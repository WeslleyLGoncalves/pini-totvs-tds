/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALNFCOMPRA �Autor  �DANILO C S PALA     � Data �  20110831 ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA O VALOR DO ITEM DA NOTA FISCAL A SER CONTABILIZADO ���
���          �                         									  ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VALNFCOMPRA(cTipo) //CP= Credito PIS apuracao ou CC= Credito COFINS apuracao
Local n_serie  := 0
Local aArea := GetArea()    

//VERIFICAR O TES
DbSelectArea("SF4")
DbSetOrder(1)
IF DbSeek(xFilial("SF4")+SD1->D1_TES)
	if alltrim(upper(cTipo)) == "CP"    
		IF SF4->F4_PISCRED=='1'
			n_serie := SD1->D1_VALIMP6
		ENDIF
	elseif alltrim(upper(cTipo)) == "CC"
		IF SF4->F4_PISCRED=='1'
			n_serie := SD1->D1_VALIMP5
		ENDIF
	endif
ELSE
	n_serie := 0
ENDIF //TES

RestArea(aArea)
RETURN(n_serie)