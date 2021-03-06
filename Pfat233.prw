#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02
//Danilo C S Pala 20100305: ENDBP
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT233   �Autor: Mauricio Mendes        � Data:   13/11/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Gera Arquivo dbf para outra empresa imprimir os boletos    � ��
���                                                                      � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento - RENOVACAO AUTOMATICA !!!           � ��
������������������������������������������������������������������������Ĵ ��
���OBSERV.  :                                                            � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat233()        // incluido pelo assistente de conversao do AP5 IDE em 21/03/02

SetPrvt("_LABORTO,CPERG,_ACAMPOS,_CNOME,LEND,MCONTA")
SetPrvt("MEND,MBAIRRO,MCEP,MCIDADE,MESTADO,MCODDEST")
SetPrvt("MNOMEDEST,MENDDEST,MBAIRRODEST,MMUNDEST,MESTDEST,MCEPDEST")
SetPrvt("_CCGC,_SALIAS,AREGS,I,J,")
//�������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                              �
//� mv_par01             //PREFIXO DE                     "C",03      �
//� mv_par02             //PREFIXO ATE                    "C",03      �
//� mv_par03             //NUMERO DE                      "C",06      �
//� mv_par04             //NUMERO ATE                     "C",06      �
//� mv_par05             //ARQUIVO DESTINO                "C",20      �
//���������������������������������������������������������������������
_lAborto := .f.
//�������������������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                                      �
//���������������������������������������������������������������������������
cPerg := "FAT233"
//_ValidPerg()
If !Pergunte(cPerg,.T.)
   Return
Endif

_aCampos := {}
aAdd( _aCampos, {"VALOR"     ,"N",012,2})
aAdd( _aCampos, {"VCTO"      ,"D",008,0})
aAdd( _aCampos, {"BANCO"     ,"C",003,0})
aAdd( _aCampos, {"AGENCIA"   ,"C",004,0})
aAdd( _aCampos, {"CONTA"     ,"C",007,0})
aAdd( _aCampos, {"EMISSAO"   ,"D",008,0})
aAdd( _aCampos, {"NUMDOC"    ,"C",009,0})
aAdd( _aCampos, {"NOSSONUM"  ,"C",009,0})
aAdd( _aCampos, {"NOMECLI"   ,"C",040,0})
aAdd( _aCampos, {"ENDERECO"  ,"C",040,0})        // 16/05/02 - Alterado o nome do campo de "END" para "ENDERECO"
aAdd( _aCampos, {"BAIRRO"    ,"C",020,0})        // a pedido da Microwork (Empresa que gera os boletos)
aAdd( _aCampos, {"MUN"       ,"C",020,0})
aAdd( _aCampos, {"EST"       ,"C",002,0})
aAdd( _aCampos, {"CEP"       ,"C",008,0})
aAdd( _aCampos, {"Nomedest"  ,"C",040,0})
aAdd( _aCampos, {"Enddest"   ,"C",040,0})
aAdd( _aCampos, {"Bairrodest","C",020,0})
aAdd( _aCampos, {"Mundest"   ,"C",020,0})
aAdd( _aCampos, {"Estdest"   ,"C",002,0})
aAdd( _aCampos, {"CEPdest"   ,"C",008,0})
aAdd( _aCampos, {"ESPECIE"   ,"C",002,0})
aAdd( _aCampos, {"ACEITE"    ,"C",100,0})
aAdd( _aCampos, {"INSTR1"    ,"C",100,0})
aAdd( _aCampos, {"INSTR2"    ,"C",100,0})
aAdd( _aCampos, {"INSTR3"    ,"C",100,0})
aAdd( _aCampos, {"INSTR4"    ,"C",100,0})
aAdd( _aCampos, {"CGC"       ,"C",018,0})
aAdd( _aCampos, {"EDFIMATU"  ,"N",004,0})
aAdd( _aCampos, {"DATAFIM"   ,"D",008,0})
aAdd( _aCampos, {"CODCLI"    ,"C",006,0})
aAdd( _aCampos, {"LOJACLI"   ,"C",002,0})
aAdd( _aCampos, {"PEDOLD"    ,"C",006,0})
aAdd( _aCampos, {"EDINIC"    ,"N",004,0})
aAdd( _aCampos, {"EDFIM"     ,"N",004,0})
aAdd( _aCampos, {"DATAEDINI" ,"D",008,0})
aAdd( _aCampos, {"DATAEDFIM" ,"D",008,0})
aAdd( _aCampos, {"VALIDADE"  ,"D",008,0})
aAdd( _aCampos, {"DATAINIC"  ,"D",008,0})
aAdd( _aCampos, {"REVISTA"	 ,"C",040,0})

_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"TRB",.F.,.F.)

lEnd := .f.

Processa( {|lEnd| Principal(@lEnd),"Aguarde","Preparando Processamento...",.t.})

Return

Static Function Principal()

DbSelectArea("ZZE")
dbSetOrder(1)  // Prefixo+Numero+Parcela+Cliente+Loja
dbSeek(xFilial("ZZE")+Padr(Alltrim(MV_PAR01),3)+Padr(Alltrim(MV_PAR03),6),.t.)
//cArq     := CriaTrab(NIL,.F.)
//cKey     := "ZZE_FILIAL+ZZE_PREFIX+ZZE_NUM"
//cFiltro  := 'ZZE_PREFIX >= "'+MV_PAR01+'"'
//cFiltro  += ' .and. ZZE_PREFIX <="'+MV_PAR02+'"'
//cFiltro  += ' .and. ZZE_NUM >= "'+MV_PAR03+'" .and. ZZE_NUM <= "'+MV_PAR04+"'
//IndRegua("ZZE",cArq,cKey,,,"Selecionando registros .. ")
//dbSeek(xFilial("ZZE")+Padr(Alltrim(MV_PAR01),3)+Padr(Alltrim(MV_PAR03),6),.t.)
mconta := 0
ProcRegua(RecCount())
While !eof() .and. ZZE->ZZE_FILIAL == xFilial("ZZE") .and. ZZE->ZZE_PREFIX+ZZE->ZZE_NUM <= MV_PAR02+MV_PAR04 .and. !lEnd
    mConta++
    mEND       := ""
    mBAIRRO    := ""
    mCEP       := ""
    mCIDADE    := ""
    mESTADO    := ""
    mCODDEST   := ""
    mNomedest  := ""
    mEnddest   := ""
    mBairrodest:= ""
    mMundest   := ""
    mEstdest   := ""
    mCEPdest   := ""

    dbSelectArea("SA1")
    dbSetOrder(1)
    dbSeek(xFilial("SA1")+ZZE->ZZE_CLIENT+ZZE->ZZE_LOJA)

    _cCGC := Space(LEN(SA1->A1_CGC))
    If Empty(SA1->A1_CGC)
      _cCGC := SA1->A1_CGCVAL
    Else
       If Trim(Upper(SA1->A1_TPCLI)) == "J"
         _cCGC := Transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
       ElseIf Trim(Upper(SA1->A1_TPCLI))=="F"
         _cCGC := Transform(SA1->A1_CGC,"@R 999.999.999-99")
       EndIf
    EndIf

//20100305 DAQUI
	IF SM0->M0_CODIGO =="03" .AND. SA1->A1_ENDBP ="S"
		DbSelectArea("ZY3")
		DbSetOrder(1)
		DbSeek(XFilial()+XCLI+XLOJA)
		MEND    :=ZY3_END
		MBAIRRO :=ZY3_BAIRRO
		MCIDADE :=ZY3_CIDADE
		MESTADO :=ZY3_ESTADO
		MCEP    :=ZY3_CEP
	ELSEIF SUBS(SA1->A1_ENDCOB,1,1)=='S' .AND. SM0->M0_CODIGO <>"03"  //ATE AQUI 20100305
      DbselectArea("SZ5")
      DbsetOrder(1)
      DbSeek(xFilial("SZ5")+SA1->A1_COD+SA1->A1_LOJA)
      MEND    := SZ5->Z5_END
      MBAIRRO := SZ5->Z5_BAIRRO
      MCEP    := SZ5->Z5_CEP
      MCIDADE := SZ5->Z5_CIDADE
      MESTADO := SZ5->Z5_ESTADO
   Else
      MEND    := SA1->A1_END
      MBAIRRO := SA1->A1_BAIRRO
      MCEP    := SA1->A1_CEP
      MCIDADE := SA1->A1_MUN
      MESTADO := SA1->A1_EST
   EndIf

   DbSelectArea("SC6")
   DbSetOrder(1)
   DbSeek(xFilial("SC6")+ZZE->ZZE_PEDOLD+ZZE->ZZE_ITEM)
   MCODDEST := SC6->C6_CODDEST
   If !Empty(MCODDEST)
      DbSelectArea("SZN")
      If DbSeek(xFilial()+SA1->A1_COD+SC6->C6_CODDEST)
         mNomeDest := SZN->ZN_NOME
      Endif

      DbSelectArea("SZO")
      If DbSeek(xFilial("SZO")+SA1->A1_COD+SC6->C6_CODDEST)
         mEnddest    := SZO->ZO_END
         mBairrodest := SZO->ZO_BAIRRO
         mMundest    := SZO->ZO_CIDADE
         mEstdest    := SZO->ZO_ESTADO
         mCEPdest    := SZO->ZO_CEP
      Else
         mEnddest    := MEND
         mBairrodest := MBAIRRO
         mMundest    := MCIDADE
         mEstdest    := MESTADO
         mCEPdest    := MCEP
      Endif
   Else
      mEnddest    := MEND
      mBairrodest := MBAIRRO
      mMundest    := MCIDADE
      mEstdest    := MESTADO
      mCEPdest    := MCEP
   Endif

   dbSelectArea("SZJ")
   dbSetOrder(1)
   dbSeek(xFilial("SZJ")+SUBSTR(SC6->C6_PRODUTO,1,4)+STR(SC6->C6_EDSUSP,4,0))

   If SC6->C6_EDSUSP>MV_PAR06
      DbSelectArea("ZZE")
      DbSkip()
      Loop
   Endif

//   SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO))       // 15/08  
   SB1->(dbSeek(xFilial("SB1")+SUBSTR(SC6->C6_PRODUTO,1,4)+'000'))     // 15/08

   MDESCRPROD := SB1->B1_DESC

   SB1->(DbSeek(xFilial("SB1")+SC6->C6_PRODUTO)) 
   
   SB5->(DbSeek(xFilial("SB5")+SC6->C6_PRODUTO))        //  23/08
   
   DbSelectArea("TRB")
   IncProc("Lendo Boleto : "+Padr(ZZE->ZZE_PREFIX+ZZE->ZZE_NUM+ZZE->ZZE_PARCEL,10)+" Gravando...... "+Padr(Str(mConta,7),7))
   RecLock("TRB",.T.)
   TRB->REVISTA    :=  MDESCRPROD
   TRB->DATAFIM    :=  SZJ->ZJ_DTCIRC
   TRB->VALIDADE   :=  ZZE->ZZE_VENCTO
   TRB->VALOR      :=  ZZE->ZZE_VALOR
   TRB->VCTO       :=  ZZE->ZZE_VENCTO
   TRB->BANCO      :=  ZZE->ZZE_BANCO
   TRB->AGENCIA    :=  ZZE->ZZE_AGENCIA
   TRB->CONTA      :=  ZZE->ZZE_CTACOR
   TRB->EMISSAO    :=  ZZE->ZZE_EMISSA
   TRB->NUMDOC     :=  ZZE->ZZE_PREFIX+ZZE->ZZE_NUM
   TRB->NOSSONUM   :=  ZZE->ZZE_NNUM
   TRB->NOMECLI    :=  SA1->A1_NOME
   TRB->ENDERECO   :=  MEND            // 16/05/02 Alterado de TRB->END para TRB->ENDERECO 
   TRB->BAIRRO     :=  MBAIRRO
   TRB->MUN        :=  MCIDADE
   TRB->EST        :=  MESTADO
   TRB->CEP        :=  MCEP
   TRB->Nomedest   :=  mNomedest
   TRB->Enddest    :=  mEnddest
   TRB->Bairrodest :=  mBairrodest
   TRB->Mundest    :=  mMundest
   TRB->Estdest    :=  mEstdest
   TRB->CEPdest    :=  mCEPdest
   TRB->ESPECIE    :=  "DM"
   TRB->ACEITE     :=  "N"
   TRB->INSTR1     :=  ZZE->ZZE_INSTR1
   TRB->INSTR2     :=  ZZE->ZZE_INSTR2
   TRB->INSTR3     :=  ZZE->ZZE_INSTR3
   TRB->INSTR4     :=  ZZE->ZZE_INSTR4
   TRB->CGC        :=  _cCgc
   TRB->CODCLI     :=  ZZE->ZZE_CLIENT
   TRB->LOJACLI    :=  ZZE->ZZE_LOJA
   TRB->PEDOLD     :=  ZZE->ZZE_PEDOLD
   TRB->EDFIMATU   :=  SC6->C6_EDSUSP
   TRB->EDINIC     :=  SC6->C6_EDSUSP+1
   TRB->EDFIM      :=  (SC6->C6_EDSUSP+1)+( SB1->B1_QTDEEX -1 )
   MsUnlock()   

   dbSelectArea("SZJ")
   dbSetOrder(1)
   dbSeek(xFilial("SZJ")+SUBSTR(SC6->C6_PRODUTO,1,4)+STR(SC6->C6_EDSUSP+1,4,0))
   DbSelectArea("TRB")
   RecLock("TRB",.f.)
   TRB->DATAEDINI  := SZJ->ZJ_DTCIRC
   MsUnlock()

   dbSelectArea("SZJ")
   dbSetOrder(1)
   dbSeek(xFilial("SZJ")+SUBSTR(SC6->C6_PRODUTO,1,4)+STR(SC6->C6_EDINIC,4))
   DbSelectArea("TRB")
   RecLock("TRB",.f.)
   TRB->DATAINIC := SZJ->ZJ_DTCIRC
   MsUnlock()
   
   dbSelectArea("SZJ")
   dbSetOrder(1)
   dbSeek(xFilial("SZJ")+SUBSTR(SC6->C6_PRODUTO,1,4)+STR((SC6->C6_EDSUSP+1)+( SB1->B1_QTDEEX -1 ) ,4,0))
   DbSelectArea("TRB")
   RecLock("TRB",.f.)
   TRB->DATAEDFIM  := SZJ->ZJ_DTCIRC
   MsUnlock()

   dbSelectArea("ZZE")
   dbSkip()
End

MsgStop(ZZE->ZZE_PREFIX+ZZE->ZZE_NUM)

If lEnd
	MsgAlert("O processamento foi interrompido pelo usuario.","Interrompido")
	Return
EndIf

dbSelectArea("TRB")
Copy To &(MV_PAR05) VIA "DBFCDXADS" // 20121106 
dbCloseArea()

MsgAlert("Foi gerado o arquivo"+Alltrim(MV_PAR05)+".DBF", "Arquivo Gerado")

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
Static Function _ValidPerg()

_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs   := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

AADD(aRegs,{cPerg,"01","Prefixo de         ","mv_ch1","C",03,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"02","Prefixo Ate        ","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"03","Numero de          ","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"04","Numero Ate         ","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"05","Nome do Arquivo    ","mv_ch5","C",20,0,0,"G","","mv_par05","","","","","","","","","","","","","","",""})
AADD(aRegs,{cPerg,"06","Edicao             ","mv_ch6","N",04,0,0,"G","","mv_par06","","","","","","","","","","","","","","",""})

For i:=1 to Len(aRegs)
    If !dbSeek(cPerg+aRegs[i,2])
        RecLock("SX1",.T.)
        For j:=1 to FCount()
            If j <= Len(aRegs[i])
                FieldPut(j,aRegs[i,j])
            Endif
        Next
        MsUnlock()
    Endif
Next
DbSelectArea(_sAlias)

Return