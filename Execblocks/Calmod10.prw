#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

User Function Calmod10()        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CNUMPAR,_NMULT,_NSOMA,_X1,_NPARTE,_CAUXVAR")
SetPrvt("_NVERNUM,_NDIGVER,_CNRCOMPLETO,")

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Fun��o    � CalcMod10� Autor � Gilberto A. Oliveira  � Data � 23/11/00    ���
����������������������������������������������������������������������������Ĵ��
���Descri��o � Calcula digito conforme as regras do Modulo 1021.             ���
����������������������������������������������������������������������������Ĵ��
���Parametros� Deve ser passado o n�mero sobre o qual ser� calculado o       ���
���          � digito.                                                       ���
����������������������������������������������������������������������������Ĵ��
���Retorno   � Sera retornado o n�mero passado como parametro acrescido do   ���
���          � digito calculado.                                             ���
����������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                      ���
����������������������������������������������������������������������������Ĵ��
��� ROTINAS AUXILIARES E RELACIONADAS.                                       ���
��� ����������������������������������                                       ���
��� PFAT210.PRX     - Principal: Chama perguntas e aciona PFAT210A.          ���
���  PFAT210A.PRX   - Aciona A210DET, grava arquivo txt e chama Bloqueto.Exe.���
���   A210DET.PRX   - Dados do Lay-Out para criacao do arquivo.txt           ���
���    NOSSONUM.PRX - Calcula Digito do Nosso Num. e incremente EE_FAXATU.   ���
��� *  CALMOD10.PRX - Calcula digitos de controle com base no Modulo 1021    ���
���    CALMOD11.PRX - Calcula digitos do Codigo de Barras com base no Mod.11 ���
����������������������������������������������������������������������������Ĵ��
���Observacao� Caso queira compilar varios desses Rdmakes utilize a Bat      ���
���          � BOL409.                                                       ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/

_cNumPar:= ParamIXB
_nMult:= 2
_nSoma:= 0

For _x1:= Len(_cNumPar) to 1 Step -1

    _nParte:= Val(SubSt(_cNumPar,_x1,1))
    _cAuxVar:= Alltrim(Str(_nMult*_nParte,2))
    _nVerNum:= Iif(Len(_cAuxVar)>1,Val(Left(_cAuxVar,1))+Val(Right(_cAuxVar,1)),Val(_cAuxVar))
    _nSoma:= _nSoma + _nVerNum
    _nMult:= iif( _nMult == 2 , 1 , 2)

Next

//Alert( "Soma das Multiplicacoes: "+Str(_nSoma) )

_nDigVer:= 10 - MOD(_nSoma,10)

If _nDigVer >= 10
   _nDigVer:= 0
EndIf

_cNrCompleto:= _cNumPar+Str(_nDigVer,1)

//Alert("Digito Encontrado : "+Str(_nDigVer,1) )
// Substituido pelo assistente de conversao do AP5 IDE em 19/03/02 ==> __Return(_cNrCompleto)
Return(_cNrCompleto)        // incluido pelo assistente de conversao do AP5 IDE em 19/03/02


