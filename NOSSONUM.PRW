#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 29/05/03

User Function NOSSONUM()        // incluido pelo assistente de conversao do AP5 IDE em 29/05/03

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CNUMERO,NRESULT,CDC,I,NTAM,NDC")
SetPrvt("_NAUXVAL,CDIG,NOSSONUM,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � NossoNum � Autor � Gilberto A Oliveira Jr� Data � 23/11/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Especifico para calculo de Nosso Numero com Modulo 11.     ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Gen�rico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� Observ.  � O arquivo SEE (Parametros Bancarios) deve estar posicionado���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/// UTILIZA-SE DO PADRAO CD1129 (MODULO 11 de 2 a 9)

//��������������������������������������������������������������Ŀ
//� Fun��o para gerar NossoNum()                                 �
//����������������������������������������������������������������

cNumero:=Alltrim(  Strzero( Val(SEE->EE_FAXATU),14)  )

If Empty(SE1->E1_NUMBCO)

   // Grava PROXIMO NUMERO a ser utilizado.
   DbSelectArea("SEE")
   RecLock("SEE",.F.)
   SEE->EE_FAXATU := Str(Val(cNumero)+1,Len(SEE->EE_FAXATU))
   MsUnlock()

   //��������������������������������������������������������������Ŀ
   //� Fun��o para gerar Digito de Controle                         �
   //����������������������������������������������������������������

   nResult:= 0
   cDc    := ""
   i      := 0
   nTam   :=Len(Alltrim(cNumero))
   nDc    := 0
   _nAuxVal:= 2

   For i:= nTam To 1 Step -1
       nResult := nResult + (Val(SubS(cNumero,i,1)) * _nAuxVal )
       _nAuxVal:= iif( _nAuxVal == 9, 2, _nAuxVal + 1 )
   Next i

   nResult:= nResult * 10
   nDC:= MOD(nResult,11)

   IF nDc > 9
      cDig := "0"
   Else
      cDig := STR(nDc,1)
   EndIF

   Nossonum := Alltrim(cNumero) + Alltrim(cDig)

   DbSelectArea("SE1")
   RecLock("SE1",.F.)
   SE1->E1_NUMBCO := Nossonum
   MsUnlock()
Else
   NossoNum:= SE1->E1_NUMBCO
EndIf

// Substituido pelo assistente de conversao do AP5 IDE em 29/05/03 ==> __Return(NossoNum)
Return(substr(NossoNum,8,8))        // incluido pelo assistente de conversao do AP5 IDE em 29/05/03

