#include "rwmake.ch"
//#INCLUDE "TOPCONN.CH"  //consulta SQL
#INCLUDE "PROTHEUS.CH"
#INCLUDE "COLORS.CH"
#INCLUDE "TBICONN.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �RFAT125   � Autor �  Danilo C S Pala      � Data � 20100713 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � CONSULTAR NFELETRONICA POR CHAVE                           ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico PINI                                            ���
�������������������������������������������������������������������������Ĵ��
��� Release  � 															  ���
���          � 															  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function RFAT125()
Private cId_ent := ""      
Private cNf_chv := ""
Private cMsg := ""
Private cAliasCONS  := "SPED054"   


cperg := "RFAT125"
ValidPerg()
Pergunte(cPerg,.t.)   

if mv_par01==1 //ED
	cId_ent := "000001"
elseif mv_par01==2 //PSE
	cId_ent := "000003"
else //BP
	cId_ent := "000002"
endif   
cNf_chv := mv_par02
         

#IFDEF TOP
	cAliasCONS := GetNextAlias()
	BeginSql Alias cAliasCONS
		//select  id_ent, nfe_id, nfe_chv from sped054 where d_e_l_e_t_<>'*'
		SELECT ID_ENT, NFE_ID, NFE_CHV
		FROM SPED054 CONS
		WHERE
		CONS.ID_ENT = %Exp:cId_ent%
		AND CONS.NFE_CHV = %Exp:cNf_chv%
		AND CONS.%NotDel%
	EndSql
	if !Eof() //.And. xFilial("SE1") == (cAliasSE1)->E1_FILIAL
		cMsg := "A chave: "+ cNf_chv +chr(10)+chr(13) +"corresponde a nota: "+ Rtrim((cAliasCONS)->NFE_ID)
	else
		cMsg :="chave nao encontrada"
	endif	             
	
#ELSE
		cMsg :="Habilitado somente para TOP/ORACLE"
#ENDIF

msgInfo(cMsg)

return



Static Function ValidPerg()
_sAlias := Alias()
dbSelectArea("SX1")
dbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs := {}
aAdd(aRegs,{cPerg,"01","Empresa?","Empresa?","Empresa?","mv_ch1","N",01,0,2,"C","","MV_PAR01","ED","ED","ED","","","PSE","PSE","PSE","","","BP","BP","BP","","","","","","","","","","","","","","","",""})
aAdd(aRegs,{cPerg,"02","Chave?","Chave?","Chave?","mv_ch2","C",44,0,0,"G","","MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","","","","","",""})

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