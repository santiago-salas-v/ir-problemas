function r=rapideces(C,T,alfa,k0,E,R,T0ref)
%RAPIDECES obtiene rapideces basado en el modelo de potencia:
%  r(T,C1,C2,...,Cn)=ki(T)*C1^alpha_(i,1)*C2^alpha_(i,2)*...
%                         *Cn^alpha_(i,n)
%  Y efecto de temperatura en la constante de rapidez mediante
%  expresión de tipo Arrhenius:
%  ki(T)=ki0*exp(-Ei/R*(1/T-1/T0ref))
%  
%  r = RAPIDECES(C,T,alfa,k0,E,R,T0ref) regresa matriz r de Nr
%  rapideces, con vector de concentraciones C, temperatura T, 
%  órdenes de reacción ALFA, constantes de rapidez en T0ref k0,
%  constante universal de los gases R, temperatura de referencia
%  de ecuación de Arrhenius T0ref.
r=zeros(size(alfa,1),size(C,2));
for i=1:size(alfa,1)
    r(i,:)=k0(i)*exp(-E(i)/R*(1./T-1/T0ref));
    for k=1:size(C,1)
        r(i,:)=r(i,:).*C(k,:).^alfa(i,k);
    end
end
end