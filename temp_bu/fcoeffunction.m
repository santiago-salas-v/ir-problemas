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