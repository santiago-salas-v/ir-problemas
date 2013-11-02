%% PFR, Efecto de condiciones de alimentaci�n
% Encuentra la soluci�n en estado estacionario y no estacionario del
% balance de materia y energ�a de un PFR donde suceden dos reacciones
% irreversibles, consecutivas, permitiendo estudiar los efectos de
% modificar las condiciones de alimentaci�n
%% 1. Reactor
%% 1.1. PFR
%
% <<../imagenes/Prob_02.png>>
% 
%% 1.2. Ecuaciones de conservaci�n
%%
% ${{\partial C_A} \over {\partial t}}+
% u_z{{\partial C_A} \over {\partial z}} = R_A$ ...(Materia)
%
% ${{\partial C_B} \over {\partial t}}+
% u_z{{\partial C_B} \over {\partial z}} = R_B$ ...(Materia)
%
% ${{\partial C_C} \over {\partial t}}+
% u_z{{\partial C_C} \over {\partial z}} = R_C$ ...(Materia)
%
% ${{\partial T} \over {\partial t}}+
% u_z{{\partial T} \over {\partial z}} = {{q_c} \over {\rho \times Cp}}+
% {{q_i} \over {\rho \times Cp}}$ ...(Energ�a T�rmica)
%
% (para componentes A,B,C)
%% 2. Reacci�n
%
% $A \rightarrow B$, exot�rmica, de 1er orden
% 
% $B \rightarrow C$, exot�rmica, de 1er orden
% 
%% 2.1. Estequiometr�a
%
% $A \rightarrow B$...(1), exot�rmica, de 1er orden
% 
% $\nu_{A,1}=-1$
%
% $\nu_{B,1}=+1$
%
% $\nu_{C,1}=+1$
% 
% $B \rightarrow C$...(2), exot�rmica, de 1er orden
%
% $\nu_{A,2}=0$
%
% $\nu_{B,2}=-1$
%
% $\nu_{C,2}=+1$
%
%% 2.2. Termodin�mica
%
% $A \rightarrow B$...(1), 
% $\Delta Hr_1<0$ ...(Exot�rmica)
%
% $\Delta Hr_1=\Sigma_i (\nu_{i,1} \Delta H_{f,i})=
% -\Delta H_{f,A}+\Delta H_{f,B}<0$ ...(Exot�rmica)
%
% $B \rightarrow C$...(2), 
% $\Delta Hr_2<0$ ...(Exot�rmica)
%
% $\Delta Hr_2=\Sigma_i (\nu_{i,2} \Delta H_{f,i})=
% -\Delta H_{f,B}+\Delta H_{f,C}<0$ ...(Exot�rmica)
%
%% 2.3. Cin�tica
%
% $A \rightarrow B$, de 1er orden
% 
% $r_1=k_{1,1}(T) \times C_A$...rapidez de reacci�n de 1er orden para
% reacci�n 1
%
% $B \rightarrow C$, de 1er orden
%
% $r_2=k_{1,2}(T) \times C_B$...rapidez de reacci�n de 1er orden para
% reacci�n 2
%
%% 2.3.1. Rapidez de generaci�n / consumo de componentes 
%
% * Consumo de  A
%
% $R_A=\Sigma_j (\nu_{A,j} r_j)=-k_{1,1}(T) \times C_A$
%
% * Generaci�n / consumo de  B
%
% $R_B=\Sigma_j (\nu_{B,j} r_j)=+k_{1,1}(T) \times C_A
% -k_{1,2}(T) \times C_B$
%
% * Formaci�n de  C
%
% $R_C=\Sigma_j (\nu_{C,j} r_j)=+k_{1,2}(T) \times C_B$
%
%% 2.3.2. Rapidez de generaci�n de calor de reacci�n
%
% $q_c=\Sigma_i ( (-\Delta Hr_i) \times r_i)=$
%
% $+(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B$
%
%% 2.3.3. Constantes de rapidez
%
% Expr. de Arrhenius
%
% $k_{1,1}(T) = k_{1,1,0} \times 
% exp[-{{E_1}\over{R}}({{1}\over{T}}-{{1}\over{T_{0,ref}}})]$ ...Constante
% de rapidez de primer orden para reacci�n 1.
%
% $k_{1,2}(T) = k_{1,2,0} \times 
% exp[-{{E_2}\over{R}}({{1}\over{T}}-{{1}\over{T_{0,ref}}})]$ ...Constante
% de rapidez de primer orden para reacci�n 2.
%
% *NOTA:*
%
% Se est� utilizando la expresi�n de Arrhenius en una forma �til para
% referirla a diferentes temperaturas. Su forma m�s utilizada es:
% 
% $k_{1,1}(T) = A \times exp({{-E_1}\over {R T}})$
% 
% A una temperatura de referencia $T_{0,ref}$:
%
% $k_{1,1}(T_{0,ref}) = k_{1,1,0}= A \times 
% exp({{-E_1}\over {R T_{0,ref}}})$
%
% La conversi�n entre estas formas entonces es la siguiente:
% 
% $A = k_{1,1,0}/exp({{-E_1}\over {R T_{0,ref}}})$ 
%
%% 2.4. Transferencia de calor con el fluido de enfriamiento
% 
% $q_i=U A\times (Ta-T)$
%% 3. Modelo matem�tico
% Juntando los puntos anteriores.
%% 3.1. Ecuaciones
%
% Ec. 1. ${{\partial C_A} \over {\partial t}}+
% u_z{{\partial C_A} \over {\partial z}} = 
% -k_{1,1}(T) \times C_A$ 
%
% Ec. 2. ${{\partial C_B} \over {\partial t}}+
% u_z{{\partial C_B} \over {\partial z}} = 
% +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
%
% Ec. 3. ${{\partial C_C} \over {\partial t}}+
% u_z{{\partial C_C} \over {\partial z}} =
% +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. ${{\partial T} \over {\partial t}}+
% u_z{{\partial T} \over {\partial z}} =$
%
% ${{1} \over {\rho \times Cp}} \times [(-\Delta Hr_1) \times k_{1,1}(T) 
% \times C_A +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B] +$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T)$
% 
% * Funcionalidades con temperatura
%
% $k_{1,1}(T) = k_{1,1,0} \times 
% exp[-{{E_1}\over{R}}({{1}\over{T}}-{{1}\over{T_{0,ref}}})]$
%
% $k_{1,2}(T) = k_{1,2,0} \times 
% exp[-{{E_2}\over{R}}({{1}\over{T}}-{{1}\over{T_{0,ref}}})]$
%
%% 3.2. Casos del modelo
%
%% 3.2.1. CSTR-1 Estado estacionario, isot�rmico
% En este caso el reactor ha alcanzando el estado estacionario sin haber
% cambiado su temperatura desde el inicio, de manera que $T=T_{t=0}$. En el
% estado estacionario el balance de energ�a implica que ser� necesario
% extraer la cantidad de calor $qi(T_{estacionario})=qi(T_{t=0})$ (en 
% reacciones exot�rmicas). Los par�metros de condiciones iniciales con las
% que se inici� el reactor al tiempo t=0 salvo temperatura $T=T_{t=0}$ no
% juegan un papel en la soluci�n, ni tampoco c�mo fueron variando a lo
% largo del tiempo. El modelo �nicamente expone las condiciones en estado 
% estacionario.
%
% Ec. 1. ${{\partial C_A} \over {\partial t}}+
% u_z{{\partial C_A} \over {\partial z}} =
% -k_{1,1}(T_{t=0}) \times C_A$ 
%
% Ec. 2. $-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T_{t=0}) \times C_A -k_{1,2}(T_{t=0}) \times C_B$
%
% Ec. 3. $-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T_{t=0}) \times C_B$ ...(Dependiente)
%
% Ec. 4. $-(T_0-T_{t=0})/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T_{t=0}) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T_{t=0}) \times C_B] +$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T_{t=0})$
%
%% 3.2.1.1. Variables independientes
%
% Dados los valores a especificar (3.2.1.3) hay una temperatura $T=T_{t=0}$
% �nica que satisface la ecuaci�n 4, ya que el sistema no tiene grados de
% libertad. 
%
%% 3.2.1.2. Variables dependientes
%
% $C_A , C_B, C_C, T=T_{t=0}$, un valor �nico
% 
%% 3.2.1.3. Valores a especificar
%
% * Condiciones de alimentaci�n: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Par�metros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Par�metros de intercambio de calor con el fluido de enfriamiento: $A, U$
%
% * Par�metros *termodin�micos* de la reacci�n: $\Delta Hf_A, \Delta Hf_B$
%
% * Par�metros *cin�ticos* de la reacci�n: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.2. CSTR-2 Estado estacionario, adiab�tico
% En este caso no se extrae calor del reactor en estado estacionario 
% $qi(T_{Estacionario})=0$ , de manera que todo el calor de despedido por 
% reacci�n se dirige a aumentar la temperatura (para reacciones 
% exot�rmicas). Esta temperatura estar� dada por las condiciones de
% alimentaci�n y las condiciones del reactor, par�metros cin�ticos, etc.
% pero no intervienen condiciones iniciales ni a lo largo del tiempo.
%
% El sistema de ecuaciones no tiene grados de libertad pero puesto que es
% no lineal, puede haber m�s de un conjunto de valores $C_A, C_B, C_C, T$
% que satisfacen las ecuaciones 1-4. Estos representan los diferentes
% estados estacionarios posibles. 
%
% Ec. 1. $-(C_{A0}-C_A)/\theta = -k_{1,1}(T) \times C_A$
%
% Ec. 2. $-(C_{B0}-C_B)/\theta = +k_{1,1}(T) \times C_A -k_{1,2}(T) \times
% C_B$
%
% Ec. 3. $-(C_{C0}-C_C)/\theta = +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. $-(T_0-T)/\theta = {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A +(-\Delta Hr_2) \times
% k_{1,2}(T) \times C_B] + \bf 0$
%
%% 3.2.2.1. Variables independientes
%
% Para observar la multiplicidad de estados estacionarios (las m�ltiples
% soluciones), se toma como variable independiente: la temperatura $T$
%
%% 3.2.2.2. Variables dependientes
%
% $C_A , C_B, C_C, T$ , en un estado estacionario dado.
% 
%% 3.2.2.3. Valores a especificar
%
% * Condiciones de alimentaci�n: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Par�metros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Cantidad de calor intercambiada: $qi=0$
%
% * Par�metros *termodin�micos* de la reacci�n: $\Delta Hf_A, \Delta Hf_B$
%
% * Par�metros *cin�ticos* de la reacci�n: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
%
%% 3.2.3. CSTR-3 Estado estacionario, no-isot�rmico, no-adiab�tico
% En este caso se tiene un sistema igual que el del reactor adiab�tico pero
% $qi=U A \times(Ta-T) \neq 0$. Los par�metros de condiciones iniciales con
% las que se inici� el reactor al tiempo t=0 no juegan un papel en la
% soluci�n, ni tampoco c�mo fueron variando a lo largo del tiempo. El
% modelo �nicamente expone las condiciones en estado estacionario.
%
% El sistema de ecuaciones no tiene grados de libertad pero puesto que es
% no lineal, puede haber m�s de un conjunto de valores $C_A, C_B, C_C, T$
% que satisfacen las ecuaciones 1-4. Estos representan los diferentes
% estados estacionarios posibles. 
%
% Ec. 1. $-(C_{A0}-C_A)/\theta = -k_{1,1}(T) \times C_A$
%
% Ec. 2. $-(C_{B0}-C_B)/\theta = +k_{1,1}(T) \times C_A -k_{1,2}(T) \times
% C_B$
%
% Ec. 3. $-(C_{C0}-C_C)/\theta = +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. $-(T_0-T)/\theta ={{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T_{t=0}) \times C_A +(-\Delta Hr_2)
% \times k_{1,2}(T) \times C_B] +$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T)$
%
%% 3.2.3.1. Variables independientes
%
% Para observar la multiplicidad de estados estacionarios (las m�ltiples
% soluciones), se toma como variable independiente: la temperatura $T$
% 
%% 3.2.3.2. Variables dependientes
%
% $C_A , C_B, C_C, T$ en un estado estacionario dado.
% 
%% 3.2.3.3. Valores a especificar
%
% * Condiciones de alimentaci�n: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Par�metros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Par�metros de intercambio de calor con el fluido de enfriamiento: $A, U$
%
% * Par�metros *termodin�micos* de la reacci�n: $\Delta Hf_A, \Delta Hf_B$
%
% * Par�metros *cin�ticos* de la reacci�n: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.4. CSTR-4 Estado no-estacionario, isot�rmico
% En este caso no hay variaci�n de la temperatura con el tiempo, por lo que
% ${{d T}\over{d t}}=0$, y $T = T_{t=0}$. Siendo un par�metro a especificar
% la temperatura inicial, el balance de energ�a requerir� la cantidad de
% calor removida que es funci�n del tiempo $qi(t)$, la cu�l ser� una
% variable dependiente ya que se calcula en base a la temperatura inicial
% seleccionada. El flujo del fluido de enfriamiento tendr�a que controlarse
% para que pudiera cumplir exactamente con este perfil de calor transferido
% y mantener la temperatura sin cambiar mientras se alcanza el estado
% estacionario.
%
% Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta = 
% -k_{1,1}(T_{t=0}) \times C_A$ 
%
% Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T_{t=0}) \times C_A -k_{1,2}(T_{t=0}) \times C_B$
%
% Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T_{t=0}) \times C_B$ ...(Dependiente)
%
% Ec. 4. $-(T_0-T_{t=0})/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T_{t=0}) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T_{t=0}) \times C_B] +qi(t)$
%
%% 3.2.4.1. Variables independientes
%
% $t$
%
%% 3.2.4.2. Variables dependientes
%
% $C_A , C_B, C_C, qi(t)$
% 
%% 3.2.4.3. Valores a especificar
%
% * Condiciones de alimentaci�n: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Condiciones iniciales: $C_{A,t=0},C_{B,t=0},C_{C,t=0},\bf T=T_{t=0}$
% 
% * Par�metros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Par�metros *termodin�micos* de la reacci�n: $\Delta Hf_A, \Delta Hf_B$
%
% * Par�metros *cin�ticos* de la reacci�n: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.5. CSTR-5 Estado no-estacionario, adiab�tico
% En este caso el calor liberado por la reacci�n �nicamente ir� dirigido
% a aumentar la temperatura de la mezcla en el reactor a lo largo del 
% tiempo (para reacciones exot�rmicas), de manera que $qi(t)=0$
%
% Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta = 
% -k_{1,1}(T) \times C_A$ 
%
% Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
%
% Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. ${{d T}\over{d t}}-(T_0-T)/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B] + \bf 0$
%
%% 3.2.5.1. Variables independientes
%
% $t$
%
%% 3.2.5.2. Variables dependientes
%
% $C_A , C_B, C_C, T$
% 
%% 3.2.5.3. Valores a especificar
%
% * Condiciones de alimentaci�n: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Condiciones iniciales: $C_{A,t=0},C_{B,t=0},C_{C,t=0}, T=T_{t=0}$
% 
% * Par�metros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Cantidad de calor removida: $qi=0$
%
% * Par�metros *termodin�micos* de la reacci�n: $\Delta Hf_A, \Delta Hf_B$
%
% * Par�metros *cin�ticos* de la reacci�n: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.6. CSTR-6 Estado no-estacionario, no-isot�rmico, no-adiab�tico
% En este caso se resuelve el sistema para una cantidad dada de calor
% removido $qi(t)=U A \times (Ta-T)$, o que se puede especificar como
% funci�n del tiempo siempre que sea una funci�n que tiene valores finitos
% y alcanza un valor dado en el estado estacionario, $qi(t= \infty)$ 
%
% Ec. 1. ${{d C_A}\over{d t}}-(C_{A0}-C_A)/\theta = 
% -k_{1,1}(T) \times C_A$
%
% Ec. 2. ${{d C_B}\over{d t}}-(C_{B0}-C_B)/\theta = 
% +k_{1,1}(T) \times C_A -k_{1,2}(T) \times C_B$
%
% Ec. 3. ${{d C_C}\over{d t}}-(C_{C0}-C_C)/\theta =
% +k_{1,2}(T) \times C_B$ ...(Dependiente)
%
% Ec. 4. ${{d T}\over{d t}}-(T_0-T)/\theta = 
% {{1} \over {\rho \times Cp}} \times$
%
% $[(-\Delta Hr_1) \times k_{1,1}(T) \times C_A
% +(-\Delta Hr_2) \times k_{1,2}(T) \times C_B]+$
%
% ${{1} \over {\rho \times Cp}} \times U A \times(Ta-T)$
%
%% 3.2.6.1. Variables independientes
%
% $t$
%
%% 3.2.6.2. Variables dependientes
%
% $C_A , C_B, C_C, T$
% 
%% 3.2.6.3. Valores a especificar
%
% * Condiciones de alimentaci�n: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Condiciones iniciales: $C_{A,t=0},C_{B,t=0},C_{C,t=0},T_{t=0}$
% 
% * Par�metros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Par�metros de intercambio de calor con el fluido de enfriamiento: $A,
% U$
%
% * Par�metros *termodin�micos* de la reacci�n: $\Delta Hf_A, \Delta Hf_B$
%
% * Par�metros *cin�ticos* de la reacci�n: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 4. Soluci�n del Modelo
% 
%% 4.1. Diarama de flujo simplificado
%
% <../Diagramas_de_flujo/DF_Prob_01.pdf DF_Prob_01.pdf>
%
%% 4.2. Diagrama de flujo completo
%% 4.3. C�digo en Matlab
%
% <./gui4.html C�DIGO>