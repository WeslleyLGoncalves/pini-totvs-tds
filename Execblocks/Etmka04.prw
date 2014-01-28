#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

User Function Etmka04()        // incluido pelo assistente de conversao do AP5 IDE em 16/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_CALIAS,_NPOSEDINIC,_NPOSEDFIN,_NPOSEDVENC,_NPOSPRODUTO,_CPRODUTO")
SetPrvt("_NORDEMSB1,_NREGSB1,_NORDEMSZ3,_NREGSZ3,ACOLS,")


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ETMKA04  � Autor � Fabio William         � Data � 18.05.99 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Preenche os Campos do Itens do Orcamento                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico para EDITORA PINI.                              ���
���          � Gatilhado pelo campo UB_PRODUTO                            ���
�������������������������������������������������������������������������Ĵ��
���UpDate    �                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

_cAlias    := Alias()
_nPosEDINIC  := ASCAN(aheader,{|x| alltrim(x[2])=="UB_EDINIC"})
_nPosEDFIN   := ASCAN(aheader,{|x| alltrim(x[2])=="UB_EDFIN"})
_nposEDVENC  := ASCAN(aheader,{|x| alltrim(x[2])=="UB_EDVENC"})
_nPosPRODUTO := ASCAN(aheader,{|x| alltrim(x[2])=="UB_PRODUTO"})

_cProduto :=  aCols[N,_nPosProduto]

// ����������������������������������������Ŀ
// �Salva Alias e Posiciona os arquivos     �
// ������������������������������������������


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



