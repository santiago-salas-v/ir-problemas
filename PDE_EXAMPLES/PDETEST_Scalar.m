function PDETEST_Scalar
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
set(fig3,'WindowStyle','docked');
h=axes('Parent',fig3);
pdegplot(gd);
set(h,'DataAspectRatio',[1,1,1]);
xlim(h,[-1.1 1.1]);

% The initial condition is u(x,y) = 0 at t = 0.
% After running the code for creating the geometry, create the mesh, refine
% it twice, and jiggle it once.
[p,e,t] = initmesh(gd);
[p,e,t] = refinemesh(gd,p,e,t);
[p,e,t] = refinemesh(gd,p,e,t);
p = jigglemesh(p,e,t);
pdemesh(p,e,t);
u0=zeros(size(p,2),1);

tlist = linspace(0,1,50);

b = @pdebound;
d = 5;
a = 0;
f = @framp;
%f = 'framp2(t,u,ux,uy)';
c = '1+x.^2+y.^2';
u = parabolic(u0,tlist,b,p,e,t,c,a,f,d);

for tt = 1:size(u,2) % number of steps
    pdeplot(p,e,t,'xydata',u(:,tt),'zdata',u(:,tt),...
        'colormap','jet','mesh','on');
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

end

function f = framp(p,t,u,time)
[ux,uy] = pdegrad(p,t,u);
if time <= 0.1
    f = 10*time;
elseif time <= 0.9
    f = 1;
else
    f = 10-10*time;    
end
f=10*f;
end

function [qmatrix,gmatrix,hmatrix,rmatrix] = pdebound(p,e,u,time)
ne = size(e,2); % number of edges
qmatrix = zeros(1,ne);
gmatrix = qmatrix;
hmatrix = zeros(1,2*ne);
rmatrix = hmatrix;
for k = 1:ne
    x1 = p(1,e(1,k)); % x at first point in segment
    x2 = p(1,e(2,k)); % x at second point in segment
    xm = (x1 + x2)/2; % x at segment midpoint
    y1 = p(2,e(1,k)); % y at first point in segment
    y2 = p(2,e(2,k)); % y at second point in segment
    ym = (y1 + y2)/2; % y at segment midpoint
    switch e(5,k)
        case {1,2,3,4} % rectangle boundaries
            hmatrix(k) = 1;
            hmatrix(k+ne) = 1;
            if ~isempty(time)
                rmatrix(k) = time*(x1 - y1);
                rmatrix(k+ne) = time*(x2 - y2);
            end
        otherwise % same as case {5,6,7,8}, circle boundaries
            qmatrix(k) = 1;
            gmatrix(k) = xm^2 + ym^2;
    end
end
end

function OKFcn(hObject,~,fig3)
    if ishandle(fig3)
        delete(fig3);
    end
    delete(get(hObject,'Parent'));
end