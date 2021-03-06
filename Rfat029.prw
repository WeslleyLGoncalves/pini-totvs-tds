#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/* Alterado Por Danilo C S Pala em 20041118                   
Alterado por Danilo C S Pala em 20041213: 	// NPESOLIQUIDO                                     
// icms: Danilo CS Pala 20051109
//Danilo C S Pala 20060620: DESPESA COM BOLETO
//Danilo C S Pala 20070613: ALMOXARIFADOS DO D2_LOCAL  
//Danilo C S Pala 20100305: ENDBP
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFAT029   �Autor  �Microsiga           � Data �  05/13/02   ���
�������������������������������������������������������������������������͹��
���Desc.     � Nota fiscal de venda de livros                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Rfat029()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

SetPrvt("LI,LIN,CBTXT,CBCONT,NORDEM,ALFA")
SetPrvt("Z,M,TAMANHO,LIMITE,TITULO,CDESC1")
SetPrvt("CDESC2,CDESC3,CNATUREZA,ARETURN,RNF,NOMEPROG")
SetPrvt("CPERG,NLASTKEY,LCONTINUA,WNREL,NTAMNF,CSTRING")
SetPrvt("TREGS,M_MULT,P_ANT,P_ATU,P_CNT,M_SAV20")
SetPrvt("M_SAV7,INICIO,XNFISCAL,XPEDIDO,XSERIE,XTIPOOP")
SetPrvt("XCODPROM,XMENSNFN,NOTA_NUM,NOTA_EMIS,NOTA_CLIE,NOTA_LOJA")
SetPrvt("NOTA_MERC,NOTA_TOTA,NOTA_VEND,NOTA_COND,NOTA_DESPREM,SERNF")
SetPrvt("MPREFIX,NREGATU,NOTA_NATU,NOTA_COFI,NOTA_TESA,NOTA_PEDI")
SetPrvt("MD2CF,CLIE_CGC,CLIE_NOME,CLIE_INSC,CLIE_ENDE,CLIE_BAIR")
SetPrvt("CLIE_MUNI,CLIE_ESTA,CLIE_CEP,CLIE_SUF,CLIE_COBR,CLIE_TRAN")
SetPrvt("CLIE_FONE,CLIE_TIPO,XENDC,XBAIRROC,XCIDADEC,XESTADOC")
SetPrvt("XCEPC,XDESCRNF,XDESCDUPL,XPAGA1,XPAGAD,XQTDEP")
SetPrvt("XCODFAT,XMENSNF1,XMENSNF2,XMENSNF3,XMENSNF4,COL")
SetPrvt("COL2,ITEM_CODI,ITEM_QUAN,ITEM_VUNI,ITEM_TOTA,ITEM_ABAT")
SetPrvt("MCOMPL,ITEM_UNID,ITEM_DESC,")    
SetPrvt("xBASE_ICMS, xVALOR_ICMS,xBSICMRET, xICMS_RET") //20051109
SetPrvt("MSOMABOL, NOTA_ALMOX,mhora")  //20060620
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: nfliv2    �Autor: Solange Nalini         � Data:   28/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Notas Fiscais de livros/md            (impressora        ) � ��
������������������������������������������������������������������������Ĵ ��
���Emite a nota fiscal p/anexar os demais boletos                        � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Lote                                 �
//� mv_par02             // Data                                 �
//����������������������������������������������������������������
li        := 0
LIN       := 0
CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "G"
limite    := 220
titulo    := PADC("Nota Fiscal - Nfiscal",74)
cDesc1    := PADC("Este programa ira emitir a Nota Fiscal da Editora Pini ",74)
cDesc2    := ""
cDesc3    := ""
cNatureza := ""
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
//RNF:='CNE'
nomeprog  := "NFASLI"
cPerg     := "FAT004"
nLastKey  := 0
lContinua := .T.
MHORA := TIME()
wnrel     := "NFLIV2_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
//�����������������������������������������������������������Ŀ
//� Tamanho do Formulario de Nota Fiscal (em Linhas)          �
//�������������������������������������������������������������
nTamNf:=66     // Apenas Informativo
//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas, busca o padrao da Nfiscal           �
//���������������������������������������������������������������������������
Pergunte(cPerg,.T.)               // Pergunta no SX1

cString:="SF2"
//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.)

If nLastKey == 27
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif
//��������������������������������������������������������������Ŀ
//�  Prepara regua de impress�o                                  �
//����������������������������������������������������������������
tregs := LastRec()-Recno()+1

DBSELECTAREA("SC6")
DBSETORDER(4)
DbSeek(xFilial("SC6")+MV_PAR01)

IF !FOUND()
	RETURN
ENDIF

LIN    := PROW()
LI     := 0
INICIO := .T.

WHILE !Eof() .and. SC6->C6_NOTA >= MV_PAR01 .AND. SC6->C6_NOTA <= MV_PAR02
	IF SUBS(SC6->C6_NUM,6,1)=='P'
		DBSKIP()
		LOOP
	ENDIF
	XNFISCAL := SC6->C6_NOTA
	XPEDIDO  := SC6->C6_NUM
	XSERIE   := SC6->C6_SERIE
	WHILE SC6->C6_NOTA == XNFISCAL
		DBSKIP()
		IF SC6->C6_NOTA # XNFISCAL
			DBSKIP(-1)
			EXIT
		ENDIF
	END
	//��������������������������������������������������������������Ŀ
	//�  Inicio do levantamento dos dados da Nota Fiscal             �
	//����������������������������������������������������������������
	XPEDIDO := SC6->C6_NUM
	DBSELECTAREA("SC5")
	DBSETORDER(1)
	DBSEEK(XFILIAL("SC5")+XPEDIDO)
	IF FOUND()
		XTIPOOP  := SC5->C5_TIPOOP
		XCODPROM := SC5->C5_CODPROM
		//*�������������������������������������������������������������������*
		//*                      MENSAGENS NOTA FISCAL                        *
		//*�������������������������������������������������������������������*
		xMENSNFN:=SUBSTR(SC5->C5_MENNOTA,1,45)
	ENDIF
	
	DbSelectArea("SF2")
	DbSetOrder(1)
	DbSeek(xFilial("SF2")+xnfiscal+xserie)
	//*��������������������������������������������������������������������*
	//*                          CABECALHO DA NOTA                         *
	//*��������������������������������������������������������������������*
	NOTA_NUM     := SF2->F2_DOC
	NOTA_EMIS    := SF2->F2_EMISSAO                         && DATA EMISSAO
	NOTA_CLIE    := SF2->F2_CLIENTE                         && CODIGO DO CLIENTE
	NOTA_LOJA    := SF2->F2_LOJA                            && CODIGO DA LOJA
	NOTA_MERC    := SF2->F2_VALMERC                         && VALOR MERCADORIA
	NOTA_TOTA    := SF2->F2_VALBRUT                         && VALOR BRUTO FATURADO
	NOTA_VEND    := SF2->F2_VEND1                           && CODIGO VENDEDOR
	NOTA_COND    := SF2->F2_COND                            && CONDICAO PAGAMENTO
	NOTA_DESPREM := SF2->F2_DESPREM
	SERNF        := SF2->F2_SERIE
	MPREFIX      := SF2->F2_PREFIXO
	//Danilo 20051109
	xBASE_ICMS   := SF2->F2_BASEICM         // Base do ICMS.
	xVALOR_ICMS  := SF2->F2_VALICM          // Valor do ICMS.
	xVALOR_IPI   := SF2->F2_VALIPI          // Valor do IPI.
	xICMS_RET    := SF2->F2_ICMSRET         // Valor do ICMS Retido.
	xBSICMRET    := 0

	//*�������������������������������������������������������������������*
	//*             ITENS DO CABECALHO QUE ESTAO NO ARQ. DE ITENS          *
	//*��������������������������������������������������������������������*
	DbSelectArea("SD2")
	DbSetOrder(3)
	DBSEEK(xFilial("SD2")+NOTA_NUM+SERNF)
	NREGATU   := RECNO()
	NOTA_NATU := ' '
	NOTA_COFI := ' '         
	NOTA_ALMOX:=' '//20070613
	
	WHILE SD2->D2_DOC == NOTA_NUM
		IF SD2->D2_SERIE # SERNF
			DBSKIP()
			LOOP
		ENDIF
		NOTA_TESA := SD2->D2_TES                        && TIPO ENTRADA E SAIDA
		NOTA_PEDI := SD2->D2_PEDIDO                     && PEDIDO INTERNO
		DbSelectArea("SF4")
		DBSEEK(xFilial("SF4")+SD2->D2_TES)
		MD2CF := SD2->D2_CF
		IF NOTA_NATU == ' '
			NOTA_NATU := TRIM(SF4->F4_TEXTO)
			NOTA_COFI := TRIM(MD2CF)
			NOTA_ALMOX:=TRIM(SD2->D2_LOCAL) //20070613
		ELSE
			IF TRIM(NOTA_NATU) # TRIM(SF4->F4_TEXTO)
				NOTA_NATU := NOTA_NATU + '/' + TRIM(SF4->F4_TEXTO)
			ENDIF
			IF TRIM(MD2CF)$(NOTA_COFI)
				NOTA_COFI := TRIM(NOTA_COFI)
			ELSE
				NOTA_COFI := TRIM(NOTA_COFI) + '/' + TRIM(SD2->D2_CF)
			ENDIF
			IF TRIM(SD2->D2_LOCAL)$(NOTA_ALMOX) //20070613
				NOTA_ALMOX :=TRIM(NOTA_ALMOX) //20070613
			ELSE //20070613
				NOTA_ALMOX :=TRIM(NOTA_ALMOX)+'/'+TRIM(SD2->D2_LOCAL) //20070613
			ENDIF //20070613
		ENDIF
		DBSELECTAREA("SD2")
		DBSKIP()
	END
	DBGOTO(NREGATU)
	//*��������������������������������������������������������������������*
	//*                          DADOS DO CLIENTE                          *
	//*��������������������������������������������������������������������*
	DbSelectArea("SA1")
	DBSEEK(xFilial("SA1")+NOTA_CLIE+NOTA_LOJA)
	IF SA1->A1_CGC == SPACE(14)
		CLIE_CGC := SA1->A1_CGCVAL
	ELSE
		CLIE_CGC := SA1->A1_CGC
	ENDIF
	CLIE_NOME := SA1->A1_NOME
	CLIE_INSC := SA1->A1_INSCR
	CLIE_ENDE := SA1->A1_END
	CLIE_BAIR := SA1->A1_BAIRRO
	CLIE_MUNI := SA1->A1_MUN
	CLIE_ESTA := SA1->A1_EST
	CLIE_CEP  := SA1->A1_CEP
	CLIE_SUF  := SA1->A1_SUFRAMA
	CLIE_COBR := SA1->A1_ENDCOB
	CLIE_TRAN := SA1->A1_TRANSP
	CLIE_FONE := SA1->A1_TEL
	CLIE_TIPO := SA1->A1_TIPO
	//*������������������������������������������������������������������*
	//*                          ENDERECO DE COBRANCA                     *
	//*������������������������������������������������������������������*
//20100305 DAQUI
	IF SM0->M0_CODIGO =="03" .AND. SA1->A1_ENDBP ="S"
		DbSelectArea("ZY3")
		DbSetOrder(1)
		DbSeek(XFilial("ZY3")+NOTA_CLIE+NOTA_LOJA)
		XENDC    :=ZY3_END
		XBAIRROC :=ZY3_BAIRRO
		XCIDADEC :=ZY3_CIDADE
		XESTADOC :=ZY3_ESTADO
		XCEPC    :=ZY3_CEP
	ELSEIF SUBS(SA1->A1_ENDCOB,1,1)=='S' .AND. SM0->M0_CODIGO <>"03"  //ATE AQUI 20100305
		DbSelectArea("SZ5")
		DbSetOrder(1)
		DbSeek(XFilial("SZ5")+NOTA_CLIE+NOTA_LOJA)
		XENDC    := SZ5->Z5_END
		XBAIRROC := SZ5->Z5_BAIRRO
		XCIDADEC := SZ5->Z5_CIDADE
		XESTADOC := SZ5->Z5_ESTADO
		XCEPC    := SZ5->Z5_CEP
	ELSE
		XENDC    := ' '
		XBAIRROC := ' '
		XCIDADEC := ' '
		XESTADOC := ' '
		XCEPC    := SPACE(8)
	ENDIF          
	
     //danilo 20051109
	If xICMS_RET > 0                          // Apenas se ICMS Retido > 0
		//������������������������������������������������������������������Ŀ
		//� CADASTRO LIVROS FISCAIS                                          �
		//��������������������������������������������������������������������
		DbSelectArea("SF3")
		DbSetOrder(4)
		DbSeek(xFilial("SF3")+SA1->A1_COD+SA1->A1_LOJA+SF2->F2_DOC+SF2->F2_SERIE)
		If Found()
			xBSICMRET := F3_VALOBSE
		EndIf
	Endif

	
	//*��������������������������������������������������������������������*
	//*        DEFINE CONDICAO DE PAGAMENTO P/TIPO DE OPER                 *
	//*��������������������������������������������������������������������*
	IF XTIPOOP=='99'
		XDESCRNF  := 'CONF.ABAIXO'
		XDESCDUPL := 'CR'                 //CONSULTA CONTAS A RECEBER
	ELSE
		DbSelectArea("SZ9")
		DbSetOrder(2)
		DbSeek(XTIPOOP)
		IF FOUND()
			XDESCRNF  := SZ9->Z9_DESCRNF
			XDESCDUPL := SZ9->Z9_DESCDUP
			XPAGA1    := SZ9->Z9_PAGA1
			XPAGAD    := SZ9->Z9_PAGAD
			XQTDEP    := SZ9->Z9_QTDEP
			XCODFAT   := SZ9->Z9_CODFAT
		ENDIF
	ENDIF
	// inicializa as variaveis de mensagem
	XMENSNF1:=' '
	XMENSNF2:=' '
	XMENSNF3:=' '
	DO CASE
		CASE XQTDEP == 1 .AND. XPAGA1 == 'S'
			XMENSNF4 := 'NF QUITADA.'
		CASE XQTDEP > 1 .AND. XPAGA1 == 'S' .AND. XPAGAD == 'S'
			XMENSNF4 := 'NF QUITADA.'
		OTHERWISE
			XMENSNF4 := ' '
	ENDCASE
	//*������������������������������������������������������������*
	//*                   IMPRESSAO DA NOTA FISCAL                 *
	//*������������������������������������������������������������*
	IF INICIO
		SETPRC(4,0) //linha -2 20041118
		COL  := 75
		COL2 := 114
		@ 04,01  PSAY '.' //linha -2 20041118
	ELSE
		SETPRC(0,0)
		@ 07,01  PSAY '.' //linha -2 20041118
		COL  := 73
		COL2 := 112
		SETPRC(4,0) //linha -2 20041118
	ENDIF
	
	@ 04,COL  PSAY 'XX' //linha -2 20041118
	@ 04,COL2 PSAY NOTA_NUM //linha -2 20041118
	@ 05,001  PSAY ' ' //linha -2 20041118
	// RETIRADO A PEDIDO DO USUARIO CICERO EM 18/10/2000 - GILBERTO.
	//@ 10,025  PSAY 'FONE:0(XX11)3224-8811'
	//@ 10,050  PSAY 'FAX:0(XX11)3224-0314'
	
	IF INICIO
		INICIO:=.F.
		INKEY(0)
	ENDIF
	@ 10,003 PSAY NOTA_NATU //linha -2 20041118
	@ 10,039 PSAY NOTA_COFI //linha -2 20041118
	@ 13,003 PSAY CLIE_NOME     + ' ' +NOTA_CLIE                && nome do cliente //linha -2 20041118
	//IF LEN(TRIM(CLIE_CGC))<14
	//@ 15,070 PSAY CLIE_CGC PICTURE "@R 999.999.999-99"        && c.g.c.
	//ELSE
	//@ 15,070 PSAY CLIE_CGC PICTURE "@R 99.999.999/9999-99"    && c.g.c.
	//ENDIF
	@ 13,077 PSAY CLIE_CGC                          && c.g.c. //linha -2 20041118
	@ 13,116 PSAY NOTA_EMIS                         && data de emissao //linha -2 20041118
	@ 15,003 PSAY CLIE_ENDE                         && endereco do cliente //linha -2 20041118
	@ 15,061 PSAY CLIE_BAIR                         && bairro //linha -2 20041118
	@ 15,092 PSAY SUBS(CLIE_CEP,1,5)+'-'+SUBS(CLIE_CEP,6,3)   && cep do cliente //linha -2 20041118
	@ 17,003 PSAY CLIE_MUNI                         && cep do cliente //linha -2 20041118
	@ 17,042 PSAY CLIE_FONE                         && fone do cliente //linha -2 20041118
	@ 17,068 PSAY CLIE_ESTA                         && estado do cliente //linha -2 20041118
	@ 17,087 PSAY CLIE_INSC                         && inscricao estadual //linha -2 20041118
	
	@ 20,020 PSAY XENDC //linha -2 20041118
	@ 21,007 PSAY SUBS(XCEPC,1,5)+'-'+SUBS(XCEPC,6,3) //linha -2 20041118
	@ 21,030 PSAY XBAIRROC //linha -2 20041118
	@ 21,083 PSAY XCIDADEC //linha -2 20041118
	@ 21,121 PSAY XESTADOC //linha -2 20041118
	SOMABOL := 0 //20060620
	If xDescDupl == "S"
		DbSelectArea("SE1")
		DbSetOrder(1)
		DBSEEK(xFilial("SE1")+MPREFIX+NOTA_NUM)  //em todos os PSAY linha -2 20041118
		WHILE SE1->E1_PREFIXO == MPREFIX  .AND. SE1->E1_NUM == NOTA_NUM .AND. !EOF()
			SOMABOL := SOMABOL + SE1->E1_DESPBOL //20060620
			IF SE1->E1_PARCELA == 'A' .OR. SE1->E1_PARCELA == ' '
				@ 23,005 PSAY '    '+ SE1->E1_PARCELA
				@ 23,025 PSAY SE1->E1_VALOR PICTURE '@e 999,999,999.99'
				@ 23,050 PSAY 'PARC QUITADA'
			ENDIF
			IF SE1->E1_PARCELA == 'B'
				@ 23,071 PSAY SE1->E1_NUM+' ' +SE1->E1_PARCELA
				@ 23,089 PSAY SE1->E1_VALOR PICTURE '@e 999,999,999.99'
				@ 23,112 PSAY SE1->E1_VENCTO
			ENDIF
			IF SE1->E1_PARCELA == 'C'
				@ 24,005 PSAY SE1->E1_NUM+' ' +SE1->E1_PARCELA
				@ 24,025 PSAY SE1->E1_VALOR PICTURE '@e 999,999,999.99'
				@ 24,050 PSAY SE1->E1_VENCTO
			ENDIF
			IF SE1->E1_PARCELA == 'D'
				@ 24,071 PSAY SE1->E1_NUM+' ' +SE1->E1_PARCELA
				@ 24,089 PSAY SE1->E1_VALOR PICTURE '@e 999,999,999.99'
				@ 24,112 PSAY SE1->E1_VENCTO
			ENDIF
			IF SE1->E1_PARCELA == 'E'
				@ 25,005 PSAY SE1->E1_NUM+' ' +SE1->E1_PARCELA
				@ 25,025 PSAY SE1->E1_VALOR PICTURE '@e 999,999,999.99'
				@ 25,050 PSAY SE1->E1_VENCTO
			ENDIF
			IF SE1->E1_PARCELA == 'F'
				@ 25,071 PSAY SE1->E1_NUM+' ' +SE1->E1_PARCELA
				@ 25,089 PSAY SE1->E1_VALOR PICTURE '@e 999,999,999.99'
				@ 25,112 PSAY SE1->E1_VENCTO
			ENDIF
			dbSkip()
		END
	ENDIF
	LIN := 29 //linha -2 20041118                         
	NPESOLIQUIDO := 0 //20041213		
	DbSelectArea('SD2')
	DbSetOrder(3)
	WHILE !Eof() .and. NOTA_NUM == SD2->D2_DOC .AND. SD2->D2_SERIE == SERNF .AND. !EOF()
		ITEM_CODI := alltrim(SD2->D2_COD)                         && codigo produto
		ITEM_QUAN := ABS(SD2->D2_QUANT)                  && quantidade
		ITEM_VUNI := ABS(SD2->D2_PRCVEN)                 && preco unitario
		ITEM_TOTA := ABS(SD2->D2_TOTAL)                  && preco total
		ITEM_ABAT := SD2->D2_DESC                        && desconto
//		NPESOLIQUIDO := NPESOLIQUIDO + D2_PESO 	// peso do produto 20041213
		
		IF SUBS(ITEM_CODI,1,2) == '01' .AND. SUBS(ITEM_CODI,5,3) # '001'
			DbSelectArea("SC6")
			DbSetOrder(1)
			If DbSeek(xFilial("SC6")+SD2->D2_PEDIDO+SD2->D2_ITEMPV)
				ITEM_EDINIC := SC6->C6_EDINIC
				ITEM_EDFIN  := SC6->C6_EDFIN				
				MCOMPL := 'ED: '+LTRIM(STR(ITEM_EDINIC,6,0))+' A '+LTRIM(STR(ITEM_EDFIN,6,0))
			EndIf
			DbSelectArea("SD2")
		ELSE
			MCOMPL := ' '
		ENDIF               
		


		DbSelectArea("SB1")
		DbSetOrder(1)
		DbSeek(xFilial("SB1")+ITEM_CODI)
		ITEM_UNID := SB1->B1_UM                          && unidade do produto
		ITEM_DESC := SUBS(SB1->B1_DESC,1,40)             && descricao do produto
		NPESOLIQUIDO := NPESOLIQUIDO + (B1_PESO * ITEM_QUAN) 	// peso do produto	

		IF TRIM(ITEM_CODI) == "0699001" .or. TRIM(ITEM_CODI) == "0699002" .or. TRIM(ITEM_CODI) == "0699003" && descricao generica 20051109
			ITEM_DESC := SUBS(SC6->C6_DESCRI,1,32)   && descricao do produto
		ENDIF
		//*���������������������������������������������������������������������*
		//*                       Detalhes do Item - Produto                    *
		//*���������������������������������������������������������������������*
		@ LIN+LI,002 PSAY ITEM_CODI                      && imprime cod do produto
		@ LIN+LI,014 PSAY ITEM_DESC                      && imprime descricao do item
		@ LIN+LI,058 PSAY 'CFOP:' + SD2->D2_CF           && SITUACAO TRIBUTARIA
		@ LIN+LI,075 PSAY '040'                           && SITUACAO TRIBUTARIA
		@ LIN+LI,080 PSAY 'UN'                           && SITUACAO TRIBUTARIA
		@ LIN+LI,084 PSAY ITEM_QUAN PICTURE '@E 999999'
		@ LIN+LI,095 PSAY ITEM_VUNI PICTURE '@E 99,999.99'
		@ LIN+LI,108 PSAY ITEM_TOTA PICTURE '@E 9,999,999.99'
		@ LIN+LI,123 PSAY IIf(Empty(SD2->D2_PICM),0,SD2->D2_PICM) Picture "@E 99" //danilo 20051109
		DBSELECTAREA("SD2")
		DBSKIP()
		LIN := LIN+1
	END
	
	DBSELECTAREA("SF2")
	IF NOTA_DESPREM <> 0
		NOTA_TOTA := NOTA_MERC + NOTA_DESPREM
	ENDIF
	IF SOMABOL > 0 //20060525
		NOTA_TOTA := NOTA_MERC + NOTA_DESPREM + SOMABOL    //20060606
	ENDIF
	@ 44,002 PSAY "PAGTO SOMENTE C/ BOLETO BANCARIO: NAO ACEITAMOS PAGTO VIA DOC, TRANSF. OU DEP. SIMPLES. POIS NOSSO SISTEMA NAO IDENTIFICA" //20060622
	@ 47,003 PSAY xBASE_ICMS  Picture "@E@Z 999,999,999.99"  // Base do ICMS.
	@ 47,028 PSAY xVALOR_ICMS Picture "@E@Z 999,999,999.99"  // Valor do ICMS.
	@ 47,055 PSAY xBSICMRET   Picture "@E@Z 999,999,999.99"  // Base ICMS Ret.
	@ 47,080 PSAY xICMS_RET   Picture "@E@Z 999,999,999.99"  // Valor  ICMS Ret.
	@ 47,102 PSAY NOTA_MERC    PICTURE '@E 9,999,999,999.99' //

	@ 49,003 PSAY NOTA_DESPREM PICTURE "@E 9,999.99" //
	@ 49,056 psay SOMABOL	    picture "@E 9,999.99" //20060620
	@ 49,102 PSAY NOTA_TOTA    PICTURE '@E 9,999,999,999.99' //
	
	DbSelectArea("SA3")
	DbSetOrder(1)
	DbSeek(xFilial()+NOTA_VEND)
	// peso liquido 20041213
	LIN:=55 //LINHA +7 20041117
	if NPESOLIQUIDO > 0 
		@ LIN +1 ,112 psay NPESOLIQUIDO PICTURE "@E 9,999.99"
	end if //ateh aki
	LIN := LIN +3
	
	@ LIN+1,20 PSAY XPEDIDO
	@ LIN+1,46 PSAY NOTA_VEND
	@ LIN+1,52 PSAY '/ ' + NOTA_ALMOX // 20070613 SA3->A3_LOCAL
	//IF XMENSNF4#'NF QUITADA'
	//   @ LIN+3,20 PSAY 'A NF SERA CONSIDERADA QUITADA APOS PAGTO DOS BOLETOS'
	//   @ LIN+4,20 PSAY 'ENVIADOS ANEXOS A CONFIRMACAO DO PEDIDO ACIMA.'
	//ENDIF
	
	@ LIN+5,20 PSAY XMENSNF3
	@ LIN+6,20 PSAY XMENSNFN
	@ LIN+7,20 PSAY XMENSNF4
	@ 69,95 PSAY TRIM(XCODFAT)+'/'+XTIPOOP //LINHA +6 20041117
	@ 69,115 PSAY NOTA_NUM //LINHA +6 20041117
	
	DbSelectArea("SC6")
	DBSETORDER(4)
	DBSKIP()
	set device to screen
	
	SETPRC(0,0)
	set device to printer
	SetPrc(0,0)
	
	LIN:=6
	LI:=0
END

SET DEVICE TO SCREEN

//DBSELECTAREA("SC6")
//DBSETORDER(1)

IF aRETURN[5] == 1
	Set Printer to
	dbcommitAll()
	ourspool(WNREL)
ENDIF

MS_FLUSH()

Return()