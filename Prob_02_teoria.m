%% PFR, Efecto de condiciones de alimentación
% Encuentra la solución en estado estacionario y no estacionario del
% balance de materia y energía de un PFR donde suceden dos reacciones
% irreversibles, consecutivas, permitiendo estudiar los efectos de
% modificar las condiciones de alimentación
%% 1. Reactor
%% 1.1. PFR
%
% <<../imagenes/Prob_02.png>>
% 
%% 1.2. Ecuaciones de conservación
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
% {{q_i} \over {\rho \times Cp}}$ ...(Energía Térmica)
%
% (para componentes A,B,C)
%% 2. Reacción
%
% $A \rightarrow B$, exotérmica, de 1er orden
% 
% $B \rightarrow C$, exotérmica, de 1er orden
% 
%% 2.1. Estequiometría
%
% $A \rightarrow B$...(1), exotérmica, de 1er orden
% 
% $\nu_{A,1}=-1$
%
% $\nu_{B,1}=+1$
%
% $\nu_{C,1}=+1$
% 
% $B \rightarrow C$...(2), exotérmica, de 1er orden
%
% $\nu_{A,2}=0$
%
% $\nu_{B,2}=-1$
%
% $\nu_{C,2}=+1$
%
%% 2.2. Termodinámica
%
% $A \rightarrow B$...(1), 
% $\Delta Hr_1<0$ ...(Exotérmica)
%
% $\Delta Hr_1=\Sigma_i (\nu_{i,1} \Delta H_{f,i})=
% -\Delta H_{f,A}+\Delta H_{f,B}<0$ ...(Exotérmica)
%
% $B \rightarrow C$...(2), 
% $\Delta Hr_2<0$ ...(Exotérmica)
%
% $\Delta Hr_2=\Sigma_i (\nu_{i,2} \Delta H_{f,i})=
% -\Delta H_{f,B}+\Delta H_{f,C}<0$ ...(Exotérmica)
%
%% 2.3. Cinética
%
% $A \rightarrow B$, de 1er orden
% 
% $r_1=k_{1,1}(T) \times C_A$...rapidez de reacción de 1er orden para
% reacción 1
%
% $B \rightarrow C$, de 1er orden
%
% $r_2=k_{1,2}(T) \times C_B$...rapidez de reacción de 1er orden para
% reacción 2
%
%% 2.3.1. Rapidez de generación / consumo de componentes 
%
% * Consumo de  A
%
% $R_A=\Sigma_j (\nu_{A,j} r_j)=-k_{1,1}(T) \times C_A$
%
% * Generación / consumo de  B
%
% $R_B=\Sigma_j (\nu_{B,j} r_j)=+k_{1,1}(T) \times C_A
% -k_{1,2}(T) \times C_B$
%
% * Formación de  C
%
% $R_C=\Sigma_j (\nu_{C,j} r_j)=+k_{1,2}(T) \times C_B$
%
%% 2.3.2. Rapidez de generación de calor de reacción
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
% de rapidez de primer orden para reacción 1.
%
% $k_{1,2}(T) = k_{1,2,0} \times 
% exp[-{{E_2}\over{R}}({{1}\over{T}}-{{1}\over{T_{0,ref}}})]$ ...Constante
% de rapidez de primer orden para reacción 2.
%
% *NOTA:*
%
% Se está utilizando la expresión de Arrhenius en una forma útil para
% referirla a diferentes temperaturas. Su forma más utilizada es:
% 
% $k_{1,1}(T) = A \times exp({{-E_1}\over {R T}})$
% 
% A una temperatura de referencia $T_{0,ref}$:
%
% $k_{1,1}(T_{0,ref}) = k_{1,1,0}= A \times 
% exp({{-E_1}\over {R T_{0,ref}}})$
%
% La conversión entre estas formas entonces es la siguiente:
% 
% $A = k_{1,1,0}/exp({{-E_1}\over {R T_{0,ref}}})$ 
%
%% 2.4. Transferencia de calor con el fluido de enfriamiento
% 
% $q_i=U A\times (Ta-T)$
%% 3. Modelo matemático
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
%% 3.2.1. CSTR-1 Estado estacionario, isotérmico
% En este caso el reactor ha alcanzando el estado estacionario sin haber
% cambiado su temperatura desde el inicio, de manera que $T=T_{t=0}$. En el
% estado estacionario el balance de energía implica que será necesario
% extraer la cantidad de calor $qi(T_{estacionario})=qi(T_{t=0})$ (en 
% reacciones exotérmicas). Los parámetros de condiciones iniciales con las
% que se inició el reactor al tiempo t=0 salvo temperatura $T=T_{t=0}$ no
% juegan un papel en la solución, ni tampoco cómo fueron variando a lo
% largo del tiempo. El modelo únicamente expone las condiciones en estado 
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
% única que satisface la ecuación 4, ya que el sistema no tiene grados de
% libertad. 
%
%% 3.2.1.2. Variables dependientes
%
% $C_A , C_B, C_C, T=T_{t=0}$, un valor único
% 
%% 3.2.1.3. Valores a especificar
%
% * Condiciones de alimentación: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Parámetros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Parámetros de intercambio de calor con el fluido de enfriamiento: $A, U$
%
% * Parámetros *termodinámicos* de la reacción: $\Delta Hf_A, \Delta Hf_B$
%
% * Parámetros *cinéticos* de la reacción: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.2. CSTR-2 Estado estacionario, adiabático
% En este caso no se extrae calor del reactor en estado estacionario 
% $qi(T_{Estacionario})=0$ , de manera que todo el calor de despedido por 
% reacción se dirige a aumentar la temperatura (para reacciones 
% exotérmicas). Esta temperatura estará dada por las condiciones de
% alimentación y las condiciones del reactor, parámetros cinéticos, etc.
% pero no intervienen condiciones iniciales ni a lo largo del tiempo.
%
% El sistema de ecuaciones no tiene grados de libertad pero puesto que es
% no lineal, puede haber más de un conjunto de valores $C_A, C_B, C_C, T$
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
% Para observar la multiplicidad de estados estacionarios (las múltiples
% soluciones), se toma como variable independiente: la temperatura $T$
%
%% 3.2.2.2. Variables dependientes
%
% $C_A , C_B, C_C, T$ , en un estado estacionario dado.
% 
%% 3.2.2.3. Valores a especificar
%
% * Condiciones de alimentación: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Parámetros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Cantidad de calor intercambiada: $qi=0$
%
% * Parámetros *termodinámicos* de la reacción: $\Delta Hf_A, \Delta Hf_B$
%
% * Parámetros *cinéticos* de la reacción: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
%
%% 3.2.3. CSTR-3 Estado estacionario, no-isotérmico, no-adiabático
% En este caso se tiene un sistema igual que el del reactor adiabático pero
% $qi=U A \times(Ta-T) \neq 0$. Los parámetros de condiciones iniciales con
% las que se inició el reactor al tiempo t=0 no juegan un papel en la
% solución, ni tampoco cómo fueron variando a lo largo del tiempo. El
% modelo únicamente expone las condiciones en estado estacionario.
%
% El sistema de ecuaciones no tiene grados de libertad pero puesto que es
% no lineal, puede haber más de un conjunto de valores $C_A, C_B, C_C, T$
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
% Para observar la multiplicidad de estados estacionarios (las múltiples
% soluciones), se toma como variable independiente: la temperatura $T$
% 
%% 3.2.3.2. Variables dependientes
%
% $C_A , C_B, C_C, T$ en un estado estacionario dado.
% 
%% 3.2.3.3. Valores a especificar
%
% * Condiciones de alimentación: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Parámetros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Parámetros de intercambio de calor con el fluido de enfriamiento: $A, U$
%
% * Parámetros *termodinámicos* de la reacción: $\Delta Hf_A, \Delta Hf_B$
%
% * Parámetros *cinéticos* de la reacción: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.4. CSTR-4 Estado no-estacionario, isotérmico
% En este caso no hay variación de la temperatura con el tiempo, por lo que
% ${{d T}\over{d t}}=0$, y $T = T_{t=0}$. Siendo un parámetro a especificar
% la temperatura inicial, el balance de energía requerirá la cantidad de
% calor removida que es función del tiempo $qi(t)$, la cuál será una
% variable dependiente ya que se calcula en base a la temperatura inicial
% seleccionada. El flujo del fluido de enfriamiento tendría que controlarse
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
% * Condiciones de alimentación: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Condiciones iniciales: $C_{A,t=0},C_{B,t=0},C_{C,t=0},\bf T=T_{t=0}$
% 
% * Parámetros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Parámetros *termodinámicos* de la reacción: $\Delta Hf_A, \Delta Hf_B$
%
% * Parámetros *cinéticos* de la reacción: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.5. CSTR-5 Estado no-estacionario, adiabático
% En este caso el calor liberado por la reacción únicamente irá dirigido
% a aumentar la temperatura de la mezcla en el reactor a lo largo del 
% tiempo (para reacciones exotérmicas), de manera que $qi(t)=0$
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
% * Condiciones de alimentación: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Condiciones iniciales: $C_{A,t=0},C_{B,t=0},C_{C,t=0}, T=T_{t=0}$
% 
% * Parámetros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Cantidad de calor removida: $qi=0$
%
% * Parámetros *termodinámicos* de la reacción: $\Delta Hf_A, \Delta Hf_B$
%
% * Parámetros *cinéticos* de la reacción: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 3.2.6. CSTR-6 Estado no-estacionario, no-isotérmico, no-adiabático
% En este caso se resuelve el sistema para una cantidad dada de calor
% removido $qi(t)=U A \times (Ta-T)$, o que se puede especificar como
% función del tiempo siempre que sea una función que tiene valores finitos
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
% * Condiciones de alimentación: $C_{A,0},C_{B,0},C_{C,0},T_0, Q_0$
% 
% * Condiciones iniciales: $C_{A,t=0},C_{B,t=0},C_{C,t=0},T_{t=0}$
% 
% * Parámetros del reactor: $Vr, \theta=Vr/Q_0$
%
% * Parámetros de intercambio de calor con el fluido de enfriamiento: $A,
% U$
%
% * Parámetros *termodinámicos* de la reacción: $\Delta Hf_A, \Delta Hf_B$
%
% * Parámetros *cinéticos* de la reacción: 
% $k_{1,1,0}, k_{1,2,0}, E_1, E_2, T_{0, ref}$
% 
%% 4. Solución del Modelo
% 
%% 4.1. Diarama de flujo simplificado
%
% <../Diagramas_de_flujo/DF_Prob_01.pdf DF_Prob_01.pdf>
%
%% 4.2. Diagrama de flujo completo
%% 4.3. Código en Matlab
%
% <./gui4.html CÓDIGO>