#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: CA050ALT  �Autor: Roger Cangianeli       � Data:   31/01/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Ponto de Entrada para validacao da alteracao de lcto cont. � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Modulo Contabilidade - Especifico PINI                     � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Ca050alt()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

SetPrvt("_LRET,_CMSG,")

_lRet := .T.


// Bloco desabilitado para alteracoes pela contabilidade
/*
If !Empty(SI2->I2_CTRL) .AND. !Upper(AllTrim(Subs(cUsuario,7,15))) $ "MARCIA"
    _cMsg := "Este Lancamento ja foi exportado para planilhas de controle e "
    _cMsg := _cMsg + "nao deve ser alterado. Consulte a Srta. Marcia - Depto Custos."
    MsgBox(_cMsg, "*** ATENCAO ***", "ALERT")
    _lRet := .F.
EndIf
*/

Return(_lRet)