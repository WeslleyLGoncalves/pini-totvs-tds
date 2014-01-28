#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Fa330exc()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NORDEM,")

/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���PTO ENTRADA �FA330EXC  � Autor � Gilberto A. Oliveira  � Data � 04/08/00 ���
���������������������������������������������������������������������������Ĵ��
���Descricao   �Ponto de Entrada para estornar o conteudo gravado no        ���
���            �C5_STATFIN pelo ponto de entrada FA330SE1.                  ���
���            �Acontece no estorno da Compensacao CR.                      ���
���������������������������������������������������������������������������Ĵ��
���Uso         �Especifico para Editora Pini. Modulo Financeiro.            ���
���������������������������������������������������������������������������Ĵ��
���Revisao     �                                          � Data �          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/

_cAlias:= Alias()
_nIndex:= IndexOrd()
_nOrdem:= Recno()

DbSelectArea("SC5")
DbSetOrder(1)
DbSeek(xfilial("SC5")+SE1->E1_PEDIDO)

If (Alltrim(SC5->C5_TIPOOP) $ "80|82|83|84") .And. Found()

   If SC5->C5_STATFIN == "DC "
      RecLock("SC5",.F.)
      SC5->C5_STATFIN:= "RA "
      MsUnLock()
   EndIf

EndIf

DbSelectArea(_cAlias)
DbSetOrder(_nIndex)
DbGoto(_nOrdem)

Return


