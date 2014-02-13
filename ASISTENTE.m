function varargout = ASISTENTE(varargin)
% ASISTENTE MATLAB code for ASISTENTE.fig
%      ASISTENTE, by itself, creates a new ASISTENTE or raises the existing
%      singleton*.
%
%      H = ASISTENTE returns the handle to a new ASISTENTE or the handle to
%      the existing singleton*.
%
%      ASISTENTE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ASISTENTE.M with the given input arguments.
%
%      ASISTENTE('Property','Value',...) creates a new ASISTENTE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ASISTENTE_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ASISTENTE_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ASISTENTE

% Last Modified by GUIDE v2.5 04-Feb-2014 23:34:48

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ASISTENTE_OpeningFcn, ...
                   'gui_OutputFcn',  @ASISTENTE_OutputFcn, ...
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
end


% --- Executes just before ASISTENTE is made visible.
function ASISTENTE_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ASISTENTE (see VARARGIN)

% Choose default command line output for ASISTENTE
handles.output = hObject;

im = image('Parent',handles.axes1,'CData',...
    imread([pwd,filesep,'utils',filesep,'TANQUE.png']));

set(handles.axes1,'YDir','reverse');
set(handles.axes1,...
    'XLimMode','auto',...
    'YLimMode','auto',...
    'ZLimMode','auto',...
    'YLim',get(im,'YData'),...
    'XLim',get(im,'XData'),...
    'Box','off','Layer','bottom',...
    'XTick',[],'YTick',[]);

set(handles.uitable1,'Data',...
    {...    
    'Isot'          ,false;...
    'Incompresible' ,true;...
    },...
    'ColumnEditable',[ false true ]);

set(handles.uitable2,'Data',...
    {...
    'delta_Hf_1'    -20     'kJ/gmol';...
    'delta_Hf_2'    -40     'kJ/gmol';...
    'delta_Hf_3'    -160    'kJ/gmol';...
    'Cp_Molares_1'  0.09    'kJ/(gmol K)';...
    'Cp_Molares_2'  0.09    'kJ/(gmol K)';...
    'Cp_Molares_3'  0.18    'kJ/(gmol K)';...
    'rhoCp_a'       0.0022  'kJ/(L K)';...
    },...
    'ColumnName',{  'VARIABLE'; 'VALOR'; 'UNIDADES' },...
    'ColumnWidth',{  100 'auto' 'auto' },...
    'ColumnEditable',[ false true false ]);

set(handles.uitable3,'Data',...
    {...
    'T0ref'         300     'K';...
    'k0_1'          600     '(1/min)(gmol/L)^(1-Sum_j(alpha_ij))';...
    'k0_2'          2.7     '(1/min)(gmol/L)^(1-Sum_j(alpha_ij))';...
    'E_1'           33256   'J/gmol';...
    'E_2'           74826   'J/gmol';...
    'Coefs_esteq_1,1'   -1  '[adim]';...
    'Coefs_esteq_1,2'   1   '[adim]';...
    'Coefs_esteq_1,3'   0   '[adim]';...
    'Coefs_esteq_2,1'   -2  '[adim]';...
    'Coefs_esteq_2,2'   0   '[adim]';...
    'Coefs_esteq_2,3'   1   '[adim]';...
    'Exponentes_r_1,1'  1   '[adim]';...
    'Exponentes_r_1,2'  0   '[adim]';...
    'Exponentes_r_1,3'  0   '[adim]';...
    'Exponentes_r_2,1'  2   '[adim]';...
    'Exponentes_r_2,2'  0   '[adim]';...
    'Exponentes_r_2,3'  0   '[adim]';...
    'Ref_Selectividad'  2   '[adim]';...
    'Ref_Rendimiento'   1   '[adim]';...
    },...
    'ColumnName',{  'VARIABLE'; 'VALOR'; 'UNIDADES' },...
    'ColumnWidth',{  100 'auto' 'auto' },...
    'ColumnEditable',[ false true false ]);

set(handles.uitable4,'Data',...
    {...
    'C. INICIALES'  ''          '';...
    'C0'            '[0.1,0,0]*1'     'gmol/L';...
    'T0'            423         'K';...
    'REACTOR'       ''          '';...
    'Longitud'      14.2        'cm';...
    'Diam'          9.468       'cm';...
    'U'             16675       'Btu/(h ft2 R)';...
    'A'             0.4547      'ft2';...
    'Ta0'           373         'K';...
    'Diam_a'        10.98288    'cm';...
    'Qa0'           20696.668   'L/min';...
    'INTEGRACIÓN'   ''          '';...
    'tiempo_tot'    1.6668E-005 'min';...
    },...
    'ColumnName',{  'VARIABLE'; 'VALOR'; 'UNIDADES' },...
    'ColumnWidth',{  'auto' 50 'auto' },...
    'ColumnEditable',[ false true false ]);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ASISTENTE wait for user response (see UIRESUME)
% uiwait(handles.figure1);
end

% --- Outputs from this function are returned to the command line.
function varargout = ASISTENTE_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;
end

% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% OK
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
menu    = get(handles.popupmenu1,'String');
tipo    = menu{get(handles.popupmenu1,'Value')};
load([pwd,filesep,'DATA',filesep,'TEMPLATE_',tipo,'.mat']);
if exist('TEMPLATE','var') == 1
    Datos   = TEMPLATE;
elseif ~(exist('TEMPLATE','var') == 1)
    Datos   ={};
end
n       = str2double(get(handles.edit1,'String'));
Nr      = str2double(get(handles.edit2,'String'));
datosDeComponentes      = get(handles.uitable2,'Data');
datosDeOperacion        = get(handles.uitable1,'Data');
datosDeReacciones       = get(handles.uitable3,'Data');
datosDeCondiciones      = get(handles.uitable4,'Data');

delta_Hf     = zeros(n,1);
Cp_Molares   = zeros(n,1);
E            = zeros(Nr,1);
k0           = zeros(Nr,1);
Coefs_esteq  = zeros(Nr,n);
Exponentes_r = zeros(Nr,n);

if ~isempty(n) && ~isempty(Nr) && ~isempty(Datos)
    for i=1:n
        delta_Hf(i)     = ...
            datosDeComponentes{strcmp(datosDeComponentes,...
            ['delta_Hf_',num2str(i)]),2};
        Cp_Molares(i)   = datosDeComponentes{strcmp(datosDeComponentes,...
            ['Cp_Molares_',num2str(i)]),2};
    end
    for i=1:Nr
        k0(i)                       = ...
            datosDeReacciones{strcmp(datosDeReacciones,...
            ['k0_',num2str(i)]),2};
        E(i)                        = ...
            datosDeReacciones{strcmp(datosDeReacciones,...
            ['E_',num2str(i)]),2};
        for j=1:n
            Coefs_esteq(i,j)        = ...
                datosDeReacciones{strcmp(datosDeReacciones,...
                ['Coefs_esteq_',num2str(i),',',num2str(j)]),2};
            Exponentes_r(i,j)        = ...
                datosDeReacciones{strcmp(datosDeReacciones,...
                ['Exponentes_r_',num2str(i),',',num2str(j)]),2};
        end
    end
end

Datos{strcmp(Datos,'Tipo'),2}        = tipo;

for i=1:size(Datos,1)
    if      ~strcmp(Datos{i,1},'OPERACIÓN') &&...
            ~strcmp(Datos{i,1},'REACCIÓN') &&...
            ~strcmp(Datos{i,1},'REACTOR') &&...
            ~strcmp(Datos{i,1},'PROPIEDADES') &&...
            ~strcmp(Datos{i,1},'INTEGRACIÓN')
        if exist(Datos{i,1},'var') == 1
            Datos{i,2} = eval(Datos{i,1});
        elseif any(strcmp(datosDeOperacion(:,1),Datos{i,1}))
            Datos{i,2} = ...
                datosDeOperacion{strcmp(datosDeOperacion,Datos{i,1}),2};
        elseif any(strcmp(datosDeReacciones(:,1),Datos{i,1}))
            Datos{i,2} = ...
                datosDeReacciones{strcmp(datosDeReacciones,Datos{i,1}),2};
        elseif any(strcmp(datosDeComponentes(:,1),Datos{i,1}))
            Datos{i,2} = ...
                datosDeComponentes{strcmp(datosDeComponentes,Datos{i,1}),2};
        elseif any(strcmp(datosDeCondiciones(:,1),Datos{i,1}))
            Datos{i,2} = ...
                datosDeCondiciones{strcmp(datosDeCondiciones,Datos{i,1}),2};
        end
        if ~isempty(Datos{i,2}) ...
                && ~isscalar(Datos{i,2}) ...
                && isnumeric(Datos{i,2})
            Datos{i,2} = mat2str(Datos{i,2});
        elseif ~isempty(Datos{i,2}) ...
                && isscalar(Datos{i,2}) ...
                && isnumeric(Datos{i,2})
            Datos{i,2} = num2str(Datos{i,2});
        end
    end
end

switch tipo
    case 'BR'
        
    case 'SEMIBR'
        
    case 'CSTR'
        Datos{strcmp(Datos,'Estacionario'),2}   = ...
            datosDeOperacion{strcmp(datosDeOperacion,'Estacionario'),2};        
    case 'PFR'
        Datos{strcmp(Datos,'Estacionario'),2}   = ...
            datosDeOperacion{strcmp(datosDeOperacion,'Estacionario'),2};
        Datos{strcmp(Datos,'Co_Corriente'),2}   = ...
            datosDeOperacion{strcmp(datosDeOperacion,'Co_Corriente'),2};
end

set(get(hObject,'Parent'),'UserData',Datos);
uiresume(get(hObject,'Parent'));
end

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% CANCEL
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if ishandle(get(hObject,'Parent')),delete(get(hObject,'Parent')),end
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1
end

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
end



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
end

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end



function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end

% --- Executes during object creation, after setting all properties.
function edit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
end
