#include "rwmake.ch"
#INCLUDE "TOPCONN.CH"

/*/  Criado por Danilo C S Pala em 20090630: ANDRE
��������������������������������������������������������������������������
��������������������������������������������������������������������������
����������������������������������������������������������������������Ŀ��
��� 16/03/02 � HISTORICO DA TRANSFERENCIA LANPAD 560 E 561             ���
����������������������������������������������������������������������Ĵ��
�����������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������
��������������������������������������������������������������������������
/*/
User Function HISTRF(cCampo, cTipo)
Local mHIST:=SPACE(40)
Local aArea := GetArea()
Local cquery := space(500)

Local aArea := GetArea()
IF cCampo=="C"
	if cTipo =="S" //saida: selecionar saida
		//cquery := "select trim(a6_numcon) ||'/'|| trim(a6_nreduz) as histbco, a6_conta as conta from "+ RetSqlName("SE5") +" se5, "+ RetSqlName("SA6") +" sa6 where e5_filial='"+ XFILIAL("SE5") +"' and a6_filial='"+ XFILIAL("SA6") +"' and a6_cod=e5_banco and a6_agencia=e5_agencia and a6_numcon=e5_conta and e5_data='"+ DTOS(SE5->E5_DATA) +"' and e5_tipo='"+ SE5->E5_TIPO +"' and e5_naturez='"+ SE5->E5_NATUREZ +"' and e5_documen='"+ SE5->E5_NUMCHEQ +"' and e5_recpag='R' and se5.d_e_l_e_t_<>'*' and sa6.d_e_l_e_t_<>'*'"
		//MHIST :="TRANSF P/"
		cquery := "select trim(a6_numcon) ||' '|| trim(a6_nreduz) as histbco, a6_conta as conta, e5_recpag"
		cquery += " from "+ RetSqlName("SE5") +" se5, "+ RetSqlName("SA6") +" sa6"
		cquery += " where e5_filial='"+ XFILIAL("SE5") +"' and a6_filial='"+ XFILIAL("SA6") +"' and a6_cod=e5_banco and a6_agencia=e5_agencia and a6_numcon=e5_conta and e5_data='"+ DTOS(SE5->E5_DATA) +"' and e5_proctra='"+ SE5->E5_PROCTRA +"' and e5_recpag='P' and se5.d_e_l_e_t_<>'*' and sa6.d_e_l_e_t_<>'*'"
	else //E =entrada: selecionar entrada
		//cquery := "select trim(a6_numcon) ||'/'|| trim(a6_nreduz) as histbco, a6_conta as conta from "+ RetSqlName("SE5") +" se5, "+ RetSqlName("SA6") +" sa6 where e5_filial='"+ XFILIAL("SE5") +"' and a6_filial='"+ XFILIAL("SA6") +"' and a6_cod=e5_banco and a6_agencia=e5_agencia and a6_numcon=e5_conta and e5_data='"+ DTOS(SE5->E5_DATA) +"' and e5_tipo='"+ SE5->E5_TIPO +"' and e5_naturez='"+ SE5->E5_NATUREZ +"' and e5_numcheq='"+ SE5->E5_DOCUMEN +"' and e5_recpag='P' and se5.d_e_l_e_t_<>'*' and sa6.d_e_l_e_t_<>'*'"
		//MHIST :="TRANSF RECEB/"
		cquery := "select trim(a6_numcon) ||' '|| trim(a6_nreduz) as histbco, a6_conta as conta, e5_recpag"
		cquery += " from "+ RetSqlName("SE5") +" se5, "+ RetSqlName("SA6") +" sa6"
		cquery += " where e5_filial='"+ XFILIAL("SE5") +"' and a6_filial='"+ XFILIAL("SA6") +"' and a6_cod=e5_banco and a6_agencia=e5_agencia and a6_numcon=e5_conta and e5_data='"+ DTOS(SE5->E5_DATA) +"' and e5_proctra='"+ SE5->E5_PROCTRA +"' and e5_recpag='R' and se5.d_e_l_e_t_<>'*' and sa6.d_e_l_e_t_<>'*'"
	endif
ELSE // HISTORICO
	cquery := "select trim(a6_numcon) ||' '|| trim(a6_nreduz) as histbco, a6_conta as conta, e5_recpag"
	cquery += " from "+ RetSqlName("SE5") +" se5, "+ RetSqlName("SA6") +" sa6"
	cquery += " where e5_filial='"+ XFILIAL("SE5") +"' and a6_filial='"+ XFILIAL("SA6") +"' and a6_cod=e5_banco and a6_agencia=e5_agencia and a6_numcon=e5_conta and e5_data='"+ DTOS(SE5->E5_DATA) +"' and e5_proctra='"+ SE5->E5_PROCTRA +"' order by e5_recpag"
ENDIF

TCQUERY cQuery NEW ALIAS "HISTRF"
DbSelectArea("HISTRF")
DBGOTOP()
if cCampo ="H" //historico
	MHIST := "TRF "+ ALLTRIM(HISTRF->HISTBCO)
	DbSkip()
	MHIST += " P/ "+ ALLTRIM(HISTRF->HISTBCO)
else //conta contabil
	MHIST := TRIM(HISTRF->CONTA)
endif

DBCLOSEAREA("HISTRF")

RestArea(aArea)

Return(TRIM(MHIST))