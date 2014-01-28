#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

User Function Rfat089()        // incluido pelo assistente de conversao do AP5 IDE em 25/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NREG,_CFILTRO,_CARQTRB,NINDEX")
SetPrvt("_NQTDLIB,_CCHAVE,_NSEQ,")

/*/                  
Danilo C S Pala 20070831: se o c5_data1 < ddatabase entao c5_data1 = ddatabase 
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: LIBSOL    �Autor: DESCONHECIDO           � Data:   02/02/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Efetua Liberacao de A.V.�s, gerando registros no SC9.      � ��
������������������������������������������������������������������������Ĵ ��
���Release  : Roger Cangianeli, correcao/otimizacao/conv.Win em 02/02/00.� ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
_cAlias := Alias()
_nIndex := IndexOrd()
_nReg   := Recno()

//���������������������������������������������������������������Ŀ
//� mv_par01 Ordem Processamento?  Ped.+Item /Dt.Entrega+Ped.+Item�
//� mv_par02 Pedido de          ?                                 �
//� mv_par03 Pedido ate         ?                                 �
//� mv_par04 Cliente de         ?                                 �
//� mv_par05 Cliente ate        ?                                 �
//� mv_par06 Dta Entrega de     ?                                 �
//� mv_par07 Dta Entrega ate    ?                                 �
//� mv_par08 Lote de                                              �
//� mv_par09 Lote Ate                                             �
//� mv_par10 Data Lote de                                         �
//� mv_par11 Data Lote Ate                                        �
//�����������������������������������������������������������������
If !Pergunte("MTALIB",.T.)
        return
Else
        Processa({||_RunProc()})// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==>         Processa({||Execute(_RunProc)})
Endif

Return


// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function _RunProc
Static Function _RunProc()
//���������������������������������������������Ŀ
//�Verifica a quantidade a ser liberada         �
//�����������������������������������������������

/*/

NAO HA NECESSIDADE DE FILTRO, SENDO QUE EFETUA FILTRAGEM NOS IF�S ABAIXO.RC

_cFiltro := "ZS_FILIAL == '"+xFilial("SZS")+"'"
_cFiltro := _cFiltro+".and. VAL(ZS_NFISCAL) == 0 "
_cFiltro := _cFiltro+".and. !Empty(ZS_CODMAT)"
_cFiltro := _cFiltro+".and. ZS_SITUAC='AA'"
_cFiltro := _cFiltro+".and. '"+STRZERO(MONTH(MV_PAR13),2) +"' == STRZERO(MONTH(ZS_LIBPROG),2) "
_cFiltro := _cFiltro+".and. '"+STRZERO(YEAR(MV_PAR13),4) +"' == STRZERO(YEAR(ZS_LIBPROG),4) "
_cArqTrb := CriaTrab(nil,.f.)
IndRegua("SZS",_cArqTrb,IndexKey(),,_cFiltro,"Selecionando Registro")
nIndex   := RetIndex("SZS")
#IFNDEF TOP
dbSetIndex(_cArqTrb+OrdBagExt())
#ENDIF
dbSetOrder(nIndex+1)
/*/

dbSelectArea("SZS")


ProcRegua(RecCount())

dbSetOrder(1)
dbSeek(xFilial("SZS")+MV_PAR02,.T.)
While !eof() .and. SZS->ZS_NUMAV <= MV_PAR03

        _nQtdLib := 0
    dbSelectArea("SC5")
    dbSeek(xFilial("SC5")+SZS->ZS_NUMAV)

    dbSelectArea("SZS")
        _cChave  := SZS->ZS_NUMAV+SZS->ZS_ITEM
    While !eof() .and. SZS->ZS_NUMAV+SZS->ZS_ITEM == _cChave

            IncProc()

        //��������������������������������������������������������������������������������������Ŀ
        //�   Somar a Quantidade Liberada por item da Av e Gerar no SC6,  SC9 a liberacao        �
        //�   correspondente                                                                     �
        //����������������������������������������������������������������������������������������
        dbSelectArea("SC6")
        dbSeek(xFilial("SC6")+SZS->ZS_NUMAV+SZS->ZS_ITEM)

        If VAL(SZS->ZS_NFISCAL) <> 0 .or. Empty(SZS->ZS_CODMAT)
            dbSelectArea("SZS")
            dbSkip()
            Loop
        EndIf

        If SZS->ZS_SITUAC #"AA" .or. SC6->C6_SITUAC # "AA"
            dbSelectArea("SZS")
            dbSkip()
            Loop
        EndIf

        If Month(MV_PAR13) #Month(SZS->ZS_LIBPROG) .or. ;
            Year(MV_PAR13) #Year(SZS->ZS_LIBPROG)
            dbSelectArea("SZS")
            dbSkip()
            Loop
        EndIf

        If !SC5->C5_TPTRANS $ '00/04/05/06/09'
            dbSelectArea("SZS")
            dbSkip()
            Loop
        EndIf

        If SC5->C5_CONDPAG < MV_PAR16 .or. SC5->C5_CONDPAG > MV_PAR17
            dbSelectArea("SZS")
            dbSkip()
            Loop
        EndIf

        If VAL(SC5->C5_VEND1) < VAL(MV_PAR14) .or. VAL(SC5->C5_VEND1) > VAL(MV_PAR15) .or.;
           SC6->C6_CLI   < MV_PAR04 .or. SC6->C6_CLI   > MV_PAR05
            dbSelectArea("SZS")
            dbSkip()
            Loop
        EndIf

        _nQtdLib := _nQtdLib + 1
        RecLock("SZS",.F.)
        SZS->ZS_LIBFAT := dDataBase
        SZS->(msUnlock())

        dbSelectArea("SZS")
        dbSkip()

    End

    If _nQtdLib <> 0
        _Gerac9()
                _nQtdLib := 0
        Endif

    dbSelectArea("SZS")

End

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoTo(_nReg)

Return



// Substituido pelo assistente de conversao do AP5 IDE em 25/02/02 ==> Function _Gerac9
Static Function _Gerac9()
_nSeq:=0

// Atualiza o Empenho
dbSelectArea("SC6")
RecLock("SC6",.F.)
SC6->C6_QTDEMP := _nQtdLib
SC6->(MsUnlock())

dbSelectArea("SC9")
dbSetOrder(1)
If dbSeek( xFilial("SC9")+SC6->C6_NUM+SC6->C6_ITEM, .F.)
        //�������������������������������������������������Ŀ
        //�  Pesquisa se ha liberacoes ja cadastradas       �
        //�  Limpa os itens que nao tiverem sido faturados  �
        //���������������������������������������������������
//    While !Eof() .And. C9_FILIAL+C9_PEDIDO == cSeek
//    If C9_PRODUTO == SC6->C6_PRODUTO .AND.
//    dbSkip()
//    Enddo

//  NAO HA NECESSIDADE DE LOOP, O ARQUIVO E FEITO ITEM A ITEM. - RC
    If Empty(SC9->C9_NFISCAL)
        RecLock("SC9",.F.)
        dbDelete()
        SC9->(msUnlock())
    EndIf


        // �������������������������������������������������Ŀ
        // ôReposiciona para verificar o ultimo item        �
        // ���������������������������������������������������
    dbSeek( xFilial("SC9")+SC6->C6_NUM, .T.)
    While !Eof() .And. SC9->C9_FILIAL+SC9->C9_PEDIDO == xFilial("SC9")+SC6->C6_NUM
        If SC9->C9_PRODUTO == SC6->C6_PRODUTO
            _nSeq := Val(C9_SEQUEN)
                EndIf
                dbSkip()
    End
    _nSeq := _nSeq + 1
Else
    _nSeq := 1
Endif

//�������������������������������������������Ŀ
//� Posiciona arquivos.                       �
//���������������������������������������������
//dbSelectArea("SC5")
//dbSetOrder(1)
//dbSeek(xFilial("SC5")+SC6->C6_NUM, .F.)
// JA ESTA POSICIONADO NO SC5. - RC

DbSelectArea("SC5") //20070831
if SC5->C5_DATA1 < DDATABASE 
	RecLock("SC5",.F.)
		REPLACE C5_DATA1 WITH DDATABASE
	SC5->(MsUnlock())    //ate aqui 20070831
endif



dbSelectArea("SC9")
If !"DB" $ SC5->C5_TIPO
        dbSelectArea("SA1")
        dbSetOrder(1)
    dbSeek(xFilial("SA1")+SC6->C6_CLI+SC6->C6_LOJA)
EndIf

RecLock("SC9",.T.)
// Atualiza os campos necessarios de SC9
SC9->C9_PEDIDO  := SC6->C6_NUM
SC9->C9_QTDLIB  := _nQtdLib
SC9->C9_SEQUEN  := Strzero(_nSeq,2)
SC9->C9_FILIAL  := xFilial("SC9")
SC9->C9_CLIENTE := SC6->C6_CLI
SC9->C9_LOJA    := SC6->C6_LOJA
SC9->C9_PRODUTO := SC6->C6_PRODUTO
SC9->C9_PRCVEN  := SC6->C6_PRCVEN
SC9->C9_ITEM    := SC6->C6_ITEM
SC9->C9_DATALIB := dDataBase
SC9->C9_NUMLOTE := sc6->c6_numlote
SC9->C9_LOTECTL := SC6->C6_LOTECTL
SC9->C9_NUMSERI := SC6->C6_NUMSERI
SC9->C9_DATA    := SC6->C6_DATA
SC9->C9_LOTEFAT := SC6->C6_LOTEFAT
Sc9->C9_LOCAL   := SC6->C6_LOCAL
Sc9->C9_DATENT  := DDATABASE
SC9->(MsUnLock())

Return

