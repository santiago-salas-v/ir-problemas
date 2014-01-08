function PDETEST_System_1D_parabolic
%Problem using parabolic system for special 1-D case, 
% where "y" is arbitrary (0.1), z[0,L] ==> "x"[0,L] and t[0,t]==>>"t"[0,t]
%   d*du/dt-div(c*grad(u))+a*u=f
%   d=1, c=0, a=0, f=f(x,y,u,ux,uy) 
% Rectangle is code 3, 4 sides,
% followed by x-coordinates and then y-coordinates
L=1;yMAX=2;
R1=[3,4,0,L,L,0,0,0,yMAX,yMAX]';
geom=R1;

% Names for the geometric objects
ns=(char('R1'))';
% Set formula
sf='R1';
% Create geometry
gd=decsg(geom,sf,ns);

% View geometry
fig3=figure;
set(fig3,'WindowStyle','docked');
h=axes('Parent',fig3);
pdegplot(gd);
set(h,'DataAspectRatio',[1,1,1]);
xlim(h,[0 L]);

% After running the code for creating the geometry, create the mesh, refine
% it twice, and jiggle it once.
N=2; % 2 Eqs.
[p,e,t] = initmesh(gd);
[p,e,t] = refinemesh(gd,p,e,t);
[p,e,t] = refinemesh(gd,p,e,t);
p = jigglemesh(p,e,t);
pdemesh(p,e,t);
np = size(p,2); % number of points
u0 = zeros(np*N,1); % initial guess

tlist = linspace(0,1,50);

b = @pdebound;
d = [1 1]';
a = [0 0]';
f = @fcoeffunction;
c = [0 0]';
% c = 0;
u = parabolic(u0,tlist,b,p,e,t,c,a,f,d);

pdeplot(p,e,t,...
    'xydata',u(1+size(u,1)/3*0:size(u,1)/3*1,1),...
    'zdata',u(1+size(u,1)/3*0:size(u,1)/3*1,1),'colormap','jet');
hold on;
pdeplot(p,e,t,...
    'xydata',u(1+size(u,1)/3*1:size(u,1)/3*2,1),...
    'zdata',u(1+size(u,1)/3*1:size(u,1)/3*2,1),'colormap','jet');
hold on;
pdeplot(p,e,t,...
    'xydata',u(1+size(u,1)/3*2:size(u,1)/3*3,1),...
    'zdata',u(1+size(u,1)/3*2:size(u,1)/3*3,1),'colormap','jet');
hold on;
for tt = 2:size(u,2) % number of steps
    pdeplot(p,e,t,...
        'xydata',u(1+size(u,1)/3*0:size(u,1)/3*1,tt),...
        'zdata',u(1+size(u,1)/3*0:size(u,1)/3*1,tt),'colormap','jet');
    hold on;
    pdeplot(p,e,t,...
        'xydata',u(1+size(u,1)/3*1:size(u,1)/3*2,tt),...
        'zdata',u(1+size(u,1)/3*1:size(u,1)/3*2,tt),'colormap','jet');
    hold on;
    pdeplot(p,e,t,...
        'xydata',u(1+size(u,1)/3*2:size(u,1)/3*3,tt),...
        'zdata',u(1+size(u,1)/3*2:size(u,1)/3*3,tt),'colormap','jet');
    hold on;
    set(findobj(h,'Type','patch'),'EdgeAlpha',0.1);
    axis([-1 1 -1/2 1/2 -1.5 1.5 -1.5 1.5]); % use fixed axis
    title(['Step ' num2str(tt)]);
    view(-45,22);
    drawnow;
    pause(.1);
end

msgbox1=msgbox('Fertig','Fertig','warn');
set(findobj(msgbox1,'Type','uicontrol'),...
    'Callback',...
    {@OKFcn,fig3});

hold off;

end

function f = fcoeffunction(p,t,u,time)
N = 2; % Number of equations
% Triangle point indices
it1=t(1,:);
it2=t(2,:);
it3=t(3,:);
% Find centroids of triangles
xpts=(p(1,it1)+p(1,it2)+p(1,it3))/3;
ypts=(p(2,it1)+p(2,it2)+p(2,it3))/3;
[ux,uy] = pdegrad(p,t,u); % Approximate derivatives
uintrp = pdeintrp(p,t,u); % Interpolated values at centroids
nt = size(t,2); % Number of columns
f = zeros(N,nt); % Allocate f
y = uintrp(1,:) - uintrp(2,:);
F = exp(5.73*y)-exp(-11.47*y);
% Now the particular functional form of f
%f(1,:) = xpts - ypts + uintrp(1,:);
f(1,:) = -F+ux(1,:);
f(2,:) = -F+ux(2,:);
end

function [qmatrix,gmatrix,hmatrix,rmatrix] = pdebound(p,e,u,time)
N = 2;
ne = size(e,2); % number of edges
qmatrix = zeros(N^2,ne);
gmatrix = zeros(N,ne);
hmatrix = zeros(N^2,2*ne);
rmatrix = zeros(N,2*ne);
for k = 1:ne
    x1 = p(1,e(1,k)); % x at first point in segment
    x2 = p(1,e(2,k)); % x at second point in segment
    xm = (x1 + x2)/2; % x at segment midpoint
    y1 = p(2,e(1,k)); % y at first point in segment
    y2 = p(2,e(2,k)); % y at second point in segment
    ym = (y1 + y2)/2; % y at segment midpoint
    switch e(5,k)
        case {1,2,3,4}
            hk = zeros(N);
            hk(1,1) = 1;
            hk(2,2) = 1;
            hk = hk(:);
            hmatrix(:,k) = hk;
            hmatrix(:,k+ne) = hk;
            rk = zeros(N,1); 
            rmatrix(:,k) = rk;
            rmatrix(:,k+ne) = rk;                   
    end
end
end

function OKFcn(hObject,~,fig3)
if ishandle(fig3)
    delete(fig3);
end
delete(get(hObject,'Parent'));
end