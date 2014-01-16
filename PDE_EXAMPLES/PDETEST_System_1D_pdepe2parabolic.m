function PDETEST_System_1D_pdepe2parabolic
%Problem using parabolic system for special 1-D case,
% where "y" is arbitrary (0.1), z[0,L] ==> "x"[0,L] and t[0,t]==>>"t"[0,t]
%   d*du/dt-div(c*grad(u))+a*u=f
%   d=1, c=0, a=0, f=f(x,y,u,ux,uy)
% Rectangle is code 3, 4 sides,
% followed by x-coordinates and then y-coordinates
L=1;
t_tot=2;
yMAX=2;
nt=20;
nGridPoints=70;
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
pdegplot(gd,'edgeLabels','on');
set(h,'DataAspectRatio',[1,1,1]);
xlim([-0.1*L,+1.1*L]);
ylim([-0.1*yMAX,+1.1*yMAX]);

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
u0(1:np)=1;

tlist = linspace(0,t_tot,nt);

b = @pdebound;
d = [1 1]';
a = [0 0]';
f = @fcoeffunction;
c = [0.024,0,0.17,0.024,0,0.17]'; % 3N-row form [c1;0;c2;c3;0;c4]
% c = 0;
u = parabolic(u0,tlist,b,p,e,t,c,a,f,d);

uxy=zeros(N,length(tlist),size(t,2));

for i=1:N
    uxy(i,:,:)=pdeintrp(p,t,u(size(u,1)/2*(i-1)+1:size(u,1)/2*(i-0),:));
end

uxya=zeros(N,nGridPoints+1,length(tlist));

for i=1:N
    for j=1:length(tlist)
        uxya(i,:,j)=...
            tri2grid(p,t,squeeze(uxy(i,j,:)),...
            (0:L/(nGridPoints):L),0);
    end
end

% pdeplot(p,e,t,...
%     'xydata',u(1+size(u,1)/2*0:size(u,1)/2*1,1),...
%     'zdata',u(1+size(u,1)/2*0:size(u,1)/2*1,1),'colormap','jet');
% hold on;
% pdeplot(p,e,t,...
%     'xydata',u(1+size(u,1)/2*1:size(u,1)/2*2,1),...
%     'zdata',u(1+size(u,1)/2*1:size(u,1)/2*2,1),'colormap','jet');
% hold on;
h=-1*ones(1,N);
for i=1:N
    h(i)=subplot(1,N,i);
end

for i = 1:N % number of steps
%     pdeplot(p,e,t,...
%         'xydata',u(1+size(u,1)/2*0:size(u,1)/2*1,tt),...
%         'zdata',u(1+size(u,1)/2*0:size(u,1)/2*1,tt),'colormap','jet');
%     hold on;
%     pdeplot(p,e,t,...
%         'xydata',u(1+size(u,1)/2*1:size(u,1)/2*2,tt),...
%         'zdata',u(1+size(u,1)/2*1:size(u,1)/2*2,tt),'colormap','jet');
%     hold on;
    subplot(h(i));
    surf(tlist,(0:L/(nGridPoints):L),squeeze(uxya(i,:,:)));
    set(findobj(h,'Type','patch'),'EdgeAlpha',0.1);
    %axis([0 L 0 yMAX]); % use fixed axis
    title(['u' num2str(i),'(t,z)']);
    view(-45,22);
    drawnow;
    pause(.1);
end

rotate3d on;

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
f(1,:) = -F+ux(1,:)*0;
f(2,:) = +F+ux(2,:)*0;
end

function [qmatrix,gmatrix,hmatrix,rmatrix] = pdebound(p,e,u,time)
N = 2;
ne = size(e,2); % number of edges
qmatrix = zeros(N^2,ne);
gmatrix = zeros(N,ne);
hmatrix = zeros(N^2,2*ne);
rmatrix = zeros(N,2*ne);
% u into N vectors of length np
np=length(p);
uvector=reshape(u,np,2)';
for k = 1:ne
    x1 = p(1,e(1,k)); % x at first point in segment
    x2 = p(1,e(2,k)); % x at second point in segment
    xm = (x1 + x2)/2; % x at segment midpoint
    y1 = p(2,e(1,k)); % y at first point in segment
    y2 = p(2,e(2,k)); % y at second point in segment
    ym = (y1 + y2)/2; % y at segment midpoint
    
    u1 = uvector(:,e(1,k));      % u at first point in segment
    u2 = uvector(:,e(2,k));      % u at second point in segment
    um = (u1 + u2)/2;            % u at segment midpoint
    
    switch e(5,k)        
        % Sides:
        % 1 (x=L),      bc, right    3 (x=0)     bc, left
        % 2 (y=yMAX),   end y        4 (y=0)     beg y
        % hu=r                          (Neumann M=0)
        % Links,  [0,0;0,1][u1;u2]   = [0;0]
        % Rechts, [1,0;0,0][u1;u2]   = [+1;0]
        % n.div(c*grad(u))+qu=g+h'u     (Dirchlet M=N)
        % Links,  n.div(c*grad(u)) = [0;0] +0
        % Rechts, n.div(c*grad(u)) = [0;ux2] +0
        case {4} % (x=0)
%             gk = zeros(N,1);
%             g(1)=0;
%             g(2)=0;
%             gmatrix(:,k) = gk;
            hk = zeros(N);
            hk(1,1) = 0;
            hk(2,2) = 1;
            hk=hk(:);
            hmatrix(:,k) = hk;
            hmatrix(:,k+ne) = hk;
            rk = zeros(N,1);
            rk(1)=0;
            rk(2)=0;   %-um(1);
            rmatrix(:,k) = rk;
            rmatrix(:,k+ne) = rk;
        case {2} % (x=L)
%             gk = zeros(N,1);
%             g(1)=0;
%             g(2)=0;
%             gmatrix(:,k) = gk;
            hk = zeros(N);
            hk(1,1) = 1;
            hk(2,2) = 0;
            hk=hk(:);
            hmatrix(:,k) = hk;
            hmatrix(:,k+ne) = hk;
            rk = zeros(N,1);
            rk(1)=+1;
            rk(2)=0;
            rmatrix(:,k) = rk;
            rmatrix(:,k+ne) = rk;
        case {1} % (y=0)
            
        case {3} % (y=yMAX)
    end
end
end

function OKFcn(hObject,~,fig3)
if ishandle(fig3)
    delete(get(hObject,'Parent'));
end
end