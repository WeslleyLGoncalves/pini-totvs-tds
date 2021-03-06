#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

User Function possb1_2()        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_NORDEM,_NRECNO,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  쿛OSSB1_2  � Autor 쿞olange                � Data � 16/03/02 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao 쿐XECBLOCK                                                   낢�
굇�          �---------                                                   낢�
굇�          쿛osiciona o arquivo SB1 quando da Exclusao da Nota Fiscal,  낢�
굇�          쿪fim de retornar a conta CREDITO do cmv para contab. do     낢�
굇�          쿐storno.                                                    낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿚bservacao쿌daptacao do POSSB1 feita por Gilberto Oliveira em 14/07/00 낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

_cAlias:= Alias()
_nOrdem:= IndexOrd()
_nRecno:= Recno()

DbSelectArea("SB1")
DbSetOrder(1)
DbSeek(xFilial("SB1")+SD2->D2_COD)

DbSelectArea( _cAlias )
DbSetOrder( _nOrdem )
DbGoTo( _nRecno )

// Substituido pelo assistente de conversao do AP5 IDE em 21/03/02 ==> __return( sb1->b1_conta1)
Return( sb1->b1_conta1)        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02