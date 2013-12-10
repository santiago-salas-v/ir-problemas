function varargout = PROBLEMASIR(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @PROBLEMASIR_OpeningFcn, ...
    'gui_OutputFcn',  @PROBLEMASIR_OutputFcn, ...
    'gui_LayoutFcn',  @PROBLEMASIR_LayoutFcn, ...
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
    handles.Datos_struct.VariablesDep = get(handles.uitable2,'Data');
    handles.Datos_struct.VariablesDepGraficadas=...
        handles.Datos_struct.VariablesDep(...
        cell2mat(handles.Datos_struct.VariablesDep(:,3)),:);    
    if ~isfield(handles,'Datos_struct')...
            ||~isfield(handles.Datos_struct,'skipSolve')...
            ||~handles.Datos_struct.skipSolve    
        Datos_struct.VariablesDep=...
            handles.Datos_struct.VariablesDep;
        Datos_struct.VariablesDepGraficadas=...
            handles.Datos_struct.VariablesDepGraficadas;
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
        msgbox(['Revisar datos. Message: ',exception.message],...
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
VariablesDep = Datos_struct.VariablesDep;
VariablesDepGraficadas=Datos_struct.VariablesDepGraficadas;
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
    case {'r' , 'k'}
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
    case {'r','k'}
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
                case {'C' , 'X', 'Y', 'S','F'}
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
                        if ~all(all(arrayfun(@isnan,Y)))
                            Y_Edos_Est=Y_Edos_Est(index,:);
                        end
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
                case {'r' , 'k'}
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
                        'FaceAlpha',.8,...
                        'LineStyle','none','LineWidth',1e-8,...
                        'EdgeColor',Datos_struct.colors(colorsIndex,:),...
                        'SpecularExponent',200);
                    light('Parent',handles.axes1,'Position',...
                        [...
                        diff(get(handles.axes1,'XLim'))*rand,...
                        diff(get(handles.axes1,'YLim'))*rand,...
                        diff(get(handles.axes1,'ZLim'))*rand]/2,...
                        'Style','local');
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
    set(handles.axes1,'Position',...
        [69.800000000000000,...
        11.230769230769232,...
        67.600000000000010,...
        19.615384615384620]);
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
    puntoMedioX=mean(get(axes2,'XLim'));
    posicionEnX=info_struct(i).Position(1);
    if posicionEnX >= puntoMedioX
        text('Parent',axes2,'Position',info_struct(i).Position,...
        'String',[mat2str(info_struct(i).Position',4),...
        '\rightarrow\bullet',],'Fontweight','bold',...
        'HorizontalAlignment','right');
    else
        text('Parent',axes2,'Position',info_struct(i).Position,...
        'String',['\bullet\leftarrow',...
        mat2str(info_struct(i).Position',4)],'Fontweight','bold');
    end    
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
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO) eventdata  reserved - to be
% defined in a future version of MATLAB handles    structure with handles
% and user data (see GUIDATA)
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


% --- Creates and returns a handle to the GUI figure. 
function h1 = PROBLEMASIR_LayoutFcn(policy)
% policy - create a new figure or use a singleton. 'new' or 'reuse'.

persistent hsingleton;
if strcmpi(policy, 'reuse') & ishandle(hsingleton)
    h1 = hsingleton;
    return;
end
load PROBLEMASIR.mat


appdata = [];
appdata.GUIDEOptions = struct(...
    'active_h', [], ...
    'taginfo', struct(...
    'figure', 2, ...
    'uitable', 3, ...
    'axes', 2, ...
    'uitoolbar', 3, ...
    'uitoggletool', 10, ...
    'uipushtool', 10, ...
    'popupmenu', 3, ...
    'text', 3, ...
    'uipanel', 3, ...
    'togglebutton', 3), ...
    'override', 0, ...
    'release', 13, ...
    'resize', 'none', ...
    'accessibility', 'callback', ...
    'mfile', 1, ...
    'callbacks', 1, ...
    'singleton', 1, ...
    'syscolorfig', 1, ...
    'blocking', 0, ...
    'lastSavedFile', 'C:\Users\Santiago Salas\git\ir-problemas\exports\PROBLEMASIR.m', ...
    'lastFilename', 'C:\Users\Santiago Salas\git\ir-problemas\PROBLEMASIR.fig');
appdata.lastValidTag = 'figure1';
appdata.GUIDELayoutEditor = [];
appdata.initTags = struct(...
    'handle', [], ...
    'tag', 'figure1');

h1 = figure(...
'Units','characters',...
'Color',[0.941176470588235 0.941176470588235 0.941176470588235],...
'Colormap',[0 0 0.5625;0 0 0.625;0 0 0.6875;0 0 0.75;0 0 0.8125;0 0 0.875;0 0 0.9375;0 0 1;0 0.0625 1;0 0.125 1;0 0.1875 1;0 0.25 1;0 0.3125 1;0 0.375 1;0 0.4375 1;0 0.5 1;0 0.5625 1;0 0.625 1;0 0.6875 1;0 0.75 1;0 0.8125 1;0 0.875 1;0 0.9375 1;0 1 1;0.0625 1 1;0.125 1 0.9375;0.1875 1 0.875;0.25 1 0.8125;0.3125 1 0.75;0.375 1 0.6875;0.4375 1 0.625;0.5 1 0.5625;0.5625 1 0.5;0.625 1 0.4375;0.6875 1 0.375;0.75 1 0.3125;0.8125 1 0.25;0.875 1 0.1875;0.9375 1 0.125;1 1 0.0625;1 1 0;1 0.9375 0;1 0.875 0;1 0.8125 0;1 0.75 0;1 0.6875 0;1 0.625 0;1 0.5625 0;1 0.5 0;1 0.4375 0;1 0.375 0;1 0.3125 0;1 0.25 0;1 0.1875 0;1 0.125 0;1 0.0625 0;1 0 0;0.9375 0 0;0.875 0 0;0.8125 0 0;0.75 0 0;0.6875 0 0;0.625 0 0;0.5625 0 0],...
'IntegerHandle','off',...
'InvertHardcopy',get(0,'defaultfigureInvertHardcopy'),...
'MenuBar','none',...
'Name','PROBLEMASIR',...
'NumberTitle','off',...
'PaperPosition',get(0,'defaultfigurePaperPosition'),...
'Position',[103.8 28.3846153846154 148.2 33.0769230769231],...
'Resize','off',...
'HandleVisibility','callback',...
'UserData',[],...
'Tag','figure1',...
'Visible','on',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uitable1';

h2 = uitable(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1;0.96078431372549 0.96078431372549 0.96078431372549],...
'CellEditCallback',@(hObject,eventdata)PROBLEMASIR('uitable1_CellEditCallback',hObject,eventdata,guidata(hObject)),...
'ColumnFormat',{  [] [] [] },...
'ColumnEditable',mat{1},...
'ColumnName',{  'VARIABLE'; 'VALOR'; 'UNIDADES' },...
'ColumnWidth',{  'auto' 'auto' 'auto' },...
'Data',mat{2},...
'Position',[-0.2 0 58.4 33.2307692307692],...
'UserData',[],...
'Tag','uitable1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'axes1';

h3 = axes(...
'Parent',h1,...
'Units','characters',...
'Position',[69.8 11.2307692307692 67.6 19.6153846153846],...
'CameraPosition',[0.5 0.5 9.16025403784439],...
'CameraPositionMode',get(0,'defaultaxesCameraPositionMode'),...
'Color',get(0,'defaultaxesColor'),...
'ColorOrder',get(0,'defaultaxesColorOrder'),...
'LooseInset',[19.266 3.65538461538462 14.079 2.49230769230769],...
'XColor',get(0,'defaultaxesXColor'),...
'YColor',get(0,'defaultaxesYColor'),...
'ZColor',get(0,'defaultaxesZColor'),...
'Tag','axes1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

h4 = get(h3,'title');

set(h4,...
'Parent',h3,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[0.498520710059172 1.02549019607843 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h5 = get(h3,'xlabel');

set(h5,...
'Parent',h3,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[0.498520710059172 -0.0921568627450979 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','cap',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h6 = get(h3,'ylabel');

set(h6,...
'Parent',h3,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','center',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-0.084319526627219 0.496078431372549 1.00005459937205],...
'Rotation',90,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','bottom',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','on',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

h7 = get(h3,'zlabel');

set(h7,...
'Parent',h3,...
'Units','data',...
'FontUnits','points',...
'BackgroundColor','none',...
'Color',[0 0 0],...
'DisplayName',blanks(0),...
'EdgeColor','none',...
'EraseMode','normal',...
'DVIMode','auto',...
'FontAngle','normal',...
'FontName','Helvetica',...
'FontSize',10,...
'FontWeight','normal',...
'HorizontalAlignment','right',...
'LineStyle','-',...
'LineWidth',0.5,...
'Margin',2,...
'Position',[-1.03402366863905 1.1078431372549 1.00005459937205],...
'Rotation',0,...
'String',blanks(0),...
'Interpreter','tex',...
'VerticalAlignment','middle',...
'ButtonDownFcn',[],...
'CreateFcn', {@local_CreateFcn, [], ''} ,...
'DeleteFcn',[],...
'BusyAction','queue',...
'HandleVisibility','off',...
'HelpTopicKey',blanks(0),...
'HitTest','on',...
'Interruptible','on',...
'SelectionHighlight','on',...
'Serializable','on',...
'Tag',blanks(0),...
'UserData',[],...
'Visible','off',...
'XLimInclude','on',...
'YLimInclude','on',...
'ZLimInclude','on',...
'CLimInclude','on',...
'ALimInclude','on',...
'IncludeRenderer','on',...
'Clipping','off');

appdata = [];
appdata.lastValidTag = 'uitoolbar2';

h8 = uitoolbar(...
'Parent',h1,...
'Tag','uitoolbar2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool1';

h9 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool1_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{3},...
'TooltipString','Abrir .xls / .xlsx / .mat',...
'Tag','uipushtool1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool9';

h10 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool9_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{4},...
'TooltipString','Exportación rápida .xls',...
'Tag','uipushtool9',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool5';

h11 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool5_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{5},...
'TooltipString','Guardar como (.xls, .mat)',...
'Tag','uipushtool5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool10';

h12 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool10_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{6},...
'TooltipString','Escribir anotación temporal',...
'Tag','uipushtool10',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.DataCursor';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool2';

h13 = uitoggletool(...
'Parent',h8,...
'ClickedCallback','%default',...
'CData',mat{7},...
'Separator','on',...
'TooltipString','Data Cursor',...
'Tag','uitoggletool2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Annotation.InsertLegend';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool3';

h14 = uitoggletool(...
'Parent',h8,...
'ClickedCallback','%default',...
'CData',mat{8},...
'TooltipString','Insert Legend',...
'Tag','uitoggletool3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.Rotate';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool8';

h15 = uitoggletool(...
'Parent',h8,...
'ClickedCallback','%default',...
'CData',mat{9},...
'TooltipString','Rotate 3D',...
'Tag','uitoggletool8',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.Pan';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool5';

h16 = uitoggletool(...
'Parent',h8,...
'ClickedCallback','%default',...
'CData',mat{10},...
'TooltipString','Pan',...
'Tag','uitoggletool5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.ZoomIn';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool4';

h17 = uitoggletool(...
'Parent',h8,...
'ClickedCallback','%default',...
'CData',mat{11},...
'TooltipString','Zoom In',...
'Tag','uitoggletool4',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = 'Exploration.ZoomOut';
appdata.CallbackInUse = struct(...
    'ClickedCallback', '%default');
appdata.lastValidTag = 'uitoggletool6';

h18 = uitoggletool(...
'Parent',h8,...
'ClickedCallback','%default',...
'CData',mat{12},...
'TooltipString','Zoom Out',...
'Tag','uitoggletool6',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool6';

h19 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool6_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{13},...
'Separator','on',...
'TooltipString','Enviar foto a portapapeles (completa)',...
'Tag','uipushtool6',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool7';

h20 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool7_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{14},...
'TooltipString','Enviar foto a portapapeles (sólo gráfica)',...
'Tag','uipushtool7',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uitoggletool9';

h21 = uitoggletool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uitoggletool9_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{15},...
'Separator','on',...
'State','on',...
'TooltipString','Habilitar marcadores',...
'Tag','uitoggletool9',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool8';

h22 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool8_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{16},...
'TooltipString','Borrar gráficas',...
'Tag','uipushtool8',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.toolid = [];
appdata.lastValidTag = 'uipushtool4';

h23 = uipushtool(...
'Parent',h8,...
'ClickedCallback',@(hObject,eventdata)PROBLEMASIR('uipushtool4_ClickedCallback',hObject,eventdata,guidata(hObject)),...
'CData',mat{17},...
'Separator','on',...
'TooltipString','Calcular nuevamente',...
'Tag','uipushtool4',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Untitled_2';

h24 = uimenu(...
'Parent',h1,...
'Callback',@(hObject,eventdata)PROBLEMASIR('Untitled_2_Callback',hObject,eventdata,guidata(hObject)),...
'Label','Ver',...
'Tag','Untitled_2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Untitled_3';

h25 = uimenu(...
'Parent',h24,...
'Callback',@(hObject,eventdata)PROBLEMASIR('Untitled_3_Callback',hObject,eventdata,guidata(hObject)),...
'Label','Código',...
'Tag','Untitled_3',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Untitled_5';

h26 = uimenu(...
'Parent',h24,...
'Callback',@(hObject,eventdata)PROBLEMASIR('Untitled_5_Callback',hObject,eventdata,guidata(hObject)),...
'Label','Teoría',...
'Tag','Untitled_5',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'popupmenu1';

h27 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)PROBLEMASIR('popupmenu1_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[72.8 6.07692307692308 17.2 1.76923076923077],...
'String','EJE X',...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PROBLEMASIR('popupmenu1_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','popupmenu1');

appdata = [];
appdata.lastValidTag = 'Untitled_6';

h28 = uimenu(...
'Parent',h1,...
'Callback',@(hObject,eventdata)PROBLEMASIR('Untitled_6_Callback',hObject,eventdata,guidata(hObject)),...
'Label','Opciones',...
'Tag','Untitled_6',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Untitled_7';

h29 = uimenu(...
'Parent',h28,...
'Callback',@(hObject,eventdata)PROBLEMASIR('Untitled_7_Callback',hObject,eventdata,guidata(hObject)),...
'Label','Reiniciar',...
'Tag','Untitled_7',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'Untitled_10';

h30 = uimenu(...
'Parent',h28,...
'Callback',@(hObject,eventdata)PROBLEMASIR('Untitled_10_Callback',hObject,eventdata,guidata(hObject)),...
'Checked','on',...
'Label','Borrar gráficas anteriores',...
'Tag','Untitled_10',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uitable2';

h31 = uitable(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1;0.96078431372549 0.96078431372549 0.96078431372549],...
'CellEditCallback',@(hObject,eventdata)PROBLEMASIR('uitable2_CellEditCallback',hObject,eventdata,guidata(hObject)),...
'ColumnFormat',{  'char' 'char' 'logical' 'char' },...
'ColumnEditable',mat{18},...
'ColumnName',{  'DEPENDIENTES'; 'UNIDADES'; 'GRAFICAR'; 'VARIABLE' },...
'ColumnWidth',{  80 100 60 140 },...
'Data',mat{19},...
'Position',[59.8 -0.0769230769230769 88.2 5.38461538461539],...
'UserData',[],...
'Tag','uitable2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'text1';

h32 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Position',[61 6.46153846153846 10.4 1.07692307692308],...
'String','EJE X',...
'Style','text',...
'Tag','text1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'popupmenu2';

h33 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[1 1 1],...
'Callback',@(hObject,eventdata)PROBLEMASIR('popupmenu2_Callback',hObject,eventdata,guidata(hObject)),...
'Position',[128 6.07692307692308 17.2 1.76923076923077],...
'String','EJE Z',...
'Style','popupmenu',...
'Value',1,...
'CreateFcn', {@local_CreateFcn, @(hObject,eventdata)PROBLEMASIR('popupmenu2_CreateFcn',hObject,eventdata,guidata(hObject)), appdata} ,...
'Tag','popupmenu2',...
'Visible','off');

appdata = [];
appdata.lastValidTag = 'text2';

h34 = uicontrol(...
'Parent',h1,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Position',[116.2 6.46153846153846 10.4 1.07692307692308],...
'String','EJE Z',...
'Style','text',...
'Tag','text2',...
'Visible','off',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'uipanel2';

h35 = uibuttongroup(...
'Parent',h1,...
'Units','characters',...
'BorderType','none',...
'Title',blanks(0),...
'Tag','uipanel2',...
'Clipping','on',...
'BackgroundColor',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Position',[91.8 5.69230769230769 23.6 2.38461538461538],...
'SelectedObject',[],...
'SelectionChangeFcn',@(hObject,eventdata)PROBLEMASIR('uipanel2_SelectionChangeFcn',get(hObject,'SelectedObject'),eventdata,guidata(get(hObject,'SelectedObject'))),...
'OldSelectedObject',[],...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'togglebutton1';

h36 = uicontrol(...
'Parent',h35,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Callback',mat{20},...
'Position',[2.8 0.307692307692308 7.6 1.76923076923077],...
'String','2D',...
'Style','togglebutton',...
'Value',1,...
'Tag','togglebutton1',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );

appdata = [];
appdata.lastValidTag = 'togglebutton2';

h37 = uicontrol(...
'Parent',h35,...
'Units','characters',...
'BackgroundColor',[0.925490196078431 0.913725490196078 0.847058823529412],...
'Callback',mat{21},...
'Position',[12.8 0.307692307692308 7.6 1.76923076923077],...
'String','3D',...
'Style','togglebutton',...
'Tag','togglebutton2',...
'CreateFcn', {@local_CreateFcn, blanks(0), appdata} );


hsingleton = h1;


% --- Set application data first then calling the CreateFcn. 
function local_CreateFcn(hObject, eventdata, createfcn, appdata)

if ~isempty(appdata)
   names = fieldnames(appdata);
   for i=1:length(names)
       name = char(names(i));
       setappdata(hObject, name, getfield(appdata,name));
   end
end

if ~isempty(createfcn)
   if isa(createfcn,'function_handle')
       createfcn(hObject, eventdata);
   else
       eval(createfcn);
   end
end


% --- Handles default GUIDE GUI creation and callback dispatch
function varargout = gui_mainfcn(gui_State, varargin)

gui_StateFields =  {'gui_Name'
    'gui_Singleton'
    'gui_OpeningFcn'
    'gui_OutputFcn'
    'gui_LayoutFcn'
    'gui_Callback'};
gui_Mfile = '';
for i=1:length(gui_StateFields)
    if ~isfield(gui_State, gui_StateFields{i})
        error(message('MATLAB:guide:StateFieldNotFound', gui_StateFields{ i }, gui_Mfile));
    elseif isequal(gui_StateFields{i}, 'gui_Name')
        gui_Mfile = [gui_State.(gui_StateFields{i}), '.m'];
    end
end

numargin = length(varargin);

if numargin == 0
    % PROBLEMASIR
    % create the GUI only if we are not in the process of loading it
    % already
    gui_Create = true;
elseif local_isInvokeActiveXCallback(gui_State, varargin{:})
    % PROBLEMASIR(ACTIVEX,...)
    vin{1} = gui_State.gui_Name;
    vin{2} = [get(varargin{1}.Peer, 'Tag'), '_', varargin{end}];
    vin{3} = varargin{1};
    vin{4} = varargin{end-1};
    vin{5} = guidata(varargin{1}.Peer);
    feval(vin{:});
    return;
elseif local_isInvokeHGCallback(gui_State, varargin{:})
    % PROBLEMASIR('CALLBACK',hObject,eventData,handles,...)
    gui_Create = false;
else
    % PROBLEMASIR(...)
    % create the GUI and hand varargin to the openingfcn
    gui_Create = true;
end

if ~gui_Create
    % In design time, we need to mark all components possibly created in
    % the coming callback evaluation as non-serializable. This way, they
    % will not be brought into GUIDE and not be saved in the figure file
    % when running/saving the GUI from GUIDE.
    designEval = false;
    if (numargin>1 && ishghandle(varargin{2}))
        fig = varargin{2};
        while ~isempty(fig) && ~ishghandle(fig,'figure')
            fig = get(fig,'parent');
        end
        
        designEval = isappdata(0,'CreatingGUIDEFigure') || isprop(fig,'__GUIDEFigure');
    end
        
    if designEval
        beforeChildren = findall(fig);
    end
    
    % evaluate the callback now
    varargin{1} = gui_State.gui_Callback;
    if nargout
        [varargout{1:nargout}] = feval(varargin{:});
    else       
        feval(varargin{:});
    end
    
    % Set serializable of objects created in the above callback to off in
    % design time. Need to check whether figure handle is still valid in
    % case the figure is deleted during the callback dispatching.
    if designEval && ishghandle(fig)
        set(setdiff(findall(fig),beforeChildren), 'Serializable','off');
    end
else
    if gui_State.gui_Singleton
        gui_SingletonOpt = 'reuse';
    else
        gui_SingletonOpt = 'new';
    end

    % Check user passing 'visible' P/V pair first so that its value can be
    % used by oepnfig to prevent flickering
    gui_Visible = 'auto';
    gui_VisibleInput = '';
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        % Recognize 'visible' P/V pair
        len1 = min(length('visible'),length(varargin{index}));
        len2 = min(length('off'),length(varargin{index+1}));
        if ischar(varargin{index+1}) && strncmpi(varargin{index},'visible',len1) && len2 > 1
            if strncmpi(varargin{index+1},'off',len2)
                gui_Visible = 'invisible';
                gui_VisibleInput = 'off';
            elseif strncmpi(varargin{index+1},'on',len2)
                gui_Visible = 'visible';
                gui_VisibleInput = 'on';
            end
        end
    end
    
    % Open fig file with stored settings.  Note: This executes all component
    % specific CreateFunctions with an empty HANDLES structure.

    
    % Do feval on layout code in m-file if it exists
    gui_Exported = ~isempty(gui_State.gui_LayoutFcn);
    % this application data is used to indicate the running mode of a GUIDE
    % GUI to distinguish it from the design mode of the GUI in GUIDE. it is
    % only used by actxproxy at this time.   
    setappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]),1);
    if gui_Exported
        gui_hFigure = feval(gui_State.gui_LayoutFcn, gui_SingletonOpt);

        % make figure invisible here so that the visibility of figure is
        % consistent in OpeningFcn in the exported GUI case
        if isempty(gui_VisibleInput)
            gui_VisibleInput = get(gui_hFigure,'Visible');
        end
        set(gui_hFigure,'Visible','off')

        % openfig (called by local_openfig below) does this for guis without
        % the LayoutFcn. Be sure to do it here so guis show up on screen.
        movegui(gui_hFigure,'onscreen');
    else
        gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        % If the figure has InGUIInitialization it was not completely created
        % on the last pass.  Delete this handle and try again.
        if isappdata(gui_hFigure, 'InGUIInitialization')
            delete(gui_hFigure);
            gui_hFigure = local_openfig(gui_State.gui_Name, gui_SingletonOpt, gui_Visible);
        end
    end
    if isappdata(0, genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]))
        rmappdata(0,genvarname(['OpenGuiWhenRunning_', gui_State.gui_Name]));
    end

    % Set flag to indicate starting GUI initialization
    setappdata(gui_hFigure,'InGUIInitialization',1);

    % Fetch GUIDE Application options
    gui_Options = getappdata(gui_hFigure,'GUIDEOptions');
    % Singleton setting in the GUI M-file takes priority if different
    gui_Options.singleton = gui_State.gui_Singleton;

    if ~isappdata(gui_hFigure,'GUIOnScreen')
        % Adjust background color
        if gui_Options.syscolorfig
            set(gui_hFigure,'Color', get(0,'DefaultUicontrolBackgroundColor'));
        end

        % Generate HANDLES structure and store with GUIDATA. If there is
        % user set GUI data already, keep that also.
        data = guidata(gui_hFigure);
        handles = guihandles(gui_hFigure);
        if ~isempty(handles)
            if isempty(data)
                data = handles;
            else
                names = fieldnames(handles);
                for k=1:length(names)
                    data.(char(names(k)))=handles.(char(names(k)));
                end
            end
        end
        guidata(gui_hFigure, data);
    end

    % Apply input P/V pairs other than 'visible'
    for index=1:2:length(varargin)
        if length(varargin) == index || ~ischar(varargin{index})
            break;
        end

        len1 = min(length('visible'),length(varargin{index}));
        if ~strncmpi(varargin{index},'visible',len1)
            try set(gui_hFigure, varargin{index}, varargin{index+1}), catch break, end
        end
    end

    % If handle visibility is set to 'callback', turn it on until finished
    % with OpeningFcn
    gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
    if strcmp(gui_HandleVisibility, 'callback')
        set(gui_hFigure,'HandleVisibility', 'on');
    end

    feval(gui_State.gui_OpeningFcn, gui_hFigure, [], guidata(gui_hFigure), varargin{:});

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        % Handle the default callbacks of predefined toolbar tools in this
        % GUI, if any
        guidemfile('restoreToolbarToolPredefinedCallback',gui_hFigure); 
        
        % Update handle visibility
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);

        % Call openfig again to pick up the saved visibility or apply the
        % one passed in from the P/V pairs
        if ~gui_Exported
            gui_hFigure = local_openfig(gui_State.gui_Name, 'reuse',gui_Visible);
        elseif ~isempty(gui_VisibleInput)
            set(gui_hFigure,'Visible',gui_VisibleInput);
        end
        if strcmpi(get(gui_hFigure, 'Visible'), 'on')
            figure(gui_hFigure);
            
            if gui_Options.singleton
                setappdata(gui_hFigure,'GUIOnScreen', 1);
            end
        end

        % Done with GUI initialization
        if isappdata(gui_hFigure,'InGUIInitialization')
            rmappdata(gui_hFigure,'InGUIInitialization');
        end

        % If handle visibility is set to 'callback', turn it on until
        % finished with OutputFcn
        gui_HandleVisibility = get(gui_hFigure,'HandleVisibility');
        if strcmp(gui_HandleVisibility, 'callback')
            set(gui_hFigure,'HandleVisibility', 'on');
        end
        gui_Handles = guidata(gui_hFigure);
    else
        gui_Handles = [];
    end

    if nargout
        [varargout{1:nargout}] = feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    else
        feval(gui_State.gui_OutputFcn, gui_hFigure, [], gui_Handles);
    end

    if isscalar(gui_hFigure) && ishghandle(gui_hFigure)
        set(gui_hFigure,'HandleVisibility', gui_HandleVisibility);
    end
end

function gui_hFigure = local_openfig(name, singleton, visible)

% openfig with three arguments was new from R13. Try to call that first, if
% failed, try the old openfig.
if nargin('openfig') == 2
    % OPENFIG did not accept 3rd input argument until R13,
    % toggle default figure visible to prevent the figure
    % from showing up too soon.
    gui_OldDefaultVisible = get(0,'defaultFigureVisible');
    set(0,'defaultFigureVisible','off');
    gui_hFigure = openfig(name, singleton);
    set(0,'defaultFigureVisible',gui_OldDefaultVisible);
else
    gui_hFigure = openfig(name, singleton, visible);  
    %workaround for CreateFcn not called to create ActiveX
    if feature('HGUsingMATLABClasses')
        peers=findobj(findall(allchild(gui_hFigure)),'type','uicontrol','style','text');    
        for i=1:length(peers)
            if isappdata(peers(i),'Control')
                actxproxy(peers(i));
            end            
        end
    end
end

function result = local_isInvokeActiveXCallback(gui_State, varargin)

try
    result = ispc && iscom(varargin{1}) ...
             && isequal(varargin{1},gcbo);
catch
    result = false;
end

function result = local_isInvokeHGCallback(gui_State, varargin)

try
    fhandle = functions(gui_State.gui_Callback);
    result = ~isempty(findstr(gui_State.gui_Name,fhandle.file)) || ...
             (ischar(varargin{1}) ...
             && isequal(ishghandle(varargin{2}), 1) ...
             && (~isempty(strfind(varargin{1},[get(varargin{2}, 'Tag'), '_'])) || ...
                ~isempty(strfind(varargin{1}, '_CreateFcn'))) );
catch
    result = false;
end


