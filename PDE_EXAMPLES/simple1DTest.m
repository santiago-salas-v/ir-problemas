function simple1DTest
% 1D transient heat transfer in x-direction (http://www.mathworks.com/matlabcentral/answers/56037-solving-one-dimensional-pde-s-using-the-pde-toolbox)
h =.1; w=1; % width equal one, height is arbitrary (set to .1)
g = decsg([3 4 0 w w 0 0 0 h h]', 'R1', ('R1')');
[p, e, t]=initmesh(g, 'Hmax', .05);
b=@boundFile;
c=1; a=0; d=1;
f='100*x'; % heat load varies along the bar
u0 = 0; % initial temperature equals zero
tlist = 0:.02:1;
u=parabolic(u0, tlist, b,p,e,t,c,a,f,d);
figure; pdeplot(p,e,t, 'xydata', u(:,end), 'contour', 'on'); axis equal;
title(sprintf('Temperature Distribution at time=%g seconds', tlist(end)));
figure; plot(tlist, u(2,:)); xlabel 'Time'; ylabel 'Temperature'; grid;
title 'Temperature at tip as a function of time'
end
function [ q, g, h, r ] = boundFile( p, e, u, time )
N = 1; ne = size(e,2);
q = zeros(N^2, ne); g = zeros(N, ne);
h = zeros(N^2, 2*ne); r = zeros(N, 2*ne);
% zero Neumann BCs (insulated) on edges 1 and 3 at y=0 and y=h
% and the right edge, edge 2
for i=1:ne
    switch(e(5,i))
        case 4
            h(1,i) = 1; h(1,i+ne) = 1;
            r(i) = 500; r(i+ne) = 500; % 500 on left edge
    end
end
end