function PropiedadesDeSerie(hObject,~)
serie=hObject;
marcadores={'none','+','o','*','.','x','square',...
    'diamond','^','<','v','>','pentagram','hexagram'};
screenSize=get(0,'MonitorPositions');
figure5=figure('Menu','none','Toolbar','none',...
    'Color',[255,255,255]/255,'Name','Propiedades de serie',...
    'WindowStyle','modal','NumberTitle','off','Resize','off',...
    'Position',[screenSize(3:4)/2,200,3*24+20]);% 3X24pix rows
panel2=uipanel('Parent',figure5,'Title',...
    ['Propiedades de serie: ',get(serie,'DisplayName')],...
    'BackgroundColor',[255,255,255]/255);

%1a fila: Propiedades del marcador
htext2=uicontrol(panel2,'Style','text',...
    'String','MARCADOR','Position',[4+22,4+22+22,0+22,0+22],...
    'BackgroundColor',[255,255,255]/255);
extent2=get(htext2,'Extent');
set(htext2,'Position',[4+22,4+22+22,0,0]+extent2);
colorFrame2=uicontrol(panel2,'Style','frame',...
    'BackgroundColor',[1,1,1],...
    'Position',[4+24+extent2(3),4+22+22,0+22+22,0+22]);
if ~strcmp(get(serie,'MarkerFaceColor'),'none')
    set(colorFrame2,'BackgroundColor',get(serie,'MarkerFaceColor'));
end
popup=uicontrol(panel2,'Style','popupmenu','String',...
    marcadores,...
    'Position',[4+24+extent2(3)+22,4+22+22,0+22+10,0+22],...
    'BackgroundColor',[1,1,1],...
    'Callback',@(hObject,eventData)...
    selectorDeMarcador(hObject,eventData,serie));
set(popup,'Value',find(strcmp(get(serie,'Marker'),marcadores)));
extent3=get(popup,'Extent');
set(popup,'Position',[4+24+extent2(3)+22,4+22+22,0+22+10+extent3(3),0+22]);
uicontrol(panel2,'CData',...
    imread(...
    fullfile(...
    ['.',filesep,'utils',filesep,'markers.png']...
    )),...
    'Style','pushbutton','Position',[4+0,4+22+22,22,22],...
    'Callback',...
    @(hObject,eventData)selectorDeColorDeMarcador(hObject,eventData,...
    colorFrame2,serie));

%2a fila: Propiedades de la l�nea
htext=uicontrol(panel2,'Style','text',...
    'String','L�NEA','Position',[4+22,4+22,0+22,0+22],...
    'BackgroundColor',[255,255,255]/255);
extent=get(htext,'Extent');
set(htext,'Position',[4+22,4+22,0,0]+extent);
colorFrame=uicontrol(panel2,'Style','frame',...
    'BackgroundColor',[1,1,1],...
    'Position',[4+24+extent2(3),4+22,0+22,0+22]);
set(colorFrame,'BackgroundColor',get(serie,'Color'));
uicontrol(panel2,'CData',...
    imread(...
    fullfile(...
    ['.',filesep,'utils',filesep,'color_wheel.jpg']...
    )),...
    'Style','pushbutton','Position',[4+0,4+22,22,22],...
    'Callback',...
    @(hObject,eventData)selectorDeColorDeLinea(hObject,eventData,...
    colorFrame,serie));

%1a fila: Bot�n para borrar serie
uicontrol(panel2,...
    'Style','pushbutton','Position',[4+0,4+0,200-4-4,22],...
    'Callback',{@BorrarSerie,serie,figure5},...
    'String','(X) Borrar Serie');

end

function selectorDeColorDeLinea(~,~,cFrame,serie)
colorActual=uisetcolor(get(cFrame,'BackgroundColor'));
set(cFrame,'BackgroundColor',colorActual);
set(serie,'Color',colorActual);
end

function selectorDeColorDeMarcador(~,~,cFrame,serie)
colorActual=uisetcolor(get(cFrame,'BackgroundColor'));
set(cFrame,'BackgroundColor',colorActual);
set(serie,'MarkerFaceColor',colorActual);
end

function selectorDeMarcador(hObject,~,serie)
Val=get(hObject,'Value');
str=get(hObject,'String');
set(serie,'Marker',str{Val});
end

function BorrarSerie(~,~,serie,fig_PropiedadesDeSerie)
axes1=get(serie,'Parent');
delete(serie);
delete(fig_PropiedadesDeSerie);
legend(axes1,...
    flipdim(get(get(axes1,'Children'),'DisplayName'),1));
end