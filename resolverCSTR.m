function Datos_struct_final = resolverCSTR(Datos_struct)
%RESOLVERCSTR Resuelve los perfiles para CSTR
Isot=Datos_struct.Isot;
Estacionario=Datos_struct.Estacionario;
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
Ta0=Datos_struct.Ta0(1);
Qa0=Datos_struct.Qa0;%L/min
rhoCp_a=Datos_struct.rhoCp_a;
Cp_Molares=Datos_struct.Cp_Molares;
R=Datos_struct.R;
tiempo_tot=Datos_struct.tiempo_tot;
Tmax=Datos_struct.Tmax;
   

if Estacionario
    t=inf;
    T=1e-4:(Tmax-1e-4)/70:Tmax;
    if Isot
        T=T_t0*ones(size(T));
    elseif ~Isot
        T=1e-4:(Tmax-1e-4)/70:Tmax;           
    end
    C=NaN*zeros(nComps,size(T,2));
    Ta=NaN*zeros(1,size(T,2));
    Qa=Qa0*zeros(1,size(T,2));
    Ta0=Ta0*ones(1,size(T,2));
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
            Coefs_esteq'*rapideces(y,...
            T(j),Exponentes_r,k0,E,R,T0ref)+...
            Q0/Vr*(C0'-y)...
            ...
            ,EstimarC,options);
        Ta(j)=T(j)-(T(j)-Ta0(j))*exp(-U*A./(Qa0*rhoCp_a));
        EstimarC=C(:,j);
    end
    delete(BarraDeEstado);
    sol.C   = C;
    sol.Ta  = Ta;
    sol.Qa  = Qa;%L/min
    [r,k]   = rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
    rho_Cp  = Cp_Molares*C;
    qgen    = 1./(rho_Cp).*(sum(...
        (-delta_Hr(T,delta_Hf,...
        Coefs_esteq,Cp_Molares))'.*r,1));
    qrem=-Q0/Vr*(Cp_Molares*C0'./(rho_Cp)).*...
        (T0-T)+...
        -(Qa0*rhoCp_a)./(Vr*rho_Cp).*(Ta0-T)*...
        (1-exp(-U*A./(Qa0*rhoCp_a)));
    try
        % crossing.m
        % http://www.mathworks.com/matlabcentral/fileexchange/2432-crossing
        [~,T_Edos_Est]=crossing(qrem-qgen,T);
        C_Edos_Est=interp1(T,C',T_Edos_Est)';
        Ta_Edos_Est=interp1(T,Ta,T_Edos_Est);
        Ta0_Edos_Est=interp1(T,Ta0,T_Edos_Est);
        r_Edos_Est=interp1(T,r',T_Edos_Est)';
        k_Edos_Est=interp1(T,k',T_Edos_Est)';
        qrem_Edos_Est=interp1(T,qrem,T_Edos_Est);
        qgen_Edos_Est=interp1(T,qgen,T_Edos_Est);
    catch exception
        if strcmp(exception.message,...
                'No zero crossings found in this sample for fzero') ||...
                strcmp(exception.message,...
                'The values of X should be distinct.')
            T_Edos_Est=[];
            C_Edos_Est=[];
            Ta_Edos_Est=[];
            Ta0_Edos_Est=[];
            r_Edos_Est=[];
            k_Edos_Est=[];
            qrem_Edos_Est=[];
            qgen_Edos_Est=[];        
            X_Edos_Est=[];
            Y_Edos_Est=[];
            Yconsumo_Edos_Est=[];
            S_Edos_Est=[];
            Qa_Edos_Est=[];
            Q_Edos_Est=[];
        end
    end       
elseif ~Estacionario
    t=[0,tiempo_tot];
    if Isot
        % Vr = Vr0;
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
            log((Ta_t0-T_t0)/(Ta0_t0Var-T_t0))+...
            Q0/Vr*...
            (Cp_Molares*C0'/(Cp_Molares*C_t0'))*...
            (T0-T_t0),...
            ...
            Ta_t0+1e-10,optimset('Display','off','TolX',1e-4^2));
        %Resolver IVP para sistema de EDO en Ta(t) y Ta0(t)
        %Considerar forma M*y'=f(t,y), especificar f(t,y) como
        %@(t,y), sistema diferencial - algebraico: Ej. n=3
        % M=[1,0,0,0,0;0,1,0,0,0;0,0,1,0,0;0,0,0,0,0;0,0,0,0,1]
        M               =eye(nComps+2);
        M(end-1,end-1)  =0;
        odeOptions  =odeset('Mass',M,'OutputFcn',@odeprog,...
            'Events',@odeabort);
        sol=ode15s(@(t,y)...
            [...
            Coefs_esteq'*rapideces(...
            y(1:end-2),T_t0,Exponentes_r,k0,E,R,T0ref)+...
            Q0/Vr*(C0'-y(1:end-2));...
            ...
            (1/(Cp_Molares*y(1:end-2)))*...
            (-delta_Hr(T_t0,delta_Hf,...
            Coefs_esteq,Cp_Molares)*...
            rapideces(y(1:end-2),T_t0,...
            Exponentes_r,k0,E,R,T0ref))+...
            U*A/(Vr*Cp_Molares*y(1:end-2))*...
            (y(end)-y(end-1))/...
            log((y(end)-T_t0)/(y(end-1)-T_t0))+...
            Q0/Vr*...
            (Cp_Molares*C0'/(Cp_Molares*y(1:end-2)))*...
            (T0-T_t0);...
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
        T   = T_t0*ones(size(t));        
    elseif ~Isot       
        %Vr = Vr0
        odeOptions=odeset('OutputFcn',@odeprog,...
            'Events',@odeabort);
        %Resolver IVP para sistema de EDO
        %Considerar forma y'=f(t,y), especificar f(t,y) como
        %@(t,y)
        sol=ode15s(@(t,y)...
            [...            
            Coefs_esteq'*rapideces(y(1:end-2),...
            y(end-1),Exponentes_r,k0,E,R,T0ref)+...
            Q0/Vr*(C0'-y(1:end-2));...
            ...
            (1/(Cp_Molares*y(1:end-2)))*...
            (-delta_Hr(y(end-1),delta_Hf,...
            Coefs_esteq,Cp_Molares)*...
            rapideces(y(1:end-2),y(end-1),...
            Exponentes_r,k0,E,R,T0ref))+...
            U*A/(Vr*Cp_Molares*y(1:end-2))*...
            (y(end)-Ta0)/...
            log((y(end)-y(end-1))/(Ta0-y(end-1)))+...            
            Q0/Vr*(Cp_Molares*C0'/...
            (Cp_Molares*y(1:end-2)))*...
            (T0-y(end-1));...
            ...
            -U*A/(Va*rhoCp_a)*...
            (y(end)-Ta0)/...
            log((y(end)-y(end-1))/(Ta0-y(end-1)))+...            
            Qa0/Va*(Ta0-y(end));...
            ]...
            ,[0,tiempo_tot],[C_t0,T_t0,Ta0+1e-10],odeOptions);
        t   = sol.x;
        C   = sol.y(1:end-2,:);
        T   = sol.y(end-1,:);
        Ta  = sol.y(end,:);
        Ta0 = Ta0*ones(size(t));
    end
    Qa0     = Qa0*ones(size(t));
    Qa      = Qa0;
    [r,k]   = rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
    rho_Cp  = Cp_Molares*C;
    qgen    = 1./(rho_Cp).*(sum(...
        (-delta_Hr(T,delta_Hf,Coefs_esteq,...
        Cp_Molares))'.*r,1));
    qrem    = ...
        -Q0/Vr*(Cp_Molares*C0'./(rho_Cp)).*...
        (T0-T)+...
        -U*A./(Vr.*rho_Cp).*...
        (Ta-Ta0)/log((Ta-T)/(Ta0-T));
    T_Edos_Est  = Datos_struct.T_Edos_Est;
    C_Edos_Est  = Datos_struct.C_Edos_Est;
    Ta_Edos_Est = Datos_struct.Ta_Edos_Est;
    Ta0_Edos_Est = Datos_struct.Ta0_Edos_Est;
    r_Edos_Est  = Datos_struct.r_Edos_Est;
    k_Edos_Est  = Datos_struct.k_Edos_Est;
    qrem_Edos_Est   = Datos_struct.qrem_Edos_Est;
    qgen_Edos_Est   = Datos_struct.qgen_Edos_Est;
end

Q=Q0*ones(size(T));

X=NaN*zeros(size(C));
Y=NaN*zeros(size(C));
S=NaN*zeros(size(C));
Yconsumo=NaN*zeros(size(C));
%CONVERSIÓN
for j=1:size(C,1)
    if ismember(j,reactivosSonCompsNo)
        X(j,:)=...
                (Q0*C0(j)-Q0*C(j,:))./...
                (Q0*C0(j));
    end
end
%RENDIMIENTO POR ALIMENTACIÓN
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        Y(j,:)=...
                (Q0*C(j,:)-Q0*C0(j))./...
                (Q0*C0(Ref_Rendimiento));     
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

warning('off','all');
if Estacionario && ~Isot  
    Q_Edos_Est=interp1(T,Q,T_Edos_Est);
    Qa_Edos_Est=interp1(T,Qa,T_Edos_Est);
    X_Edos_Est=interp1(T,X',T_Edos_Est)';
    Y_Edos_Est=interp1(T,Y',T_Edos_Est)';
    Yconsumo_Edos_Est=interp1(T,Yconsumo',T_Edos_Est)';
    S_Edos_Est=interp1(T,S',T_Edos_Est)';
elseif ~Estacionario
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
Datos_struct.Ta0=Ta0;
Datos_struct.T_Edos_Est=T_Edos_Est;
Datos_struct.r=r;
Datos_struct.k=k;
Datos_struct.qgen=qgen;
Datos_struct.qrem=qrem;
Datos_struct.q={qrem;qgen};
Datos_struct.Qa=Qa;
Datos_struct.Q=Q;

Datos_struct.C_Edos_Est=C_Edos_Est;
Datos_struct.X_Edos_Est=X_Edos_Est;
Datos_struct.Y_Edos_Est=Y_Edos_Est;
Datos_struct.Yconsumo_Edos_Est=Yconsumo_Edos_Est;
Datos_struct.S_Edos_Est=S_Edos_Est;
Datos_struct.T_Edos_Est=T_Edos_Est;
Datos_struct.Ta_Edos_Est=Ta_Edos_Est;
Datos_struct.Ta0_Edos_Est=Ta0_Edos_Est;
Datos_struct.r_Edos_Est=r_Edos_Est;
Datos_struct.k_Edos_Est=k_Edos_Est;
Datos_struct.qgen_Edos_Est=qgen_Edos_Est;
Datos_struct.qrem_Edos_Est=qrem_Edos_Est;
Datos_struct.q_Edos_Est=...
    {qrem_Edos_Est;qgen_Edos_Est};
Datos_struct.Qa_Edos_Est=Qa_Edos_Est;
Datos_struct.Q_Edos_Est=Q_Edos_Est;

Datos_struct_final=Datos_struct;

end