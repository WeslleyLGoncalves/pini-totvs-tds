#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02
// Danilo C S Pala: alterado a pedido do cicero, completar pesquisa por indice
User Function cfat001()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("CSAVTELA,CSAVCURSOR,CSAVCOR,CSAVALIAS,CPERG,MVPAR")
SetPrvt("MNOTA,MDATA, MSERIE, MCLIENTE")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: CFAT001   �Autor: Solange Nalini         � Data:   20/01/00 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: CONSULTA DE NF PELO PEDIDO                                 � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento/                                     � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//cSavTela   := SaveScreen( 0, 0,23,80)
//cSavCursor := SetCursor()
//cSavCor    := SetColor()
//cSavAlias  := Select()

//������������������������������������������Ŀ
//� Recupera o desenho padrao de atualizacoes�
//��������������������������������������������
//ScreenDraw("SMT050", 3, 0, 0, 0)
//SetCursor(1)
//SetColor("B/BG")
//
//DO WHILE .T.

   CPERG:="PFAT50"

   If .Not. PERGUNTE(cPerg)
       Return
   Endif

   MVPAR:=MV_PAR01
   DBSELECTAREA("SC5")
   DBSETORDER(1)
   IF DBSEEK(XFILIAL()+MVPAR)
      MNOTA   := SC5->C5_NOTA        
      MSERIE  := SC5->C5_SERIE
      MCLIENTE:= SC5->C5_CLIENTE
      DBSELECTAREA("SF2")
      DBSETORDER(1)

      IF DBSEEK(XFILIAL()+MNOTA+MSERIE+MCLIENTE)
         MDATA := SF2->F2_EMISSAO
      ENDIF
      notali := sc5->c5_nota
      datli  := DTOC(SF2->F2_EMISSAO)
  
      ALERT("N� da Nota Fiscal -->  " + sc5->c5_nota +' '+ SC5->C5_SERIE +'  de   '+ datli)
   Else
     ALERT("O pedido n�o se encontra faturado, Verifique !!")
   endif

RETURN