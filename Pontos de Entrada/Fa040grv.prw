#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Fa040grv()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_NORDEMC5,_NREGISC5,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FA040GRV  � Autor � Gilberto A Oliveira Jr� Data � 19/07/00 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �PONTO DE ENTRADA PARA ATUALIZACAO DO STATUS (C5_STATFIN) NO ���
���          �SC5 - PEDIDO DE VENDA. Somente quando o titulo for "RA".    ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Especifico para Editora Pini. Modulo Financeiro.            ���
�������������������������������������������������������������������������Ĵ��
���Revisao   �                                          � Data �          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


If SE1->E1_TIPO<>"RA"
   Return
EndIf

If Empty(SE1->E1_PEDIDO)
   #IFNDEF WINDOWS
      Alert('Por ser um titulo tipo "RA",e necessario que se digite o numero do Pedido de Venda. Verifique...')
   #ELSE
      MsgStop('Por ser um titulo tipo "RA", e necessario que se digite o numero do Pedido de Venda. Verifique...')
   #ENDIF
EndIf


DbSelectArea("SC5")
_nOrdemC5:= IndexOrd()
_nRegisC5:= Recno()
DbSetOrder(3)
If !( DbSeek(xFilial("SC5")+SE1->E1_CLIENTE+SE1->E1_PEDIDO) )
   #IFNDEF WINDOWS
      Alert("Cod. Cliente + Nr.Pedido nao encontrado !!" )
   #ELSE
      MsgStop("Cod. Cliente + Nr.Pedido nao encontrado !!" )
   #ENDIF
Else
   RecLock("SC5",.F.)
   SC5->C5_STATFIN:= "RA"
   MsUnLock()
EndIf

Return




