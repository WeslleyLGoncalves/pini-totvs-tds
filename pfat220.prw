#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

User Function pfat220()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CMSG1,_CMSG2,CPERG,_CPARBANCO,_CPARAGENC,_CPARCONTA")
SetPrvt("_CPARCARTE,_CPARNOTAI,_CPARNOTAF,_CPARSERIE,_NPARJUROS,_NPARDESCO")
SetPrvt("_CPARPARCE,_NPARPRAZO,NRESP,_LCONTINUA,_CPATHMERCANTIL,_CARQUIVO")
SetPrvt("_NHDL,_CMSG,_NCONTABOLETO,_CLIN,_LOK,_NSEQ")
SetPrvt("_CINCREMENTA,HEAD_001_A_001,HEAD_002_A_002,HEAD_003_A_009,HEAD_010_A_011,HEAD_012_A_026")
SetPrvt("HEAD_027_A_030,HEAD_031_A_045,HEAD_046_A_046,HEAD_047_A_076,HEAD_077_A_079,HEAD_080_A_094")
SetPrvt("HEAD_095_A_100,HEAD_101_A_389,HEAD_390_A_394,HEAD_395_A_400,_AHEADER,_N1")
SetPrvt("_LSAIDA,_CSERIE,_CMSGAVISO,_CERRORMSG,_CMSGERROR,_CMULTA")
SetPrvt("_CPRAZO,_CDESC,_CXMSG0,_CXMSG1,_CXMSG2,_CXMSG3")
SetPrvt("MSG_001_A_001,MSG_002_A_071,MSG_072_A_141,MSG_142_A_211,MSG_212_A_281,MSG_282_A_351")
SetPrvt("MSG_352_A_394,MSG_395_A_400,INST_001_A_001,INST_002_A_050,INST_051_A_099,INST_100_A_148")
SetPrvt("INST_149_A_197,INST_198_A_246,INST_247_A_295,INST_296_A_344,INST_345_A_393,INST_394_A_394")
SetPrvt("INST_395_A_400,_NSOMA,_AFATORES,_CAGENCIA,_CNUMEROBANCARIO,X")
SetPrvt("_NNR1,_NNR2,_NDIGITO,_SALIAS,AREGS,I")
SetPrvt("J,_N,")

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� Programa � PFAT220  � Autor � Gilberto A Oliveira � Data �Qui  30/11/00���
��������������������������������������������������������������������������Ĵ��
���Descri��o � Gera arquivo para impressao de boleto bancario.             ���
���          � Banco Banco Mercantil.                                      ���
��������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para Editora Pini Ltda.                          ���
��������������������������������������������������������������������������Ĵ��
���Outras    � ExecBlock("A220DET",.F.,.F.)                                ���
���Fun��es   �                                                             ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

//���������������������������������������������������������������������������Ŀ
//� Verifica as perguntas                                                     �
//���������������������������������������������������������������������������Ĵ
//� MV_PAR01    Banco            ?                                            �
//� MV_PAR02    Agencia          ?                                            �
//� MV_PAR03    Conta            ?                                            �
//� MV_PAR04    Carteira         ?                                            �
//� MV_PAR05    Da Nota Fiscal   ? -  Titulo  Inicial                         �
//� MV_PAR06    Ate Nota Fiscal  ? -  Titulo  Final                           �
//� MV_PAR07    Serie            ? -  Serie da Nota Fiscal                    �
//� MV_PAR08    Taxa de Juros/Dia? -  Taxa de Juros                           �
//� MV_PAR09    Desconto         ? -  Desconto em reais a ser aplicado ao tit.�
//� MV_PAR10    Parcelas         ? -  Parcelas do Titulo a serem impressas.   �
//� MV_PAR11    Dias p/Recebim.  ? -                                          �
//�����������������������������������������������������������������������������

_cMsg1:= "Esta rotina esta preparada APENAS para impressao de boletos do Banco Bco Mercantil. Verifique ..."
_cMsg2:= "Banco Bco Mercantil nao Encontrado no Cadastro de Parametros CNAB!!"

cPerg := "FAT220"
ValidPerg()
Pergunte(cPerg,.T.)

_cPARBanco:= MV_PAR01
_cPARAgenc:= MV_PAR02
_cPARConta:= MV_PAR03
_cPARCarte:= MV_PAR04
_cPARNotaI:= MV_PAR05
_cPARNotaF:= MV_PAR06
_cPARSerie:= MV_PAR07
_nPARJuros:= MV_PAR08
_nPARDesco:= MV_PAR09
_cPARParce:= MV_PAR10
_nPARPrazo:= MV_PAR11

//���������������������������������������������������������������������Ŀ
//� Montagem da tela													�
//�����������������������������������������������������������������������

#IFNDEF WINDOWS

	ScreenDraw("SMT250",3,0,0,0)

	@03,06 Say "Gera��o de Arquivo Texto           " Color "B/W"

	@11,08 Say " Este programa ir� gerar um arquivo texto, conforme os parame- " Color "B/BG"
	@12,08 Say " tros definidos  pelo usuario,  com os registros do arquivo de " Color "B/BG"
	@13,08 Say " contas a receber (SE1).  Este programa � um programa de exem- " Color "B/BG"
	@14,08 Say " plo, deve ser ajustado conforme o lay-out desejado.           " Color "B/BG"
	@17,04 Say Space(73) Color "B/W"

	While .T.

        nResp := MenuH({"Confirma","Abandona"},17,04,"b/w,w+/n,r/w","CA","",1)

		If nResp == 1

           _lContinua:= .T.

           FConsiste()
           If _lContinua
              BolMercantil()
              Exit
           Else
              Alert(_cMsg1)
           EndIf

        Else
			Return
		Endif

	EndDo

    Return

#ELSE

    @ 200,1 TO 380,395 DIALOG oDlg TITLE OemToAnsi("Geracao de Arquivo Texto")
	@ 02,10 TO 080,190
    @ 10,018 Say " Este programa ira gerar um arquivo texto, conforme os parame- "
	@ 18,018 Say " tros definidos  pelo usuario,  com os registros do arquivo de "
    @ 26,018 Say " contas a receber (SE1).  Este programa e um programa de exem- "
	@ 34,018 Say " plo, deve ser ajustado conforme o lay-out desejado.           "

    @ 60,070 BMPBUTTON TYPE 01 ACTION RunProc()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     @ 60,070 BMPBUTTON TYPE 01 ACTION Execute(RunProc)
    @ 60,110 BMPBUTTON TYPE 02 ACTION Close(oDlg)
    /// @ 60,150 BMPBUTTON TYPE 05 ACTION Pergunte(cPerg,.T.)

	Activate Dialog oDlg Centered

    Return

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     Function RunProc
Static Function RunProc()

             _lContinua:= .T.

             FConsiste()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>              Execute(FConsiste)

             If _lContinua
                BolMercantil()// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>                 Execute(BolMercantil)
             Else
                MsgBox(_cMsg1,"* * * ATENCAO * * *","STOP")
             EndIf

    Return

#ENDIF

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
��� Fun��o   �BolMercantil� Autor �Gilberto A Oliveira � Data � 24/07/2000  ���
���������������������������������������������������������������������������Ĵ��
���Descri��o � Funcao para continuacao do processamento (na confirmacao)    ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                           ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function BolMercantil
Static Function BolMercantil()

//��������������������������������������������������������������Ŀ
//� SEE - Comunica��o Remota p/guardar a Faixa Atual             �
//����������������������������������������������������������������

DbSelectArea("SEE")
DbSetOrder(1)
DbSeek(xFilial("SEE")+_cPARBanco+_cPARAgenc+_cPARConta)

If EOF()
   Help("",1,"NAOFAIXA")
   Return
Endif

_cPathMercantil:= Alltrim( GETMV("MV_MERCANT") )
_cArquivo:= Subs(cUsuario,7,3)+"0"+AllTrim(_cPARBanco)+".DAT"

//��������������������������������������������������������������Ŀ
//� Seleciona Ordem dos Arquivos                                 �
//����������������������������������������������������������������
DbSelectArea("SE1")
DbSetOrder(1)

DbSelectArea("SA1")
DbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� SF2 - Cabecalho de NF de Saida                               �
//����������������������������������������������������������������

DbSelectArea("SF2")
DbSetOrder(1)

DbSeek(xFilial("SF2")+_cPARNotaI,.T.)
ProcRegua( RecCount() )

If ( SF2->F2_DOC > _cPARNotaF ) .Or. ( SF2->F2_SERIE #_cPARSerie )
   #IFDEF WINDOWS
      MsgAlert("Nao foram encontrados Notas Fiscais para Impressao !! Verifique ...","Aten��o!")
   #ELSE
      Alert("Nao foram encontrados Notas Fiscais para Impressao !! Verifique ...")
   #ENDIF
   Return
EndIf

//���������������������������������������������������������������������Ŀ
//� Inicializa a regua de processamento 								�
//�����������������������������������������������������������������������

#IFDEF WINDOWS
	Processa({|| RunCont()},"Processando...")// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> 	Processa({|| Execute(RunCont)},"Processando...")
	Return
// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>     Function RunCont
Static Function RunCont()
	ProcRegua(RecCount())
#ELSE
	SetRegua(RecCount())
#ENDIF

//���������������������������������������������������������������������Ŀ
//� Processamento														�
//�����������������������������������������������������������������������

_nHdl:=FCreate(_cArquivo)

If _nHdl == -1

   _cMsg:= "O arquivo de nome "+_cArquivo+" n�o pode ser criado! Verifique os par�metros."
   #IFNDEF WINDOWS
      Alert(_cMsg)
   #ELSE
       MsgAlert(_cMsg,"Aten��o!")
   #ENDIF

   Return

Endif

_nContaBoleto:= 0

//������������������������������������������������������������ͻ
//� HEADER.                                                    �
//������������������������������������������������������������ͼ
_cLin       :=""
_lOk        :=.T.
_nSeq       := 1
_cIncrementa:= Strzero(_nSeq,6)

Head_001_a_001:= "0"                              //1
Head_002_a_002:= "1"                              //1
Head_003_a_009:= "REMESSA"                        //7
Head_010_a_011:= PadL(AllTrim(_cPARCarte),2)      //6
Head_012_a_026:= PadR("COBRANCA",15," ")          //15
Head_027_a_030:= Alltrim(_cPARAgenc)              //4
Head_031_a_045:= StrZero(Val(SM0->M0_CGC),15)     //15
Head_046_a_046:= "0"                              //1
Head_047_a_076:= SubStr(SM0->M0_NOMECOM,1,30)
Head_077_a_079:= Alltrim(_cPARBanco)
Head_080_a_094:= "BANCO MERCANTIL"
Head_095_a_100:= GravaData(dDataBase,.F.)
Head_101_a_389:= Space(289)
Head_390_a_394:= Repl("0",5)
Head_395_a_400:= "000001"

_aHeader:={}
AADD(_aHeader,Head_001_a_001)
AADD(_aHeader,Head_002_a_002)
AADD(_aHeader,Head_003_a_009)
AADD(_aHeader,Head_010_a_011)
AADD(_aHeader,Head_012_a_026)
AADD(_aHeader,Head_027_a_030)
AADD(_aHeader,Head_031_a_045)
AADD(_aHeader,Head_046_a_046)
AADD(_aHeader,Head_047_a_076)
AADD(_aHeader,Head_077_a_079)
AADD(_aHeader,Head_080_a_094)
AADD(_aHeader,Head_095_a_100)
AADD(_aHeader,Head_101_a_389)
AADD(_aHeader,Head_390_a_394)
AADD(_aHeader,Head_395_a_400)
For _n1:= 1 to Len(_aHeader)
    _cLin:=_cLin +  _aHeader[_n1]
Next
_cLin:= _cLin+CHR(13)+CHR(10)
FWrite( _nHdl,_cLin,Len(_cLin) )

_lSaida:= .F.
While !EOF() .And. SF2->F2_DOC <= _cPARNotaF .And. xFilial("SF2") == SF2->F2_FILIAL

      //���������������������������������������������������������������������Ŀ
      //� Incrementa a regua                                                  �
      //�����������������������������������������������������������������������

      #IFNDEF WINDOWS
          IncRegua()
      #ELSE
          IncProc()
      #ENDIF

      //��������������������������������������������������������������Ŀ
      //� Identifica a serie da nota                                   �
      //����������������������������������������������������������������
      If SF2->F2_SERIE #_cPARSerie           // Se a Serie do Arquivo for Diferente
         DbSkip()                             // do Parametro Informado !!!
         Loop
      Endif

      //��������������������������������������������������������������Ŀ
      //� SE1 - Contas a Receber                                       �
      //����������������������������������������������������������������

      _cSerie:= _cPARSerie

      DbSelectArea("SE1")
      DbSetOrder(1)

      If DbSeek( xFilial("SE1") + _cSERIE + SF2->F2_DOC )

         While !Eof() .And. SE1->E1_FILIAL+SE1->E1_NUM==xFilial("SE1")+SF2->F2_DOC

               If Alltrim(SE1->E1_TIPO) != "NF" .Or. SE1->E1_PREFIXO != _cSerie
                  DbSelectArea("SE1")
                  DbSkip()
                  Loop
               Endif

               IF _cPARParce <> "."
                  IF !(SE1->E1_PARCELA $ _cPARParce )
                     DbSelectArea("SE1")
                     DbSkip()
                     Loop
                  ENDIF
               ENDIF

               If SE1->E1_SITUACA #"0"
                  _cMsgAviso:="Aten��o: O titulo "+SE1->E1_NUM+SE1->E1_PARCELA+" "+SE1->E1_SERIE
                  _cMsgAviso:=_cMsgAviso+" esta fora de CARTEIRA, transferido para o Banco "+Alltrim(SE1->E1_PORTADO)+"."
                  _cMsgAviso:=_cMsgAviso+" Para reemitir esse boleto solicite a cobran�a que transfira o "
                  _cMsgAviso:=_cMsgAviso+" titulo para carteira."
                  #IFNDEF WINDOWS
                     Alert(_cMsgAviso)
                  #ELSE
                     MsgInfo( OemToAnsi(_cMsgAviso ) )
                  #ENDIF
                  DbSkip()
                  Loop
               EndIf

               //����������������������������������������������������������Ŀ
               //� Verifica se ja foi emitido boleto para esse titulo por   �
               //� outro banco.                                             �
               //������������������������������������������������������������

               /*/
               If SE1->E1_BOLEM == "S"
                  If AllTrim(SE1->E1_PORTADO) #AllTrim( _cPARBanco )
                     If AllTrim(SE1->E1_PORTADO) #"CX1"
                        If SA6->( dbSeek(xFilial("SA6")+SE1->E1_PORTADO) )
                           _cErrorMsg:= "Ja foi Emitido Boleto para esse Titulo !!!"
                           _cMsgError:= "TITULO "+SE1->E1_NUM+" - "+SE1->E1_PARCELA + " SERIE " + _cSerie
                           _cMsgError:= _cMsgError+" com Boleto Emitido para o Banco : "
                           _cMsgError:= _cMsgError+Alltrim(SE1->E1_PORTADO)+" Agencia : "+SE1->E1_AGEDEP+ " Cta. Corrente : "
                           _cMsgError:= _cMsgError+SE1->E1_CONTA
                           _cMsgError:= _cMsgError+" Por favor, para esse t�tulo entre no Banco Correspondente..."
                           #IFNDEF WINDOWS
                              Alert(_cErrorMsg)
                              Alert(_cMsgError)
                           #ELSE
                              MsgAlert(OemToAnsi(_cErrorMsg),OemToAnsi("Aten��o"))
                              MsgAlert(OemToAnsi(_cMsgError),OemToAnsi("Aten��o"))
                           #ENDIF
                           DbSkip()
                           Loop
                        Endif
                     Endif
                  Endif
               Endif
               /*/
               //����������������������������������������������������������Ŀ
               //� CONSISTENCIA PARA IMPEDIR QUE SEJA IMPRESSO BOLETO DE    �
               //� TITULOS QUE NAO GERAM BOLETO. TITULOS A VISTA E OUTROS.  �
               //������������������������������������������������������������

               DbSelectArea("SC5")
               DbSetOrder(5)
               DbSeek(xFilial("SC5")+SF2->F2_DOC+_cSERIE)

               If Found()

                  DbSelectArea("SZ9")
                  DbSetOrder(1)
                  DbSeek(xFilial("SZ9")+SC5->C5_TIPOOP)

                  If SZ9->Z9_QTDEP == 1
                     If SE1->E1_PARCELA == "A" .Or. SE1->E1_PARCELA == " "
                        If SZ9->Z9_BOLETO1 == "N" .OR. SZ9->Z9_BOLETO1 == " "
                           DbSelectArea("SE1")
                           DbSkip()
                           Loop
                        EndIf
                     Endif
                  Else
                     If SE1->E1_PARCELA == "A" .Or. SE1->E1_PARCELA == " "
                        If SZ9->Z9_BOLETO1 == "N" .OR. SZ9->Z9_BOLETO1 == " "
                           DbSelectArea("SE1")
                           DbSkip()
                           Loop
                        EndIf
                     Else
                        If SZ9->Z9_BOLETOD == "N" .OR. SZ9->Z9_BOLETOD == " "
                           DbSelectArea("SE1")
                           DbSkip()
                           Loop
                        EndIf
                     Endif
                  Endif
               Else
                  DbSelectArea("SE1")
                  DbSkip()
                  Loop
               EndIf

               DbSelectArea("SE1")

               //�������������������������������������������������������������ͻ
               //� DETALHE.                                                    �
               //�������������������������������������������������������������ͼ
               _cLin:= ""
               _cLin:= ExecBlock( "A220DET",.F.,.F.)
               FWrite( _nHdl,_cLin,Len(_cLin))

               //�������������������������������������������������������������ͻ
               //� MENSAGENS.                                                  �
               //�������������������������������������������������������������ͼ
               _nSeq:= _nSeq + 1
               _cIncrementa:= StrZero(_nSeq,6)
               _nPARPrazo  := Iif(empty(_nPARPrazo),10,_nPARPrazo)
               _cMulta     := Alltrim(Str((SE1->E1_VALOR * _nPARJuros)/100,10,2))
               _cPrazo     := DtoC( SE1->E1_VENCTO + _nPARPrazo )                    /// anteriormente era fixado em 10 dias...
               _cDesc      := Alltrim(Str(_nPARDesco,10,2))
               _cXMsg0     := "PAGAVEL EM QUALQUER BANCO ATE O VENCIMENTO"
               _cXMsg1     := iif(_nPARJuros > 0 , "COBRAR R$ "+_cMulta+" POR DIA DE ATRASO." , Space(2) )
               _cXMsg2     := "NAO RECEBER APOS O DIA "+_cPrazo
               _cXMsg3     := iif(_nPARDesco > 0 , "CONCEDER DESCONTO DE R$ "+_cDesc, Space(2) )

               Msg_001_a_001:= "2"
               Msg_002_a_071:= PadR(_cXMsg0,070," ")
               Msg_072_a_141:= Padr(_cXMsg1,070," ")
               Msg_142_a_211:= Padr(_cXMsg2,070," ")
               Msg_212_a_281:= Padr(_cXMsg3,070," ")
               Msg_282_a_351:= Space(70)
               Msg_352_a_394:= Space(43)
               Msg_395_a_400:= _cIncrementa

               _cLin:=Msg_001_a_001+;        // C�digo do registro=  "2".
                      Msg_002_a_071+;        // Mensagem 01.
                      Msg_072_a_141+;        // Mensagem 02.
                      Msg_142_a_211+;        // Mensagem 03.
                      Msg_212_a_281+;        // Mensagem 04.
                      Msg_282_a_351+;        // Mensagem 05.
                      Msg_352_a_394+;        // Brancos.
                      Msg_395_a_400+;        // N�mero Sequencial do registro.
                      CHR(13)+CHR(10)

               FWrite( _nHdl,_cLin,Len(_cLin) )

               //�������������������������������������������������������������ͻ
               //� INSTRUCOES.                                                 �
               //�������������������������������������������������������������ͼ
               _nSeq:= _nSeq + 1
               _cIncrementa:= StrZero(_nSeq,6)

               Inst_001_a_001:= "3"
               Inst_002_a_050:= Left(PadR(_cXMsg0,049," "),49)
               Inst_051_a_099:= Left(Padr(_cXMsg1,049," "),49)
               Inst_100_a_148:= Left(Padr(_cXMsg2,049," "),49)
               Inst_149_a_197:= Left(Padr(_cXMsg3,049," "),49)
               Inst_198_a_246:= Space(49)
               Inst_247_a_295:= Space(49)
               Inst_296_a_344:= Space(49)
               Inst_345_a_393:= Space(49)
               Inst_394_a_394:= Space(01)
               Inst_395_a_400:= _cIncrementa

               _cLin:=Inst_001_a_001+;        // C�digo do registro=  "2".
                      Inst_002_a_050+;        // Instrucoes 1.
                      Inst_051_a_099+;        // Instrucoes 2.
                      Inst_100_a_148+;        // Instrucoes 3.
                      Inst_149_a_197+;        // Instrucoes 4.
                      Inst_198_a_246+;        // Instrucoes 5.
                      Inst_247_a_295+;        // Instrucoes 6.
                      Inst_296_a_344+;        // Instrucoes 7.
                      Inst_345_a_393+;        // Instrucoes 8.
                      Inst_394_a_394+;        // Espaco
                      Inst_395_a_400+;        // N�mero Sequencial do registro.
                      CHR(13)+CHR(10)

               FWrite( _nHdl,_cLin,Len(_cLin) )
      
               _nContaBoleto:= _nContaBoleto + 1
               #IFNDEF WINDOWS
                   @ 14,05 Say " Gerando Boleto Nr. : "+StrZero( _nContaBoleto,5 )
               #ELSE
                   IncProc( "Gerando Boleto Nr.: "+StrZero( _nContaBoleto,5) )
               #ENDIF

               //�������������������������������������������������������������ͻ
               //� Gravar Faixa Atual                                          �
               //�������������������������������������������������������������ͼ


               DbSelectArea("SE1")
               RecLock("SE1",.F.)
//             SE1->E1_PORTADO:= Alltrim(_cPARBanco)     // Banco...
//             SE1->E1_AGEDEP := Alltrim(_cPARAgenc)     // Agencia...
//             SE1->E1_CONTA  := Alltrim(_cPARConta)     // Conta Corrente
//             SE1->E1_BOLEM  := "S"
//             SE1->E1_SITUACA:= "1"
//             SE1->E1_HIST   := Iif( _nPARDesco > 0, "DESCONTO DE R$ "+Alltrim(Str(_nPARDesco,10,2)), SE1->E1_HIST )

               // Nosso Numero sendo gravado na Rotina Externa A220DET.PRX

               SE1->(MsUnLock())

               _lSaida:= .T.

               DbSelectArea("SE1")
               DbSkip()

         Enddo

      Else

         _cMsg:= "Duplicata nao Encontrada !!! Verifique se os TES's utilizados geram duplicata"
         _cMsg:= _cMsg+" ou seu houve algum problema durante o faturamento..."
         #IFNDEF WINDOWS
            Alert(_cMsg)
         #ELSE
            MsgBox(_cMsg,"* * * ATENCAO * * *","STOP")
         #ENDIF
         Exit

      EndIf

      DbSelectArea("SF2")
      DbSkip()

End-While

If !(_lSaida)

   _cMsg:= "Nao haviam registros para geracao do boleto. Verifique ..."
   #IFDEF WINDOWS
      MsgStop( _cMsg )
   #ELSE
      Alert( _cMsg )
   #ENDIF

Else

   //������������������������������������������������������������������ͻ
   //� GRAVA TRAILLER.                                                  �
   //������������������������������������������������������������������ͼ

   _cIncrementa:= StrZero(_nSeq+2,6)
   _cLin:= "9"+Space(393)+_cIncrementa+CHR(13)+CHR(10)

   fWrite( _nHdl , _cLin , Len(_cLin) )
   fClose(_nHdl)

   //������������������������������������������������������������������ͻ
   //� IMPRESSAO DOS BOLETOS.                                           �
   //������������������������������������������������������������������ͼ
   // Copy File ("\SIGA\SIGAADV\"+_cArquivo) To (_cPathMercantil+_cArquivo)
   ALERT( _CARQUIVO )
   ALERT( _CPATHMERCANTIL+_CARQUIVO)
   Copy File (_cArquivo) To (_cPathMercantil+_cArquivo)

   FErase(_cArquivo)

   #IFDEF WINDOWS
      If MsgYesNo("Arquivo gerado com sucesso. Deseja imprimir o boleto ?", "Atencao")
   //    WinExec("Bco Mercantil.BAT "+_cArquivo+" >Nul",2 )
   //    RUN C:\BMB\COBRANCA\BMBEM400.EXE
         Processa({|| GANHATEMPO()},"Gerando arquivo de boleto ...")// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==>          Processa({|| Execute(GANHATEMPO)},"Gerando arquivo de boleto ...")
         MsgInfo( "FIM DA IMPRESSAO !!!" )
      Endif
   #ELSE
      If Alert("Arquivo gerado com sucesso. Deseja carregar impressor de boletos ?",{"Sim","N�o"}) == 1
         Run ("C:\BMB\COBRANCA\BMBEM400.EXE")
         Run ("CD\SIGATST\SIGAADV\")
      Endif
   #ENDIF
EndIf

fClose(_nHdl)

Return

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���Fun��o    �EXIBI_ALERTA� Autor �Gilberto A de Oliveira � Data � 28/07/00 ���
���������������������������������������������������������������������������Ĵ��
���Uso       � Funcao de apoio para exibicao de mensagem.                   ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function Exibi_Alerta
Static Function Exibi_Alerta()
#IFNDEF WINDOWS
    If Alert("Ocorreu um erro na grava��o do arquivo "+_cArquivo+" Continua?",{"Sim","N�o"}) == 2
       _lOk:= .F.
    Endif
#ELSE
    If !MsgAlert("Ocorreu um erro na grava��o do arquivo "+_cArquivo+".   Continua?","Aten��o!")
       _lOk:= .F.
    Endif
#ENDIF
Return

************************************************************************
***  Calculo do Digito Verificador.                                  ***
************************************************************************

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function CalculaDigito
Static Function CalculaDigito()

***
***
*** Formula Bco Mercantil : O n�mero banc�rio � composto por 3 partes
*** - 3 (tres) d�gitos para o n�mero da �gencia (constante);
*** - 7 (sete) d�gitos para a numera��o sequencial; e
*** - 1 (um) d�gito verificador.
***
*** Variavel "_nFaixaAtu" deve conter o valor de SEE->EE_FAXATU
***
***

_nSoma:= 0
_aFatores:={7,3,1,9,7,3,1,9,7,3}

_cAgencia:= "001"
_cNumeroBancario:= alltrim(_cAgencia + Strzero(_nFaixaAtu,7) )

For x:= 1 to Len(_aFatores)
    _nNr1:= Val( Subs(_cNumeroBancario,x,1) )
    _nNr2:= Val( Right( Str(_aFatores[x]*_nNr1,2),1) )
    _nSoma:= _nSoma + _nNr2
Next

if _nSoma <> 10
   _nDigito:= 10 - Val( Right( Str(_nSoma,2),1 ))
else
   _nDigito:= 0
endif

_cNumeroBancario:= _cNumeroBancario + str(_nDigito,1)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 �VALIDPERG � Autor �  Luiz Carlos Vieira	� Data � 18/11/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam		  ���
�������������������������������������������������������������������������Ĵ��
���Uso		 � Espec�fico para clientes Microsiga						  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function ValidPerg
Static Function ValidPerg()

_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs:={}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
Aadd(aRegs,{cPerg,"01","Banco             ?","mv_ch1","C",03,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","SA6"})
Aadd(aRegs,{cPerg,"02","Agencia           ?","mv_ch2","C",05,0,0,"G","","MV_PAR02","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"03","Conta             ?","mv_ch3","C",10,0,0,"G","","MV_PAR03","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"04","Carteira          ?","mv_ch4","C",06,0,0,"G","","MV_PAR04","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"05","Da Nota Fiscal    ?","mv_ch5","C",06,0,0,"G","","MV_PAR05","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"06","Ate Nota Fiscal   ?","mv_ch6","C",06,0,0,"G","","MV_PAR06","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"07","Serie             ?","mv_ch7","C",03,0,0,"G","","MV_PAR07","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"08","Taxa de Juros/Dia ?","mv_ch8","N",05,2,0,"G","","MV_PAR08","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"09","Desconto          ?","mv_ch9","N",10,2,0,"G","","MV_PAR09","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"10","Parcelas          ?","mv_chA","C",10,0,0,"G","","MV_PAR10","","","","","","","","","","","","","",""})
Aadd(aRegs,{cPerg,"11","Dias p/Recebimento?","mv_chB","N",02,0,0,"G","","MV_PAR11","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
	If !dbSeek(cPerg+aRegs[i,2])
		RecLock("SX1",.T.)
		For j:=1 to FCount()
			If j <= Len(aRegs[i])
				FieldPut(j,aRegs[i,j])
			Endif
		Next
		SX1->(MsUnlock())
	Endif
Next

dbSelectArea(_sAlias)

Return

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function GANHATEMPO
Static Function GANHATEMPO()
ProcRegua(1000)
For _n := 1 to 1000
    IncProc()
Next
Return

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function FCONSISTE
Static Function FCONSISTE()

If Alltrim(_cPARBanco) #"389"
   _cMsg1:= "A Banco para essa rotina deve ser o 389 (Bco Mercantil). Verifique !!!"
   _lContinua:= .F.
Endif
If Alltrim(_cPARAgenc) #"0081"
   _cMsg1:= "A Agencia para este Banco so podera ser 0081. Verifique !!!"
   _lContinua:= .F.
EndIf
If Alltrim(_cPARConta) #"0030674"
   _cMsg1:= "A Conta Corrente so podera ser 0030674. Verifique !!!"
   _lContinua:= .F.
EndIf

Return
