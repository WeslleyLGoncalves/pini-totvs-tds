#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FC010LIST �Autor  �Danilo C S Pala     � Data �  05/04/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Ponto de Entrada que permite incluir novas linhas na tela de consulta � Posi�ao de Clientes. O ponto de entrada � executado ap�s clicar no bot�o Consultar da rotina FINC010.
User Function FC010LIST()
Local aCols := paramixb
/*Local nTOTVS1 := 0
Local nTOTVS2 := 0

/*Aadd(aCols,{"TOTVS",TRansform(Round(Noround(xMoeda(nTOTVS1, nTOTVS2 ,1, dDataBase,MsDecimais(1)+1 ),2),MsDecimais(1)),PesqPict("SA1","A1_MSALDO",14,1)),;
            TRansform(nTOTVS1,PesqPict("SA1","A1_MSALDO",14,nTOTVS2))," ","TOTVS",""}) 
*/
		U_PINILOGCONS(SM0->M0_CODIGO, SA1->A1_COD, SA1->A1_LOJA, "", "", "", NIL, "", "CON", "FINC010", "POSICAO CLIENTE") //20120504
Return aCols 