function Vars = obtenerDatos(Datos)

Vars.Tipo.Valor = Datos{strcmp(Datos,'Tipo'),2};

load([pwd,filesep,'DATA',filesep,...
    'TEMPLATE_',Vars.Tipo.Valor,'.mat']);
% Sacar variables de acuerdo con el template
if exist('TEMPLATE','var') == 1
    nombresDeDatos = ...
        intersect(...
        ...
        Datos(cellfun(@(x)...
        find(strcmp(x,Datos(:,1))) ...
        ,TEMPLATE(:,1)),1) ...
        , ...
        Datos(cellfun(@(x)...
        ~strcmp(x,'OPERACIÓN') && ...
        ~strcmp(x,'REACCIÓN') && ...
        ~strcmp(x,'REACTOR') && ...
        ~strcmp(x,'PROPIEDADES') && ...
        ~strcmp(x,'INTEGRACIÓN') && ...
        ~strcmp(x,'EJES') ...
        ,Datos(:,1)),1) ...
        ); %#ok
    Datos_evaluados           = ...
        Datos(cellfun(@(x)...
        find(strcmp(x,Datos(:,1))) ...
        ,nombresDeDatos),:);
    for i=1:size(Datos_evaluados,1)
        if ~isnumeric(Datos_evaluados{i,2}) && ...
                ~islogical(Datos_evaluados{i,2}) && ...
                ~strcmp('Tipo',Datos_evaluados{i,1})
            Datos_evaluados{i,2} = eval(Datos_evaluados{i,2});
        end
        Vars.(Datos_evaluados{i,1}).Valor=Datos_evaluados{i,2};
        Vars.(Datos_evaluados{i,1}).Unidades=Datos_evaluados{i,3};
    end
elseif ~(exist('TEMPLATE','var') == 1)
    %Do nothig
end

% Únicamente extraer explícitamente valores que no están
% en todos los tipos de reactores, y puede ser necesario reordenarlos

Vars.Incompresible.Valor        = logical(Vars.Incompresible.Valor);
Vars.Isot.Valor                 = logical(Vars.Isot.Valor);
Datos{strcmp(Datos,'Incompresible'),2} = ...
    Vars.Incompresible.Valor;
Datos{strcmp(Datos,'Isot'),2}   = ...
    Vars.Isot.Valor;

if isempty(Vars.Incompresible.Valor) ||...
        isempty(Vars.Isot.Valor)
    Vars.Incompresible.Valor    = true;
    Vars.Isot.Valor             = false;
end

if strcmp(Vars.Tipo.Valor,'SEMIBR')|| ...
        strcmp(Vars.Tipo.Valor,'CSTR') || ...
        strcmp(Vars.Tipo.Valor,'BR')
    Vars.Longitud.Valor = 1.5 * Vars.Diam.Valor;
    Vars.A.Valor        = ...
        pi*Vars.Diam.Valor * ...
        Vars.Longitud.Valor * 1/30.48^2;
        
    Vars.Longitud.Unidades  = 'cm';
    Vars.A.Unidades         = 'cm^2';    
end

if strcmp(Vars.Tipo.Valor,'SEMIBR')|| ...
        strcmp(Vars.Tipo.Valor,'CSTR') || ...
        strcmp(Vars.Tipo.Valor,'PFR')
    Vars.theta.Valor        = ...
        Vars.Vr.Valor / Vars.Q0.Valor;
    Vars.uz.Valor           = ...
        Vars.Q0.Valor * 1000 / ...
        (pi/4*Vars.Diam.Valor^2);
    
    Vars.theta.Unidades     = 'min';
    Vars.uz.Unidades        = 'cm/min';
end

if strcmp(Vars.Tipo.Valor,'SEMIBR')
    Vars.Estacionario.Valor = false;
    Vars.C_t0.Valor         = reshape(...
        Vars.C_t0.Valor,...
        1,numel(Vars.C_t0.Valor));    
elseif strcmp(Vars.Tipo.Valor,'CSTR')
    Vars.C_t0.Valor         = reshape(...
        Vars.C_t0.Valor,...
        1,numel(Vars.C_t0.Valor));    
elseif strcmp(Vars.Tipo.Valor,'PFR')
    if Vars.Co_Corriente.Valor
        Vars.factorCoContraCorriente = +1;
    else
        Vars.factorCoContraCorriente = -1;
    end
elseif strcmp(Vars.Tipo.Valor,'BR')
    Vars.Estacionario.Valor = false;
end

Vars.nReacs.Valor       = size(Vars.Coefs_esteq.Valor,1);
Vars.nComps.Valor       = size(Vars.Coefs_esteq.Valor,2);
Vars.delta_Hf.Valor     = reshape(...
    Vars.delta_Hf.Valor*1000,...
    1,Vars.nComps.Valor);
Vars.delta_Hr_0.Valor   = reshape(...
    Vars.Coefs_esteq.Valor * ...
    Vars.delta_Hf.Valor',...
    1,Vars.nReacs.Valor);
Vars.E.Valor            = reshape(...
    Vars.E.Valor,...
    1,Vars.nReacs.Valor);
Vars.k0.Valor           = reshape(...
    Vars.k0.Valor,...
    1,Vars.nReacs.Valor);
Vars.C0.Valor           = reshape(...
    Vars.C0.Valor,...
    1,numel(Vars.C0.Valor));
Vars.Cp_Molares.Valor    = reshape(...
    Vars.Cp_Molares.Valor * 1000,...
    1,numel(Vars.Cp_Molares.Valor * 1000));
Vars.rhoCp_a.Valor      = ...
    Vars.rhoCp_a.Valor * 1000;

Vars.Vr.Valor           = ...
    Vars.Longitud.Valor*pi/4 * ...
    Vars.Diam.Valor^2*1/1000;
Vars.U.Valor            = ...
    Vars.U.Valor * ...
    1055*1/60*9/5;
Vars.Va.Valor           = Vars.Longitud.Valor * ...
    pi/4 * (Vars.Diam_a.Valor^2-Vars.Diam.Valor^2) * ...
    1/1000;
Vars.uza.Valor          = ...
    Vars.Qa0.Valor * 1000 / ...
    (pi/4*(Vars.Diam_a.Valor^2-Vars.Diam.Valor^2));
Vars.a.Valor            = ...
    4/Vars.Diam.Valor * 1/30.48^2 * 1000;
Vars.R.Valor            = 8.3140;


Vars.Cp_Molares.Unidades = 'J/(gmol K)';
Vars.rhoCp_a.Unidades   = 'J/(L K)';
Vars.Vr.Unidades        = 'L';
Vars.U.Unidades         = 'J/(min ft^2 K)';
Vars.uza.Unidades       = 'cm/min';
Vars.Va.Unidades        = 'L';
Vars.a.Unidades         = 'ft^2/L';
Vars.R.Unidades         = 'J/(gmol K)';


characters=char(65:90);

Vars.labels         = ...
    cell(1,min(length(characters),...
    size(Vars.Coefs_esteq.Valor,2)));
Vars.labels_est     = ...
    cell(1,min(length(characters),...
    size(Vars.Coefs_esteq.Valor,2)));
for i=1:length(Vars.labels)
    Vars.labels{i}  = characters(i);
end
for i=1:length(Vars.labels_est)
    Vars.labels_est{i} = [characters(i),'est'];
end

%
% Análisis reactivos - productos
encontrarReactivos          = ...
    find(Vars.Coefs_esteq.Valor < 0);
[~,reactivosSonCompsNo]     = ...
    ind2sub(size(Vars.Coefs_esteq.Valor),...
    encontrarReactivos);
encontrarProductos          = ...
    find(Vars.Coefs_esteq.Valor > 0);
[~,productosSonCompsNo]     = ...
    ind2sub(size(Vars.Coefs_esteq.Valor),...
    encontrarProductos);
Vars.reactivosSonCompsNo        = unique(reactivosSonCompsNo);
Vars.productosSonCompsNo        = unique(productosSonCompsNo);
Vars.productosConSelectividad   = Vars.productosSonCompsNo(...
    Vars.productosSonCompsNo ~= ...
    Vars.Ref_Selectividad.Valor);

if ~ismember(Vars.Ref_Selectividad.Valor,...
        Vars.productosSonCompsNo)
    Datos{strcmp(Datos,'Ref_Selectividad'),2}   =...
        Vars.productosSonCompsNo(1);
    Vars.Ref_Selectividad.Valor                 = ...
        Vars.productosSonCompsNo(1);
end
if ~ismember(Vars.Ref_Rendimiento.Valor,...
        Vars.reactivosSonCompsNo)
    Datos{strcmp(Datos,'Ref_Rendimiento'),2}    =...
        Vars.reactivosSonCompsNo(1);
    Vars.Ref_Rendimiento.Valor                  =...
        Vars.reactivosSonCompsNo(1);
end

%
% Variables Dep
VariablesDep = cell(1,4);

Row=0+1;
if strcmp(Vars.Tipo.Valor,'CSTR')
    VariablesDep{Row,1}='ESTACIONARIO';
    VariablesDep{Row,2}='NA';
    VariablesDep{Row,4}='';
    Row=Row+1;
end
VariablesDep{Row,1}='[C]';
VariablesDep{Row,2}='gmol/L';
VariablesDep{Row,4}='CONCENTRACION';
for i=1:Vars.nComps.Valor
    Row=Row+1;
    VariablesDep{Row,1}=['C',Vars.labels{i}];
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
if strcmp(Vars.Tipo.Valor,'SEMIBR') ||...
        strcmp(Vars.Tipo.Valor,'CSTR')
    Row=Row+1;
    VariablesDep{Row,1}='Ta0';
    VariablesDep{Row,2}=VariablesDep{Row-1,2};
end
Row=Row+1;
VariablesDep{Row,1}='[r]';
VariablesDep{Row,2}='mol/(L*min)';
VariablesDep{Row,4}='RAPIDEZ';
for i=1:Vars.nReacs.Valor
    Row=Row+1;
    VariablesDep{Row,1}=['r',int2str(i)];
    VariablesDep{Row,2}=VariablesDep{Row-i,2};
end
Row=Row+1;
VariablesDep{Row,1}='[k]';
VariablesDep{Row,2}='(1/min){\times}(gmol/L)^{(1-{\Sigma}_j({\alpha}_{ij}))}';
VariablesDep{Row,4}='CONSTANTE DE RAPIDEZ';
for i=1:Vars.nReacs.Valor
    Row=Row+1;
    VariablesDep{Row,1}=['k',int2str(i)];
    VariablesDep{Row,2}=['(1/min){\times}(gmol/L)^{',...
        num2str(1-sum(Vars.Exponentes_r.Valor(i,:))),'}'];
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
if strcmp(Vars.Tipo.Valor,'PFR')
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
for i=1:length(Vars.reactivosSonCompsNo)
    Row=Row+1;
    VariablesDep{Row,1}=['X',...
        Vars.labels{Vars.reactivosSonCompsNo(i)}];
    VariablesDep{Row,2}=VariablesDep{Row-i,2};
end
Row=Row+1;
VariablesDep{Row,1}='[Y]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='RENDIMIENTO POR ALIMENTACIÓN';
for i=1:length(Vars.productosSonCompsNo)
    Row=Row+1;
    VariablesDep{Row,1}=['Y',...
        Vars.labels{Vars.productosSonCompsNo(i)}];
    VariablesDep{Row,2}='[adim]';
end
Row=Row+1;
VariablesDep{Row,1}='[Yconsumo]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='RENDIMIENTO POR CONSUMO';
for i=1:length(Vars.productosSonCompsNo)
    Row=Row+1;
    VariablesDep{Row,1}=['Yconsumo',...
        Vars.labels{Vars.productosSonCompsNo(i)}];
    VariablesDep{Row,2}='[adim]';
end
Row=Row+1;
VariablesDep{Row,1}='[S]';
VariablesDep{Row,2}='[adim]';
VariablesDep{Row,4}='SELECTIVIDAD';
for i=1:length(Vars.productosConSelectividad)
    Row=Row+1;
    VariablesDep{Row,1}=['S',...
        Vars.labels{Vars.productosConSelectividad(i)}];
    VariablesDep{Row,2}='[adim]';
end

if strcmp(Vars.Tipo.Valor,'PFR')
    Row=Row+1;
    VariablesDep{Row,1}='[F]';
    VariablesDep{Row,2}='gmol/min';
    VariablesDep{Row,4}='FLUJO MOLAR';
    for i=1:Vars.nComps.Valor
        Row=Row+1;
        VariablesDep{Row,1}=['F',Vars.labels{i}];
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

if strcmp(Vars.Tipo.Valor,'BR')||...
        strcmp(Vars.Tipo.Valor,'SEMIBR')
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
if strcmp(Vars.Tipo.Valor,'PFR')
    VariablesXZ=[{'z','cm',false,''};...
        {'t','min',false,''};VariablesXZ];
elseif strcmp(Vars.Tipo.Valor,'BR')||...
        strcmp(Vars.Tipo.Valor,'SEMIBR')
    VariablesXZ=[{'t','min',false,''};VariablesXZ];
elseif strcmp(Vars.Tipo.Valor,'CSTR')
    VariablesXZ=[{'t','min',false,''};VariablesXZ];
    Vars.MostrarEstadosEstacionarios = VariablesDep{...
        strcmp(VariablesDep(:,1),'ESTACIONARIO'),3};
end
VariablesIndep=[{'z','cm',false,''};{'t','min',false,''}];
Vars.VariablesDep=VariablesDep;
Vars.Variables_Todas=[VariablesIndep;VariablesDep];
Vars.VariablesXZ=VariablesXZ;

%
% Calculados
Datos{strcmp(Datos,'delta_Hr_0'),2} = ...
    mat2str(Vars.delta_Hr_0.Valor);
Datos{strcmp(Datos,'Vr'),2}         = ...
    Vars.Vr.Valor;
if strcmp(Vars.Tipo.Valor,'BR')
    Datos{strcmp(Datos,'A'),2}=Vars.A.Valor;
elseif strcmp(Vars.Tipo.Valor,'SEMIBR')
    Datos{strcmp(Datos,'A'),2}=Vars.A.Valor;    
elseif strcmp(Vars.Tipo.Valor,'CSTR')
    Datos{strcmp(Datos,'A'),2}=Vars.A.Valor;
    Datos{strcmp(Datos,'Estacionario'),2} = ...
        logical(Vars.Estacionario.Valor);
elseif strcmp(Vars.Tipo.Valor,'PFR')
    Datos{strcmp(Datos,'a'),2}=Vars.a.Valor;
    Datos{strcmp(Datos,'Estacionario'),2} = ...
        logical(Vars.Estacionario.Valor);
    Datos{strcmp(Datos,'Co_Corriente'),2} = ...
        logical(Vars.Co_Corriente.Valor);
end
    
%Compresible no estacionario no se ha implementado
if strcmp(Vars.Tipo.Valor,'PFR') && ...
        ~Vars.Estacionario.Valor && ~Vars.Incompresible.Valor
    MException('InputError:Conditions',...
        ['PFR, Flujo compresible, estado no estacionario,',...
        ' no implementado en esta versiï¿½n']);
end

Vars.Datos_Con_Unidades = Vars;

nombresDeCampos         = fieldnames(Vars);

for i=1:size(nombresDeCampos,1)
    if isfield(Vars.(nombresDeCampos{i}),'Valor')
        Vars.(nombresDeCampos{i}) = Vars.(nombresDeCampos{i}).Valor;
    end
end

Vars.DatosCalc = Datos;