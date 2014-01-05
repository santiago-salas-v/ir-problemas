function f = framp2(t,u,ux,uy)
%[ux,uy] = pdegrad(p,t,u);
if t <= 0.1
    f = 10*t;
elseif t <= 0.9
    f = 1;
else
    f = 10-10*t;    
end
f=10*f;
end