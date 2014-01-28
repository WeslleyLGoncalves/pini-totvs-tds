#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

User Function Possb1_1()        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NORDEM,_NRECNO,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �POSSB1_1  � Autor �Solange                � Data � 16/03/02 ���
�������������������������������������������������������������������������Ĵ��
���Descricao �EXECBLOCK                                                   ���
���          �---------                                                   ���
���          �Posiciona o arquivo SB1 quando da Exclusao da Nota Fiscal,  ���
���          �afim de retornar a conta DEBITO  do cmv para contab. do     ���
���          �Estorno.                                                    ���
�������������������������������������������������������������������������Ĵ��
���Observacao�Adaptacao do POSSB1 feita por Gilberto Oliveira em 14/07/00 ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
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

// Substituido pelo assistente de conversao do AP5 IDE em 21/03/02 ==> __return( sb1->b1_conta2)
Return( sb1->b1_conta2)        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02