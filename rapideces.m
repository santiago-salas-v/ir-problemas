function [varargout]=rapideces(C,T,alfa,k0,E,R,T0ref)
%RAPIDECES obtiene rapideces basado en el modelo de potencia:
%  r(T,C1,C2,...,Cn)=ki(T)*C1^alpha_(i,1)*C2^alpha_(i,2)*...
%                         *Cn^alpha_(i,n)
%  Y efecto de temperatura en la constante de rapidez mediante
%  expresi�n de tipo Arrhenius:
%  ki(T)=ki0*exp(-Ei/R*(1/T-1/T0ref))
%  
%  r = RAPIDECES(C,T,alfa,k0,E,R,T0ref) regresa matriz r de Nr
%  rapideces, con vector de concentraciones C, temperatura T, 
%  �rdenes de reacci�n ALFA, constantes de rapidez en T0ref k0,
%  constante universal de los gases R, temperatura de referencia
%  de ecuaci�n de Arrhenius T0ref.
%
%  [r,k] = RAPIDECES(C,T,alfa,k0,E,R,T0ref) regresa matriz r de Nr
%  rapideces, y matriz k de Nr constantes de rapidez, con vector de 
%  concentraciones C, temperatura T, �rdenes de reacci�n ALFA, constantes
%  de rapidez en T0ref k0, constante universal de los gases R, temperatura
%  de referencia de ecuaci�n de Arrhenius T0ref.
r=zeros(size(alfa,1),size(C,2));
k=zeros(size(alfa,1),size(C,2));
for i=1:size(alfa,1)
    k(i,:)=k0(i)*exp(-E(i)/R*(1./T-1/T0ref));
    r(i,:)=k(i,:);
    for j=1:size(C,1)
        r(i,:)=r(i,:).*C(j,:).^alfa(i,j);
    end
end

if nargout==2
    varargout{1}=r;
    varargout{2}=k;
elseif nargout==1
    varargout{1}=r;    
end

end