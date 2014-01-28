#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function sf1100i()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
//Alterado por Danilo C S Pala em 20090109
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_AALIAS,_MENSNF,_CNOTA,_CSERIE,_CFORNECE,_CLOJA")
SetPrvt("_DDATA,_CSERVICO,_CNOME,_LGRAVOU,_ACRA,_CSAVSCR1")
SetPrvt("_CSAVCUR1,_CSAVROW1,_CSAVCOL1,_CSAVCOR1,_LEMFRENTE,NOPCA")
SetPrvt("CALERT,CMENS,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � SF1100I  � Autor � Jader Cezar T. Brito  � Data � 11/12/99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de entrada apos gravar cabecalho data nota fiscal de ���
���          � entrada SF1                                                ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Grinnel                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_aAlias := { Alias() , IndexOrd() , Recno() }

//��������������������������������������������������������������������������Ŀ
//� Definicao de variaveis                                                   �
//����������������������������������������������������������������������������
_MensNf := Space(125)

// traz conteudo das variaveis de memoria do modelo 2 da nota de entrada

_cNota   := cNFiscal
_cSerie  := cSerie
_CFORNECE := SPACE(6)
_cFornece:= SUBSTR(cA100For,1,6) //cA100For             // Cuidado com essa variavel !! Ela traz //20081009
//_cFornece:= Alltrim(_cFornece)   // o fornecedor como caracter de 12 posicoes...
_cLoja   := cLoja
_dData   := dDEmissao
_cServico:= "N"                                                   

If cTipo $ "DB"
	_cNome := SA1->A1_NOME
Else
	_cNome := SA2->A2_NOME
Endif

_lGravou := .F.

#IFDEF WINDOWS
      //���������������������������������������������������������������������Ŀ
      //� Criacao da Interface                                                �
      //�����������������������������������������������������������������������
      @ 158,84 To 300,726 Dialog oWinDlg Title OemToAnsi("Mensagem para ser Impressa na Nota Fiscal")
      @ 11,11 To 38,301 Title OemToAnsi("Mensagem para Nota : "+ _cNota + " " + _cSerie)
      @ 22,17 Get _MensNF Picture "@!S80" Size 275,10
      @ 250,160 BmpButton Type 1 Action Close(oWinDlg)
      Activate Dialog oWinDlg Centered

#ELSE
      _aCRA:= { "Confirma","Redigita","Abandona" }

      //��������������������������������������������������������������Ŀ
      //� Salva a Integridade dos dados de Entrada                     �
      //����������������������������������������������������������������
      _cSavScr1 := SaveScreen(3,0,24,79)
      _cSavCur1 := SetCursor(0)
      _cSavRow1 := Row()
      _cSavCol1 := COL()
      _cSavCor1 := SetColor("bg+/b,,,")
      _lEmFrente:= .T.
      //��������������������������������������������������������������Ŀ
      //� Monta Tela Inicial Do Programa                               �
      //����������������������������������������������������������������
      DispBegin()
      DrawAdvWin("Mensagem p/ N.F. de Entrada :"+ _cNota + " " + _cSerie, 10,0,18,79)

      SetColor("n/w,,,")
      @ 16,03 SAY Space(40) Color "b/w"
      DispEnd()

      //��������������������������������������������������������������Ŀ
      //� Descricao generica do programa                               �
      //����������������������������������������������������������������
      SetColor("b/bg")

      @ 14,03 Say "Mensagem p/ NFE :"

      While .T.

            @ 14,021 Get _MensNF Picture "@!S50"
            Read

            //��������������������������������������������������������������Ŀ
            //� Verifica as perguntas selecionadas                           �
            //����������������������������������������������������������������

            nOpcA:=menuh(_aCRA,16,4,"b/w,w+/n,r/w","CRA","",1)
            @ 16,03 SAY Space(71) Color "b/w"
            If nOpca == 2
               Loop
            ElseIf nOpcA == 3
               _lEmFrente:= .F.
            Endif

            Exit

      End-While

#ENDIF

If !Empty(_MensNF)
	dbSelectArea("SF1")
	dbSetOrder(1)
	If dbSeek(xFilial("SF1")+PADR(_cNota,9)+_cSerie+_cFornece+_cLoja) //20081009 //20090803 MP10
		RecLock("SF1",.F.)
		REPL F1_MENSNF  WITH _MensNf
		MsUnLock()
	Else
		cAlert:=OemToAnsi("Aten��o")
		cMens :=       OemToAnsi("Houve algum problema com a grava��o da")+chr(13)
		cMens :=cMens+ OemToAnsi("MENSAGEM da NOTA FISCAL no campo F1_MENSNF.")+chr(13)
		cMens :=cMens+ OemToAnsi("Entre em contato com o Depto de Informatica.")+chr(13)
        cMens :=cMens+ OemToAnsi("Rdmake: SF1100I.PRW, Linha: 063 ")+chr(13)
		Tone(3500,1)
        #IFDEF WINDOWS
           MsgAlert(cMens,cAlert)
        #ELSE
           Alert(cMens)
        #ENDIF
        Tone(3500,1)
	EndIf
EndIF

//20090109
if SD1->D1_RATEIO == "1"
	u_pcom001(_cNota,_cSerie,_cFornece,_cLoja, SF1->F1_VALBRUT)
endif          
//20090109 ate aqui

dbSelectArea(_aAlias[1])
dbSetOrder(_aAlias[2])
dbGoTo(_aAlias[3])

Return


