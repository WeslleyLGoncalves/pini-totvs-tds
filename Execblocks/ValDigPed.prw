#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValDIGPED �Autor  �Danilo C S Pala    � Data �  20120831    ���
�������������������������������������������������������������������������͹��
���Desc.     �Avisar que houver pedido digitado nos ultimos 30 dias       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ValDigPed()
Private mRet := .T.
Private cQuery := ""

/*cQuery := "SELECT C5_DATA FROM "+ RetSqlName("SC5") +" WHERE C5_FILIAL='"+ XFILIAL("SC5") +"' AND C5_CLIENTE='"+ M->C5_CLIENTE +"' AND C5_DATA>='"+ DTOS(DDATABASE -30) +"' AND D_E_L_E_T_<>'*'"
DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "DIGPED", .T., .F. )
DbSelectArea("DIGPED")
dbGotop()                
If !EOF()
	MsgInfo("Existe(m) pedido(s) digitado(s) para este cliente nos �ltimos 30 dias")
EndIf
DBCloseArea("DIGPED")
  */
Return(MRET)