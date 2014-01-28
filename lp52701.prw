#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: LP52701A  �Autor: Roger Cangianeli       � Data:   21/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Retorna historico do lancamento padrao 527 seq.01          � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI                                            � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Lp52701()

Local aArea := GetArea()

If Empty(SE1->E1_REAB) .and. 'LP' $ SUBS(SE1->E1_MOTIVO,1,2)
    DbSelectArea("SE1")
    RecLock("SE1", .F.)
    SE1->E1_REAB := "S"
    msUnlock()
EndIf

_cHist := "VLR.REF.REAB.DUPL." + AllTrim(SE1->E1_NUM)
_cHist += IIf(!Empty(SE1->E1_PARCELA), '/' + SE1->E1_PARCELA, '' )
_cHist += IIf(!Empty(SE1->E1_GRPROD), ' GR.PROD. ' + AllTrim(SE1->E1_GRPROD), '' )

RestArea(aArea)

Return(_cHist)     
