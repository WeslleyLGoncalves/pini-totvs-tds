#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02
#IFNDEF WINDOWS
  #DEFINE PSAY SAY
#ENDIF

User Function Rfatr32a()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,CSTRING,CDESC1,CDESC2,CDESC3,TAMANHO")
SetPrvt("ARETURN,NOMEPROG,LIMITE,ALINHA,NLASTKEY,NLIN")
SetPrvt("TITULO,CCABEC1,CCABEC2,CCANCEL,M_PAG,WNREL")
SetPrvt("_CIND,_CKEY,_CFILTRO,NINDEX,_MTOT,_MPROD")
SetPrvt("_MQTDE,_MTOTP,_MVAL,_MNUM,_MDESCR,_MCONT")
SetPrvt("_MOTIVO,_NREGATU,_NVALOR,_CPRODUTO,_NI,_CSUPORTE")
SetPrvt("_MPERC,_MDESP,mhora")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 25/02/02 ==>   #DEFINE PSAY SAY
#ENDIF
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: RFATR32   �Autor: Rosane Rodrigues       � Data:   21/04/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: RELATORIO DE VENDAS                                        � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//�������������������������������������������Ŀ
//�   Parametros Utilizados                   �
//�   mv_par01 = Produto  Inicial             �
//�   mv_par02 = Produto  Final               �
//�   mv_par03 = Data Inicial                 �
//�   mv_par04 = Data Final                   �
//���������������������������������������������

cPerg    := "FAT018"
If !Pergunte(CPERG)
   Return
EndIf
cString  := "SC6"
cDesc1   := PADC("Este programa emite o relat�rio das vendas",70)
cDesc2   := PADC("por produto no per�odo solicitado",70)
cDesc3   := PADC("Obs: os pedidos com S�rie CP0 e LIV n�o aparecem no relat�rio",70)
tamanho  := "M"
aReturn  := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog := "RFATR32A"
limite   := 80
aLinha   := { }
nLastKey := 0
nLin     := 80
titulo   := "Vendas por Produto"
cCabec1  := "Produto Inicial : " + MV_PAR01 + SPACE(04) + "Produto Final : " + MV_PAR02 + SPACE(04) +;
            "Dt. Compra Inicial : " + DTOC(MV_PAR03) + SPACE(04) + "Dt. Compra Final : " + DTOC(MV_PAR04)
cCabec2  := " "
cCancel  := "***** CANCELADO PELO OPERADOR *****"
m_pag    := 1               //Variavel que acumula numero da pagina
MHORA := TIME()
wnrel    := "RFATR32_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)       //Nome Default do relatorio em Disco
wnrel    := SetPrint(cString,wnrel,cPerg,space(25)+titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

SetDefault(aReturn,cString)

IF NLASTKEY==27 .OR. NLASTKEY==65
   RETURN
ENDIF

// �����������������������������������������������Ŀ
// �Chama Relatorio                                �
// �������������������������������������������������
#IFDEF WINDOWS
   RptStatus({|| RptDetail() })// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>    RptStatus({|| Execute(RptDetail) })
#ELSE
   RptDetail()
#ENDIF
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
// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function RptDetail
Static Function RptDetail()

dbSelectArea("SE5")

_cInd    := CriaTrab(NIL,.F.)
_cKey    := "E5_FILIAL+E5_NUMERO+E5_PARCELA"
IndRegua("SE5",_cInd,_cKey,,,"Selecionando registros .. ")

dbSelectArea("SE1")

_cInd    := CriaTrab(NIL,.F.)
_cKey    := "E1_FILIAL+E1_PEDIDO+E1_NUM+E1_PARCELA"
_cFiltro := "E1_FILIAL == '"+xFilial("SE1")+"'"
_cFiltro := _cFiltro+".and.E1_SERIE<>'LIV'.AND.E1_SERIE<>'CP0'"
IndRegua("SE1",_cInd,_cKey,,_cFiltro,"Selecionando registros .. ")

dbSelectArea("SC6")

_cInd    := CriaTrab(NIL,.F.)
_cKey    := "C6_FILIAL+C6_PRODUTO+C6_NUM+DTOS(C6_DATA)"
_cFiltro := "C6_FILIAL == '"+xFilial("SC6")+"'"
_cFiltro := _cFiltro+".and.DTOS(C6_DATA)>=DTOS(CTOD('"+DTOC(MV_PAR03)+"'))"
_cFiltro := _cFiltro+".and.DTOS(C6_DATA)<=DTOS(CTOD('"+DTOC(MV_PAR04)+"'))"
IndRegua("SC6",_cInd,_cKey,,_cFiltro,"Selecionando registros .. ")
nIndex := RetIndex("SC6")+1

#IFNDEF TOP
   dbSetIndex( _cInd + OrdBagExt())
   dbSetOrder( nIndex )
#ENDIF

DbSelectArea("SC6")
DbSetOrder( nIndex )

SetRegua(Reccount()/7)
dbSeek(xFilial("SC6")+MV_PAR01,.T.)

_mtot  := 0
_mProd := " "
_mQtde := 0
_mtotp := 0

While !eof() .and. sc6->c6_produto <= mv_par02

    // Gilberto em 01/12/2000. Para desprezar o Suporte Informatico.

    If Left(SC6->C6_PRODUTO,4) $ "1195/1495/1595/1795"
       DbSelectAreA("SC6")
       DbSkip()
       Loop
    EndIf

    IncRegua()

    _mval   := 0
    _mnum   := SC6->C6_NUM
    _mDescr := " "
    _mCont  := 0
    _motivo := " "

    // Gilberto - 01/12/2000. Para somar suporte informatico.

    DbSelectArea("SC6")

    _nRegAtu:= SC6->( Recno() )
    _nValor:= SC6->C6_VALOR
    _cProduto:= LEFT(SC6->C6_PRODUTO,2)+"95"
    For _ni := 1 To 3

        DbSelectArea("SC6")
        _cSuporte:= Padr(_cProduto+StrZero(_ni,3),15) + _mNum
        DbSeek( xFilial("SC6")+_cSuporte )
        If Found()
           _nValor:= _nValor + SC6->C6_VALOR
        EndIf

    Next
    dbGoto(_nRegAtu)


    If _mProd <> SC6->C6_PRODUTO .and. _mProd <> " "
       nlin := nlin + 2
       @ nlin,000 PSAY "Total do Produto .....................................: "
       @ nlin,056 PSAY STR(_mQtde,6)
       @ nlin,108 PSAY _mtot  PICTURE "@E 9,999,999.99"
       nLin := nLin + 2
       @ nlin,000 PSAY "Total de Pagamentos ..................................: "
       @ nlin,108 PSAY _mtotp PICTURE "@E 9,999,999.99"
       _mtot  := 0
       _mQtde := 0
       _mtotp := 0
       nLin   := 80
    Endif

    DbSelectArea("SC5")
    DbSetOrder(01)
    DbSeek(xFilial("SC5")+_mnum)

    If Found()

       // _mPerc := (SC6->C6_VALOR * 100) / SC5->C5_VLRPED

       _mPerc := (_nValor * 100) / SC5->C5_VLRPED
       _mDesp := SC5->C5_DESPREM

       DbSelectArea("SZ9")
       DbSetOrder(01)
       DbSeek(xFilial("SZ9")+SC5->C5_TIPOOP)
       If Found()
          _mDescr := SUBSTR(SZ9->Z9_DESCR,1,19)
       Endif

       DbSelectArea("SE1")
       DbSeek(xFilial("SE1")+_mnum,.T.)
       If Found()
          Do While _mnum == SE1->E1_PEDIDO
             IF 'LUCROS E PERDAS' $(SE1->E1_HIST)
                _motivo := "L&P"
             ENDIF
             IF 'NF CANCELA' $(SE1->E1_HIST) .OR. 'CAN' $(SE1->E1_MOTIVO)
                _motivo := "NF CANC"
             ENDIF
             DbSelectArea("SE5")
             DbSeek(xFilial("SE5")+SE1->E1_NUM+SE1->E1_PARCELA)
             If Found()
                IF 'CAN' $(E5_MOTBX)
                    _motivo := "NF CANC"
                Endif
             Endif

             if nLin > 59
                nLin     := Cabec(titulo,cCabec1,cCabec2,nomeprog,tamanho,18) //IIF(aReturn[4]==1,15,18) ) //Impressao do cabecalho
                nLin     := nLin + 2
                @ nlin,00 PSAY "Produto :  " + SC6->C6_DESCRI
                nLin     := nLin + 2
                             //           1         2         3         4         5         6         7         8         9        10        11        12        13
                             // 0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

// 34567890123456789012345678901234567890123456789
                @ nlin,00 PSAY "Pedido  Cliente  Nome do Cliente                          Qtde  Forma de Pgto        Valor Total   Duplicata  Valor Parcela  Dt.Pgto."
                nLin     := nLin + 1
                @ nlin,00 PSAY "------  -------  ---------------------------------------- ----  -------------------  ------------  ---------  -------------  --------"
                nLin     := nLin + 1
             Endif

             nLin     := nLin + 1
             _mval := SE1->E1_VALOR

             If _mCont == 0
                @ nlin,000 PSAY SE1->E1_PEDIDO
                @ nlin,008 PSAY SC6->C6_CLI
                dbSelectArea("SA1")
                dbSetOrder(1)
                dbSeek(xFilial("SA1")+SC6->C6_CLI)
                @ nlin,017 PSAY SA1->A1_NOME
                @ nlin,058 PSAY STR(SC6->C6_QTDVEN,4)
                @ nlin,064 PSAY _mDescr
                @ nlin,086 PSAY SC5->C5_VLRPED * (_mPerc / 100) PICTURE "@E 99,999.99"
                _mQtde := _mQtde + SC6->C6_QTDVEN
                _mCont := 1
             Endif
             If SE1->E1_PARCELA == 'A' .OR. SE1->E1_PARCELA == ' '
                _mval  := SE1->E1_VALOR - _mDesp
             Endif
             @ nlin,099 PSAY SE1->E1_NUM+' '+SE1->E1_PARCELA
             @ nlin,111 PSAY _mval * (_mPerc / 100) PICTURE "@E 99,999.99"
             If _motivo #" "
                If _motivo == "L&P"
                   @ nlin,125 PSAY _motivo
                   _mtot  := _mtot + (_mval * (_mPerc / 100))
                else
                   @ nlin,125 PSAY _motivo
                endif
             else
                If YEAR(SE1->E1_BAIXA) <> 0
                   @ nlin,125 PSAY SE1->E1_BAIXA
                   _mtotp := _mtotp + (_mval * (_mPerc / 100))
                endif
                _mtot  := _mtot + (_mval * (_mPerc / 100))
             Endif
             _motivo := " "
             DbSelectArea("SE1")
             DbSkip()
          Enddo
       Endif
    Endif
    _mProd := SC6->C6_PRODUTO
    DbSelectArea("SC6")
    DbSkip()
End

nLin := nLin + 2
@ nlin,000 PSAY "Total do Produto .....................................: "
@ nlin,056 PSAY STR(_mQtde,6)
@ nlin,108 PSAY _mtot  PICTURE "@E 9,999,999.99"
nLin := nLin + 2
@ nlin,000 PSAY "Total de Pagamentos ..................................: "
@ nlin,108 PSAY _mtotp PICTURE "@E 9,999,999.99"

dbSelectarea("SC6")
RetIndex("SC6")
// Apaga Indice SC6
fErase(_cInd+OrdBagExt())
dbSelectarea("SE1")
RetIndex("SE1")
dbSelectarea("SC5")
RetIndex("SC5")
dbSelectarea("SE5")
RetIndex("SE5")

Set Device to Screen
If aReturn[5] == 1
    Set Printer To
    ourspool(wnrel) //Chamada do Spool de Impressao
Endif
MS_FLUSH() //Libera fila de relatorios em spool
Return

