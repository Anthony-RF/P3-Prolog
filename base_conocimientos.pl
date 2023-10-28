%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 													Proyecto 3													%
% 											Lenguajes de Programacion											%
% 									 Sistema de diagnóstico utilizando Prolog									%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	

infects(maria,pedro).
infects(pedro,julia).
infects(julia,flor).
infects(flor,rosa).
infects(rosa,gloria).
infects(jose,flor).
infects(carlos,jose).
infects(andres,jose).

%===============================================================================================================%
% 								                      Hechos													% 
%===============================================================================================================%

%------------------------------------------------------------
presenta_sintomas(true).
%------------------------------------------------------------
expuesto_al_virus(true).
%------------------------------------------------------------
incubacion_completada(true).
%------------------------------------------------------------
fuente_de_prueba_valida(autoprueba).
fuente_de_prueba_valida(centro).
%------------------------------------------------------------
tipo_de_prueba_valida(pcr).
tipo_de_prueba_valida(pa).
%------------------------------------------------------------
prueba_realizada_correctamente(true).
%------------------------------------------------------------
se_realizo_pcr(true).
%------------------------------------------------------------
se_realizo_pa(true).
%------------------------------------------------------------
infeccion_anterior(true).
%------------------------------------------------------------
positivo_ultimos_30_dias(true).
%------------------------------------------------------------
positivo_ultimos_90_dias(true).
%------------------------------------------------------------
prueba_unica(true).
%------------------------------------------------------------
transcurridas_48_horas(true).
%------------------------------------------------------------
resultado_concluyente(true).
%------------------------------------------------------------
resultado_positivo(true).
%------------------------------------------------------------
se_realizo_anticuerpos(true).
%------------------------------------------------------------
cumple_con_el_aislamiento(true).
%------------------------------------------------------------
informar_a_la_burbuja_social(true).
%------------------------------------------------------------
revisar_constantemente_los_sintomas(true).
%------------------------------------------------------------
seguir_el_tratamiento(true).
%------------------------------------------------------------
revisar_otras_enfermedades(true).
%------------------------------------------------------------
tomar_medidas_preventivas(true).
%------------------------------------------------------------

%===============================================================================================================%
% 								                      Reglas													% 
%===============================================================================================================%

%----------------------------------------------------------------------------------------------------------------
necesita_prueba(Sintomas,Exposicion,Incubacion) :- 
    presenta_sintomas(Sintomas);
    %or
    (expuesto_al_virus(Exposicion),
    %and
    incubacion_completada(Incubacion)).
%----------------------------------------------------------------------------------------------------------------
necesita_una_pcr(Necesidad, Unica, Positivo_30_dias, Positivo_90_dias) :-
    necesita_prueba(Necesidad,Necesidad,Necesidad),
    %and
    prueba_unica(Unica),
    %and
    not(positivo_ultimos_30_dias(Positivo_30_dias)),
    %and
    not(positivo_ultimos_90_dias(Positivo_90_dias)).
%----------------------------------------------------------------------------------------------------------------
necesita_una_pa(Necesidad, Unica, Positivo_30_dias, Positivo_90_dias) :-
    necesita_prueba(Necesidad,Necesidad,Necesidad),
    %and
    (not(prueba_unica(Unica));
    %or
    positivo_ultimos_30_dias(Positivo_30_dias);
    %or
    positivo_ultimos_90_dias(Positivo_90_dias)).
%----------------------------------------------------------------------------------------------------------------
se_realiza_pcr(Realizada,Concluyente) :-
    se_realizo_pcr(Realizada),
    %and
    resultado_concluyente(Concluyente).
%----------------------------------------------------------------------------------------------------------------
se_realiza_pa(Realizada,Concluyente) :-
    se_realizo_pa(Realizada),
    %and
    resultado_concluyente(Concluyente).
%----------------------------------------------------------------------------------------------------------------
pcr_positiva(Realiza_pcr, Resultado_pcr) :-
    necesita_una_pcr(true, true, false, false),
    %and
    se_realiza_pcr(Realiza_pcr,Realiza_pcr),
    %and
    resultado_positivo(Resultado_pcr).
%----------------------------------------------------------------------------------------------------------------
pcr_negativa(Realiza_pcr, Resultado_pcr) :-
    not(pcr_positiva(Realiza_pcr, Resultado_pcr)).
%----------------------------------------------------------------------------------------------------------------
pa_negativa(Sintomas, Realiza_pa_1, Realiza_pa_2, Realiza_pa_3, Resultado_pa_1, Resultado_pa_2, Resultado_pa_3) :-
    necesita_una_pa(true, false, true, true),
    %and
    se_realiza_pa(Realiza_1,Realiza_1),
    %and
    not(resultado_positivo(Resultado_pa_1)),
    (   
        (   
    	presenta_sintomas(Sintomas),
    	%and
    	transcurridas_48_horas(true),
    	%and
        se_realiza_pa(Realiza_2,Realiza_2),
        %and
        not(resultado_positivo(Resultado_pa_2))
    	);
    %or
    	(   
    	not(presenta_sintomas(Sintomas)),
    	%and
    	transcurridas_48_horas(true),
    	%and
    	se_realiza_pa(Realiza_2,Realiza_2),
        %and
        not(resultado_positivo(Resultado_pa_2)),
        %and
    	transcurridas_48_horas(true),
    	%and
    	se_realiza_pa(Realiza_3,Realiza_3),
        %and
        not(resultado_positivo(Resultado_pa_3))
    	)
    ).
%----------------------------------------------------------------------------------------------------------------
pa_positiva(Sintomas,Realiza_pa_1, Realiza_pa_2, Realiza_pa_3, Resultado_pa_1, Resultado_pa_2, Resultado_pa_3) :-
    not(pa_negativa(Sintomas, Realiza_pa_1, Realiza_pa_2, Realiza_pa_3, Resultado_pa_1, Resultado_pa_2, Resultado_pa_3)).
%----------------------------------------------------------------------------------------------------------------
la_prueba_es_valida(Fuente_valida, Tipo_valido, Correctitud) :-
    fuente_de_prueba_valida(Fuente_valida),    
    tipo_de_prueba_valida(Tipo_valido),
    prueba_realizada_correctamente(Correctitud).
%----------------------------------------------------------------------------------------------------------------
se_encuentra_contagiado(Realiza_prueba, Resultado_prueba, Validez_prueba) :-
    pcr_positiva(Realiza_prueba, Resultado_prueba),    
    pa_positiva(true, Realiza_prueba, Realiza_prueba, Realiza_prueba, Resultado_prueba, Resultado_prueba, Resultado_prueba),
    la_prueba_es_valida(Validez_prueba, Validez_prueba, Validez_prueba).
%----------------------------------------------------------------------------------------------------------------
no_se_encuentra_contagiado(Realiza_prueba, Resultado_prueba, Validez_prueba) :-
    pcr_negativa(Realiza_prueba, Resultado_prueba),    
    pa_negativa(true, Realiza_prueba, Realiza_prueba, Realiza_prueba, Resultado_prueba, Resultado_prueba, Resultado_prueba),
    la_prueba_es_valida(Validez_prueba, Validez_prueba, Validez_prueba).
%----------------------------------------------------------------------------------------------------------------
es_asintomatico(Contagiado, Sintomas) :-
    se_encuentra_contagiado(Contagiado,Contagiado,Contagiado),
    not(presenta_sintomas(Sintomas)).
%----------------------------------------------------------------------------------------------------------------
es_sintomatico(Contagiado, Sintomas) :-
    se_encuentra_contagiado(Contagiado,Contagiado,Contagiado),
    presenta_sintomas(Sintomas).
%----------------------------------------------------------------------------------------------------------------
no_se_encuentra_contagiado_pero_presenta_sintomas(Contagiado, Sintomas) :-
    no_se_encuentra_contagiado(Contagiado,Contagiado,Contagiado),
    presenta_sintomas(Sintomas).    
%----------------------------------------------------------------------------------------------------------------
debe_utilizar_una_prueba_anticuerpos(Contagiado, Anterior_infeccion):-
    no_se_encuentra_contagiado(Contagiado,Contagiado,Contagiado),
    infeccion_anterior(Anterior_infeccion).
%----------------------------------------------------------------------------------------------------------------
prueba_anticuerpos_positiva(Realizo_anticuerpos, Resultado_anticuerpos) :-
    se_realizo_anticuerpos(Realizo_anticuerpos),
    resultado_positivo(Resultado_anticuerpos).
%----------------------------------------------------------------------------------------------------------------
sigue_el_protocolo_para_contagiados(Aislamiento, Informar, Revisar_sintomas, Tratamiento) :-
    cumple_con_el_aislamiento(Aislamiento),
	informar_a_la_burbuja_social( Informar),
	revisar_constantemente_los_sintomas(Revisar_sintomas),
	seguir_el_tratamiento(Tratamiento).
%----------------------------------------------------------------------------------------------------------------
sigue_el_protocolo_para_no_contagiados() :-
    revisar_otras_enfermedades(true),
	tomar_medidas_preventivas(true).
%----------------------------------------------------------------------------------------------------------------
% diagnostico:
% Recibe: Una Persona y un "Resultado".
% Devuelve: Un Resultado (positivo o negativo) según la persona forme parte del árbol de contagios o no.
diagnostico(Persona, positivo) :-
    infects(Persona, _);
    infects(_, Persona).

diagnostico(Persona, negativo) :-
    + infects(Persona, _),
    + infects(_, Persona).
%----------------------------------------------------------------------------------------------------------------
% Reglas para encontrar la persona que contagió a otra, utilizando listas de manera recursiva
spread_disease(enfermo, contagiado) :- 
    infects([enfermo, contagiado]).
spread_disease(enfermo, contagiado) :- 
    infects([enfermo, otro_contagiado]), 
    spread_disease(otro_contagiado, contagiado).
%----------------------------------------------------------------------------------------------------------------
