#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

User Function Calmod11()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CNUMERO,_NRESULT,_CDC,_I,_NTAM,_NDC")
SetPrvt("_NAUXVAL,_CDIG,")

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � CalMod11 � Autor � Gilberto A Oliveira Jr� Data � 23/11/00    ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Especifico para calculo de Nosso Numero com Modulo 11.        ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                      ���
����������������������������������������������������������������������������Ĵ��
��� ROTINAS AUXILIARES E RELACIONADAS.                                       ���
��� ����������������������������������                                       ���
��� PFAT210.PRX     - Principal: Chama perguntas e aciona PFAT210A.          ���
���  PFAT210A.PRX   - Aciona A210DET, grava arquivo txt e chama Bloqueto.Exe.���
���   A210DET.PRX   - Dados do Lay-Out para criacao do arquivo.txt           ���
���    NOSSONUM.PRX - Calcula Digito do Nosso Num. e incremente EE_FAXATU.   ���
���    CALMOD10.PRX - Calcula digitos de controle com base no Modulo 1021    ���
���  * CALMOD11.PRX - Calcula digitos do Codigo de Barras com base no Mod.11 ���
����������������������������������������������������������������������������Ĵ��
���Observacao� Caso queira compilar varios desses Rdmakes utilize a Bat      ���
���          � BOL409.                                                       ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

// ParamIXB traz o numero sobre o qual sera calculado o digito verificador.
// Retorna o digito encontrado como caracter de uma posicao.

_cNumero:=ParamIXB


//��������������������������������������������������������������Ŀ
//� Fun��o para gerar Digito de Controle                         �
//����������������������������������������������������������������

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

