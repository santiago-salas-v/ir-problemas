function delta_Hr=delta_Hr(T,delta_Hf,Coefs_esteq,CpMolares)
%DELTA_HR obtiene entalpías de reacción a la temperatura del 
%  sistema mediante la expresión:
%  DHr =   sum_{j=1}^{n}{nu_{ij}*(-DELTA H_{fj})}
%        + sum_{j=1}^{n}{nu_{ij}*Cp_{(molar)j}*(T-Tref)}
%  
%  DHr = DELTA_HR(T,delta_Hf,Coefs_esteq,CpMolares) regresa 
%  matriz DHr de Nr entalpías de reacción, a la temperatura
%  T, dada temperatura estándar Tref=298.15K, con entalpías
%  de formación de los componentes delta_Hf, coeficientes es-
%  tequiométricos Coefs_esteq de los componentes en las reac-
%  ciones, y capacidades caloríficas molares CpMolares de los
%  componentes.
delta_Hr=...
    +Coefs_esteq*delta_Hf'*ones(1,size(T,2))...
    -Coefs_esteq*CpMolares'*(T-298.15);
delta_Hr=delta_Hr';
end