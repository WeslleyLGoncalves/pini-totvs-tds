#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA191GRV  �Autor  �Danilo C S Pala     � Data �  20120925   ���
�������������������������������������������������������������������������͹��
���Desc.     �Grava dados de cheques recebidos                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//O ponto de entrada FA191GRV � chamado ap�s a grava��o (inclus�o, altera��o e exclus�o) de Cheques Recebidos. Programa Fonte FINA191.PRW
User Function FA191GRV()          
local _lOk := .T. 
local aCab := {} 
local aItens := {}                       
local nValor := SEF->EF_VALOR             
private lMsErroAuto := .F. 

If INCLUI                 

	aCab   := {     {"DDATALANC"     ,dDataBase     ,NIL}     ,; 
              {"CLOTE"      ,"008850"     ,NIL}     ,; 
              {"CSUBLOTE"      ,"001"           ,NIL}     ,; 
              {"CDOC"      , strzero(seconds(),6)     ,NIL}     ,; 
    	      {"CPADRAO"     ,""               ,NIL}     ,; 
              {"NTOTINF"     ,0               ,NIL}     ,; 
              {"NTOTINFLOT"     ,0               ,NIL}} 

	aAdd(aItens,{     {"CT2_FILIAL"      ,"01"               , NIL},; 
                {"CT2_LINHA"      ,"001"             , NIL},; 
                {"CT2_MOEDLC"      ,"01"             , NIL},; 
                {"CT2_DC"        ,"3"                  , NIL},; 
                {"CT2_DEBITO"      ,"11020101012"     , NIL},; 
                {"CT2_CREDIT"      ,"21080202002"     , NIL},; 
                {"CT2_VALOR"      ,nValor           , NIL},; 
                {"CT2_ORIGEM"      ,SUBS(CUSUARIO,7,15)+"-FA191GRV" , NIL},; 
                {"CT2_HIST"        ,"RECEB CH "+ALLTRIM(SEF->EF_NUM) + "-TIT "+ALLTRIM(SEF->EF_TITULO), NIL}}) 

	MSExecAuto( {|X,Y,Z| CTBA102(X,Y,Z)} ,aCab ,aItens, 3) 
	If lMsErroAuto
		MOSTRAERRO()
	EndIf
EndIf

Return NIL