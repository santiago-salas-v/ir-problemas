%% CSTR , multiplicidad de Estados Estacionarios.
% Encuentra la soluci�n en estado estacionario y no estacionario del
% balance de materia y energ�a de un CSTR donde suceden dos reacciones
% irreversibles, consecutivas, permitiendo estudiar la multiplicidad de 
% estados estacionarios, con los siguientes casos especiales:
%
% * CSTR-1 Estado estacionario, isot�rmico
% * CSTR-2 Estado estacionario, adiab�tico
% * CSTR-3 Estado estacionario, no-isot�rmico, no-adiab�tico
% * CSTR-4 Estado no-estacionario, isot�rmico
% * CSTR-5 Estado no-estacionario, adiab�tico
% * CSTR-6 Estado no-estacionario, no-isot�rmico, no-adiab�tico
%
% Este c�digo es de Matlab y es presentado como documento html para 
% facilitar su comprensi�n. Para ver el c�digo sin formato, <../gui4.m haga
% CLICK aqu�>
%
% Para ver el diagrama de flujo de este programa haga
% <../Diagramas_de_flujo/DF_Prob_01.pdf haga CLICK aqu�>
%%
% *NOTA:* El c�digo relevante a la soluci�n del problema est� en la secci�n
% denominada "C�DIGO RELEVANTE", el resto son funciones para producir la
% ventana, las tablas, etc.
% 
% Se eval�an �nicamente los bloques que tienen fondo gris y no es letra  
% color verde en la versi�n en formato html.
%%
%
% *BLOQUE DE C�DIGO AUTO-GENERADO*
function varargout = gui4(varargin)
% GUI4 M-file for gui4.fig
%      GUI4, by itself, creates a new GUI4 or raises the existing
%      singleton*.
%
%      H = GUI4 returns the handle to a new GUI4 or the handle to
%      the existing singleton*.
%
%      GUI4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI4.M with the given input arguments.
%
%      GUI4('Property','Value',...) creates a new GUI4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui4

% Last Modified by GUIDE v2.5 16-Aug-2010 17:15:44

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui4_OpeningFcn, ...
                   'gui_OutputFcn',  @gui4_OutputFcn, ...
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


% --- Executes just before gui4 is made visible.
function gui4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui4 (see VARARGIN)

% Choose default command line output for gui4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%%
% *LLAMADA AL C�DIGO RELEVANTE*
codigoRelevante(hObject, eventdata, handles, varargin);































function codigoRelevante(hObject, eventdata, handles, varargin)
%% 1. C�DIGO RELEVANTE
% Llamar al c�digo de arranque
codigoDeArranque(hObject, eventdata, handles, varargin);

function codigoDeArranque(hObject, eventdata, handles, varargin)
%% 1.1. Arranque
% Se ejecuta cada vez que se reinicia el programa.
%
% Primero definici�n de variables globales que ser�n manipuladas por la
% ventana cuando se elige opci�n de hacer an�lisis del estado no
% estacionario o estacionario.
global hacerAnalisisEstacionario
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
global gui4_variables_default
%%
% *hacerAnalisisEstacionario*     
%        
%                                  true si se ha seleccionado analizar el 
%                                  estado estacionario. Si no, false.
%
% *solucionAnalisisEstacionario*  
%
%                                  Matriz con la soluci�n {'t',t,'Y',Y}
%                                  en el an�lisis del estado estacionario.
%                                  t es una matriz Nx1 con los puntos de
%                                  tiempo analizado. Y es la matriz Nx3 con
%                                  los valores de {CA,CB,T}
%                                  correspondientes a cada tiempo en t.
%
% *solucionAnalisisNoEstacionario*
% 
%                                  Matriz con la soluci�n 
%                                  {'T',T,'CA',CA,'CB',CB,'qi_balance',
%                                  qi_balance} en
%                                  el an�lisis del estado estacionario. T
%                                  es matriz Nx1 con las temperaturas
%                                  analizadas, CA es matriz Nx1 con
%                                  concentraci�n de A por balance de
%                                  materia y energ�a en estado
%                                  estacionario, etc.
%
% *gui4_variables_default*
%
%                                  Matriz con los valores de las variables
%                                  que se pondr�n en la tabla cada vez que
%                                  se reinicie el programa. 
%
% En las variables *solucionAnalisisEstacionario* y 
% *solucionAnalisisNoEstacionario* se almacena la soluci�n obtenida en edo.
% estacionario y no estacionario, la cu�l no se borrar� hasta que se
% modifique alguna de las variables (para evitar recalcular la soluci�n de
% los sistema de ecuaciones diferenciales (no estacionario), algebr�icas (
% estacionario) y diferencial algebr�icas (no estacionario isot�rmico).
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
%%
% Por omisi�n hace y muestra el an�lisis del estado estacionario, con la 
% opci�n de hacer y mostrar el del estado no estacionario.
hacerAnalisisEstacionario=true;
%%
% Cambiar los t�tulos de las gr�ficas que es posible hacer a las que se
% hacen en el an�lisis  del estado estacionario. Estas opciones cambian
% cuando se selecciona el an�lisis del estado no estacionario.
set(handles.popupmenu1,'String',...
        {'q vs T';'C vs T';'S vs C';'Y vs C';'C vs q';' '});  
%%
% Al principio cargar las extensiones que se est�n usando con c�digo para
% la barra de % terminado en la soluci�n de sistemas de EDO's y EDA's.
path(path,genpath('matlab_exts'));
%%
% Todas las variables se ponen en una matriz de Nx4, cada fila es una
% variable y tienen las columnas: {'VARIABLE','VALOR','UNIDADES','SECCI�N'}
gui4_variables_default=cell(1,4);
%%
% Al inicio cargar los valores de las variables especificados en el archivo
% gui4_variables_default.mat
load('Prob_01_CSTR_Fogler_p8-11.mat');
varargin=varargin{1}{1}(:);
if length(varargin)>=2
    for i = 1 : 2 : length(varargin)
        name = varargin{i};
        value = varargin{i+1};
        switch name
            case 'defaultData'
                load(value);
            case 'regimen'
                if strcmp(value,'No-Estacionario')
                    hacerAnalisisEstacionario=false;
                    set(handles.popupmenu1,'String',...
                        {'C vs t';'T vs t';'qi vs t';...
                        'Y vs t';'S vs t';'C vs T'});  
                    set(handles.Untitled_1,'Label',...
                        'No Estacionario ==> Estacionario');
                end
            case 'grafica'
                opciones = get(handles.popupmenu1,'String');
                set(handles.popupmenu1,'Value',...
                    find(strcmp(value,opciones)));
        end
    end
end
%%
% Poner estos valores en la tabla uitable1 (a la izq.)
set(handles.uitable1,'Data',gui4_variables_default(2:end,1:3));
set(handles.uitable1,'Columnname',gui4_variables_default(1,1:3));
set(handles.uitable1,'Rowname',[]);
set(handles.uitable1,'Columneditable',[false true false]);
%%
% Correr el c�digo para actualizar ( o generar en dado caso) la gr�fica
% solicitada.
actualizarGraficas(hObject, eventdata, handles, varargin);


function actualizarGraficas(hObject, eventdata, handles, varargin)
%% 1.2. Actualizaci�n de gr�ficas
% Decide en base a si se quieren ver las gr�ficas de estado estacionario o 
% no estacionario, qu� gr�ficas generar o tomar una soluci�n ya obtenida si
% no hubo cambio en las variables.
%
% Las sig. variables se definieron en la secci�n de Arranque
global hacerAnalisisEstacionario 
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
%%
% Correr el c�digo para guardar los datos de la tabla en variables que se
% meter�n al modelo matem�tico (c�digo abajo en secci�n Obtener datos)
obtenerDatos(hObject, eventdata, handles, varargin);
%%
% Resolver estado estacionario si el valor de la variable
% hacerAnalisisEstacionario es true, o si no entonces resolver el estado
% no estacionario, para hacer las gr�ficas correspondientes.
if hacerAnalisisEstacionario
    %%
    % Si no se ha resuelto todav�a, o cambiaron los valores en la tabla,
    % la variable *solucionAnalisisEstacionario* no tendr� nada todav�a y
    % se procede a resolverlo, de otra manera se grafica la soluci�n que ya
    % se obtuvo. Esto evita recalcular innecesariamente.
    if isempty(solucionAnalisisEstacionario)
        %%
        % Obtener la soluci�n del estado estacionario con los valores que 
        % se extrajeron de la tabla, y almacenarlo en la variable
        % *solucionAnalisisEstacionario*. El c�digo de la funci�n est�
        % definido abajo.
        solucionAnalisisEstacionario =...
            analisisEdoEst(hObject, eventdata, handles, varargin);
        %%
        % Graficar la soluci�n obtenida.
        graficarEdoEst(hObject, eventdata, handles, varargin);
    else
        %%
        % Graficar la soluci�n previa.
        graficarEdoEst(hObject, eventdata, handles, varargin);
    end
else
    %%
    % Si no se ha resuelto todav�a, o cambiaron los valores en la tabla,
    % la variable *solucionAnalisisNoEstacionario* no tendr� nada todav�a y
    % se procede a resolverlo, de otra manera se grafica la soluci�n que ya
    % se obtuvo. Esto evita recalcular innecesariamente.
    if isempty(solucionAnalisisNoEstacionario)
        %%
        % Obtener la soluci�n del estado estacionario con los valores que 
        % se extrajeron de la tabla, y almacenarlo en la variable
        % *solucionAnalisisEstacionario*. El c�digo de la funci�n est�
        % definido abajo.
        solucionAnalisisNoEstacionario=...
            analisisEdoNoEst(hObject, eventdata, handles, varargin);        
        %%
        % Graficar la soluci�n obtenida.
        graficarEdoNoEst(hObject, eventdata, handles, varargin);
    else
        %%
        % Graficar la soluci�n previa.
        graficarEdoNoEst(hObject, eventdata, handles, varargin);
    end
end



function obtenerDatos(hObject, eventdata, handles, varargin);
%% 1.3. Obtener datos
% Toma los datos de la tabla y los guarda en variables globales para que la
% nueva soluci�n tome los �ltimos datos que se pusieron en la tabla.
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta 
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global rho_Cp R tiempoSoluciones isotermico 
global Datos Tmax Tmin Npuntos
global selectividades rendimientos mostrarComponentes
%  Variables establecidas por la tabla:
%
% *delta_Hf_A*          
%
%                       Entalp�a de formaci�n de A
%
% *delta_Hf_B*
%
%                       Entalp�a de formaci�n de B
%
% *delta_Hf_C*
%
%                       Entalp�a de formaci�n de C
%
% *delta_Hr_1*
%
%                       Entalp�a de reacci�n A==>>B
%
% *delta_Hr_2*
%
%                       Entalp�a de reacci�n B==>>C
%
% *E1*
%
%                       Energ�a de activaci�n para la reacci�n A==>>B, para
%                       ecuaci�n de Arrhenius en obtenci�n de constante de
%                       rapidez
%
% *E2*
%
%                       Energ�a de activaci�n para la reacci�n B==>>C, para
%                       ecuaci�n de Arrhenius en obtenci�n de constante de
%                       rapidez
%
% *k110*
%
%                       Valor de constante de rapidez de reacci�n de primer
%                       orden para la temperatura de referencia *T0ref*,
%                       para la reacci�n A==>>B
%
% *k120*
%
%                       Valor de constante de rapidez de reacci�n de primer
%                       orden para la temperatura de referencia *T0ref*,
%                       para la reacci�n B==>>C
%
% *T0ref*
%
%                       Temperatura a la cu�l   k11(T)=k11(T0ref)=k110
%                                               k12(T)=k12(T0ref)=k120
%
% *CA00*
%
%                       Concentraci�n de A en el reactor al tiempo t=0, �
%                       'CA , t=0'
%
% *CB00*
%
%                       Concentraci�n de B en el reactor al tiempo t=0, �
%                       'CB , t=0'
%
% *CC00*
%
%                       Concentraci�n de C en el reactor al tiempo t=0, �
%                       'CC, t=0'
%
% *T00*
%
%                       Temperatura del reactor al tiempo t=0, � 'T , t=0'
%
% *CA0*
%
%                       Concentraci�n de A en la corriente de alimentaci�n
%
% *CB0*
%
%                       Concentraci�n de B en la corriente de alimentaci�n
%
% *CC0*
%
%                       Concentraci�n de C en la corriente de alimentaci�n
%
% *T0*
%
%                       Temperatura de la corriente de alimentaci�n
%
% *Test*
%
%                       Temperatura alcanzada en el estado estacionario en
%                       el �ltimo reactor de la serie
%
% *Vr*
%
%                       Suma de los vol�menes de los reactores de la serie
%                       o volumen de cada reactor de la serie
%
% *Q0*
%
%                       Flujo volum�trico de la alimentaci�n
%
% *theta*
%
%                       Tiempo de residencia del fluido en el reactor
%
% *qi_balance*
%
%                       Cantidad de calor que ser� removida por las 
%                       fronteras del sistema por unidad de tiempo, 
%                       expresada en [temperatura]/[tiempo]
%
% *MA*
%
%                       Masa molar de A
%
% *MB*
%
%                       Masa molar de B
%
% *rho_Cp*
%
%                       Producto rho*Cp para la mezcla 
%
% *tiempoSoluciones*
%
%                       Tiempo total que se tomar� para las soluciones en
%                       estado no estacionario.
%
% *R*
%
%                       Constante universal de los gases
%
% *isotermico*
%
%                       Seleccionar esta opci�n para resolver el caso no
%                       estacionario e isot�rmico (dT/dt = 0), T=T(t=0), y
%                       / o el caso estacionario isot�rmico, T=T(t=0)
%
% A continuaci�n se asignan las variables globales a partir de los valores
% indicados en la tabla con el nombre correspondiente.
Datos=get(handles.uitable1,'Data');
delta_Hf_A = Datos{strcmp(Datos,'delta Hf A'),2}*1000;
delta_Hf_B = Datos{strcmp(Datos,'delta Hf B'),2}*1000;
delta_Hf_C = Datos{strcmp(Datos,'delta Hf C'),2}*1000;
delta_Hf_D = Datos{strcmp(Datos,'delta Hf D'),2}*1000;
delta_Hf_E = Datos{strcmp(Datos,'delta Hf E'),2}*1000;
delta_Hf_F = Datos{strcmp(Datos,'delta Hf F'),2}*1000;
nu = eval(Datos{strcmp(Datos,'Coefs. esteq.'),2});
delta_Hf = [delta_Hf_A delta_Hf_B delta_Hf_C...
    delta_Hf_D delta_Hf_E delta_Hf_F]';
delta_Hr_1 = nu(1,:)*delta_Hf;
delta_Hr_2 = nu(2,:)*delta_Hf;
delta_Hr_3 = nu(3,:)*delta_Hf;
E1 = Datos{strcmp(Datos,'E1'),2};
E2 = Datos{strcmp(Datos,'E2'),2};
E3 = Datos{strcmp(Datos,'E3'),2};
k110 = Datos{strcmp(Datos,'k110'),2};
k120 = Datos{strcmp(Datos,'k120'),2};
k130 = Datos{strcmp(Datos,'k130'),2};
T0ref = Datos{strcmp(Datos,'T0ref'),2};
alfa = eval(Datos{strcmp(Datos,'Exponentes r.'),2});
CA00 = Datos{strcmp(Datos,'CA, t=0'),2};
CB00 = Datos{strcmp(Datos,'CB, t=0'),2};
CC00 = Datos{strcmp(Datos,'CC, t=0'),2};
CD00 = Datos{strcmp(Datos,'CD, t=0'),2};
CE00 = Datos{strcmp(Datos,'CE, t=0'),2};
CF00 = Datos{strcmp(Datos,'CF, t=0'),2};
T00 = Datos{strcmp(Datos,'T, t=0'),2};
CA0 = Datos{strcmp(Datos,'CA0'),2};
CB0 = Datos{strcmp(Datos,'CB0'),2};
CC0 = Datos{strcmp(Datos,'CC0'),2};
CD0 = Datos{strcmp(Datos,'CD0'),2};
CE0 = Datos{strcmp(Datos,'CE0'),2};
CF0 = Datos{strcmp(Datos,'CF0'),2};
T0 = Datos{strcmp(Datos,'T0'),2};
Vr = Datos{strcmp(Datos,'Vr'),2};
U = Datos{strcmp(Datos,'U'),2}*1055*1/60*9/5;
A = Datos{strcmp(Datos,'A'),2};
Q0 = Datos{strcmp(Datos,'Q0'),2};
theta = Vr/Q0;
qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t = ...
    Datos{strcmp(Datos,'qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)'),2};
Ta0 = Datos{strcmp(Datos,'Ta0'),2};
rho_Cp = Datos{strcmp(Datos,'rho Cp'),2}*1000;
rho_Cpa = Datos{strcmp(Datos,'rho_Cpa'),2}*1000;
tiempoSoluciones = Datos{strcmp(Datos,'tiempo tot.'),2};
R = Datos{strcmp(Datos,'R'),2};
isotermico = Datos{strcmp(Datos,'Isot�rmico'),2};
Tmax = Datos{strcmp(Datos,'Tmax'),2};
Tmin = Datos{strcmp(Datos,'Tmin'),2};
Npuntos = Datos{strcmp(Datos,'N. puntos'),2};

selectividades={};rendimientos={};mostrarComponentes={};
for i=1:length(Datos)
    if ~isempty(regexpi(Datos{i,1},'^Y[1-9]=')) 
        rendimientos{size(rendimientos,1)+1,1}=Datos{i,1};
        rendimientos{size(rendimientos,1),2}=Datos{i,2};
    end
    if ~isempty(regexpi(Datos{i,1},'^S[1-9]='))
        selectividades{size(selectividades,1)+1,1}=Datos{i,1};
        selectividades{size(selectividades,1),2}=Datos{i,2};
    end
    if ~isempty(regexpi(Datos{i,1},'^mostrar [A-Z]'))
        mostrarComponentes{size(mostrarComponentes,1)+1,1}=Datos{i,1};
        mostrarComponentes{size(mostrarComponentes,1),2}=Datos{i,2};
    end
end
%%
% Finalmente se fija que la �nica manera de cambiar la entalp�a de reacci�n
% ser� variando las entalp�as de formaci�n de A , B y C. Aqu� se est�
% pooniendo el valor calculado en la tabla de datos, independientemente del
% valor que el usuario hab�a puesto.
Datos{strcmp(Datos,'delta Hr 1'),2}=delta_Hr_1;
Datos{strcmp(Datos,'delta Hr 2'),2}=delta_Hr_2;
Datos{strcmp(Datos,'delta Hr 3'),2}=delta_Hr_3;
%%
% Tambi�n se fija que la �nica manera de cambiar el tiempo de residencia
% ser� cambiando el flujo de alimentaci�n y el volumen de reactor.
Datos{strcmp(Datos,'theta'),2}=theta;
%%
% El valor de la constante universal de los gases no se podr� variar
Datos{strcmp(Datos,'R'),2}=R;
%%
% Tomar los valores que se calcularon en estos pasos y ponerlos en la tabla
% uitable1.
set(handles.uitable1,'Data',Datos);

%% 1.4. Soluci�n del modelo
% El c�digo a continuaci�n es el que se encarga de encontrar la soluci�n 
% del modelo una vez obtenidos los par�metros que estableci� el usuario.
% Comprende dos funciones:
%
% *analisisEdoEst*
%
%                   Encuentra la soluci�n de los casos:
%                   * CSTR-1 Estado estacionario, isot�rmico
%                   * CSTR-2 Estado estacionario, adiab�tico
%                   * CSTR-3 Estado estacionario, no-isot�rmico, 
%                     no-adiab�tico
%
% *analisisEdoNoEst*
%
%                   Encuentra la soluci�n de los casos:
%                   * CSTR-4 Estado no-estacionario, isot�rmico
%                   * CSTR-5 Estado no-estacionario, adiab�tico
%                   * CSTR-6 Estado no-estacionario, no-isot�rmico,
%                     no-adiab�tico
function resultado = analisisEdoEst(hObject, eventdata, handles, varargin)
%% 1.4.1. Resolver estado estacionario
% Esta funci�n obtiene la soluci�n en estado estacionario.
%
% El modelo matem�tico en estado estacionario es algebr�ico.
%
% Ec. 1. $-(C_{A0}-C_A)/\theta = 
% -k_{1,1}(T) \times C_A$ 
%
% Ec. 2. $-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
%
% Ec. 3. $-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. $-(T_0-T)/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B] +$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T)$
%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa 
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta 
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0 gui4_variables_default
global rho_Cp R tiempoSoluciones isotermico 
global Datos Tmax Tmin Npuntos
%% 1.4.1.1. CSTR-1 Estado estacionario, isot�rmico
% En este caso el valor de la temperatura es �nica $T=T_{t=0}$. 
%
% Ec. 1. $-(C_{A0}-C_A)/\theta = 
% -k_{1,1}(T_{t=0}) \times C_A$ 
%
% Ec. 2. $-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T_{t=0}) \times C_A -k_{1,2}(T_{t=0}) \times C_B$
%
% Ec. 3. $-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T_{t=0}) \times C_B$ ...(Dependiente)
%
% Ec. 4. $-(T_0-T_{t=0})/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T_{t=0}) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T_{t=0}) \times C_B] +$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T_{t=0})$
%
% Lo que hace el programa es resolver este sistema de ecuaciones para
% obtener el valor de $T_{t=0}, CA, CB, CC$. Se obtiene un punto
% que es el �nico que satisface los balances de materia y energ�a para las
% condiciones de alimentaci�n y par�metros del reactor y reacci�n en estado
% estacionario.
if isotermico
%     qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t =...
%         gui4_variables_default{strcmp(gui4_variables_default,'qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)'),2};
    %%
    % Si es isot�rmico, resolver el sistema de ecuaciones para estado
    % estacionario isot�rmico.
    %
    % Opciones, no mostrar detalles cuando converge a la soluci�n    
    opciones=optimset('fsolve');
    opciones=optimset(opciones,'Display','off');
    %%
    % Resolver el sistema de ecuaciones (definido en la secci�n de
    % SUBFUNCIONES).
    x = fsolve(@f_isot_est,[CA00 CB00 CC00 CD00 CE00 CF00 T00],opciones);
    CA=x(1);CB=x(2);CC=x(3);CD=x(4);CE=x(5);CF=x(6);T=x(7);Ta=Ta0;
    %%
    % para satisfacer el balance de energ�a esta soluci�n requiere una 
    % cantidad de calor removido del reactor, que se calcula como qi
    % (definido en la secci�n de SUBFUNCIONES). �ste es el �nico valor que
    % cumple con los balances en estado estacionario.
    qi_que_balancea=qi(U,A,rho_Cp,Vr,T,Ta,Ta0,inf);
    %%
    % Poner el valor de T(t=0) y T0 calculado en la tabla que ve el usuario
    % ya que los valores que insert� anteriormente en ese campo no
    % satisface las ecuaciones del modelo.
    Datos{strcmp(Datos,'T, t=0'),2}=T;
    %%
    % El valor de qi insertado por el usuario podr�a ser cero, pero el
    % reactor no puede ser simult�neamente isot�rmico y adiab�tico porque
    % en ese caso no se puede satisfacer el balance de energ�a. Entonces
    % substituir ese valor por el calculado.
    if abs(qi_que_balancea)<opciones.TolX
        errordlg(['Error: El reactor es propuesto es '...
            'isot�rmico y adiab�tico. S�lo puede suceder esto'...
            'si no hay reacci�n.']);
    end
    set(handles.uitable1,'Data',Datos);    
else
    %%
    % Si no es isot�rmico, puede ser adiab�tico o no adiab�tico.
    %
    %% 1.4.1.2. CSTR-2 Estado estacionario, adiab�tico
    % En este caso el valor que tiene la variable qi es $qi=0$. Se da
    % cuando el usuario inserta el valor de 0 en el campo, o puso la
    % funci�n con que se empez� $qi={{U \times A}\over{\rho \times Cp}}
    % \times (Ta-T)$, e insert� el valor de �rea de transferencia A=0.
    % Tambi�n se da cuando el usuario pone una funci�n del tiempo cuyo
    % $lim_{t \rightarrow \infty} qi(U,A,rho Cp,T,Ta,t) = 0$, las gr�ficas
    % de q vs. T mostrar�n el caso en que el �nico calor removido es por la
    % reacci�n.
    %
    % Ec. 1. $-(C_{A0}-C_A)/\theta = -k_{1,1}(T) \times C_A$
    %
    % Ec. 2. $-(C_{B0}-C_B)/\theta = +k_{1,1}(T) \times C_A -k_{1,2}(T)
    % \times C_B$
    %
    % Ec. 3. $-(C_{C0}-C_C)/\theta = +k_{1,2}(T) \times C_B$
    % ...(Dependiente)
    %
    % Ec. 4. $-(T_0-T)/\theta = {{1} \over {\rho \times Cp}} \times$
    %
    % $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A +(-\Delta Hr_2) \times
    % k_{1,2}(T) \times C_B] + \bf 0$   
    %
    % Este sistema es de cuatro ecuaciones con cuatro variables CA,CB,CC,T.
    % Sin embargo para observar todas las posibles soluciones se grafica un
    % intervalo de temperatura en el cu�l el calor removido y el generado
    % se grafican contra la temperatura, y los puntos en que se cruzan las
    % l�neas (se igualan) son un estado estacionario posible.    
    %
    %% 1.4.1.3. CSTR-3 Estado estacionario, no isot�rmico, no adiab�tico
    % En este caso el usuario puede modificar el valor de $qi(U,A,rho
    % Cp,T,Ta,t)$ en la tabla, a tener un valor espec�fico o ser funci�n de
    % la temperatura o tiempo..
    %
    % Ec. 1. $-(C_{A0}-C_A)/\theta = -k_{1,1}(T) \times C_A$
    %
    % Ec. 2. $-(C_{B0}-C_B)/\theta = +k_{1,1}(T) \times C_A -k_{1,2}(T)
    % \times C_B$
    %
    % Ec. 3. $-(C_{C0}-C_C)/\theta = +k_{1,2}(T) \times C_B$
    % ...(Dependiente)
    %
    % Ec. 4. $-(T_0-T)/\theta = {{1} \over {\rho \times Cp}} \times$
    %
    % $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A +(-\Delta Hr_2) \times
    % k_{1,2}(T) \times C_B] +$
    %
    % ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T)$
    %
    % Igualmente, este sistema es de cuatro ecuaciones con cuatro variables
    % CA,CB,CC,T. Sin embargo para observar todas las posibles soluciones
    % se grafica un intervalo de temperatura en el cu�l el calor removido y
    % el generado se grafican contra la temperatura, y los puntos en que se
    % cruzan las l�neas (se igualan) son un estado estacionario posible.
    %
    % Se hace el c�lculo del estado estacionario para el intervalo de
    % temperaturas seleccionado entre *Tmin* y *Tmax*.
    %
    % Se toman 100 puntos en el intervalo.
    T=Tmin:(Tmax-Tmin)/Npuntos:Tmax;
    Ta=Ta0;
    %%
    % Calcular CA , CB, CC, qi por balance de materia en estado
    % estacionario (la soluci�n algebr�ica es directa).
    %
    % La cantidad denominada aqu� como *qi_que_balancea* es la cantidad de
    % energ�a que se requiere retirar por el balance de materia y energ�a
    % para el estado estacionario. Sin embargo la gr�fica se har� contra
    % $qi={{U \times A}\over{\rho \times Cp}} \times (Ta-T)$, que s�lo
    % coincide con esta cantidad en ciertos puntos que son los estados
    % estacionarios posibles con el intercambiador de calor seleccionado,
    % con sus valores de U y A.
    %
    % Opciones, no mostrar detalles cuando converge a la soluci�n    
    opciones=optimset('Display','off');
    %%
    % Resolver el sistema de ecuaciones (definido en la secci�n de
    % SUBFUNCIONES).
    CA=NaN*zeros(size(T));CB=NaN*zeros(size(T));CC=NaN*zeros(size(T));
    CD=NaN*zeros(size(T));CE=NaN*zeros(size(T));CF=NaN*zeros(size(T));
    x0=[CA0 CB0 CC0 CD0 CE0 CF0];
    BarraDeEstado=waitbar(0,' ','Name','Resolviendo',...
        'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
    setappdata(BarraDeEstado,'canceling',0);
    for i=1:length(T)
        if getappdata(BarraDeEstado,'canceling')
            break
        end
        estatus=['punto ' sprintf('%u',i) ' de ' sprintf('%u',length(T))...
            ' (' sprintf('%u',round(i/length(T)*100)) '%)'];
        waitbar(i/length(T),BarraDeEstado,estatus);        
        x = fsolve(@(C)f_est(C,T(i)),x0,opciones);
        x0=x;
        CA(i)=x(1);CB(i)=x(2);CC(i)=x(3);
        CD(i)=x(4);CE(i)=x(5);CF(i)=x(6);
    end
    delete(BarraDeEstado);
end
%%
% Desglosar t�rminos de calor en el balance de energ�a, normalizados
% (divididos) por unidad de $\rho Cp$:
% *Generaci�n de calor = Ganancia de calor sensible*
% 
% *G(T)=R(T)*
% R(T)=(qs-qi)
%
% 1. Calor eliminado como sensible en la reacci�n qs:
%
% $qs=-(T_0-T)/\theta$
qs=-(T0-T)/theta;
%%
% 2. Calor intercambiado con el medio de enfriamiento qi:
%
% $qi={{U A} \over {\rho Cp}} \times(Ta-T)$
qi=qi(U,A,rho_Cp,Vr,T,Ta,Ta0,inf);
%%
% 3. Calor generado por la reacci�n qr:
% $qr={{1}\over{\rho Cp}}\times
% [(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B]$
r1=NaN*zeros(size(T));
r2=NaN*zeros(size(T));
r3=NaN*zeros(size(T));
for i=1:length(T)
    [r1(i),r2(i),r3(i)]=...
        rapideces([CA(i),CB(i),CC(i),CD(i),CE(i),CF(i)],T(i));
end
qr=1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+(-delta_Hr_3)*r3);
%%
% Encontrar la temperatura para todos los estados estacionarios en el
% intervalo como ra�ces de la funci�n.
if isotermico
    TedosEst=T;
else
    TedosEst=[];
    try
        [TedosEst,Residuo,~,~]=...
            rmsearch(@(x)interp1(T,qr-(qs-qi),x),'fzero',Tmin,Tmin,Tmax,'InitialSample',10*Npuntos);
    catch exception
        errordlg('No hay estados estacionarios en el sistema propuesto');
    end
end
%%
% Ahora regresar matriz con la soluci�n del modelo, en la forma
% convencional donde el nombre de la variable viene seguido del valor de la
% variable.
resultado = {'T',T,'CA',CA,'CB',CB,'CC',CC,'CD',CD,'CE',CE,'CF',CF,...
    'qs',qs,'qi',qi,'qr',qr,'TedosEst',TedosEst};

function graficarEdoEst(hObject, eventdata, handles, varargin)
%% 1.4.2. Graficar estado estacionario
% Grafica la soluci�n del estado estacionario
%%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta 
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global rho_Cp R tiempoSoluciones isotermico 
global selectividades rendimientos mostrarComponentes
%%
% Esta variable *solucionAnalisisEstacionario* se defini� en la secci�n
% Arranque y almacena la soluci�n del estado estacionario en la forma
% convencional, donde el nombre de la variable viene seguido de su valor.
global solucionAnalisisEstacionario
%%
% * Asignar valores correspondientes de la soluci�n a cada variable.
%
% Se extraen las series de valores de cada variable para poder 
% hacer las gr�ficas correspondientes. Se hace usando las funciones strmp y
% find, donde strmp busca en la soluci�n el nombre de cada variable y find
% nos lleva al siguiente elemento que se regres� de la soluci�n, que es el
% que contiene el valor.
T=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'T'))+1};
CA=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CA'))+1};
CB=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CB'))+1};
CC=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CC'))+1};
CD=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CD'))+1};
CE=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CE'))+1};
CF=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'CF'))+1};
TedosEst=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'TedosEst'))+1};
qs_est=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'qs'))+1};
qi_est=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'qi'))+1};
qr_est=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'qr'))+1};
if isotermico
    CAedosEst=CA;CBedosEst=CB;CCedosEst=CC;
    CDedosEst=CD;CEedosEst=CE;CFedosEst=CF;
    qr_edosEst=qr_est;
else
    CAedosEst=interp1(T,CA,TedosEst);
    CBedosEst=interp1(T,CB,TedosEst);
    CCedosEst=interp1(T,CC,TedosEst);
    CDedosEst=interp1(T,CD,TedosEst);
    CEedosEst=interp1(T,CE,TedosEst);
    CFedosEst=interp1(T,CF,TedosEst);
    qr_edosEst=interp1(T,qr_est,TedosEst);
end
%% 
% strcmp compara la matriz de soluci�n con el texto que est� como segundo
% par�metro y regresa una matriz del tama�o de la matriz de soluci�n, con
% ceros donde no es igual el texto y unos donde s� es igual.
%%
% find regresa los �ndices de los elementos que no son cero, se le suma 1
% porque el siguiente elemento del texto es ya la tabla de valores de la
% variable.
% * Escoger colores para graficar.
set(0,'DefaultAxesColorOrder',...
    [0.4,0.5,0.6 ; [165,42,42]/255 ; [102,204,0]/255; [255 48 48]/255]);
%%
% * Extraer opci�n seleccionada para graficar
%
% Esta parte es para decidir qu� se graficar� contra qu�, ya que hay una
% caja popmenu1 con opciones para graficar , conteniendo las opciones  {'C
% vs urem';'T vs q';'C vs T';'S vs C';'Y vs C'}
%
% Primero, qu� n�mero de opci�n del men� est� seleccionada. Guardarlo en el
% valor de la variable _numeroDeOpcion_.
numeroDeOpcion = get(handles.popupmenu1,'Value');
%%
% Sacar la lista correspondiente de opciones en forma de texto que tiene el
% men�, guardarla en el valor de la variable _opciones_.
opciones = get(handles.popupmenu1,'String');
%%
% Sacar el valor exacto del texto que dice en la opci�n seleccionada,
% guardarlo en el valor de la variable _opcionSeleccionada_.
opcionSeleccionada = opciones{numeroDeOpcion};
%%
% * Graficar en base a la opci�n seleccionada
%
switch opcionSeleccionada
    %%
    % En base a la opci�n que en este momento muestra la caja de opciones
    % popmenu1, graficar las variables correspondientes.
    case 'q vs T'
        %%
        % Gr�fica familiar qs-qi y qr vs. T
        plot(handles.axes1,T,(qs_est-qi_est),'--.',T,qr_est,'--*',...
            TedosEst,qr_edosEst,'>','MarkerFaceColor','auto');            
        xlabel('T, �K');
        ylabel('q., �K/min');
        set(handles.axes1,'YAxisLocation','right');
        legend({'(qs-qi)' 'qr' 'Edos. Est.'},'Location','SouthEast');        
    case 'C vs q'
        %%
        % Gr�fica C vs qs, la cu�l es parecida a C vs. T porque qs es
        % proporcional a T.
        plot(handles.axes1,qr_est,CA,'s',qr_est,CB,'*',qr_est,CC,'.',...
            qr_est,CD,'^',qr_est,CE,'d',qr_est,CF,'o')
        
%         for i=1:size(mostrarComponentes,1)
%             hold on;
%             if mostrarComponentes{i,2}
%                 plot(handles.axes1,qr_est,CA);
%             end     
%             hold off;
%         end
        hold on;
        for i=1:length(TedosEst)
            plot(handles.axes1,...
                qr_edosEst(i)*ones(1,6),...
                [CAedosEst(i),CBedosEst(i),CCedosEst(i),...
                CDedosEst(i),CEedosEst(i),CFedosEst(i)],'-->',...
                'MarkerFaceColor','auto','MarkerEdgeColor','k');            
        end
        hold off;
        xlabel('qr=qs-qi., �K/min');
        ylabel('Conc., mol/L');
        legend({'CA' 'CB' 'CC' 'CD' 'CE' 'CF' 'Edos. Est.'},'Location','East');
        limitesX=xlim;
        if abs(limitesX(1)-limitesX(2))<=1e-2
            xlim([-1 1]);
        end
    case 'T vs q'
        plot(handles.axes1,qr_est,T,'s',(qs_est-qi_est),T,'o');
        %%
        % A dem�s de graficar T vs. qs, y T vs qi+qr, que son las gr�ficas
        % t�picas, presentar T vs. cantidad de calor que balancea el estado
        % estacionario y T vs cantidad de calor que extrae el
        % intercambiador de calor, de manera que la intersecci�n de las dos
        % �ltimas es equivalente a la intersecci�n de las dos primeras
        % gr�ficas.
        xlabel('q., �K/min');
        ylabel('T, �K');
        legend({'T vs qr' 'T vs (qs-qi)'},'Location','SouthEast');
        limitesX=xlim;
        if abs(limitesX(1)-limitesX(2))<=1e-2
            xlim([-1 1]);
        end
    case 'C vs T'
        %%
        % Graficar conc. vs. temperatura
        plot(handles.axes1,T,CA,'s',T,CB,'*',T,CC,'.',...
            T,CD,'^',T,CE,'d',T,CF,'o');    
        hold on;
        for i=1:length(TedosEst)
            plot(handles.axes1,...
                TedosEst(i)*ones(1,6),...
                [CAedosEst(i),CBedosEst(i),CCedosEst(i),...
                CDedosEst(i),CEedosEst(i),CFedosEst(i)],'-->',...
                'MarkerFaceColor','auto','MarkerEdgeColor','k');            
        end
        hold off;
        xlabel('T, �K');
        ylabel('Conc., mol/L');
        legend({'CA' 'CB' 'CC' 'CD' 'CE' 'CF' 'Edos. Est.'});
    case 'S vs C'
        %%
        % Graficar selectividad. vs. conc. del componente de ref. (A)
        %
        % S(B/C)=CB/CC,S(B/D)=CB/CD,S(B/E)=CE/CD,S(B/F)=CB/CF
        plot(handles.axes1,CA,CB./CC,'s',CA,CB./CD,'*',CA,CB./CE,'.',...
            CA,CB./CF,'o');
        hold on;
        for i=1:length(TedosEst)
            plot(handles.axes1,CAedosEst(i)*ones(1,4),...
                [CBedosEst(i)/CCedosEst(i),...
                CBedosEst(i)/CDedosEst(i),CBedosEst(i)/CEedosEst(i),...
                CBedosEst(i)/CFedosEst(i)],'-->',...
                'MarkerFaceColor','auto','MarkerEdgeColor','k');
        end        
        hold off;
        xlabel('Conc., mol/L');
        ylabel('S(i/j), moli/molj');
        legend('S(B/C) vs CA','S(B/D) vs CA','S(B/E) vs CA',...
            'S(B/F) vs CA','Edos. Est.');
        case 'Y vs C'
        %%
        % Graficar rendimiento. vs. conc. del componente de ref. (A)
        %
        % Y(B)=CB/CA,Y(C)=CC/CA,Y(D)=CD/CA,Y(E)=CE/CA,Y(F)=CF/CA
        plot(handles.axes1,CA,CB./CA,'s',CA,CC./CA,'*',CA,CD./CA,'.',...
            CA,CE./CA,'o',CA,CF./CA,'d');        
        hold on;
        for i=1:length(TedosEst)
            plot(handles.axes1,CAedosEst(i)*ones(1,5),...
                [CBedosEst(i)/CAedosEst(i),...
                CCedosEst(i)/CAedosEst(i),CDedosEst(i)/CAedosEst(i),...
                CEedosEst(i)/CAedosEst(i),CFedosEst(i)/CAedosEst(i)],...
                '-->','MarkerFaceColor','auto','MarkerEdgeColor','k');
        end        
        hold off;
        xlabel('Conc., mol/L');
        ylabel('Y(i/j), moli/molj');
        legend('Y(B) vs CA','Y(C) vs CA','Y(D) vs CA',...
            'Y(E) vs CA','Y(F) vs CA','Edos. Est.');
end

title('Estado Estacionario');
%%
% Regresar a los colores default para las gr�ficas.
set(0,'DefaultAxesColorOrder','remove');
%%
% Expooner los l�mites.
exponerLimites(hObject, eventdata, handles, varargin);
%%
% Fijar l�mites si se pidieron como argumento en varargin
if length(varargin)>=2
    Datos = get(handles.uitable1,'Data');
    for i = 1 : 2 : length(varargin)
        name = varargin{i};
        value = varargin{i+1};
        switch name
            case {'XMIN','YMIN','ZMIN','XMAX','YMAX','ZMAX'}
                Datos{strcmp(Datos,name),2} = value;                       
        end
    end
end

function resultado = analisisEdoNoEst(hObject, eventdata, handles, varargin)
%% 1.4.3. Resolver estado no-estacionario
% Esta funci�n obtiene la soluci�n del estado no-estacionario
%
% El modelo matem�tico en estado no-estacionario es un sistema de
% ecuaciones diferenciales ordinarias (ODE � EDO) en el caso no isot�rmico,
% y en el caso isot�rimico (dT/dt=0), un sistema de ecuaciones
% diferencial-algebr�icas (DAE � EDA), pero con diferenciales ordinarias; 
% con condiciones inciales (en t=0, CA = CA(t=0) , CB=CB(t=0), CC=CC(t=0), 
% T=T(t=0) � urem=urem(t=0)).
%
% Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta = 
% -k_{1,1}(T) \times C_A$ 
%
% Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
%
% Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. ${{d T}\over{d t}}-(T_0-T)/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B] +$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T)$
%
% *Casos*:
%
% * Adiab�tico: qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t) = 0.   
%
%                              Necesariamente  dT/dt != 0 porque el calor
%                              producido por la reacci�n al no salir del 
%                              sistema s�lo puede calentar la mezcla (si 
%                              es reacci�n exot�rmica)
%
% * Isot�rmico: dT/dt = 0.     
%
%                              Necesariamente qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t) != 0 porque el calor
%                              producido por la reacci�n debe equilibrarse
%                              entonces con el calor removido, y se debe
%                              sacar la misma cantidad de calor que la que
%                              se genera por unidad de tiempo.
%                              Puesto que con esta modificaci�n la tercera
%                              ecuaci�n ya no es diferencial, el sistema a
%                              resolver es un sistema de ecuaciones
%                              diferencial-algebr�icas, ya que las dos
%                              primeras ecuaciones s� son diferenciales.
%
% * No isot�rmico, no adiab�tico:  
%
%                              tal como se plante�. qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t) es funci�n
%                              del tiempo y tambi�n lo es T(t).
%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa 
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta U A Ta0
global MA MB rho_Cp R tiempoSoluciones isotermico qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t 
%%
% En Matlab es posible definir el sistema de ecuaciones
% diferencial-algebr�icas (EDA) de manera muy similar a uno de ecuaciones
% diferenciales ordinarias (EDO), si se hace por medio de una matriz masa
% M(t). Se usar� este m�todo para aclarar el c�digo.
%
% Consta en expresar el sistema en la forma *M(t)y' = f(t)*, donde:
%
% El lado *izquierdo* de la ecuaci�n es un vector columna con toda la parte
% diferencial del sistema de EDO o EDA
%
% El lado *derecho* de la ecuaci�n es un vector columna con toda la parte
% no diferencial del sistema de EDO o EDA 
%
% Puesto que el caso no isot�rmico requiere la soluci�n de las variables
% [CA CB CC T], mientras que en el isot�rmico T es conocida T(t)=T(t=0) y 
% se requiere la soluci�n de las variables [CA CB CC qi], se hace 
% diferente definici�n en cada caso para y',  f(t). Ver abajo cada una.
if isotermico
    %% 1.4.3.1. CSTR-4 Estado no-estacionario, isot�rmico    
    % En este caso la temperatura se fija desde el principio, ya que 
    % T(t)=T(t=0), y dT/dt = 0. Entonces las cuatro variables a resolver son 
    % CA(t), CB(t), qi(t).
    % 
    % Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta =
    % -k_{1,1}(T_{t=0}) \times C_A$
    %
    % Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta =
    % +k_{1,1}(T_{t=0}) \times C_A -k_{1,2}(T_{t=0}) \times C_B$
    %
    % Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
    % +k_{1,2}(T_{t=0}) \times C_B$ ...(Dependiente)
    %
    % Ec. 4. $-(T_0-T_{t=0})/\theta =
    % {{1} \over {\rho \times Cp}} \times$
    %
    % $[(-\Delta Hr_1) \times k_{1,1}(T_{t=0}) \times C_A
    % +(-\Delta Hr_2) \times k_{1,2}(T_{t=0}) \times C_B] +qi(t)$
    %
    % Definiciones:
    %
    % *t*
    %
    %               Tiempo, variable independiente
    %
    % *y*
    %
    %               Vector columna con las variables dependientes: 
    %               [CA CB CC urem]
    %
    % *y'*
    %
    %               Vector columna con las diferenciales respecto del
    %               tiempo de cada una de las variables dependientes:
    %               [dCA/dt dCB/dt dCC/dt durem/dt]
    %
    % *M(t)*
    %
    %               Matriz masa, donde cada elemento puede ser funci�n del
    %               tiempo pero en este caso son s�lo unos y ceros. Es de 
    %               tama�o 4x4 y es tal que multiplicando �sta por el 
    %               vector columna *y'*, se obtiene el lado izquierdo del
    %               sistema de ecuaciones diferenciales, con toda la parte
    %               izquierda. Entonces en este caso: M(t)=[1 0 0 0;0 1 0
    %               0;0 0 1 0; 0 0 0 0] Por lo que el lado izquierdo del
    %               sistema de ecuaciones queda: *M(t)y'* = [dCA/dt dCB/dt
    %               dCC/dt 0] Esto significa que en el sistema de
    %               ecuaciones no hay derivada respecto del tiempo de
    %               qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t). La cuarta ecuaci�n es
    %               algebr�ica.
    %
    % *f(t)*
    %
    %               Vector columna con las funciones que componen el lado
    %               derecho de cada una de las ecuaciones del sistema de
    %               ecuaciones diferenciales ordinarias (EDO) o ecuaciones
    %               diferencial-algebr�icas (EDA) que se resolver�. Para 
    %               hacer esta evaluaci�n
    %
    % * Establecer la matriz masa M(t)
    
    M=[1 0 0 0 0 0 0;
       0 1 0 0 0 0 0;
       0 0 1 0 0 0 0; 
       0 0 0 1 0 0 0;
       0 0 0 0 1 0 0;
       0 0 0 0 0 1 0;
       0 0 0 0 0 0 0];    
    %%
    % * Establecer opciones:
    %
    %  M             Matriz masa. Se pone en las opciones del solver. 
    %  'OutpuFcn'    En este caso se agrega porque la funci�n @odeprog
    %                contenida en el folder matlab_exts es la que tiene el 
    %                c�digo para desplegar una barra de porcentaje resuelto 
    %                para ue en los casos en la  que la soluci�n sea lenta, 
    %                se pueda saber qu� tanto se ha resuelto. 
    %  'Events'      En este caso se agrega para pedir que si el sistema no
    %                tiene soluci�n o hay un error simplemente deje de
    %                intentar y no trabe al sistema, llama a la funci�n 
    %                @odeabort.
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,'Events',@odeabort);
    %%
    % * Encontrar soluci�n del sistema de EDA's
    %
    % Matlab tiene varias funciones para resolver sistemas de EDO's (� EDA)
    % La recomendada para cuando no se conoce el sistema bien es ode45, 
    % pero en este caso esa funci�n alcanza la soluci�n muy lentamente ya
    % que este sistema de ecuaciones es conocido como 'r�gido', o 'stiff'. 
    % La funci�n recomendada en esos casos es *ode15s*.
    %
    %  Par�metros:
    %
    %  @f_isot              
    % 
    %                       Funci�n definida m�s abajo que calcula y 
    %                       regresa la matriz que comprende el lado derecho 
    %                       del sistema de ecuaciones. Es diferente que la
    %                       funci�n para el caso no isot�rmico porque en
    %                       este caso una de las variables es urem, y en el
    %                       otro es T.
    %
    %  [0,tiempoSoluciones] 
    %
    %                       Intervalo de tiempo (variable independiente)
    %                       para el cu�l se encontrar� la soluci�n.
    %
    %  [CA00,CB00,CC00,0]
    % 
    %                       Condiciones iniciales, en t=0. En el tiempo
    %                       exactamente cero, no se extra�a calor porque se
    %                       se parte de un estado estacionario.
    %                       En momentos subsecuentes habr� un valor de urem
    %                       que no es cero.
    %
    %  odeOptions           
    %
    %                       Las opciones que se pusieron arriba.
    % 
    % Se almacena la soluci�n para las cuatro variables en la matriz Y. En
    % la matriz t est�n los valores de tiempo que se tomaron.
    [t,Y]=ode15s(@f_isot,[0,tiempoSoluciones],[CA00,CB00,CC00,CD00,...
        CE00,CF00,qi(U,A,rho_Cp,Vr,T00,Ta0,Ta0,0)],odeOptions);
    %%
    % * Reordenamiento
    %
    % Para cumplir con ser de la forma Y=[CA(t) CB(t) CC(t) CD(t) CE(T)
    % CF(T) T(t) qi(t)], igual  que para el caso no isot�rmico, se hace un
    % reordenamiento, poniendo en el cuarto elemento la temperatura y en el
    % quinto el perfil qi(t).
    Y(:,8)=Y(:,7);
    Y(:,7)=T00;
    %%
    % * Ajuste de la funci�n qi(t)
    %
    % A continuaci�n se hace un ajuste de la funci�n qi(t), para el
    % perfil que se obtuvo como soluci�n del sistema de EDA's
    Datos=get(handles.uitable1,'Data');        
    opciones=fitoptions('exp1','Display','off');    
    try
        ajuste=fit(t,Y(:,8),...
            fittype('exp2'),...
            opciones);
        % Regresar la variable que estaban normalizada t a su norma y
        % desviaci�n est�ndar y los coeficientes correspondientes.
        A=ajuste.a;
        B=ajuste.b;
        C=ajuste.c;
        D=ajuste.d;
        qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t=[...
            num2str(A) '*exp('...
            num2str(B) '*t)+'...
            num2str(C) '*exp('...
            num2str(D) '*t)'...
            ];
        Datos{strcmp(Datos,'qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)'),2}=qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t;
        set(handles.uitable1,'Data',Datos);
    catch exception
        errordlg(exception.message);
    end
else
    %%
    % Si el sistema es No isot�rmico, y = [CA CB CC T] y el sistema es 
    % un sistema de ecuaciones diferenciales ordinarias (EDO) de la forma 
    % M(t)y'=f(t).
    %
    %% 1.4.3.2. CSTR-5 Estado no-estacionario, adiab�tico
    % En este caso $qi(U,A,rho Cp,T,Ta,t)=0$, lo cu�l est� habilitado en
    % este programa de la misma manera que el caso no adiab�tico, siempre
    % que el usuario seleccione el valor de cero para la variable
    % $qi(U,A,rho Cp,T,Ta,t)$ que est� en la tabla.
    %
    % Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta =
    % -k_{1,1}(T) \times C_A$
    %
    % Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta =
    % +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
    %
    % Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
    % +k_{1,2}(T) \times C_B$ ...(Dependiente)
    %
    % Ec. 4. ${{d T}\over{d t}}-(T_0-T)/\theta =
    % {{1} \over {\rho \times Cp}} \times$
    %
    % $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
    % +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B] + \bf 0$
    %
    %% 1.4.3.3. CSTR-6 Estado no-estacionario, no-isot�rmico, no-adiab�tico
    % En este caso $qi(U,A,rho Cp,T,Ta,t)\neq = 0$, lo cu�l est�
    % funcionando en este programa con la funci�n $qi(U,A,rho Cp,T,Ta,t)$
    % que puede modificar el usuario en el espacio que lo pide en la tabla.
    %
    % Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta =
    % -k_{1,1}(T) \times C_A$
    %
    % Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta =
    % +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
    %
    % Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
    % +k_{1,2}(T) \times C_B$ ...(Dependiente)
    %
    % Ec. 4. ${{d T}\over{d t}}-(T_0-T)/\theta =
    % {{1} \over {\rho \times Cp}} \times$
    %
    % $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
    % +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B] +$
    %
    % ${{U \times A}\over{\rho \times Cp}} \times (Ta-T)$
    %
    % Definiciones:
    %
    % *t*
    %
    %               Tiempo, variable independiente
    %
    % *y*
    %
    %               Vector columna con las variables dependientes: 
    %               [CA CB CC T]
    %
    % *y'*
    %
    %               Vector columna con las diferenciales respecto del
    %               tiempo de cada una de las variables dependientes:
    %               [dCA/dt dCB/dt dCC/dt dT/dt]
    %
    % *M(t)*
    %
    %               Matriz masa, donde cada elemento puede ser funci�n del
    %               tiempo pero en este caso son s�lo unos y ceros. Es de 
    %               tama�o 4x4 y es tal que multiplicando �sta por el 
    %               vector columna *y'*, se obtiene el lado izquierdo del
    %               sistema de ecuaciones diferenciales, con toda la parte
    %               izquierda. Entonces en este caso:
    %               M(t)=[1 0 0 0 0;0 1 0 0;0 0 1 0; 0 0 0 1] 
    %               (Matriz identidad de 4x4)
    %               Por lo que el lado izquierdo del sistema de ecuaciones 
    %               queda: *M(t)y'* = [dCA/dt dCB/dt dCC/dt dT/dt] 
    %
    % *f(t)*
    %
    %               Vector columna con las funciones que componen el lado
    %               derecho de cada una de las ecuaciones del sistema de
    %               ecuaciones diferenciales ordinarias (EDO) o ecuaciones
    %               diferencial-algebr�icas (EDA) que se resolver�. Para hacer
    %               esta evaluaci�n
    %
    % * Establecer la matriz masa M(t)
    M=[1 0 0 0 0 0 0;
       0 1 0 0 0 0 0;
       0 0 1 0 0 0 0; 
       0 0 0 1 0 0 0;
       0 0 0 0 1 0 0;
       0 0 0 0 0 1 0;
       0 0 0 0 0 0 1];
    %%
    % * Establecer opciones
    %
    %  M             Matriz masa. Se pone en las opciones del solver. 
    %  'OutpuFcn'    En este caso se agrega porque la funci�n @odeprog
    %                contenida en el folder matlab_exts es la que tiene el 
    %                c�digo para desplegar una barra de porcentaje resuelto 
    %                para ue en los casos en la  que la soluci�n sea lenta, 
    %                se pueda saber qu� tanto se ha resuelto. 
    %  'Events'      En este caso se agrega para pedir que si el sistema no
    %                tiene soluci�n o hay un error simplemente deje de
    %                intentar y no trabe al sistema, llama a la funci�n 
    %                @odeabort.    
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,'Events',@odeabort);
    %%
    % * Resolver el sistema de EDO's
    %
    % Matlab tiene varias funciones para resolver sistemas de EDO's.
    % La recomendada para cuando no se conoce el sistema bien es ode45, 
    % pero en este caso esa funci�n alcanza la soluci�n muy lentamente ya
    % que este sistema de ecuaciones es conocido como 'r�gido', o 'stiff'. 
    % La funci�n recomendada en esos casos es *ode15s*.
    %
    %  Par�metros:
    %
    %  @f                   
    %                       Funci�n definida m�s abajo que calcula y 
    %                       regresa la matriz que comprende el lado derecho 
    %                       del sistema de ecuaciones.
    %
    %  [0,tiempoSoluciones] 
    %                       Intervalo de tiempo (variable independiente)
    %                       para el cu�l se encontrar� la soluci�n.
    %
    %  [CA00,CB00,CC00,T00]      
    %                       Condiciones iniciales, en t=0.
    %
    %  odeOptions           
    %                       Las opciones que se pusieron arriba.
    %
    % Se almacena la soluci�n para las cuatro variables en la matriz Y. En
    % la matriz t est�n los valores de tiempo que se tomaron.
    [t,Y]=ode15s(@f,[0,tiempoSoluciones],...
        [CA00,CB00,CC00,CD00,CE00,CF00,T00],odeOptions);
    %%
    % * Reordenamiento
    %
    % Para cumplir con ser de la forma Y=[CA(t) CB(t) CC(t) CD(t) CE(T)
    % CF(T) T(t) qi(t)], igual que para el caso isot�rmico, se agrega la
    % funci�n qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t) al final como cuarto elemento.
    Y(:,8)=qi(U,A,rho_Cp,Vr,Y(:,7),Ta0,Ta0,t);
end
%%
% Regresar matriz [t,Y]
resultado={'t',t,'Y',Y};

function graficarEdoNoEst(hObject, eventdata, handles, varargin);
%% 1.4.4. Graficar estado no-estacionario
% Grafica la soluci�n del estado no-estacionario
%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta 
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global MA MB rho_Cp R tiempoSoluciones isotermico
%%
% Esta variable *solucionAnalisisEstacionario* se defini� en la secci�n
% Arranque y almacena la soluci�n del estado no estacionario en la forma 
% convencional, donde el nombre de la variable viene seguido de su valor.
global solucionAnalisisNoEstacionario
%%
% * Asignar valores correspondientes de la soluci�n a cada variable.
%
% Se extraen las series de valores de cada variable para poder 
% hacer las gr�ficas correspondientes. Se hace usando las funciones strmp y
% find, donde strmp busca en la soluci�n el nombre de cada variable y find
% nos lleva al siguiente elemento que se regres� de la soluci�n, que es el
% que contiene el valor.
t=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'t'))+1};
Y=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'Y'))+1};
CA=Y(:,1);
CB=Y(:,2);
CC=Y(:,3);
CD=Y(:,4);
CE=Y(:,5);
CF=Y(:,6);
T=Y(:,7);
urem_no_est=Y(:,8);
%% 
% strcmp compara la matriz de soluci�n con el texto que est� como segundo
% par�metro y regresa una matriz del tama�o de la matriz de soluci�n, con
% ceros donde no es igual el texto y unos donde s� es igual.
%%
% find regresa los �ndices de los elementos que no son cero, se le suma 1
% porque el siguiente elemento del texto es ya la tabla de valores de la
% variable.
%%
% * Escoger colores para graficar.
set(0,'DefaultAxesColorOrder',...
    [0.4,0.5,0.6 ; [156,42,42]/255 ; [102,204,0]/255]);
%%
% * Extraer opci�n seleccionada para graficar
%
% Esta parte es para decidir qu� se graficar� contra qu�, ya que hay una
% caja popmenu1 con opciones para graficar , conteniendo las opciones  {'C
% vs urem';'T vs q';'C vs T';'S vs C';'Y vs C'}
%
% Primero, qu� n�mero de opci�n del men� est� seleccionada. Guardarlo en el
% valor de la variable _numeroDeOpcion_.
numeroDeOpcion = get(handles.popupmenu1,'Value');
%%
% Sacar la lista correspondiente de opciones en forma de texto que tiene el
% men�, guardarla en el valor de la variable _opciones_.
opciones = get(handles.popupmenu1,'String');
%%
% Sacar el valor exacto del texto que dice en la opci�n seleccionada,
% guardarlo en el valor de la variable _opcionSeleccionada_.
opcionSeleccionada = opciones{numeroDeOpcion};
%%
% * Graficar en base a la opci�n seleccionada
%
switch opcionSeleccionada
    case 'C vs t'       
        plot(handles.axes1,...
            t,CA,'s-',t,CB,'*-',t,CC,'.-',...
            t,CD,'o-',t,CE,'d-',t,CF,'^-');
        xlabel('t, min');
        ylabel('Conc., mol/L');
        legend('CA','CB','CC','CD','CE','CF');
    case 'T vs t'
        plot(handles.axes1,t,T);
        xlabel('t, min');
        ylabel('T, �K');
        legend('T, �K');
    case 'qi vs t'        
        if isotermico
            plot(handles.axes1,t,urem_no_est,'*',...
                t,qi(U,A,rho_Cp,Vr,T,Ta0,Ta0,t),'--');
            legend({'soluci�n'...
                sprintf(['correlaci�n qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)=\n'...
                qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t])},'Location','NorthOutside');
        else
            plot(handles.axes1,t,urem_no_est);
            legend('qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)');
        end
        xlabel('t, min');
        ylabel('qi, �K/min');
    case 'Y vs t'
        plot(handles.axes1,...
            t,CB./CA,'*-',t,CC./CA,'.-',...
            t,CD./CA,'o-',t,CE./CA,'d-',...
            t,CF./CA,'^-');
        xlabel('t, min');
        ylabel('Y(i), moli/molA');
        legend('Y(B)','Y(C)','Y(D)','Y(E)','Y(F)');
    case 'S vs t'
        plot(handles.axes1,...
            t,CB./CC,'*-',t,CB./CD,'.-',...
            t,CB./CE,'o-',t,CB./CF,'d-');
        xlabel('t, min');
        ylabel('S(B/i), molB/moli');
        legend('S(B/C)','S(B/D)','S(B/E)','S(B/F)');
    case 'C vs T'
        plot(handles.axes1,T,CA,'s',T,CB,'*',...
            T,CC,'.',T,CD,'^',T,CE,'d',T,CF,'o');
        hold on;
        quiver(handles.axes1,...
            [T(1:end-1);T(1:end-1);T(1:end-1);...
            T(1:end-1);T(1:end-1);T(1:end-1)],...
            [CA(1:end-1);CB(1:end-1);CC(1:end-1);...
            CD(1:end-1);CE(1:end-1);CF(1:end-1)],...
            [T(2:end)-T(1:end-1);T(2:end)-T(1:end-1);...
            T(2:end)-T(1:end-1);T(2:end)-T(1:end-1);...
            T(2:end)-T(1:end-1);T(2:end)-T(1:end-1)],...
            [CA(2:end)-CA(1:end-1);CB(2:end)-CB(1:end-1);...
            CC(2:end)-CC(1:end-1);CD(2:end)-CD(1:end-1);...
            CE(2:end)-CE(1:end-1);CF(2:end)-CF(1:end-1)],0);
        xlabel('T, �K');
        ylabel('Conc., mol/L');
        legend('CA vs T','CB vs T','CC vs T','CD vs T',...
            'CE vs T','CF vs T','Location','East');    
        if strcmp(get(handles.Untitled_10, 'Checked'),'on')
            hold off;
        end
end
%%
% Poner t�tulo y regresar los colores a los 'default'
title('Estado No Estacionario');
set(0,'DefaultAxesColorOrder','remove');
%%
% Exponer los l�mites de gr�fica en la tabla
exponerLimites(hObject, eventdata, handles, varargin);
%%
% Fijar l�mites si se pidieron como argumento en varargin
if length(varargin)>=2
    Datos = get(handles.uitable1,'Data');
    for i = 1 : 2 : length(varargin)
        name = varargin{i};
        value = varargin{i+1};
        switch name
            case {'XMIN','YMIN','ZMIN','XMAX','YMAX','ZMAX'}
                Datos{strcmp(Datos,name),2} = value;                       
        end
    end
end

%% 2. SUBFUNCIONES
% Estas subfunciones se usan recurrentemente por las funciones de an�lisis
% - soluci�n de estado estacionario y no estacionario.
%
%% 2.1. Partes no-diferenciales del modelo matem�tico
%
function resultado = f(t,y)
%% 2.1.1. Estado No-Estacionario, No Isot�rmico
% Para el estado no estacionario, esta funci�n es la parte no-diferencial 
% de las ecuaciones del modelo matem�tico, en caso no isot�rmico y no 
% adiab�tico, o adiab�tico (si qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)=0)
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa 
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta 
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global rho_Cp R tiempoSoluciones isotermico 
%%
% La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
%
% y(1) es CA(t)
%
% y(2) es CB(t)
%
% y(3) es CC(t)
%
% y(7) es T(t)
[r1,r2,r3]=rapideces(y(1:6),y(7));
resultado = [...
    (CA0-y(1))/theta+nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    (CB0-y(2))/theta+nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    (CC0-y(3))/theta+nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    (CD0-y(4))/theta+nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    (CE0-y(5))/theta+nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    (CF0-y(6))/theta+nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
    (T0-y(7))/theta+1/rho_Cp*((-delta_Hr_1)*r1+...
    (-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+qi(U,A,rho_Cp,Vr,y(7),Ta0,Ta0,inf);
    ];

function resultado = f_isot(t,y)
%% 2.1.2. Estado No-Estacionario, Isot�rmico
% Para el estado no estacionario, esta funci�n es la parte no-diferencial 
% de las ecuaciones del modelo matem�tico, en caso isot�rmico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa 
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global rho_Cp R tiempoSoluciones isotermico 
%%
% La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
%
% y(1) es CA(t)
%
% y(2) es CB(t)
%
% y(3) es CC(t)
%
% y(7) es qi(t)
T=T00;
%%
% Calcular con esta temperatura el modelo matem�tico.
[r1,r2,r3]=rapideces(y(1:6),T);
resultado = [...
    (CA0-y(1))/theta+nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    (CB0-y(2))/theta+nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    (CC0-y(3))/theta+nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    (CD0-y(4))/theta+nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    (CE0-y(5))/theta+nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    (CF0-y(6))/theta+nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
    (T0-T)/theta+1/rho_Cp*((-delta_Hr_1)*r1+...
    (-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+y(7);
    ];

%
%% 2.2. Funciones en estado estacionario
% Son las ecuaciones algebr�icas del modelo matem�tico igualadas a cero.
function resultado = f_isot_est(y)
%% 2.2.1. Estado Estacionario, Isot�rmico
% Para el estado estacionario, esta funci�n representa el conjunto de
% ecuaciones del modelo igualadas a cero, cuando la variable a determinar
% es T(t=0), la �nica temperatura posible dadas las condiciones de
% alimentaci�n y par�metros del reactor y la reacci�n que puede satisfacer
% el BME en estado estacionario e isot�rmico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa 
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global rho_Cp R tiempoSoluciones isotermico 
%%
% La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T(t=0)]. Por lo tanto:
%
% y(1) es CA(t)
%
% y(2) es CB(t)
%
% y(3) es CC(t)
%
% y(4) es T=T(t=0)
%
% Calcular con esta temperatura el modelo matem�tico.
[r1,r2,r3]=rapideces(y(1:6),y(7));
resultado = [...
    (CA0-y(1))/theta+nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    (CB0-y(2))/theta+nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    (CC0-y(3))/theta+nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    (CD0-y(4))/theta+nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    (CE0-y(5))/theta+nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    (CF0-y(6))/theta+nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
    (T0-y(7))/theta+1/rho_Cp*((-delta_Hr_1)*r1+...
    (-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+qi(U,A,rho_Cp,Vr,y(7),Ta0,Ta0,inf);
    ];

function resultado = f_est(y,T)
%% 2.2.2. Estado Estacionario no isot�rmico
% Para el estado estacionario, esta funci�n representa el conjunto de
% ecuaciones del modelo igualadas a cero (la parte del balance de materia
% �nicamente). Sin embargo no necesariamente se satisfacen balance de
% materia y energ�a ya que puede haberse seleccionado una temperatura que
% no sea de estado estacionario. En ese caso 
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global E1 E2 E3 k110 k120 k130 T0ref
global CA00 CB00 CC00 CD00 CE00 CF00 T00 CA0 CB0 CC0 CD0 CE0 CF0 T0 Vr Q0 theta
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t U A Ta0
global rho_Cp R tiempoSoluciones isotermico 
%%
% La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T(t=0)]. Por lo tanto:
%
% y(1) es CA(t)
%
% y(2) es CB(t)
%
% y(3) es CC(t)
%
% Calcular con esta temperatura T los valores de concentraci�n que
% satisfacen el balance de materia.
[r1,r2,r3]=rapideces(y(1:6),T);
resultado = [...
    (CA0-y(1))/theta+nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    (CB0-y(2))/theta+nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    (CC0-y(3))/theta+nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    (CD0-y(4))/theta+nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    (CE0-y(5))/theta+nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    (CF0-y(6))/theta+nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
    ];


%% 2.3. Funcionalidades con la temperatura
% Cada vez que se necesite evaluar una variable que var�a con la
% temperatura se llaman estas funciones. Ej. las constantes de rapidez,
% entalp�as de reacci�n (IMPLEMENTAR), densidad (IMPLEMENTAR), capacidad
% calor�fica (IMPLEMENTAR).
function k11 = k11(T)
%% 2.3.1. Expresi�n de Arrhenius para reacci�n 1
% k de T por expr. de Arrhenius
global k110 E1 R T0ref
k11 = k110*exp(-E1/R*(1./T-1/T0ref));

function k12 = k12(T)
%% 2.3.2. Expresi�n de Arrhenius para reacci�n 2
% k de T por expr. de Arrhenius
global k120 E2 R T0ref
k12 = k120*exp(-E2/R*(1./T-1/T0ref));

function k13 = k13(T)
%% 2.3.3. Expresi�n de Arrhenius para reacci�n 3
% k de T por expr. de Arrhenius
global k130 E3 R T0ref
k13 = k130*exp(-E3/R*(1./T-1/T0ref));

%% 2.4 Evaluaci�n de par�metros establecidos por el usuario
% Son funciones que el usuario ha insertado como texto y se tiene que
% interpretar para dar un resultado num�rico.
function resultado=qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)
%% 2.4.1. Evaluar qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t) a un tiempo t dado
% A partir del valor de texto que tiene el campo. Por omisi�n,
% $qi={{U A} \over {\rho Cp}} \times(Ta-T)$
global qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t gui4_variables_default
try
resultado = eval(qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t);
catch exception    
    Datos=gui4_variables_default(2:end,1:3);
    qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t = Datos{strcmp(Datos,'qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)'),2};
    errordlg(sprintf(['qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t) no fue correctamente insertada,'...
        ' se utiliza el valor default que es:' qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t...
        ' \n' exception.identifier]),...
        'WindowStyle','modal');        
    resultado = eval(qi_U_A_rho_Cp_Vr_T_Ta_Ta0_t);
end

%% 2.4. Funcionalidad de la cin�tica de las reacciones
% Calcula la rapidez de las reacciones involucradas en funci�n de la
% concentracion y temperatura
function [r1,r2,r3]=rapideces(C,T)
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
r1=k11(T)*C(1)^alfa(1,1)*C(2)^alfa(1,2)*C(3)^alfa(1,3)*...
    C(4)^alfa(1,4)*C(5)^alfa(1,5)*C(6)^alfa(1,6);
r2=k12(T)*C(1)^alfa(2,1)*C(2)^alfa(2,2)*C(3)^alfa(2,3)*...
    C(4)^alfa(2,4)*C(5)^alfa(2,5)*C(6)^alfa(2,6);
r3=k13(T)*C(1)^alfa(3,1)*C(2)^alfa(3,2)*C(3)^alfa(3,3)*...
    C(4)^alfa(3,4)*C(5)^alfa(3,5)*C(6)^alfa(3,6);

























%% 
% *BLOQUE DE C�DIGO PARA MANEJO DE TABLAS, MEN�S, ETC.*
function exponerLimites(hObject, eventdata, handles, varargin)
%%
% Funci�n para poner los l�mites de las gr�ficas en la tabla para su
% manipulacion.
Datos = get(handles.uitable1,'Data');
variables = {'XMIN','XMAX','YMIN','YMAX','ZMIN','ZMAX'};
limsXAhora = get(handles.axes1,'XLim');
limsYAhora = get(handles.axes1,'YLim');
limsZAhora = get(handles.axes1,'ZLim');
limites = [limsXAhora(1),limsXAhora(2),limsYAhora(1),limsYAhora(2),...
    limsZAhora(1),limsZAhora(2)];
for i=1:length(variables)
    if ~isempty(find(strcmp(Datos,variables(i)),1))
        Datos{strcmp(Datos,variables(i)),2} = limites(i);
    else
        if isempty(find(strcmp(Datos,'EJES'),1))
            Datos{length(Datos)+1,1} = 'EJES';
            Datos{length(Datos)+1,1} = variables{i};
            Datos{length(Datos),2} = limites(i);
        else
            Datos{length(Datos)+1,1} = variables{i};
            Datos{length(Datos),2} = limites(i);
        end
    end
end
set(handles.uitable1,'Data',Datos);

% --- Outputs from this function are returned to the command line.
function varargout = gui4_OutputFcn(hObject, eventdata, handles) 
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
%	NewData: EditData or its converted form set on the Data property. Empty
%	if Data was not changed
%	Error: error string when failed to convert EditData to appropriate
%	value for Data
% handles    structure with handles and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
global hacerAnalisisEstacionario
Datos = get(handles.uitable1,'Data');
nombresDeColumnas=get(handles.uitable1,'Columnname');
columnasEditables=get(handles.uitable1,'Columneditable');
solucionAnalisisNoEstacionario={};
solucionAnalisisEstacionario={};
variableModificada = Datos{eventdata.Indices(1),1};
noSeInsertoUnNumero = not(isnumeric(eventdata.NewData))&&...
    not(islogical(eventdata.NewData))&&...
    not(ischar(eventdata.NewData)) ||any(isnan(eventdata.NewData));
if noSeInsertoUnNumero
    Datos{eventdata.Indices(1),eventdata.Indices(2)}=...
        eventdata.PreviousData;    
    set(handles.uitable1,'Data',Datos);
else
    switch variableModificada
        case 'Isot�rmico'
            if eventdata.PreviousData==true
                Datos{strcmp(Datos,'qi(U,A,rho_Cp,Vr,T,Ta,Ta0,t)'),2}=...
                    'U*A/(Vr*rho_Cp)*(Ta-T)';
                set(handles.uitable1,'Data',Datos);
            end
            actualizarGraficas(hObject, eventdata, handles);
        case 'XMAX'
            try
                limitesAnteriores = get(handles.axes1,'XLim');
                xlim(handles.axes1,...
                    [limitesAnteriores(1),...
                    Datos{strcmp(Datos,variableModificada),2}]);
            catch exception
                %%
                % This is in case bad axis limits were chosen
                exponerLimites(hObject, eventdata, handles,{});
            end
        case 'YMAX'
            try
                limitesAnteriores = get(handles.axes1,'YLim');
                ylim(handles.axes1,...
                    [limitesAnteriores(1),...
                    Datos{strcmp(Datos,variableModificada),2}]);
            catch exception
                %%
                % This is in case bad axis limits were chosen
                exponerLimites(hObject, eventdata, handles,{});
            end
        case 'ZMAX'
            try
                limitesAnteriores = get(handles.axes1,'ZLim');
                zlim(handles.axes1,...
                    [limitesAnteriores(1),...
                    Datos{strcmp(Datos,variableModificada),2}]);
            catch exception
                %%
                % This is in case bad axis limits were chosen
                exponerLimites(hObject, eventdata, handles,{});
            end
        case 'XMIN'
            try
                limitesAnteriores = get(handles.axes1,'XLim');
                xlim(handles.axes1,...
                    [Datos{strcmp(Datos,variableModificada),2},...
                    limitesAnteriores(2)]);
            catch exception
                %%
                % This is in case bad axis limits were chosen
                exponerLimites(hObject, eventdata, handles,{});
            end
        case 'YMIN'
            try
                limitesAnteriores = get(handles.axes1,'YLim');
                ylim(handles.axes1,...
                    [Datos{strcmp(Datos,variableModificada),2},...
                    limitesAnteriores(2)]);
            catch exception
                %%
                % This is in case bad axis limits were chosen
                exponerLimites(hObject, eventdata, handles,{});
            end
        case 'ZMIN'
            try
                limitesAnteriores = get(handles.axes1,'ZLim');
                zlim(handles.axes1,...
                    [Datos{strcmp(Datos,variableModificada),2},...
                    limitesAnteriores(2)]);
            catch exception
                %%
                % This is in case bad axis limits were chosen
                exponerLimites(hObject, eventdata, handles,{});
            end
        otherwise
            actualizarGraficas(hObject, eventdata, handles);            
    end
end
%%
% Generar una vista de cambio r�pido de la variable, para poder seguir
% cambi�ndola sin perderla de vista.
% vistaDeCambioRapido = cambioRapido;
% uiTable1 = get(vistaDeCambioRapido,'Children');
% Datos = {...
%     Datos{strcmp(Datos,variableModificada),1},...
%     Datos{strcmp(Datos,variableModificada),2},...
%     Datos{strcmp(Datos,variableModificada),3}...
%     };
% set(uiTable1, 'Data',Datos,'ColumnName',{'Variable','Valor','Unidades'},...
%     'RowName',{},'ColumnEditable',[false,true,false]);





% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hacerAnalisisEstacionario
if hacerAnalisisEstacionario
    set(handles.Untitled_1,'Label','No Estacionario ==> Estacionario');
    set(handles.popupmenu1,'String',...
        {'C vs t';'T vs t';'qi vs t';'Y vs t';'S vs t';'C vs T'});
    hacerAnalisisEstacionario=false;
    actualizarGraficas(hObject, eventdata, handles);
else
    set(handles.Untitled_1,'Label','Estacionario ==> No Estacionario');
    set(handles.popupmenu1,'String',...
        {'q vs T';'C vs T';'S vs C';'Y vs C';'C vs q';' '});    
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
web('./html/gui4.html','-browser');

% --------------------------------------------------------------------
function Untitled_5_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('./html/Prob_01_teoria.html','-browser');

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
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
actualizarGraficas(hObject, eventdata, handles, {});


% --------------------------------------------------------------------
function Untitled_9_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%
% Limpiar soluciones que hab�an
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
[FileName,PathName,~]=uigetfile('*CSTR*.mat');

if FileName~=0
    load([PathName filesep FileName],'gui4_variables_default');
    %
    % Poner estos valores en la tabla uitable1 (a la izq.)
    set(handles.uitable1,'Data',gui4_variables_default(2:end,1:3)); %#ok<COLND>
    set(handles.uitable1,'Columnname',gui4_variables_default(1,1:3));
    set(handles.uitable1,'Rowname',[]);
    set(handles.uitable1,'Columneditable',[false true false]);
    %
    % Correr el c�digo para actualizar ( o generar en dado caso) la gr�fica
    % solicitada.
    actualizarGraficas(hObject, eventdata, handles, {});
end

% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(hObject, 'Checked'),'on')
    set(hObject,'Checked','off');
    hold on;
else 
    set(hObject,'Checked','on');
    hold off;
    actualizarGraficas(hObject, eventdata, handles, {});
end
