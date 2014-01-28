/*
//Alterado por Danilo C S Pala em 20110829: Nao contabilizar almox CD (Jose Martins)
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALPODER3 �Autor  �DANILO C S PALA     � Data �  20101109   ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA O VALOR DO ITEM DA NOTA FISCAL A SER CONTABILIZADO ���
���          � DO PODER DE TERCEIROS    								  ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALPODER3(cTpNota) //cTpNota:E=Entrada ou S=Saida
Local nValor  := 0
Local aArea := GetArea()
Local cTES := ""
Local nTotal := 0           
Local cAlmox := 0
Local cSERIE := ""


if cTpNota =="S" //Saida
	cTES := SD2->D2_TES
	nTotal := SD2->D2_CUSTO1
	cAlmox := SD2->D2_LOCAL
	cSERIE := SD2->D2_SERIE
else //Entrada
	cTES := SD1->D1_TES
	nTotal := SD1->D1_CUSTO
	cAlmox := SD1->D1_LOCAL
	cSERIE := SD1->D1_SERIE
endif


//VERIFICAR O TES
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+cTES)
IF !EMPTY(SF4->F4_CTBESP) .and. SF4->F4_DUPLIC <>"S" .AND. Alltrim(cAlmox) <>'CD' .and. Alltrim(cAlmox) <>'02' .and. cSERIE <>'2  ' .and. SF4->F4_CTBESP<>"DC"
	nValor := nTotal
ELSE
	nValor := 0
ENDIF //TES

RestArea(aArea)
RETURN(nValor)