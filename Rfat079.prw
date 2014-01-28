#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT041   �Autor: Solange Nalini         � Data:   18/11/98 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RESUMO DE VENDAS - PLANILHA COMISSOES                      � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rfat079()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

SetPrvt("TITULO,CDESC1,CTITULO,CCABEC1,CCABEC2,NCARACTER")
SetPrvt("ARETURN,CPROGRAMA,CPERG,NLASTKEY,M_PAG,LCONTINUA")
SetPrvt("WNREL,L,CBTXT,CBCONT,NORDEM,ALFA")
SetPrvt("Z,M,TAMANHO,CDESC2,CDESC3,CSTRING")
SetPrvt("_ACAMPOS,_CNOME,NSALDOATU,NSALDOINI,XCONTA,MBANCO")
SetPrvt("MNOMEBANCO,MAGENCIA,MCONTA,MLIMCRED,MSALDOT,mhora")

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Regiao                            �
//� mv_par02             // At� Regiao                           �
//� mv_par02             // Data de Pagamento                    �
//� mv_par02             // Mensal/Semestral                     �
//����������������������������������������������������������������
Titulo     := PADC("SALDOS BANCARIOS ",74)
cDesc1     := PADC("Este programa emite Relatorio de saldos bancarios ",74)
cTitulo    := ' **** SALDOS BANCARIOS  **** '
cCabec1    := ' '
cCabec2    := ' '
nCaracter  := 10
aReturn    := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
cPrograma  := "SALDO"
cPerg      := "FINR02"
nLastKey   := 0
M_PAG      := 1
lContinua  := .T.
MHORA := TIME()
wnrel      := "SALDOS_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
L          := 0
CbTxt      := ""
CbCont     := ""
nOrdem     := 0
Alfa       := 0
Z          := 0
M          := 0
tamanho    := "P"
cDesc2     := ""
cDesc3     := ""

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas.                                     �
//���������������������������������������������������������������������������
Pergunte(cPerg,.T.)               // Pergunta no SX1

cString    :="SE8"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel      := SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.T.)

//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

_aCampos := {  	{"NOMEBCO" ,"C"	,40	,0},;
				{"CONTA"   ,"C"	,12	,0},;
				{"SALDO"   ,"N"	,12	,2}}

_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"BANCO",.F.,.F.)

nSaldoAtu := 0
nSaldoIni := 0

dbSelectArea("SA6")
DbGoTop()
While !eof()
	xconta:=A6_NUMCON
	if SA6->A6_FLUXCAI <> "S"
		DbSkip()
		Loop
	Endif
	
	MBanco      := A6_COD
	MNomeBanco  := A6_NOME
	MAgencia    := A6_AGENCIA
	MConta      := A6_NUMCON
	MLimCred    := A6_LIMCRED
	//��������������������������������������������������������������Ŀ
	//� Saldo de Partida                                             �
	//����������������������������������������������������������������
	dbSelectArea("SE8")
	dbSeek( xFilial("SE8")+mBanco+mAgencia+mConta+Dtos(mv_par01),.T.)
	
	//��������������������������������������������������������������Ŀ
	//� Defini��o dos cabe�alhos                                     �
	//����������������������������������������������������������������
	
	IF E8_BANCO!=mBanco .or. E8_AGENCIA!=MAgencia .or. E8_CONTA!=mConta .or. BOF() .or. EOF() .or. E8_DTSALAT!=mv_par01
		dbskip(-1)
		If E8_BANCO!=mBanco .or. E8_AGENCIA!=MAgencia .or. E8_CONTA!=mConta .or. BOF() .or. EOF()
			nsaldoatu:=0
		Else
			nsaldoatu:=E8_SALATUA
		ENDIF
	Else
		nsaldoatu:=E8_SALATUA
	Endif
	
	GRAVA_BANCO()
	DbSelectarea("SA6")
	DbSkip()
End

IMPRES()

IF L >= 55
	//SETPRC(0,0)
	Roda(0,"",tamanho)
	L := CABEC(cTitulo,cCabec1,cCabec2,cPrograma,tamanho,NCARACTER)
	L += 2
ELSE
	L += 2
ENDIF

DBSELECTAREA("BANCO")
COPY TO VERB VIA "DBFCDXADS" // 20121106 
DBCLOSEAREA()

SET DEVI TO SCREEN
IF aRETURN[5] == 1
	Set Printer to
	dbcommitAll()
	ourspool(WNREL)
ENDIF

MS_FLUSH()

Return

Static FUNCTION IMPRES()

DBSELECTAREA("BANCO")
DBGOTOP()
MSALDOT := 0
L       := 0

WHILE !EOF()
	IF L == 0
		L := CABEC(cTitulo,cCabec1,cCabec2,cPrograma,tamanho,NCARACTER)
		L += 2
		@ L,030 PSAY  'MOVIMENTO DE : ' + DTOC(MV_PAR01)
		//   @ L+1,00 PSAY REPLICATE('*',80)
		L += 3
	ENDIF
	@ L,00 Psay CONTA
	@ L,15 PSAY NOMEBCO
	@ L,60 PSAY STR(SALDO,10,2)
	MSALDOT  := MSALDOT+SALDO
	l:=l+3
	@ l,00 Psay replicate('-',80)
	IF L >= 55
		Roda(0,"",tamanho)
		L := CABEC(cTitulo,cCabec1,cCabec2,cPrograma,tamanho,NCARACTER)
		L += 2
	ELSE
		L++
	ENDIF
	DBSKIP()
END

@ L+2,00 PSAY 'SALDO TOTAL'
@ L+2,60 PSAY STR(MSALDOT,10,2)

Roda(0,"",tamanho)

RETURN

Static FUNCTION GRAVA_BANCO()

DBSELECTAREA("BANCO")

RECLOCK("BANCO",.t.)
BANCO->NOMEBCO:=MNOMEBANCO
BANCO->CONTA  :=MCONTA
BANCO->SALDO  :=nsaldoatu
MSUNLOCK()

RETURN