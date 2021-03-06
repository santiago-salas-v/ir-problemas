function Datos_struct_final = resolverPFR(Datos_struct)
%RESOLVERPFR Resuelve los perfiles para PFR
Estacionario=Datos_struct.Estacionario;
Isot=Datos_struct.Isot;
Incompresible=Datos_struct.Incompresible;
factorCoContraCorriente=Datos_struct.factorCoContraCorriente;
Coefs_esteq=Datos_struct.Coefs_esteq;
nComps=Datos_struct.nComps;
nReacs=Datos_struct.nReacs;
reactivosSonCompsNo=Datos_struct.reactivosSonCompsNo;
productosSonCompsNo=Datos_struct.productosSonCompsNo;
Ref_Selectividad=Datos_struct.Ref_Selectividad;
Ref_Rendimiento=Datos_struct.Ref_Rendimiento;
E=Datos_struct.E;
k0=Datos_struct.k0;
Exponentes_r=Datos_struct.Exponentes_r;
T0ref=Datos_struct.T0ref;
delta_Hf = Datos_struct.delta_Hf;
Diam=Datos_struct.Diam;
U=Datos_struct.U;
a=Datos_struct.a;
Longitud=Datos_struct.Longitud;
Q0=Datos_struct.Q0*1000;%L/min ==>> cm^3/min
T0=Datos_struct.T0;
C0=Datos_struct.C0;
Ta0=Datos_struct.Ta0;
Diam_a=Datos_struct.Diam_a;
Qa0=Datos_struct.Qa0*1000;%L/min ==>> cm^3/min
rhoCp_a=Datos_struct.rhoCp_a;
Cp_Molares=Datos_struct.Cp_Molares;
R=Datos_struct.R;
tiempo_tot=Datos_struct.tiempo_tot;
timestep_factor=Datos_struct.timestep_factor;
Az=pi/4*(Diam)^2;%cm^2
Aza=pi/4*(Diam_a^2-Diam^2);%cm^2
F0=C0*Q0/1000;%mol/min
stop_sign_icon =imread(fullfile(...
    ['.',filesep,'utils',filesep,'Stop_sign.png']));
stop_sign_icon(stop_sign_icon==0)=255;

    function [c,f,s] = ...
            EDPNoEstacionarioNoIsotermicoCoCorriente(z,t,u,DuDz,varargin)
        %  c(x,t,u,Du/Dx) * Du/Dt = x^(-m) * D(x^m * f(x,t,u,Du/Dx))/Dx + s(x,t,u,Du/Dx)
        %  f(x,t,u,Du/Dx) is a flux and s(x,t,u,Du/Dx) is a source term. m must
        %  be 0, 1, or 2, corresponding to slab, cylindrical, or spherical symmetry,
        %  respectively.
        c = eye(size(u,1));
        f = zeros(size(DuDz)) .* DuDz;
        s = ...
            [...
            ...
            -Q0/Az*DuDz(1:end-2,:)+...
            Coefs_esteq'*rapideces(u(1:end-2,:),...
            u(end-1,:),Exponentes_r,k0,E,R,T0ref);
            ...
            -Q0/Az*DuDz(end-1,:)+...
            (1./(Cp_Molares*u(1:end-2,:))).*sum(...
            (-delta_Hr(u(end-1,:),delta_Hf,...
            Coefs_esteq,Cp_Molares)'.*rapideces(u(1:end-2,:),...
            u(end-1,:),Exponentes_r,k0,E,R,T0ref))...
            ,1)+...
            U*a./(Cp_Molares*u(1:end-2,:)).*(u(end,:)-u(end-1,:));
            ...
            -Qa0/Aza*DuDz(end,:)*factorCoContraCorriente+...
            -U*a./(rhoCp_a).*(u(end,:)-u(end-1,:))...
            ...
            ];
    end

    function [pl,ql,pr,qr] = ...
            CFNoEstacionarioNoIsotermicoCoCorriente(zl,ul,zr,ur,t,varargin)
        % p(x,t,u) + q(x,t) * f(x,t,u,Du/Dx) = 0
        % In diesem Falle:
        % f = [0;0] .* DuDx;
        % Links,  [0;u_2]   + [1;0] .* [0;0] .* DuDx = 0
        % Rechts, [u_1-1;0] + [0;1] .* [0;0] .* DuDx = 0
        pl = zeros(size(ul));
        ql = eye(size(ul,1));
        pr = zeros(size(ul));
        qr = eye(size(ul,1));
        if factorCoContraCorriente ==+1
            %yL=y0(:,1);
            pl = ul-y0(:,1);
        elseif factorCoContraCorriente ==-1
            %yL(1:end-1)=y0(1:end-1,1);
            %yR(end)=y0(end,1);
            pl(1:end-1,1) = ul(1:end-1,1)-y0(1:end-1,1);
            pr(end,1) = ur(end,1)-y0(end,1);
        end
    end

    function u0 = ...
            CINoEstacionarioNoIsotermicoCoCorriente(z,varargin);
        u0 = y0(:,1);
    end

if Estacionario
    t=inf;
    if Isot
        % Isot�rmico estacionario: La temperatura T(z) es igual que la
        % temperatura inicial y en z=0. Delta Hr y k ya est�n fijos en todo
        % el reactor.
        T=T0;
        DHr=delta_Hr(T,delta_Hf,Coefs_esteq,Cp_Molares);
        if factorCoContraCorriente==+1
            %+1 Co-Corriente
            if Incompresible
                M=Q0/Az*eye(nComps);%cm/min
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                %Resolver IVP para sistema de EDO
                %Considerar forma M*y'=f(z,y), especificar f(z,y) como
                %@(z,y)
                sol=ode15s(@(z,y)...
                    ...
                    Coefs_esteq'*rapideces(...
                    y,T,Exponentes_r,k0,E,R,T0ref)...
                    ...
                    ,[0,Longitud],C0,odeOptions);
                z=sol.x;
                C=sol.y;
                T=T0*ones(1,size(C,2));
                dT_en_dz = 0*ones(1,size(C,2));
                F=C*Q0/1000;%mol/min
                Q=Q0/1000*ones(size(z));%L/min
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
            elseif ~Incompresible
                M=1/Az*1000*eye(nComps);%1/cm^2*cm^3/L
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                %Resolver IVP para sistema de EDO
                %Considerar forma M*y'=f(z,y), especificar f(z,y) como
                %@(z,y)
                sol=ode15s(@(z,y)...
                    ...
                    Coefs_esteq'*rapideces(...
                    sum(C0)*y/sum(y),T,Exponentes_r,k0,E,R,T0ref)...
                    ...
                    ,[0,Longitud],F0,odeOptions);
                z=sol.x;
                F=sol.y;
                T=T0*ones(1,size(F,2));
                dT_en_dz = 0*ones(1,size(F,2));
                C=zeros(size(F));
                for j=1:nComps
                    C(j,:)=sum(C0)*F(j,:)./sum(F,1);
                end
                Q=sum(F,1)./sum(C,1);%L/min
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
            end
        elseif factorCoContraCorriente==-1
            %-1 Contra-Corriente
            if Incompresible
                M=Q0/Az*eye(nComps);%cm/min
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                %Resolver IVP para sistema de EDO
                %Considerar forma M*y'=f(z,y), especificar f(z,y) como
                %@(z,y)
                sol=ode15s(@(z,y)...
                    ...
                    Coefs_esteq'*rapideces(...
                    y(1:length(y)),T,Exponentes_r,k0,E,R,T0ref)...
                    ...
                    ,[0,Longitud],C0,odeOptions);
                z=sol.x;
                C=sol.y;
                T=T0*ones(1,size(C,2));
                dT_en_dz = 0*ones(1,size(C,2));
                F=C*Q0/1000;%mol/min
                Q=Q0/1000*ones(size(z));%L/min
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
            elseif ~Incompresible
                M=1/Az*1000*eye(nComps);%1/cm^2*cm^3/L
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                %Resolver IVP para sistema de EDO
                %Considerar forma M*y'=f(z,y), especificar f(z,y) como
                %@(z,y)
                sol=ode15s(@(z,y)...
                    ...
                    Coefs_esteq'*rapideces(...
                    sum(C0)*y/sum(y),T,Exponentes_r,k0,E,R,T0ref)...
                    ...
                    ,[0,Longitud],F0,odeOptions);
                z=sol.x;
                F=sol.y;
                T=T0*ones(1,size(F,2));
                dT_en_dz = 0*ones(1,size(F,2));
                C=zeros(size(F));
                for j=1:nComps
                    C(j,:)=sum(C0)*F(j,:)./sum(F,1);
                end
                Q=sum(F,1)./sum(C,1);
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
            end
        end
        % Ta ya est� fija por el balance de materia y energ�a
        % �nicamente en el fluido de proceso. Calcular Ta.
        rho_Cp=Cp_Molares*C;
        Ta=-1/(U*a)*(-DHr*r)+T;
        qgen=1./(rho_Cp).*(sum(...
            (-delta_Hr(T,delta_Hf,Coefs_esteq,Cp_Molares))'.*r,1));
        qrem=+(Q*1000)./Az.*dT_en_dz+...
            -U*a./(rho_Cp).*(Ta-T);
        qrem_z= -U*a./(rho_Cp).*(Ta-T).*Az./(Q*1000);
        qgen_z= +qgen.*Az./(Q*1000);
        Ta_z=interp1((z(1:end-1)+z(2:end))/2,diff(Ta)./diff(z),z);
        Qa=1/factorCoContraCorriente*...
            -U*a./(rhoCp_a).*(Ta-T0).*(1./Ta_z)*Aza;
        Qa=1/1000*Qa;%L/min
    elseif ~Isot
        if factorCoContraCorriente==+1
            %+1 Co-Corriente
            if Incompresible
                M=eye(nComps+2);%cm/min
                M(1:end-1,1:end-1)=Q0/Az*M(1:end-1,1:end-1);
                M(end,end)=Qa0/(Aza)*M(end,end)*...
                    factorCoContraCorriente;
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                %Resolver IVP para sistema de EDO
                %Considerar forma M*y'=f(z,y), especificar f(z,y) como
                %@(z,y)
                sol=ode15s(@(z,y)...
                    ...
                    [...
                    Coefs_esteq'*rapideces(y(1:end-2),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref);
                    ...
                    (1./(Cp_Molares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,Cp_Molares)*...
                    rapideces(y(1:end-2),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(Cp_Molares*y(1:end-2)).*(y(end)-y(end-1));
                    ...
                    -U*a./(rhoCp_a).*(y(end)-y(end-1))...
                    ]...
                    ...
                    ,[0,Longitud],[C0,T0,Ta0],odeOptions);
                z=sol.x;
                C=sol.y(1:end-2,:);
                T=sol.y(end-1,:);
                Ta=sol.y(end,:);
                F=C*Q0/1000;%mol/min
                Q=Q0/1000*ones(size(z));%L/min
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
                [~,dy_en_dz] = deval(sol,z);
                dT_en_dz = dy_en_dz(end-1,:);
            elseif ~Incompresible
                M=eye(nComps+2);
                M(1:end-1,1:end-1)=...
                    1/Az*1000*M(1:end-1,1:end-1);%1/cm^2*cm^3/L
                M(end,end)=Qa0/Aza*M(end,end)*...
                    factorCoContraCorriente;%cm^3/min*1/cm^2
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                %Resolver IVP para sistema de EDO
                %Considerar forma M*y'=f(z,y), especificar f(z,y) como
                %@(z,y)
                sol=ode15s(@(z,y)...
                    ...
                    [...
                    Coefs_esteq'*rapideces(...
                    sum(C0)*y(1:end-2)/sum(y(1:end-2))*T0/y(end-1),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref);
                    ...
                    (1./(Cp_Molares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,Cp_Molares)*...
                    rapideces(...
                    sum(C0)*y(1:end-2)/sum(y(1:end-2))*T0/y(end-1),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(Cp_Molares*y(1:end-2)).*(y(end)-y(end-1));
                    ...
                    -U*a./(rhoCp_a).*(y(end)-y(end-1))...
                    ]...
                    ...
                    ,[0,Longitud],[F0,T0,Ta0],odeOptions);
                z=sol.x;
                F=sol.y(1:end-2,:);
                T=sol.y(end-1,:);
                Ta=sol.y(end,:);
                C=zeros(size(F));
                for j=1:nComps
                    C(j,:)=sum(C0)*F(j,:)./sum(F,1).*T0./T;
                end
                Q=sum(F,1)./sum(C,1);
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
                [~,dy_en_dz] = deval(sol,z);
                dT_en_dz = dy_en_dz(end-1,:);
            end
        elseif factorCoContraCorriente==-1
            %-1 Contra-Corriente
            if Incompresible
                M=eye(nComps+2);%cm/min
                M(1:end-1,1:end-1)=Q0/Az*M(1:end-1,1:end-1);
                M(end,end)=Qa0/(Aza)*M(end,end)*...
                    factorCoContraCorriente;
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                z=linspace(0,Longitud,70);
                yinit=[C0,T0,Ta0];
                solinit = bvpinit(z,yinit);
                %Resolver BVP para sistema de EDO
                %Considerar forma y'=M^(-1)*f(z,y), especificar f(z,y) como
                %@(z,y), especificar condiciones de frontera como @(yl,yr)
                sol=bvp5c(@(z,y)...
                    ...
                    M\[...
                    Coefs_esteq'*rapideces(y(1:end-2),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref);
                    ...
                    (1./(Cp_Molares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,Cp_Molares)*...
                    rapideces(y(1:end-2),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(Cp_Molares*y(1:end-2)).*(y(end)-y(end-1));
                    ...
                    -U*a./(rhoCp_a).*(y(end)-y(end-1))...
                    ],...
                    ...
                    @(yleft,yright)...
                    [...
                    yleft(1:end-2)-C0';...
                    yleft(end-1)-T0;...
                    yright(end)-Ta0...
                    ]...
                    ...
                    ,solinit,odeOptions);
                z=sol.x;
                C=sol.y(1:end-2,:);
                T=sol.y(end-1,:);
                Ta=sol.y(end,:);
                F=C*Q0/1000;%mol/min
                Q=Q0/1000*ones(size(z));%L/min
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
                [~,dy_en_dz] = deval(sol,z);
                dT_en_dz = dy_en_dz(end-1,:);
            elseif ~Incompresible
                M=eye(nComps+2);
                M(1:end-1,1:end-1)=...
                    1/Az*1000*M(1:end-1,1:end-1);%1/cm^2*cm^3/L
                M(end,end)=Qa0/Aza*M(end,end)*...
                    factorCoContraCorriente;%cm^3/min*1/cm^2
                odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,...
                    'Events',@odeabort);
                z=linspace(0,Longitud,70);
                yinit=[F0,T0,Ta0];
                solinit = bvpinit(z,yinit);
                %Resolver BVP para sistema de EDO
                %Considerar forma y'=M^(-1)*f(z,y), especificar f(z,y) como
                %@(z,y), especificar condiciones de frontera como @(yl,yr)
                sol=bvp5c(@(z,y)...
                    ...
                    M\[...
                    Coefs_esteq'*rapideces(...
                    sum(C0)*y(1:end-2)/sum(y(1:end-2))*T0/y(end-1),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref);
                    ...
                    (1./(Cp_Molares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,Cp_Molares)*...
                    rapideces(...
                    sum(C0)*y(1:end-2)/sum(y(1:end-2))*T0/y(end-1),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(Cp_Molares*y(1:end-2)).*(y(end)-y(end-1));
                    ...
                    -U*a./(rhoCp_a).*(y(end)-y(end-1))...
                    ],...
                    ...
                    @(yleft,yright)...
                    [...
                    yleft(1:end-2)-F0';...
                    yleft(end-1)-T0;...
                    yright(end)-Ta0...
                    ]...
                    ...
                    ,solinit,odeOptions);
                z=sol.x;
                F=sol.y(1:end-2,:);
                T=sol.y(end-1,:);
                Ta=sol.y(end,:);
                C=zeros(size(F));
                for j=1:nComps
                    C(j,:)=sum(C0)*F(j,:)./sum(F,1).*T0./T;
                end
                Q=sum(F,1)./sum(C,1);
                [r,k]=rapideces(C,T,Exponentes_r,k0,E,R,T0ref);
                [~,dy_en_dz] = deval(sol,z);
                dT_en_dz = dy_en_dz(end-1,:);
            end
        end
        rho_Cp=Cp_Molares*C;
        qgen=1./(rho_Cp).*(sum(...
            (-delta_Hr(T,delta_Hf,Coefs_esteq,Cp_Molares))'.*r,1));
        qrem=+(Q*1000)./Az.*dT_en_dz+...
            -U*a./(rho_Cp).*(Ta-T);
        qrem_z= -U*a./(rho_Cp).*(Ta-T).*Az./(Q*1000);
        qgen_z= +qgen.*Az./(Q*1000);
        Qa=Qa0*ones(size(T));
    end
elseif ~Estacionario
    nPuntos=20;
    nTiempos=20;
    z=linspace(0,Longitud,nPuntos);
    t=linspace(0,tiempo_tot,nTiempos);
    C=NaN*zeros(length(C0),nPuntos,nTiempos);
    F=NaN*zeros(length(C0),nPuntos,nTiempos);
    T=NaN*zeros(nPuntos,nTiempos);
    Ta=NaN*zeros(nPuntos,nTiempos);
    
    sol_est=Datos_struct.sol;
    
    if Isot
        Y=NaN*zeros(length(C0),nPuntos,nTiempos);
        T=T0*ones(nPuntos,nTiempos);
        dT_en_dz=0*ones(nPuntos,nTiempos);
        if factorCoContraCorriente==+1
            %+1 Co-Corriente
            if Incompresible
                C_est=deval(sol_est,z,1:nComps);
                C(:,:,end)=C_est;
                C(:,1,:)=repmat(reshape(C0,length(C0),1),1,nTiempos);
                C(:,:,1)=repmat(reshape(C0,length(C0),1),1,nPuntos);
                y0=C(:,:,1);
                
                sol=setup(1,@(t,z,y,y_z)...
                    ...
                    ...
                    -Q0/Az*y_z(1:end,:)+...
                    Coefs_esteq'*rapideces(y(1:end,:),...
                    T0,Exponentes_r,k0,E,R,T0ref)...
                    ...
                    ...
                    ,t(1),z,y0,'SLXW',[],...
                    @(t,yL,yR)bc(t,yL,yR,y0,factorCoContraCorriente)...
                    ...
                    ,{[],[]});
                Y(:,:,1)=sol.u;
                for j=2:nTiempos
                    % Increase timestepFactor*1C/(dT/dt) every time
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,y)...
                        ...
                        timestep_factor/...
                        (max(max(abs(...
                        -Q0/Az*[0,diff(y(1:end,:))]/dx+...
                        Coefs_esteq'*rapideces(y(1:end,:),...
                        T0,Exponentes_r,k0,E,R,T0ref)...
                        ))))...
                        ...
                        );
                    Y(:,:,j)=sol.u;
                end
                
                C=Y(1:nComps,:,:);
                F=Q0*C/1000;%mol/min
                Q=squeeze(sum(F,1)./sum(C,1));
            elseif ~Incompresible
                
            end
        elseif factorCoContraCorriente==-1
            %-1 Contra-Corriente
            if Incompresible
                C_est=deval(sol_est,z,1:nComps);
                C(:,:,end)=C_est;
                C(:,1,:)=repmat(reshape(C0,length(C0),1),1,nTiempos);
                C(:,:,1)=repmat(reshape(C0,length(C0),1),1,nPuntos);
                y0=C(:,:,1);
                
                sol=setup(1,@(t,z,y,y_z)...
                    ...
                    ...
                    -Q0/Az*y_z(1:end,:)+...
                    Coefs_esteq'*rapideces(y(1:end,:),...
                    T0,Exponentes_r,k0,E,R,T0ref)...
                    ...
                    ...
                    ,t(1),z,y0,'SLXW',[],...
                    @(t,yL,yR)bc(t,yL,yR,y0,factorCoContraCorriente)...
                    ...
                    ,{[],[]});
                Y(:,:,1)=sol.u;
                for j=2:nTiempos
                    % Increase timestepFactor*1C/(dT/dt) every time
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,y)...
                        ...
                        timestep_factor/...
                        (max(max(abs(...
                        -Q0/Az*[0,diff(y(1:end,:))]/dx+...
                        Coefs_esteq'*rapideces(y(1:end,:),...
                        T0,Exponentes_r,k0,E,R,T0ref)...
                        ))))...
                        ...
                        );
                    Y(:,:,j)=sol.u;
                end
                
                C=Y(1:nComps,:,:);
                F=Q0*C/1000;%mol/min
                Q=squeeze(sum(F,1)./sum(C,1));
            elseif ~Incompresible
                
            end
        end
        rho_Cp=zeros(size(T));
        r=zeros(nReacs,nPuntos,nTiempos);
        k=zeros(nReacs,nPuntos,nTiempos);
        for j=1:nPuntos
            [r(:,j,:),k(:,j,:)]=rapideces(squeeze(C(:,j,:)),...
                T(j,:),Exponentes_r,k0,E,R,T0ref);
        end
        for j=1:size(rho_Cp,1)
            rho_Cp(j,:)=Cp_Molares*squeeze(C(:,j,:));
        end
        Ta=Ta0*ones(size(T));
        Ta_z=zeros(size(Ta));
        Ta_t=zeros(size(Ta));
        qgen=zeros(size(T));
        qrem=zeros(size(T));
        qrem_z=zeros(size(T));
        qgen_z=zeros(size(T));
        for j=1:nPuntos
            Ta(j,:)=-sum(...
                (-delta_Hr(T(j,:),delta_Hf,...
                Coefs_esteq,Cp_Molares)'...
                .*squeeze(r(:,j,:)))...
                ,1)/(U*a)+T(j,:);
            qgen(j,:)=1./(rho_Cp(j,:)).*(sum(...
                (-delta_Hr(T(j,:),delta_Hf,Coefs_esteq,Cp_Molares...
                ))'.*squeeze(r(:,j,:)),1));
            qrem(j,:)=+Q(j,:)./Az.*dT_en_dz(j,:)+...
                -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:));
            qrem_z(j,:)= -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:)).*Az./(Q(j,:)*1000);
            qgen_z(j,:)= +qgen(j,:).*Az./(Q(j,:)*1000);
        end
        for j=1:nPuntos
            Ta_t(j,:)=interp1((t(1:end-1)+t(2:end))/2,...
                diff(Ta(j,:))./diff(t),t);
        end
        for j=1:nTiempos
            Ta_z(:,j)=interp1((z(1:end-1)+z(2:end))/2,...
                diff(Ta(:,j)')./diff(z),z);
        end
        Qa=Aza/factorCoContraCorriente*(...
            -U*a./(rhoCp_a).*(Ta-T)-Ta_t).*(1./Ta_z);
    elseif ~Isot
        Y=NaN*zeros(length(C0)+2,nPuntos,nTiempos);
        dy_en_dz=NaN*zeros(length(C0)+2,nPuntos,nTiempos);
        T_est=deval(sol_est,z,size(sol_est.y,1)-1);
        Ta_est=deval(sol_est,z,size(sol_est.y,1));
        if factorCoContraCorriente==+1
            %+1 Co-Corriente
            Ta(1,:)=Ta0*ones(1,nTiempos);
            if Incompresible
                C_est=deval(sol_est,z,1:nComps);
                C(:,:,end)=C_est;
                T(:,end)=T_est;
                Ta(:,end)=Ta_est;
                C(:,1,:)=repmat(reshape(C0,length(C0),1),1,nTiempos);
                C(:,:,1)=repmat(reshape(C0,length(C0),1),1,nPuntos);
                T(:,1)=T0*ones(nPuntos,1);
                Ta(:,1)=Ta0*ones(nPuntos,1);
                y0=[C(:,:,1);T(:,1)';Ta(:,1)'];
                
                N=size(y0,1);
                wb=waitbar(0,'Solving...','CreateCancelBtn',@cancelOperation);
                wbMessageText=findall(wb,'type','text');
                set(wbMessageText,'Interpreter','none');
                set(wb,'Name','Solving...');
                
                fig3=figure('WindowStyle','docked');
                
                h=-1*ones(1,N);
                for i=1:N
                    h(i)=subplot(1,N,i);
                end
                
                options=odeset('Events'...
                    ...
                    ,@events,'Stats','on');
                
                m=0;
                [sol,tsol,~,te,~] = pdepe(m,...
                    @EDPNoEstacionarioNoIsotermicoCoCorriente,...
                    @CINoEstacionarioNoIsotermicoCoCorriente,...
                    @CFNoEstacionarioNoIsotermicoCoCorriente,...
                    z,t,options,'WaitBar',wb,'TotalTime',t(length(t)),...
                    'AxesToPlotOn',h,...
                    'uEdoEst',[C_est;T_est;Ta_est]);
                
                t=tsol;
                Y=NaN*zeros(length(C0)+2,nPuntos,length(t));
                dy_en_dz=NaN*zeros(length(C0)+2,nPuntos,length(t));
                
                delete(h);
                
                if ishandle(wb)
                    set(wbMessageText,'String',...
                        ['Steady state reached at t=',...
                        sprintf('%02.2e',te(length(te)))]);
                    uiwait(wb,3);
                    if ishandle(wb),delete(wb);end
                    if ishandle(fig3),delete(fig3);end
                end
                
                for j=1:size(sol,1)
                    for i=1:size(y0,1)
                        [Y(i,:,j),dy_en_dz(i,:,j)]=pdeval(m,z,sol(j,:,i),z);
                    end
                end
                
                
                C=Y(1:nComps,:,:);
                F=Q0*C/1000;%mol/min
                T=squeeze(Y(end-1,:,:));
                dT_en_dz=squeeze(dy_en_dz(end-1,:,:));
                Ta=squeeze(Y(end,:,:));
                Q=squeeze(sum(F,1)./sum(C,1));
                r=zeros(nReacs,nPuntos,length(t));
                k=zeros(nReacs,nPuntos,length(t));
                qgen=zeros(size(T));
                qrem=zeros(size(T));
                qrem_z=zeros(size(T));
                qgen_z=zeros(size(T));
                rho_Cp=zeros(size(T));
                for j=1:size(rho_Cp,1)
                    rho_Cp(j,:)=Cp_Molares*squeeze(C(:,j,:));
                end
                for j=1:nPuntos
                    [r(:,j,:),k(:,j,:)]=rapideces(squeeze(C(:,j,:)),...
                        T(j,:),Exponentes_r,k0,E,R,T0ref);
                    qgen(j,:)=1./(rho_Cp(j,:)).*(sum(...
                        (-delta_Hr(T(j,:),delta_Hf,Coefs_esteq,Cp_Molares...
                        ))'.*squeeze(r(:,j,:)),1));
                    qrem(j,:)=+(Q(j,:)*1000)./Az.*dT_en_dz(j,:)+...
                        -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:));
                    qrem_z(j,:)= -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:)).*Az./...
                        (Q(j,:)*1000);
                    qgen_z(j,:)= +qgen(j,:).*Az./(Q(j,:)*1000);
                end
                Qa=Qa0*ones(size(T));
            elseif ~Incompresible
                
            end
        elseif factorCoContraCorriente==-1
            %-1 Contra-Corriente
            Ta(end,:)=Ta0*ones(1,nTiempos);
            if Incompresible
                C_est=deval(sol_est,z,1:nComps);
                C(:,:,end)=C_est;
                T(:,end)=T_est;
                Ta(:,end)=Ta_est;
                C(:,1,:)=repmat(reshape(C0,length(C0),1),1,nTiempos);
                C(:,:,1)=repmat(reshape(C0,length(C0),1),1,nPuntos);
                T(:,1)=T0*ones(nPuntos,1);
                Ta(:,1)=Ta0*ones(nPuntos,1);
                y0=[C(:,:,1);T(:,1)';Ta(:,1)'];
                
                sol=setup(1,@(t,z,y,y_z)...
                    ...
                    [...
                    ...
                    -Q0/Az*y_z(1:end-2,:)+...
                    Coefs_esteq'*rapideces(y(1:end-2,:),...
                    y(end-1,:),Exponentes_r,k0,E,R,T0ref);
                    ...
                    -Q0/Az*y_z(end-1,:)+...
                    (1./(Cp_Molares*y(1:end-2,:))).*sum(...
                    (-delta_Hr(y(end-1,:),delta_Hf,...
                    Coefs_esteq,Cp_Molares)'.*rapideces(y(1:end-2,:),...
                    y(end-1,:),Exponentes_r,k0,E,R,T0ref))...
                    ,1)+...
                    U*a./(Cp_Molares*y(1:end-2,:)).*(y(end,:)-y(end-1,:));
                    ...
                    -Qa0/Aza*y_z(end,:)*factorCoContraCorriente+...
                    -U*a./(rhoCp_a).*(y(end,:)-y(end-1,:))...
                    ...
                    ]...
                    ...
                    ,t(1),z,y0,'SLXW',[],...
                    @(t,yL,yR)bc(t,yL,yR,y0,factorCoContraCorriente)...
                    ...
                    ,{[],[]});
                Y(:,:,1)=sol.u;
                dy_en_dz(:,:,1)=sol.du;
                % Ventana de estatus
                figure2=figure('DockControls','off',...
                    'MenuBar','none','Color','white','Name','Solving',...
                    'Toolbar','none');
                axes2=axes('Parent',figure2);
                h=plot(axes2,z,squeeze(Y(end-1:end,:,1)));
                xlabel(axes2,'z,cm');
                hpt=uipushtool(uitoolbar(figure2),'CData',stop_sign_icon,...
                    'ClickedCallback',...
                    @(hObject,eventdata)...
                    parar_Solucion_PFR_NoEst(hObject, eventdata));
                legend(axes2,'T','Ta');
                title(axes2,[num2str(t(1)),'min']);
                refreshdata(h,'caller');
                drawnow;
                set(h(1),'XDataSource','z');
                set(h(1),'YDataSource',['Y(',int2str(size(Y,1)-1),',:,j)']);
                set(h(2),'XDataSource','z');
                set(h(2),'YDataSource',['Y(',int2str(size(Y,1)),',:,j)']);
                % Empieza recorrido en tiempo
                for j=2:nTiempos
                    if strcmp(get(hpt,'UserData'),'Cancelled')
                        break
                    end
                    % Incrementar timestep_factor*1C/(dT/dt) cada vez
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,y)...
                        ...
                        timestep_factor/...
                        (max(max(abs(...
                        -Q0/Az*[0,diff(y(end-1,:))]/dx+...
                        (1./(Cp_Molares*y(1:end-2,:))).*sum(...
                        (-delta_Hr(y(end-1,:),delta_Hf,...
                        Coefs_esteq,Cp_Molares)'.*rapideces(y(1:end-2,:),...
                        y(end-1,:),Exponentes_r,k0,E,R,T0ref))...
                        ,1)+...
                        U*a./(Cp_Molares*y(1:end-2,:)).*(y(end,:)-y(end-1,:))...
                        ))))...
                        );
                    Y(:,:,j)=sol.u;
                    dy_en_dz(:,:,j)=sol.du;
                    % Refrescar ventana de estatus
                    title(axes2,[num2str(t(j)),'min']);
                    refreshdata(h,'caller');
                    drawnow;
                end
                delete([figure2,axes2]);
                
                C=Y(1:nComps,:,:);
                F=Q0*C/1000;%mol/min
                T=squeeze(Y(end-1,:,:));
                dT_en_dz=squeeze(dy_en_dz(end-1,:,:));
                Ta=squeeze(Y(end,:,:));
                Q=squeeze(sum(F,1)./sum(C,1));
                r=zeros(nReacs,nPuntos,nTiempos);
                k=zeros(nReacs,nPuntos,nTiempos);
                rho_Cp=zeros(size(T));
                qgen=zeros(size(T));
                qrem=zeros(size(T));
                qrem_z=zeros(size(T));
                qgen_z=zeros(size(T));
                for j=1:size(rho_Cp,1)
                    rho_Cp(j,:)=Cp_Molares*squeeze(C(:,j,:));
                end
                for j=1:nPuntos
                    [r(:,j,:),k(:,j,:)]=rapideces(squeeze(C(:,j,:)),...
                        T(j,:),Exponentes_r,k0,E,R,T0ref);
                    qgen(j,:)=1./(rho_Cp(j,:)).*(sum(...
                        (-delta_Hr(T(j,:),delta_Hf,Coefs_esteq,Cp_Molares...
                        ))'.*squeeze(r(:,j,:)),1));
                    qrem(j,:)=+(Q(j,:)*1000)./Az.*dT_en_dz(j,:)+...
                        -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:));
                    qrem_z(j,:)= -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:)).*Az./...
                        (Q(j,:)*1000);
                    qgen_z(j,:)= +qgen(j,:).*Az./(Q(j,:)*1000);
                end
                Qa=Qa0*ones(size(T));
            elseif ~Incompresible
                
            end
        end
    end
end

    function [yL,yR]=bc(~,yL,yR,y0,factorCoContraCorriente)
        if factorCoContraCorriente ==+1
            yL=y0(:,1);
        elseif factorCoContraCorriente ==-1
            yL(1:end-1)=y0(1:end-1,1);
            yR(end)=y0(end,1);
        end
    end

X=NaN*zeros(size(C));
Y=NaN*zeros(size(C));
Yconsumo=NaN*zeros(size(C));
S=NaN*zeros(size(C));
%CONVERSI�N
for j=1:size(C,1)
    if ismember(j,reactivosSonCompsNo)
        if length(size(C))<3
            X(j,:)=(F0(j)-F(j,:))./(F0(j));
        else
            X(j,:,:)=(F0(j)-squeeze(F(j,:,:)))./(F0(j));
        end
    end
end
%RENDIMIENTO POR ALIMENTACI�N
for j=1:size(C,1)
    if ismember(j,productosSonCompsNo)
        if length(size(C))<3
            Y(j,:)=(F(j,:)-F0(j))./...
                (F0(Ref_Rendimiento));
        else
            Y(j,:,:)=(squeeze(F(j,:,:))-F0(j))./...
                (F0(Ref_Rendimiento));
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
            S(j,:)=Y(j,:)./Y(Ref_Selectividad,:);
        else
            S(j,:,:)=squeeze(Y(j,:,:))./...
                squeeze(Y(Ref_Selectividad,:,:));
        end
    end
end

Datos_struct.sol=sol;
Datos_struct.z=z;
Datos_struct.t=t;
Datos_struct.C=C;
Datos_struct.F=F;
Datos_struct.X=X;
Datos_struct.Y=Y;
Datos_struct.Yconsumo=Yconsumo;
Datos_struct.S=S;
Datos_struct.T=T;
Datos_struct.Ta=Ta;
Datos_struct.r=r;
Datos_struct.k=k;
Datos_struct.qrem=qrem;
Datos_struct.qgen=qgen;
Datos_struct.qrem_z=qrem_z;
Datos_struct.qgen_z=qgen_z;
Datos_struct.q={qgen;qrem;qrem_z;qgen_z};
Datos_struct.Q=Q;
Datos_struct.Qa=Qa;
Datos_struct_final=Datos_struct;
end

function cancelOperation(hObject,eventData)
parent=get(hObject,'Parent');
if ishandle(parent) && strcmp(get(parent,'Type'),'figure')
    delete(parent);
elseif ishandle(hObject) && strcmp(get(hObject,'Type'),'figure')
    delete(hObject);
end
end

function [value,isterminal,direction] = events(m,t,xmesh,umesh,varargin)
% Stop when steady condition crossed.
value = umesh; % Detect u-u_steady = 0
isterminal = 1*ones(size(value));   % To make terminal change 0 for 1
direction = 0*ones(size(value));   % Negative or positive directions
if nargin >= 8 ...
        && strcmp(varargin{1},'WaitBar')...
        && ishandle(varargin{2})...
        && strcmp(get(varargin{2},'Type'),'figure')...
        && strcmp(varargin{3},'TotalTime')...
        && isnumeric(varargin{4}) ...
        && isscalar(varargin{4})...
        && isreal(varargin{4})
    wb=varargin{2};
    figure(wb);
    totalTime=varargin{4};
    fraction=t(length(t))/totalTime;
    if ishandle(wb),messageText=findall(wb,'type','text');end
    estatus=['Will stop once steady state is reached or ',...
        't= ',sprintf('%02.2f',totalTime),...
        ' (',sprintf('%u',round(fraction*100)) '%)'];
    if ishandle(wb),waitbar(fraction,wb);end
    if ishandle(wb),set(messageText,'String',estatus);end
    if ~ishandle(wb)
        value = umesh*0; % Stop prematurely
        sprintf('canceled')
    end
end
if nargin >= 10 ...
        && strcmp(varargin{5},'AxesToPlotOn')...
        && all(ishandle(varargin{6}))
    axesArray  = varargin{6};
    uVarNo = size(umesh,1)/size(xmesh,1);
    lineObjects = double.empty(0,uVarNo);
    for i=1:uVarNo
        subplot(axesArray(i));
        if isempty(findobj(axesArray(i),'Type','line'))
            plot(axesArray(i),...
                xmesh,...
                umesh(linspace(...
                i,i+uVarNo*(size(xmesh,1)-1),size(xmesh,1))));
        else
            lineObjects(i) = findobj(axesArray(i),'Type','line');
            set(lineObjects(i),'XData',xmesh,...
                'YData',umesh(linspace(...
                i,i+uVarNo*(size(xmesh,1)-1),size(xmesh,1))));
        end
        title(axesArray(i),...
            ['u',num2str(i),'(x,t=',sprintf('%0.3f',t),')']);
    end
    if nargin > 10 ...
            && strcmp(varargin{7},'uEdoEst')...
            && isnumeric(varargin{8}) ...
            && size(varargin{8},1) == uVarNo
        uEdoEst = varargin{8};
        value = umesh-uEdoEst(:); % Detect u-u_steady = 0
    end
end
end