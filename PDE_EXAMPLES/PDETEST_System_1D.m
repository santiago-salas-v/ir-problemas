function PDETEST_System_1D
%Simplified Problem in time and 1-D
%   c(x,t,u,Du/Dx) * Du/Dt = x^(-m) * D(x^m * f(x,t,u,Du/Dx))/Dx + s(x,t,u,Du/Dx)
%   c=I, f=0, s=s(x,t,u,Du/Dx)
POINTFACTOR=10;
nt=9*POINTFACTOR;
np=13*POINTFACTOR;
m = 0;
x = linspace(0,1,np);
t = linspace(0,2,nt);

wb=waitbar(0,'Solving...','CreateCancelBtn',@cancelOperation);
wbMessageText=findall(wb,'type','text');
set(wbMessageText,'Interpreter','none');
set(wb,'Name','Solving...');

options=odeset('Events'...
    ...
    ,@events,'Stats','on');
%,@events,'Stats','on');
[sol,tsol,sole,te,ie] = pdepe(m,@pdex4pde,@pdex4ic,@pdex4bc,...
    x,t,options,'WaitBar',wb,'TotalTime',t(length(t)));
%sol = pdepe(m,@pdex4pde,@pdex4ic,@pdex4bc,x,t);
u1 = sol(:,:,1);
u2 = sol(:,:,2);

fig3=figure('WindowStyle','docked');
axes3=axes('Parent',fig3);
surf(axes3,x,tsol,u1);
hold on;
surf(axes3,x,tsol,u2);
zLimits=get(findobj(fig3,'Type','axes'),'ZLim');
xlabel('Distance x');
ylabel('Time t');
legend('u1(x,t)','u2(x,t)');
zlim([0,zLimits(2)])
set(findobj(fig3,'Type','surface'),'EdgeAlpha',0.1);
for i=1:length(te)
    plot3(axes3,x,te(i)*ones(size(x)),sole(i,:,1),...
        'marker','none','Color',[1,1,1]*.3);
    plot3(axes3,x,te(i)*ones(size(x)),sole(i,:,2),...
        'marker','none','Color',[1,1,1]*.3);
end
hold off

rotate3d on;
set(get(axes3,'Parent'),'currentaxes',axes3);

if ishandle(wb)    
    set(wbMessageText,'String',...
    ['Steady state reached at t=',...
    sprintf('%02.2f',te(length(te)))]);
    uiwait(wb,3);
    if ishandle(wb),delete(wb);end
end
end
% --------------------------------------------------------------
function [c,f,s] = pdex4pde(x,t,u,DuDx,varargin)
%  c(x,t,u,Du/Dx) * Du/Dt = x^(-m) * D(x^m * f(x,t,u,Du/Dx))/Dx + s(x,t,u,Du/Dx)
%  f(x,t,u,Du/Dx) is a flux and s(x,t,u,Du/Dx) is a source term. m must
%  be 0, 1, or 2, corresponding to slab, cylindrical, or spherical symmetry,
%  respectively.
c = [1; 1];
%f = [0.024; 0.17] .* DuDx;
f = [0; 0] .* DuDx;
y = u(1) - u(2);
F = exp(5.73*y)-exp(-11.47*y);
s = [-F+DuDx(1); F+DuDx(2)];
end
% --------------------------------------------------------------
function u0 = pdex4ic(x,varargin);
u0 = [1; 0];
end
% --------------------------------------------------------------
function [pl,ql,pr,qr] = pdex4bc(xl,ul,xr,ur,t,varargin)
% p(x,t,u) + q(x,t) * f(x,t,u,Du/Dx) = 0 
% In diesem Falle: 
% f = [0;0] .* DuDx;
% Links,  [0;u_2]   + [1;0] .* [0;0] .* DuDx = 0
% Rechts, [u_1-1;0] + [0;1] .* [0;0] .* DuDx = 0
pl = [0; ul(2)];
ql = [1; 0];
pr = [ur(1)-1; 0];
qr = [0; 1];
end

function [value,isterminal,direction] = events(m,t,xmesh,umesh,varargin)
if nargin==8 ...
        && strcmp(varargin{1},'WaitBar')...
        && ishandle(varargin{2})...
        && strcmp(get(varargin{2},'Type'),'figure')...
        && strcmp(varargin{3},'TotalTime')...
        && isnumeric(varargin{4}) ...
        && isscalar(varargin{4})...
        && isreal(varargin{4})
    wb=varargin{2};
    totalTime=varargin{4};
    fraction=t(length(t))/totalTime;
    if ishandle(wb),messageText=findall(wb,'type','text');end
    estatus=['Will stop once steady state is reached or ',...
        't= ',sprintf('%02.2f',totalTime),...
        ' (',sprintf('%u',round(fraction*100)) '%)'];
    if ishandle(wb),waitbar(fraction,wb);end
    if ishandle(wb),set(messageText,'String',estatus);end
end
% Stop when steady condition crossed.
value = umesh; % Detect u-u_steady = 0
isterminal = 1*ones(size(value));   % T make terminal change 0 for 1
direction = 0*ones(size(value));   % Negative or positive directions
end

function cancelOperation(hObject,eventData)
parent=get(hObject,'Parent');
if ishandle(parent) && strcmp(get(parent,'Type'),'figure')
    delete(parent);
elseif ishandle(hObject) && strcmp(get(hObject,'Type'),'figure')
    delete(hObject);
end
end

function change_current_figure(h)
set(0,'CurrentFigure',h)
end