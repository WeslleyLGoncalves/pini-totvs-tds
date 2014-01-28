#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function M410alok()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NREG,_LRET,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: M410ALOK  �Autor: Roger Cangianeli       � Data:   07/07/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Bloqueio na Alteracao de Pedidos de Venda.                 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI.                                           � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//_cAlias := Alias()
//_nIndex := IndexOrd()
//_nReg   := Recno()

_lRet   := .T.
If "P" $ SC5->C5_NUM .or. SC5->C5_DIVVEN == "PUBL"
    If !Upper(AllTrim(Subs(cUsuario,7,15))) $ GetMV("MV_PINI001")
        _lRet := .F.
    EndIf
EndIf

//dbSelectArea(_cAlias)
//dbSetOrder(_nIndex)
//dbGoTo(_nReg)

// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return(_lRet)
Return(_lRet)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
