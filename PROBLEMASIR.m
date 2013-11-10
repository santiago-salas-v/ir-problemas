function varargout = PROBLEMASIR(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PROBLEMASIR_OpeningFcn, ...
    'gui_OutputFcn',  @PROBLEMASIR_OutputFcn, ...
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
end
% End initialization code - DO NOT EDIT

%
function codigoDeArranque(hObject, eventdata, handles, varargin)
path(path,genpath('matlab_exts'));
handles.Datos=get(handles.uitable1,'Data');
set(handles.uitable1,'Data',handles.Datos);
set(handles.uitable1,'Rowname',[]);
set(handles.uitable1,'Columneditable',[false true false]);

actualizar(hObject, eventdata, handles, varargin)
end

function actualizar(hObject, eventdata, handles, varargin)

Datos=get(handles.uitable1,'Data');

try
    
    Datos_struct = obtenerDatos(Datos);
    
    if ~isequal(Datos,Datos_struct.DatosCalc)
        Datos=Datos_struct.DatosCalc;
        set(handles.uitable1,'Data',Datos);
    end
    
    if ~isfield(handles,'Datos_struct')...
            ||handles.Datos_struct.nComps~=Datos_struct.nComps...
            ||handles.Datos_struct.nReacs~=Datos_struct.nReacs...
            ||handles.Datos_struct.Ref_Selectividad~=...
            Datos_struct.Ref_Selectividad...
            ||handles.Datos_struct.Ref_Rendimiento~=...
            Datos_struct.Ref_Rendimiento...
            ||~strcmp(handles.Datos_struct.Tipo,...
            Datos_struct.Tipo)
        
        Datos_struct.VariablesDep(:,3)={false};
        Datos_struct.VariablesDep(cellfun(@(x)~isempty(x),...
            regexp(Datos_struct.VariablesDep(:,1),'^C.+')),3)={true};
        Datos_struct.VariablesDep(cellfun(@(x)~isempty(x),...
            regexp(Datos_struct.VariablesDep(:,1),'\WC.*\W')),3)={true};
        Datos_struct.VariablesDep(cellfun(@(x)~isempty(x),...
            regexp(Datos_struct.VariablesDep(:,1),'ESTACIONARIO')),3)=...
            {true};
        
        set(handles.uitable2,'Data',Datos_struct.VariablesDep);
        set(handles.popupmenu1,'String',Datos_struct.VariablesXZ(:,1));
        set(handles.popupmenu2,'String',Datos_struct.VariablesXZ(:,1));
        set(handles.popupmenu2,'Value',2);
    end
    if ~isfield(handles,'Datos_struct')...
            ||~isfield(handles.Datos_struct,'skipSolve')...
            ||~handles.Datos_struct.skipSolve
        Datos_struct=resolver(Datos_struct);
        graficar(hObject, eventdata, handles,Datos_struct);
        handles.Datos_struct=Datos_struct;
    else
        graficar(hObject, eventdata, handles,handles.Datos_struct);
    end
    if isfield(handles,'annotations')
        for i=1:numel(handles.annotations)
            delete(handles.annotations{i});
        end
        handles=rmfield(handles,'annotations');
    end
    handles.Datos_struct.skipSolve=false;
    openFigs=get(0,'Children');
    delete(openFigs(strcmp(get(openFigs,'Name'),'Calculando Edos. Est.')));
    guidata(hObject,handles);
catch exception
    if strcmp(exception.identifier,'InputError:Conditions')
        msgbox(exception.message,'Error','error');
    else
        msgbox(['Datos mal insertados. Message: ',exception.message],...
            'Error','error');
    end
    getReport(exception)
    openFigs=get(0,'Children');
    delete(openFigs(strcmp(get(openFigs,'Name'),'Calculando Edos. Est.')));
    cla(handles.axes1);
end
end

function Datos_struct1 = resolver(Datos_struct)
switch Datos_struct.Tipo
    case 'PFR'
        if Datos_struct.Estacionario
            Datos_struct1=resolverPFR(Datos_struct);
        else
            Datos_struct.Estacionario=true;
            Datos_struct1=resolverPFR(Datos_struct);
            Datos_struct1.Estacionario=false;
            Datos_struct1=resolverPFR(Datos_struct1);
        end
        
    case 'BR'
        Datos_struct1=resolverBR(Datos_struct);
        
    case 'CSTR'
        if Datos_struct.Estacionario
            Datos_struct1=resolverCSTR(Datos_struct);
        else
            Datos_struct.Estacionario=true;
            Datos_struct1=resolverCSTR(Datos_struct);
            Datos_struct1.Estacionario=false;
            Datos_struct1=resolverCSTR(Datos_struct1);
        end
        
    case 'SEMIBR'
        Datos_struct1=resolverSEMIBR(Datos_struct);
        
    otherwise
        Datos_struct1=Datos_struct;
        errRecord = MException('InputError:ReactorType',...
            'Error: Tipo de reactor');
        throw(errRecord);
end
end

function graficar(hObject, eventdata, handles, Datos_struct)
VariablesDep = get(handles.uitable2,'Data');
VariablesDepGraficadas=VariablesDep(cell2mat(VariablesDep(:,3)),:);
Variables_XZ = Datos_struct.VariablesXZ(:,1:2);
VariableIndep1Index = get(handles.popupmenu1,'Value');
VariableIndep1List = get(handles.popupmenu1,'String');
VariableIndep1String = VariableIndep1List{VariableIndep1Index};
VariableIndep2Index = get(handles.popupmenu2,'Value');
VariableIndep2List = get(handles.popupmenu2,'String');
VariableIndep2String = VariableIndep2List{VariableIndep2Index};

Datos_struct.colors=...
    [colormap('Hot');colormap('HSV')]/1.9;
Datos_struct.markerFaceColors=...
    [colormap('Cool');colormap('Jet')]/1.0;
Datos_struct.markerFaceCells= ...
    [...
    mat2cell(...
    [colormap('Cool');colormap('Jet')],...
    ones(size(...
    [colormap('Cool');colormap('Jet')],...
    1),1));...
    repmat({'none'},...
    size([colormap('Cool');colormap('Jet')],...
    1),1)...
    ];
Datos_struct.colors=...
    Datos_struct.colors(...
    randperm(size(Datos_struct.colors,1)),:);
Datos_struct.markerFaceCells=...
    Datos_struct.markerFaceCells(...
    randperm(size(Datos_struct.markerFaceCells,1)),:);
Datos_struct.linestyles=...
    {'--*','--o','-.x','-h','-.d','^-',...
    ':<','-s','--v',':s','--+','-p'};
Datos_struct.linestyles=...
    Datos_struct.linestyles(randperm(size(Datos_struct.linestyles,2)));
set(handles.uitoggletool9,'State','on');

if strcmp(Datos_struct.Tipo,'CSTR')
    Datos_struct.MostrarEstadosEstacionarios = VariablesDep{...
        strcmp(VariablesDep(:,1),'ESTACIONARIO'),3};
end

VarIndep1=VariableIndep1String(1);
VarIndep2=VariableIndep2String(1);

switch VarIndep1
    case 'z'
        X = Datos_struct.(VarIndep1);
    case 't'
        if Datos_struct.Estacionario ...
                && strcmp(Datos_struct.Tipo,'PFR')
            X = Datos_struct.z;
            VariableIndep1String='z';
            set(handles.popupmenu1,'Value',1);
        elseif strcmp(Datos_struct.Tipo,'CSTR')
            if Datos_struct.Estacionario
                X = Datos_struct.T;
                VariableIndep1String='T';
                set(handles.popupmenu1,'Value',1);
                X_Edos_Est = Datos_struct.T_Edos_Est;
            else
                X = Datos_struct.(VarIndep1);
                X_Edos_Est = max(X)*ones(size(Datos_struct.T_Edos_Est));
            end
        else
            X = Datos_struct.(VarIndep1);
        end
    case {'C' , 'X', 'Y', 'S'}
        if ~isempty(strfind(VariableIndep1String,'Yconsumo'))
            label=VariableIndep1String(...
                length('Yconsumo')+1:length(VariableIndep1String));
            VarIndep1='Yconsumo';
        else
            label=VariableIndep1String(2:length(VariableIndep1String));
        end
        index=cellfun(@(x)strcmp(x,label),...
            Datos_struct.labels);
        X=Datos_struct.(VarIndep1);
        X=squeeze(X(index,:,:));
        if strcmp(Datos_struct.Tipo,'CSTR')
            X_Edos_Est=Datos_struct.([VarIndep1,'_Edos_Est']);
            X_Edos_Est=squeeze(X_Edos_Est(index,:,:));
        end
    case 'Y_cons'
        label=VariableIndep1String(2:length(VariableIndep1String));
        index=cellfun(@(x)strcmp(x,label),...
            Datos_struct.labels);
        X=Datos_struct.(VarIndep1);
        X=squeeze(X(index,:,:));
        if strcmp(Datos_struct.Tipo,'CSTR')
            X_Edos_Est=Datos_struct.([VarIndep1,'_Edos_Est']);
            X_Edos_Est=squeeze(X_Edos_Est(index,:,:));
        end
    case 'T'
        X = Datos_struct.(VariableIndep1String);
        if strcmp(Datos_struct.Tipo,'CSTR')
            X_Edos_Est=Datos_struct.([VariableIndep1String,'_Edos_Est']);
        end
    case 'r'
        index=eval(VariableIndep1String(2:length(VariableIndep1String)));
        X=Datos_struct.(VarIndep1);
        X=squeeze(X(index,:,:));
        if strcmp(Datos_struct.Tipo,'CSTR')
            X_Edos_Est=Datos_struct.([VarIndep1,'_Edos_Est']);
            X_Edos_Est=squeeze(X_Edos_Est(index,:,:));
        end
    case 'q'
        X = Datos_struct.(VariableIndep1String);
        if strcmp(Datos_struct.Tipo,'CSTR')
            X_Edos_Est=Datos_struct.([VariableIndep1String,'_Edos_Est']);
        end
    case 'Q'
        X = Datos_struct.(VariableIndep1String);
        if strcmp(Datos_struct.Tipo,'CSTR')
            X_Edos_Est=Datos_struct.([VariableIndep1String,'_Edos_Est']);
        end
    case 'V'
        X = Datos_struct.(VariableIndep1String);
end

switch VarIndep2
    case 'z'
        Z = Datos_struct.(VarIndep2);
    case 't'
        if Datos_struct.Estacionario...
                && strcmp(Datos_struct.Tipo,'PFR')
            Z = Datos_struct.z;
            VariableIndep2String='z';
            set(handles.popupmenu2,'Value',1);
        elseif strcmp(Datos_struct.Tipo,'CSTR')
            Z = Datos_struct.T;
            VariableIndep2String='T';
            set(handles.popupmenu2,'Value',1);
            Z_Edos_Est = Datos_struct.T_Edos_Est;
        else
            Z = Datos_struct.(VarIndep2);
        end
    case {'C' , 'X', 'Y', 'S'}
        if ~isempty(strfind(VariableIndep2String,'Yconsumo'))
            label=VariableIndep2String(...
                length('Yconsumo')+1:length(VariableIndep2String));
            VarIndep2='Yconsumo';
        else
            label=VariableIndep2String(2:length(VariableIndep2String));
        end
        index=cellfun(@(x)strcmp(x,label),...
            Datos_struct.labels);
        Z=Datos_struct.(VarIndep2);
        Z=squeeze(Z(index,:,:));
        if strcmp(Datos_struct.Tipo,'CSTR')
            Z_Edos_Est=Datos_struct.([VarIndep2,'_Edos_Est']);
            Z_Edos_Est=squeeze(Z_Edos_Est(index,:,:));
        end
    case 'T'
        Z = Datos_struct.(VariableIndep2String);
        if strcmp(Datos_struct.Tipo,'CSTR')
            Z_Edos_Est=Datos_struct.([VariableIndep2String,'_Edos_Est']);
        end
    case 'r'
        index=eval(VariableIndep2String(2:length(VariableIndep2String)));
        Z=Datos_struct.(VarIndep2);
        Z=squeeze(Z(index,:,:));
        if strcmp(Datos_struct.Tipo,'CSTR')
            Z_Edos_Est=Datos_struct.([VarIndep2,'_Edos_Est']);
            Z_Edos_Est=squeeze(Z_Edos_Est(index,:,:));
        end
    case 'q'
        Z = Datos_struct.(VariableIndep2String);
        if strcmp(Datos_struct.Tipo,'CSTR')
            Z_Edos_Est=Datos_struct.([VariableIndep2String,'_Edos_Est']);
        end
    case 'Q'
        Z = Datos_struct.(VariableIndep2String);
        if strcmp(Datos_struct.Tipo,'CSTR')
            Z_Edos_Est=Datos_struct.([VariableIndep2String,'_Edos_Est']);
        end
    case 'V'
        Z = Datos_struct.(VariableIndep2String);
end

if strcmp(get(handles.Untitled_10, 'Checked'),'on')
    cla(handles.axes1,'reset');
end

legend(handles.axes1,'off');
box(handles.axes1,'on');
xlim(handles.axes1,'auto');
ylim(handles.axes1,'auto');
zlim(handles.axes1,'auto');
hold(handles.axes1,'on');

for i=1:size(VariablesDepGraficadas,1)
    Variable=VariablesDepGraficadas{i,1};
    if isempty(regexp(Variable,'\W.+\W','ONCE'))
        if strcmp(Variable,'ESTACIONARIO')
            Var=Variable;
        elseif ~strcmp(Variable,'ESTACIONARIO')
            Var=Variable(1);
        end
        if isfield(Datos_struct,Var)
            switch Var
                case {'C' , 'X', 'Y', 'S'}
                    if ~isempty(strfind(Variable,'Yconsumo'))
                        label=Variable(...
                            length('Yconsumo')+1:length(Variable));
                        Var='Yconsumo';
                    else
                        label=Variable(2:length(Variable));
                    end
                    index=cellfun(@(x)strcmp(x,label),...
                        Datos_struct.labels);
                    if strcmp(Datos_struct.Tipo,'CSTR')
                        Y=Datos_struct.(Var);
                        Y_Edos_Est=Datos_struct.([Var,'_Edos_Est']);
                        Y_Edos_Est=Y_Edos_Est(index,:);
                    else
                        Y=Datos_struct.(Var);
                    end
                    if ~isvector(Y)
                        Y=squeeze(Y(index,:,:));
                    else
                        Y=Y(index,:);
                    end
                    if strcmp(Var,'Y')||strcmp(Var,'Yconsumo')
                        Variable=[Variable,'/',...
                            Datos_struct.labels{...
                            Datos_struct.Ref_Rendimiento}];
                    end
                    if strcmp(Var,'S')
                        Variable=[Variable,'/',...
                            Datos_struct.labels{...
                            Datos_struct.Ref_Selectividad}];
                    end
                case 'T'
                    if strcmp(Datos_struct.Tipo,'CSTR')
                        Y=Datos_struct.(Variable);
                        Y_Edos_Est=Datos_struct.([Variable,'_Edos_Est']);
                    else
                        Y=Datos_struct.(Variable);
                    end
                case 'r'
                    index=eval(Variable(2:length(Variable)));
                    if strcmp(Datos_struct.Tipo,'CSTR')
                        Y=Datos_struct.(Var);
                        Y_Edos_Est=Datos_struct.([Var,'_Edos_Est']);
                        Y_Edos_Est=Y_Edos_Est(index,:);
                    else
                        Y=Datos_struct.(Var);
                    end
                    if ~isvector(Y)
                        Y=squeeze(Y(index,:,:));
                    else
                        Y=Y(index,:);
                    end
                case 'q'
                    if strcmp(Datos_struct.Tipo,'CSTR')
                        Y=Datos_struct.(Variable);
                        Y_Edos_Est=Datos_struct.([Variable,'_Edos_Est']);
                    else
                        Y=Datos_struct.(Variable);
                    end
                case 'Q'
                    if strcmp(Datos_struct.Tipo,'CSTR')
                        Y=Datos_struct.(Variable);
                        Y_Edos_Est=Datos_struct.([Variable,'_Edos_Est']);
                    else
                        Y=Datos_struct.(Variable);
                    end
                case 'V'
                    Y=Datos_struct.(Variable);
            end
            
            if ~Datos_struct.Estacionario ...
                    && ((VarIndep2=='z' && VarIndep1=='z')...
                    || (VarIndep2=='t' && VarIndep1=='t'))
                X = Datos_struct.z;
                Z = Datos_struct.t;
                VariableIndep1String='z';
                VariableIndep2String='t';
                set(handles.popupmenu1,'Value',1);
                set(handles.popupmenu2,'Value',2);
                X=X';
                Y=Y';
                Z=Z';
            elseif ~Datos_struct.Estacionario ...
                    && (VarIndep2=='t' || VarIndep1=='z')
                X=X';
                Y=Y';
                Z=Z';
            end
            
            linestylesIndex=i;
            colorsIndex=i;
            if i>length(Datos_struct.linestyles)
                linestylesIndex=...
                    mod((i-length(Datos_struct.linestyles)),...
                    length(Datos_struct.linestyles))+1;
            end
            if i>length(Datos_struct.colors)
                colorsIndex=...
                    mod((i-length(Datos_struct.colors)),...
                    length(Datos_struct.colors))+1;
            end
            
            if strcmp('2D',...
                    get(get(handles.uipanel2,'SelectedObject'),'String'))
                if ~isvector(Y)
                    h=surf(handles.axes1,X,Z,Y,...
                        'FaceColor',...
                        Datos_struct.colors(colorsIndex,:),...
                        'MarkerFaceColor',...
                        Datos_struct.markerFaceCells{colorsIndex},...
                        'FaceAlpha',0.6,...
                        'LineStyle','-','LineWidth',1e-8,...
                        'EdgeColor',[0.1,0.1,0.1]);
                    set(h(end),'DisplayName',[Variable,',',...
                        VariablesDepGraficadas{i,2}]);                 
                    set(h(end),'ButtonDownFcn',@inspeccionarLinea);
                    view(0,0);
                else
                    h=plot(handles.axes1,X,Y,...
                        Datos_struct.linestyles{linestylesIndex},...
                        'Color',...
                        Datos_struct.colors(colorsIndex,:),...
                        'MarkerFaceColor',...
                        Datos_struct.markerFaceCells{colorsIndex},...
                        'LineWidth',2);
                    set(h(end),'DisplayName',[Variable,',',...
                        VariablesDepGraficadas{i,2}]);
                    set(h(end),'ButtonDownFcn',@inspeccionarLinea);
                    if strcmp(Datos_struct.Tipo,'CSTR')...
                            && Datos_struct.MostrarEstadosEstacionarios
                        h=plot(handles.axes1,X_Edos_Est,Y_Edos_Est,...
                            Datos_struct.linestyles{linestylesIndex},...
                            'Color',Datos_struct.colors(colorsIndex,:),...                            
                            'LineWidth',2);
                        set(h(end),'DisplayName',[Variable,',',...
                            VariablesDepGraficadas{i,2},'_E_s_t']);
                        set(h(end),'MarkerSize',...
                            3*get(h(end),'MarkerSize'));
                        set(h(end),'LineStyle','none');
                        set(h(end),'ButtonDownFcn',@inspeccionarLinea);
                    end
                    view(2);
                end
            else
                if ~isvector(Y)
                    h=surf(handles.axes1,X,Z,Y,...
                        'FaceColor',...
                        Datos_struct.colors(colorsIndex,:),...
                        'MarkerFaceColor',...
                        Datos_struct.markerFaceCells{colorsIndex},...
                        'FaceAlpha',0.6,...
                        'LineStyle','-','LineWidth',1e-8,...
                        'EdgeColor',[0.1,0.1,0.1]);
                    set(h(end),'DisplayName',[Variable,',',...
                        VariablesDepGraficadas{i,2}]);
                    set(h(end),'ButtonDownFcn',@inspeccionarLinea);
                    view(3);
                else
                    h=plot3(handles.axes1,X,Z,Y,...
                        Datos_struct.linestyles{linestylesIndex},...
                        'Color',...
                        Datos_struct.colors(colorsIndex,:),...
                        'MarkerFaceColor',...
                        Datos_struct.markerFaceCells{colorsIndex},...
                        'LineWidth',2);
                    set(h(end),'DisplayName',[Variable,',',...
                        VariablesDepGraficadas{i,2}]);
                    set(h(end),'ButtonDownFcn',@inspeccionarLinea);
                    if strcmp(Datos_struct.Tipo,'CSTR')...
                            && Datos_struct.MostrarEstadosEstacionarios
                        h=plot3(handles.axes1,...
                            X_Edos_Est,Z_Edos_Est,Y_Edos_Est,...
                            Datos_struct.linestyles{linestylesIndex},...
                            'Color',...
                            Datos_struct.colors(colorsIndex,:),...                            
                            'LineWidth',2);
                        set(h(end),'DisplayName',[Variable,',',...
                            VariablesDepGraficadas{i,2},'_E_s_t']);
                        set(h(end),'MarkerSize',...
                            2*get(h(end),'MarkerSize'));
                        set(h(end),'LineStyle','none');
                        set(h(end),'ButtonDownFcn',@inspeccionarLinea);
                    end
                    view(3);
                end
            end
        end
    end
end
if ~isempty(get(handles.axes1,'Children'))
    legend(handles.axes1,'show');
    xlabel(handles.axes1,...
        [VariableIndep1String,' , ',...
        Variables_XZ{cellfun(@(x)strcmp(x,...
        VariableIndep1String),Variables_XZ),2}]);
    if strcmp('2D',...
            get(get(handles.uipanel2,'SelectedObject'),'String'))
        ylabel(handles.axes1,'');
    else
        ylabel(handles.axes1,...
            [VariableIndep2String,' , ',...
            Variables_XZ{cellfun(@(x)strcmp(x,...
            VariableIndep2String),Variables_XZ),2}]);
    end
end
limsXAhora = get(handles.axes1,'XLim');
limsYAhora = get(handles.axes1,'YLim');
limsZAhora = get(handles.axes1,'ZLim');
Datos_struct.DatosCalc{strcmp(Datos_struct.DatosCalc,'XMIN'),2}=...
    limsXAhora(1);
Datos_struct.DatosCalc{strcmp(Datos_struct.DatosCalc,'XMAX'),2}=...
    limsXAhora(2);
Datos_struct.DatosCalc{strcmp(Datos_struct.DatosCalc,'YMIN'),2}=...
    limsYAhora(1);
Datos_struct.DatosCalc{strcmp(Datos_struct.DatosCalc,'YMAX'),2}=...
    limsYAhora(2);
Datos_struct.DatosCalc{strcmp(Datos_struct.DatosCalc,'ZMIN'),2}=...
    limsZAhora(1);
Datos_struct.DatosCalc{strcmp(Datos_struct.DatosCalc,'ZMAX'),2}=...
    limsZAhora(2);
set(handles.uitable1,'Data',Datos_struct.DatosCalc);
end

%
% --- Executes just before PROBLEMASIR is made visible.
function PROBLEMASIR_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
codigoDeArranque(hObject, eventdata, handles, varargin)
end

% --- Outputs from this function are returned to the command line.
function varargout = PROBLEMASIR_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
end

% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1
% contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu1
handles.Datos_struct.skipSolve=true;
actualizar(hObject, eventdata, handles)
end

% --- Executes on selection change in popupmenu2.
function popupmenu2_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu2
% contents as cell array
%        contents{get(hObject,'Value')} returns selected item from
%        popupmenu2
handles.Datos_struct.skipSolve=true;
actualizar(hObject, eventdata, handles)
end

% --- Executes during object creation, after setting all properties.
function popupmenu2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu2 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    empty - handles not
% created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), ...
        get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
end

function uipushtool1_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool1 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
global solucionAnalisisEstacionario solucionAnalisisNoEstacionario
solucionAnalisisEstacionario={};
solucionAnalisisNoEstacionario={};
[success,~] = mkdir('DATA');
if success 
    [FileName,PathName,~]=uigetfile('./DATA/*.mat;*.xlsx;*.xls');    
else
    [FileName,PathName,~]=uigetfile('./*.mat;*.xlsx;*.xls');
end
Datos={};
if FileName~=0
    extension=regexp(FileName,'.mat$|.xls$|.xlsx$','match');
    if strcmp('.mat',extension)
        load([PathName filesep FileName],'Datos');
    elseif strcmp(extension,'.xls') ||...
            strcmp(extension,'.xlsx')
        [~,~,Datos]=xlsread([PathName filesep FileName]);
        Datos=quitarNaN(Datos);
    end
    %
    % Poner estos valores en la tabla uitable1 (a la izq.)}
    handles=rmfield(handles,'Datos_struct');
    set(handles.uitable1,'Data',Datos); %#ok<COLND>
    %
    % Correr el código para actualizar ( o generar en dado caso) la gráfica
    % solicitada.
    actualizar(hObject, eventdata, handles, {});
end
end

function cellArraySinNaN=quitarNaN(cellArrayConNaN)
%QUITARNAN(varargin) reemplaza valores NaN generados en array de
% celdas contenido en cellArrayConNaN al importar de Excel.
% DatosSinNaN = QUITARNAN(DatosConNaN) regresa matriz
% DatosSinNaN donde el valor NaN fue reemplazado de
% la matriz DatosConNaN por [].
    function resultado = NaN2Empty(y)
        y(isnan(y))=[];
        resultado=y;
    end
cellArraySinNaN=...
    cellfun(@(x)NaN2Empty(x),cellArrayConNaN,'UniformOutput',false);
end

function output = nombreDeVariable(variable)
%NOMBREDEVARIABLE(variable) toma una variable y regresa su nombre.
% Útil para usarse con la función save, que únicamente acepta texto
% con el nombre de la variable.
    output = inputname(1);
end

function cambiarTextoDeAnotacion(varargin)
%CAMBIARTEXTODEANOTACION para utilizar como ButtonDownFcn
% de reemplazar texto en TextBox anotación de gráfica por el
% deseado
% CAMBIARTEXTODEANOTACION(varargin) toma el primer elemento
% de varargin y si es handle a una anotación, cambia su 
% valor de texto.
if numel(varargin)>1
    h=varargin{1};
    if ishandle(h) && strcmp(get(h,'Type'),'hggroup')
        respuesta=inputdlg('Nuevo valor','Cambiar valor',...
            1,get(h,'String'));
        set(h,'String',respuesta);
    end
end
end

function inspeccionarLinea(varargin)
%INSPECCIONARLINEA(varargin) Función para mostrar al usuario las 
% propiedades de las líneas cuando hace click en ellas, permitiendo
% su edición.
if numel(varargin)>1
    h=varargin{1};
    if ishandle(h) && strcmp(get(h,'Type'),'line')
        try
            inspect(h);
        catch error    
            % Si Java está limitado, registrar error en log ya que 
            % no estará disponible la funcion INSPECT
            report=getReport(error);
            openedFile=fopen('./error_ignorethis.log','a+');
            fprintf(openedFile,'=====================================');
            fprintf(openedFile,'\n');
            fprintf(openedFile,'%s',...
                datestr(now,'dd-mmm-yyyy-HH-MM-SS PM'));
            fprintf(openedFile,'\n');
            fprintf(openedFile,'%s',report);
            fprintf(openedFile,'\n');
            fprintf(openedFile,'=====================================');
            fprintf(openedFile,'\n');
            fclose(openedFile);
        end
    end
end
end

% --------------------------------------------------------------------
function uipushtool6_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool10 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
hgexport(handles.figure1,'-clipboard');
end

% --------------------------------------------------------------------
function uipushtool7_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool10 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
figure2=figure('MenuBar','none','ToolBar','none','Resize','off');
axes2=copyobj(handles.axes1,figure2);
set(axes2,'Units','characters');
set(figure2,'Units','characters');
axesposition=get(axes2,'OuterPosition');
figureposition=get(figure2,'Position');
axesposition=[0,0,axesposition(3),axesposition(4)];
figureposition=[figureposition(1),figureposition(2),...
    axesposition(3),axesposition(4)];
set(axes2,'OuterPosition',axesposition);
set(figure2,'Position',figureposition);
set(axes2,'XLim',get(handles.axes1,'XLim'));
set(axes2,'YLim',get(handles.axes1,'YLim'));
set(axes2,'ZLim',get(handles.axes1,'ZLim'));
if ~isempty(legend(handles.axes1))
    set(legend(handles.axes1),'Units',get(axes2,'Units'));
    offset=([1,0,0,0;0,1,0,0;0,0,0,0;0,0,0,0]*...
        (get(legend(handles.axes1),'OuterPosition')-...
        get(handles.axes1,'OuterPosition'))')';
    legend2Position=offset+([0,0,0,0;0,0,0,0;0,0,1,0;0,0,0,1]*...
        get(legend(handles.axes1),'OuterPosition')')';
    legend(axes2,'show');
    set(legend(axes2),'OuterPosition',legend2Position);
end
dcm_obj=datacursormode(handles.figure1);
info_struct = getCursorInfo(dcm_obj);
for i=1:length(info_struct)
    text('Parent',axes2,'Position',info_struct(i).Position,...
        'String',['\bullet\leftarrow',...
        mat2str(info_struct(i).Position',4)],'Fontweight','bold');
end
if isfield(handles,'annotations')
    c=cell(size(handles.annotations));    
    for i=1:numel(handles.annotations)
        posicionOriginal=get(handles.annotations{i},'Position');
        posicionCorregida=dsxy2figxy(axes2,...
            get(handles.annotations{i},'UserData'));
        posicionCorregida(3:4)=posicionOriginal(3:4);
        c{i}=annotation(figure2,'textbox',posicionCorregida);                
        set(c{i},'String',get(handles.annotations{i},'String'));
        set(c{i},'FitBoxToText','on');
    end
end
set(figure2,'PaperPositionMode','auto');
set(figure2,'InvertHardcopy','off');
set(figure2,'Color','blue');
hgexport(figure2,'-clipboard');
delete(axes2);
delete(figure2);
end

% --------------------------------------------------------------------
function uipushtool9_ClickedCallback(hObject, eventdata, handles)
% Write to Excel
% hObject    handle to uipushtool10 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
[success,MESSAGE,MESSAGEID] = mkdir('exports');
success = success && fileattrib('./exports','+w');
if success
    fileName=['exported_',...
        datestr(now,'dd-mmm-yyyy-HH-MM-SS PM')];
    xlswrite(['./exports/',fileName],get(handles.uitable1,'Data'));
    msgbox(['Data written to: ',['./exports/',fileName],'.xls']);
else
    msgbox(['Falla en permisos al generar directorio: "./export" ',...
        '. Favor de exportar manualmente:',MESSAGEID,',',MESSAGE]);
end
end

% --------------------------------------------------------------------
function uipushtool5_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool10 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
Datos = get(handles.uitable1,'Data');
[success,~] = mkdir('DATA');
success = success && fileattrib('./DATA','+w');
if success
    [FileName,PathName,~]=uiputfile({'*.mat';'*.xls'},...
        'Guardar estado de variables','./DATA/*.xls');
else
    [FileName,PathName,~]=uiputfile({'*.mat';'*.xls'},...
        'Guardar estado de variables','./*.xls');
end
if FileName~=0
    extension=regexp(FileName,'.mat$|.xls$|.xlsx$','match');
    if isempty(extension)
        extension='.xls';
        FileName=[FileName,extension];
    end
    if strcmp('.mat',extension)
        save([PathName,FileName],nombreDeVariable(Datos));
    elseif strcmp(extension,'.xls') ||...
            strcmp(extension,'.xlsx')
        xlswrite([PathName,FileName],...
            get(handles.uitable1,'Data'));    
    end
end
end

% --------------------------------------------------------------------
function uitoggletool10_OnCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool10 (see GCBO) eventdata  reserved - to
% be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)
set(get(handles.axes1,'Children'),'EdgeColor','black');
end

% --------------------------------------------------------------------
function uitoggletool10_OffCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool10 (see GCBO) eventdata  reserved - to
% be defined in a future version of MATLAB handles    structure with
% handles and user data (see GUIDATA)
if ~handles.estacionario
    set(get(handles.axes1,'Children'),'EdgeColor','none');
end
end

% --------------------------------------------------------------------
function uipushtool8_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool8 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
variablesDep = get(handles.uitable2,'Data');
variablesDep(:,3)=cellfun(@(x){false},cell(size(variablesDep(:,3))));
set(handles.uitable2,'Data',variablesDep);
handles.Datos_struct.skipSolve=true;
actualizar(hObject, eventdata, handles);
end

% --- Executes when entered data in editable cell(s) in uitable1.
function uitable1_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable1 (see GCBO) eventdata  structure with the
% following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited PreviousData:
%	previous data for the cell(s) edited EditData: string(s) entered by the
%	user NewData: EditData or its converted form set on the Data property.
%	Empty if Data was not changed Error: error string when failed to
%	convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
Datos = get(handles.uitable1,'Data');
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
        case 'XMAX'
            try
                limitesAnteriores = get(handles.axes1,'XLim');
                xlim(handles.axes1,...
                    [limitesAnteriores(1),...
                    Datos{strcmp(Datos,variableModificada),2}]);
            catch exception
                % This is in case bad axis limits were chosen
                xlim(handles.axes1,'auto');
            end
        case 'YMAX'
            try
                limitesAnteriores = get(handles.axes1,'YLim');
                ylim(handles.axes1,...
                    [limitesAnteriores(1),...
                    Datos{strcmp(Datos,variableModificada),2}]);
            catch exception
                % This is in case bad axis limits were chosen
                ylim(handles.axes1,'auto');
            end
        case 'ZMAX'
            try
                limitesAnteriores = get(handles.axes1,'ZLim');
                zlim(handles.axes1,...
                    [limitesAnteriores(1),...
                    Datos{strcmp(Datos,variableModificada),2}]);
            catch exception
                % This is in case bad axis limits were chosen
                zlim(handles.axes1,'auto');
            end
        case 'XMIN'
            try
                limitesAnteriores = get(handles.axes1,'XLim');
                xlim(handles.axes1,...
                    [Datos{strcmp(Datos,variableModificada),2},...
                    limitesAnteriores(2)]);
            catch exception
                % This is in case bad axis limits were chosen
                xlim(handles.axes1,'auto');
            end
        case 'YMIN'
            try
                limitesAnteriores = get(handles.axes1,'YLim');
                ylim(handles.axes1,...
                    [Datos{strcmp(Datos,variableModificada),2},...
                    limitesAnteriores(2)]);
            catch exception
                % This is in case bad axis limits were chosen
                ylim(handles.axes1,'auto');
            end
        case 'ZMIN'
            try
                limitesAnteriores = get(handles.axes1,'ZLim');
                zlim(handles.axes1,...
                    [Datos{strcmp(Datos,variableModificada),2},...
                    limitesAnteriores(2)]);
            catch exception
                % This is in case bad axis limits were chosen
                zlim(handles.axes1,'auto');
            end
        otherwise
            handles.Datos=Datos;
            try
                actualizar(hObject, eventdata, handles);
            catch exception
                Datos{eventdata.Indices(1),eventdata.Indices(2)}=...
                    eventdata.PreviousData;
                set(handles.uitable1,'Data',Datos);
                msgbox(['Error in data, reverting to original value. ',...
                    'Message: ',exception.message],...
                    'Error','error');
            end
    end
end
end

% --- Executes when entered data in editable cell(s) in uitable2.
function uitable2_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable2 (see GCBO) eventdata  structure with the
% following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited PreviousData:
%	previous data for the cell(s) edited EditData: string(s) entered by the
%	user NewData: EditData or its converted form set on the Data property.
%	Empty if Data was not changed Error: error string when failed to
%	convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
variablesDep = get(handles.uitable2,'Data');
variableModificada = variablesDep{eventdata.Indices(1),1};
variableModificadaHabilitada = variablesDep{eventdata.Indices(1),3};
if ~isempty(regexp(variableModificada,'\W.+\W'))
    stringOfVal=strrep(variableModificada,'[','');
    stringOfVal=strrep(stringOfVal,']','');
    if variableModificadaHabilitada
        variablesDep(cellfun(@(x)~isempty(x),regexp(variablesDep(:,1),...
            ['^',stringOfVal,'+'])),3)={true};
        set(handles.uitable2,'Data',variablesDep);
    else
        variablesDep(cellfun(@(x)~isempty(x),regexp(variablesDep(:,1),...
            ['^',stringOfVal,'+'])),3)={false};
        set(handles.uitable2,'Data',variablesDep);
    end
end
handles.Datos_struct.skipSolve=true;
actualizar(hObject, eventdata, handles);
end

% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 eventdata  structure
% with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only) OldValue: handle of
%	the previously selected object or empty if none was selected NewValue:
%	handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)
switch get(eventdata.NewValue,'String') % Get String of selected object.
    case '2D'
        set(handles.text2,'Visible','off');
        set(handles.popupmenu2,'Visible','off');
        view(handles.axes1,2);
    case '3D'
        set(handles.text2,'Visible','on');
        set(handles.popupmenu2,'Visible','on');
        view(handles.axes1,3);
    otherwise
        set(handles.text2,'Visible','off');
        set(handles.popupmenu2,'Visible','off');
end
handles.Datos_struct.skipSolve=true;
actualizar(hObject, eventdata, handles);
end

% --------------------------------------------------------------------
function uipushtool4_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool4 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
actualizar(hObject, eventdata, handles)
end

% --------------------------------------------------------------------
function Untitled_10_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_10 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
if strcmp(get(handles.Untitled_10, 'Checked'),'on')
    set(handles.Untitled_10, 'Checked','off');
else
    set(handles.Untitled_10, 'Checked','on');
end
end

% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
end

% --------------------------------------------------------------------
function uitoggletool9_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uitoggletool9 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
if strcmp(get(handles.uitoggletool9,'State'),'on')
    h=get(handles.axes1,'Children');
    markers=...
        {'*','o','x','h','d','^','<','s','v','s','+','p'};
    markers=markers(randperm(size(markers,2)));
    markers=repmat(markers,1,ceil(length(h)/length(markers)));
    for j=1:length(h)
        set(h(j),'Marker',markers{j});
    end
elseif strcmp(get(handles.uitoggletool9,'State'),'off')
    set(get(handles.axes1,'Children'),'Marker','.');
end
end

% --------------------------------------------------------------------
function uipushtool10_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to uipushtool10 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
    [X,Y]=ginput(1);
    XLIMS=get(handles.axes1,'XLim');
    YLIMS=get(handles.axes1,'YLim');
    WIDTH=1/100*abs(diff(XLIMS));
    HEIGHT=6/100*abs(diff(YLIMS));
    posicionCorregida=dsxy2figxy(handles.axes1,...
        [X Y WIDTH HEIGHT]);
    if posicionCorregida(1)>=0 && posicionCorregida(1)<=1 && ...
            posicionCorregida(2)>=0 && posicionCorregida(2)<=1        
        b=annotation('textbox',posicionCorregida);
        if isfield(handles,'annotations')
            handles.annotations=[handles.annotations;b];
        else
            handles.annotations={b};
        end
        guidata(hObject,handles);
        respuesta=...
            inputdlg('Agregar texto','Escriba una anotación',...
            1,{'[Cambiar texto]'});        
        set(b,'String',respuesta);
        set(b,'ButtonDownFcn',{@cambiarTextoDeAnotacion});
        set(b,'FitBoxToText','on');
        set(b,'BackgroundColor','flat');
        posicionCorregida=get(b,'Position');
        set(b,'UserData',...
            [X Y posicionCorregida(3) posicionCorregida(4)]);
    end
end
