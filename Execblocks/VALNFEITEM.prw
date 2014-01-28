/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALNFEITEM�Autor  �DANILO C S PALA     � Data �  20101203   ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA O VALOR DO ITEM DA NOTA FISCAL DE ENTRADA          ���
���          �                          								  ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALNFEITEM()
Local nValor  := 0
Local aArea := GetArea()
Local cTES := ""
Local nTotal := 0

//VERIFICAR O TES
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+SD1->D1_TES)
IF !EMPTY(SF4->F4_CTBESP) .and. SF4->F4_DUPLIC <>"S" .OR. SD1->D1_TES $ "153/005/136" .OR. SD1->D1_RATEIO="1" .OR. SD1->D1_TIPO=="D" .OR. SD1->D1_TIPO=="B"
	nValor := 0
ELSE                                                                                                     
	nValor := SD1->D1_TOTAL+SD1->D1_VALIPI+(SF1->F1_FRETE*SD1->D1_PESO)
ENDIF //TES

RestArea(aArea)
RETURN(nValor)