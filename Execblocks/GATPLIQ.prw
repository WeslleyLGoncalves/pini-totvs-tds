#INCLUDE "rwmake.ch"                       
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  | GATPLIQ  � Autor � DANILO C S PALA    � Data �  20100614   ���
�������������������������������������������������������������������������͹��
���Descricao � Gatilho para calcular o peso liquido e bruto para a NFe    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function GATPLIQ()
Local nX      := 0
Local nQtd    := 0
Local cProd   := ""
Local nPeso   := 0
Local nPesoL  := 0
Local nQtdVAL := aCols[n,aScan(aHeader ,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })]

    For nX := 1 To len(aCols)
		nQtd   := aCols[nX,aScan(aHeader ,{|x| Upper(AllTrim(x[2]))=="C6_QTDVEN" })]
		cProd  := aCols[nX,aScan(aHeader ,{|x| Upper(AllTrim(x[2]))=="C6_PRODUTO" })]				
		nPeso  := posicione("SB1",1,xfilial("SB1")+cProd,"B1_PESO")
		nPesoL := nPesoL + (nQtd * nPeso)
    Next nX        
    M->C5_PESOL  := nPesoL
    M->C5_PBRUTO := (nPesoL + 0.150)
Return(nQtdVAL)