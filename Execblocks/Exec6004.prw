#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 22/03/02
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXEC6004  �Autor  �Microsiga           � Data �  03/25/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho no pedido de venda                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Exec6004()        // incluido pelo assistente de conversao do AP5 IDE em 22/03/02
Local aArea := GetArea()

SetPrvt("_CALIAS,_NRECNO,_NINDICE,_LRET,_NPOSPRODUTO,_NPOSLOCAL")
SetPrvt("_NPOSQTDVEN,_CPRODUTO,_CLOCAL,_NQTDVEN,_CALIASC6,_NRECSC6")
SetPrvt("_NINDSC6,")



dbSelectArea("SC6")

_lRet := .f.

_nPosProduto:= Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_PRODUTO"})
_nPosLocal  := Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_LOCAL"})
//_nPosQtdVen := Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_QTDVEN"})

_cProduto   := Acols[n][_nPosProduto]
_cLocal     := Acols[n][_nPosLocal]
//_nQtdVen    := Acols[n][_nPosQtdVen]
_nQtdVen    := M->C6_QTDVEN

dbSelectArea("SA3")
dbSetOrder(1)
dbSeek(Xfilial("SA3")+M->C5_VEND1)

_cLocal := SA3->A3_LOCAL

If _cLocal == "03"

    _cAliasC6 := "SC6"
    _nRecSC6  := Recno()
    _nIndSC6  := IndexOrd()

    dbSelectArea("SB1")
    dbSetOrder(1)
    dbSeek(xFilial("SB1")+_cProduto)

    dbSelectArea("SB2")
    dbSetOrder(1)
    If !dbSeek(xFilial("SB2")+_cProduto+_cLocal)
        ALERT("Produto sem Estoque neste Local Verificar Almoxarifado -> "+_cLocal)
        _lRet := .f.
    Else
        If SB2->B2_QATU - _nQtdVen > SB1->B1_ESTSEG
           _lRet := .t.
        Else
           Alert("Quantidade em estoque("+STR(SB2->B2_QATU - _nQtdVen,12,2)+") menor que o estoque de Seguranca"+str(SB1->B1_ESTSEG,12,2))
           _lRet := .f.
        Endif
    Endif

Else
   _lRet := .t.
Endif

RestArea(aArea)

Return(_lRet)