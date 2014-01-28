#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02


/*/
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������Ŀ��
���PTO ENTRADA �FA040B01  � Autor � Gilberto A. Oliveira  � Data � 04/08/00 ���
���������������������������������������������������������������������������Ĵ��
���Descricao   �Ponto de Entrada para estornar o conteudo gravado no        ���
���            �C5_STATFIN pelo ponto de entrada FA040GRV (gravacao crc).   ���
���            �Executado no momento da Exclusao do T�tulo a pagar.         ���
���������������������������������������������������������������������������Ĵ��
���Uso         �Especifico para Editora Pini. Modulo Financeiro.            ���
���������������������������������������������������������������������������Ĵ��
���Revisao     �                                          � Data �          ���
����������������������������������������������������������������������������ٱ�
�������������������������������������������������������������������������������
�������������������������������������������������������������������������������
/*/
User Function Fa040b01()
SetPrvt("_CALIAS,_NINDEX,_NORDEM,")


IF SE1->E1_TIPO == "RA "

   _cAlias:= Alias()
   _nIndex:= IndexOrd()
   _nOrdem:= Recno()

   DbSelectArea("SC5")
   DbSetOrder(1)
   DbSeek(xfilial("SC5")+SE1->E1_PEDIDO)
   If (Alltrim(SC5->C5_TIPOOP) $ "80|82|83|84") .And. Found()
      If SC5->C5_STATFIN == "RA "
         RecLock("SC5",.F.)
         SC5->C5_STATFIN:= "RG "
         MsUnLock()
      EndIf
   EndIf
   DbSelectArea(_cAlias)
   DbSetOrder(_nIndex)
   DbGoto(_nOrdem)

ENDIF

// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __Return(.T.)
Return(.T.)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02


