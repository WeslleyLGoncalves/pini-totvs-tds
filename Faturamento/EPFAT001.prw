#INCLUDE "rwmake.ch"
#include "Protheus.ch"
#INCLUDE "ap5mail.ch"
#INCLUDE "TbiConn.ch"
#INCLUDE "TopConn.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EPFAT001  � Autor � Rodolfo Vacari     � Data �  21/06/13   ���
�������������������������������������������������������������������������͹��
���Descricao � LIBERA��O DO PEDIDO DE VENDA, EM SEGUIDA, EXECUTA A ROTINA ���
���          � DE FATURAMENTO                                             ���
�������������������������������������������������������������������������͹��
���Uso       � ED. Pini                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/   

User Function EPFAT001

Local _cQuery := ""

_cQuery := "SELECT C9_FILIAL, C9_PEDIDO, C9_ITEM," 
_cQuery += " C9_PRODUTO, C9_BLEST, C9_BLCRED, C9_DATALIB" 
_cQuery += " FROM "+RetSqlName("SC9")+ " WHERE D_E_L_E_T_ = ' ' AND C9_DATALIB BETWEEN '"+DTOS(dDataBase-1)+"' AND '"+DTOS(dDataBase)+"' AND" 
_cQuery += " (C9_BLEST NOT IN (' ','10') OR C9_BLCRED NOT IN (' ','10'))" 
_cQuery += " ORDER BY C9_PEDIDO, C9_ITEM, C9_DATALIB"
TCQUERY _cQuery NEW ALIAS "QRY"
        
dbSelectArea("QRY")
dbGoTop()
While !QRY->(EOF())
		dbSelectArea("SC9")
		dbSetOrder(1)
		IF DbSeek(xFilial("SC9")+QRY->(C9_PEDIDO+C9_ITEM))
			RecLock("SC9",.F.)
				SC9->C9_BLEST := "  "
				SC9->C9_BLCRED:= "  "
			MsUnLock()	
		EndIf	
QRY->(dbSkip())
EndDo

QRY->(dbCloseArea())
                                       
MATA460()

Return
