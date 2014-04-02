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
Cp_Molares=Datos_struct.Cp_Molares;
R=Datos_struct.R;
tiempo_tot=Datos_struct.tiempo_tot;

if Isot
    Vr=Vr0;
    T_t0=T0;
    C_t0=C0;
    % Obtener valores iniciales de Ta y Ta0
    Ta_t0 = fsolve(@(Ta0_t0Var)...
        ...
        (1/(Cp_Molares*C_t0'))*...
        (-delta_Hr(T_t0,delta_Hf,...
        Coefs_esteq,Cp_Molares)*...
        rapideces(C_t0',T_t0,...
        Exponentes_r,k0,E,R,T0ref))+...
        U*A/(Vr*Cp_Molares*C_t0')*...
        (Ta0_t0Var-T_t0),...
        ...
        Ta0,optimset('Display','off','TolX',1e-4^2));
    Ta0_t0 = fsolve(@(Ta0_t0Var)...
        ...
        (1/(Cp_Molares*C_t0'))*...
        (-delta_Hr(T_t0,delta_Hf,...
        Coefs_esteq,Cp_Molares)*...
        rapideces(C_t0',T_t0,...
        Exponentes_r,k0,E,R,T0ref))+...
        U*A/(Vr*Cp_Molares*C_t0')*...
        (Ta_t0-Ta0_t0Var)/...
        log((Ta_t0-T_t0)/(Ta0_t0Var-T_t0)),...
        ...
        Ta_t0+1e-10,optimset('Display','off','TolX',1e-4^2));
    %Resolver IVP para sistema de EDO en Ta(t) y Ta0(t)
    %Considerar forma M*y'=f(t,y), especificar f(t,y) como
    %@(t,y), sistema diferencial - algebraico: Ej. n=3
    % M=[1,0,0,0,0;0,1,0,0,0;0,0,1,0,0;0,0,0,0,0;0,0,0,0,1]
    M               = eye(nComps+2);
    M(end-1,end-1)  = 0;
    odeOptions      = odeset('Mass',M,'OutputFcn',@odeprog,...
        'Events',@odeabort);    
    sol=ode15s(@(t,y)...
        [...
        Coefs_esteq'*rapideces(...
        y(1:end-2),T_t0,Exponentes_r,k0,E,R,T0ref);...
        ...
        (1/(Cp_Molares*y(1:end-2)))*...
        (-delta_Hr(T_t0,delta_Hf,...
        Coefs_esteq,Cp_Molares)*...
        rapideces(y(1:end-2),T_t0,...
        Exponentes_r,k0,E,R,T0ref))+...
        U*A/(Vr*Cp_Molares*y(1:end-2))*...
        (y(end)-y(end-1))/...
        log((y(end)-T_t0)/(y(end-1)-T_t0));...
        ...
        -U*A/(Va*rhoCp_a)*...
        (y(end)-y(end-1))/...
        log((y(end)-T_t0)/(y(end-1)-T_t0))+...
        Qa0/Va*(y(end-1)-y(end));...
        ]...
        ,[0,tiempo_tot],[C0,Ta0_t0,Ta_t0],odeOptions);
    t   = sol.x;
    C   = sol.y(1:end-2,:);
    Ta  = sol.y(end,:);
    Ta0 = sol.y(end-1,:);
    T   = T_t0*ones(1,size(C,2));
    Vr  = Vr0*ones(size(t));    
elseif ~Isot   
    Vr=Vr0;
    odeOptions=odeset('OutputFcn',@odeprog,...
        'Events',@odeabort);
    %Resolver IVP para sistema de EDO
    %Considerar forma M*y'=f(z,y), especificar f(z,y) como
    %@(z,y)
    sol=ode15s(@(t,y)...
        [...
        Coefs_esteq'*rapideces(y(1:end-2),...
        y(end-1),Exponentes_r,k0,E,R,T0ref);
        ...
        (1/(Cp_Molares*y(1:end-2)))*...
        (-delta_Hr(y(end-1),delta_Hf,...
        Coefs_esteq,Cp_Molares)*...
        rapideces(y(1:end-2),y(end-1),...
        Exponentes_r,k0,E,R,T0ref))+...
        U*A/(Vr*Cp_Molares*y(1:end-2))*...
        (y(end)-Ta0)/...
        log((y(end)-y(end-1))/(Ta0-y(end-1)));
        ...
        -U*A/(Va*rhoCp_a)*...
        (y(end)-Ta0)/...
        log((y(end)-y(end-1))/(Ta0-y(end-1)))+...
        Qa0/Va*(Ta0-y(end))...;
        ]...
        ,[0,tiempo_tot],[C0,T0,Ta0+1e-10],odeOptions);
    t   = sol.x;
    C   = sol.y(1:end-2,:);
    T   = sol.y(end-1,:);
    Ta  = sol.y(end,:);   
    Ta0 = Ta0*ones(size(t));
    Vr  = Vr0*ones(size(t));
end
Qa0     = Qa0*ones(size(t));
Qa      = Qa0;
[r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
rho_Cp=Cp_Molares*C;
qgen=1./(rho_Cp).*(sum(...
    (-delta_Hr(T,delta_Hf,Coefs_esteq,Cp_Molares))'.*r,1));
qrem=-U*A./(Vr.*rho_Cp).*(Ta-Ta0)/log((Ta-T)/(Ta0-T));
X=NaN*zeros(size(C));
Y=NaN*zeros(size(C));
Yconsumo=NaN*zeros(size(C));
S=NaN*zeros(size(C));
%CONVERSIÓN
for j=1:size(C,1)
    if ismember(j,reactivosSonCompsNo)
        X(j,:)=(Vr0.*C0(j)-Vr.*C(j,:))./(Vr0.*C0(j));  
    end
end
%RENDIMIENTO POR ALIMENTACIÓN
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        Y(j,:)=(Vr.*C(j,:)-Vr0.*C0(j))./...
                (Vr0.*C0(Ref_Rendimiento));   
    end
end
%RENDIMIENTO POR CONSUMO
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        Yconsumo(j,:)=Y(j,:)./X(Ref_Rendimiento,:);
    end
end
%SELECTIVIDAD
for j=1:size(C,1)
    if j~=Ref_Selectividad && ismember(j,productosSonCompsNo)
        S(j,:)=Y(j,:)./Y(Ref_Selectividad,:);
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
Datos_struct.Ta0=Ta0;
Datos_struct.r=r;
Datos_struct.k=k;
Datos_struct.qrem=qrem;
Datos_struct.qgen=qgen;
Datos_struct.q={qrem;qgen};
Datos_struct.Q=0*ones(size(Qa));
Datos_struct.Qa=Qa;
Datos_struct.Vr=Vr;
Datos_struct.V={Vr};

Datos_struct_final=Datos_struct;

end