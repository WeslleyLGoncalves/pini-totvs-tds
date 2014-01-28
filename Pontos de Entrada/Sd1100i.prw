#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Sd1100i()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NINDEX,_NRECNO,_NINDSB1,_NRECSB1,_ATABSUP")
SetPrvt("_CSUP,_DUCOM,_NUPRC,_X,")

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���P.Entrada � SD1100I  � Autor � Gilberto A. de Oliveira  � Data � 13/09/00 ���
����������������������������������������������������������������������������Ĵ��
���Descricao � Ponto de entrada apos a gravacao dos itens da nota de entrada.���
���          � tem por funcao atualizar os valores de suporte informatico.   ���
����������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para Editora Pini Ltda.                            ���
����������������������������������������������������������������������������Ĵ��
���Alteracoes�                                                               ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

IF ALLTRIM(FUNNAME())=="MATA100"

   _cAlias:= Alias()
   _nIndex:= IndexOrd()
   _nRecno:= Recno()

   _nIndSB1:= SB1->( IndexOrd() )
   _nRecSB1:= SB1->( Recno() )


   _aTabSup:= {"1195","1495","1595","1795" }
   _cSup   := Space(03)

   if alltrim(sb1->b1_cod) == "0001107"        // CD
      _cSup:= "001"
   elseif alltrim(sb1->b1_cod) == "0001029"    // DSK
      _cSup:= "002"
   endif

   If !Empty( _cSup )

      _dUCOM:= SB1->B1_UCOM
      _nUPRC:= SB1->B1_UPRC

      For _X:= 1 To Len(_aTabSup)
         dbSelectArea("SB1")
         dbSetOrder(1)
         dbSeek( xFilial("SB1")+_aTabSup[_x]+_cSup )
         If Found()
            RecLock("SB1",.F.)
            SB1->B1_UPRC:= _nUPRC
            SB1->B1_UCOM:= _dUCOM
            MsUnlock()
         EndIf
      Next

   EndIf

   dbSelectArea("SB1")
   dbSetOrder(_nIndSB1)
   dbGoto(_nRecSB1 )

   dbSelectArea(_cAlias)
   dbSetOrder(_nIndex)
   dbGoto(_nRecno)

ENDIF

Return
