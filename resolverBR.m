function Datos_struct_final = resolverBR(Datos_struct)    
%RESOLVERBR Resuelve los perfiles para BR
Isot=Datos_struct.Isot;
Coefs_esteq=Datos_struct.Coefs_esteq;
nComps=Datos_struct.nComps;
reactivosSonCompsNo=Datos_struct.reactivosSonCompsNo;
productosSonCompsNo=Datos_struct.productosSonCompsNo;
Ref_Selectividad=Datos_struct.Ref_Selectividad;
Ref_Rendimiento=Datos_struct.Ref_Rendimiento;
delta_Hf=Datos_struct.delta_Hf;
E=Datos_struct.E;
k0=Datos_struct.k0;
Exponentes_r=Datos_struct.Exponentes_r;
T0ref=Datos_struct.T0ref;
U=Datos_struct.U;
A=Datos_struct.A;
Vr0=Datos_struct.Vr;
Va=Datos_struct.Va;
T0=Datos_struct.T0;
C0=Datos_struct.C0;
Ta0=Datos_struct.Ta0;
Qa0=Datos_struct.Qa0;%L/min
rhoCp_a=Datos_struct.rhoCp_a;
CpMolares=Datos_struct.CpMolares;
R=Datos_struct.R;
tiempo_tot=Datos_struct.tiempo_tot;

if Isot
    Vr=Vr0;
    T=T0;
    M=eye(nComps);%cm/min
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
        'Events',@odeabort);
    %Resolver IVP para sistema de EDO
    %Considerar forma M*y'=f(z,y), especificar f(z,y) como
    %@(z,y)
    sol=ode15s(@(t,y)... 
        ...
        Coefs_esteq'*rapideces(...
        y(1:end),T,Exponentes_r,k0,E,R,T0ref)...
        ...       
        ,[0,tiempo_tot],C0',odeOptions);
    t=sol.x;
    C=sol.y(1:end,:);
    T=T0*ones(1,size(C,2));     
    Ta=Ta0*ones(size(T));
    for j=2:length(T)
        Ta(j)=fsolve(@(TaVar)...
            ...
            (1./(CpMolares*C(:,j))).*...
            (-delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares)*...
            rapideces(C(:,j),...
            T0,Exponentes_r,k0,E,R,T0ref))+...
            U*A./(Vr*CpMolares*C(:,j)).*(TaVar-Ta0)/...
            log((TaVar-T0)/(Ta0-T0)),...
            ...
            Ta(j-1)+1e-10,optimset('Display','off'));
    end
    Vr=Vr0*ones(size(t));
    Ta_t=interp1((t(1:end-1)+t(2:end))/2,diff(Ta)./diff(t),t);
    Qa=Ta_t*Va./(Ta0-Ta)-U*A/(rhoCp_a)./log((Ta-T0)./(Ta0-T0));
elseif ~Isot   
    Vr=Vr0;
    M=eye(nComps+2);%cm/min
    M(1:end-1,1:end-1)=M(1:end-1,1:end-1);
    M(end,end)=M(end,end);
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
        'Events',@odeabort);
    %Resolver IVP para sistema de EDO
    %Considerar forma M*y'=f(z,y), especificar f(z,y) como
    %@(z,y)
    sol=ode15s(@(t,y)...
        ...
        [...
        Coefs_esteq'*rapideces(y(1:end-2),...
        y(end-1),Exponentes_r,k0,E,R,T0ref);
        ...
        (1./(CpMolares*y(1:end-2))).*...
        (-delta_Hr(y(end-1),delta_Hf,Coefs_esteq,CpMolares)*...
        rapideces(y(1:end-2),...
        y(end-1),Exponentes_r,k0,E,R,T0ref))+...
        U*A./(Vr*CpMolares*y(1:end-2)).*(y(end)-Ta0)/...
        log((y(end)-y(end-1))/(Ta0-y(end-1)));
        ...
        -U*A./(Va*rhoCp_a).*...
        (y(end)-Ta0)/log((y(end)-y(end-1))/(Ta0-y(end-1)))+...
        Qa0/Va*(Ta0-y(end))...;
        ]...
        ...
        ,[0,tiempo_tot],[C0,T0,Ta0+1e-10],odeOptions);
    t=sol.x;
    C=sol.y(1:end-2,:);
    T=sol.y(end-1,:);
    Ta=sol.y(end,:);   
    Vr=Vr0*ones(size(t));
    Qa=Qa0*ones(size(T));
end
r=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
rho_Cp=CpMolares*C;
qiproceso=U*A./(rho_Cp).*(Ta-T);
qiservicio=-U*A./(rhoCp_a).*(Ta-T);

X=NaN*zeros(size(C));
Y=NaN*zeros(size(C));
Yconsumo=NaN*zeros(size(C));
S=NaN*zeros(size(C));
%CONVERSIÓN
for j=1:size(C,1)
    if ismember(j,reactivosSonCompsNo)
        if length(size(C))<3
            X(j,:)=(Vr0.*C0(j)-Vr.*C(j,:))./(Vr0.*C0(j));
        else
            X(j,:,:)=(Vr0.*C0(j)-Vr.*squeeze(C(j,:,:)))./(Vr0.*C0(j));
        end
    end
end
%RENDIMIENTO POR ALIMENTACIÓN
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        if length(size(C))<3
            Y(j,:)=Vr.*C(j,:)./...
                (Vr0.*C0(Ref_Rendimiento));
        else
            Y(j,:,:)=Q.*C(j,:,:)./...
                (Vr0.*C0(Ref_Rendimiento));
        end
    end
end
%RENDIMIENTO POR CONSUMO
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        if length(size(C))<3
            Yconsumo(j,:)=Y(j,:)./X(Ref_Rendimiento,:);
        else
            Yconsumo(j,:,:)=Y(j,:,:)./...
                (X(Ref_Rendimiento,:,:));
        end
    end
end
%SELECTIVIDAD
for j=1:size(C,1)
    if j~=Ref_Selectividad && ismember(j,productosSonCompsNo)
        if length(size(C))<3
            S(j,:)=Vr.*C(j,:)./(Vr.*C(Ref_Selectividad,:));
        else
            S(j,:,:)=Vr.*C(j,:,:)./(Vr.*C(Ref_Selectividad,:,:));
        end
    end
end
Datos_struct.sol=sol;
Datos_struct.t=t;
Datos_struct.C=C;
Datos_struct.X=X;
Datos_struct.Y=Y;
Datos_struct.Yconsumo=Yconsumo;
Datos_struct.S=S;
Datos_struct.T=T;
Datos_struct.Ta=Ta;
Datos_struct.r=r;
Datos_struct.qiproceso=qiproceso;
Datos_struct.qiservicio=qiservicio;
Datos_struct.q={qiproceso;qiservicio};
Datos_struct.Q=0*ones(size(Qa));
Datos_struct.Qa=Qa;
Datos_struct.Vr=Vr;
Datos_struct.V={Vr};

Datos_struct_final=Datos_struct;

end