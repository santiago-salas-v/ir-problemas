function PDETEST_System
% Rectangle is code 3, 4 sides,
% followed by x-coordinates and then y-coordinates
R1=[3,4,-1,1,1,-1,-.4,-.4,.4,.4]';
C1=[1,.5,0,.2]';
% Pad C1 with zeros to enable concatenation with R1
C1=[C1;zeros(length(R1)-length(C1),1)];
geom=[R1,C1];

% Names for the two geometric objects
ns=(char('R1','C1'))';
% Set formula
sf='R1-C1';
% Create geometry
gd=decsg(geom,sf,ns);

% View geometry
fig3=figure;
h=axes('Parent',fig3);
pdegplot(gd);
set(h,'DataAspectRatio',[1,1,1]);
xlim(h,[-1.1 1.1]);

% The initial condition is u(x,y) = 0 at t = 0.
% After running the code for creating the geometry, create the mesh, refine
% it twice, and jiggle it once.
N=3 % 3 Eqs.
[p,e,t] = initmesh(gd);
[p,e,t] = refinemesh(gd,p,e,t);
[p,e,t] = refinemesh(gd,p,e,t);
p = jigglemesh(p,e,t);
pdemesh(p,e,t);
np = size(p,2); % number of points
u0 = zeros(np,N); % initial guess

tlist = linspace(0,1,50);

b = @pdebound;
d = [1 2 3]';
a = [1 2 3]';
f = @fcoeffunction;
c = (char('1+x.^2+y.^2','1+x.^2+y.^2','1+x.^2+y.^2')');
u = parabolic(u0,tlist,b,p,e,t,c,a,f,d);

for tt = 1:size(u,2) % number of steps
    pdeplot(p,e,t,'xydata',u(:,tt),'zdata',u(:,tt),'colormap','jet');
    axis([-1 1 -1/2 1/2 -1.5 1.5 -1.5 1.5]); % use fixed axis
    title(['Step ' num2str(tt)]);
    view(-45,22);
    drawnow;
    pause(.1);
end

delete(fig3);

end

function f = fcoeffunction(p,t,u,time)
N = 3; % Number of equations
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
% Now the particular functional form of f
f(1,:) = xpts - ypts + uintrp(1,:);
f(2,:) = 1 + tanh(ux(1,:)) + tanh(uy(3,:));
f(3,:) = (5+uintrp(3,:)).*sqrt(xpts.^2+ypts.^2);
end

function [qmatrix,gmatrix,hmatrix,rmatrix] = pdebound(p,e,u,time)
N = 3;
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
            hk = hk(:);
            hmatrix(:,k) = hk;
            hmatrix(:,k+ne) = hk;
            rk = zeros(N,1); % Not strictly necessary
            rmatrix(:,k) = rk; % These are already 0
            rmatrix(:,k+ne) = rk;
            qk = zeros(N);
            qk(1,2) = 1;
            qk(1,3) = 1;
            qk(3,1) = 1;
            qk(3,2) = 1;
            qk = qk(:);
            qmatrix(:,k) = qk;
            gk = zeros(N,1);
            gk(1) = 1+xm^2;
            gk(3) = 1+ym^2;
            gmatrix(:,k) = gk;
        case {5,6,7,8}
            hk = zeros(N);
            hk(2,2) = 1;
            hk = hk(:);
            hmatrix(:,k) = hk;
            hmatrix(:,k+ne) = hk;
            rk = zeros(N,1); % Not strictly necessary
            rmatrix(:,k) = rk; % These are already 0
            rmatrix(:,k+ne) = rk;
            qk = zeros(N);
            qk(1,2) = 1+xm^2;
            qk(1,3) = 2+ym^2;
            qk(3,1) = 1+xm^4;
            qk(3,2) = 1+ym^4;
            qk = qk(:);
            qmatrix(:,k) = qk;
            gk = zeros(N,1);
            gk(1) = cos(pi*xm);
            gk(3) = tanh(xm*ym);
            gmatrix(:,k) = gk;
    end
end
end