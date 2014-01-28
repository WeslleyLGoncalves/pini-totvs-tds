#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA410I   �Autor  �Microsiga           � Data �  04/15/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para gravacao da data do lote de fatura_   ���
���          �mento                                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Mta410i()

Local aArea    := GetArea()
Local aAreaSC6 := GetArea()

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xFilial("SC5")+SC6->C6_NUM)

DbSelectArea("SC6")
If !Eof()
	RecLock("SC6",.F.)
	SC6->C6_DATA    := SC5->C5_DATA
	SC6->C6_LOTEFAT := SC5->C5_LOTEFAT
	MsUnLock()
EndIf

RestArea(aArea)

Return