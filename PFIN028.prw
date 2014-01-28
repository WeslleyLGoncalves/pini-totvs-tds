#include "rwmake.ch"        
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFIN028   �Autor: DANILO CESAR SESTARI PALA � Data: 20110111� ��
������������������������������������������������������������������������Ĵ ��
���Descri��o: Relatorio CONTAS A PAGAR TITULO PAI                        � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : Pini													     � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function PFIN028()

SetPrvt("CPERG,_StringArq, cquery, MHORA, aRegs")
MHORA      := TIME()
_StringArq := "\SIGA\ARQTEMP\"+ SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2) +".DBF"

//�������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros      �
//� mv_par01             Vencto de            �
//� mv_par02             Vencto ate           �
//� mv_par03             Tipo				  �
//� mv_par04             Natureza             �
//���������������������������������������������
cPerg    := "PFIN028"  
ValidPerg()
If !Pergunte(cPerg)
   Return
Endif

If Select("PFIN028") <> 0
	DbSelectArea("PFIN028")
	DbCloseArea()
EndIf
      
bBloco:= { |lEnd| RptDetail()  }
MsAguarde( bBloco, "Aguarde" ,"Processando...", .T. )

RETURN


Static Function RptDetail() 

cQuery := "select se2.e2_parcela as PARC, se2.e2_tipo as TIP, se2.e2_naturez as NAT, se2.e2_codret AS COD_RET, se2.e2_fornece AS FOR_TIT, se2.e2_loja as LOJA_TIT, sf1.f1_fornece as COD_FORN, sf1.f1_loja as LOJA_FOR, sa2.a2_nome as NOME, se2.e2_prefixo as PREF, se2.e2_num AS NUM_NF, sf1.f1_valbrut as VR_BRUTO, se2.e2_valor as VR_IMP, substr(f_converter_data_siga(se2.e2_emissao),1,10) as EMIS_TIT, substr(f_converter_data_siga(sf1.f1_emissao),1,10) as EMIS_NF, substr(f_converter_data_siga(se2.e2_baixa),1,10) as DT_BAIXA, substr(f_converter_data_siga(se2.e2_vencto),1,10) as VENC_IMP, substr(f_converter_data_siga(se2.e2_vencrea),1,10) as VENC_REAL, se2.e2_titpai AS TIT_PAI "
cQuery := cQuery + " from "+ RetSqlName("SE2") +" se2, "+ RetSqlName("SF1") +" sf1, "+ RetSqlName("SA2") +" sa2"
cQuery := cQuery + " where e2_filial='"+ xFilial("SE1") +"' and e2_vencto >='"+ DTOS(MV_PAR01) +"' and e2_vencto <='"+ DTOS(MV_PAR02) +"' and e2_tipo = '"+ MV_PAR03 +"' and e2_naturez='"+ MV_PAR04 +"' and se2.d_e_l_e_t_<>'*'"
cQuery := cQuery + " and sf1.f1_filial(+)='"+ xFilial("SF1") +"' and sf1.f1_prefixo(+) = substr(se2.e2_titpai,1,3)"
cQuery := cQuery + " and sf1.f1_doc(+) = substr(se2.e2_titpai,4,9)"
cQuery := cQuery + " and sf1.f1_fornece(+) = substr(se2.e2_titpai,17,6)"
cQuery := cQuery + " and sf1.f1_loja(+) = substr(se2.e2_titpai,23,2)"
cQuery := cQuery + " and sf1.d_e_l_e_t_(+)<>'*'"
cQuery := cQuery + " and sa2.a2_filial(+) = '"+ xFilial("SA2") +"'"
cQuery := cQuery + " and sa2.a2_cod(+)= sf1.f1_fornece"
cQuery := cQuery + " and sa2.a2_loja(+)= sf1.f1_loja"  
cQuery := cQuery + " order by se2.e2_prefixo, se2.e2_num, se2.e2_parcela, se2.e2_tipo"

MsAguarde({|| DbUseArea( .T., "TOPCONN", TcGenQry(,,cQuery), "PFIN028", .T., .F. )},"Aguarde - NAO DESCONECTE!","Selecionando dados. Isto pode demorar um pouco...")
DBSelectArea("PFIN028")
DBGotop()
COPY TO &_StringArq VIA "DBFCDXADS" // 20121106 
DBCLOSEAREA()   
MsgInfo(_StringArq)
RETURN




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ValidPerg �Autor  �Marcio Torresson    � Data �  10/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria parametros no SX1 nao existir os parametros.           ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Pini                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs := {}
//�������������������������������������������Ŀ
//� Vari�veis utilizadas para parametros      �
//� mv_par01             Vencto de            �
//� mv_par02             Vencto ate           �
//� mv_par03             Tipo				  �
//� mv_par04             Natureza             �
//���������������������������������������������
aAdd(aRegs,{cPerg,"01","Vencimento de  ","Vencimento de  ","Vencimento de  ","mv_ch1","D",08,0,0,"G","","MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Vencimento ate ","Vencimento ate ","Vencimento ate ","mv_ch2","D",08,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"03","Tipo           ","Tipo           ","Tipo           ","mv_ch3","C",03,0,0,"G","","MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"04","Natureza       ","Natureza       ","Natureza       ","mv_ch4","C",10,0,0,"G","","MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

_nLimite := If(Len(aRegs[1])<FCount(),Len(aRegs[1]),FCount())
For i := 1 To Len(aRegs)
	If !DbSeek(cPerg + aRegs[i,2])
		Reclock("SX1", .T.)
		For j := 1 to _nLimite
			FieldPut(j, aRegs[i,j])
		Next
		MsUnlock()
	Endif
Next
DbSelectArea(_sAlias)

Return(.T.)