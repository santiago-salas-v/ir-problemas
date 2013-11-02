function delta_Hr=delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares)
%DELTA_HR obtiene entalp�as de reacci�n a la temperatura del 
%  sistema mediante la expresi�n:
%  DHr =   sum_{j=1}^{n}{nu_{ij}*(-DELTA H_{fj})}
%        + sum_{j=1}^{n}{nu_{ij}*Cp_{(molar)j}*(T-Tref)}
%  
%  DHr = DELTA_HR(T,delta_Hf,Coefs_esteq,CpMolares) regresa 
%  matriz DHr de Nr entalp�as de reacci�n, a la temperatura
%  T, dada temperatura est�ndar Tref=298.15K, con entalp�as
%  de formaci�n de los componentes delta_Hf, coeficientes es-
%  tequiom�tricos Coefs_esteq de los componentes en las reac-
%  ciones, y capacidades calor�ficas molares CpMolares de los
%  componentes.
delta_Hr=...
    +Coefs_esteq*delta_Hf'*ones(1,size(T,2))...
    -Coefs_esteq*CpMolares'*(T-298.15);
delta_Hr=delta_Hr';
end