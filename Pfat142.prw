#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

User Function Pfat142()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,_SALIAS,AREGS,I,J,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT142   �Autor: Raquel Ramalho         � Data:   12/09/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Libera pedido para refaturamento                           � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI                                            � ��
������������������������������������������������������������������������Ĵ ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Pedido  C-6                          �
//����������������������������������������������������������������

cPerg    := "PFT142"
_ValidPerg()

//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������

Pergunte(cPerg,.T.)               // Pergunta no SX1

Do While .T.
   dbSelectArea("SC6")
   DbSetOrder(1)
   DbGotop()
   DbSeek(xfilial()+MV_PAR01)
   If Found()
      Do While SC6->C6_NUM==MV_PAR01
         If SC6->C6_TES=='700' .OR. SC6->C6_TES=='701'
            RecLock("SC6",.f.)
            REPLACE C6_NOTA   with ' '
            REPLACE C6_SERIE  with ' '
            REPLACE c6_DATFAT with CTOD('  /  /  ')
            REPLACE C6_QTDENT with 0
            SC6->(MsUnLock())
            skip
         Else
            skip
         EndIf
       Enddo
   Else
     help(" ",1,"REGNOIS")
   EndIf
   Exit
Enddo

dbSelectArea("SC6")
Retindex("SC6")

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �VALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 16/07/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Verifica as perguntas inclu�ndo-as caso n�o existam        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Espec�fico para clientes Microsiga                         ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function _ValidPerg
Static Function _ValidPerg()

         _sAlias := Alias()
         DbSelectArea("SX1")
         DbSetOrder(1)
         cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
         aRegs:={}

         // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

         AADD(aRegs,{cPerg,"01","Pedido.:","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})

         For i:=1 to Len(aRegs)
             If !dbSeek(cPerg+aRegs[i,2])
                 RecLock("SX1",.T.)
                 For j:=1 to FCount()
                     If j <= Len(aRegs[i])
                         FieldPut(j,aRegs[i,j])
                     Endif
                 Next
                 SX1->(MsUnlock())
             Endif
         Next

         DbSelectArea(_sAlias)

Return

