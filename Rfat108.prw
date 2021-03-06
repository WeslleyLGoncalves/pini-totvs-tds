#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT039   �Autor: Valdir Diocleciano     � Data:   25/09/02 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Relatorio de comissoes a pagar - Cartao de Credito         � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rfat108()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

SetPrvt("TITULO,CDESC1,CTITULO,CCABEC1,CCABEC2,XCABEC1")
SetPrvt("XCABEC2,NCARACTER,ARETURN,SERNF,CPROGRAMA,CPERG")
SetPrvt("NLASTKEY,M_PAG,LCONTINUA,WNREL,L,CBTXT")
SetPrvt("CBCONT,NORDEM,ALFA,Z,M,TAMANHO")
SetPrvt("CDESC2,CDESC3,CSTRING,TREGS,M_MULT,P_ANT")
SetPrvt("P_ATU,P_CNT,M_SAV20,M_SAV7,MVEND,MEMISSN")
SetPrvt("MNOMEVEND,MREGIAO,MEQUIPE,MVALTOT,MVALCOM,MVALBASE")
SetPrvt("MPREFIXO,MNUM,MPARCELA,MCODCLI,MLOJA,MVBASE")
SetPrvt("MPEDIDO,MVLRBASE,MPORC,MCOMIS,MTIPO,MSTATUS,MSTATUS1")
SetPrvt("MEMISSAO,MVENCTO,MBAIXA,MNOMECLI,MCALCCOM,MCALCFGTS")
SetPrvt("MCALCDSR,MTOTALCOM,mValor,mhora")

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Da Regiao                            �
//� mv_par02             // At� Regiao                           �
//� mv_par03             // Data de Pagamento                    �
//� mv_par04             // Mensal/Semestral                     �
//����������������������������������������������������������������
Titulo    := PADC("COMISSOES ",74)
cDesc1    := PADC("Este programa emite relatorio de Comissoes a pagar ",74)
cTitulo   := ' **** RELATORIO DE COMISSOES - CARTAO DE CREDITO **** '
// Regua para impressao dos sub-titulos
//                 10        20        30        40        50        60        70         80        90        100      110       120     130         140      150       160
//        123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 123456789 12456789'
cCabec1   := 'PEDIDO    CODIGO    LJ   NOME CLIENTE                                 DUPL      DATA      DATA        DATA             VALOR         %             VALOR       OBSERVACAO'
cCabec2   := '          CLIENTE                                                               EMISSAO   VENCTO      PAGTO            BASE                     COMISSAO    '
xCabec1   := 'DEMONSTRATIVO DE VENDAS - RESUMO'
xCabec2   := ' '
nCaracter := 18
aReturn   := { "Especial", 1,"Administracao", 1, 2, 1,"",1 }
SERNF     := 'UNI'
cPrograma := "RELCOM2"
cPerg     := "FAT026"
nLastKey  := 0
M_PAG     := 1
lContinua := .T.
MHORA := TIME()
wnrel     := "RELCOM2_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
L         := 0
CbTxt     := ""
CbCont    := ""
nOrdem    := 0
Alfa      := 0
Z         := 0
M         := 0
tamanho   := "G"
cDesc2    := ""
cDesc3    := ""
//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas.                                     �
//���������������������������������������������������������������������������
Pergunte(cPerg,.T.)               // Pergunta no SX1

cString:="ZZN"

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������

wnrel:=SetPrint(cString,wnrel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F.)          // 30/09

If nLastKey == 27
	Return
Endif
//��������������������������������������������������������������Ŀ
//� Verifica Posicao do Formulario na Impressora                 �
//����������������������������������������������������������������
SetDefault(aReturn,cString)           // 30/09

If nLastKey == 27
	Return
Endif

Processa({|| Impressao()})

Static FUNCTION Impressao()

Dbselectarea("ZZN")
Dbsetorder(2)
// dbSeek(xFILIAL("ZZN")+MV_PAR05+DTOS(MV_PAR03)+MV_PAR01,.t.)

dbSeek(xFILIAL("ZZN")+MV_PAR05+DTOS(MV_PAR03),.t.)

ProcRegua(RecCount())

//  While DTOS(ZZN->ZZN_EMISSA) >= DTOS(MV_PAR03) .AND. DTOS(ZZN->ZZN_EMISSA) <= DTOS(MV_PAR04)

While !EOF() .OR. ZZN->ZZN_VEND > MV_PAR05
	
	/*
	IF DTOS(ZZN->ZZN_DATA) < DTOS(MV_PAR03)
	DBSKIP()
	LOOP
	ENDIF
	*/
	IF  (DTOS(ZZN->ZZN_DATA) > DTOS(MV_PAR04) .OR. (ZZN->ZZN_REGIAO < MV_PAR01 .OR. ZZN->ZZN_REGIAO > MV_PAR02))
		DBSKIP()
		LOOP
	ENDIF
	
	IncProc("Vendedor: "+ZZN->ZZN_VEND)
	
	DBSELECTAREA("ZZN")
	
	mVend   :=ZZN->ZZN_VEND
	
	IF MVEND # MV_PAR05 .AND. MV_PAR05 # SPACE(6)
		DBSKIP()
		LOOP
	ENDIF
	
	dbSelectArea("SA3")
	DBSETORDER(1)
	dbSeek(xFILIAL("SA3")+mVEND)
	If Found()
		
		If SA3->A3_EMISSN == 'N' .OR. SA3->A3_TIPOVEN == 'CT'
			dbSelectArea("ZZN")
			dbskip()
			loop
		Endif
		
		/*
		IF  (DTOS(ZZN->ZZN_DTMOV) > DTOS(MV_PAR04) .OR. (ZZN->ZZN_REGIAO < MV_PAR01 .OR. ZZN->ZZN_REGIAO > MV_PAR02))
		dbSelectArea("ZZN")
		DBSKIP()
		LOOP
		ENDIF
		*/
		
		MEMISSN   := SA3->A3_EMISSN
		mNOMEVEND := SA3->A3_NOME
		mREGIAO   := SA3->A3_REGIAO
		mEQUIPE   := SA3->A3_EQUIPE
	Endif
	mValtot  := 0
	mVALCOM  := 0
	mVALBASE := 0
	L        := 0
	
	dbSelectArea("ZZN")
	
	While Alltrim(Mvend) == Alltrim(ZZN->ZZN_VEND)
		IF  (DTOS(ZZN->ZZN_EMISSA) > DTOS(MV_PAR04) .OR. (ZZN->ZZN_REGIAO < MV_PAR01 .OR. ZZN->ZZN_REGIAO > MV_PAR02))
			dbSelectArea("ZZN")
			DBSKIP()
			LOOP
		ENDIF
		
		dbSelectArea("SE3")
		dbSetOrder(2)
		If dbSeek(xFILIAL("SE3")+ZZN->ZZN_VEND+ZZN->ZZN_PREFIX+ZZN->ZZN_NUM+ZZN->ZZN_PARCEL,.t.)
			If DTOS(SE3->E3_DATA) # "        "
				DBSELECTAREA("ZZN")
				RecLock("ZZN",.F.)
				ZZN->ZZN_PGTO := SE3->E3_DATA
				MsUnlock()
				DBSKIP()
				LOOP
			Endif
		ENDIF
		
		dbSelectArea("ZZN")
		mPREFIXO  := ZZN->ZZN_PREFIX
		mNUM      := ZZN->ZZN_NUM
		mPARCELA  := ZZN->ZZN_PARCEL
		mCODCLI   := ZZN->ZZN_CODCLI
		mLOJA     := ZZN->ZZN_LOJA
		//		mVBASE    := SE3->E3_BASE
		mVBASE    := ZZN->ZZN_VALOR
		mPEDIDO   := ZZN->ZZN_PEDIDO
		mVLRBASE  := ZZN->ZZN_VALOR
		mPORC     := ZZN->ZZN_PCCOMI
		mCOMIS    := ZZN->ZZN_VLCOMI
		mTIPO     := ZZN->ZZN_TIPO
		mVEND     := ZZN->ZZN_VEND
		mSTATUS   := ZZN->ZZN_SITUAC
		//		mSTATUS1  := ZZN->ZZN_ESTORN
		
		//		If val(SE3->E3_SITUAC)==0
		If val(ZZN->ZZN_SITUAC)==0
			//			dbSelectArea("SE1")
			//			dbSeek(xFILIAL()+mPREFIXO+mNUM+mPARCELA)
			//			If Found()
			mEMISSAO := ZZN->ZZN_EMISSAO
			mVENCTO  := ZZN->ZZN_VENCTO
			mBAIXA   := ZZN->ZZN_DTBX
			//			Endif
		Else
			mEMISSAO := ' '
			mVENCTO  := ' '
			mBAIXA   := ' '
		Endif
		
		dbSelectArea("SA1")
		dbsetorder(1)
		dbSeek(xFILIAL()+mCODCLI+mLOJA)
		If found()
			mNOMECLI := SA1->A1_NOME
		Endif
		
		DO CASE
			CASE MEMISSN == 'P'
				IMPPLAN()
			CASE MEMISSN == 'R'
				IMPRECI()
		ENDCASE
		
		dbSelectArea("ZZN")
		dbSkip()
	End
	
	If MEMISSN == "P"
		@ l+2,000 psay 'TOTAL===========> '
		@ L+2,114 psay STR(mVALBASE,10,2)
		@ L+2,142 psay STR(mVALCOM,10,2)
		Roda(0,"",tamanho)
	ELSEIF MEMISSN == 'R'
		IF VAL(MVEND)#10
			@ l+2,05 psay ' TOTAL DA PRODUCAO : '+STR(MVALBASE,10,2)
			@ L+4,05 psay ' TOTAL DE COMISSOES: '+STR(MVALCOM,10,2)
			@ L+5,05 psay '                      =========='
		ELSE
			MCALCCOM  := MVALBASE*.7915/100
			MCALCFGTS := MVALBASE*.074084/100
			MCALCDSR  := MVALBASE*.134555/100
			MTOTALCOM := MCALCCOM+MCALCFGTS+MCALCDSR
			@ L +2,10 psay 'TOTAL DA PRODUCAO......: ' + STR(MVALBASE,10,2)
			@ L +4,10 psay 'VALOR DE COMISSOES ....: ' + STR(MCALCCOM,10,2)
			@ L +6,10 psay 'VALOR FGTS ............: ' + STR(MCALCFGTS,10,2)
			@ L +8,10 psay 'VALOR DSR  ............: ' + STR(MCALCDSR,10,2)
			@ L+10,10 psay 'TOTAL DE COMISSOES.....: ' + STR(MTOTALCOM,10,2)
		ENDIF
		Roda(0,"",tamanho)
	endif
END

SET DEVICE TO SCREEN

IF aRETURN[5] == 1
	Set Printer to
	dbcommitAll()
	ourspool(WNREL)
ENDIF

MS_FLUSH()

Return

Static FUNCTION IMPPLAN()

IF L == 0
	L := CABEC(cTitulo,cCabec1,cCabec2,cPrograma,tamanho)
	L += 2
	@ L,001 psay  'REPRES.....:  ' + MVEND +' ' +MNOMEVEND +' '+'REGIAO: '+MREGIAO+' ' +'EQUIPE: ' + MEQUIPE
	L += 2
ENDIF

@ L,001 psay  mPEDIDO
@ L,010 psay  mCODCLI
@ L,020 psay  mLOJA
@ L,025 psay  mNOMECLI
@ L,070 psay  mNUM
@ L,077 psay  mPARCELA
@ L,080 psay  mEMISSAO
@ L,090 psay  mVENCTO
@ L,102 psay  mBAIXA
//  @ L,114 psay  STR(MVALOR,10,2)
@ L,114 psay  STR(MVLRBASE,10,2)
@ L,130 psay  STR(mPORC,6,3)
@ L,142 psay  STR(MCOMIS,10,2)
DO CASE
	CASE MSTATUS=='1'
		@ L,159 psay 'FATURAMENTO CANCELADO'
	CASE MSTATUS=='2'
		@ L,159 psay 'ESTORNO DE VENDEDOR'
	CASE MSTATUS=='3'
		@ L,159 psay 'ESTORNO DE PRODUTO'
	CASE MSTATUS=='4'
		@ L,159 psay 'ESTORNO DE CLIENTE'
	CASE MSTATUS=='5'
		@ L,159 psay 'COMISSAO PAGA EM DUPLICIDADE'
	CASE MSTATUS=='6'
		@ L,159 psay 'ESTORNO PARA ACERTO DE VALOR'
ENDCASE

/*
IF MSTATUS1 == 'S'
@ L,159 psay 'ESTORNO DE COMISSAO'
ENDIF
*/

//IF VAL(MSTATUS)>0 .OR. MSTATUS1 == 'S'
IF VAL(MSTATUS) > 0
	MVALCOM  := MVALCOM-MCOMIS
	MVALBASE := MVALBASE-MVLRBASE
ELSE
	MVALBASE := MVALBASE+MVLRBASE
	MVALCOM  := MVALCOM+MCOMIS
ENDIF

IF L >= 55
	L:=0
ELSE
	L++
ENDIF

RETURN

Static FUNCTION IMPRECI()

IF L == 0
	L := CABEC(cTitulo,xCabec1,xCabec2,cPrograma,tamanho)
	L += 2
	@ L,001 psay  'REPRES.....:  ' + MVEND +' ' +MNOMEVEND +' '+'REGIAO: '+MREGIAO+' ' +'EQUIPE: ' + MEQUIPE
	L += 2
ENDIF

IF VAL(MSTATUS)>0
	//  MVALTOT  := MVALTOT-MVALOR
	MVALCOM  := MVALCOM-MCOMIS
	MVALBASE := MVALBASE-MVLRBASE
ELSE
	//    MVALTOT  := MVALTOT+MVALOR
	MVALBASE := MVALBASE+MVLRBASE
	MVALCOM  := MVALCOM+MCOMIS
ENDIF
Return
