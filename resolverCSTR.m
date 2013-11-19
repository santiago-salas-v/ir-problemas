function Datos_struct_final = resolverCSTR(Datos_struct)
%RESOLVERCSTR Resuelve los perfiles para CSTR
Isot=Datos_struct.Isot;
Estacionario=Datos_struct.Estacionario;
Incompresible=Datos_struct.Incompresible;
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
Va=Datos_struct.Va;
Vr=Datos_struct.Vr;
T0=Datos_struct.T0;
T_t0=Datos_struct.T_t0;
Q0=Datos_struct.Q0;
C0=Datos_struct.C0;
C_t0=Datos_struct.C_t0;
Ta0=Datos_struct.Ta0;
Qa0=Datos_struct.Qa0;%L/min
rhoCp_a=Datos_struct.rhoCp_a;
CpMolares=Datos_struct.CpMolares;
R=Datos_struct.R;
tiempo_tot=Datos_struct.tiempo_tot;
Tmax=Datos_struct.Tmax;
   

if Estacionario
    t=inf;
    if Isot
        T=1e-4:(Tmax-1e-4)/70:Tmax;
        T0=T;        
    elseif ~Isot
        T=1e-4:(Tmax-1e-4)/70:Tmax;           
    end
    C=NaN*zeros(nComps,size(T,2));
    Ta=NaN*zeros(1,size(T,2));
    Qa=Qa0*zeros(1,size(T,2));    
    EstimarC=C0';
    options=optimset('Display','off','TolFun',1e-10);
    BarraDeEstado=waitbar(0,' ','Name','Calculando Edos. Est.',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(BarraDeEstado,'canceling',0);
    for j=1:length(T)
        if getappdata(BarraDeEstado,'canceling')
            break
        end
        estatus=[sprintf('%u',round(j/length(T)*100)) '%'];
        waitbar(j/length(T),BarraDeEstado,estatus);
        C(:,j)=fsolve(@(y)...
            ...
            Q0/Vr*(C0'-y)+...
            Coefs_esteq'*rapideces(y,...
            T(j),Exponentes_r,k0,E,R,T0ref)...
            ...
            ,EstimarC,options);
        Ta(j)=T(j)-(T(j)-Ta0)*exp(-U*A./(Qa0*rhoCp_a));        
        if norm(Ta(j)-Ta0)==0
            Qa(j)=-Va/(Ta0-Ta(j)).*...
                -U*A./(Va*rhoCp_a).*...
                (Ta(j)-T(j));
        else
            Qa(j)=-Va/(Ta0-Ta(j)).*...
                -U*A./(Va*rhoCp_a).*...
                (Ta(j)-Ta0)/log((Ta(j)-T(j))/(Ta0-T(j)));
        end
        EstimarC=C(:,j);
    end
    delete(BarraDeEstado);
    sol.C=C;
    sol.Ta=Ta;
    sol.Qa=Qa;%L/min
    r=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
    rho_Cp=CpMolares*C;
    qgen=1./(rho_Cp).*(sum(...
        (-delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares))'.*r...
        ,1));
    qrem=-Q0/Vr*(CpMolares*C0'./(rho_Cp)).*...
        (T0-T)+...
        -(Qa0*rhoCp_a)./(Vr*rho_Cp).*(Ta0-T)*(1-exp(-U*A./(Qa0*rhoCp_a)));
    try
        T_Edos_Est=rmsearch(@(x)interp1(T,qrem-qgen,x),...
            'fzero',Tmax/2,1e-10,Tmax,'InitialSample',1*length(T));
        C_Edos_Est=interp1(T,C',T_Edos_Est)';
        Ta_Edos_Est=interp1(T,Ta,T_Edos_Est);
        r_Edos_Est=interp1(T,r',T_Edos_Est)';
        qrem_Edos_Est=interp1(T,qrem,T_Edos_Est);
        qgen_Edos_Est=interp1(T,qgen,T_Edos_Est);
    catch exception
        if strcmp(exception.message,...
                'No zero crossings found in this sample for fzero')
            T_Edos_Est=NaN;
            C_Edos_Est=NaN;
            Ta_Edos_Est=NaN;
            r_Edos_Est=NaN;
            qrem_Edos_Est=NaN;
            qgen_Edos_Est=NaN;
        end
    end       
elseif ~Estacionario
    if Isot
        T=T0;
        if Incompresible
            M=eye(nComps+1);%cm/min
            odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                'Events',@odeabort);
            %Resolver IVP para sistema de EDO
            %Considerar forma M*y'=f(z,y), especificar f(z,y) como
            %@(z,y)
            sol=ode15s(@(t,y)...
                ...
                [...
                Q0/Vr*(C0'-y(1:end-1))+...
                Coefs_esteq'*rapideces(y(1:end-1),...
                T0,Exponentes_r,k0,E,R,T0ref);...  
                ...
                Qa0/Va*(Ta0-y(end))+...
                -U*A./(Va*rhoCp_a).*...
                (y(end)-Ta0)/log((y(end)-T0)/(Ta0-T0));...
                ]...
                ...
                ,[0,tiempo_tot],[C0,Ta0+1e-10],odeOptions);
            t=sol.x;
            C=sol.y(1:end-1,:);
            T=T0*ones(size(t));
            Ta=sol.y(end,:);
        elseif ~Incompresible
        end
    elseif ~Isot
        if Incompresible
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
                Q0/Vr*(C0'-y(1:end-2))+...
                Coefs_esteq'*rapideces(y(1:end-2),...
                y(end-1),Exponentes_r,k0,E,R,T0ref);...
                ...
                Q0/Vr*(CpMolares*C0'./(CpMolares*y(1:end-2))).*...
                (T0-y(end-1))+...
                (1./(CpMolares*y(1:end-2))).*...
                (-delta_Hr(y(end-1),delta_Hf,Coefs_esteq,CpMolares)*...
                rapideces(y(1:end-2),...
                y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                +U*A./(Vr*CpMolares*y(1:end-2)).*...
                (y(end)-Ta0)/log((y(end)-y(end-1))/(Ta0-y(end-1)));...
                ...
                Qa0/Va*(Ta0-y(end))+...
                -U*A./(Va*rhoCp_a).*...
                (y(end)-Ta0)/log((y(end)-y(end-1))/(Ta0-y(end-1)));...                
                ]...
                ...
                ,[0,tiempo_tot],...
                [C_t0,T_t0,Ta0+1e-10],odeOptions);
            t=sol.x;
            C=sol.y(1:end-2,:);
            T=sol.y(end-1,:);
            Ta=sol.y(end,:);
        elseif ~Incompresible
        end
    end
    r=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
    rho_Cp=CpMolares*C;
    qgen=1./(rho_Cp).*(sum(...
        (-delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares))'.*r...
        ,1));
    qrem=-Q0/Vr*(CpMolares*C0'./(CpMolares*C)).*...
        (T0-T)+...
        -(Qa0*rhoCp_a)./(Vr*rho_Cp).*(Ta0-T)*(1-exp(-U*A./(Qa0*rhoCp_a)));
    Qa=Qa0*ones(size(T));
    T_Edos_Est=Datos_struct.T_Edos_Est;
    C_Edos_Est=Datos_struct.C_Edos_Est;
    Ta_Edos_Est=Datos_struct.Ta_Edos_Est;
    r_Edos_Est=Datos_struct.r_Edos_Est;
    qrem_Edos_Est=Datos_struct.qrem_Edos_Est;
    qgen_Edos_Est=Datos_struct.qgen_Edos_Est;
end
if norm(Ta-Ta0)==0
    qiproceso=+U*A./(Vr*rho_Cp).*(Ta-T);
    qiservicio=-U*A./(Va*rhoCp_a).*(Ta-T);
else
    qiproceso=+U*A./(Vr*rho_Cp).*...
        (Ta-Ta0)./log((Ta-T)./(Ta0-T));
    qiservicio=-U*A./(Va*rhoCp_a).*...
        (Ta-Ta0)./log((Ta-T)./(Ta0-T));
end
Q=Q0*ones(size(T));

X=NaN*zeros(size(C));
Y=NaN*zeros(size(C));
S=NaN*zeros(size(C));
Yconsumo=NaN*zeros(size(C));
%CONVERSIÓN
for j=1:size(C,1)
    if ismember(j,reactivosSonCompsNo)
        if length(size(C))<3
            X(j,:)=(Q0.*C0(j)-Q.*C(j,:))./(Q0.*C0(j));
        else
            X(j,:,:)=(Q0.*C0(j)-Q.*squeeze(C(j,:,:)))./(Q0.*C0(j));
        end
    end
end
%RENDIMIENTO POR ALIMENTACIÓN
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        if length(size(C))<3
            Y(j,:)=Q.*C(j,:)./...
                (Q0.*C0(Ref_Rendimiento));
        else
            Y(j,:,:)=Q.*C(j,:,:)./...
                (Q0.*C0(Ref_Rendimiento));
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
            S(j,:)=Q.*C(j,:)./(Q.*C(Ref_Selectividad,:));
        else
            S(j,:,:)=Q.*C(j,:,:)./(Q.*C(Ref_Selectividad,:,:));
        end
    end
end

warning('off','all');
if Estacionario
    qiproceso_Edos_Est=interp1(T,qiproceso,T_Edos_Est);
    qiservicio_Edos_Est=interp1(T,qiservicio,T_Edos_Est);
    Q_Edos_Est=interp1(T,Q,T_Edos_Est);
    Qa_Edos_Est=interp1(T,Qa,T_Edos_Est);
    X_Edos_Est=interp1(T,X',T_Edos_Est)';
    Y_Edos_Est=interp1(T,Y',T_Edos_Est)';
    Yconsumo_Edos_Est=interp1(T,Yconsumo',T_Edos_Est)';
    S_Edos_Est=interp1(T,S',T_Edos_Est)';
elseif ~Estacionario
    qiproceso_Edos_Est=Datos_struct.qiproceso_Edos_Est;
    qiservicio_Edos_Est=Datos_struct.qiservicio_Edos_Est;
    Q_Edos_Est=Datos_struct.Q_Edos_Est;
    Qa_Edos_Est=Datos_struct.Qa_Edos_Est;
    X_Edos_Est=Datos_struct.X_Edos_Est;
    Y_Edos_Est=Datos_struct.Y_Edos_Est;
    Yconsumo_Edos_Est=Datos_struct.Yconsumo_Edos_Est;
    S_Edos_Est=Datos_struct.S_Edos_Est;
end
warning('on','all');

Datos_struct.sol=sol;
Datos_struct.t=t;
Datos_struct.C=C;
Datos_struct.X=X;
Datos_struct.Y=Y;
Datos_struct.Yconsumo=Yconsumo;
Datos_struct.S=S;
Datos_struct.T=T;
Datos_struct.Ta=Ta;
Datos_struct.T_Edos_Est=T_Edos_Est;
Datos_struct.r=r;
Datos_struct.qiproceso=qiproceso;
Datos_struct.qiservicio=qiservicio;
Datos_struct.qgen=qgen;
Datos_struct.qrem=qrem;
Datos_struct.q={qiproceso;qiservicio;qrem;qgen};
Datos_struct.Qa=Qa;
Datos_struct.Q=Q;

Datos_struct.C_Edos_Est=C_Edos_Est;
Datos_struct.X_Edos_Est=X_Edos_Est;
Datos_struct.Y_Edos_Est=Y_Edos_Est;
Datos_struct.Yconsumo_Edos_Est=Yconsumo_Edos_Est;
Datos_struct.S_Edos_Est=S_Edos_Est;
Datos_struct.T_Edos_Est=T_Edos_Est;
Datos_struct.Ta_Edos_Est=Ta_Edos_Est;
Datos_struct.r_Edos_Est=r_Edos_Est;
Datos_struct.qiproceso_Edos_Est=qiproceso_Edos_Est;
Datos_struct.qiservicio_Edos_Est=qiservicio_Edos_Est;
Datos_struct.qgen_Edos_Est=qgen_Edos_Est;
Datos_struct.qrem_Edos_Est=qrem_Edos_Est;
Datos_struct.q_Edos_Est=...
    {qiproceso_Edos_Est;qiservicio_Edos_Est;...
    qrem_Edos_Est;qgen_Edos_Est};
Datos_struct.Qa_Edos_Est=Qa_Edos_Est;
Datos_struct.Q_Edos_Est=Q_Edos_Est;

Datos_struct_final=Datos_struct;

end