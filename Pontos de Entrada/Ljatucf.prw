#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Ljatucf()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o	 � LjAtuCF	� Autor � F�bio F. Pessoa		  � Data �01/03/1999���
�������������������������������������������������������������������������Ĵ��
���Descri��o � � chamado atrav�s de um gatilho no campo L2_PRODUTO na     ���
���          � tela de Venda Balc�o.                                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso		 � SigaLoja 												  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_RET")


If SA1->A1_EST == GetMV("MV_ESTADO") .And. SA1->A1_TIPO #"X"
  _Ret := "5" + SubStr(SF4->F4_CF, 2, 3)
ElseIf SA1->A1_TIPO#"X"
  _Ret := "6" + SubStr(SF4->F4_CF, 2, 3)
Else
  _Ret := "7" + SubStr(SF4->F4_CF, 2, 3)
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return(_Ret)
Return(_Ret)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
