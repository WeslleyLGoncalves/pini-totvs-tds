#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Se5fi70e()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_LRET,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: SE5FI70E  �Autor: Solange Nalini         � Data:   19/08/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Marca a reabilitacao do LP                                 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI                                            � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//_lRet := .T.
If 'LP' $ SUBS(SE1->E1_MOTIVO,1,2)
    RECLOCK("SE1",.F.)
      SE1->E1_MOTIVO :=' '
      SE1->E1_REAB   :='S'
    MSUNLOCK()
//    _lRet := .F.
EndIf
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return()
Return()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

