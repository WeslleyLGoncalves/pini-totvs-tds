#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Md2linok()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("NLINGETD,")

nLinGetD:=n
#IFDEF WINDOWS
	MsgStop("Estava na Linha "+Alltrim(Str(n))+" da GetDados")
#ELSE
	Alert("Estava na Linha "+AllTrim(Str(n))+" da GetDados")
#ENDIF
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __RETURN(.T.)	
Return(.T.)	        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
