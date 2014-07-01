/*
Danilo C S Pala 20110504: Alterado a pedido do Jose Martins
//Alterado por Danilo Pala em 20130828: TCPO INFRA
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CONTAPODER3�Autor  �DANILO C S PALA     � Data �  20101109  ���
�������������������������������������������������������������������������͹��
���Desc.     � RETORNA A CONTA CONTABIL DO PRODUTO 						  ���
���          � DO PODER DE TERCEIROS    								  ���
�������������������������������������������������������������������������͹��
���Uso       � PINI                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function CONTAPODER3(cTpNota, cTipo) //cTpNota:E=Entrada ou S=Saida ,cTipo:C=Credito ou D=Debito
Local cConta := ""
Local aArea := GetArea()
Local cTES := ""
Local cProduto := ""


if cTpNota =="S" //Saida
	cTES := SD2->D2_TES
	cProduto := SD2->D2_COD
else //Entrada
	cTES := SD1->D1_TES
	cProduto := SD1->D1_COD
endif

//VERIFICAR O TES
DbSelectArea("SF4")
DbSetOrder(1)
DbSeek(xFilial("SF4")+cTES)
IF !EMPTY(SF4->F4_CTBESP) .and. SF4->F4_CTBESP<>"DC" 
	DbSelectArea("SB1")
	DbSetOrder(1)
	IF DbSeek(xFilial("SB1")+cProduto)
		IF SF4->F4_CTBESP =="XN" //EXPOSICAO NFS
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "D"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "D"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "D"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "D"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "D"
					cConta := "11030107005"
				else   
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO //DVD PINI
				if cTipo == "D"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC//MODELATTO
				if cTipo == "D"
					cConta := "11030107009"
				else   
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Elseif SB1->B1_TIPO =="RE" .AND. SUBSTR(SB1->B1_COD,1,3) == "015"
				if cTipo == "D"
					cConta := "11030107010"
				else   
					cConta := "11030109001"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="XT" .OR. SF4->F4_CTBESP =="XS"  //EXPOSICAO TRANSPORTE OU EXPOSICAO SIMBOLICA
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "C"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "C"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "C"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "C"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "C"
					cConta := "11030107005"
				else
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO//DVD PINI
				if cTipo == "C"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "C"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="CN" //CONSIGNACAO NFS
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "D"
					cConta := "11030107001"
				else	
					cConta := "11030102001"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "D"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "D"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "D"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="CT" .OR. SF4->F4_CTBESP =="CS" //CONSIGNACAO TRANSPORTE OU CONSIGNACAO SIMBOLICA
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "C"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "C"
					cConta := "11030107007"
				else    
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "C"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "C"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf   
		ELSEIF SF4->F4_CTBESP =="EN" //EXPOSICAO NFS
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "D"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "D"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "D"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "D"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "D"
					cConta := "11030107005"
				else   
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO//DVD PINI
				if cTipo == "D"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC//MODELATTO
				if cTipo == "D"
					cConta := "11030107009"
				else   
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="ET" .OR. SF4->F4_CTBESP =="ES"  //EXPOSICAO TRANSPORTE OU EXPOSICAO SIMBOLICA
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "C"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "C"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "C"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "C"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "C"
					cConta := "11030107005"
				else
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO//DVD PINI
				if cTipo == "C"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "C"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSE 
			cConta := ""
		ENDIF
	ELSE          
		cConta := ""
	ENDIF
EndIf 

//Outros comandos

//
/*
If SF4->F4_CODIGO = "662" .Or. SF4->F4_CODIGO = "FE6"


	DbSelectArea("SB1")
	DbSetOrder(1)
	IF DbSeek(xFilial("SB1")+cProduto)
		//IF SF4->F4_CTBESP =="XN" //EXPOSICAO NFS
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "D"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "D"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "D"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "D"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "D"
					cConta := "11030107005"
				else   
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO //DVD PINI
				if cTipo == "D"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC//MODELATTO
				if cTipo == "D"
					cConta := "11030107009"
				else   
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="XT" .OR. SF4->F4_CTBESP =="XS"  //EXPOSICAO TRANSPORTE OU EXPOSICAO SIMBOLICA
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "C"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "C"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "C"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "C"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "C"
					cConta := "11030107005"
				else
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO//DVD PINI
				if cTipo == "C"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "C"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="CN" //CONSIGNACAO NFS
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "D"
					cConta := "11030107001"
				else	
					cConta := "11030102001"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "D"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "D"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "D"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="CT" .OR. SF4->F4_CTBESP =="CS" //CONSIGNACAO TRANSPORTE OU CONSIGNACAO SIMBOLICA
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "C"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "C"
					cConta := "11030107007"
				else    
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "C"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "C"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf   
		ELSEIF SF4->F4_CTBESP =="EN" //EXPOSICAO NFS
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "D"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "D"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "D"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "D"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "D"
					cConta := "11030107005"
				else   
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO//DVD PINI
				if cTipo == "D"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC//MODELATTO
				if cTipo == "D"
					cConta := "11030107009"
				else   
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSEIF SF4->F4_CTBESP =="ET" .OR. SF4->F4_CTBESP =="ES"  //EXPOSICAO TRANSPORTE OU EXPOSICAO SIMBOLICA
			If SB1->B1_TIPO =="LI" .AND. !("TCPO" $ B1_DESC) //LIVRO PINI
				if cTipo == "C"
					cConta := "11030107001"
				else
					cConta := "11030102001"
				endif
			Elseif SB1->B1_TIPO =="LC" //LIVROS CONSIGNADO
				if cTipo == "C"
					cConta := "11030107002"
				else
					cConta := "11030102002"
				endif
			Elseif (SB1->B1_TIPO =="TC" .OR. SB1->B1_TIPO =="LI") .AND. "TCPO" $ B1_DESC //LIVRO TCPO
				if cTipo == "C"
					cConta := "11030107007"
				else
					cConta := "11030106001"
				endif                      
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD TCPO
				if cTipo == "C"
					cConta := "11030107008"
				else
					cConta := "11030106001"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. !("TCPO" $ B1_DESC) .AND. !("MODELAT" $ B1_DESC) .AND. !("INFRA" $ B1_DESC)//CD PINI
				if cTipo == "C"
					cConta := "11030107005"
				else
					cConta := "11030104001"
				endif
			Elseif SB1->B1_TIPO =="DV" .OR. SB1->B1_TIPO =="DC" //CD CONSIGNADO//DVD PINI
				if cTipo == "C"
					cConta := "11030107006"
				else
					cConta := "11030104002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "MODELAT" $ B1_DESC //MODELATTO 20110504
				if cTipo == "C"
					cConta := "11030107009"   
				else
					cConta := "11030106002"
				endif
			Elseif SB1->B1_TIPO =="CD" .AND. "TCPO" $ B1_DESC .AND. "INFRA" $ B1_DESC//INFRA
				if cTipo == "D"
					cConta := "11030107011"
				else   
					cConta := "11030106003"
				endif
			Else
				cConta := ""
			EndIf
		ELSE 
			cConta := ""
		ENDIF
	//Endif
Endif


*/
RestArea(aArea)
RETURN(cConta)