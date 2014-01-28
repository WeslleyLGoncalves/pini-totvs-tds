#include "rwmake.ch"
#include "topconn.ch"
#include "tbiconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VenctoPiniPedido�Autor �Danilo C S Pala� Data � 20110704    ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VenctoPiniPedido(cNumero, cParcela)
Private cQuery 		:= ""
Private dVencto := stod("")

cQuery := "select c.numpedido, to_char(c.vencimento,'yyyyMMdd') as vencto, c.valor from pinipedido p, pinicontasreceber c where p.status='F' and c.codusuario =p.codusuario and c.codempresa =p.codempresa and c.numpedido = p.numpedido and p.numpedidopini ='"+ cNumero +"' and  c.parcela='"+ cParcela +"' and p.codempresa='"+ SM0->M0_CODIGO +"'"
DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PINICR", .T., .F. )
DbSelectArea("PINICR")
dbGotop()
If !EOF()
	dvencto :=	STOD(PINICR->VENCTO)
Else
	dVencto := stod("")
EndIf   
DBCloseArea()

Return dVencto