function informarAlUsuario(mensaje,tiempoSegundos)
% INFORMARALUSUARIO(mensaje,tiempoSegundos) genera diálogo con 
% texto mensaje durante tiempo tiempoSegundos. Transcurrido este
% tiempo, el mensaje se cierra automáticamente. Se puede cerrar
% apretando el botón OK, o con el botón de cerrar ('X') del 
% diálogo.
dialog=msgbox(mensaje);
tID=tic;
set(findobj(dialog,'Tag','OKButton'),'String',...
    ['OK (',sprintf('%02.f',toc(tID)),'s)']);
t = timer('TimerFcn',...
    @(hObject,event)set(findobj(dialog,'Tag','OKButton'),...
    'String',['OK (',sprintf('%02.f',toc(tID)),'s)']),...
    'Period',1,'ExecutionMode','fixedRate','TasksToExecute',...
    tiempoSegundos+2);
set(findobj(dialog,'Tag','OKButton'),'Callback',...
    {@timerKeyPressFcn,dialog,t,false});
set(t,'StopFcn',{@closeTimerDialog,dialog,t});
set(dialog,'CloseRequestFcn',...
    {@timerKeyPressFcn,dialog,t,strcmp(get(t,'Running'),'on')});
start(t);
end

function timerKeyPressFcn(~,~,dialog,timer,alreadystopped)
if ~alreadystopped
    stop(timer);
end
if ishandle(dialog)
    delete(dialog);
end
end

function closeTimerDialog(hObject,event,dialog,timer)
timerKeyPressFcn(hObject,event,dialog,timer,true);
end