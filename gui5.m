%% PFR adiab�tico, reacciones consecutivas (2), exot�rmicas.
%  Este programa encuentra la soluci�n de un PFR
%%
% Este c�digo es de Matlab y es presentado como documento html para 
% facilitar su comprensi�n. Para ver el c�digo sin formato, <../gui5.m haga
% CLICK aqu�>
%%
% *NOTA:* El c�digo relevante a la soluci�n del problema est� en la secci�n
% denominada "C�DIGO RELEVANTE", el resto son funciones para producir la
% ventana, las tablas, etc.
%%

%% 1. BLOQUE DE C�DIGO AUTO-GENERADO
function varargout = gui5(varargin)
% gui5 M-file for gui5.fig
%      gui5, by itself, creates a new gui5 or raises the existing
%      singleton*.
%
%      H = gui5 returns the handle to a new gui5 or the handle to
%      the existing singleton*.
%
%      gui5('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in gui5.M with the given input arguments.
%
%      gui5('Property','Value',...) creates a new gui5 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before gui5_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to gui5_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help gui5

% Last Modified by GUIDE v2.5 09-Dec-2010 15:38:23

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @gui5_OpeningFcn, ...
                   'gui_OutputFcn',  @gui5_OutputFcn, ...
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


% --- Executes just before gui5 is made visible.
function gui5_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to gui5 (see VARARGIN)

% Choose default command line output for gui5
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes gui5 wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%% 2. LLAMADA AL C�DIGO RELEVANTE
codigoRelevante(hObject, eventdata, handles, varargin);






























%% 3. C�DIGO RELEVANTE
function codigoRelevante(hObject, eventdata, handles, varargin)
%% 
% Llamar al c�digo de arranque
codigoDeArranque(hObject, eventdata, handles, varargin);

function codigoDeArranque(hObject, eventdata, handles, varargin)
%% 3.1 Arranque
% Se ejecuta cada vez que se reinicia el programa.
%%
% Primero definici�n de variables globales que ser�n manipuladas por la
% ventana cuando se elige opci�n de hacer an�lisis del estado no
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
%                                  Matriz con la soluci�n {'t',t,'Y',Y}
%                                  en el an�lisis del estado estacionario.
%                                  t es una matriz Nx1 con los puntos de
%                                  tiempo analizado. Y es la matriz Nx3 con
%                                  los valores de {CA,CB,T}
%                                  correspondientes a cada tiempo en t.
%%
% *solucionAnalisisNoEstacionario*
%% 
%                                  Matriz con la soluci�n 
%                                  {'T',T,'CA',CA,'CB',CB,'Urem',Urem} en
%                                  el an�lisis del estado estacionario. T
%                                  es matriz Nx1 con las temperaturas
%                                  analizadas, CA es matriz Nx1 con
%                                  concentraci�n de A por balance de
%                                  materia y energ�a en estado
%                                  estacionario, etc.
%%
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
        {'C vs z';'T vs z';'qi vs z';'Y vs X';'Diametro ext. vs z'});  
%%
% Al principio cargar las extensiones que se est�n usando con c�digo para
% la barra de % terminado en la soluci�n de sistemas de EDO's y EDA's.
path(path,genpath('matlab_exts'));
%%
% Todas las variables se ponen en una matriz de Nx4, cada fila es una
% variable y tienen las columnas: {'VARIABLE','VALOR','UNIDADES','SECCI�N'}
gui5_variables_default=cell(1,4);
%%
% Al inicio cargar los valores de las variables especificados en el archivo
% gui5_variables_default.mat
load('Prob_02_PFR_valores_Fogler_p8-10.mat');
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
                        {'C vs z,t';'T vs z,t';'qi vs z';'C vs T';' '});  
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
set(handles.uitable1,'Data',gui5_variables_default(2:end,1:3));
set(handles.uitable1,'Columnname',gui5_variables_default(1,1:3));
set(handles.uitable1,'Rowname',[]);
set(handles.uitable1,'Columneditable',[false true false]);

%%
% Correr el c�digo para actualizar ( o generar en dado caso) la gr�fica
% solicitada.
actualizarGraficas(hObject, eventdata, handles, varargin);


function actualizarGraficas(hObject, eventdata, handles, varargin)
%% 3.2 Actualizaci�n de gr�ficas
% Decide en base a si se quieren ver las gr�ficas de estacionario o no
% estacionario, qu� gr�ficas generar o tomar una soluci�n ya obtenida si no
% hubo cambio en las variables.
%%
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
%% 3.3 Obtener datos
% Toma los datos de la tabla y los guarda en variables globales para que la
% nueva soluci�n tome los �ltimos datos que se pusieron en la tabla.
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global E1 E2 E3 k110 k120 k130 T0ref
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global uz uza
global MA MB rho_Cp R tiempoSoluciones isotermico
global Tmax Tmin
%%
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
CA0 = Datos{strcmp(Datos,'CA0'),2};
CB0 = Datos{strcmp(Datos,'CB0'),2};
CC0 = Datos{strcmp(Datos,'CC0'),2};
CD0 = Datos{strcmp(Datos,'CD0'),2};
CE0 = Datos{strcmp(Datos,'CE0'),2};
CF0 = Datos{strcmp(Datos,'CF0'),2};
T0 = Datos{strcmp(Datos,'T0'),2};
CA0z = CA0;
CB0z = CB0;
CC0z = CC0;
CD0z = CD0;
CE0z = CE0;
CF0z = CF0;
T0z = T0;
Longitud = Datos{strcmp(Datos,'Longitud'),2};
Diametro = Datos{strcmp(Datos,'Di�metro'),2};
Vr = Longitud*pi/4*Diametro^2*1/1000;
U = Datos{strcmp(Datos,'U'),2}*1055*1/60*9/5;
a = 4/Diametro*1/30.48^2*1000;
Q0 = Datos{strcmp(Datos,'Q0'),2};
theta = Vr/Q0;
uz=Q0*1000/(pi/4*Diametro^2);
qi_U_A_rho_Cp_T_Ta_t = Datos{strcmp(Datos,'qi(U,a,rho_Cp,T,Ta,t)'),2};
qa_U_A_rho_Cpa_T_Ta_t = Datos{strcmp(Datos,'qa(U,a,rho_Cpa,T,Ta,t)'),2};
Ta00 = Datos{strcmp(Datos,'Ta(z=0,t)'),2};
Diametro_a = Datos{strcmp(Datos,'Di�metro_a'),2};
Q0a = Datos{strcmp(Datos,'Q0a'),2};
uza = Q0a*1000/(pi/4*(Diametro_a^2-Diametro^2));
MA = Datos{strcmp(Datos,'MA'),2};
MB = Datos{strcmp(Datos,'MB'),2};
rho_Cp = Datos{strcmp(Datos,'rho_Cp'),2}*1000;
rho_Cpa = Datos{strcmp(Datos,'rho_Cpa'),2}*1000;
tiempoSoluciones = Datos{strcmp(Datos,'tiempo tot.'),2};
R = Datos{strcmp(Datos,'R'),2};
isotermico = Datos{strcmp(Datos,'Isot�rmico'),2};
Tmax = Datos{strcmp(Datos,'Tmax'),2};
Tmin = Datos{strcmp(Datos,'Tmin'),2};
%%
% Finalmente se fija que la �nica manera de cambiar la entalp�a de reacci�n
% ser� variando las entalp�as de formaci�n de A , B y C
Datos{strcmp(Datos,'delta Hr 1'),2}=delta_Hr_1;
Datos{strcmp(Datos,'delta Hr 2'),2}=delta_Hr_2;
Datos{strcmp(Datos,'delta Hr 3'),2}=delta_Hr_3;
%%
% Tambi�n se fija que la �nica manera de cambiar el tiempo de residencia
% ser� cambiando el flujo de alimentaci�n y el volumen de reactor.
Datos{strcmp(Datos,'theta'),2}=theta;
%%
% Tambi�n se fija el volumen del reactor por el di�metro y longitud.
Datos{strcmp(Datos,'Vr'),2}=Vr;
Datos{strcmp(Datos,'a'),2}=a;
%%
% El valor de la constante universal de los gases no se podr� variar
Datos{strcmp(Datos,'R'),2}=R;
%%
% Por ahora no se tiene implementado el efecto de incompatibilidad por lo
% que la alimentaci�n tendr� que ser igual que la condici�n inicial en la
% frontera.
Datos{strcmp(Datos,'T(t=0,z)'),2}=T0;
Datos{strcmp(Datos,'CA(t=0,z)'),2}=CA0;
Datos{strcmp(Datos,'CB(t=0,z)'),2}=CB0;
Datos{strcmp(Datos,'CC(t=0,z)'),2}=CC0;
Datos{strcmp(Datos,'CD(t=0,z)'),2}=CD0;
Datos{strcmp(Datos,'CE(t=0,z)'),2}=CE0;
Datos{strcmp(Datos,'CF(t=0,z)'),2}=CF0;
%%
% Tomar los valores que ahorita se calcularon y ponerlos en la tabla
% uitable1.
set(handles.uitable1,'Data',Datos);

function resultado = analisisEdoEst(hObject, eventdata, handles, varargin)
%% 3.4.1 An�lisis de estado estacionario
% Obtiene la soluci�n del estado estacionario
%%
% El modelo matem�tico en estado estacionario es un sistema de ecuaciones
% diferenciales con condiciones en la frontera pero unidimensional ya que
% se toma como de secci�n constante el tubo. (en z=0, CA = CA0, CB = CB0, 
% CC = CC0, T = T0).
%%
% $$u_z{{\partial C_A} \over {\partial z}} = -k_{11}(T)C_A$$
%%
% $$u_z{{\partial C_B} \over {\partial z}} = +k_{11}(T)C_A-k_{12}(T)C_B$$
%%
% $$u_z{{\partial C_C} \over {\partial z}} = +k_{12}(T)C_B$$
%%
% $$u_z{{\partial T} \over {\partial z}} = {{1}\over{\rho Cp}}\times
% [+(-\Delta Hr_1)\times k_{11}(T)C_A+(-\Delta Hr_2)\times k_{12}(T)C_B]
% + urem(z)$$
%%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global E1 E2 E3 k110 k120 k130 T0ref
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global uz uza
global MA MB rho_Cp R tiempoSoluciones isotermico Tmax Tmin

if isotermico
    M=[ uz 0 0 0 0 0 ;
        0 uz 0 0 0 0 ;
        0 0 uz 0 0 0 ;
        0 0 0 uz 0 0 ;
        0 0 0 0 uz 0 ;
        0 0 0 0 0 uz ;
        ];
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,'Events',@odeabort,...
        'AbsTol',1e-10);
    [Ta00,yval]=fsolve(@(Ta)f_est_isot_encontrar_Taz...
        ([CA0z,CB0z,CC0z,CD0z,CE0z,CF0z,T0z,Ta00],Ta),Ta00,...
        optimset('TolX',1e-10,'Display','off'));
    ErrorBalance = yval;
    [z,Y]=ode15s(@(t,y)f_est_isot(t,y,T0z),[0,Longitud],...
        [CA0z,CB0z,CC0z,CD0z,CE0z,CF0z],odeOptions);   
    CA=Y(:,1);CB=Y(:,2);CC=Y(:,3);CD=Y(:,4);CE=Y(:,5);CF=Y(:,6);
    T=T0z*ones(size(Y(:,1)));
    Ta=NaN*ones(size(Y(:,1)));
    DiametroExt=NaN*ones(size(Y(:,1)));
    Ta(1) = Ta00;
    for i=2:length(T)
        Ta(i)=fsolve(@(TaVar)f_est_isot_encontrar_Taz...
        ([CA(i),CB(i),CC(i),CD(i),CE(i),CF(i),T(i),Ta(i-1)],TaVar),...
        Ta(i-1),optimset('TolX',1e-10,'Display','off'));
        ErrorBalance(i) = CalculateError(z(i),...
            [CA(i),CB(i),CC(i),CD(i),CE(i),CF(i),Ta(i)],T(i));
        DiametroExt(i-1) = sqrt((Ta(i)-Ta(i-1))/(z(i)-z(i-1))/...
        qa(U,a,rho_Cpa,T0z,Ta00,inf)*rho_Cpa*Q0a*1000*4/pi+Diametro^2);   
        % Q0a/1000=pi/4*(Da^2-D^2)*uaz
    end
    DiametroExt(end) = sqrt((Ta(end)-Ta(end-1))/(z(end)-z(end-1))/...
        qa(U,a,rho_Cpa,T0z,Ta00,inf)*rho_Cpa*Q0a*4/pi*1000+Diametro^2);
    
    qi_est=qi(U,a,rho_Cp,T,Ta,inf);
    qa_est=qa(U,a,rho_Cpa,T,Ta,inf);
    axes(handles.axes1);
else
    M=[ uz 0 0 0 0 0 0 0; 
        0 uz 0 0 0 0 0 0; 
        0 0 uz 0 0 0 0 0;
        0 0 0 uz 0 0 0 0;
        0 0 0 0 uz 0 0 0;
        0 0 0 0 0 uz 0 0; 
        0 0 0 0 0 0 uz 0;
        0 0 0 0 0 0 0 uza;
        ];
    odeOptions=odeset('Mass',M,'OutputFcn',@odeprog,'Events',@odeabort);
    [z,Y]=ode15s(@f_est,[0,Longitud],...
        [CA0z,CB0z,CC0z,CD0z,CE0z,CF0z,T0z,Ta00],odeOptions);
    CA=Y(:,1);CB=Y(:,2);CC=Y(:,3);CD=Y(:,4);CE=Y(:,5);CF=Y(:,6);
    T=Y(:,7);Ta=Y(:,8);
    
    DiametroExt = sqrt(Q0a*1000/uza*4/pi +Diametro^2)*ones(size(z));
    
    qi_est=qi(U,a,rho_Cp,T,Ta,inf);
    qa_est=qa(U,a,rho_Cpa,T,Ta,inf);
end
resultado = {'T',T,'CA',CA,'CB',CB,'CC',CC,'CD',CD,'CE',CE,'CF',CF,...
    'Ta',Ta,'z',z,'qi',qi_est,'qa',qa_est,'DiametroExt',DiametroExt};

function graficarEdoEst(hObject, eventdata, handles, varargin)
%% 3.4.2 Graficar estado estacionario
% Grafica la soluci�n del estado estacionario
%%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global MA MB rho_Cp R tiempoSoluciones isotermico
%%
% Esta variable *solucionAnalisisEstacionario* se defini� en la secci�n
% Arranque y almacena la soluci�n del estado estacionario en la forma 
% {'T',T,'CA',CA,'CB',CB,'Urem',Urem}
global solucionAnalisisEstacionario
%%
% Extraer de la soluci�n las series de valores de cada variable para poder 
% hacer las gr�ficas correspondientes. Se usa la funci�n find y strcmp 
% porque la convenci�n fue poner el nombre de la variable como String (tipo
% de variable de texto ) y el siguiente elemento la matriz con los valores 
% de �sta. 
%% 
% strcmp compara la matriz de soluci�n con el texto que est� como segundo
% par�metro y regresa una matriz del tama�o de la matriz de soluci�n, con
% ceros donde no es igual el texto y unos donde s� es igual
%%
% find regresa los �ndices de los elementos que no son cero, se le suma 1
% porque el siguiente elemento del texto es ya la tabla de valores de la
% variable.
T=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'T'))+1};
Ta=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'Ta'))+1};
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
z=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'z'))+1};
qi_est=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'qi'))+1};
qa_est=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'qa'))+1};
DiametroExt=solucionAnalisisEstacionario{...
    find(strcmp(solucionAnalisisEstacionario,'DiametroExt'))+1};
Y_B_A0 = CB/CA(1);
X_A = 1-CA/CA(1);
%%
% Escoger colores para graficar.
set(0,'DefaultAxesColorOrder',[0.2,0.5,0.8 ; 0.8,0.5,0.1; 0.1,0.8,0.05 ]);
%%
% Esta parte es para decidir qu� se graficar� contra qu�, ya que hay una
% caja popmenu1 con opciones para graficar , conteniendo las opciones  {'C
% vs urem';'T vs urem';'C vs T';'T vs C'}
numeroDeOpcion = get(handles.popupmenu1,'Value');
opciones = get(handles.popupmenu1,'String');
opcionSeleccionada = opciones{numeroDeOpcion};
%%
% En base a la opci�n que en este momento muestra la caja de opciones
% popmenu1, graficar las variables correspondientes.
switch opcionSeleccionada
    case 'C vs z'
        plot(handles.axes1,z,CA,'-.',z,CB,'-',z,CC,'--',...
            z,CD,':',z,CE,'-o',z,CF,'-s');        
%         LinkTopAxisData(handles.axes1,get(handles.axes1,'XTick'),...
%             get(handles.axes1,'XTick'),'V / m3');
        limitesAuto = get(handles.axes1,'YLim');
        set(handles.axes1,'YLim',[0 limitesAuto(2)]);
        xlabel(handles.axes1,'z., cm');
        ylabel(handles.axes1,'Conc., mol/L');
        legend(handles.axes1,'CA','CB','CC','CD','CE','CF',...
            'Location','North');        
    case 'T vs z'
        plot(handles.axes1,z,T,'-',z,Ta,'-^');        
        xlabel('z., cm');
        ylabel('T, �K');
        legend('T','Ta, �K','Location','North');    
    case 'r vs z'
        
    case 'qi vs z'
        plot(handles.axes1,z,qi_est*rho_Cp,'-^',z,qa_est*rho_Cpa,'-sq');
        xlabel('z., cm');
        ylabel('qi, �K/min');
        legend('qi','qa','Location','North');
    case 'Y vs X'
        plot(handles.axes1,X_A,Y_B_A0,'-^');
        xlabel('1-A/A0');
        ylabel('B/A0');
        xlim([0,1]);    
    case 'Diametro ext. vs z'
        plot(handles.axes1,z,DiametroExt,'-^',z,Diametro*ones(size(z)),'-');
        xlabel('z., cm');
        ylabel('Di�metroExt, cm');
        legend('Diametro Ext.','Diametro Int.','Location','North');
end

title('Estado Estacionario');
%%
% Regresar a los colores default para las gr�ficas.
set(0,'DefaultAxesColorOrder','remove');
datacursormode on;
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
%% 3.5.1 An�lisis de estado no-estacionario
% Obtiene la soluci�n del estado no-estacionario
%%
% El modelo matem�tico en estado estacionario es un sistema de ecuaciones
% diferenciales parciales con condiciones en la frontera e iniciales (en 
% t=0, CA(0,z)=CA0z, CB(0,z)=CB0z, CC(0,z)=CC0z, T(0,z)=T0z). A dem�s, en 
%%
% $${{\partial C_A} \over {\partial t}}+
% u_z{{\partial C_A} \over {\partial z}} = -k_{11}(T)C_A$$
%%
% $${{\partial C_B} \over {\partial t}}+
% u_z{{\partial C_B} \over {\partial z}} = +k_{11}(T)C_A-k_{12}(T)C_B$$
%%
% $${{\partial C_C} \over {\partial t}}+
% u_z{{\partial C_C} \over {\partial z}} = +k_{12}(T)C_B$$
%%
% $${{\partial T} \over {\partial t}}+
% u_z{{\partial T} \over {\partial z}} = {{1}\over{\rho Cp}}\times$$
%%
% $$[+(-\Delta Hr_1)\times k_{11}(T)C_A+(-\Delta Hr_2)\times k_{12}(T)C_B]
% +urem(z,t)$$
%%
global delta_Hf_A delta_Hf_B delta_Hr_1 delta_Hr_2 E1 E2 k110 k120 T0ref
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global uz uza
global MA MB rho_Cp R tiempoSoluciones isotermico Tmax Tmin
global solucionAnalisisEstacionario
 
if isempty(solucionAnalisisEstacionario)
    %%
    % Obtener la soluci�n del estado estacionario con los valores que
    % se extrajeron de la tabla, y almacenarlo en la variable
    % *solucionAnalisisEstacionario*. El c�digo de la funci�n est�
    % definido arriba.
    solucionAnalisisEstacionario =...
        analisisEdoEst(hObject, eventdata, handles, varargin);  
end

nPuntos=50;
nTiempos=70;
z=linspace(0,Longitud,nPuntos);
t=linspace(0,tiempoSoluciones,nTiempos);
CA=NaN*zeros(nPuntos,nTiempos);
CB=NaN*zeros(nPuntos,nTiempos);
CC=NaN*zeros(nPuntos,nTiempos);
CD=NaN*zeros(nPuntos,nTiempos);
CE=NaN*zeros(nPuntos,nTiempos);
CF=NaN*zeros(nPuntos,nTiempos);
T=NaN*zeros(nPuntos,nTiempos);
Ta=NaN*zeros(nPuntos,nTiempos);

y0=[CA0z*ones(1,nPuntos);CB0z*ones(1,nPuntos);...
    CC0z*ones(1,nPuntos);CD0z*ones(1,nPuntos);...
    CE0z*ones(1,nPuntos);CF0z*ones(1,nPuntos);...
    T0z*ones(1,nPuntos);
    Ta00*ones(1,nPuntos)];
if ~isotermico
    solucion=setup(1,@sis_edp_1,t(1),z,y0,'SLxW',[],...
        @(t,yL,yR)cfr_edp_1(t,yL,yR,y0(:,1)),{[],[]});
else
    solucion=setup(1,@sis_edp_2,t(1),z,y0,'SLxW',[],...
        @(t,yL,yR)cfr_edp_1(t,yL,yR,y0(:,1)),{[],[]});
end
solucion.u(solucion.u<1e-10)=0;
Y(:,:,1)=solucion.u';
CA(:,1)=squeeze(Y(:,1,:));CB(:,1)=squeeze(Y(:,2,:));
CC(:,1)=squeeze(Y(:,3,:));CD(:,1)=squeeze(Y(:,4,:));
CE(:,1)=squeeze(Y(:,5,:));CF(:,1)=squeeze(Y(:,6,:));
T(:,1)=squeeze(Y(:,7,:));Ta(:,1)=squeeze(Y(:,8,:));
qi_no_est=qi(U,a,rho_Cp,T,Ta,t);
qa_no_est=qa(U,a,rho_Cpa,T,Ta,t);
BarraDeEstado=waitbar(0,' ','Name','Resolviendo',...
    'CreateCancelBtn','setappdata(gcbf,''canceling'',1)');
setappdata(BarraDeEstado,'canceling',0);
plot(handles.axes1,z,CA(:,1),z,CB(:,1),z,CC(:,1),z,CD(:,1),...
    z,CE(:,1),z,CF(:,1));
legend(handles.axes1,'CA','CB','CC','CD','CE','CF');
% set(get(handles.axes1,'Children'),'YDataSource','CA');
for i=2:nTiempos
    if getappdata(BarraDeEstado,'canceling')
        break
    end
    estatus=[sprintf('%e',t(i)) 'min de ' sprintf('%e',t(end))...
        'min (' sprintf('%u',round(t(i)/t(end)*100)) '%)'];
    plot(handles.axes1,z,CA(:,i-1),z,CB(:,i-1),z,CC(:,i-1),z,CD(:,i-1),...
        z,CE(:,i-1),z,CF(:,i-1));
    legend(handles.axes1,'CA','CB','CC','CD','CE','CF');
    %     refreshdata(get(handles.axes1,'Children'));
    waitbar(t(i)/t(end),BarraDeEstado,estatus);
    solucion=hpde(solucion,t(i),@timestep);
    solucion.u(solucion.u<=1e-10)=0;
    Y(:,:,i)=solucion.u';
    CA(:,i)=squeeze(Y(:,1,i));
    CB(:,i)=squeeze(Y(:,2,i));
    CC(:,i)=squeeze(Y(:,3,i));
    CD(:,i)=squeeze(Y(:,4,i));
    CE(:,i)=squeeze(Y(:,5,i));
    CF(:,i)=squeeze(Y(:,6,i));
    T(:,i)=squeeze(Y(:,7,i));
    Ta(:,i)=squeeze(Y(:,8,i));
    qi_no_est(:,i)=qi(U,a,rho_Cp,T(:,i),Ta(:,i),t(i));
    qa_no_est(:,i)=qa(U,a,rho_Cpa,T(:,i),Ta(:,i),t(i));
end
delete(BarraDeEstado);
resultado={'t',t,'z',z,'CA',CA,'CB',CB,'CC',CC,'CD',CD,'CE',CE,'CF',CF,...
    'T',T,'Ta',Ta,'qi_no_est',qi_no_est,'qa_no_est',qa_no_est};

function graficarEdoNoEst(hObject, eventdata, handles, varargin);
%% 3.5.2 Graficar estado no-estacionario
% Grafica la soluci�n del estado no-estacionario
%%
% Las sig. variables globales se definieron en la secci�n de Obtener datos.
global qi_U_A_rho_Cp_T_Ta_t
%%
% Esta variable *solucionAnalisisEstacionario* se defini� en la secci�n
% Arranque y almacena la soluci�n del estado estacionario en la forma 
% {'T',T,'CA',CA,'CB',CB,'Urem',Urem}
global solucionAnalisisNoEstacionario
%%
% Extraer de la soluci�n las series de valores de cada variable para poder 
% hacer las gr�ficas correspondientes. Se usa la funci�n find y strcmp 
% porque la convenci�n fue poner el nombre de la variable como String (tipo
% de variable de texto ) y el siguiente elemento la matriz con los valores 
% de �sta. 
%% 
% strcmp compara la matriz de soluci�n con el texto que est� como segundo
% par�metro y regresa una matriz del tama�o de la matriz de soluci�n, con
% ceros donde no es igual el texto y unos donde s� es igual
%%
% find regresa los �ndices de los elementos que no son cero, se le suma 1
% porque el siguiente elemento del texto es ya la tabla de valores de la
% variable.
z=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'z'))+1};
t=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'t'))+1};
CA=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'CA'))+1};
CB=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'CB'))+1};
CC=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'CC'))+1};
CD=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'CD'))+1};
CE=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'CE'))+1};
CF=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'CF'))+1};
T=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'T'))+1};
Ta=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'Ta'))+1};
qi_no_est=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'qi_no_est'))+1};
qa_no_est=solucionAnalisisNoEstacionario{...
    find(strcmp(solucionAnalisisNoEstacionario,'qa_no_est'))+1};
%%
% Escoger colores para graficar.
set(0,'DefaultAxesColorOrder',[0.2,0.5,0.8 ; 0.8,0.5,0.1]);
%%
% Esta parte es para decidir qu� se graficar� contra qu�, ya que hay una
% caja popmenu1 con opciones para graficar , conteniendo las opciones  {'C
% vs urem';'T vs urem';'C vs T';'T vs C'}
numeroDeOpcion = get(handles.popupmenu1,'Value');
opciones = get(handles.popupmenu1,'String');
opcionSeleccionada = opciones{numeroDeOpcion};
%%
% En base a la opci�n que en este momento muestra la caja de opciones
% popmenu1, graficar las variables correspondientes.
switch opcionSeleccionada
    case 'C vs z'       
        plot(handles.axes1,z,CA(:,end),z,CB(:,end),z,CC(:,end),...
            z,CD(:,end),z,CE(:,end),z,CF(:,end));        
        xlabel(handles.axes1,'z, cm');
        ylabel(handles.axes1,'Conc., mol/L');
        legend(handles.axes1,'CA','CB', 'CC');        
    case 'C vs z,t'        
        colormap summer;                
        surf(handles.axes1,t,z,CA,'FaceColor','r');        
        hold on;        
        surf(handles.axes1,t,z,CB,'FaceColor','g');        
        surf(handles.axes1,t,z,CC,'FaceColor','y');
        surf(handles.axes1,t,z,CD,'FaceColor','c');
        surf(handles.axes1,t,z,CE,'FaceColor','b');
        surf(handles.axes1,t,z,CF,'FaceColor','m');
        hold off;       
        xlabel(handles.axes1,'t, min');
        ylabel(handles.axes1,'z, cm');
        zlabel(handles.axes1,'CA,CB,CC, mol/L');
        legend('CA','CB','CC','CD','CE','CF');
    case 'T vs z,t'
        surfc(handles.axes1,t,z,T);
        hold on;        
        surfc(handles.axes1,t,z,Ta);
        hold off;
        xlabel(handles.axes1,'t, min');
        ylabel(handles.axes1,'z, cm');
        zlabel(handles.axes1,'T, �K');
    case 'qi vs z'
        surfc(handles.axes1,t,z,qi_no_est);
        xlabel(handles.axes1,'t, min');
        ylabel(handles.axes1,'z, cm');
        zlabel(handles.axes1,'qi_U_A_rho_Cp_T_Ta_t, �K/min');        
    case 'C vs T'
        surf(handles.axes1,T,z,CA,'FaceColor','r');        
        hold on;        
        surf(handles.axes1,T,z,CB,'FaceColor','g');        
        surf(handles.axes1,T,z,CC,'FaceColor','y');
        surf(handles.axes1,T,z,CD,'FaceColor','c');
        surf(handles.axes1,T,z,CE,'FaceColor','b');
        surf(handles.axes1,T,z,CF,'FaceColor','m');
        hold off;               
        zlabel(handles.axes1,'CA,CB,CC, mol/L');
        xlabel(handles.axes1,'T, �K');
        ylabel(handles.axes1,'z, cm');
        legend('CA','CB','CC','CD','CE','CF');
end

% title(handles.axes1,'Estado No Estacionario');
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

%% 4. SUBFUNCIONES
% Estas subfunciones se usan recurrentemente por las funciones de an�lisis
% de estado estacionario y no estacionario.
%%

function resultado = f_est_isot(t,y,T)
%% 4.1.1 Funci�n objetivo Estado Estacionario, No Isot�rmico, Adiab�tico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es qi(z)
r1=k11(T)*y(1)^alfa(1,1)*y(2)^alfa(1,2)*y(3)^alfa(1,3)*...
    y(4)^alfa(1,4)*y(5)^alfa(1,5)*y(6)^alfa(1,6);
r2=k12(T)*y(1)^alfa(2,1)*y(2)^alfa(2,2)*y(3)^alfa(2,3)*...
    y(4)^alfa(2,4)*y(5)^alfa(2,5)*y(6)^alfa(2,6);
r3=k13(T)*y(1)^alfa(3,1)*y(2)^alfa(3,2)*y(3)^alfa(3,3)*...
    y(4)^alfa(3,4)*y(5)^alfa(3,5)*y(6)^alfa(3,6);
resultado = [...
    nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
%     1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+...
%     qi(U,a,rho_Cp,T,y(7),inf);
%     1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+...
%     qi(U,a,rho_Cp,T,y(7),inf)+qa(U,a,rho_Cpa,T,y(7),inf);
    ];

function ErrorBalance = CalculateError(t,y,T)
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global MA MB rho_Cp R tiempoSoluciones
r1=k11(T)*y(1)^alfa(1,1)*y(2)^alfa(1,2)*y(3)^alfa(1,3)*...
    y(4)^alfa(1,4)*y(5)^alfa(1,5)*y(6)^alfa(1,6);
r2=k12(T)*y(1)^alfa(2,1)*y(2)^alfa(2,2)*y(3)^alfa(2,3)*...
    y(4)^alfa(2,4)*y(5)^alfa(2,5)*y(6)^alfa(2,6);
r3=k13(T)*y(1)^alfa(3,1)*y(2)^alfa(3,2)*y(3)^alfa(3,3)*...
    y(4)^alfa(3,4)*y(5)^alfa(3,5)*y(6)^alfa(3,6);
ErrorBalance = ...
    1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+...
    qi(U,a,rho_Cp,T,y(7),inf);

function resultado = f_est_isot_encontrar_Taz(y,Ta)
%% 4.1.1 Funci�n objetivo Estado Estacionario, No Isot�rmico, Adiab�tico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es qi(z)
T=y(7);
r1=k11(T)*y(1)^alfa(1,1)*y(2)^alfa(1,2)*y(3)^alfa(1,3)*...
    y(4)^alfa(1,4)*y(5)^alfa(1,5)*y(6)^alfa(1,6);
r2=k12(T)*y(1)^alfa(2,1)*y(2)^alfa(2,2)*y(3)^alfa(2,3)*...
    y(4)^alfa(2,4)*y(5)^alfa(2,5)*y(6)^alfa(2,6);
r3=k13(T)*y(1)^alfa(3,1)*y(2)^alfa(3,2)*y(3)^alfa(3,3)*...
    y(4)^alfa(3,4)*y(5)^alfa(3,5)*y(6)^alfa(3,6);
resultado = ...
    1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+...
    qi(U,a,rho_Cp,T,Ta,inf);

function resultado = f_est(t,y)
%% 4.1.1 Funci�n objetivo Estado Estacionario, No Isot�rmico, Adiab�tico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es T(z)
r1=k11(y(7))*y(1)^alfa(1,1)*y(2)^alfa(1,2)*y(3)^alfa(1,3)*...
    y(4)^alfa(1,4)*y(5)^alfa(1,5)*y(6)^alfa(1,6);
r2=k12(y(7))*y(1)^alfa(2,1)*y(2)^alfa(2,2)*y(3)^alfa(2,3)*...
    y(4)^alfa(2,4)*y(5)^alfa(2,5)*y(6)^alfa(2,6);
r3=k13(y(7))*y(1)^alfa(3,1)*y(2)^alfa(3,2)*y(3)^alfa(3,3)*...
    y(4)^alfa(3,4)*y(5)^alfa(3,5)*y(6)^alfa(3,6);
resultado = [...
    nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
    1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+(-delta_Hr_3)*r3)+...
    qi(U,a,rho_Cp,y(7),y(8),inf);
    qa(U,a,rho_Cpa,y(7),y(8),inf);
    ];

function resultado = sis_edp_1(t,z,y,y_z)
%% 4.1.2.1 Funci�n objetivo Estado No-Estacionario, No Isot�rmico, No Adiab�tico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global uz uza
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es T(z)
r1=k11(y(7,:)).*y(1,:).^alfa(1,1).*y(2,:).^alfa(1,2).*y(3,:).^alfa(1,3).*...
    y(4,:).^alfa(1,4).*y(5,:).^alfa(1,5).*y(6,:).^alfa(1,6);
r2=k12(y(7,:)).*y(1,:).^alfa(2,1).*y(2,:).^alfa(2,2).*y(3,:).^alfa(2,3).*...
    y(4,:).^alfa(2,4).*y(5,:).^alfa(2,5).*y(6,:).^alfa(2,6);
r3=k13(y(7,:)).*y(1,:).^alfa(3,1).*y(2,:).^alfa(3,2).*y(3,:).^alfa(3,3).*...
    y(4,:).^alfa(3,4).*y(5,:).^alfa(3,5).*y(6,:).^alfa(3,6);
resultado = [...
    -uz*y_z(1,:)+nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    -uz*y_z(2,:)+nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    -uz*y_z(3,:)+nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    -uz*y_z(4,:)+nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    -uz*y_z(5,:)+nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    -uz*y_z(6,:)+nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;    
    -uz*y_z(7,:)+ 1/(rho_Cp)*(+(-delta_Hr_1)*r1+(-delta_Hr_2)*r2+...
    (-delta_Hr_3)*r3)+qi(U,a,rho_Cp,y(7,:),y(8,:),inf);
    -uza*y_z(8,:)+qa(U,a,rho_Cpa,y(7,:),y(8,:),inf);
    ];

function resultado = sis_edp_2(t,z,y,y_z)
%% 4.1.2.1 Funci�n objetivo Estado No-Estacionario, Isot�rmico, No-Adiab�tico
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z CD0z CE0z CF0z T0z CA0 CB0 CC0 CD0 CE0 CF0 T0 
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global uz uza
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es T(z)
r1=k11(y(7,:)).*y(1,:).^alfa(1,1).*y(2,:).^alfa(1,2).*y(3,:).^alfa(1,3).*...
    y(4,:).^alfa(1,4).*y(5,:).^alfa(1,5).*y(6,:).^alfa(1,6);
r2=k12(y(7,:)).*y(1,:).^alfa(2,1).*y(2,:).^alfa(2,2).*y(3,:).^alfa(2,3).*...
    y(4,:).^alfa(2,4).*y(5,:).^alfa(2,5).*y(6,:).^alfa(2,6);
r3=k13(y(7,:)).*y(1,:).^alfa(3,1).*y(2,:).^alfa(3,2).*y(3,:).^alfa(3,3).*...
    y(4,:).^alfa(3,4).*y(5,:).^alfa(3,5).*y(6,:).^alfa(3,6);
resultado = [...
    -uz*y_z(1,:)+nu(1,1)*r1+nu(2,1)*r2+nu(3,1)*r3;
    -uz*y_z(2,:)+nu(1,2)*r1+nu(2,2)*r2+nu(3,2)*r3;
    -uz*y_z(3,:)+nu(1,3)*r1+nu(2,3)*r2+nu(3,3)*r3;
    -uz*y_z(4,:)+nu(1,4)*r1+nu(2,4)*r2+nu(3,4)*r3;
    -uz*y_z(5,:)+nu(1,5)*r1+nu(2,5)*r2+nu(3,5)*r3;
    -uz*y_z(6,:)+nu(1,6)*r1+nu(2,6)*r2+nu(3,6)*r3;
    0*ones(size(y(7,:)));
    -uza*y_z(8,:)+qa(U,a,rho_Cpa,y(7,:),y(8,:),inf);
    ];

function [yL,yR] = cfr_edp_1(t,yL,yR,yL_condicion)
%% 4.1.2.2 Condiciones a la frontera para el sistema de EDP 4.1.2.1
global delta_Hr_1 delta_Hr_2 delta_Hr_3 nu alfa
global CA0z CB0z CC0z T0z CA0 CB0 CC0 T0
global Longitud Diametro Vr Q0 Q0a theta qi_U_A_rho_Cp_T_Ta_t U a
global rho_Cpa Ta00 qa_U_A_rho_Cpa_T_Ta_t
global uz uza
global MA MB rho_Cp R tiempoSoluciones
%%
%  La manera en que se estableci� en la secci�n de An�lisis de estado no-
% estacionario es y = [CA CB CC T]. Por lo tanto:
% y(1) es CA(z)
% y(2) es CB(z)
% y(3) es CC(z)
% y(4) es T(z)
yL=yL_condicion;

function dt = timestep(dx,t,x,V)
        mumax1 = max(abs(V(1,:) + sqrt(1+V(2,:))));
        mumax2 = max(abs(V(1,:) - sqrt(1+V(2,:))));
        dt = 0.009*dx/max(mumax1,mumax2);

function k11 = k11(T)
%% 4.2.1 Expresi�n de Arrhenius
% k de T por expr. de Arrhenius
global k110 E1 R T0ref
k11 = k110*exp(-E1/R*(1./T-1/T0ref));

function k12 = k12(T)
%% 4.2.2 Expresi�n de Arrhenius
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
function resultado=qi(U,a,rho_Cp,T,Ta,t)
%% 2.4.1. Evaluar qi(U,a,rho_Cp,T,Ta,t) a un tiempo t dado
% A partir del valor de texto que tiene el campo. Por omisi�n,
% $qi={{U A} \over {\rho Cp}} \times(Ta-T)$
global qi_U_A_rho_Cp_T_Ta_t gui5_variables_default
try
resultado = eval(qi_U_A_rho_Cp_T_Ta_t);
catch exception    
    Datos=gui5_variables_default(2:end,1:3);
    qi_U_A_rho_Cp_T_Ta_t = Datos{strcmp(Datos,'qi(U,a,rho_Cp,T,Ta,t)'),2};
    errordlg(sprintf(['qi(U,a,rho_Cp,T,Ta,t) no fue correctamente insertada,'...
        ' se utiliza el valor default que es:' qi_U_A_rho_Cp_T_Ta_t...
        ' \n' exception.identifier]),...
        'WindowStyle','modal');        
    resultado = eval(qi_U_A_rho_Cp_T_Ta_t);
end

function resultado=qa(U,a,rho_Cpa,T,Ta,t)
%% 2.4.1. Evaluar qi(U,a,rho_Cp,T,Ta,t) a un tiempo t dado
% A partir del valor de texto que tiene el campo. Por omisi�n,
% $qi={{U A} \over {\rho Cp}} \times(Ta-T)$
global qa_U_A_rho_Cpa_T_Ta_t gui5_variables_default
try
resultado = eval(qa_U_A_rho_Cpa_T_Ta_t);
catch exception    
    Datos=gui5_variables_default(2:end,1:3);
    qa_U_A_rho_Cpa_T_Ta_t =...
        Datos{strcmp(Datos,'qa(U,a,rho_Cpa,T,Ta,t)'),2};
    errordlg(sprintf(['qa(U,a,rho_Cpa,T,Ta,t) no fue correctamente insertada,'...
        ' se utiliza el valor default que es:' qa_U_A_rho_Cpa_T_Ta_t...
        ' \n' exception.identifier]),...
        'WindowStyle','modal');        
    resultado = eval(qa_U_A_rho_Cpa_T_Ta_t);
end






















%% 5. BLOQUE DE C�DIGO PARA MANEJO DE TABLAS, MEN�S, ETC.
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
function varargout = gui5_OutputFcn(hObject, eventdata, handles) 
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
%         case 'Isot�rmico'
%             if eventdata.PreviousData==true
%                 Datos{strcmp(Datos,'qi(U,a,rho_Cp,Vr,T,Ta,Ta0,t)'),2}=...
%                     'U*a/(Vr*rho_Cp)*(Ta-T)';
%                 set(handles.uitable1,'Data',Datos);
%             end
%             actualizarGraficas(hObject, eventdata, handles);
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
        case 'delta Hf A'
            
        case 'delta Hf B'
            
        case 'delta Hr'
            
    end
end
actualizarGraficas(hObject, eventdata, handles);


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global hacerAnalisisEstacionario
if hacerAnalisisEstacionario
    set(handles.Untitled_1,'Label','No Estacionario ==> Estacionario');
    set(handles.popupmenu1,'String',...
        {'C vs z,t';'T vs z,t';'qi vs z';'C vs T';' '});
    hacerAnalisisEstacionario=false;
    actualizarGraficas(hObject, eventdata, handles);
else
    set(handles.Untitled_1,'Label','Estacionario ==> No Estacionario');
    set(handles.popupmenu1,'String',...
        {'C vs z';'T vs z';'qi vs z';'Y vs X';'Diametro ext. vs z'});
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
function Untitled_3_Callback(~, eventdata, handles)
% hObject    handle to Untitled_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('./html/gui5.html','-browser');

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
function Untitled_8_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
actualizarGraficas(hObject, eventdata, handles, {});

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


% --------------------------------------------------------------------
function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
[FileName,PathName,~]=uigetfile('*PFR*.mat');
if FileName~=0
    load([PathName filesep FileName],'gui5_variables_default');
    %
    % Poner estos valores en la tabla uitable1 (a la izq.)
    set(handles.uitable1,'Data',gui5_variables_default(2:end,1:3)); %#ok<COLND>
    set(handles.uitable1,'Columnname',gui5_variables_default(1,1:3));
    set(handles.uitable1,'Rowname',[]);
    set(handles.uitable1,'Columneditable',[false true false]);
    %
    % Correr el c�digo para actualizar ( o generar en dado caso) la gr�fica
    % solicitada.
    actualizarGraficas(hObject, eventdata, handles, {});
end


% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gui5_variables_default= get(handles.uitable1,'Data');
[FileName,PathName,FilterIndex]=uiputfile('./*PFR*.mat',...
    'Guardar estado de variables');
save(FileName, 'gui5_variables_default');