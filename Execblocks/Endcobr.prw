#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

User Function Endcobr()        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("MRET,")

AxCadastro("SZ5","EndCobr")
IF Z5_END==' '
   MRET:='N'
ELSE
   MRET:='S'
ENDIF
// Substituido pelo assistente de conversao do AP5 IDE em 16/03/02 ==> __return(MRET)
Return(MRET)        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02


