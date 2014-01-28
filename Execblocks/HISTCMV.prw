//Alterado por Danilo Pala em 20130828: TCPO INFRA
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �HISTCMV   �Autor  �DANILO C S PALA     � Data �  20110505   ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA O HISTORICO DO ITEM DA NOTA FISCAL A SER CONTABILIZADO ���
���          � DO CMV                   								  ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function HISTCMV(cTpNota) //cTpNota:E=Entrada ou S=Saida
Local cConta := ""
Local aArea := GetArea()
Local cTES := ""
Local cProduto := ""
Local cNf := ""    
Local cCanc := ""
Local cValor :=""


if cTpNota =="S" //Saida
	cTES := SD2->D2_TES
	cProduto := SD2->D2_COD
	cNf := ALLTRIM(SD2->D2_DOC)
	cCanc := ""
else //Entrada
	cTES := SD1->D1_TES
	cProduto := SD1->D1_COD
	cNf := ALLTRIM(SD1->D1_DOC)
	cCanc := "CANC."
endif

//VERIFICAR O TES
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+cTES)
IF EMPTY(SF4->F4_CTBESP) //NAO CONTABILIZA PODER3
	DbSelectArea("SB1")
	DbSetOrder(1)
	IF DbSeek(xFilial("SB1")+cProduto)
		If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
			cConta := "LIVRO PINI"
		Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
			cConta := "LIVRO CONSIG"
		Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
			cConta := "TCPO"
		Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC//CD TCPO
			cConta := "TCPO"
		Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				cConta := "CD"
		Elseif SB1->B1_TIPO =="DV" //DVD PINI
			cConta := "DVD"
		Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC//MODELATTO
			cConta := "MODELATTO"
		Elseif SB1->B1_TIPO =="IE" //ESTUDO DE MERCADO
			cConta := "ESTUDO MERC"
		Elseif SB1->B1_TIPO =="PE" //PESQUISA EXPRESSA
			cConta := "PESQ EXPRESSA"
		Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//TCPO INFRA
			cConta := "TCPO INFRA"
		Else
			cConta := ""
		EndIf
	ELSE
		cConta := ""
	ENDIF //DBSEEK SB1
ELSEIF SF4->F4_CTBESP =="DC" //DEVOLUCAO DE CONSIGNACAO
	cValor := ALLTRIM(SA1->A1_NREDUZ)+"/NF "+ cNf +"/DEV CONSIG"	
ELSE
	cConta := ""
ENDIF //TES

If empty(cValor)
	cValor := "CMV/"+ cCanc +"NF "+ cNf +"/"+ cConta
EndIf

RestArea(aArea)
RETURN(cValor)