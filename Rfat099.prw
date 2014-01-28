#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa : RFAT099  � Autor: Claudio               � Data: 12/12/01   � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Relacao do Controle de Pagamentos                          � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Rfat099()
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = numero do lote               �
//�   mv_par02 = data do lote                 �
//���������������������������������������������
SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,ALINHA,NLASTKEY,NLIN,TITULO")
SetPrvt("CABEC1,CABEC2,CCANCEL,M_PAG,WNREL,MBRUTO")
SetPrvt("_TLIQ,_SALIAS,AREGS,I,J,mhora")

cPerg := "ZZI001"

_validPerg()

If !pergunte(cperg)
	Return
Endif

cString  := "ZZI"
cDesc1   := PADC("Emite o relat�rio dos pedidos por periodo",70)
cDesc2   := " "
cDesc3   := " "
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFAT099"
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := OemToAnsi("RELACAO DO CONTROLE DE PAGAMENTOS")
Cabec1   := " "
cabec2   := "PEDIDO  CODVEND  TIPOOP      VALOR         DTVENC    HISTORICO"
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1      //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFAT099_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
wnrel    := SetPrint(cString,wnrel,cPerg,space(15)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)
Mbruto   := 0
_Tliq    := 0

SetDefault(aReturn,cString)

If nLastKey == 27 .or. nlastkey == 65
	Return
Endif

// �����������������������������������������������Ŀ
// �Chama Relatorio                                �
// �������������������������������������������������
RptStatus({|| RptDetail() })

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �RptDetail � Autor � Ary Medeiros          � Data � 15.02.96 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Impressao do corpo do relatorio                             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function RptDetail()

Local lLote := .F.

dbSelectArea("ZZI")
DbGoTop()
dbSetOrder(1)
SetRegua(LastRec())
While !Eof() .and. ZZI->ZZI_FILIAL == xFilial("ZZI")
	IncRegua()

	IF  ZZI->ZZI_LOTE  <>  MV_PAR01
		DBSKIP()
		LOOP
	ENDIF
    
	If !Eof() .and. Alltrim(ZZI->ZZI_LOTE) == Alltrim(MV_PAR01)
		lLote := .T.
	EndIf    

	IF  ZZI->ZZI_DATA  <>  MV_PAR02
		DBSKIP()
		LOOP
	ENDIF
	
	if nLin > 50
		Cabec1 := "Numero do Lote: " + MV_PAR01 + "          Data do Lote: " + DTOC(MV_PAR02)
		nLin   := Cabec(titulo,cabec1,cabec2,nomeprog,tamanho,18) //Impressao do cabecalho
		nLin   += 2
	endif
	
	@ nLin,000 PSAY ZZI->ZZI_PEDIDO
	@ nLin,009 PSAY ZZI->ZZI_CODVEN
	@ nLin,019 PSAY ZZI->ZZI_TIPOOP
	@ nLin,025 PSAY TRANSFORM(ZZI->ZZI_VALOR, "@E 999,999,999.99")
	MBRUTO += ZZI->ZZI_VALOR
	@ nLin,042 PSAY ZZI->ZZI_DTVENC
	@ nLin,053 PSAY ZZI->ZZI_OBS
	nLin++
	
	DbSelectArea("ZZI")
	DbSkip()
End

nLin  +=  3

@ nLin,000 PSAY "Valor Total.:            " + Transform(Mbruto, "@E 999,999,999.99")

If !lLote
	nlin += 2
	@ nLin,000 PSAY "********** NAO FOI ENCONTRADO LOTE DE ACORDO COM OS PARAMETROS INFORMADOS	**********"
	nLin++
	@ nLin,000 PSAY "********** LOTE " + MV_PAR01+ " DATA " + DTOC(MV_PAR02)+" **********"
EndIf

Mbruto:= 0

Set Device to Screen

If aReturn[5] == 1
	Set Printer To
	DbCommitAll()
	ourspool(wnrel) //Chamada do Spool de Impressao
Endif

MS_FLUSH() //Libera fila de relatorios em spool

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
Static Function _ValidPerg()

_sAlias := Alias()

DbSelectArea("SX1")
DbSetOrder(1)

cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
AADD(aRegs,{cPerg,"01","Numero do Lote....:","mv_ch1","C",3,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data do Lote......:","mv_ch2","D",8,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})

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