#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

User Function Etmka04()        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALIAS,_NPOSEDINIC,_NPOSEDFIN,_NPOSEDVENC,_NPOSPRODUTO,_CPRODUTO")
SetPrvt("_NORDEMSB1,_NREGSB1,_NORDEMSZ3,_NREGSZ3,ACOLS,")


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � ETMKA04  � Autor � Fabio William         � Data � 18.05.99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Preenche os Campos do Itens do Orcamento                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico para EDITORA PINI.                              낢�
굇�          � Gatilhado pelo campo UB_PRODUTO                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢pDate    �                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

_cAlias    := Alias()
_nPosEDINIC  := ASCAN(aheader,{|x| alltrim(x[2])=="UB_EDINIC"})
_nPosEDFIN   := ASCAN(aheader,{|x| alltrim(x[2])=="UB_EDFIN"})
_nposEDVENC  := ASCAN(aheader,{|x| alltrim(x[2])=="UB_EDVENC"})
_nPosPRODUTO := ASCAN(aheader,{|x| alltrim(x[2])=="UB_PRODUTO"})

_cProduto :=  aCols[N,_nPosProduto]

// 旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
// 쿞alva Alias e Posiciona os arquivos     �
// 읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸


DbSelectArea("SB1")
_nOrdemSB1 := IndexOrd()
_nRegSB1   := Recno()
DbSetOrder(01)
DbSeek(xFilial()+_cProduto)

DbSelectarea("SZ3")
_nOrdemSZ3 := IndexOrd()
_nRegSZ3   := Recno()
DbSeek(xFILIAL("SZ3")+_cProduto+SA3->A3_REGIAO)


aCols[N,_nposEDFIN]   :=  aCols[N,_nposEDINIC]+SB1->B1_QTDEEX
aCols[N,_nposEDVENC]  :=  aCols[N,_nposEDINIC]+SB1->B1_QTDEEX+SB1->B1_EXBONIF

DbSelectArea("SB1")
IndexOrd(_nOrdemSB1)
DbGoTo(_nRegSB1)

DbSelectarea("SZ3")
IndexOrd(_nOrdemSZ3)
DbGoTo(_nRegSZ3)

DbSelectarea(_cAlias)


// Substituido pelo assistente de conversao do AP5 IDE em 16/03/02 ==> __return(aCols[N,_nposEDINIC])
Return(aCols[N,_nposEDINIC])        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02



