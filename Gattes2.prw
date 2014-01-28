#INCLUDE "RWMAKE.CH"
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Gatilho   � GATTES2    � Autor �Gilberto A. de Oliveira� Data � 11.09.00  ���
����������������������������������������������������������������������������Ĵ��
���Descri��o �Mostra ao usuario que o TES que esta sendo informado � diferen-���
���          �te do padrao normalmente utilizado.                            ���
����������������������������������������������������������������������������Ĵ��
���Alteracoes�Incluido o TES 603 na condicao - Gilberto , 15/09/00           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/
User Function Gattes2()

Local _cProd, _cTES

_cProd := aCols[n,aScan(aHeader ,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO" })]
_cTES  := aCols[n,aScan(aHeader ,{|x| Upper(AllTrim(x[2]))=="C6_TES" })]

If Alltrim(M->C5_TIPOOP) $ "18/24/34/44" .And. LEFT(_cProd,2) $ "02/07"
   If _cTES != "602" .AND. _cTES != "603"
      _nMsg:= OemToAnsi("Esse TES encontra-se incompativel com o produto")
      _nMsg:= _nMsg+OemToAnsi(" e o tipo de operacao. Confirma ? ")
      _nAv:= Aviso(OemToAnsi("Confirma o TES ("+_cTES+") ?"),_nMsg,{"SIM","NAO"} )
      If _nAV == 2
         _cTES:= SPACE(3)
      EndIf
   Endif
ENDIF

Return(_cTES)
