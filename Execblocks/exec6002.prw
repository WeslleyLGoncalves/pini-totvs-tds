#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 22/03/02
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EXEC6002  �Autor  �Microsiga           � Data �  03/25/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gatilho no pedido de venda                                  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function exec6002()        // incluido pelo assistente de conversao do AP5 IDE em 22/03/02
Local aArea := GetArea()

SetPrvt("_CALIAS,_NRECNO,_NINDICE,_CRET,_NPOSPEDANT,_NPOSITEMANT")
SetPrvt("_CPEDANT,_CITEMANT,_CALIASC6,_NRECSC6,_NINDSC6,")



dbSelectArea("SC6")

_cRet := ""

_nPosPedAnt := Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_PEDANT"})
_nPosItemAnt:= Ascan(aHeader,{ |x| Alltrim(x[2])=="C6_ITEMANT"})

_cPedAnt    := Acols[n][_nPosPedAnt]
_cItemAnt   := Acols[n][_nPosItemAnt]


_cAliasC6 := "SC6"
_nRecSC6  := Recno()
_nIndSC6  := IndexOrd()

dbSelectArea("SC6")
dbSetOrder(1)
If dbSeek(xFilial("SC6")+_cPedAnt+_cItemAnt)
   _cRet := SC6->C6_CODDEST
Endif

RestArea(aArea)

Return(_cRet)