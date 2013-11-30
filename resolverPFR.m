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
CpMolares=Datos_struct.CpMolares;
R=Datos_struct.R;
tiempo_tot=Datos_struct.tiempo_tot;
timestep_factor=Datos_struct.timestep_factor;
Az=pi/4*(Diam)^2;%cm^2
Aza=pi/4*(Diam_a^2-Diam^2);%cm^2
F0=C0*Q0/1000;%mol/min

if Estacionario
    t=inf;
    if Isot
        % Isot�rmico estacionario: La temperatura T(z) es igual que la
        % temperatura inicial y en z=0. Delta Hr y k ya est�n fijos en todo
        % el reactor.
        T=T0;
        DHr=delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares);
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
        rho_Cp=CpMolares*C;
        Ta=-1/(U*a)*(-DHr*r)+T;        
        qgen=1./(rho_Cp).*(sum(...
            (-delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares))'.*r,1));
        qrem=+Q./Az.*dT_en_dz+...
            -U*a./(rho_Cp).*(Ta-T);
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
                    (1./(CpMolares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,CpMolares)*...
                    rapideces(y(1:end-2),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(CpMolares*y(1:end-2)).*(y(end)-y(end-1));
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
                    (1./(CpMolares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,CpMolares)*...
                    rapideces(...
                    sum(C0)*y(1:end-2)/sum(y(1:end-2))*T0/y(end-1),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(CpMolares*y(1:end-2)).*(y(end)-y(end-1));
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
                    (1./(CpMolares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,CpMolares)*...
                    rapideces(y(1:end-2),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(CpMolares*y(1:end-2)).*(y(end)-y(end-1));
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
                    (1./(CpMolares*y(1:end-2))).*...
                    (-delta_Hr(y(end-1),delta_Hf,...
                    Coefs_esteq,CpMolares)*...
                    rapideces(...
                    sum(C0)*y(1:end-2)/sum(y(1:end-2))*T0/y(end-1),...
                    y(end-1),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(CpMolares*y(1:end-2)).*(y(end)-y(end-1));
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
        rho_Cp=CpMolares*C;        
        qgen=1./(rho_Cp).*(sum(...
            (-delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares))'.*r,1));
        qrem=+Q./Az.*dT_en_dz+...
            -U*a./(rho_Cp).*(Ta-T);
        Qa=Qa0*ones(size(T));
    end
elseif ~Estacionario    
    nPuntos=80;
    nTiempos=70;
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
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,V)...
                        ...
                        timestep_factor/...
                        (max(max(abs(V(:,2:end) - V(:,1:end-1))))/dx)...
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
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,V)...
                        ...
                        timestep_factor/...
                        (max(max(abs(V(:,2:end) - V(:,1:end-1))))/dx)...
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
            rho_Cp(j,:)=CpMolares*squeeze(C(:,j,:));            
        end    
        Ta=Ta0*ones(size(T));
        Ta_z=zeros(size(Ta));
        Ta_t=zeros(size(Ta));
        qgen=zeros(size(T));
        qrem=zeros(size(T));
        for j=1:nPuntos
            Ta(j,:)=-sum(...
                (-delta_Hr(T(j,:),delta_Hf,...
                Coefs_esteq,CpMolares)'...
                .*squeeze(r(:,j,:)))...
                ,1)/(U*a)+T(j,:);
            qgen(j,:)=1./(rho_Cp(j,:)).*(sum(...
                (-delta_Hr(T(j,:),delta_Hf,Coefs_esteq,CpMolares...
                ))'.*squeeze(r(:,j,:)),1));
            qrem(j,:)=+Q(j,:)./Az.*dT_en_dz(j,:)+...
                -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:));
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
                
                sol=setup(1,@(t,z,y,y_z)...
                    ...
                    [...
                    ...
                    -Q0/Az*y_z(1:end-2,:)+...
                    Coefs_esteq'*rapideces(y(1:end-2,:),...
                    y(end-1,:),Exponentes_r,k0,E,R,T0ref);
                    ...
                    -Q0/Az*y_z(end-1,:)+...
                    (1./(CpMolares*y(1:end-2,:))).*sum(...
                    (-delta_Hr(y(end-1,:),delta_Hf,...
                    Coefs_esteq,CpMolares)'.*rapideces(y(1:end-2,:),...
                    y(end-1,:),Exponentes_r,k0,E,R,T0ref))...
                    ,1)+...
                    U*a./(CpMolares*y(1:end-2,:)).*(y(end,:)-y(end-1,:));
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
                for j=2:nTiempos
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,V)...
                        ...
                        timestep_factor/...
                        (max(max(abs(V(:,2:end) - V(:,1:end-1))))/dx)...
                        ...
                        );
                    Y(:,:,j)=sol.u;  
                    dy_en_dz(:,:,j)=sol.du;
                end
                
                C=Y(1:nComps,:,:);
                F=Q0*C/1000;%mol/min
                T=squeeze(Y(end-1,:,:));
                dT_en_dz=squeeze(dy_en_dz(end-1,:,:));
                Ta=squeeze(Y(end,:,:));
                Q=squeeze(sum(F,1)./sum(C,1));
                r=zeros(nReacs,nPuntos,nTiempos);               
                k=zeros(nReacs,nPuntos,nTiempos);               
                qgen=zeros(size(T));
                qrem=zeros(size(T));
                rho_Cp=zeros(size(T));                
                for j=1:size(rho_Cp,1)
                    rho_Cp(j,:)=CpMolares*squeeze(C(:,j,:));
                end
                for j=1:nPuntos
                    [r(:,j,:),k(:,j,:)]=rapideces(squeeze(C(:,j,:)),...
                        T(j,:),Exponentes_r,k0,E,R,T0ref);                    
                    qgen(j,:)=1./(rho_Cp(j,:)).*(sum(...
                        (-delta_Hr(T(j,:),delta_Hf,Coefs_esteq,CpMolares...
                        ))'.*squeeze(r(:,j,:)),1));
                    qrem(j,:)=+Q(j,:)./Az.*dT_en_dz(j,:)+...
                        -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:));
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
                    (1./(CpMolares*y(1:end-2,:))).*...
                    (-delta_Hr*rapideces(y(1:end-2,:),...
                    y(end-1,:),Exponentes_r,k0,E,R,T0ref))+...
                    U*a./(CpMolares*y(1:end-2,:)).*(y(end,:)-y(end-1,:));
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
%                 figure2=figure;axes2=axes('Parent',figure2);
%                 h=plot(axes2,z,squeeze(Y(1:nComps,:,1)));
%                 for j=1:length(h)
%                     set(h(j),'XDataSource','z');
%                     set(h(j),'YDataSource',['Y(',int2str(j),',:,j)']);
%                 end
                for j=2:nTiempos
                    sol=hpde(sol,t(j)-t(j-1),...
                        @(dx,t,x,V)...
                        ...
                        timestep_factor/...
                        (max(max(abs(V(:,2:end) - V(:,1:end-1))))/dx)...
                        ...
                        );
                    Y(:,:,j)=sol.u;
                    dy_en_dz(:,:,j)=sol.du;
%                     refreshdata(h,'caller');
                end
%                 delete([figure2,axes2]);
                
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
                for j=1:size(rho_Cp,1)
                    rho_Cp(j,:)=CpMolares*squeeze(C(:,j,:));
                end
                for j=1:nPuntos
                    [r(:,j,:),k(:,j,:)]=rapideces(squeeze(C(:,j,:)),...
                        T(j,:),Exponentes_r,k0,E,R,T0ref);
                    qgen(j,:)=1./(rho_Cp(j,:)).*(sum(...
                        (-delta_Hr(T(j,:),delta_Hf,Coefs_esteq,CpMolares...
                        ))'.*squeeze(r(:,j,:)),1));
                    qrem(j,:)=+Q(j,:)./Az.*dT_en_dz(j,:)+...
                        -U*a./(rho_Cp(j,:)).*(Ta(j,:)-T(j,:));
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
            S(j,:)=Y(j,:)/Y(Ref_Selectividad,:);
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
Datos_struct.q={qgen;qrem};
Datos_struct.Q=Q;
Datos_struct.Qa=Qa;
Datos_struct_final=Datos_struct;
end