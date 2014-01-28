#INCLUDE "RWMAKE.CH"
#INCLUDE "GPER250.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER250  � Autor � R.H. - Marcos Stiefano� Data � 30.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Cesta Basica                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER250(void)                                              ���
�������������������������������������������������������������������������Ĵ��
���Parametros�                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   � BOPS �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��� Aldo       �24/03/97�xxxxxx� Inclusao de cancelamento de impressao.   ���
��� Aldo       �28/05/97�11114A� Pegar Horas do cad.Func. na CompMes().   ���
��� Aldo       �29/07/97�10468A� Criado pergunta Salario Base/Composto.   ���
��� Aldo       �18/09/97�XXXXXX� Trocado "funcionario" por "beneficiario" ���
��� Aldo       �31/10/97�12207a� Lanc.Verba Base C.Basica parte Empresa.  ���
��� Aldo       �05/01/98�13929a� Cancel.Rel. qdo nao achar Adic.Temp.Serv.���
��� Cristina   �19/05/98�XXXXXX� Conversao para outros idiomas.           ���
��� Kleber     �02/07/98�15943A� Acrescentado ordem por Nome e C.C.+Nome  ���
��� Kleber     �13/07/98�16043A� Impor quebra de pagina por Filial.       ���
��� Mauro      �25/08/98�------� Subs.fValoriza por fSalInc-Incorp.Salar. ���
��� Aldo       �30/03/99�------� Passagem de nTamanho para SetPrint().    ���
���Marinaldo   �27/07/00�XXXXXX� Retirada Dos e Validacao Filial/Acessos  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
USER Function CTBASI()
LOCAL cDesc1  := STR0001			//"Rela��o da Cesta Basica                                   "
LOCAL cDesc2  := STR0002			//"Ser� impresso de acordo com os parametros solicitados pelo"
LOCAL cDesc3  := STR0003			//"usu�rio."
LOCAL cString := "SRA" 							// alias do arquivo principal (Base)
LOCAL aOrd    := {STR0004,STR0005,STR0017,STR0018}	//"Centro de Custo"###"Matr�cula"###"Nome"###"Centro de Custo + Nome"//

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Basicas)                            �
//����������������������������������������������������������������
Private aReturn  := {STR0006,1,STR0007,2,2,1,"",1 }		//"Zebrado"###"Administra��o"
Private NomeProg := "GPER250"
Private aLinha   := {}
Private nLastKey := 0
Private cPerg    := "GPR250"

//��������������������������������������������������������������Ŀ
//� Define Variaveis Private(Programa)                           �
//����������������������������������������������������������������
Private aPosicao1 := {} // Array das posicoes
Private aTotCc1   := {}
Private aTotFil1  := {}
Private aTotEmp1  := {}
Private aInfo     := {}

//��������������������������������������������������������������Ŀ
//� Variaveis Utilizadas na funcao IMPR                          �
//����������������������������������������������������������������
Private Titulo
Private AT_PRG   := "GPER250"
Private wCabec0  := 1
Private wCabec1  := STR0008		//"FIL C.CUSTO   MATRICULA   NOME                                CUSTO BENEFICIARIO     CUSTO EMPRESA        CUSTO TOTAL"
Private Contfl   := 1
Private Li       := 0
Private nTamanho := "M"

//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
pergunte("GPR250",.F.)

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01        //  Filial De                                �
//� mv_par02        //  Filial Ate                               �
//� mv_par03        //  Centro de Custo De                       �
//� mv_par04        //  Centro de Custo Ate                      �
//� mv_par05        //  Matricula De                             �
//� mv_par06        //  Matricula Ate                            �
//� mv_par07        //  Situacoes                                �
//� mv_par08        //  Categorias                               �
//� mv_par09        //  Imprime C.C em Outra Pagina              �
//� mv_par10        //  Atualiza SRC                             �
//� mv_par11        //  Data do Pagamento                        �
//� mv_par12        //  Sobre qual Salario                       �
//����������������������������������������������������������������
cTit   :=STR0009	// " RELA��O DA CESTA BASICA "
Titulo :=STR0009	// " RELA��O DA CESTA BASICA "
wCabec1+=" "
wCabec1+=" "

//��������������������������������������������������������������Ŀ
//� Envia controle para a funcao SETPRINT                        �
//����������������������������������������������������������������
wnrel:="GPER250"            //Nome Default do relatorio em Disco
wnrel:=SetPrint(cString,wnrel,cPerg,cTit,cDesc1,cDesc2,cDesc3,.F.,aOrd,,nTamanho)

//��������������������������������������������������������������Ŀ
//� Carregando variaveis mv_par?? para Variaveis do Sistema.     �
//����������������������������������������������������������������
nOrdem     := aReturn[8]
cFilDe     := mv_par01
cFilAte    := mv_par02
cCcDe      := mv_par03
cCcAte     := mv_par04
cMatDe     := mv_par05
cMatAte    := mv_par06
cSituacao  := mv_par07
cCategoria := mv_par08
lSalta     := If( mv_par09 == 1 , .T. , .F. )
lAtualiza  := If( mv_par10 == 1 , .T. , .F. )
dDpgto     := mv_par11
nQualSal   := mv_par12

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

RptStatus({|lEnd| GR250Imp(@lEnd,wnRel,cString)},cTit)

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � GPER250  � Autor � R.H. - Marcos Stiefano� Data � 30.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Relatorio Cesta Basica                                     ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � GPER250(lEnd,WnRel,cString)                                ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lEnd        - A��o do Codelock                             ���
���          � wnRel       - T�tulo do relat�rio                          ���
���Parametros� cString     - Mensagem			                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GR250Imp(lEnd,WnRel,cString)
//��������������������������������������������������������������Ŀ
//� Define Variaveis Locais (Programa)                           �
//����������������������������������������������������������������
LOCAL CbTxt //Ambiente
LOCAL CbCont

Local aBasica   := {}
Local nCustFunc := 0
Local nSalario  := 0
Local nSalMes   := 0
Local nSalDia   := 0
Local nSalHora  := 0

/*
��������������������������������������������������������������Ŀ
� Variaveis de Acesso do Usuario                               �
����������������������������������������������������������������*/
Local cAcessaSRA	:= &( " { || " + ChkRH( "GPER250" , "SRA" , "2" ) + " } " )

Private aCodFol   := {}
Private aRoteiro  := {}

dbSelectArea( "SRA" )
If nOrdem == 1
	dbSetOrder(2)
ElseIf nOrdem == 2
	dbSetOrder(1)
ElseIf nOrdem == 3
   dbSetOrder(3)
ElseIf nOrdem == 4
   dbSetOrder(8)	
Endif
dbGoTop()

If nOrdem == 1 
	dbSeek( cFilDe + cCcDe + cMatDe , .T. )
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC + SRA->RA_MAT"
	cFim    := cFilAte + cCcAte + cMatAte
ElseIf nOrdem == 2 
	dbSeek( cFilDe + cMatDe , .T. )
	cInicio := "SRA->RA_FILIAL + SRA->RA_MAT"
	cFim    := cFilAte + cMatAte
ElseIf nOrdem == 3
   dbSeek( cFilDe , .T. )
	cInicio := "SRA->RA_FILIAL"
	cFim    := cFilAte
ElseIf nOrdem == 4
  	dbSeek( cFilDe + cCcDe , .T. )
	cInicio := "SRA->RA_FILIAL + SRA->RA_CC"
	cFim    := cFilAte + cCcAte		
Endif

cFilialAnt := "  "
cCcAnt     := Space(9)

dbSelectArea( "SRA" )
SetRegua(SRA->(RecCount()))

While	!EOF() .And. &cInicio <= cFim
	
		//��������������������������������������������������������������Ŀ
		//� Movimenta Regua Processamento                                �
		//����������������������������������������������������������������
		IncRegua()

		If lEnd
			@Prow()+1,0 PSAY cCancel
			Exit
		Endif	 
		
		If SRA->RA_FILIAL # cFilialAnt
			If !Fp_CodFol(@aCodFol,SRA->RA_FILIAL)           .Or. ;
				!CarBasica(@aBasica,SRA->RA_FILIAL)           .Or. ;
				!fInfo(@aInfo,SRA->RA_FILIAL)
				Exit
			Endif
			dbSelectArea( "SRA" )
			cFilialAnt := SRA->RA_FILIAL
		Endif
      
      //��������������������������������������������������������������Ŀ
		//� Consiste Parametrizacao do Intervalo de Impressao            �
		//����������������������������������������������������������������
		If (Sra->Ra_Mat < cMatDe) .Or. (Sra->Ra_Mat > cMatAte) .Or. ;
			(Sra->Ra_CC < cCcDe) .Or. (Sra->Ra_CC > cCCAte)
			fTestaTotal()			
			Loop
		EndIf

		/*
		�����������������������������������������������������������������������Ŀ
		�Consiste Filiais e Acessos                                             �
		�������������������������������������������������������������������������*/
		IF !( SRA->RA_FILIAL $ fValidFil() .and. Eval( cAcessaSRA ) )
	   		fTestaTotal()
	   		Loop
		EndIF

		//��������������������������������������������������������������Ŀ
		//� Verifica se Existe Incorporacao de Salario                   �
		//����������������������������������������������������������������
		aPd := {} // Limpa a Matriz do SRC
		If nQualSal # 2 		//-- Salario Composto
			//��������������������������������������������������������������Ŀ
			//� Calcula Salario Mes,Dia,Hora Funcionario                     �
			//����������������������������������������������������������������
			fSalario(@nSalario,@nSalHora,@nSalDia,@nSalMes,"A")
		Else
			fSalInc(@nSalario,@nSalMes,@nSalHora,@nSalDia,.T.)
		Endif
		
		//��������������������������������������������������������������Ŀ
		//� Verifica se o Funcionario Tem Cesta Basica                   �
		//����������������������������������������������������������������
		If SRA->RA_CESTAB # "S"
			fTestaTotal()
			Loop
		Endif
	
		//��������������������������������������������������������������Ŀ
		//� Verifica Situacao e Categoria do Funcionario                 �
		//����������������������������������������������������������������
		If !( SRA->RA_SITFOLH $ cSituacao ) .OR. !( SRA->RA_CATFUNC $ cCategoria )
			fTestaTotal()
			Loop
		Endif
	
		nCustFunc := 0			
		//��������������������������������������������������������������Ŀ
		//� Calcula a Cesta Basica                                       �
		//����������������������������������������������������������������
		If nSalMes >= aBasica[1,2] .And. nSalMes <= aBasica[1,3]
			nCustFunc := ( aBasica[1,1] * aBasica[1,4] ) / 100
		ElseIf nSalMes >= aBasica[1,5] .And. nSalMes <= aBasica[1,6]
			nCustFunc := ( aBasica[1,1] * aBasica[1,7] ) / 100
		ElseIf nSalMes >= aBasica[1,8] .And. nSalMes <= aBasica[1,9]
			nCustFunc := ( aBasica[1,1] * aBasica[1,10] ) / 100
		ElseIf nSalMes >= aBasica[1,11] .And. nSalMes <= aBasica[1,12]
			nCustFunc := ( aBasica[1,1] * aBasica[1,13] ) / 100
		ElseIf nSalMes >= aBasica[1,14] .And. nSalMes <= aBasica[1,15]
			nCustFunc := ( aBasica[1,1] * aBasica[1,16] ) / 100
        ElseIf nSalMes >= aBasica[1,17] .And. nSalMes <= aBasica[1,18]
			nCustFunc := ( aBasica[1,1] * aBasica[1,19] ) / 100
        ElseIf nSalMes >= aBasica[1,20] .And. nSalMes <= aBasica[1,21]
			nCustFunc := ( aBasica[1,1] * aBasica[1,22] ) / 100
        ElseIf nSalMes >= aBasica[1,23] .And. nSalMes <= aBasica[1,24]
			nCustFunc := ( aBasica[1,1] * aBasica[1,25] ) / 100
        ElseIf nSalMes >= aBasica[1,26] .And. nSalMes <= aBasica[1,27]
			nCustFunc := ( aBasica[1,1] * aBasica[1,28] ) / 100
		Endif
	
		//��������������������������������������������������������������Ŀ
		//� Calcula o Bloco para o Funcionario                           �
		//����������������������������������������������������������������
		aPosicao1:={} // Limpa Arrays
		Aadd(aPosicao1,{0,0,0,0})
	
		//��������������������������������������������������������������Ŀ
		//� Atualiza o Bloco para os Totalizadores                       �
		//����������������������������������������������������������������
		nPos0 := nCustFunc
		nPos1 := ( aBasica[1,1] - nCustFunc )
		nPos2 := aBasica[1,1]
		nPos3 := 1
		Atualiza(@aPosicao1,1,nPos0,nPos1,nPos2,nPos3)
	
		//��������������������������������������������������������������Ŀ
		//� Atualiza a Movimentacao do Funcionario SRC                   �
		//����������������������������������������������������������������
		If lAtualiza
			Begin Transaction
				If nCustFunc > 0
					GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aCodFol[156,1],dDpgto,SRA->RA_CC,cSemana,"V","G",0,nCustFunc,0)
				Endif
				If ( aBasica[1,1] - nCustFunc ) > 0
					GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aCodFol[157,1],dDpgto,SRA->RA_CC,cSemana,"V","G",0,aBasica[1,1],0)
					GravaSrc(SRA->RA_FILIAL,SRA->RA_MAT,aCodFol[211,1],dDpgto,SRA->RA_CC,cSemana,"V","G",0,(aBasica[1,1]-nCustFunc),0)
				Endif
			End Transaction
		Endif

		//��������������������������������������������������������������Ŀ
		//� Atualizando Totalizadores                                    �
		//����������������������������������������������������������������
		fAtuCont(@aToTCc1)  // Centro de Custo
		fAtuCont(@aTotFil1) // Filial
		fAtuCont(@aTotEmp1) // Empresa
	
		//��������������������������������������������������������������Ŀ
		//� Impressao do Funcionario                                     �
		//����������������������������������������������������������������
		fImpFun()
	
		fTestaTotal()  // Quebras e Skips
EndDo

//��������������������������������������������������������������Ŀ
//� Termino do Relatorio                                         �
//����������������������������������������������������������������
dbSelectArea( "SRA" )
Set Filter to 
dbSetOrder(1)

Set Device To Screen

If aReturn[5] = 1
	Set Printer To
	Commit
	ourspool(wnrel)
Endif

MS_FLUSH()

*--------------------------------------*
Static Function CarBasica(aBasica,cFil)
*--------------------------------------*
Local cAlias := Alias()
Local nValCesta := 0
Local nIniF1 := nFimF1 := nPerc1:= 0
Local nIniF2 := nFimF2 := nPerc2:= 0
Local nIniF3 := nFimF3 := nPerc3:= 0
Local nIniF4 := nFimF4 := nPerc4:= 0
Local nIniF5 := nFimF5 := nPerc5:= 0
Local nIniF6 := nFimF6 := nPerc6:= 0
Local nIniF7 := nFimF7 := nPerc7:= 0
Local nIniF8 := nFimF8 := nPerc8:= 0
Local nIniF9 := nFimF9 := nPerc9:= 0
aBasica := {}

dbSelectArea( "SRX" )
If FPHIST82( SRA->RA_FILIAL , "35" , cFil + "1" )
	nValCesta := Val(Substr(SRX->RX_TXT,01,11))
	nIniF1    := Val(Substr(SRX->RX_TXT,12,11))
	nFimF1    := Val(Substr(SRX->RX_TXT,23,11))
	nPerc1    := Val(Substr(SRX->RX_TXT,34,07))
	FPHIST82( SRA->RA_FILIAL , "35" , cFil + "2" )
	nIniF2    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF2    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc2    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF3    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF3    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc3    := Val(Substr(SRX->RX_TXT,52,07))
	FPHIST82( SRA->RA_FILIAL , "35" , cFil + "3" )
	nIniF4    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF4    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc4    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF5    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF5    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc5    := Val(Substr(SRX->RX_TXT,52,07))
	FPHIST82( SRA->RA_FILIAL , "35" , cFil + "4" )
	nIniF6    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF6    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc6    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF7    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF7    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc7    := Val(Substr(SRX->RX_TXT,52,07))
	FPHIST82( SRA->RA_FILIAL , "35" , cFil + "5" )
	nIniF8    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF8    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc8    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF9    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF9    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc9    := Val(Substr(SRX->RX_TXT,52,07))
ElseIf FPHIST82( SRA->RA_FILIAL , "35" , "  1" )
	nValCesta := Val(Substr(SRX->RX_TXT,01,11))
	nIniF1    := Val(Substr(SRX->RX_TXT,12,11))
	nFimF1    := Val(Substr(SRX->RX_TXT,23,11))
	nPerc1    := Val(Substr(SRX->RX_TXT,34,07))
	dbSkip( 1 )
	FPHIST82( SRA->RA_FILIAL , "35" , "  2" )
	nIniF2    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF2    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc2    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF3    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF3    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc3    := Val(Substr(SRX->RX_TXT,52,07))
	FPHIST82( SRA->RA_FILIAL , "35" , "  3" )
	nIniF4    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF4    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc4    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF5    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF5    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc5    := Val(Substr(SRX->RX_TXT,52,07))
		FPHIST82( SRA->RA_FILIAL , "35" , "  4" )
	nIniF6    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF6    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc6    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF7    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF7    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc7    := Val(Substr(SRX->RX_TXT,52,07))
	FPHIST82( SRA->RA_FILIAL , "35" , "  5" )
	nIniF8    := Val(Substr(SRX->RX_TXT,01,11))
	nFimF8    := Val(Substr(SRX->RX_TXT,12,11))
	nPerc8    := Val(Substr(SRX->RX_TXT,23,07))
	nIniF9    := Val(Substr(SRX->RX_TXT,30,11))
	nFimF9    := Val(Substr(SRX->RX_TXT,41,11))
	nPerc9    := Val(Substr(SRX->RX_TXT,52,07))
Else
	Set Device To Screen
	HELP(" ",1,"GR250CESTA")
	dbSelectArea( cAlias )
	Return ( .F. )
Endif

Aadd(aBasica,{nValCesta,nIniF1,nFimF1,nPerc1,nIniF2,nFimF2,nPerc2,nIniF3,nFimF3,nPerc3,nIniF4,nFimF4,nPerc4,nIniF5,nFimF5,nPerc5,nIniF6,nFimF6,nPerc6,nIniF7,nFimF7,nPerc7,nIniF8,nFimF8,nPerc8,nIniF9,nFimF9,nPerc9})

dbSelectArea( cAlias )
Return ( .T. )

*--------------------------------------------------------------*
Static Function Atualiza(aMatriz,nElem,nPos0,nPos1,nPos2,nPos3)
*--------------------------------------------------------------*
aMatriz[nElem,1] := nPos0
aMatriz[nElem,2] := nPos1
aMatriz[nElem,3] := nPos2
aMatriz[nElem,4] := nPos3

Return Nil

*--------------------------*
Static Function fTestaTotal
*--------------------------*
dbSelectArea( "SRA" )
cFilialAnt := SRA->RA_FILIAL              // Iguala Variaveis
cCcAnt     := SRA->RA_CC
dbSkip()

If Eof() .Or. &cInicio > cFim
	fImpCc()
	fImpFil()
	fImpEmp()
Elseif cFilialAnt # SRA->RA_FILIAL
	fImpCc()
	fImpFil()
Elseif cCcAnt # SRA->RA_CC
	fImpCc()
Endif

Return Nil

*------------------------*
Static Function fImpFun()
*------------------------*
Local lRetu1 := .T.

cDet := " "+SRA->RA_FILIAL+" "+SRA->RA_CC+"    "+SRA->RA_MAT+"   "+Left(SRA->RA_NOME,30)+SPACE(09)
cDet += TRANSFORM(aPosicao1[1,1],"@E 999,999,999.99")+SPACE(5)+TRANSFORM(aPosicao1[1,3] - aPosicao1[1,1],"@E 999,999,999.99")+SPACE(5)
cDet += TRANSFORM(aPosicao1[1,3],"@E 999,999,999.99")
Impr(cDet,"C")

Return Nil

*-----------------------*
Static Function fImpCc()
*-----------------------*
Local lRetu1 := .T.

If Len(aTotCc1) == 0 .Or. nOrdem # 1
	Return Nil
Endif

Impr("","C")
cDet := STR0010+cFilialAnt+STR0011+cCcAnt+" - "+DescCc(cCcAnt,cFilialAnt)		//"FILIAL: "###" CCTO: "
cDet += Space(13)+STR0012			//"CUSTO BENEFICIARIO     CUSTO EMPRESA        CUSTO TOTAL  CESTA BASICA"
Impr(cDet,"C")

lRetu1 := fImpComp(aTotCc1,1) // Imprime

aTotCc1 :={}      // Zera

cDet := Repl("=",132)
Impr(cDet,"C")

//��������������������������������������������������������������Ŀ
//� Salta de Pagina na Quebra de Centro de Custo (lSalta = .T.)  �
//����������������������������������������������������������������
If lSalta
	Impr("","P")
Endif

Return Nil

*------------------------*
Static Function fImpFil()
*------------------------*
Local lRetu1 := .T.
Local cDescFil

If Len(aTotFil1) == 0
	Return Nil
Endif

cDescFil := aInfo[1] + Space(25)
cDet     := STR0013+cFilialAnt+" - "+cDescFil		//"FILIAL: "
cDet     += Space(09)+STR0014		//"CUSTO BENEFICIARIO     CUSTO EMPRESA        CUSTO TOTAL  CESTA BASICA"
Impr(cDet,"C")
Impr("","C")

lRetu1 := fImpComp(aTotFil1,1) // Imprime

aTotFil1 :={}      // Zera

cDet := Repl("#",132)
Impr(cDet,"C")
Impr("","P")

Return Nil

*------------------------*
Static Function fImpEmp()
*------------------------*
Local lRetu1 := .T.

If Len(aTotEmp1) == 0
	Return Nil
Endif

cDet := STR0015+aInfo[3]		//"Empresa: "
cDet += Space(13)+STR0016		//"CUSTO BENEFICIARIO     CUSTO EMPRESA        CUSTO TOTAL  CESTA BASICA"
Impr(cDet,"C")
Impr("","C")

lRetu1 := fImpComp(aTotEmp1,1) // Imprime

aTotEmp1 :={}      // Zera

Impr("","F")

Return Nil

*-------------------------------------------------------------------*
Static Function fImpComp(aPosicao,nLugar) // Complemento da Impressao
*-------------------------------------------------------------------*
//�������������������������������������������������������������Ŀ
//� aPosicao = Array Contendo o que vai ser impresso            �
//� nLugar   = Posicao Fisica dos Grupos de Impressao           �
//���������������������������������������������������������������
Local nResImp := 0
Local nPos    := 0
Local cCab1 , cCab2

//�������������������������������������������������������������Ŀ
//� Resultado de Impressao para testar se tudo nao esta zerado  �
//���������������������������������������������������������������
nPos := 1
AeVal(aPosicao,{ |X| nResImp += ( X[1] + X[2] + X[3] ) })  // Testa se a Soma == 0

//��������������������������������������������������������������Ŀ
//� Imprime se Possui Valores                                    �
//����������������������������������������������������������������
If nResImp > 0
	cDet := Space(65) + TRANSFORM(aPosicao[nPos,1],"@E 999,999,999.99")
	cDet += Space(05) + TRANSFORM(aPosicao[nPos,2],"@E 999,999,999.99")
	cDet += Space(05) + TRANSFORM(aPosicao[nPos,3],"@E 999,999,999.99")
	cDet += Space(05) + TRANSFORM(aPosicao[nPos,4],"@E 9999999")
	Impr(cDet,"C")
	Return ( .T. )
Else
	Return ( .F. )
Endif

*---------------------------------------------------------*
Static Function fAtuCont(aArray1)  // Atualiza Acumuladores
*---------------------------------------------------------*
Local x := 0
Local z := 1

If Len(aArray1) > 0
	For x:= 1 To 4
		aArray1[z,x] += aPosicao1[z,x]
	Next
Else
	aArray1 := Aclone(aPosicao1)
Endif

Return Nil

