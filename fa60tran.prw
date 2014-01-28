#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA60TRAN  �Autor  �Marcos Farineli     � Data �  04/05/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Pergunta se deseja deixar o titulo em condicao de emitir   ���
���          � um novo boleto na transferencia para carteira              ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function FA60TRAN()

Local aArea := GetArea()
Local cMsg
cMsg := "O Titulo "+SE1->E1_PREFIXO+SE1->E1_NUM+" foi transferido para Carteira e tinha boleto emitido."+CHR(10)+CHR(13)
cMsg += "Deseja permitir que seja emitido um novo boleto para este titulo no futuro?"

If SE1->E1_BOLEM == "S" .and. Empty(SE1->E1_PORTADO) .and. SE1->E1_SITUACA == "0"
	If MsgYesNo(OemToAnsi(cMsg),OemToAnsi("Boleto Emitido"))
    	DbSelectArea("SE1")
		Reclock("SE1",.F.)
		SE1->E1_BOLEM := ""
		MsUnlock()
		cMsg := "Um novo boleto podera ser emitido para este titulo"
		MsgAlert(OemToAnsi(cMsg),OemToAnsi("Operacao Efetuada"))
	EndIf
EndIf

RestArea(aArea)

Return