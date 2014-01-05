function [qmatrix,gmatrix,hmatrix,rmatrix] = pdebound(p,e,u,time)
N = 3; % Set N = the number of equations
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
        otherwise
            % Fill in hmatrix,rmatrix or qmatrix,gmatrix
    end
end