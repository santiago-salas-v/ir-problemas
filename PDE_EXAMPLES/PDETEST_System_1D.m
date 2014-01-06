function PDETEST_System_1D
%Simplified Problem in time and 1-D
%   c(x,t,u,Du/Dx) * Du/Dt = x^(-m) * D(x^m * f(x,t,u,Du/Dx))/Dx + s(x,t,u,Du/Dx)
%   c=I, f=0, s=s(x,t,u,Du/Dx)
POINTFACTOR=50;
nt=9*POINTFACTOR;
np=13*POINTFACTOR;
m = 0;
x = linspace(0,1,np);
t = linspace(0,2,nt);

wb=waitbar(0,'message','CreateCancelBtn',@cancelOperation);

options=odeset('Events'...
    ...
    ,@events,'Stats','on');
%,@events,'Stats','on');
[sol,tsol,sole,te,ie] = pdepe(m,@pdex4pde,@pdex4ic,@pdex4bc,...
    x,t,options,'WaitBar',wb,'TotalTime',t(length(t)));
%sol = pdepe(m,@pdex4pde,@pdex4ic,@pdex4bc,x,t);
u1 = sol(:,:,1);
u2 = sol(:,:,2);

figure
surf(x,tsol,u1)
title('u1(x,t)')
xlabel('Distance x')
ylabel('Time t')
zLimits=get(findobj(gcf,'Type','axes'),'ZLim');
zlim([0,zLimits(2)])
set(gcf,'WindowStyle','docked');

figure
surf(x,tsol,u2)
title('u2(x,t)')
xlabel('Distance x')
ylabel('Time t')
zLimits=get(findobj(gcf,'Type','axes'),'ZLim');
zlim([0,zLimits(2)])
set(gcf,'WindowStyle','docked');

delete(wb);
end
% --------------------------------------------------------------
function [c,f,s] = pdex4pde(x,t,u,DuDx,varargin)
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
    waitbar(t(length(t))/totalTime,wb);
end
% Stop when steady condition crossed.
value = umesh; % Detect u-u_steady = 0
%isterminal = 1;   % FIXME: Stop the integration
isterminal = 1*ones(size(value));   % BYPASSING: Stop the integration
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