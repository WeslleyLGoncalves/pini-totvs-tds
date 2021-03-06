#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Sd1100i()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_NINDEX,_NRECNO,_NINDSB1,_NRECSB1,_ATABSUP")
SetPrvt("_CSUP,_DUCOM,_NUPRC,_X,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컫컴컴컴쩡컴컴컴컴커굇
굇쿛.Entrada � SD1100I  � Autor � Gilberto A. de Oliveira  � Data � 13/09/00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컨컴컴컴좔컴컴컴컴캑굇
굇쿏escricao � Ponto de entrada apos a gravacao dos itens da nota de entrada.낢�
굇�          � tem por funcao atualizar os valores de suporte informatico.   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿢so       � Especifico para Editora Pini Ltda.                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿌lteracoes�                                                               낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
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
