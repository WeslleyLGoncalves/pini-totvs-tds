#include "rwmake.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT149A  �Autor: Raquel Ramalho         � Data:   28/01/02 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Gera Posicao de Comissoes                                  � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Alterado por Marcos Farineli em 18/07/02 para considerar produtos no SC6
User Function Pfat149a()

SetPrvt("PROGRAMA,MHORA,CARQ,CSTRING,WNREL,NLASTKEY")
SetPrvt("L,NORDEM,M_PAG,NCARACTER,TAMANHO,CCABEC1")
SetPrvt("CCABEC2,LCONTINUA,CARQPATH,_CSTRING,_CSTRING2,CPERG")
SetPrvt("MCONTA1,MCONTA2,MCONTA3,LEND,BBLOCO,CMSG")
SetPrvt("CCHAVE,CFILTRO1,CFILTRO2,CFILTRO3,CFILTRO,CIND")
SetPrvt("MCONTA,MVEND,MEMISSAO,MDTPGTO,MPEDIDO,MPARCELA,MVALITEM,MQTDE")
SetPrvt("MNOMEVEND,MDIVVEND,MVALOR,MPLANILHA,_ACAMPOS,_CNOME")
SetPrvt("CINDEX,CKEY,_SALIAS,AREGS,I,J")

//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//�������������������������������������������������������������������������Ĵ
//� mv_par01 Vencimento De......:                                           �
//� mv_par02 Vencimento At�.....:                                           �
//� mv_par03 Pagas   Em Aberto    Ambos  
//� mv_par04 Produto de.........:   
//� mv_par05 Produto Ate........:                                       �                                        �                                   �
//���������������������������������������������������������������������������

Programa  := "PFAT149A"
MHORA     := TIME()
cArq      := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
cString   := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
wnrel     := SUBS(CUSUARIO,7,6)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
nLastKey  := 00
L         := 00
nOrdem    := 00
m_pag     := 01
nCaracter := 10
tamanho   := "M"
cCabec1   := ""
cCabec2   := ""
lContinua := .T.
cArqPath  := GetMv("MV_PATHTMP")
_cString  := cArqPath+cString+".DBF"
_cString2 := cString+".DBF"

//��������������������������������������������������������������Ŀ
//� Caso nao exista, cria grupo de perguntas.                    �
//����������������������������������������������������������������
cPerg:="PFT149"

// Definindo bases
DbSelectArea("SE3")
DbSetOrder(2)
DbGoTop()

If !Pergunte(cPerg)
	Return
Endif

IF Lastkey()==27
	Return
Endif

mConta1 :=0
mConta2 :=0
mConta3 :=0

FArqTrab()

Filtra()

lEnd   := .F.
bBloco := {|lEnd| PRODUTOS()}
Processa(bBloco,"Aguarde","Processando",.t.)

While .T.
	If !Pergunte(cPerg)
		Exit
	Endif
	If LastKey()== 27
		Exit
	Endif
	Filtra()
	lEnd   := .F.
	bBloco := {|lEnd| PRODUTOS()}
	Processa(bBloco,"Aguarde","Processando",.t.)
End
     
cMsg := "Arquivo Gerado com Sucesso em: "+_cString

DbSelectArea(cArq)
dbGoTop()
COPY TO &_cString VIA "DBFCDXADS" // 20121106 
MSGINFO(cMsg)

//��������������������������������������������������������������Ŀ
//� Retorna indices originais...                                 �
//����������������������������������������������������������������
DbSelectArea(cArq)
DbCloseArea()

DbSelectArea("SE3")
Retindex("SE3")

DbSelectArea("SA3")
Retindex("SA3")

Return
//���������������������������������������������������������������������������Ŀ
//� Function  � Filtra()                                                      �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Filtra arquivo SE3 para ser utilizado no programa.            �
//�����������������������������������������������������������������������������
Static Function FILTRA()

DbSelectArea("SE3")
DbGoTop()
cChave := IndexKey()
If MV_PAR03==1
	cFiltro := 'DTOS(E3_DATA)>="'+DTOS(MV_PAR01)+'"'
	cFiltro += '.AND. DTOS(E3_DATA)<="'+DTOS(MV_PAR02)+'"'
	cFiltro += '.AND. !Empty(DTOS(E3_DATA)) .and. SE3->E3_COMIS<>0'
Endif   

If MV_PAR03==2
	cFiltro :='Empty(DTOS(E3_DATA)) .and. SE3->E3_COMIS<>0'
Endif

cInd := CriaTrab(NIL,.f.)

IndRegua("SE3",cInd,cChave,,cFiltro,"Filtrando Pedidos...")

Dbgotop()

Return
//���������������������������������������������������������������������������Ŀ
//� Function  � PRODUTOS()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza leitura dos registros do SE2 ja filtrado e aplica     �
//�           � restante dos filtros de parametros. Prepara os dados para     �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//�����������������������������������������������������������������������������
Static Function PRODUTOS()

Local nregs := 0

mConta :=0

DbSelectArea("SE3")
DbGoTop()

nRegs := RecCount()

ProcRegua(nRegs)

While SE3->E3_FILIAL = xFilial("SE3") .and. !EOF()
	IncProc("Lendo Pedido: " + SE3->E3_PEDIDO)
	mVend     := SE3->E3_VEND
	mEmissao  := SE3->E3_EMISSAO
	mDtPgto   := SE3->E3_DATA
	mPedido   := SE3->E3_PEDIDO
	mParcela  := SE3->E3_PARCELA
	mNomeVend := ""
	mDivVend  := ""
	mValPed   := 0       

	If !Empty(SE3->E3_SITUAC)
		mValor   := -SE3->E3_COMIS
	Else
		mValor   := SE3->E3_COMIS
	Endif
	
	DbSelectArea("SA3")
	DbGoTop()
	DbSeek(xFilial("SA3")+mVend)
	If Found()
		mNomeVend := SA3->A3_NOME
		mPlanilha := SA3->A3_EMISSN
		mDivVend  := SA3->A3_DIVVEND
		mRegiao   := SA3->A3_REGIAO
		If SA3->A3_TIPOVEN=='CT'
			mPlanilha := 'N'
		Endif
		If SA3->A3_TIPOVEN=='CP'
			mPlanilha := 'N'
		Endif
	Endif

	If mPlanilha <> 'N'
		DbSelectArea("SC5")
		DBSetOrder(1)
		DbSeek(xFilial("SC5")+mPedido)
		mValPed := SC5->C5_VLRPED
		
		DbSelectArea("SC6")
		DbSetOrder(1)
		If DbSeek(xFilial("SC6") + mPedido)
			While !Eof() .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM == mPedido
			    If SC6->C6_PRODUTO<MV_PAR04 .OR. SC6->C6_PRODUTO>MV_PAR05
			       Dbskip()
			       loop
			    Endif
				GRAVA()
				DbSelectArea("SC6")
				DbSkip()
		    End
		EndIf
	Endif

	DbSelectArea("SE3")
	DbSkip()

End

Return
//���������������������������������������������������������������������������Ŀ
//� Function  � GRAVA()                                                       �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza gravacao dos registros ideais (conforme parametros)   �
//�           � para impressao de Relatorio.                                  �
//�����������������������������������������������������������������������������
Static Function GRAVA()

aVend    := {}
aPercom  := {}
mConta1  := mConta1++
mProd    := SC6->C6_PRODUTO
mValTit  := 0
cCampo   := ""
cInd     := ""

For nC := 1 to 5
	cCampo := "SC6->C6_COMIS"
	cInd   := Alltrim(Str(nC))
	AADD(aPercom,&(cCampo+cInd))
    cCampo := "SC5->C5_VEND"
    AADD(aVend,&(cCampo+cInd))
Next nC    

cInd := Alltrim(Str(ASCAN(aVend,SE3->E3_VEND)))

mPercCom := IIF(cInd <> "0",&("SC6->C6_COMIS"+cInd),SC6->C6_COMIS1) 

DbSelectArea("SE1")
DbSetOrder(1)
DbSeek(xFilial("SE1")+SE3->E3_PREFIXO+SE3->E3_NUM+SE3->E3_PARCELA)
mValTit  := SE1->E1_VLCRUZ

DbSelectArea("SZ3")
DBSetOrder(1)
If DbSeek(xFilial("SZ3") + mProd + mRegiao)
	mPercCom := IIF(cInd $ "1/2",&("SZ3->Z3_COMREP"+cInd),mPercCom)
	If SA3->A3_TIPOVEN == "SP"
		mPercCom := IIF(SZ3->Z3_COMGLOC <> 0,SZ3->Z3_COMGLOC,mPercCom)
	EndIf
EndIf

mComPro  := Round((SC6->C6_QTDVEN*SC6->C6_PRCVEN * mPercCom/100) * (mValTit/mValPed), 2)
mQtde    :=SC6->C6_QTDVEN
mValItem :=SC6->C6_PRCVEN


DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1") + mProd)
mGrupo := SB1->B1_GRUPO

DbSelectArea(cArq)
RecLock(cArq,.T.)
Replace Vend     With mVend
Replace Emissao  With mEmissao
Replace NomeVend With mNomeVend
Replace DivVend  with mDivVend
Replace DtPgto   With mDtPgto
Replace Pedido   With mPedido
Replace Parcela  With mParcela
Replace PercCom  With mPercCom
Replace ComiProd With mComPro
Replace Grupo    With mGrupo
Replace Produto  With mProd 
Replace ValItem  With mValItem
Replace Qtde     With mQtde
MsUnlock()

Return
//���������������������������������������������������������������������������Ŀ
//� Function  � FARQTRAB()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Cria arquivo de trabalho para guardar registros que serao     �
//�           � impressos em forma de etiquetas.                              �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//�����������������������������������������������������������������������������
Static Function FARQTRAB()

_aCampos := {}
AADD(_aCampos,{"VEND"     ,"C" ,06 ,0})
AADD(_aCampos,{"EMISSAO"  ,"D" ,08 ,0})
AADD(_aCampos,{"DTPGTO"   ,"D" ,08 ,2})
AADD(_aCampos,{"NOMEVEND" ,"C" ,40 ,0})
AADD(_aCampos,{"DIVVEND"  ,"C" ,40 ,0})
AADD(_aCampos,{"PARCELA"  ,"C" ,01 ,2})
AADD(_aCampos,{"PEDIDO"   ,"C" ,06 ,2})
AADD(_aCampos,{"PRODUTO"  ,"C" ,15 ,0})
AADD(_aCampos,{"GRUPO"    ,"C" ,06 ,0})
AADD(_aCampos,{"PERCCOM"  ,"N" ,12 ,2})
AADD(_aCampos,{"COMIPROD" ,"N" ,12 ,2})
AADD(_aCampos,{"VALITEM"   ,"N" ,12 ,2})
AADD(_aCampos,{"QTDE" ,"N" ,12 ,2})

_cNome := CriaTrab(_aCampos,.t.)
cIndex := CriaTrab(Nil,.F.)
cKey   := "DTOS(EMISSAO)+VEND"

dbUseArea(.T.,, _cNome,cArq,.F.,.F.)
dbSelectArea(cArq)

Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")

Return