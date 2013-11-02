%% n-CSTR , Perfil óptimo de temperatura.
%  Este programa encuentra la solución de una serie de n CSTR en donde se 
%  llevan a cabo las Reacciones A ==> B , B==>>C, con las siguientes 
%  características:
%  * No estacionario, No Adiabático, No Isotérmico
%  * No estacionario, Adiabático
%  * No estacionario, Isotérmico
%  * Estacionario, No Adiabático
%  * Estacionario, Adiabático
%%
% Este código es de Matlab y es presentado como documento html para 
% facilitar su comprensión. Para ver el código sin formato, <../gui6.m haga
% CLICK aquí>
%%
% *NOTA:* El código relevante a la solución del problema está en la sección
% denominada "CÓDIGO RELEVANTE", el resto son funciones para producir la
% ventana, las tablas, etc.
%%

%% 1. BLOQUE DE CÓDIGO AUTO-GENERADO
function varargout = gui6(varargin)
% gui6 M-file for gui6.fig
%      gui6, by itself, creates a new gui6 or raises the existing
%      singleton*.
%
%      H = gui6 returns the handle to a new gui6 or the handle to
%      the existing singleton*.
%
%      gui6('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui6.M with the given input arguments.
%
%      gui6('Property','Value',...) creates a new gui6 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui6_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui6_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui6

% Last Modified by GUIDE v2.5 23-Jun-2010 18:55:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui6_OpeningFcn, ...
                   'gui_OutputFcn',  @gui6_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before gui6 is made visible.
function gui6_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui6 (see VARARGIN)

% Choose default command line output for gui6
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui6 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% 2. LLAMADA AL CÓDIGO RELEVANTE
codigoRelevante(hObject, eventdata, handles, varargin);






























%% 3. CÓDIGO RELEVANTE
function codigoRelevante(hObject, eventdata, handles, varargin)
%% 
% Llamar al código de arranque
codigoDeArranque(hObject, eventdata, handles, varargin);

function codigoDeArranque(hObject, eventdata, handles, varargin)
%% 3.1 Arranque
% Se ejecuta cada vez que se reinicia el programa.
%%
% Primero definición de variables globales que serán manipuladas por la
% ventana cuando se elige opción de hacer análisis del estado no
% estacionario o estacionario.
global hacerAnalisisEstacionario
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
%%
% *hacerAnalisisEstacionario*     
%%        
%                                  true si se ha seleccionado analizar el 
%                                  estado estacionario. Si no, false.
%%
% *solucionAnalisisEstacionario*  
%%
%                                  Matriz con la solución {'t',t,'Y',Y}
%                                  en el análisis del estado estacionario.
%                                  t es una matriz Nx1 con los puntos de
%                                  tiempo analizado. Y es la matriz Nx3 con
%                                  los valores de {CA,CB,T}
%                                  correspondientes a cada tiempo en t.
%%
% *solucionAnalisisNoEstacionario*
%% 
%                                  Matriz con la solución 
%                                  {'T',T,'CA',CA,'CB',CB,'Urem',Urem} en
%                                  el análisis del estado estacionario. T
%                                  es matriz Nx1 con las temperaturas
%                                  analizadas, CA es matriz Nx1 con
%                                  concentración de A por balance de
%                                  materia y energía en estado
%                                  estacionario, etc.
%%
% En las variables *solucionAnalisisEstacionario* y 
% *solucionAnalisisNoEstacionario* se almacena la solución obtenida en edo.
% estacionario y no estacionario, la cuál no se borrará hasta que se
% modifique alguna de las variables (para evitar recalcular la solución de
% los sistema de ecuaciones diferenciales (no estacionario), algebráicas (
% estacionario) y diferencial algebráicas (no estacionario isotérmico).
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
%%
% Por omisión hace y muestra el análisis del estado estacionario, con la 
% opción de hacer y mostrar el del estado no estacionario.
hacerAnalisisEstacionario=true;
%%
% Cambiar los títulos de las gráficas que es posible hacer a las que se
% hacen en el análisis  del estado estacionario. Estas opciones cambian
% cuando se selecciona el análisis del estado no estacionario.
set(handles.popupmenu1,'String',...
        {'C vs theta';'T vs theta';'urem vs theta';'r vs T';'r vs C'});  
%%
% Al principio cargar las extensiones que se están usando con código para
% la barra de % terminado en la solución de sistemas de EDO's y EDA's.
path(path,'matlab_exts');
%%
% Todas las variables se ponen en una matriz de Nx4, cada fila es una
% variable y tienen las columnas: {'VARIABLE','VALOR','UNIDADES','SECCIÓN'}
gui6_variables_default=cell(1,4);
%%
% Al inicio cargar los valores de las variables especificados en el archivo
% gui6_variables_default.mat
load('gui6_variables_default.mat');
%%
% Poner estos valores en la tabla uitable1 (a la izq.)
set(handles.uitable1,'Data',gui6_variables_default(2:end,1:3));
set(handles.uitable1,'Columnname',gui6_variables_default(1,1:3));
set(handles.uitable1,'Rowname',[]);
%%
% Hacer columna editable únicamente la segunda
set(handles.uitable1,'Columneditable',[false true false]);

%%
% Correr el código para actualizar ( o generar en dado caso) la gráfica
% solicitada.
actualizarGraficas(hObject, eventdata, handles, varargin);


function actualizarGraficas(hObject, eventdata, handles, varargin)
%% 3.2 Actualización de gráficas
% Decide en base a si se quieren ver las gráficas de estacionario o no
% estacionario, qué gráficas generar o tomar una solución ya obtenida si no
% hubo cambio en las variables.
%%
% Las sig. variables se definieron en la sección de Arranque
global hacerAnalisisEstacionario 
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
global Datos
%%
% Correr el código para guardar los datos de la tabla en variables que se
% meterán al modelo matemático (código abajo en sección Obtener datos)
obtenerDatos(hObject, eventdata, handles, varargin);
%%
% Resolver estado estacionario si el valor de la variable
% hacerAnalisisEstacionario es true, o si no entonces resolver el estado
% no estacionario, para hacer las gráficas correspondientes.
if hacerAnalisisEstacionario
    %%
    % Si no se ha resuelto todavía, o cambiaron los valores en la tabla,
    % la variable *solucionAnalisisEstacionario* no tendrá nada todavía y
    % se procede a resolverlo, de otra manera se grafica la solución que ya
    % se obtuvo. Esto evita recalcular innecesariamente.
    if isempty(solucionAnalisisEstacionario)
        %%
        % Obtener la solución del estado estacionario con los valores que 
        % se extrajeron de la tabla, y almacenarlo en la variable
        % *solucionAnalisisEstacionario*. El código de la función está
        % definido abajo.
        solucionAnalisisEstacionario =...
            analisisEdoEst(hObject, eventdata, handles, varargin);
        %%
        % Tomar los valores que ahorita se calcularon y ponerlos en la tabla
        % uitable1.
        set(handles.uitable1,'Data',Datos);
        %%
        % Graficar la solución obtenida.
        graficarEdoEst(hObject, eventdata, handles, varargin);
    else
        %%
        % Graficar la solución previa.
        graficarEdoEst(hObject, eventdata, handles, varargin);
    end
else
    %%
    % Si no se ha resuelto todavía, o cambiaron los valores en la tabla,
    % la variable *solucionAnalisisNoEstacionario* no tendrá nada todavía y
    % se procede a resolverlo, de otra manera se grafica la solución que ya
    % se obtuvo. Esto evita recalcular innecesariamente.
    if isempty(solucionAnalisisNoEstacionario)
         %%
        % Obtener la solución del estado estacionario con los valores que 
        % se extrajeron de la tabla, y almacenarlo en la variable
        % *solucionAnalisisEstacionario*. El código de la función está
        % definido abajo.
        solucionAnalisisNoEstacionario=...
            analisisEdoNoEst(hObject, eventdata, handles, varargin);        
        %%
        % Tomar los valores que ahorita se calcularon y ponerlos en la tabla
        % uitable1.
        set(handles.uitable1,'Data',Datos);
        %%
        % Graficar la solución obtenida.
        graficarEdoNoEst(hObject, eventdata, handles, varargin);
    else
        %%
        % Graficar la solución previa.
        graficarEdoNoEst(hObject, eventdata, handles, varargin);
    end
end



function obtenerDatos(hObject, eventdata, handles, varargin);
%% 3.3 Obtener datos
% Toma los datos de la tabla y los guarda en variables globales para que la
% nueva solución tome los últimos datos que se pusieron en la tabla.
global delta_Hf_A delta_Hf_B delta_Hf_C delta_Hr_1 delta_Hr_2 
global E1 E2 k110 k120 T0ref
global CA00 CB00 CC00 T00 CA0 CB0 CC0 T0 Vr Q0 theta urem n thetaAcum Test
global MA MB rho_Cp R tiempoSoluciones isotermico mismasCondInciales
global calcularTestacionario
global Datos
%%
%  Variables establecidas por la tabla:
%%
% *delta_Hf_A*          
%%
%                       Entalpía de formación de A
%%
% *delta_Hf_B*
%%
%                       Entalpía de formación de B
%%
% *delta_Hf_C*
%%
%                       Entalpía de formación de C
%%
% *delta_Hr_1*
%%
%                       Entalpía de reacción A==>>B
%%
% *delta_Hr_2*
%%
%                       Entalpía de reacción B==>>C
%%
% *E1*
%%
%                       Energía de activación para la reacción A==>>B, para
%                       ecuación de Arrhenius en obtención de constante de
%                       rapidez
%%
% *E2*
%%
%                       Energía de activación para la reacción B==>>C, para
%                       ecuación de Arrhenius en obtención de constante de
%                       rapidez
%%
% *k110*
%%
%                       Valor de constante de rapidez de reacción de
%                       primer orden para la temperatura de referencia
%                       *T0ref*, para la reacción A==>>B
%%
% *k120*
%%
%                       Valor de constante de rapidez de reacción de
%                       primer orden para la temperatura de referencia
%                       *T0ref*, para la reacción B==>>C
%%
% *T0ref*
%%
%                       Temperatura a la cuál   k11(T)=k11(T0ref)=k110
%                                               k12(T)=k12(T0ref)=k120
%%
% *CA00*
%%
%                       Concentración de A en el reactor al tiempo t=0, ó
%                       'CA , t=0'
%%
% *CB00*
%%
%                       Concentración de B en el reactor al tiempo t=0, ó
%                       'CB , t=0'
%%
% *CC00*
%%
%                       Concentración de C en el reactor al tiempo t=0, ó
%                       'CC, t=0'
%%
% *T00*
%%
%                       Temperatura del reactor al tiempo t=0, ó 'T , t=0'
%%
% *CA0*
%%
%                       Concentración de A en la corriente de alimentación
%%
% *CB0*
%%
%                       Concentración de B en la corriente de alimentación
%%
% *CC0*
%%
%                       Concentración de C en la corriente de alimentación
%%
% *T0*
%%
%                       Temperatura de la corriente de alimentación
%%
% *Test*
%%
%                       Temperatura alcanzada en el estado estacionario en
%                       el último reactor de la serie
%%
% *Vr*
%%
%                       Suma de los volúmenes de los reactores de la serie
%                       o volumen de cada reactor de la serie
%%
% *Q0*
%%
%                       Flujo volumétrico de la alimentación
%%
% *theta*
%%
%                       Tiempo de residencia del fluido en el reactor
%%
% *urem*
%%
%                       Cantidad de calor removida al inicio por unidad de
%                       tiempo, expresada en [temperatura]/[tiempo]
%%
% *MA*
%%
%                       Masa molar de A
%%
% *MB*
%%
%                       Masa molar de B
%%
% *rho_Cp*
%%
%                       Producto rho*Cp para la mezcla 
%%
% *tiempoSoluciones*
%%
%                       Tiempo total que se tomará para las soluciones en
%                       estado no estacionario.
%%
% *R*
%%
%                       Constante universal de los gases
%%
% *isotermico*
%%
%                       Seleccionar esta opción para resolver el caso no
%                       estacionario e isotérmico (dT/dt = 0)
%%
% A continuación se asignan las variables globales a partir de los valores
% indicados en la tabla con el nombre correspondiente.
Datos=get(handles.uitable1,'Data');
delta_Hf_A = Datos{strcmp(Datos,'delta Hf A'),2};
delta_Hf_B = Datos{strcmp(Datos,'delta Hf B'),2};
delta_Hf_C = Datos{strcmp(Datos,'delta Hf C'),2};
delta_Hr_1 =  delta_Hf_B-delta_Hf_A;
delta_Hr_2 =  delta_Hf_C-delta_Hf_B;
E1 = Datos{strcmp(Datos,'E1'),2};
E2 = Datos{strcmp(Datos,'E2'),2};
k110 = Datos{strcmp(Datos,'k110'),2};
k120 = Datos{strcmp(Datos,'k120'),2};
T0ref = Datos{strcmp(Datos,'T0ref'),2};
n = Datos{strcmp(Datos,'n'),2};
CA00 = Datos{strcmp(Datos,'CA, t=0'),2};
CB00 = Datos{strcmp(Datos,'CB, t=0'),2};
CC00 = Datos{strcmp(Datos,'CC, t=0'),2};
T00 = Datos{strcmp(Datos,'T, t=0'),2};
CA0 = Datos{strcmp(Datos,'CA0'),2};
CB0 = Datos{strcmp(Datos,'CB0'),2};
CC0 = Datos{strcmp(Datos,'CC0'),2};
T0 = Datos{strcmp(Datos,'T0'),2};
Test = Datos{strcmp(Datos,'Test'),2};
Vr = Datos{strcmp(Datos,'Vr'),2};
Q0 = Datos{strcmp(Datos,'Q0'),2};
urem = Datos{strcmp(Datos,'urem'),2};
MA = Datos{strcmp(Datos,'MA'),2};
MB = Datos{strcmp(Datos,'MB'),2};
rho_Cp = Datos{strcmp(Datos,'rho Cp'),2};
tiempoSoluciones = Datos{strcmp(Datos,'tiempo tot.'),2};
calcularTestacionario= Datos{strcmp(Datos,'Calcular Test'),2};
R = Datos{strcmp(Datos,'R'),2};
isotermico = Datos{strcmp(Datos,'Serie isot.'),2};
mismasCondInciales = Datos{strcmp(Datos,...
    'Reactores iguales'),2};

if isotermico 
    calcularTestacionario= false;
    Datos{strcmp(Datos,'Calcular Test'),2}=false;    
    Datos{strcmp(Datos,'Calcular urem'),2}=true;
    Datos{strcmp(Datos,'Test'),2}=T00;
end

if not(mismasCondInciales)
    CA00 = cell2mat(Datos(strcmp(Datos,'CA, t=0'),[2 3+1:3+n-1]));
    CB00 = cell2mat(Datos(strcmp(Datos,'CB, t=0'),[2 3+1:3+n-1]));
    CC00 = cell2mat(Datos(strcmp(Datos,'CC, t=0'),[2 3+1:3+n-1]));
    T00 = cell2mat(Datos(strcmp(Datos,'T, t=0'),[2 3+1:3+n-1]));
    Vr = cell2mat(Datos(strcmp(Datos,'Vr'),[2 3+1:3+n-1]));
    urem = cell2mat(Datos(strcmp(Datos,'urem'),[2 3+1:3+n-1]));
    Test = cell2mat(Datos(strcmp(Datos,'Test'),[2 3+1:3+n-1]));
    theta = Vr/Q0;
else
    CA00 = CA00*ones(1,n);
    CB00 = CB00*ones(1,n);
    CC00 = CC00*ones(1,n);
    T00 = T00*ones(1,n);
    Vr = Vr*ones(1,n)/n;
    urem = urem*ones(1,n)/n;
    Test = Test*ones(1,n);
    theta = Vr/Q0;
end



%%
% Finalmente se fija que la única manera de cambiar la entalpía de reacción
% será variando las entalpías de formación de A , B y C
Datos{strcmp(Datos,'delta Hr 1'),2}=delta_Hr_1;
Datos{strcmp(Datos,'delta Hr 2'),2}=delta_Hr_2;
%%
% También se fija que la única manera de cambiar el tiempo de residencia
% será cambiando el flujo de alimentación y el volumen de reactor.
Datos{strcmp(Datos,'theta'),2}=sum(theta);
%%
%
thetaAcum=zeros(1,n);
for i=1:n
    thetaAcum(i)=sum(theta(1:i));
end
%%
% El valor de la constante universal de los gases no se podrá variar
Datos{strcmp(Datos,'R'),2}=R;


function resultado = analisisEdoEst(hObject, eventdata, handles, varargin)
%% 3.4.1 Análisis de estado estacionario
% Obtiene la solución del estado estacionario
%%
% El modelo matemático en estado estacionario es algebráico.
%%
% $$-(C_{A,i-1}-C_{A,i})/\theta_i = 
% -k_{110} * exp(-E_1/R(1/T_i-1/T_{0ref}))C_{A,i} $$ 
%%
% $$-(C_{B,i-1}-C_{B,i})/\theta_i = 
% +k_{110} * exp(-E_1/R(1/T_i-1/T_{0ref}))C_{A,i} $$
%%
% $$-k_{120} * exp(-E_2/R(1/T_i-1/T_{0ref}))C_{B,i} $$ 
%%
% $$-(C_{C,i-1}-C_{C,i})/\theta_i = 
% +k_{120} * exp(-E_2/R(1/T_i-1/T_{0ref}))C_{B,i}  $$ 
% ...(dependiente)
%%
% $$-(T_{i-1}-T_i)/\theta_i = {{1} \over {\rho \times Cp}}\times $$
%%
% $$ ((-\Delta H_{r1}) \times k_{110} * exp(-E_1/R(1/T_i-1/T_{0ref}))
% C_{A,i}$$
%%
% $$+(-\Delta H_{r2}) \times k_{120} * exp(-E_2/R(1/T_i-1/T_{0ref}))
% C_{B,i})+urem_i $$

%%
% Las sig. variables globales se definieron en la sección de Obtener datos.
global delta_Hf_A delta_Hf_B delta_Hr_1 delta_Hr_2 E1 E2 k110 k120 T0ref
global CA00 CB00 CC00 T00 CA0 CB0 CC0 T0 Vr Q0 theta urem n thetaAcum Test
global MA MB rho_Cp R tiempoSoluciones isotermico mismasCondInciales 
global CA_i_menos_1 CB_i_menos_1 CC_i_menos_1 T_i_menos_1 thetai uremi
global calcularTestacionario
global Datos
Y=NaN*zeros(n,4);
CA=NaN*zeros(1,n);
CB=NaN*zeros(1,n);
CC=NaN*zeros(1,n);
if calcularTestacionario
    T=NaN*zeros(1,n);    
else
    urem=NaN*zeros(1,n);    
    T=Test;
end
BarraDeEstado=waitbar(0,' ','Name','Resolviendo',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(BarraDeEstado,'canceling',0);
options=optimset('Display','off','TolFun',1.0e-6,'FunValCheck','on');
%%
% Calcular CA y CB por balance de materia en estado estacionario (se
% calculan directamente y la solución algebráica es sencilla).
for reactorNumeroi=1:n
    if getappdata(BarraDeEstado,'canceling')
        break
    end
    waitbar(reactorNumeroi/n,BarraDeEstado,...
        [sprintf('%u',reactorNumeroi) ' de ' sprintf('%u',n) ...
        '(' sprintf('%u',round(reactorNumeroi/n*100)) '%)']);
    if calcularTestacionario
        %%
        % Resolver para T        
        thetai = theta(reactorNumeroi);
        uremi = urem(reactorNumeroi);
        if reactorNumeroi<=1
            CA_i_menos_1 = CA0;
            CB_i_menos_1 = CB0;
            CC_i_menos_1 = CC0;
            T_i_menos_1 = T0;
        else
            CA_i_menos_1 = CA(reactorNumeroi-1);
            CB_i_menos_1 = CB(reactorNumeroi-1);
            CC_i_menos_1 = CC(reactorNumeroi-1);
            T_i_menos_1 = T(reactorNumeroi-1);
        end
        y0=[CA_i_menos_1 CB_i_menos_1 CC_i_menos_1 T_i_menos_1];
        [Y(reactorNumeroi,:),~,x,exitflag]=...
            lsqnonlin(@f_est,y0,[0 0 0 0],[],options);
        if exitflag~=1
            ajuste=fit([0 thetaAcum(1:reactorNumeroi)]',...
                [T0; Y(1:reactorNumeroi,4)],fittype('pchipinterp'));
            y0=[CA_i_menos_1 CB_i_menos_1...
                CC_i_menos_1 ajuste(reactorNumeroi)];
            [Y(reactorNumeroi,:),~,x,exitflag]=...
                lsqnonlin(@f_est,y0,[],[],options);
            while exitflag~=1
                figure2=figure('MenuBar','none');
                axes2=axes;
                set(figure2,'CurrentAxes',axes2);
                plot(axes2,[0 thetaAcum(1:reactorNumeroi-1)],...
                    [T0 Y(1:reactorNumeroi-1,4)'],'*',...
                    [0 thetaAcum(1:reactorNumeroi)],...
                    ajuste([0 thetaAcum(1:reactorNumeroi)]),'--' );
                xlim([0 thetaAcum(reactorNumeroi)]);
                xlabel(axes2,'theta, min');
                ylabel(axes2,'T,°K');
%                 addaxes('off');
%                 addaxes('XFun',...
%                     @(x)interp1([0 thetaAcum],0:n,x,'linear','extrap'));
                try
                    stringCellArray=inputdlg(...
                        ['Estimar temp. °K manualmente para Reactor '...
                        sprintf('%u',reactorNumeroi) ', theta= '...
                        sprintf('%u',thetaAcum(reactorNumeroi))],...
                        'Estimar T',1,{sprintf('%f',2.5*T_i_menos_1)});
                    if isempty(stringCellArray)
                        Y(reactorNumeroi,:)=...
                            NaN*zeros(1,length(Y(reactorNumeroi,:)));
                        delete(axes2,figure2);
                        break
                    else
                        T_i_menos_1_manual=eval(stringCellArray{1});
                    end
                catch excepcion
                    T_i_menos_1_manual=2.5*T_i_menos_1;
                end
                delete(axes2,figure2);
                y0=[CA_i_menos_1 CB_i_menos_1 CC_i_menos_1,...
                    T_i_menos_1_manual];
                [Y(reactorNumeroi,:),~,x,exitflag]=...
                    lsqnonlin(@f_est,y0,[],[],options);
            end
            if any(isnan(Y(reactorNumeroi,:)))
                break
            end
        end    
        CA(reactorNumeroi)=Y(reactorNumeroi,1);
        CB(reactorNumeroi)=Y(reactorNumeroi,2);
        CC(reactorNumeroi)=Y(reactorNumeroi,3);
        T(reactorNumeroi)=Y(reactorNumeroi,4);
    else        
        %%
        % Resolver para urem, es solución directa porque la serie de T ya
        % se conoce para todos los reactores
        thetai = theta(reactorNumeroi);
        Ti = T(reactorNumeroi);
        if reactorNumeroi<=1
            CA_i_menos_1 = CA0;
            CB_i_menos_1 = CB0;
            CC_i_menos_1 = CC0;
            T_i_menos_1 = T0;
        else
            CA_i_menos_1 = CA(reactorNumeroi-1);
            CB_i_menos_1 = CB(reactorNumeroi-1);
            CC_i_menos_1 = CC(reactorNumeroi-1);
            T_i_menos_1 = T(reactorNumeroi-1);
        end        
        CA(reactorNumeroi)=(CA_i_menos_1/thetai)/(1/thetai+k11(Ti));
        CB(reactorNumeroi)=...
            (CB_i_menos_1/thetai+CA(reactorNumeroi)*k11(Ti))/...
            (1/thetai+k12(Ti));
        CC(reactorNumeroi)=...
            (CC_i_menos_1/thetai+CB(reactorNumeroi)*k12(Ti))/(1/thetai);
        urem(reactorNumeroi)=-(T_i_menos_1-Ti)/thetai+...
            -1/(rho_Cp)*(+(-delta_Hr_1)*k11(Ti)*CA(reactorNumeroi)+...
            (-delta_Hr_2)*k12(Ti)*CA(reactorNumeroi));
    end
end
r1=+k11(T).*CA;
r2=+k12(T).*CB;
delete(BarraDeEstado);
Test=T;
%%
% Regresar matriz con la solución del modelo para cada temperatura que se
% fijó (independiente)
resultado = {'T',T,'CA',CA,'CB',CB, 'CC', CC,'urem',urem,'r1',r1,'r2',r2};

function graficarEdoEst(hObject, eventdata, handles, varargin)
%% 3.4.2 Graficar estado estacionario
% Grafica la solución del estado estacionario
%%
% Las sig. variables globales se definieron en la sección de Obtener datos.
global CA00 CB00 CC00 T00 CA0 CB0 CC0 T0 Vr Q0 theta urem n thetaAcum Test
%%
% Esta variable *solucionAnalisisEstacionario* se definió en la sección
% Arranque y almacena la solución del estado estacionario en la forma 
% {'T',T,'CA',CA,'CB',CB,'Urem',Urem}
global solucionAnalisisEstacionario
%%
% Extraer de la solución las series de valores de cada variable para poder 
% hacer las gráficas correspondientes. Se usa la función find y strcmp 
% porque la convención fue poner el nombre de la variable como String (tipo
% de variable de texto ) y el siguiente elemento la matriz con los valores 
% de ésta. 
%% 
% strcmp compara la matriz de solución con el texto que está como segundo
% parámetro y regresa una matriz del tamaño de la matriz de solución, con
% ceros donde no es igual el texto y unos donde sí es igual
%%
% find regresa los índices de los elementos que no son cero, se le suma 1
% porque el siguiente elemento del texto es ya la tabla de valores de la
% variable.
T=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'T'))+1};
CA=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CA'))+1};
CB=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CB'))+1};
CC=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CC'))+1};
urem=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'urem'))+1};
r1=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'r1'))+1};
r2=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'r2'))+1};
%%
% Escoger colores para graficar.
set(0,'DefaultAxesColorOrder',...
    [0.4,0.5,0.6 ; 0.2,0.3,0.4 ; [102,204,0]/255]);
%%
% Esta parte es para decidir qué se graficará contra qué, ya que hay una
% caja popmenu1 con opciones para graficar , conteniendo las opciones  {'C
% vs urem';'T vs urem';'C vs T';'T vs C'}
numeroDeOpcion = get(handles.popupmenu1,'Value');
opciones = get(handles.popupmenu1,'String');
opcionSeleccionada = opciones{numeroDeOpcion};
%%
% En base a la opción que en este momento muestra la caja de opciones
% popmenu1, graficar las variables correspondientes.
switch opcionSeleccionada
    case 'C vs theta'
        plot(handles.axes1,[0 thetaAcum],[CA0 CA],'--s',...
            [0 thetaAcum],[CB0 CB],'--*',...
            [0 thetaAcum],[CC0 CC],'--.');
        limitesYAuto=get(handles.axes1,'YLim');
        if any(limitesYAuto<0)
           set(handles.axes1,'YLim',[0 limitesYAuto(2)]); 
        end        
        set(handles.axes1,'XLim',[0 sum(theta)]);
        xlabel(handles.axes1,'theta, min');
        ylabel(handles.axes1,'Conc., mol/L');        
        legend(handles.axes1,...
            'CA vs \theta','CB vs \theta','CC vs \theta',...
            'Location','NorthOutside');
%         addaxes('off');
%         addaxes('XFun',@(x)interp1([0 thetaAcum],0:n,x,'linear','extrap'));
    case 'T vs theta'
        plot(handles.axes1,[0 thetaAcum],[T0 T],'--s');
        xlabel(handles.axes1,'theta, min');
        ylabel(handles.axes1,'T, °K');
        set(handles.axes1,'XLim',[0 sum(theta)]);
        legend(handles.axes1,'T vs theta','Location','NorthOutside');
%         addaxes('off');
%         addaxes('XFun',@(x)interp1([0 thetaAcum],0:n,x,'linear','extrap'));
    case 'urem vs theta'
        plot(handles.axes1,thetaAcum,urem,'--s');
        xlabel(handles.axes1,'theta, min');
        ylabel(handles.axes1,'urem, °K/min');
        set(handles.axes1,'XLim',[0 sum(theta)]);
        legend(handles.axes1,'urem vs theta','Location','NorthOutside');
%         addaxes('off');
%         addaxes('XFun',@(x)interp1([0 thetaAcum],0:n,x,'linear','extrap'));
    case 'r vs T'
        plot(handles.axes1,T,r1,'-s',T,r2,'*-');
        xlabel(handles.axes1,'T, °K');
        ylabel(handles.axes1,'r, mol/(L min)');
        legend(handles.axes1,{'r1 vs T','r2 vs T'},...
            'Location','NorthOutside');
    case 'r vs C'
        plot(handles.axes1,CA,r1,'-s',CB,r2,'*-');
        xlabel(handles.axes1,'C, mol/L');
        ylabel(handles.axes1,'r, mol/(L min)');
        legend(handles.axes1,{'r1 vs CA','r2 vs CB'},...
            'Location','NorthOutside');
end

title(handles.axes1,'Estado Estacionario');
%%
% Regresar a los colores default para las gráficas.
set(0,'DefaultAxesColorOrder','remove');
datacursormode on;

function resultado = analisisEdoNoEst(hObject, eventdata, handles, varargin)
%% 3.5.1 Análisis de estado no-estacionario
% Obtiene la solución del estado no-estacionario
%%
% El modelo matemático en estado no-estacionario es un sistema de
% ecuaciones diferenciales ordinarias (ODE ó EDO) en el caso no isotérmico,
% y en el caso isotérimico (dT/dt=0), un sistema de ecuaciones
% diferencial-algebráicas (DAE ó EDA); con condiciones inciales (en t=0, CA
% = CA(t=0) , CB=CB(t=0), CC=CC(t=0), T=T(t=0) ó urem=urem(t=0)).

%%
% $${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta = 
% -k_{10} * exp(-E/R(1/T-1/T_{0ref}))C_A $$
%%
% $${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta = 
% +k_{10} * exp(-E/R(1/T-1/T_{0ref}))C_A $$ ...(dependiente)
%%
% $${{d T}\over{d t}}-(T_0-T)/\theta = {{\Delta H_r} \over {\rho \times Cp}}
% \times k_{10} * exp(-E/R(1/T-1/T_{0ref}))C_A +urem(t)$$
%%
% *Casos*:
%%
%  * Adiabático: urem(t) = 0.   Necesariamente  dT/dt != 0 porque el calor
%                               producido por la reacción al no salir del 
%                               sistema sólo puede calentar la mezcla (si 
%                               es reacción exotérmica)
%  * Isotérmico: dT/dt = 0.     Necesariamente urem(t) != 0 porque el calor
%                               producido por la reacción debe equilibrarse
%                               entonces con el calor removido, y se debe
%                               sacar la misma cantidad de calor que la que
%                               se genera por unidad de tiempo.
%                               Puesto que con esta modificación la tercera
%                               ecuación ya no es diferencial, el sistema a
%                               resolver es un sistema de ecuaciones
%                               diferencial-algebráicas, ya que las dos
%                               primeras ecuaciones sí son diferenciales.
%  * No isotérmico, no adiabático:  tal como se planteó. urem(t) es función
%                                   del tiempo y también lo es T(t).
%%
% Las sig. variables globales se definieron en la sección de Obtener datos.
global CA00 CB00 T00 CA0 CB0 T0 Vr Q0 theta urem
global MA MB rho_Cp R tiempoSoluciones isotermico

%%
% En Matlab es posible definir el sistema de ecuaciones
% diferencial-algebráicas (EDA) de manera muy similar a uno de ecuaciones
% diferenciales ordinarias (EDO), si se hace por medio de una matriz masa
% M(t). Se usará este método para aclarar el código.
%%
% Consta en expresar el sistema en la forma *M(t)y' = f(t)*, donde:
%%
% El lado *izquierdo* de la ecuación es un vector columna con toda la parte
% diferencial del sistema de EDO o EDA
%%
% El lado *derecho* de la ecuación es un vector columna con toda la parte
% no diferencial del sistema de EDO o EDA 
%%
% Puesto que el caso no isotérmico requiere la solución de las variables
% [CA CB T], mientras que en el isotérmico T es conocida T(t)=T(t=0) y se
% requiere la solución de las variables [CA CB urem], se hace diferente
% definición en cada caso para y',  f(t). Ver abajo cada una.
if isotermico
    %%
    % En este caso la temperatura se fija desde el principio, ya que 
    % T(t)=T(t=0), y entonces las tres variables a resolver son CA(t),
    % CB(t), urem(t).
    %%
    % Definiciones:
    %%
    % *t*
    %%
    %               Tiempo, variable independiente
    %%
    % *y*
    %%
    %               Vector columna con las variables dependientes: 
    %               [CA CB urem]
    %%
    % *y'*
    %%
    %               Vector columna con las diferenciales respecto del
    %               tiempo de cada una de las variables dependientes:
    %               [dCA/dt dCB/dt durem/dt]
    %%
    % *M(t)*
    %%
    %               Matriz masa, donde cada elemento puede ser función del
    %               tiempo pero en este caso son sólo unos y ceros. Es de 
    %               tamaño 3x3 y es tal que multiplicando ésta por el 
    %               vector columna *y'*, se obtiene el lado izquierdo del
    %               sistema de ecuaciones diferenciales, con toda la parte
    %               izquierda. Entonces en este caso:
    %               M(t)=[1 0 0;0 1 0;0 0 0]
    %               Por lo que el lado izquierdo del sistema de ecuaciones 
    %               queda: *M(t)y'* = [dCA/dt dCB/dt 0] 
    %               Esto significa que en el sistema de ecuaciones no hay
    %               derivada respecto del tiempo de urem(t). La tercera
    %               ecuación es algebráica.
    %%
    % *f(t)*
    %%
    %               Vector columna con las funciones que componen el lado
    %               derecho de cada una de las ecuaciones del sistema de
    %               ecuaciones diferenciales ordinarias (EDO) o ecuaciones
    %               diferencial-algebráicas (EDA) que se resolverá. Para 
    %               hacer esta evaluación
    %%
    % Establecer la matriz masa M(t)
    M=[1 0 0; 0 1 0; 0 0 0];    
    %%
    %  Opciones:
    %  M             Matriz masa. Se pone en las opciones del solver. 
    %  'OutpuFcn'    En este caso se agrega porque la función @odeprog
    %                contenida en el folder matlab_exts es la que tiene el 
    %                código para desplegar una barra de porcentaje resuelto 
    %                para ue en los casos en la  que la solución sea lenta, 
    %                se pueda saber qué tanto se ha resuelto. 
    %  'Events'      En este caso se agrega para pedir que si el sistema no
    %                tiene solución o hay un error simplemente deje de
    %                intentar y no trabe al sistema, llama a la función 
    %                @odeabort.
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,'Events',@odeabort);
    %%
    % Matlab tiene varias funciones para resolver sistemas de EDO's.
    % La recomendada para cuando no se conoce el sistema bien es ode45, 
    % pero en este caso esa función alcanza la solución muy lentamente ya
    % que este sistema de ecuaciones es conocido como 'rígido', o 'stiff'. 
    % La función recomendada en esos casos es *ode15s*.
    %%
    %  Parámetros:
    %  @f_isot              Función definida más abajo que calcula y 
    %                       regresa la matriz que comprende el lado derecho 
    %                       del sistema de ecuaciones. Es diferente que la
    %                       función para el caso no isotérmico porque en
    %                       este caso una de las variables es urem, y en el
    %                       otro es T.
    %  [0,tiempoSoluciones] Intervalo de tiempo (variable independiente)
    %                       para el cuál se encontrará la solución.
    %  [CA00,CB00,urem]     Condiciones iniciales, en t=0.
    %  odeOptions           Las opciones que se pusieron arriba.
    [t,Y]=ode15s(@f_isot,[0,tiempoSoluciones],[CA00,CB00,urem],odeOptions);
    %%
    % Para cumplir con ser de la forma Y=[CA(t) CB(t) T(t) urem(t)], igual 
    % que para el caso no isotérmico, se hace un reordenamiento.
    Y(:,4)=Y(:,3);
    Y(:,3)=T00;
else
    %%
    % Si el sistema es No isotérmico, y = [CA CB urem] y el sistema es un
    % sistema de ecuaciones diferenciales M(t)y'=f(t)
    %%
    % Definiciones:
    %%
    % *t*
    %%
    %               Tiempo, variable independiente
    %%
    % *y*
    %%
    %               Vector columna con las variables dependientes: 
    %               [CA CB T]
    %%
    % *y'*
    %%
    %               Vector columna con las diferenciales respecto del
    %               tiempo de cada una de las variables dependientes:
    %               [dCA/dt dCB/dt dT/dt]
    %%
    % *M(t)*
    %%
    %               Matriz masa, donde cada elemento puede ser función del
    %               tiempo pero en este caso son sólo unos y ceros. Es de 
    %               tamaño 3x3 y es tal que multiplicando ésta por el 
    %               vector columna *y'*, se obtiene el lado izquierdo del
    %               sistema de ecuaciones diferenciales, con toda la parte
    %               izquierda. Entonces en este caso:
    %               M(t)=[1 0 0;0 1 0;0 0 1] (Matriz identidad de 3x3)
    %               Por lo que el lado izquierdo del sistema de ecuaciones 
    %               queda: *M(t)y'* = [dCA/dt dCB/dt dT/dt] 
    %%
    % *f(t)*
    %%
    %               Vector columna con las funciones que componen el lado
    %               derecho de cada una de las ecuaciones del sistema de
    %               ecuaciones diferenciales ordinarias (EDO) o ecuaciones
    %               diferencial-algebráicas (EDA) que se resolverá. Para hacer
    %               esta evaluación
    %%
    % Establecer la matriz masa M(t)
    M=[1 0 0; 0 1 0; 0 0 1];
    %%
    %  Opciones:
    %  M             Matriz masa. Se pone en las opciones del solver. 
    %  'OutpuFcn'    En este caso se agrega porque la función @odeprog
    %                contenida en el folder matlab_exts es la que tiene el 
    %                código para desplegar una barra de porcentaje resuelto 
    %                para ue en los casos en la  que la solución sea lenta, 
    %                se pueda saber qué tanto se ha resuelto. 
    %  'Events'      En este caso se agrega para pedir que si el sistema no
    %                tiene solución o hay un error simplemente deje de
    %                intentar y no trabe al sistema, llama a la función 
    %                @odeabort.
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,'Events',@odeabort);
    %%
    % Matlab tiene varias funciones para resolver sistemas de EDO's.
    % La recomendada para cuando no se conoce el sistema bien es ode45, 
    % pero en este caso esa función alcanza la solución muy lentamente ya
    % que este sistema de ecuaciones es conocido como 'rígido', o 'stiff'. 
    % La función recomendada en esos casos es *ode15s*.
    %%
    %  Parámetros:
    %  @f                   Función definida más abajo que calcula y 
    %                       regresa la matriz que comprende el lado derecho 
    %                       del sistema de ecuaciones.
    %  [0,tiempoSoluciones] Intervalo de tiempo (variable independiente)
    %                       para el cuál se encontrará la solución.
    %  [CA00,CB00,T00]      Condiciones iniciales, en t=0.
    %  odeOptions           Las opciones que se pusieron arriba.
    [t,Y]=ode15s(@f,[0,tiempoSoluciones],[CA00,CB00,T00],odeOptions);
    %%
    % Para cumplir con ser de la forma Y=[CA(t) CB(t) T(t) urem(t)], igual 
    % que para el caso isotérmico, se agrega la función urem(t) al final
    % como cuarto elemento.
    Y(:,4)=urem;
end
%%
% Regresar matriz [t,Y]
resultado={'t',t,'Y',Y};

function graficarEdoNoEst(hObject, eventdata, handles, varargin);
%% 3.5.2 Graficar estado no-estacionario
% Grafica la solución del estado no-estacionario
%%
% Las sig. variables globales se definieron en la sección de Obtener datos.
global urem
%%
% Esta variable *solucionAnalisisEstacionario* se definió en la sección
% Arranque y almacena la solución del estado estacionario en la forma 
% {'T',T,'CA',CA,'CB',CB,'Urem',Urem}
global solucionAnalisisNoEstacionario
%%
% Extraer de la solución las series de valores de cada variable para poder 
% hacer las gráficas correspondientes. Se usa la función find y strcmp 
% porque la convención fue poner el nombre de la variable como String (tipo
% de variable de texto ) y el siguiente elemento la matriz con los valores 
% de ésta. 
%% 
% strcmp compara la matriz de solución con el texto que está como segundo
% parámetro y regresa una matriz del tamaño de la matriz de solución, con
% ceros donde no es igual el texto y unos donde sí es igual
%%
% find regresa los índices de los elementos que no son cero, se le suma 1
% porque el siguiente elemento del texto es ya la tabla de valores de la
% variable.
t=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'t'))+1};
Y=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'Y'))+1};
%%
% Escoger colores para graficar.
set(0,'DefaultAxesColorOrder',[0.2,0.5,0.8 ; 0.8,0.5,0.1]);
%%
% Esta parte es para decidir qué se graficará contra qué, ya que hay una
% caja popmenu1 con opciones para graficar , conteniendo las opciones  {'C
% vs urem';'T vs urem';'C vs T';'T vs C'}
numeroDeOpcion = get(handles.popupmenu1,'Value');
opciones = get(handles.popupmenu1,'String');
opcionSeleccionada = opciones{numeroDeOpcion};
%%
% En base a la opción que en este momento muestra la caja de opciones
% popmenu1, graficar las variables correspondientes.
switch opcionSeleccionada
    case 'C vs t'       
        plot(handles.axes1,t,Y(:,1),t,Y(:,2));
        xlabel('t, min');
        ylabel('Conc., mol/L');
        legend('CA','CB');
    case 'T vs t'
        plot(handles.axes1,t,Y(:,3));
        xlabel('t, min');
        ylabel('T, °K');
        legend('T, °K');
    case 'urem vs t'
        plot(handles.axes1,t,Y(:,4));
        xlabel('t, min');
        ylabel('urem, °K/min');
    case 'C vs T'
        plot(handles.axes1,Y(:,3),Y(:,1),'s',Y(:,3),Y(:,2),'*');
        xlabel('T, °K');
        ylabel('Conc., mol/L');
        legend('T vs CA','T vs CB');    
end

title('Estado No Estacionario');
set(0,'DefaultAxesColorOrder','remove');

%% 4. SUBFUNCIONES
% Estas subfunciones se usan recurrentemente por las funciones de análisis
% de estado estacionario y no estacionario.
%%

function resultado = f(t,y)
%% 4.1.1 Función objetivo Estado No-Estacionario, No Isotérmico
% Para el estado no estacionario, es la parte no-diferencial de las
% ecuaciones que resultaron del balances de materia y energía, en caso no
% isotérmico y no adiabático, o adiabático (si urem(t)=0)
global delta_Hf_A delta_Hf_B delta_Hr E k10 T0ref
global CA00 CB00 T00 CA0 CB0 T0 Vr Q0 theta urem
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableció en la sección de Análisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es T(z)
resultado = [...
    (CA0-y(1))/theta-k11(y(4))*y(1);
    (CB0-y(2))/theta+k11(y(4))*y(1)-k12(y(4))*y(2);
    (CC0-y(3))/theta+k12(y(4))*y(2);
    (T0-y(4))/theta+1/(rho_Cp)*(+(-delta_Hr_1)*k11(y(4))*y(1)+...
    (-delta_Hr_2)*k12(y(4))*y(2));...
    ];

function resultado = f_isot(t,y)
%% 4.1.2 Función objetivo Estado No-Estacionario, Isotérmico
% Para el estado no estacionario, es la parte no-diferencial de las
% ecuaciones que resultaron del balances de materia y energía, en caso 
% isotérmico
global delta_Hf_A delta_Hf_B delta_Hr E k10 T0ref
global CA00 CB00 T00 CA0 CB0 T0 Vr Q0 theta 
global MA MB rho_Cp R tiempoSoluciones

%%
%  La manera en que se estableció en la sección de Análisis de estado no-
% estacionario es y = [CA CB urem]. Por lo tanto:
% y(1) es CA(t)
% y(2) es CB(t)
% y(3) es urem(t)
resultado = [...
    (CA0-y(1))/theta-k1(T00)*y(1);
    (CB0-y(2))/theta+k1(T00)*y(1);
    (T0-T00)/theta-delta_Hr/rho_Cp*k1(T00)*y(1)+y(3);...
    ];

function resultado = f_est(y)
%% 4.1.3 Función objetivo Estado Estacionario
% Para el estado no estacionario, es la parte no-diferencial de las
% ecuaciones que resultaron del balances de materia y energía, en caso no
% isotérmico y no adiabático, o adiabático (si urem(t)=0)
global delta_Hf_A delta_Hf_B delta_Hr_1 delta_Hr_2 E1 E2 k110 k120 T0ref
global CA00 CB00 CC00 T00 CA0 CB0 CC0 T0 Vr Q0 theta urem n thetaAcum Test
global MA MB rho_Cp R tiempoSoluciones isotermico mismasCondInciales
global CA_i_menos_1 CB_i_menos_1 CC_i_menos_1 T_i_menos_1 thetai uremi
%%
%  La manera en que se estableció en la sección de Análisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CAi
% y(2) es CBi
% y(3) es CCi
% y(4) es Ti
resultado = [...
    (CA_i_menos_1-y(1))/thetai-k11(y(4))*y(1);
    (CB_i_menos_1-y(2))/thetai+k11(y(4))*y(1)-k12(y(4))*y(2);
    (CC_i_menos_1-y(3))/thetai+k12(y(4))*y(2);    
    (T_i_menos_1-y(4))/thetai+1/(rho_Cp)*(+(-delta_Hr_1)*k11(y(4))*y(1)+...
    (-delta_Hr_2)*k12(y(4))*y(2))+uremi;...
    CA_i_menos_1+CB_i_menos_1+CC_i_menos_1-y(3)-y(2)-y(1);...
    ];

function k11 = k11(T)
%% 4.2.1 Expresión de Arrhenius
% k de T por expr. de Arrhenius
global k110 E1 R T0ref
k11 = k110*exp(-E1/R*(1./T-1/T0ref));

function k12 = k12(T)
%% 4.2.2 Expresión de Arrhenius
% k de T por expr. de Arrhenius
global k120 E2 R T0ref
k12 = k120*exp(-E2/R*(1./T-1/T0ref));
































%% 5. BLOQUE DE CÓDIGO PARA MANEJO DE TABLAS, MENÚS, ETC.
% --- Outputs from this function are returned to the command line.
function varargout = gui6_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
global delta_Hf_A delta_Hf_B delta_Hr_1 delta_Hr_2 E1 E2 k110 k120 T0ref
global CA00 CB00 CC00 T00 CA0 CB0 CC0 T0 Vr Q0 theta urem n thetaAcum Test
global MA MB rho_Cp R tiempoSoluciones isotermico mismasCondInciales
Datos = get(handles.uitable1,'Data');
nombresDeColumnas=get(handles.uitable1,'Columnname');
columnasEditables=get(handles.uitable1,'Columneditable');
solucionAnalisisNoEstacionario={};
solucionAnalisisEstacionario={};
% leyenda = get(legend,'String');
variableModificada = Datos{eventdata.Indices(1),1};
noSeInsertoUnNumero = not(isnumeric(eventdata.NewData))&&...
    not(islogical(eventdata.NewData))&&...
    not(ischar(eventdata.NewData)) ||any(isnan(eventdata.NewData));
if noSeInsertoUnNumero
    Datos{eventdata.Indices(1),eventdata.Indices(2)}=...
        eventdata.PreviousData;    
    set(handles.uitable1,'Data',Datos);
else
% leyenda = {leyenda{:,1:end},[variableModificada,'==',...
%     num2str(eventdata.PreviousData) ]};
switch variableModificada
    case 'Reactores iguales'
        if not(eventdata.NewData)
            mismasCondInciales=false;
            Datos(strcmp(Datos,'Vr'),2)={Datos{strcmp(Datos,'Vr'),2}/n};
            Datos(strcmp(Datos,'urem'),2)=...
                {Datos{strcmp(Datos,'urem'),2}/n};
            Datos(:,n+3-1)={[]};
            for i=2:n
                Datos(strcmp(Datos,'CA, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'CA, t=0'),2);
                Datos(strcmp(Datos,'CB, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'CB, t=0'),2);
                Datos(strcmp(Datos,'CC, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'CC, t=0'),2);
                Datos(strcmp(Datos,'T, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'T, t=0'),2);
                Datos(strcmp(Datos,'Test'),3+i-1)=...
                    Datos(strcmp(Datos,'Test'),2);
                Datos(strcmp(Datos,'Vr'),3+i-1)=...
                    Datos(strcmp(Datos,'Vr'),2);
                Datos(strcmp(Datos,'urem'),3+i-1)=...
                    Datos(strcmp(Datos,'urem'),2);
                Datos(strcmp(Datos,'theta'),3+i-1)=...
                    {theta(i)};
                nombresDeColumnas{3+i-1}=['Reactor ' ...
                    sprintf('%u',i) ];
            end
            columnasEditables=[columnasEditables true(1,n-1)];
            nombresDeColumnas{2}='Reactor 1';
        else
            mismasCondInciales=true;
            Datos(strcmp(Datos,'Vr'),2)=...
                {sum(cell2mat(Datos(strcmp(Datos,'Vr'),[2 3+1:3+n-1])))};
            Datos(strcmp(Datos,'urem'),2)=...
                {sum(cell2mat(Datos(strcmp(Datos,'urem'),[2 3+1:3+n-1])))};
            Datos=Datos(:,1:3);
            columnasEditables=[false true false];
            nombresDeColumnas{2}='Valor';
            nombresDeColumnas=nombresDeColumnas(1:3);
        end        
    case 'n'
        if not(mismasCondInciales)
            Datos(:,n+3-1)={[]};
            for i=2:n
                Datos(strcmp(Datos,'CA, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'CA, t=0'),2);
                Datos(strcmp(Datos,'CB, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'CB, t=0'),2);
                Datos(strcmp(Datos,'CC, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'CC, t=0'),2);
                Datos(strcmp(Datos,'T, t=0'),3+i-1)=...
                    Datos(strcmp(Datos,'T, t=0'),2);
                Datos(strcmp(Datos,'Test'),3+i-1)=...
                    Datos(strcmp(Datos,'Test'),2);
                Datos(strcmp(Datos,'Vr'),3+i-1)=...
                    Datos(strcmp(Datos,'Vr'),2);
                Datos(strcmp(Datos,'urem'),3+i-1)=...
                    Datos(strcmp(Datos,'urem'),2);
                nombresDeColumnas{3+i-1}=['Valor, i=' ...
                    sprintf('%u',i)];
            end
        end
    case 'Calcular urem'
        Datos{strcmp(Datos,'Calcular Test'),2}=not(eventdata.NewData);
    case 'Calcular Test'
        Datos{strcmp(Datos,'Calcular urem'),2}=not(eventdata.NewData);
    case 'delta Hf A'
        
    case 'delta Hf B'
        
    case 'delta Hr'
        
end
set(handles.uitable1,'Data',Datos);
set(handles.uitable1,'Columnname', nombresDeColumnas);
set(handles.uitable1,'Columneditable',columnasEditables);
actualizarGraficas(hObject, eventdata, handles);
end



% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hacerAnalisisEstacionario
if hacerAnalisisEstacionario
    set(handles.Untitled_1,'Label','No Estacionario ==> Estacionario');
    set(handles.popupmenu1,'String',...
        {'C vs t';'T vs t';'urem vs t';'C vs T'});
    hacerAnalisisEstacionario=false;
    actualizarGraficas(hObject, eventdata, handles);
else
    set(handles.Untitled_1,'Label','Estacionario ==> No Estacionario');
    set(handles.popupmenu1,'String',...
        {'C vs theta';'T vs theta';'r vs T';'r vs C'});    
    hacerAnalisisEstacionario=true;
    actualizarGraficas(hObject, eventdata, handles);
end


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
actualizarGraficas(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_3_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('./html/gui6.html','-browser');

% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
codigoDeArranque(hObject, eventdata, handles, {});


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
actualizarGraficas(hObject, eventdata, handles, {});
