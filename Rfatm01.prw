#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Rfatm01()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CEMPRESA,_CPATH,_AESTRU,_ACAMPOSC6,_ACAMPOSC5,_NITEM")
SetPrvt("_CARQSC5,_CARQSC6,_CARQIND,CCOND,_CNUMERO,_CCHAVE")
SetPrvt("_LGERADO,_CCONDPAG,_NPRECO,_NEDINI,_NEDFIN,_DDTINI")

/*/

�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATM01   �Autor: Fabio William          � Data:   07/07/97 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Cria Pedido de Venda p/ Edicao de Vencimento               � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
������������������������������������������������������������������������Ĵ ��
���Objetivo : Gerar o pedido de venda na empresa corrente para as edicoes� ��
���         : que estao vencendo.                                        � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//��������������������������������������¿
//��   MV_PAR01  Revista de             ��
//��   MV_PAR02  Revista ate            ��
//��   MV_PAR03  Mes Ref.               ��
//��   MV_PAR04  Acao                   ��
//��   MV_PAR05  Cond. Pgto a Vista     ��
//��   MV_PAR06  Cond. Pgto a Prazo     ��
//����������������������������������������

pergunte("FATM01",.F.)

// ���������������������������������͸
// �  Defines variaveis correntes    �
// ���������������������������������;
_cEmpresa  := "010" // Empresa que sera extraido os pedidos
_cpath     := "\SIGA\DADOSADV\"
_aEstru    := {}    // Estrutura do SC6
_acamposc6 := {}    // campos que serao passados ao SC6
_acamposc5 := {}    // campos que serao passados ao SC6
_nItem     := 0     // Contador do numero de itens

#IFDEF WINDOWS
   @ 96,42 TO 323,505 DIALOG oDlg5 TITLE "Rotina de Geracao Pedido"
   @ 8,10 TO 84,222
   @ 91,139 BMPBUTTON TYPE 5 ACTION Pergunte("FATM01")
   @ 91,168 BMPBUTTON TYPE 1 ACTION OkProc()// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    @ 91,168 BMPBUTTON TYPE 1 ACTION Execute(OkProc)
   @ 91,196 BMPBUTTON TYPE 2 ACTION Close(oDlg5)
   @ 23,14 SAY "Este programa ira gerar os Pedidos de Venda, baseado na data da vencimento."
   @ 33,14 SAY "   - Ok - Dispara a Geracao "
//   @ 43,14 SAY "   -ProcRegua() - Ajusta tamanho da regua"
//   @ 53,14 SAY "   -IncProc() - Incrementa posicao da regua"
   ACTIVATE DIALOG oDlg5
   Return
#ELSE

   DrawAdvWin("Rotina de Geracao Pedido " , 8, 0, 12, 75 )
   @ 10, 5 Say " A G U A R D E "
   @ 11, 5 say 'lendo registro ' +str(recno(),6)
   Pergunte("FATM01",.T.)
   OkProc()
   Return

#ENDIF



/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: OKPROC    �Autor: Fabio William          � Data:   07/07/97 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Processamento                                              � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
������������������������������������������������������������������������Ĵ ��
���Objetivo :                                                            � ��
���         :                                                            � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function Okproc
Static Function Okproc()
#IFDEF WINDOWS
  Close(oDlg5)
#ENDIF


// ���������������������������������͸
// �  Abre os Arquivos               �
// ���������������������������������;

_cArqSC5 := _cPath + "SC5"+ _cEmpresa + ".dbf"
dbUseArea( .T.,,_cArqSC5, "TRBSC5", if(.T. .OR. .F., !.F., NIL), .F. )

_cArqSC6 := _cPath + "SC6"+ _cEmpresa + ".dbf"
dbUseArea( .T.,,_cArqSC6, "TRBSC6", if(.T. .OR. .F., !.F., NIL), .F. )

// ���������������������������������͸
// �  Indexa o arquivo de trabalho   �
// ���������������������������������;
DbSelectArea("TRBSC6")
_cArqInd := CriaTrab(nil,.F.)
cCond  := ""
cCond  := cCond+"Month(C6_DTFIN) == Val('"+Str(Month(mv_par03),2)+"')"
cCond  := cCond+" .and. STR(year(C6_DTFIN),4) == '"+STR(year(mv_par03),4)+"'"
cCond  := cCond+" .and. Subs(C6_PRODUTO,1,4) >= '"+MV_PAR01+"'"
cCond  := cCond+" .and. Subs(C6_PRODUTO,1,4) <= '"+MV_PAR02+"'"
DBSelectArea("TRBSC6")
IndRegua("TRBSC6",_cArqInd,"C6_FILIAL+C6_NUM+C6_ITEM",,cCond,"Selecionando Registros")

_cArqInd := CriaTrab(nil,.F.)
DBSelectArea("TRBSC5")
IndRegua("TRBSC5",_cArqInd,"C5_FILIAL+C5_NUM",,,"Selecionando Registros")


DbSelectArea("TRBSC6")
#IFNDEF WINDOWS
   SetRegua(Reccount())
#ENDIF
Do While !eof()



// Condicao a Vista

   #IFNDEF WINDOWS
      IncRegua()
   #ENDIF
// ���������������������������������͸
// �  Obtem o Numero do Pedido       �
// ���������������������������������;
   _cNumero := GetSx8Num("SC5")
   ConfirmSX8()


// ��������������������������������������͸
// �  Obtem o Processa 1� Pedido A Vista  �
// ��������������������������������������;
   DbSelectArea("TRBSC5")
   DbSeek(TRBSC6->C6_FILIAL+TRBSC6->C6_NUM)


   DbSelectArea("TRBSC6")
   _cChave := TRBSC6->C6_FILIAL+TRBSC6->C6_NUM
   _nItem  := 0
   _lGerado := .f.

   Do While TRBSC6->C6_FILIAL+TRBSC6->C6_NUM == TRBSC5->C5_FILIAL+TRBSC5->C5_NUM .and. !eof()
      // �������������������������������������������Ŀ
      // �  Variavel que controla a Geracao          �
      // ���������������������������������������������

      _lGerado := .t.

      _nItem := _nitem + 1
      AppSC6()

      DbSelectArea("TRBSC6")
      DbSkip()
   Enddo


   // �������������������������������������������Ŀ
   // �  Gera SC5 somente se                      �
   // ���������������������������������������������
   if _lGerado
      _cCondPag := MV_PAR05  // Pagamento a Vista
      DbSelectArea("SC5")
      Appsc5()
   Else
      DbSelectArea("SC6")
      DbSkip()
   Endif
   DbSelectArea("SC6")

// ���������������������������������������������������Ŀ
// �    Condicao a Prazo                               �
// �����������������������������������������������������


   #IFNDEF WINDOWS
      IncRegua()
   #ENDIF
// ���������������������������������͸
// �  Obtem o Numero do Pedido       �
// ���������������������������������;
   _cNumero := GetSx8Num("SC5")
   ConfirmSX8()


// ��������������������������������������͸
// �  Obtem o Processa 1� Pedido A prazo  �
// ��������������������������������������;
   DbSelectArea("TRBSC6")
   DbSeek(_cChave)


   DbSelectArea("TRBSC6")
   _cChave := TRBSC6->C6_FILIAL+TRBSC6->C6_NUM
   _nItem  := 0
   _lGerado := .f.

   Do While TRBSC6->C6_FILIAL+TRBSC6->C6_NUM == TRBSC5->C5_FILIAL+TRBSC5->C5_NUM .and. !eof()
      // �������������������������������������������Ŀ
      // �  Variavel que controla a Geracao          �
      // ���������������������������������������������

      _lGerado := .t.

      _nItem := _nitem + 1
      _nPreco := ZZ5->ZZ5_APRAZ
      AppSC6()

      DbSelectArea("TRBSC6")
      DbSkip()
   Enddo


   // �������������������������������������������Ŀ
   // �  Gera SC5 somente se                      �
   // ���������������������������������������������
   if _lGerado
      _cCondPag := MV_PAR06  // Pagamento a PRAZO
      DbSelectArea("SC5")
      Appsc5()
   Else
      DbSelectArea("SC6")
      DbSkip()
   Endif
   DbSelectArea("SC6")

Enddo
DbSelectArea("TRBSC5")
DbCloseArea()
DbSelectArea("TRBSC6")
DbCloseArea()


Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function AppSc6
Static Function AppSc6()

    // �������������������������������������������Ŀ
    // �  Busca o preco da Revista para a Campanha �
    // ���������������������������������������������
    DbSelectArea("ZZ5")
    DbSeek(xFilial()+SUBS(TRBSC6->C6_PRODUTO,4)+MV_PAR04)


    _nPreco := ZZ5->ZZ5_PRCAV

   // �����������������������������������������������Ŀ
   // �  Posiciona o Cadastro de Produtos             �
   // �������������������������������������������������
   DbSelectArea("SB1")
   DbSetOrder(01)
   DbSeek(xFilial()+TRBSC6->C6_PRODUTO)
   // �����������������������������������������������Ŀ
   // �  Busca a Data da Circulacao da Proxima Revista�
   // �������������������������������������������������
   _nEdIni := TRBSC6->C6_EDFIN + 1
   _nEdFin := _nEdIni + SB1->B1_QTDEEX
   DbSelectArea("SZJ")
   // �����������������������������������������������Ŀ
   // � Busca a Data Inicial da Circulacao da  Revista�
   // �������������������������������������������������
   DbSeek(Subs(TRBSC6->C6_PRODUTO,1,4)+STR(_nEdIni,4))
   _dDtIni := SZJ->ZJ_DTCIRC
   // �����������������������������������������������Ŀ
   // � Busca a Data Final da Circulacao  da   Revista�
   // �������������������������������������������������
   DbSeek(Subs(TRBSC6->C6_PRODUTO,1,4)+STR(_nEdFin,4))


   DbSelectArea("SC6")
   RecLock("SC6",.T.)
   // ��������������������������������������͸
   // �  Atualiza os dados Principais        �
   // ��������������������������������������;
   SC6->C6_FILIAL    :=   xFilial("SC6")
   SC6->C6_ITEM      :=   StrZero(_nItem,2)
   SC6->C6_NUM       :=   _cNumero
   SC6->C6_NOTA      :=   " "
   SC6->C6_SERIE     :=   " "
   SC6->C6_QTDLIB    :=   0
   SC6->C6_ENTREG    :=   dDataBase
   SC6->C6_QTDEMP    :=   0
   SC6->C6_QTDENT    :=   0
   SC6->C6_QTDVEN    :=   1
   SC6->C6_PRUNIT    :=   _nPreco
   SC6->C6_PRCVEN    :=   _nPreco
   SC6->C6_VALOR     :=   _nPreco
   SC6->C6_PEDANT    :=   TRBSC6->C6_NUM


   SC6->C6_COMIS1    :=   TRBSC6->C6_COMIS1
   SC6->C6_COMIS2    :=   TRBSC6->C6_COMIS2
   SC6->C6_COMIS3    :=   TRBSC6->C6_COMIS3
   SC6->C6_COMIS4    :=   TRBSC6->C6_COMIS4
   SC6->C6_COMIS5    :=   TRBSC6->C6_COMIS5


   // ��������������������������������������͸
   // �  Atualiza os dados das edicoes       �
   // ��������������������������������������;
   SC6->C6_EDVENC    :=   _nEdFin
   SC6->C6_EDSUSP    :=   _nEdIni
   SC6->C6_EDINIC    :=   _nEdIni
   SC6->C6_EDFIN     :=   _nEdFin
   SC6->C6_DTCIRC    :=   SZJ->ZJ_DTCIRC
   SC6->C6_EDICAO    :=   0
   SC6->C6_EDREAB    :=   0
   SC6->C6_DTINIC    :=   _dDtIni
   SC6->C6_DTFIN     :=   SZJ->ZJ_DTCIRC
   SC6->C6_DTCANC    :=   stod("")
   SC6->C6_DTENVIO   :=   stod("")

   // ��������������������������������������͸
   // �  mantem o restante como padrao       �
   // ��������������������������������������;
   SC6->C6_PRODUTO   :=   TRBSC6->C6_PRODUTO
   SC6->C6_UM        :=   TRBSC6->C6_UM
   SC6->C6_TES       :=   TRBSC6->C6_TES
   SC6->C6_CF        :=   TRBSC6->C6_CF
   SC6->C6_SEGUM     :=   TRBSC6->C6_SEGUM
   SC6->C6_LOCAL     :=   TRBSC6->C6_LOCAL
   SC6->C6_UNSVEN    :=   TRBSC6->C6_UNSVEN
   SC6->C6_QTDENT    :=   TRBSC6->C6_QTDENT
   SC6->C6_CLI       :=   TRBSC6->C6_CLI
   SC6->C6_DESCONT   :=   TRBSC6->C6_DESCONT
   SC6->C6_VALDESC   :=   TRBSC6->C6_VALDESC
   SC6->C6_ENTREG    :=   TRBSC6->C6_ENTREG
   SC6->C6_LA        :=   TRBSC6->C6_LA
   SC6->C6_LOJA      :=   TRBSC6->C6_LOJA
   SC6->C6_DATFAT    :=   TRBSC6->C6_DATFAT
   SC6->C6_PEDCLI    :=   TRBSC6->C6_PEDCLI
   SC6->C6_DESCRI    :=   TRBSC6->C6_DESCRI
   SC6->C6_PRUNIT    :=   TRBSC6->C6_PRUNIT
   SC6->C6_BLOQUEI   :=   TRBSC6->C6_BLOQUEI
   SC6->C6_GEROUPV   :=   TRBSC6->C6_GEROUPV
   SC6->C6_RESERVA   :=   TRBSC6->C6_RESERVA
   SC6->C6_OP        :=   TRBSC6->C6_OP
   SC6->C6_OK        :=   TRBSC6->C6_OK
   SC6->C6_NFORI     :=   TRBSC6->C6_NFORI
   SC6->C6_SERIORI   :=   TRBSC6->C6_SERIORI
   SC6->C6_NUMLOTE   :=   TRBSC6->C6_NUMLOTE
   SC6->C6_PICMRET   :=   TRBSC6->C6_PICMRET
   SC6->C6_IDENTB6   :=   TRBSC6->C6_IDENTB6
   SC6->C6_BLQ       :=   TRBSC6->C6_BLQ
   SC6->C6_ITEMORI   :=   TRBSC6->C6_ITEMORI
   SC6->C6_CODISS    :=   TRBSC6->C6_CODISS
   SC6->C6_GRADE     :=   TRBSC6->C6_GRADE
   SC6->C6_ITEMGRD   :=   TRBSC6->C6_ITEMGRD
   SC6->C6_IPIDEV    :=   TRBSC6->C6_IPIDEV
   SC6->C6_LOTECTL   :=   TRBSC6->C6_LOTECTL
   SC6->C6_DTVALID   :=   TRBSC6->C6_DTVALID
   SC6->C6_ITEMOP    :=   TRBSC6->C6_ITEMOP
   SC6->C6_NUMORC    :=   TRBSC6->C6_NUMORC
   SC6->C6_CHASSI    :=   TRBSC6->C6_CHASSI
   SC6->C6_OPC       :=   TRBSC6->C6_OPC
   SC6->C6_LOCALIZ   :=   TRBSC6->C6_LOCALIZ
   SC6->C6_NUMSERI   :=   TRBSC6->C6_NUMSERI
   SC6->C6_TIPOREV   :=   TRBSC6->C6_TIPOREV
   SC6->C6_CODDEST   :=   TRBSC6->C6_CODDEST
   SC6->C6_QTDRESE   :=   TRBSC6->C6_QTDRESE
   SC6->C6_NUMOP     :=   TRBSC6->C6_NUMOP
   SC6->C6_NUMOS     :=   TRBSC6->C6_NUMOS
   SC6->C6_CODSCC    :=   TRBSC6->C6_CODSCC
   SC6->C6_NUMOSFA   :=   TRBSC6->C6_NUMOSFA
   SC6->C6_CLASFIS   :=   TRBSC6->C6_CLASFIS
   SC6->C6_CODFAB    :=   TRBSC6->C6_CODFAB
   SC6->C6_LOJAFA    :=   TRBSC6->C6_LOJAFA
   SC6->C6_PEDREN    :=   TRBSC6->C6_PEDREN
   SC6->C6_ITEMREN   :=   TRBSC6->C6_ITEMREN
   SC6->C6_TPOP      :=   TRBSC6->C6_TPOP
   SC6->C6_REVISAO   :=   TRBSC6->C6_REVISAO
   SC6->C6_SITUAC    :=   TRBSC6->C6_SITUAC
   SC6->C6_DESCESP   :=   TRBSC6->C6_DESCESP
   SC6->C6_VALESP    :=   TRBSC6->C6_VALESP
   SC6->C6_TIPOASS   :=   TRBSC6->C6_TIPOASS
   SC6->C6_TPPORTE   :=   TRBSC6->C6_TPPORTE
   SC6->C6_ITEMANT   :=   TRBSC6->C6_ITEMANT
   SC6->C6_LOTEFAT   :=   TRBSC6->C6_LOTEFAT
   SC6->C6_DATA      :=   TRBSC6->C6_DATA
   SC6->C6_REGCOT    :=   TRBSC6->C6_REGCOT
   SC6->C6_ORIGEM    :=   TRBSC6->C6_ORIGEM
   SC6->C6_NUMANT    :=   TRBSC6->C6_NUMANT
   SC6->C6_EXADIC    :=   TRBSC6->C6_EXADIC
   SC6->C6_VERSAO    :=   TRBSC6->C6_VERSAO
   SC6->C6_RAZSIS    :=   TRBSC6->C6_RAZSIS
   SC6->C6_MENVIO    :=   TRBSC6->C6_MENVIO
   SC6->C6_ROTEIRO   :=   TRBSC6->C6_ROTEIRO
   SC6->C6_NUMINS    :=   TRBSC6->C6_NUMINS
   SC6->C6_CODVEIC   :=   TRBSC6->C6_CODVEIC
   SC6->C6_CODMAT    :=   TRBSC6->C6_CODMAT
   SC6->C6_CODTIT    :=   TRBSC6->C6_CODTIT
   SC6->C6_TPPROG    :=   TRBSC6->C6_TPPROG
   Msunlock()
Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function AppSc5
Static Function AppSc5()
   RecLock("SC5",.T.)
   // ��������������������������������������͸
   // �  Atualiza os dados Principais        �
   // ��������������������������������������;
   SC5->C5_FILIAL  :=  xFilial("SC5")
   SC5->C5_NUM     :=  _cNumero
   SC5->C5_CONDPAG :=  _cCondPag
   SC5->C5_PARC1   :=  0
   SC5->C5_DATA1   :=  stod("")
   SC5->C5_PARC2   :=  0
   SC5->C5_DATA2   :=  stod("")
   SC5->C5_PARC3   :=  0
   SC5->C5_DATA3   :=  stod("")
   SC5->C5_PARC4   :=  0
   SC5->C5_DATA4   :=  stod("")
   SC5->C5_PARC5   :=  0
   SC5->C5_DATA5   :=  stod("")
   SC5->C5_PARC6   :=  0
   SC5->C5_DATA6   :=  stod("")
   SC5->C5_EMISSAO :=  dDataBase
   SC5->C5_VLRPED  :=  0


   // ��������������������������������������͸
   // �  mantem o restante como padrao       �
   // ��������������������������������������;
   SC5->C5_TIPO    :=  TRBSC5->C5_TIPO
   SC5->C5_DIVVEN  :=  TRBSC5->C5_DIVVEN
   SC5->C5_CODPROM :=  TRBSC5->C5_CODPROM
   SC5->C5_CLIENTE :=  TRBSC5->C5_CLIENTE
   SC5->C5_LOJAENT :=  TRBSC5->C5_LOJAENT
   SC5->C5_LOJACLI :=  TRBSC5->C5_LOJACLI
   SC5->C5_TRANSP  :=  TRBSC5->C5_TRANSP
   SC5->C5_TIPOCLI :=  TRBSC5->C5_TIPOCLI
   SC5->C5_TABELA  :=  TRBSC5->C5_TABELA
   SC5->C5_LOTEFAT :=  TRBSC5->C5_LOTEFAT
   SC5->C5_DATA    :=  TRBSC5->C5_DATA
   SC5->C5_VEND1   :=  TRBSC5->C5_VEND1
   SC5->C5_DESPREM :=  TRBSC5->C5_DESPREM
   SC5->C5_TIPOOP  :=  TRBSC5->C5_TIPOOP
   SC5->C5_DTCALC  :=  TRBSC5->C5_DTCALC
   SC5->C5_CLIFAT  :=  TRBSC5->C5_CLIFAT
   SC5->C5_AVESP   :=  TRBSC5->C5_AVESP
   SC5->C5_TPTRANS :=  TRBSC5->C5_TPTRANS
   SC5->C5_CODAG   :=  TRBSC5->C5_CODAG
   SC5->C5_OBSPED  :=  TRBSC5->C5_OBSPED
   SC5->C5_RESPCOB :=  TRBSC5->C5_RESPCOB
   SC5->C5_DESC2   :=  TRBSC5->C5_DESC2
   SC5->C5_DESC3   :=  TRBSC5->C5_DESC3
   SC5->C5_DESC4   :=  TRBSC5->C5_DESC4
   SC5->C5_BANCO   :=  TRBSC5->C5_BANCO
   SC5->C5_DESCFI  :=  TRBSC5->C5_DESCFI
   SC5->C5_COTACAO :=  TRBSC5->C5_COTACAO
   SC5->C5_COMIS1  :=  TRBSC5->C5_COMIS1
   SC5->C5_FRETE   :=  TRBSC5->C5_FRETE
   SC5->C5_SEGURO  :=  TRBSC5->C5_SEGURO
   SC5->C5_DESC1   :=  TRBSC5->C5_DESC1
   SC5->C5_VEND2   :=  TRBSC5->C5_VEND2
   SC5->C5_PESOL   :=  TRBSC5->C5_PESOL
   SC5->C5_COMIS2  :=  TRBSC5->C5_COMIS2
   SC5->C5_PBRUTO  :=  TRBSC5->C5_PBRUTO
   SC5->C5_DESPESA :=  TRBSC5->C5_DESPESA
   SC5->C5_FRETAUT :=  TRBSC5->C5_FRETAUT
   SC5->C5_REAJUST :=  TRBSC5->C5_REAJUST
   SC5->C5_MOEDA   :=  TRBSC5->C5_MOEDA
   SC5->C5_REIMP   :=  TRBSC5->C5_REIMP
   SC5->C5_VEND3   :=  TRBSC5->C5_VEND3
   SC5->C5_REDESP  :=  TRBSC5->C5_REDESP
   SC5->C5_COMIS3  :=  TRBSC5->C5_COMIS3
   SC5->C5_VOLUME1 :=  TRBSC5->C5_VOLUME1
   SC5->C5_VEND4   :=  TRBSC5->C5_VEND4
   SC5->C5_VOLUME2 :=  TRBSC5->C5_VOLUME2
   SC5->C5_COMIS4  :=  TRBSC5->C5_COMIS4
   SC5->C5_VOLUME3 :=  TRBSC5->C5_VOLUME3
   SC5->C5_VEND5   :=  TRBSC5->C5_VEND5
   SC5->C5_VOLUME4 :=  TRBSC5->C5_VOLUME4
   SC5->C5_COMIS5  :=  TRBSC5->C5_COMIS5
   SC5->C5_ESPECI1 :=  TRBSC5->C5_ESPECI1
   SC5->C5_ESPECI2 :=  TRBSC5->C5_ESPECI2
   SC5->C5_TIPLIB  :=  TRBSC5->C5_TIPLIB
   SC5->C5_ESPECI4 :=  TRBSC5->C5_ESPECI4
   SC5->C5_INCISS  :=  TRBSC5->C5_INCISS
   SC5->C5_LIBEROK :=  TRBSC5->C5_LIBEROK
   SC5->C5_OK      :=  TRBSC5->C5_OK
   SC5->C5_ACRSFIN :=  TRBSC5->C5_ACRSFIN
   SC5->C5_MENPAD  :=  TRBSC5->C5_MENPAD
   SC5->C5_MENNOTA :=  TRBSC5->C5_MENNOTA
   SC5->C5_USUARIO :=  TRBSC5->C5_USUARIO
   SC5->C5_OS      :=  TRBSC5->C5_OS
   SC5->C5_NOTA    :=  TRBSC5->C5_NOTA
   SC5->C5_SERIE   :=  TRBSC5->C5_SERIE
   SC5->C5_TPFRETE :=  TRBSC5->C5_TPFRETE
   SC5->C5_ESPECI3 :=  TRBSC5->C5_ESPECI3
   SC5->C5_VENDA   :=  TRBSC5->C5_VENDA
   SC5->C5_KITREP  :=  TRBSC5->C5_KITREP
   SC5->C5_DESCESP :=  TRBSC5->C5_DESCESP
   SC5->C5_PEDORIG :=  TRBSC5->C5_PEDORIG
   SC5->C5_CLISOFT :=  TRBSC5->C5_CLISOFT
   SC5->C5_DTMOV   :=  TRBSC5->C5_DTMOV
   SC5->C5_ORIGEM  :=  TRBSC5->C5_ORIGEM
   SC5->C5_NUMANT  :=  TRBSC5->C5_NUMANT
   msunlock()
Return
