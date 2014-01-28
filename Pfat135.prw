#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

User Function Pfat135()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CPERG,MNOTA,MSERIE,MDATA,_SALIAS,AREGS")
SetPrvt("I,J,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT135   �Autor: Raquel Ramalho         � Data:   27/07/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Atualiza a nf refaturada no pedido de convers�o            � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Especifico PINI                                            � ��
������������������������������������������������������������������������Ĵ ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Pedido  C-6                          �
//� mv_par02             // Nota    C-6                          �
//� mv_par03             // Serie   C-6                          �
//����������������������������������������������������������������

cPerg    := "PFT135"
_ValidPerg()


//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������

Pergunte(cPerg,.T.)               // Pergunta no SX1

Do While .T.
   DbSelectArea("SE1")
	DbOrderNickName("E1_PEDIDO") //dbSetOrder(27) 20130225  ///dbSetOrder(15) AP5  //20090114 era(21) //20090723 mp10 era(22) //dbSetOrder(26) 20100412
   DbGotop()
   DbSeek(xfilial()+MV_PAR01)
   If Found()
      mNota :=SE1->E1_NUM
      mSerie:=SE1->E1_SERIE
      mData :=SE1->E1_EMISSAO
      If mNota==MV_PAR02 .AND. mSerie==MV_PAR03
         DbSelectArea("SC6")
         DbSetOrder(1)
         DbGotop()
         DbSeek(xfilial()+MV_PAR01)
         If Found()
            Do While SC6->C6_NUM==MV_PAR01
               If SC6->C6_TES=='700' .OR. SC6->C6_TES=='701'
                  RecLock("SC6",.F.)
                  REPLACE C6_NOTA   with mNota
                  REPLACE C6_SERIE  with mSerie
                  REPLACE C6_DATFAT with mData
                  REPLACE C6_QTDENT with 1
                  SC6->(MsUnLock())
                  skip
               Else
                  skip
               EndIf
             Enddo
         Else
           help(" ",1,"REGNOIS")
         EndIf
      Else
        help(" ",1,"REGNOIS")
      EndIf
   Else
     help(" ",1,"REGNOIS")
   EndIf
   Exit
Enddo

dbSelectArea("SE1")
Retindex("SE1")

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
         cPerg := PADR(cPerg,6)
         aRegs:={}

         // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

         AADD(aRegs,{cPerg,"01","Pedido.:","mv_ch1","C",6,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"02","Nota...:","mv_ch2","C",6,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"03","Serie..:","mv_ch3","C",3,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})

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
