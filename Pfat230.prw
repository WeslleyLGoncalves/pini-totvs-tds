#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT230   �Autor: Gilberto A. de Oliveira� Data:   16/01/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Gera SC5/SC6, Seleciona registros para impressao de boleto � ��
���           Alterado por Mauricio / Gilberto para ao inves de Gerar C5 � ��
���           C6 e E1 Gerar ZZE para que na Hora da Baixa gere C5,C6 e E1� ��
���           Deletando o Segundo Registro do ZZE  17/05/2001            � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento - RENOVACAO AUTOMATICA !!!           � ��
���                                                                      � ��
���     * PFAT230                                                        � ��
���         PFAT230A                                                     � ��
���             A230DET                                                  � ��
���                 VCB01R                                               � ��
���                 VCB02R                                               � ��
���                 VCB03R                                               � ��
���                 VCB04R                                               � ��
���                 VCB05R                                               � ��
������������������������������������������������������������������������Ĵ ��
���OBSERV.  : UTILIZA-SE DOS MESMOS CRITERIOS DE SELECAO DO PFAT057      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat230()

SetPrvt("CPERG,CTITULO,TITULO,MCONTA,MCONTA1,_LABORTO")
SetPrvt("_ATITULOS,MPRODUTO,MNOMECLI,_CPEDIDO,_AARRAY_DE_PEDIDOS,_CMSGABORTO")
SetPrvt("_NITENS,IND_A,_NPRECO_A_VISTA,_NPRECO_1_DE_3,_LOK,_CMSG1")
SetPrvt("_NVLRUNICA,_N3VEZES,_NPERACAO1,_NPERACAO2,_NEDINI,_NEDFIN")
SetPrvt("_DDTINI,_CPARCELA,_DVENCTO,_NVALOR,_CTIPOOP,_CCLIENTE")
SetPrvt("_CLOJA,_CNUMTITULO,_CNUMNOVOPED,_CMSG2,_CARQPATH,_CARQNOME")
SetPrvt("_CMSG3,CARQ,CKEY,CFILTRO,CINDEX,_SALIAS")
SetPrvt("AREGS,I,J,MTITULO,MDTVENC,MEND")
SetPrvt("MBAIRRO,MMUN,MEST,MCEP,MFAX,MEMAIL")
SetPrvt("MDEST,MCGC,MFONE,MCODATIV,MFONE1,")
//����������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                       �
//� mv_par01             //Nome do Arquivo                "C",6                �
//� mv_par02             //Regi�o Inicial                 "C",3                �
//� mv_par03             //Regi�o Final                   "C",3                �
//� mv_par04             //Vendedor Inicial               "C",6                �
//� mv_par05             //Vendedor Final                 "C",6                �
//� mv_par06             //Tipo                           "N",1                �
//� mv_par07             //Cep Inicial                    "C",8                �
//� mv_par08             //Cep Final                      "C",8                �
//� mv_par09             //Do produto                     "C",1                �
//� mv_par10             //At� produto                    "C",1                �
//� mv_par11             //Da  Situa��o
//� mv_par12             //At� Situa��o
//� mv_par13             //Da Atividade
//� mv_par14             //At� Atividade
//� mv_par15             //Desconto
//������������������������������������������������������������������������������
//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������
cPerg:= "FAT230"
//_ValidPerg()
If !Pergunte(cPerg,.T.)
	Return
Endif

//�������������������������������������������������������������������������Ŀ
//� Define arquivo de trabalho e cabecalhos                                 �
//���������������������������������������������������������������������������
If MV_PAR06 == 1
	cTitulo := " **** RENOVA��ES **** "
	Titulo  := PadC("RENOVA��ES ",74)
ElseIf MV_PAR06==2
	cTitulo := " **** RECUPERA��O **** "
	Titulo  := PadC("RECUPERA��O ",74)
EndIf

If SM0->M0_CODIGO $ "01/02"
	OpenRenov()
Else
	MsgAlert("ROTINA VALIDA APENAS PARA EMPRESA 01 E 02 ...")
	Return
EndIf

DbSelectArea("ARQREN")
lEnd := .f.
Processa( {|lEnd|RptDetail(@lEnd)},"Aguarde","Procesando...",.t.)// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==>    Processa( {||Execute(RptDetail)})

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RPTDETAIL �Autor  �Microsiga           � Data �  04/11/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento                                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RptDetail()

mConta    := 0
mConta1   := 0
mConta    := 1
_lAborto  := .F.
_aTitulos := {}

DbSelectArea("ARQREN")
DbGoTop()

ProcRegua(Reccount())

DbSelectArea("ARQREN")
While !EOF() .and. !lEnd

	mProduto := ""
	mNomecli := ""
	
	IncProc("Lendo registro "+Padr(Str(Recno(),7),7))
	
	mConta++
	//�������������������������������������Ŀ
	//�   APENAS PAGAS                      �
	//���������������������������������������
	If SubStr(AllTrim(ARQREN->CF),2,2)=="99"
		DbSelectArea("ARQREN")
		DbSkip()
		Loop
	EndIf
	
	//������������������������������������Ŀ
	//�  APURACAO DOS ITENS DO PEDIDO      �
	//��������������������������������������
	SA1->( DbSeek(xFilial("SA1")+ARQREN->CODCLI) )
	
	_cPedido           := ARQREN->NUMPED
	_aArray_de_Pedidos := {}
	
	DbSelectArea("ARQREN")
	
	While !EOF() .And.  ARQREN->NUMPED == _cPedido .and. !lEnd
		mProduto := ""
		DbSelectArea("SC5")
		DbSetOrder(1)
		DbSeek( xFilial("SC5")+ARQREN->NUMPED)
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		DbSeek( xFilial("SC6")+ARQREN->NUMPED+ARQREN->ITEM)
		mProduto := SC6->C6_PRODUTO
		If Subs(SC6->C6_PRODUTO,5,3)=='004'
			mProduto := Subs(SC6->C6_PRODUTO,1,4)+'002'
		Endif
		If Subs(SC6->C6_PRODUTO,5,3)=='005'
			mProduto := Subs(SC6->C6_PRODUTO,1,4)+'003'
		Endif
		If SC6->(!FOUND()) .or. SC5->(!FOUND())
			_cMsgAborto := "ATENCAO : Nao foi possivel encontrar o pedido "
			_cMsgAborto := _cMsgAborto+Left(_cPedido,6)+" "
			_cMsgAborto := _cMsgAborto+"no arquivo de pedidos de vendas. Verifique..."
			_lAborto    := .T.
			Exit
		EndIf
		AADD(_aArray_de_Pedido, ARQREN->NUMPED+ARQREN->ITEM)
		ARQREN->( DbSkip() )
	End
	
	//������������������������������������Ŀ
	//�  LEITURA DO ARRAY                  �
	//��������������������������������������
	If Len(_aArray_de_Pedidos) > 0 .and. !_lAborto
		//���������������������������������������������������������Ŀ
		//� O Ind_A abaixo devera controlar quando trata-se da      �
		//� parcela �nica e quando trata-se da 1� parcela da condi- �
		//� cao de 3 vezes...                                       �
		//�����������������������������������������������������������
		For _nItens := 1 to Len(_aArray_de_Pedidos)
			For Ind_A := 1 to 2
				DbSelectArea("SC6")
				DbSetOrder(1)
				DbSeek( xFilial("SC6")+_aArray_de_Pedidos[_nItens])
				_nPreco_a_Vista := 0
				_nPreco_1_de_3  := 0
				//����������������������������������������������������������������Ŀ
				//�Gera Registros para geracao dos boletos de renovacao automatica.�
				//������������������������������������������������������������������
				GeraRenovacao()
			Next Ind_A
		Next _nItens
	EndIf
	//��������������������������������������������������������������Ŀ
	//� Controle de Rotina Abortada por Falta de Informacoes...      �
	//����������������������������������������������������������������
	If _lAborto
		MsgInfo(_cMsgAborto,"Pedido nao encontrado")
	Endif
	DbSelectArea("ARQREN")
	//DbSkip()
End

If !_lAborto
	_lOk := ExecBlock("PFAT230A",.F.,.F., _aTitulos )        // Chamada para impressao dos boletos...
	If !_lOk
		MsgInfo("Rotina abortada !!")
	EndIf
Endif

DbSelectArea("ARQREN")
DbCloseArea()
DbSelectArea("SZJ")
Retindex("SZJ")
DbSelectArea("SA1")
Retindex("SA1")
DbSelectArea("SB1")
Retindex("SB1")
DbSelectArea("SZO")
Retindex("SZO")
DbSelectArea("SZN")
Retindex("SZN")

Return

//****************************************************************
//***                                                          ***
//*** GERA REGISTROS PARA RENOVACAO AUTOMATICA.                ***
//***                                                          ***
//****************************************************************
Static Function GeraRenovacao()
_cMsg1     := ""
_nVlrUnica := 0
_n3Vezes   := 0

// �����������������������������������Ŀ
// �  Posiciona o Cadastro de Produtos �
// �������������������������������������
DbSelectArea("SB1")
DbSetOrder(01)
If !DbSeek(xFilial("SB1")+mProduto)
	_cMsg1 := "ATENCAO : O PRODUTO NAO FOI ENCONTRADO !! VERIFIQUE ..."
EndIf

If Empty(_cMsg1)
	_nPerAcao1      := 1 // (SB1->B1_DESCRA1/100)                     // Percentual de desconto p/ acao 1
	_nPerAcao2      := 1// (SB1->B1_DESCRA2/100)                     // Percentual de desconto p/ acao 2
	_nVlrUnica      := ROUND(SB1->B1_PRV1*(1-MV_PAR15),0)//-(SB1->B1_PRV1*_nPerAcao1)    // Preco a Vista.
	_nPreco_a_Vista := _nPreco_a_Vista + _nVlrUnica   // ?????
	
	IF SB5->( DbSeek( xFilial("SB5")+mProduto ))
		_n3Vezes       := ROUND((SB5->B5_PRV3/3)*(1-MV_PAR15),0)                  // Vlr. Primeira Parcela.
		//_n3Vezes      := _n3Vezes -  (_n3Vezes * _nPerAcao1)
		//_nPreco_1_de_3:= _nPreco_1_de_3 + _n3Vezes      // ?????
		_nPreco_1_de_3:= _n3Vezes      // ?????
	Endif
	
	Do Case
		Case _nVlrUnica == 0
			_cMsg1 := "ATENCAO : Preco a Vista nao cadastrado no Cadastro de Produtos ! Verifique..." + SB1->B1_COD
		Case _n3Vezes == 0 .And. Empty(_cMsg1)
			_cMsg1 := "ATENCAO : Preco a para Condicao de 3 vezes com boleto nao Cadastrado na Tabela de Precos ! Verifique..." + SB1->B1_COD
	EndCase
EndIf

If !Empty( _cMsg1 )
	MsgAlert( OemToAnsi(_cMsg1) )
	_lAborto:= .T.          // Autoriza aborto.
	Return                  // Rotina abortada por falta de precos !!
Endif

//�����������������������������������������������Ŀ
//� Busca data da circulacao da proxima revista.  �
//�������������������������������������������������
_nEdIni := SC6->C6_EDFIN + 1
_nEdFin := _nEdIni + SB1->B1_QTDEEX

//��������������������������������������Ŀ
//� Observa CRONOGRAMA da Revista (SZJ). �
//����������������������������������������
DbSelectArea("SZJ")
DbSeek(SubStr(mProduto,1,4)+STR(_nEdIni,4))  // Busca data inicial da circulacao da revista.

_dDtIni := SZJ->ZJ_DTCIRC
DbSeek(Subs(mProduto,1,4)+STR(_nEdFin,4))    // Busca data final da circulacao da revista.

//�����������������������������������������������������Ŀ
//� Programacao do Titulo a Ser Paga No Valor Total.    �
//�������������������������������������������������������
If Ind_A == 1
	_cParcela := ""
	_dVencto  := dDataBase  + GETMV("MV_DIAVENC")         // Parcela Unica
	//_dVencto:= CTOD("11/06/2001")
	_nValor   := _nPreco_a_Vista
	_cTipoOp  := "18"
Else
	_cParcela := "A"
	_dVencto  :=  dDataBase  + GETMV("MV_DIAVENC")          // Segunda Parcela
	//_dVencto:= CTOD("11/06/2001")
	_nValor   := _nPreco_1_de_3
	_cTipoOp  := "34"
EndIf

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek( xFilial("SC5") + Left(_aArray_de_Pedidos[_nItens],6) )

_cCliente := SC5->C5_CLIENTE
_cLoja    := SC5->C5_LOJACLI

//************************************************************************
//** NOVO BLOCO INCLUIDO PARA MUDAR A MANEIRA COMO SAO FEITAS AS COISAS **
//************************************************************************
_cNumTitulo := GetSX8Num("REA")
ConfirmSX8()
_cNumNovoPed:= GetSX8Num("REN") //GetSX8Num("REN")
ConfirmSx8()

DbSelectArea("ZZE")
RecLock("ZZE",.T.)
ZZE->ZZE_FILIAL  := XFILIAL()
ZZE->ZZE_PREFIX  := "REA"
ZZE->ZZE_NUM     := _cNumTitulo
ZZE->ZZE_PARCEL  := _cParcela
ZZE->ZZE_CLIENT  := _cCliente
ZZE->ZZE_LOJA    := _cLoja
ZZE->ZZE_PEDIDO  := _cNumNovoPed
ZZE->ZZE_VENCTO  := _dVencto
ZZE->ZZE_VALOR   := _nValor
ZZE->ZZE_BANCO   := "341"
ZZE->ZZE_AGENCI  := "0585"
ZZE->ZZE_CTACOR  := "398860"
ZZE->ZZE_NNUM    := ""
ZZE->ZZE_INSTR1  := ""
ZZE->ZZE_INSTR2  := ""
ZZE->ZZE_INSTR3  := ""
ZZE->ZZE_INSTR4  := ""
ZZE->ZZE_ARQREN  := ""
ZZE->ZZE_EMISSA  := ddatabase
ZZE->ZZE_DATA    := ddatabase
ZZE->ZZE_ARQBOL  := ""
ZZE->ZZE_PEDOLD  := Left(_aArray_de_Pedidos[_nItens],6)
ZZE->ZZE_ITEM    := SUBSTR(_aArray_de_Pedidos[_nItens],7,2)
//ZZE->ZZE_CONDPAG := ""
//ZZE->ZZE_VEND1   := ""
//ZZE->ZZE_VEND2   := ""
//ZZE->ZZE_VEND3   := ""
//ZZE->ZZE_VEND4   := ""
//ZZE->ZZE_VEND5   := ""
//ZZE->ZZE_DIVVEN  := SC5->C5_DIVVEN
//ZZE->ZZE_TIPOOP  := _cTipoOp
//ZZE->ZZE_ACOESRA := ""
// Mauricio 17/05/2001 2 Linhas abaixo
MsUnLock()

// Guarda numero dos Titulos Gerados.
AADD( _aTitulos,{ZZE_NUM,ZZE_PREFIX})
// 1� -> RA0101 1 onde :
//      "RA"= Renov. Automatica
//        "01" = Mes da Renovacao
//          "01" = Ano da Renovacao
//             "1" = Numero da Acao, quando 1 indica renovacao, quando 2 indica recuperacao.

//***********************
//** FIM DO NOVO BLOCO **
//***********************

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ARQUIVOTRB� Autor � Gilberto A. Oliveira  � Data � 18/01/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Abre e indexa o arquivo de trabalho cujo nome sera indicado���
���          � em mv_par01.                                               ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function OpenRenov()

If !( Left( Alltrim(MV_PAR01),2 ) $ "RN/RC/RE" )
	_cMsg2 := 'ATENCAO : O arquivo mencionado nos parametros nao parece ser um arquivo '
	_cMsg2 := _cMsg2 + 'valido. Normalmente os arquivos de renovacao tem como prefixo '
	_cMsg2 := _cMsg2 + '"RN", "RC" (recuperacao) ou "RE"/"RA" (arq. de renovacoes do mes).'
	_cMsg2 := _cMsg2 + 'Por medida de seguranca nao sera possivel continuar. Verifique...'
	MsgInfo( OemToAnsi(_cMsg2) )
	Return
EndIf

_cArqPath := GETMV("MV_PATHASS")
_cArqNome := _cArqPath+Alltrim(MV_PAR01)

IF !FILE(_cArqNome+".DBF")
	_cMsg3 := "Atencao: Arquivo "+Upper(Alltrim(MV_PAR01))+".DBF nao encontrado no diretorio "+UPPER(_cArqPath)+" !!!"
	MsgAlert(OemToAnsi(_cMsg3))
ENDIF

DbUseArea(.T.,,_cArqNome,"ARQREN",.T.,.F.)
DbSelectArea("ARQREN")

//��������������������������������������������������������������Ŀ
//� Filtra arquivo de Itens do Pedidos de Vendas.                �
//����������������������������������������������������������������
cArq    := "ARQREN"
cKey    := "NUMPED+ITEM+CODPROD"
cFiltro := 'CEP >= "'+MV_PAR07+'" .AND. CEP <= "'+MV_PAR08+'"'
cFiltro += ' .AND. NOVAREG >="'+MV_PAR02+'" .AND. NOVAREG <="'+MV_PAR03+'"'
cFiltro += ' .AND. NOVOVEND >="'+MV_PAR04+'" .AND. NOVOVEND <="'+MV_PAR05+'"'
cFiltro += ' .AND. CODPROD >="'+MV_PAR09+'" .AND. CODPROD <="'+MV_PAR10+'"'
cFiltro += ' .AND. SITUAC  >="'+MV_PAR11+'" .AND. SITUAC  <="'+MV_PAR12+'"'
cFiltro += ' .AND. CODATIV >="'+MV_PAR13+'" .AND. CODATIV <="'+MV_PAR14+'"'

cIndex := CriaTrab(nil,.f.)
IndRegua(cArq,cIndex,cKey,,cFiltro,"Filtrando ..")

DbGoTop()

Return
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 16/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/03/02 ==> Function _ValidPerg
Static Function _ValidPerg()

_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

AADD(aRegs,{cPerg,"01","Nome do Arquivo    ","mv_ch1","C",8,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Regi�o Inicial     ","mv_ch2","C",3,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Regi�o Final       ","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Vendedor Inicial   ","mv_ch4","C",6,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Vendedor Final     ","mv_ch5","C",6,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Tipo               ","mv_ch6","C",1,0,0,"C","","mv_par06","Renovacao","","","Recuperacao","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"07","Cep Inicial        ","mv_ch7","C",8,0,0,"G","","mv_par07","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"08","Cep Final          ","mv_ch8","C",8,0,0,"G","","mv_par08","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"09","Do produto         ","mv_ch9","C",15,0,0,"G","","mv_par09","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"10","At� produto        ","mv_chA","C",15,0,0,"G","","mv_par10","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"11","Da  Situa��o       ","mv_chB","C",2,0,0,"G","","mv_par11","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"12","At� Situa��o       ","mv_chC","C",2,0,0,"G","","mv_par12","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"13","Da Atividade       ","mv_chD","C",7,0,0,"G","","mv_par13","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"14","At� Atividade      ","mv_chE","C",7,0,0,"G","","mv_par14","","","","","","","","","","","","","","",""   })
AADD(aRegs,{cPerg,"15","Desconto           ","mv_chF","N",10,2,0,"G","","mv_par15","","","","","","","","","","","","","","",""   })

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return

//������������������������������������������������Ŀ
//�   ARQUIVO COM OS DADOS DOS BOLETOS...          �
//��������������������������������������������������
Static Function Grava_Temp()

mTitulo := "  "
DbSelectArea("SB1")
DbSeek(xFilial("SB1")+ARQREN->CODPROD )
mTitulo := iif(Empty(SB1->B1_TITULO), SubStr(SB1->B1_DESC,1,13),SB1->B1_TITULO)

mDtVenc := CTOD("")
DbSelectArea("SZJ")
DbSeek(xFilial("SZJ")+ARQREN->CODREV+Str(ARQREN->EDVENC,4,0))
mDtVenc := SZJ->ZJ_DTCIRC

DbSelectArea("SA1")
If DbSeek(xFilial("SA1")+ARQREN->CODCLI)
	mNomeCli := SA1->A1_NOME
	mEnd     := SA1->A1_END
	mBairro  := SA1->A1_BAIRRO
	mMun     := SA1->A1_MUN
	mEst     := SA1->A1_EST
	mCEP     := SA1->A1_CEP
	mFax     := SA1->A1_FAX
	mEmail   := SA1->A1_EMAIL
	mDest    := SPACE(40)
	mCGC     := SA1->A1_CGC
	mFone    := SA1->A1_TEL
	mCodAtiv := SA1->A1_ATIVIDA
Else
	mNomeCli := SPACE(40)
Endif

If !Empty(mNomeCli)
	If !Empty(ARQREN->CODDEST)
		DbSelectArea("SZN")
		If DbSeek(xFilial("SZN")+mCodCli+mCodDest)
			mDest := SZN->ZN_NOME
		Endif
		
		DbSelectArea("SZO")
		If DbSeek(xFilial("SZO")+mCodCli+mCodDest)
			mEnd    := SZO->ZO_END
			mBairro := SZO->ZO_BAIRRO
			mMun    := SZO->ZO_CIDADE
			mEst    := SZO->ZO_ESTADO
			mCEP    := SZO->ZO_CEP
			mFone1  := SZO->ZO_FONE
			If !Empty(mFone1)
				mFone:=mFone1
			Endif
		Endif
	Endif
Endif

DbSelectArea("PFAT230")

Reclock("PFAT230",.T.)
PFAT230->CODCLI  := MCODCLI
PFAT230->CODDEST := MCODDEST
PFAT230->CF      := AllTrim(ARQREN->CF)
PFAT230->SITUAC  := ARQREN->SITUAC
PFAT230->EDIN    := ARQREN->EDIN
PFAT230->EDVENC  := ARQREN->EDVENC
PFAT230->EDSUSP  := ARQREN->EDSUSP
PFAT230->NOME    := SA1->A1_NOME
PFAT230->DEST    := MDEST
PFAT230->END     := MEND
PFAT230->BAIRRO  := MBAIRRO
PFAT230->MUN     := MMUN
PFAT230->CEP     := MCEP
PFAT230->EST     := MEST
PFAT230->FAX     := MFAX
PFAT230->EMAIL   := MEMAIL
PFAT230->FONE    := MFONE
PFAT230->TITULO  := MTITULO
PFAT230->CGC     := MCGC
PFAT230->NUMPED  := ARQREN->NUMPED
PFAT230->ITEM    := ARQREN->ITEM
PFAT230->VALOR   := ARQREN->VALOR
PFAT230->DTVENC  := MDTVENC
PFAT230->CODVEND := ARQREN->CODVEND
PFAT230->CODPROD := ARQREN->CODPROD
PFAT230->CODATIV := MCODATIV
MsUnLock()

Return