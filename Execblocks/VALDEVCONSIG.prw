#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALDEVCONSIG Autor�DANILO C S PALA     � Data �  20111229   ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA O VALOR DO ITEM DA NOTA FISCAL A SER CONTABILIZADO ���
���          � NA DEVOLUCAO DE CONSIGACAO   							  ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALDEVCONSIG()
Local nValor  := 0
Local aArea := GetArea()
Local cTES := ""
Local nTotal := 0           
Local cAlmox := 0

cTES := SD1->D1_TES
nTotal := SD1->D1_CUSTO
cAlmox := SD1->D1_LOCAL


//VERIFICAR O TES
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+cTES)
IF EMPTY(SF4->F4_CTBESP) .and. SD1->D1_TIPO="B"
	nValor := nTotal
ELSE
	nValor := 0
ENDIF //TES

RestArea(aArea)
RETURN(nValor)