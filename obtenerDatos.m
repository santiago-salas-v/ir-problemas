function Datos_struct = obtenerDatos(Datos)

Datos_struct.Tipo = Datos{strcmp(Datos,'Tipo'),2};
if ~islogical(Datos{strcmp(Datos,'Incompresible'),2})  &&...
        ischar(Datos{strcmp(Datos,'Incompresible'),2})
    Datos_struct.Incompresible = ...
        logical(eval(Datos{strcmp(Datos,'Incompresible'),2}));
else
    Datos_struct.Incompresible = ...
    Datos{strcmp(Datos,'Incompresible'),2};
end
Datos{strcmp(Datos,'Incompresible'),2}=Datos_struct.Incompresible;
if ~islogical(Datos{strcmp(Datos,'Isot'),2}) &&...
        ischar(Datos{strcmp(Datos,'Isot'),2})
    Datos_struct.Isot = ...
        logical(eval(Datos{strcmp(Datos,'Isot'),2}));
else
    Datos_struct.Isot = ...
    Datos{strcmp(Datos,'Isot'),2};
end
Datos{strcmp(Datos,'Isot'),2}=Datos_struct.Isot;
if strcmp(Datos_struct.Tipo,'PFR')||...
        strcmp(Datos_struct.Tipo,'CSTR')
    if ~islogical(Datos{strcmp(Datos,'Estacionario'),2}) &&...
            ischar(Datos{strcmp(Datos,'Estacionario'),2})
        Datos_struct.Estacionario = ...
            logical(eval(Datos{strcmp(Datos,'Estacionario'),2}));
    else
        Datos_struct.Estacionario = ...
        Datos{strcmp(Datos,'Estacionario'),2};
    end
    Datos{strcmp(Datos,'Estacionario'),2}=Datos_struct.Estacionario;
    if isempty(Datos_struct.Estacionario) 
        Datos_struct.Estacionario=true;        
    end    
    Datos{strcmp(Datos,'Estacionario'),2}=Datos_struct.Estacionario;
else
    Datos_struct.Estacionario = true;    
end
if isempty(Datos_struct.Incompresible) ||...
        isempty(Datos_struct.Isot)
   Datos_struct.Incompresible=true;
   Datos{strcmp(Datos,'Incompresible'),2}=Datos_struct.Incompresible;
   Datos_struct.Isot=false;      
   Datos{strcmp(Datos,'Isot'),2}=Datos_struct.Isot;
end
if ~isempty(Datos{strcmp(Datos,'Coefs_esteq'),2}) &&...
        ischar(Datos{strcmp(Datos,'Coefs_esteq'),2})
    Datos_struct.Coefs_esteq = ...
        eval(Datos{strcmp(Datos,'Coefs_esteq'),2});
else
    Datos_struct.Coefs_esteq = ...
    Datos{strcmp(Datos,'Coefs_esteq'),2};
end
Datos_struct.nReacs=size(Datos_struct.Coefs_esteq,1);
Datos_struct.nComps=size(Datos_struct.Coefs_esteq,2);
if ~isempty(Datos{strcmp(Datos,'delta_Hf'),2}) &&...
        ischar(Datos{strcmp(Datos,'delta_Hf'),2})
    Datos_struct.delta_Hf = ...
        reshape(eval(Datos{strcmp(Datos,'delta_Hf'),2})*...
        1000,1,Datos_struct.nComps);
else
    Datos_struct.delta_Hf = ...
    reshape(Datos{strcmp(Datos,'delta_Hf'),2}*...
    1000,1,Datos_struct.nComps);
end
Datos_struct.delta_Hr_0 = reshape(Datos_struct.Coefs_esteq*...
    Datos_struct.delta_Hf',1,Datos_struct.nReacs);
if ~isempty(Datos{strcmp(Datos,'E'),2}) &&...
        ischar(Datos{strcmp(Datos,'E'),2})
    Datos_struct.E = reshape(eval(Datos{strcmp(Datos,'E'),2}),1,...
        Datos_struct.nReacs);
else
    Datos_struct.E = ...
    Datos{strcmp(Datos,'E'),2};
end
if ~isempty(Datos{strcmp(Datos,'k0'),2}) &&...
        ischar(Datos{strcmp(Datos,'k0'),2})
    Datos_struct.k0 = reshape(eval(Datos{strcmp(Datos,'k0'),2}),1,...
        Datos_struct.nReacs);
else
    Datos_struct.k0 = ...
    Datos{strcmp(Datos,'k0'),2};
end
if ~isempty(Datos{strcmp(Datos,'T0ref'),2}) &&...
        ischar(Datos{strcmp(Datos,'T0ref'),2})
    Datos_struct.T0ref = ...
        eval(Datos{strcmp(Datos,'T0ref'),2});
else
    Datos_struct.T0ref = ...
    Datos{strcmp(Datos,'T0ref'),2};
end
if ~isempty(Datos{strcmp(Datos,'Exponentes_r'),2}) &&...
        ischar(Datos{strcmp(Datos,'Exponentes_r'),2})
    Datos_struct.Exponentes_r = ...
        eval(Datos{strcmp(Datos,'Exponentes_r'),2});
else
    Datos_struct.Exponentes_r = ...
    Datos{strcmp(Datos,'Exponentes_r'),2};
end
if ~isempty(Datos{strcmp(Datos,'Ref_Rendimiento'),2}) &&...
        ischar(Datos{strcmp(Datos,'Ref_Rendimiento'),2})
    Datos_struct.Ref_Rendimiento = ...
        eval(Datos{strcmp(Datos,'Ref_Rendimiento'),2});
else
    Datos_struct.Ref_Rendimiento = ...
    Datos{strcmp(Datos,'Ref_Rendimiento'),2};
end
if ~isempty(Datos{strcmp(Datos,'Ref_Selectividad'),2}) &&...
        ischar(Datos{strcmp(Datos,'Ref_Selectividad'),2})
    Datos_struct.Ref_Selectividad = ...
        eval(Datos{strcmp(Datos,'Ref_Selectividad'),2});
else
    Datos_struct.Ref_Selectividad = ...
    Datos{strcmp(Datos,'Ref_Selectividad'),2};
end
if ~isempty(Datos{strcmp(Datos,'C0'),2}) &&...
        ischar(Datos{strcmp(Datos,'C0'),2})
    Datos_struct.C0 = eval(Datos{strcmp(Datos,'C0'),2});
else
    Datos_struct.C0 = ...
    Datos{strcmp(Datos,'C0'),2};
end
Datos_struct.C0 = reshape(Datos_struct.C0,1,numel(Datos_struct.C0));
if ~isempty(Datos{strcmp(Datos,'T0'),2}) &&...
        ischar(Datos{strcmp(Datos,'T0'),2})
    Datos_struct.T0 = eval(Datos{strcmp(Datos,'T0'),2});
else
    Datos_struct.T0 = ...
    Datos{strcmp(Datos,'T0'),2};
end
if strcmp(Datos_struct.Tipo,'SEMIBR')||...
        strcmp(Datos_struct.Tipo,'CSTR')
    if ~isempty(Datos{strcmp(Datos,'C_t0'),2})
        if ischar(Datos{strcmp(Datos,'C_t0'),2})
            Datos_struct.C_t0 = eval(Datos{strcmp(Datos,'C_t0'),2});
        end    
    else
        Datos_struct.C_t0 = ...
        Datos{strcmp(Datos,'C_t0'),2};
    end
    Datos_struct.C_t0 = ...
        reshape(Datos_struct.C_t0,1,numel(Datos_struct.C_t0));
    if ~isempty(Datos{strcmp(Datos,'T_t0'),2})
        if ischar(Datos{strcmp(Datos,'T_t0'),2})
            Datos_struct.T_t0 = eval(Datos{strcmp(Datos,'T_t0'),2});
        end    
    else
        Datos_struct.T_t0 = ...
        Datos{strcmp(Datos,'T_t0'),2};
    end
end
if ~isempty(Datos{strcmp(Datos,'Longitud'),2}) && ...
    ischar(Datos{strcmp(Datos,'Longitud'),2})
        Datos_struct.Longitud = eval(Datos{strcmp(Datos,'Longitud'),2});   
else
    Datos_struct.Longitud = ...
    Datos{strcmp(Datos,'Longitud'),2};
end
if ~isempty(Datos{strcmp(Datos,'Diam'),2}) && ...
        ischar(Datos{strcmp(Datos,'Diam'),2})
    Datos_struct.Diam = eval(Datos{strcmp(Datos,'Diam'),2});
else
    Datos_struct.Diam = ...
    Datos{strcmp(Datos,'Diam'),2};
end
Datos_struct.Vr = Datos_struct.Longitud*pi/4*Datos_struct.Diam^2*1/1000;
if ~isempty(Datos{strcmp(Datos,'U'),2}) && ...
        ischar(Datos{strcmp(Datos,'U'),2})
    Datos_struct.U = ...
        eval(Datos{strcmp(Datos,'U'),2})*1055*1/60*9/5;
else
    Datos_struct.U = ...
        Datos{strcmp(Datos,'U'),2}*1055*1/60*9/5;
end
if ~isempty(Datos{strcmp(Datos,'Ta0'),2}) && ...
        ischar(Datos{strcmp(Datos,'Ta0'),2})
    Datos_struct.Ta0 = ...
        eval(Datos{strcmp(Datos,'Ta0'),2});   
else
    Datos_struct.Ta0 = ...
        Datos{strcmp(Datos,'Ta0'),2};
end
if ~isempty(Datos{strcmp(Datos,'Diam_a'),2}) && ...
        ischar(Datos{strcmp(Datos,'Diam_a'),2})
    Datos_struct.Diam_a = ...
        eval(Datos{strcmp(Datos,'Diam_a'),2});   
else
    Datos_struct.Diam_a = ...
        Datos{strcmp(Datos,'Diam_a'),2};
end
if ~isempty(Datos{strcmp(Datos,'Qa0'),2}) && ...
        ischar(Datos{strcmp(Datos,'Qa0'),2})
    Datos_struct.Qa0 = ...
        eval(Datos{strcmp(Datos,'Qa0'),2});   
else
    Datos_struct.Qa0 = ...
        Datos{strcmp(Datos,'Qa0'),2};
end
Datos_struct.uza = Datos_struct.Qa0*1000/...
    (pi/4*(Datos_struct.Diam_a^2-Datos_struct.Diam^2));
if strcmp(Datos_struct.Tipo,'PFR')    
    if ~islogical(Datos{strcmp(Datos,'Co_Corriente'),2})
        if ischar(Datos{strcmp(Datos,'Co_Corriente'),2})
            Datos_struct.Co_Corriente = ...
            logical(eval(Datos{strcmp(Datos,'Co_Corriente'),2}));
        end    
    else
        Datos_struct.Co_Corriente = ...
        Datos{strcmp(Datos,'Co_Corriente'),2};
    end
    Datos{strcmp(Datos,'Co_Corriente'),2}=Datos_struct.Co_Corriente;    
    if isempty(Datos_struct.Co_Corriente)
       Datos_struct.Co_Corriente=true;
       Datos{strcmp(Datos,'Co_Corriente'),2}=Datos_struct.Co_Corriente;
    end
    if Datos_struct.Co_Corriente
        Datos_struct.factorCoContraCorriente = +1;
    else
        Datos_struct.factorCoContraCorriente = -1;
    end
    Datos_struct.a = 4/Datos_struct.Diam*1/30.48^2*1000;
    if ~isempty(Datos{strcmp(Datos,'Q0'),2}) &&...
            ischar(Datos{strcmp(Datos,'Q0'),2})
        Datos_struct.Q0 = ...
            eval(Datos{strcmp(Datos,'Q0'),2});   
    else
        Datos_struct.Q0 = ...
            Datos{strcmp(Datos,'Q0'),2};
    end
    Datos_struct.theta = Datos_struct.Vr/Datos_struct.Q0;
    Datos_struct.uz=Datos_struct.Q0*1000/(pi/4*Datos_struct.Diam^2);
    if ~isempty(Datos{strcmp(Datos,'timestep_factor'),2}) &&...
            ischar(Datos{strcmp(Datos,'timestep_factor'),2})
        Datos_struct.timestep_factor = ...
            eval(Datos{strcmp(Datos,'timestep_factor'),2});   
    else
        Datos_struct.timestep_factor = ...
            Datos{strcmp(Datos,'timestep_factor'),2};
    end
elseif strcmp(Datos_struct.Tipo,'CSTR')
    Datos_struct.Longitud = 1.5*Datos_struct.Diam;
    Datos_struct.A = pi*Datos_struct.Diam*Datos_struct.Longitud*1/30.48^2;
    if ~isempty(Datos{strcmp(Datos,'Q0'),2}) &&...
            ischar(Datos{strcmp(Datos,'Q0'),2})
        Datos_struct.Q0 = ...
            eval(Datos{strcmp(Datos,'Q0'),2});
    else
        Datos_struct.Q0 = ...
            Datos{strcmp(Datos,'Q0'),2};
    end
    Datos_struct.theta = Datos_struct.Vr/Datos_struct.Q0;
    Datos_struct.uz=Datos_struct.Q0*1000/(pi/4*Datos_struct.Diam^2);
    Datos_struct.Va = Datos_struct.Longitud*...
        pi/4*(Datos_struct.Diam_a^2-Datos_struct.Diam^2)*1/1000;
    if ~isempty(Datos{strcmp(Datos,'Tmax'),2}) &&...
            ischar(Datos{strcmp(Datos,'Tmax'),2})
        Datos_struct.Tmax = ...
            eval(Datos{strcmp(Datos,'Tmax'),2});
    else
        Datos_struct.Tmax = ...
            Datos{strcmp(Datos,'Tmax'),2};
    end
elseif strcmp(Datos_struct.Tipo,'BR')
    Datos_struct.Longitud = 1.5*Datos_struct.Diam;
    Datos_struct.A = pi*Datos_struct.Diam*Datos_struct.Longitud*1/30.48^2;
    Datos_struct.Va = Datos_struct.Longitud*...
        pi/4*(Datos_struct.Diam_a^2-Datos_struct.Diam^2)*1/1000;
elseif strcmp(Datos_struct.Tipo,'SEMIBR')
    Datos_struct.Longitud = 1.5*Datos_struct.Diam;
    Datos_struct.A = pi*Datos_struct.Diam*Datos_struct.Longitud*1/30.48^2;
    if ~isempty(Datos{strcmp(Datos,'Q0'),2}) &&...
            ischar(Datos{strcmp(Datos,'Q0'),2})
        Datos_struct.Q0 = ...
            eval(Datos{strcmp(Datos,'Q0'),2});
    else
        Datos_struct.Q0 = ...
            Datos{strcmp(Datos,'Q0'),2};
    end
    Datos_struct.theta = Datos_struct.Vr/Datos_struct.Q0;
    Datos_struct.uz=Datos_struct.Q0*1000/(pi/4*Datos_struct.Diam^2);
    Datos_struct.Va = Datos_struct.Longitud*...
        pi/4*(Datos_struct.Diam_a^2-Datos_struct.Diam^2)*1/1000;    
end
if ~isempty(Datos{strcmp(Datos,'Cp_Molares'),2}) &&...
        ischar(Datos{strcmp(Datos,'Cp_Molares'),2})
    Datos_struct.CpMolares = ...
        eval(Datos{strcmp(Datos,'Cp_Molares'),2})*1000;
else
    Datos_struct.CpMolares = ...
    Datos{strcmp(Datos,'Cp_Molares'),2}*1000;
end
Datos_struct.CpMolares = ...
    reshape(Datos_struct.CpMolares,1,numel(Datos_struct.CpMolares));
if ~isempty(Datos{strcmp(Datos,'rhoCp_a'),2}) &&...
        ischar(Datos{strcmp(Datos,'rhoCp_a'),2})
    Datos_struct.rhoCp_a = ...
        eval(Datos{strcmp(Datos,'rhoCp_a'),2})*1000;
else
    Datos_struct.rhoCp_a = ...
        Datos{strcmp(Datos,'rhoCp_a'),2}*1000;
end
if ~isempty(Datos{strcmp(Datos,'tiempo_tot'),2}) &&...
        ischar(Datos{strcmp(Datos,'tiempo_tot'),2})
    Datos_struct.tiempo_tot = ...
        eval(Datos{strcmp(Datos,'tiempo_tot'),2});
else
    Datos_struct.tiempo_tot = ...
        Datos{strcmp(Datos,'tiempo_tot'),2};
end
Datos_struct.R = 8.3140;

if ~isempty(Datos{strcmp(Datos,'XMIN'),2}) &&...
        ischar(Datos{strcmp(Datos,'XMIN'),2})
    Datos_struct.XMIN = ...
        eval(Datos{strcmp(Datos,'XMIN'),2});
else
    Datos_struct.XMIN = ...
        Datos{strcmp(Datos,'XMIN'),2};
end
if ~isempty(Datos{strcmp(Datos,'XMAX'),2}) &&...
        ischar(Datos{strcmp(Datos,'XMAX'),2})
    Datos_struct.XMAX = ...
        eval(Datos{strcmp(Datos,'XMAX'),2});
else
    Datos_struct.XMAX = ...
        Datos{strcmp(Datos,'XMAX'),2};
end
if ~isempty(Datos{strcmp(Datos,'YMIN'),2}) &&...
        ischar(Datos{strcmp(Datos,'YMIN'),2})
    Datos_struct.YMIN = ...
        eval(Datos{strcmp(Datos,'YMIN'),2});
else
    Datos_struct.YMIN = ...
        Datos{strcmp(Datos,'YMIN'),2};
end
if ~isempty(Datos{strcmp(Datos,'YMAX'),2}) &&...
        ischar(Datos{strcmp(Datos,'YMAX'),2})
    Datos_struct.YMAX = ...
        eval(Datos{strcmp(Datos,'YMAX'),2});
else
    Datos_struct.YMAX = ...
        Datos{strcmp(Datos,'YMAX'),2};
end
if ~isempty(Datos{strcmp(Datos,'ZMIN'),2}) &&...
        ischar(Datos{strcmp(Datos,'ZMIN'),2})
    Datos_struct.ZMIN = ...
        eval(Datos{strcmp(Datos,'ZMIN'),2});
else
    Datos_struct.ZMIN = ...
        Datos{strcmp(Datos,'ZMIN'),2};
end
if ~isempty(Datos{strcmp(Datos,'ZMAX'),2}) &&...
        ischar(Datos{strcmp(Datos,'ZMAX'),2})
    Datos_struct.ZMAX = ...
        eval(Datos{strcmp(Datos,'ZMAX'),2});
else
    Datos_struct.ZMAX = ...
        Datos{strcmp(Datos,'ZMAX'),2};
end

characters=char(65:90);
Datos_struct.labels=cell(1,min(length(characters),...
    size(Datos_struct.Coefs_esteq,2)));
Datos_struct.labels_est=cell(1,min(length(characters),...
    size(Datos_struct.Coefs_esteq,2)));
for i=1:length(Datos_struct.labels)
    Datos_struct.labels{i}=characters(i);
end
for i=1:length(Datos_struct.labels_est)
    Datos_struct.labels_est{i}=[characters(i),'est'];
end

%
% Análisis reactivos - productos
encontrarReactivos = find(Datos_struct.Coefs_esteq<0);
[~,reactivosSonCompsNo] = ind2sub(size(Datos_struct.Coefs_esteq),...
    encontrarReactivos);
encontrarProductos = find(Datos_struct.Coefs_esteq>0);
[~,productosSonCompsNo] = ind2sub(size(Datos_struct.Coefs_esteq),...
    encontrarProductos);
Datos_struct.reactivosSonCompsNo=unique(reactivosSonCompsNo);
Datos_struct.productosSonCompsNo=unique(productosSonCompsNo);
Datos_struct.productosConSelectividad=Datos_struct.productosSonCompsNo(...
        Datos_struct.productosSonCompsNo~=...
        Datos_struct.Ref_Selectividad);
if isempty(Datos_struct.Ref_Selectividad)||...
        ~ismember(Datos_struct.Ref_Selectividad,...
        Datos_struct.productosSonCompsNo)
    Datos{strcmp(Datos,'Ref_Selectividad'),2}=...
        Datos_struct.productosSonCompsNo(1);
    Datos_struct.Ref_Selectividad=Datos_struct.productosSonCompsNo(1);
end
if isempty(Datos_struct.Ref_Rendimiento)||...
        ~ismember(Datos_struct.Ref_Rendimiento,...
        Datos_struct.reactivosSonCompsNo)
    Datos{strcmp(Datos,'Ref_Rendimiento'),2}=...
        Datos_struct.reactivosSonCompsNo(1);
    Datos_struct.Ref_Rendimiento=Datos_struct.reactivosSonCompsNo(1);
end


%
% Variables Dep
VariablesDep = cell(1,4);

Row=0+1;
if strcmp(Datos_struct.Tipo,'CSTR')
    VariablesDep{Row,1}='ESTACIONARIO';
    VariablesDep{Row,2}='NA';
    VariablesDep{Row,4}='';
    Row=Row+1;
end
VariablesDep{Row,1}='[C]';
VariablesDep{Row,2}='gmol/L';
VariablesDep{Row,4}='CONCENTRACION';
for i=1:Datos_struct.nComps
    Row=Row+1;
    VariablesDep{Row,1}=['C',Datos_struct.labels{i}];
    VariablesDep{Row,2}=VariablesDep{Row-i,2};    
end
Row=Row+1;
VariablesDep{Row,1}='[T]';
VariablesDep{Row,2}='K';
VariablesDep{Row,4}='TEMPERATURA';
Row=Row+1;
VariablesDep{Row,1}='T';
VariablesDep{Row,2}=VariablesDep{Row-1,2};
Row=Row+1;
VariablesDep{Row,1}='Ta';
VariablesDep{Row,2}=VariablesDep{Row-1,2};
Row=Row+1;
VariablesDep{Row,1}='[r]';
VariablesDep{Row,2}='mol/(L*min)';
VariablesDep{Row,4}='RAPIDEZ';
for i=1:Datos_struct.nReacs
    Row=Row+1;
    VariablesDep{Row,1}=['r',int2str(i)];
    VariablesDep{Row,2}=VariablesDep{Row-i,2};
end
Row=Row+1;
VariablesDep{Row,1}='[k]';
VariablesDep{Row,2}='(1/min){\times}(gmol/L)^{(1-{\Sigma}_j({\alpha}_{ij}))}';
VariablesDep{Row,4}='CONSTANTE DE RAPIDEZ';
for i=1:Datos_struct.nReacs
    Row=Row+1;
    VariablesDep{Row,1}=['k',int2str(i)];
    VariablesDep{Row,2}=['(1/min){\times}(gmol/L)^{',...
        num2str(1-sum(Datos_struct.Exponentes_r(i,:))),'}'];
end
Row=Row+1;
VariablesDep{Row,1}='[q]';
VariablesDep{Row,2}='K/min';
VariablesDep{Row,4}='CALOR/rhoCp';
Row=Row+1;
VariablesDep{Row,1}='qgen';
VariablesDep{Row,2}=VariablesDep{Row-1,2};
Row=Row+1;
VariablesDep{Row,1}='qrem';
VariablesDep{Row,2}=VariablesDep{Row-1,2};
if strcmp(Datos_struct.Tipo,'PFR')
    Row=Row+1;
    VariablesDep{Row,1}='[q_z]';
    VariablesDep{Row,2}='K/cm';
    VariablesDep{Row,4}='CALOR/rhoCp*Az/Q';
    Row=Row+1;
    VariablesDep{Row,1}='qgen_z';
    VariablesDep{Row,2}=VariablesDep{Row-1,2};
    Row=Row+1;
    VariablesDep{Row,1}='qrem_z';
    VariablesDep{Row,2}=VariablesDep{Row-1,2};
end
Row=Row+1;
VariablesDep{Row,1}='[X]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='CONVERSION';
for i=1:length(Datos_struct.reactivosSonCompsNo)
    Row=Row+1;
    VariablesDep{Row,1}=['X',...
        Datos_struct.labels{Datos_struct.reactivosSonCompsNo(i)}];
    VariablesDep{Row,2}=VariablesDep{Row-i,2};
end
Row=Row+1;
VariablesDep{Row,1}='[Y]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='RENDIMIENTO POR ALIMENTACIï¿½N';
for i=1:length(Datos_struct.productosSonCompsNo)
    Row=Row+1;
    VariablesDep{Row,1}=['Y',...
        Datos_struct.labels{Datos_struct.productosSonCompsNo(i)}];
    VariablesDep{Row,2}='[adim]';
end
Row=Row+1;
VariablesDep{Row,1}='[Yconsumo]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='RENDIMIENTO POR CONSUMO';
for i=1:length(Datos_struct.productosSonCompsNo)
    Row=Row+1;
    VariablesDep{Row,1}=['Yconsumo',...
        Datos_struct.labels{Datos_struct.productosSonCompsNo(i)}];
    VariablesDep{Row,2}='[adim]';
end
Row=Row+1;
VariablesDep{Row,1}='[S]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='SELECTIVIDAD';
for i=1:length(Datos_struct.productosConSelectividad)
    Row=Row+1;
    VariablesDep{Row,1}=['S',...
        Datos_struct.labels{Datos_struct.productosConSelectividad(i)}];
    VariablesDep{Row,2}='[adim]';
end

if strcmp(Datos_struct.Tipo,'PFR')
    Row=Row+1;
    VariablesDep{Row,1}='[F]';
    VariablesDep{Row,2}='gmol/min';
    VariablesDep{Row,4}='FLUJO MOLAR';
    for i=1:Datos_struct.nComps
        Row=Row+1;
        VariablesDep{Row,1}=['F',Datos_struct.labels{i}];
        VariablesDep{Row,2}=VariablesDep{Row-i,2};
    end 
end

Row=Row+1;
VariablesDep{Row,1}='[Q]';
VariablesDep{Row,2}='[L/min]';
VariablesDep{Row,4}='FLUJO';
Row=Row+1;
VariablesDep{Row,1}='Q';
VariablesDep{Row,2}=VariablesDep{Row-1,2};

Row=Row+1;
VariablesDep{Row,1}='Qa';
VariablesDep{Row,2}='[L/min]';

if strcmp(Datos_struct.Tipo,'BR')||...
        strcmp(Datos_struct.Tipo,'SEMIBR')
    Row=Row+1;
    VariablesDep{Row,1}='[V]';
    VariablesDep{Row,2}='[L]';
    VariablesDep{Row,4}='VOLUMEN';
    
    Row=Row+1;
    VariablesDep{Row,1}='Vr';
    VariablesDep{Row,2}='[L]';
end

VariablesXZ=VariablesDep(cellfun(@(x)isempty(x),...
    regexp(VariablesDep(:,1),'\W.+\W')),:);
VariablesXZ=VariablesXZ(cellfun(@(x)isempty(x),...
    regexp(VariablesXZ(:,1),'ESTACIONARIO')),:);
if strcmp(Datos_struct.Tipo,'PFR')
    VariablesXZ=[{'z','cm',false,''};...
        {'t','min',false,''};VariablesXZ];
elseif strcmp(Datos_struct.Tipo,'BR')||...
        strcmp(Datos_struct.Tipo,'SEMIBR')
    VariablesXZ=[{'t','min',false,''};VariablesXZ];
elseif strcmp(Datos_struct.Tipo,'CSTR')
    VariablesXZ=[{'t','min',false,''};VariablesXZ];
    Datos_struct.MostrarEstadosEstacionarios = VariablesDep{...
        strcmp(VariablesDep(:,1),'ESTACIONARIO'),3};
end
VariablesIndep=[{'z','cm',false,''};{'t','min',false,''}];
Datos_struct.VariablesDep=VariablesDep;
Datos_struct.Variables_Todas=[VariablesIndep;VariablesDep];
Datos_struct.VariablesXZ=VariablesXZ;

%
% Calculados
Datos{strcmp(Datos,'delta_Hr_0'),2}=mat2str(Datos_struct.delta_Hr_0);
Datos{strcmp(Datos,'Vr'),2}=Datos_struct.Vr;
if strcmp(Datos_struct.Tipo,'BR')
    Datos{strcmp(Datos,'A'),2}=Datos_struct.A;
elseif strcmp(Datos_struct.Tipo,'SEMIBR')
    Datos{strcmp(Datos,'A'),2}=Datos_struct.A;
elseif strcmp(Datos_struct.Tipo,'CSTR')
    Datos{strcmp(Datos,'A'),2}=Datos_struct.A;
elseif strcmp(Datos_struct.Tipo,'PFR')
    Datos{strcmp(Datos,'a'),2}=Datos_struct.a;
end
    
%Compresible no estacionario no se ha implementado
if strcmp(Datos_struct.Tipo,'PFR') && ...
        ~Datos_struct.Estacionario && ~Datos_struct.Incompresible
    MException('InputError:Conditions',...
        ['PFR, Flujo compresible, estado no estacionario,',...
        ' no implementado en esta versiï¿½n']);
end

Datos_struct.DatosCalc = Datos;