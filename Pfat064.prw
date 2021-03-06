#INCLUDE "RWMAKE.CH"
/*/
// 20051026: Nao perguntar novamente    
// 20060223: Ajuste do tipo de lancamento era X, C, D agora eh 3,2,1
//20090930 Danilo C S Pala: CT1_TPCONT CHAR(4) ERA CHAR(2)
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT064   �Autor: Raquel Farias          � Data: 26/08/99   � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Seleciona registros no CT2                                 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento  Liberado para Usu�rio em:           � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat064()
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // De      D-8                          �
//� mv_par02             // At�     D-8                          �
//� mv_par03 Conta       // De      C-20                         �
//� mv_par04 Conta       // At�     C-20                         �
//� mv_par05 Tipo        // De      C-20                         �
//����������������������������������������������������������������
cDesc1    := PADC("Este programa ira selecionar registros no arquivo" ,74)
cDesc2    := "  "
cDesc3    := ""
cPerg     := "PCON01"
mHora     := TIME()
cArq      := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
cString   := SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
cArqPath  := GetMv("MV_PATHTMP")
_cString  := cArqPath+cString+".DBF"
mConta    := 0
cQuery1   := ""
cQuery2   := ""
cUpdt     := ""
aStru     := ""

If !PERGUNTE(cPerg)
	Return
Endif

lEnd:= .F.

Processa({|| P064Proc()})

Return

Static Function P064Proc()

MsAguarde({|| FArqTrab()},"Aguarde" ,"Criando Arquivos Temporarios...",lEnd)

DBSELECTAREA("CT2")
aStru := DbStruct()

cChave  := IndexKey()
cFiltro := 'CT2_FILIAL == "' + xFilial("CT2") + '" .AND. DTOS(CT2_DATA) >= "' + DTOS(MV_PAR01) + '"'
cFiltro += ' .AND. DTOS(CT2_DATA) <= "' + DTOS(MV_PAR02) + '"'
cFiltro += ' .AND. Alltrim(CT2_DEBITO) >= "' + Alltrim(MV_PAR03) + '" .AND. Alltrim(CT2_DEBITO) <= "' + Alltrim(MV_PAR04) + '"'

If mv_par05 == 2
	cFiltro +=  ' .AND. DTOS(CT2_FECHCUS) == "        "'
EndIf
	
cInd := CriaTrab(nil,.f.)
MsAguarde({|| IndRegua("CT2",cInd,cChave,,cFiltro,"Filtrando ..")},"Aguarde","Selecionando Debitos...")

//mCond := " .AND. dtos(CT2_FECHCUS) == '        '"

//Copy Structure to &("\SIGAADV\PFAT064.DBF")

cArqTemp1 := CriaTrab(aStru,.t.)
cArqTemp2 := CriaTrab(aStru,.t.)

Copy to &cArqTemp1 //VIA "DBFCDXADS" // 20121106 

Dbgotop()
While !Eof()
	DbSelectArea("CT2")
	RecLock("CT2",.F.)
	CT2->CT2_FECHCUS := dDatabase
	CT2->CT2_CTRL    := IIF(mv_par05 == 2, "C", "M")
	MsUnlock()
	Dbskip()
End

DbSelectArea("CT2")
Retindex("CT2")

DBSELECTAREA('CT2')
cChave  := IndexKey()
cFiltro := 'CT2_FILIAL == "' + xFilial("CT2") + '" .AND. DTOS(CT2_DATA) >= "'+DTOS(MV_PAR01)+'"'
cFiltro += ' .AND. DTOS(CT2_DATA) <= "'+DTOS(MV_PAR02)+'"'
cFiltro += ' .AND. Alltrim(CT2_CREDIT) >= "' + Alltrim(MV_PAR03) + '" .AND. Alltrim(CT2_CREDIT) <= "' + Alltrim(MV_PAR04) + '"'

If MV_PAR05 == 2
	cFiltro += ' .AND. DTOS(CT2_FECHCUS) == "        "'
Endif

//If mv_par05 == 2
//	cFiltro += ' .AND. CT2_CTRL $ "C/ "'
//EndIf

cInd := CriaTrab(nil,.f.)
MsAguarde({|| IndRegua("CT2",cInd,cChave,,cFiltro,"Filtrando ..")},"Aguarde","Selecionando Creditos...")

Dbgotop()

Copy to &cArqTemp2   //VIA "DBFCDXADS" // 20121106 //("\SIGAADV\PFAT064B.DBF")

While !Eof()
	DbSelectArea("CT2")
	RecLock("CT2",.F.)
	CT2->CT2_FECHCUS := dDatabase
	CT2->CT2_CTRL    := IIF(mv_par05 == 2, "C", "M")
	MsUnlock()
	Dbskip()
End

Retindex("CT2")

//cArqTemp1 := "\SIGAADV\PFAT064A.DBF"
dbUseArea( .T.,, cArqTemp1,"PFAT064", .f., .F. )

dbSelectArea("PFAT064")
Dbgotop()

While !Eof()
	If CT2_DC == '3' // 20060223 era X
		Reclock("PFAT064",.f.)
		PFAT064->CT2_CREDIT := ' '
		MsUnlock()
	Endif
	If CT2_DC == '2' // 20060223 era C
		RecLock("PFAT064",.f.)
		dbDelete()
		MsUnlock()
	Endif
	DbSkip()
End

Pack

//cArqTemp2 := "\SIGAADV\PFAT064B.DBF"
dbUseArea( .T.,, cArqTemp2,"PFAT064B", .f., .F. )

dbSelectArea("PFAT064B")
Dbgotop()
While !Eof()
	If CT2_DC == '3' // 20060223 era X
		RecLock("PFAT064B",.f.)
		PFAT064B->CT2_DEBITO := ' '
		MsUnlock()
	Endif
	If CT2_DC == '1' // 20060223 era D
		RecLock("PFAT064B",.f.)
		dbDelete()
		MsUnlock()
	Endif
	DbSkip()
End

Pack

DbSelectArea("PFAT064B")
DbCloseArea()

dbSelectArea("PFAT064")
Append from &cArqTemp2 //PFAT064B.DBF
DbGoTop()

ProcRegua(RecCount())

While !EOF()
	mContab     := ""
	mDescrConta := ""
	mAno        := YEAR (CT2_DATA)
	mMes        := MONTH(CT2_DATA)
	mData       := CT2_DATA
	mValor      := CT2_VALOR
	mEdicao     := CT2_EDICAO
	mLancamento := CT2_LOTE + CT2_SBLOTE + CT2_DOC 
	mHist       := CT2_HIST
	mCodprod    := CT2_PRODUTO
	mLinha      := CT2_LINHA
	mTipo       := CT2_DC
	mGrconta    := ""
	mTpconta    := ""
	mDescrTp    := ""
	mCusto      := ""
	mProduto    := ""
	mNucleo     := ""
	mCCD        := ""
	mCCC        := ""
	mGrupoprod  := ""
	mCodEmpr    := ""
	mCodResp    := ""
	mCodNucleo  := ""
	mCodGeren   := ""
	mCodDetal   := ""
	mCodCusto   := ""
	mDesEmpr    := ""
	mDesResp    := ""
	mDesNucleo  := ""
	mDesGeren   := ""
	mDesDetal   := ""
	mDesCusto   := ""
	mCustoDeb   := CT2_CCD
	mCustoCred  := CT2_CCC
	mEmpresa    := SM0->M0_NOME
	
	If mv_par05 == 2
		If !PFAT064->CT2_CTRL $ "C/ "
			DbSelectArea("PFAT064")
			DbSkip()
			Loop
		EndIf
	EndIf
	
	If !Empty(PFAT064->CT2_DEBITO) .AND. PFAT064->CT2_DEBITO >= MV_PAR03 .AND. PFAT064->CT2_DEBITO <= MV_PAR04
		mContab := PFAT064->CT2_DEBITO
	Endif
	
	If !Empty(PFAT064->CT2_CREDIT) .AND. PFAT064->CT2_CREDIT >= MV_PAR03 .AND. PFAT064->CT2_DEBITO <= MV_PAR04
		mContab := PFAT064->CT2_CREDIT
	Endif

	If !Empty(PFAT064->CT2_DEBITO)
		mValor := mValor*(-1)
	Endif
	
	If !Empty(PFAT064->CT2_CCD) // .and. mValor < 0
		mCodEmpr   := SUBS(PFAT064->CT2_CCD,1,1)
		mCodResp   := SUBS(PFAT064->CT2_CCD,1,2)
		mCodNucleo := SUBS(PFAT064->CT2_CCD,1,3)
		mCodGeren  := SUBS(PFAT064->CT2_CCD,1,4)
		mCodDetal  := SUBS(PFAT064->CT2_CCD,1,9)
		mCodCusto  := SUBS(PFAT064->CT2_CCD,1,6)
	Endif
	
	If !Empty(PFAT064->CT2_CCC) .and. Empty(PFAT064->CT2_CCD) // .and. mValor > 0 
		//mCodEmpr   := SUBS(PFAT064->CT2_CCD,1,1) // Alterei em 13.05.02
		//mCodResp   := SUBS(PFAT064->CT2_CCD,1,2)
		//mCodNucleo := SUBS(PFAT064->CT2_CCD,1,4)
		//mCodGeren  := SUBS(PFAT064->CT2_CCD,1,6)
		//mCodDetal  := SUBS(PFAT064->CT2_CCD,1,6)
		//mCodCusto  := SUBS(PFAT064->CT2_CCD,1,9)
		mCodEmpr   := SUBS(PFAT064->CT2_CCC,1,1)
		mCodResp   := SUBS(PFAT064->CT2_CCC,1,2)
		mCodNucleo := SUBS(PFAT064->CT2_CCC,1,3)
		mCodGeren  := SUBS(PFAT064->CT2_CCC,1,4)
		mCodDetal  := SUBS(PFAT064->CT2_CCC,1,9)
		mCodCusto  := SUBS(PFAT064->CT2_CCC,1,6)
	Endif
	
	DbSelectArea("CT1")
	DbGoTop()
	If DbSeek(xFilial("CT1")+mContab) //,.T.)
		mDescrConta := CT1->CT1_DESC01
	Endif
	
	//If !Empty(PFAT064->CT2_DEBITO)
	//	mValor := mValor*(-1)
	//Endif
	

	IF TRIM(CT1->CT1_TPCONT) == '00' .OR. TRIM(CT1->CT1_TPCONT) == '0000' //20090930
		RecLock('CT1',.F.)
		Replace CT1_TPCONT With "    " //"  "   //20090930
		MsUnlock()
	ENDIF
	           
	//mTpConta := SUBS(CT1->CT1_GRCONT,1,2)+'00'
	mGrConta := SUBS(CT1->CT1_GRCONT,1,2)+'00'
	
	DbSelectArea("SX5")
	DbGoTop()
	//If DbSeek(xFilial("SX5")+'Z4'+Alltrim(mTpConta)) //, .T.)
	If DbSeek(xFilial("SX5")+'Z4'+Alltrim(mGrConta))
		mGrconta := mGrconta+' '+SX5->X5_DESCRI
	Endif	
	
	DbSelectArea("SX5")
	//DbGoTop()
	//If DbSeek(xFilial("SX5")+'Z4'+AllTrim(CT1->CT1_GRCONT)+Alltrim(CT1->CT1_TPCONT)) //, .T.)
	If DbSeek(xFilial("SX5")+'Z4'+AllTrim(CT1->CT1_GRCONT)+SUBSTR(CT1->CT1_TPCONT,3,2))//20090930
		mTpconta := CT1->CT1_GRCONT+IIF(Alltrim(CT1->CT1_TPCONT) == "","00",SUBSTR(CT1->CT1_TPCONT,3,2))+' '+SX5->X5_DESCRI //20090930
	Endif

	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+PFAT064->CT2_CCD)
		mCCD := CTT->CTT_DESC01
	Endif
	
	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+PFAT064->CT2_CCC)
		mCCD := CTT->CTT_DESC01
	Endif
	
	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+mCodEmpr)
		mDesEmpr := CTT->CTT_DESC01
	Endif
	
	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+mCodResp)
		mDesResp := CTT->CTT_DESC01
	Endif
	
	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+mCodGeren)
		mDesGeren := CTT->CTT_DESC01
	Endif
	
	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+mCodDetal)
		mDesDetal:=CTT->CTT_DESC01
	Endif

	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+mCodNucleo)
		mDesNucleo := CTT->CTT_DESC01
	Endif
	
	DbSelectArea("CTT")
	DbGoTop()
	If DbSeek(xFilial("CTT")+mCodCusto)
		mDesCusto:=CTT->CTT_DESC01
	Endif
	
	DbSelectArea("SX5")
	DbGoTop()
	If DbSeek(xFilial("SX5")+'98'+PFAT064->CT2_PROCESSO)
		mNucleo := PFAT064->CT2_PROCESSO+' '+SX5->X5_DESCRI
	Endif
	
	DbSelectArea("SB1")
	DbGoTop()
	If DbSeek(xFilial("SB1")+PFAT064->CT2_PRODUTO)
		mProduto := SB1->B1_DESC
		mNucleo  := SB1->B1_PROCESS
		//mCodNucleo := SB1->B1_PROCESS
	Endif
	
	If Empty(Alltrim(mNucleo)) .and. (Empty(mCodprod) .or. Alltrim(mCodProd) == "0999999")
		mNucleo := mCodNucleo
		//DbSelectArea("SX5")
		//DbGoTop()
		//If DbSeek(xFilial("SX5")+'98'+mCodNucleo, .T.)
		//	Nucleo := SX5->X5_DESCRI
		//Else
		//	Nucleo := mDesNucleo
		//Endif
	Endif
/*	
	DbSelectArea("SX5")
	DbGoTop()
	If DbSeek(xFilial("SX5")+'03'+SB1->B1_GRUPO)
		mGrupoprod := SX5->X5_DESCRI
	Endif
*/
	DbSelectArea("SBM")
	DbGoTop()
	If DbSeek(xFilial("SBM")+SB1->B1_GRUPO)
		mGrupoprod := SBM->BM_DESC
	Endif
	
	dbSelectArea("PFAT064")
	DbSkip()
	
	IF '-' $(PFAT064->CT2_DC)
		While (PFAT064->CT2_LOTE + PFAT064->CT2_SBLOTE + PFAT064->CT2_DOC )  == mlancamento .and. '-'$(PFAT064->CT2_DC)
			mHist += mHist+CT2_HIST
			DbSkip()
		End
	Endif
	Grava()
	dbSelectArea("PFAT064")
	IncProc("Lendo Registro : "+Alltrim(StrZero(Recno(),7))+" Gravando...... "+Alltrim(StrZero(mConta,7)))
End

cMsg:= "Arquivo Gerado com Sucesso em: "+_cString

DbSelectArea(cArq)
dbGoTop()
COPY TO &(_cString) VIA "DBFCDXADS" // 20121106 
MsgAlert(cMsg)

DbSelectArea("CT1")
Retindex("CT1")

DbSelectArea(cArq)
DbCloseArea()

DbSelectArea("PFAT064")
DbCloseArea()

fErase('PFAT064A.DBF')
fErase('PFAT064B.DBF')
//Grvdata()
Return
//���������������������������������������������������������������������������Ŀ
//� Function  � GRAVA()                                                       �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza gravacao dos registros ideais (conforme parametros)   �
//�           � para impressao de Relatorio.                                  �
//�����������������������������������������������������������������������������
Static Function GRAVA()

mConta := mConta+1

If Empty(mCodprod)
	mProduto:=" "
	mGrupoprod:=" "
Endif

If Empty(mCodEmpr)
	mDesEmpr  :=" "
	mDesResp  :=" "
	mDesNucleo:=" "
	mDesGeren :=" "
	mDesDetal :=" "
	mDesCusto :=" "
Endif

DbSelectArea(cArq)
RecLock(cArq,.T.)
Replace Empresa    With mEmpresa
Replace Ano        With mAno
Replace Mes        With mMes
Replace Conta      With mContaB
Replace DescrConta With mDescrConta
Replace GrConta    With mGrConta
Replace TpConta    With mTpconta
Replace Dta        With mData
Replace Valor      With mValor
Replace Produto    With mProduto
Replace Codprod    With mCodprod
Replace Nucleo     With mNucleo
Replace Grupoprod  With mGrupoprod
Replace CCD        With mCCD
Replace CCC        With mCCC
Replace CodEmpr    With mCodEmpr 
Replace CodResp    With mCodResp
Replace CodNucleo  With mCodNucleo
Replace CodGeren   With mCodGeren
Replace CodDetal   With mCodDetal
Replace CodCusto   With mCodCusto
Replace DesEmpr    With mDesEmpr
Replace DesResp    With mDesResp
Replace DesNucleo  With mDesNucleo
Replace DesGeren   With mDesGeren
Replace DesDetal   With mDesDetal
Replace DesCusto   With mDesCusto
Replace Lancamento With mLancamento
Replace Linha      With mLinha
Replace Hist       With mHist
Replace Edicao     With mEdicao
Replace Tipo       With mTipo

MsUnlock()
Return

//���������������������������������������������������������������������������Ŀ
//� Function  � FARQTRAB()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Cria arquivo de trabalho para guardar registros que serao     �
//�           � impressos em forma de etiquetas.                              �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//�����������������������������������������������������������������������������
STATIC Function FARQTRAB()

_aCampos := {}
AADD(_aCampos,{"Empresa   ","C",30,0})
AADD(_aCampos,{"CodEmpr   ","C",9,0})
AADD(_aCampos,{"CodResp   ","C",9,0})
AADD(_aCampos,{"CodNucleo ","C",9,0})
AADD(_aCampos,{"CodGeren  ","C",9,0})
AADD(_aCampos,{"CodCusto  ","C",9,0})
AADD(_aCampos,{"CodDetal  ","C",9,0})
AADD(_aCampos,{"DesEmpr   ","C",40,0})
AADD(_aCampos,{"DesResp   ","C",40,0})
AADD(_aCampos,{"DesNucleo ","C",40,0})
AADD(_aCampos,{"DesGeren  ","C",40,0})
AADD(_aCampos,{"DesCusto  ","C",40,0})
AADD(_aCampos,{"DesDetal  ","C",40,0})
AADD(_aCampos,{"Ano       ","N",4,0})
AADD(_aCampos,{"Mes       ","N",2,0})
AADD(_aCampos,{"Conta     ","C",40,0})
AADD(_aCampos,{"DescrConta","C",60,0})
AADD(_aCampos,{"GrConta   ","C",60,0})
AADD(_aCampos,{"TpConta   ","C",60,0})
AADD(_aCampos,{"Nucleo    ","C",60,0})
AADD(_aCampos,{"CCD       ","C",60,0})
AADD(_aCampos,{"CCC       ","C",60,0})
AADD(_aCampos,{"Dta       ","D",8,0})
AADD(_aCampos,{"Valor     ","N",12,2})
AADD(_aCampos,{"Codprod   ","C",15,0})
AADD(_aCampos,{"Produto   ","C",60,0})
AADD(_aCampos,{"Grupoprod ","C",40,0})
AADD(_aCampos,{"Lancamento","C",10,0})
AADD(_aCampos,{"Linha"     ,"C",3,0})
AADD(_aCampos,{"Hist      ","C",255,0})
AADD(_aCampos,{"Edicao    ","N",4,0})
AADD(_aCampos,{"Tipo      ","C",1,0})

_cNome := CriaTrab(_aCampos,.t.)
cIndex := CriaTrab(Nil,.F.)
cKey   := "Dtos(Dta)+Conta"
dbUseArea(.T.,, _cNome,cArq,.F.,.F.)
dbSelectArea(cArq)
Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")

Return(.T.)
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
STATIC Function _ValidPerg()

_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

AADD(aRegs,{cPerg,"01","Data de............:","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Data at�...........:","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Conta  de..........:","mv_ch3","C",20,0,0,"G","","mv_par03","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"04","Conta  At�.........:","mv_ch4","C",20,0,0,"G","","mv_par04","","","","","","","","","","","","","","","CT1"})
AADD(aRegs,{cPerg,"05","Tipo...............:","mv_ch5","G",01,0,2,"C","","mv_par05","Movimento","","","Complemento","","","","","","","","","","",""})

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
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �GrvData   � Autor � Marcos Farineli       � Data � 22/07/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Grava a data de fechamento de custo no encerramento        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico Editora Pini                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function GrvData()

mCond := " .AND. dtos(CT2_FECHCUS) == '        '"

DBSELECTAREA("CT2")
cChave  := IndexKey()
cFiltro := 'CT2_FILIAL == "' + xFilial("CT2") + '" .AND. DTOS(CT2_DATA) >= "' + DTOS(MV_PAR01) + '"'
cFiltro += ' .AND. DTOS(CT2_DATA) <= "' + DTOS(MV_PAR02) + '"'
cFiltro += ' .AND. Alltrim(CT2_DEBITO) >= "' + Alltrim(MV_PAR03) + '" .AND. Alltrim(CT2_DEBITO) <= "' + Alltrim(MV_PAR04) + '"'

If MV_PAR05 == 2
	cFiltro += ' .AND. DTOS(CT2_FECHCUS) == "        "'
Endif

cInd := CriaTrab(nil,.f.)
MsAguarde({|| IndRegua("CT2",cInd,cChave,,cFiltro,"Filtrando ..")},"Aguarde","Gravando Fechamento (D)...")

Dbgotop()

While !Eof()
	DbSelectArea("CT2")
	RecLock("CT2",.F.)
	CT2->CT2_FECHCUS := dDatabase
	MsUnlock()
	Dbskip()
End

DbSelectArea("CT2")
Retindex("CT2")

DBSELECTAREA('CT2')
cChave  := IndexKey()
cFiltro := 'CT2_FILIAL == "' + xFilial("CT2") + '" .AND. DTOS(CT2_DATA) >= "'+DTOS(MV_PAR01)+'"'
cFiltro += ' .AND. DTOS(CT2_DATA) <= "'+DTOS(MV_PAR02)+'"'
cFiltro += ' .AND. Alltrim(CT2_CREDIT) >= "' + Alltrim(MV_PAR03) + '" .AND. Alltrim(CT2_CREDIT) <= "' + Alltrim(MV_PAR04) + '"'
If MV_PAR05 == 2
	cFiltro += ' .AND. DTOS(CT2_FECHCUS) == "        "'
Endif

cInd := CriaTrab(nil,.f.)
MsAguarde({|| IndRegua("CT2",cInd,cChave,,cFiltro,"Filtrando ..")},"Aguarde","Gravando Fechamento (C)...")

Dbgotop()

While !Eof()
	DbSelectArea("CT2")
	RecLock("CT2",.F.)
	CT2->CT2_FECHCUS := dDatabase
	MsUnlock()
	Dbskip()
End

DbSelectArea("CT2")
RetIndex("CT2")

Return