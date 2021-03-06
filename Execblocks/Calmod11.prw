#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

User Function Calmod11()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CNUMERO,_NRESULT,_CDC,_I,_NTAM,_NDC")
SetPrvt("_NAUXVAL,_CDIG,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴컴커굇
굇쿑un뇚o    � CalMod11 � Autor � Gilberto A Oliveira Jr� Data � 23/11/00    낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴컴캑굇
굇쿏escri뇚o � Especifico para calculo de Nosso Numero com Modulo 11.        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� Uso      � Gen굍ico                                                      낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇� ROTINAS AUXILIARES E RELACIONADAS.                                       낢�
굇� 컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴                                       낢�
굇� PFAT210.PRX     - Principal: Chama perguntas e aciona PFAT210A.          낢�
굇�  PFAT210A.PRX   - Aciona A210DET, grava arquivo txt e chama Bloqueto.Exe.낢�
굇�   A210DET.PRX   - Dados do Lay-Out para criacao do arquivo.txt           낢�
굇�    NOSSONUM.PRX - Calcula Digito do Nosso Num. e incremente EE_FAXATU.   낢�
굇�    CALMOD10.PRX - Calcula digitos de controle com base no Modulo 1021    낢�
굇�  * CALMOD11.PRX - Calcula digitos do Codigo de Barras com base no Mod.11 낢�
굇쳐컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑굇
굇쿚bservacao� Caso queira compilar varios desses Rdmakes utilize a Bat      낢�
굇�          � BOL409.                                                       낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽
/*/

// ParamIXB traz o numero sobre o qual sera calculado o digito verificador.
// Retorna o digito encontrado como caracter de uma posicao.

_cNumero:=ParamIXB


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Fun눯o para gerar Digito de Controle                         �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

_nResult:= 0
_cDC    := ""
_i      := 0
_nTam   := Len(Alltrim(_cNumero))
_nDc    := 0
_nAuxVal:= 2  // valor auxiliar.

For _i  := _nTam To 1 Step -1
       _nResult := _nResult + (Val(SubS(_cNumero,_i,1)) * _nAuxVal )
       _nAuxVal:= iif( _nAuxVal == 9, 2, _nAuxVal + 1 )
Next _i

_nResult:= _nResult * 10

_nDc := MOD(_nResult,11)

IF _nDc == 0 .or. _nDc==10  /// > 9
   _cDig := "1"
Else
   _cDig := STR(_nDc,1)
EndIF

// Substituido pelo assistente de conversao do AP5 IDE em 19/03/02 ==> __Return(_cDig)
Return(_cDig)        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

