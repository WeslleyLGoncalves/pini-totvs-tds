#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT128   �Autor: Raquel Ramalho         � Data:   16/03/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Atualiza a tabela de comiss�es para produts novos          � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function Pfat128()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

Private MHORA,  CARQPATH, CARQCOPY, CPERG,   CSTRING,  LEND
Private BBLOCO, CINDEX,   CCHAVE,   CFILTRO, CARQTRAB, CARQ
Private _SALIAS,AREGS, I, J
//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//�������������������������������������������������������������������������Ĵ
//� mv_par01 Codigo do Poduto Base.:                                        �
//� mv_par02 Codigo do Produto Novo:                                        �
//� mv_par03 Titulo do Produto Novo:                                        �
//���������������������������������������������������������������������������

mHora    := TIME()
cArqPath := GETMV("MV_PATHTMP")
cArqCopy := SUBS(CUSUARIO,7,3) + SUBS(MHORA,1,2)
cPerg    := "PFT128"
cString  := cArqPath + cArqCopy + ".DTC"

//��������������������������������������������������������������Ŀ
//� Caso nao exista, cria grupo de perguntas.                    �
//����������������������������������������������������������������
//_ValidPerg()

If !Pergunte(cPerg)
	Return
Endif

IF Lastkey()==27
	Return
Endif

lEnd   := .F.
bBloco := {|lEnd| ATUALIZA(@lEnd)}
Processa( bBloco, "Aguarde" ,"Atualizando tabela de comiss�es...", .T. )

DbSelectArea(cArq)
DbCloseArea()

DbSelectArea("SZ3")
Append From &cString
MsUnlock()

DbSelectArea("SZ3")
Retindex("SZ3")

Return

Static Function ATUALIZA()

DbSelectArea("SZ3")
DbGoTop()
cIndex  := CriaTrab(Nil,.F.)
cChave  := IndexKey()
cFiltro := "Z3_CODPROD == '" + MV_PAR01 + "'"
MsAguarde({|| IndRegua("SZ3",cIndex,cChave,,cFiltro,"Filtrando Pedidos...")},"Aguarde","Filtrando Pedidos...")

Copy to &cString 

DbSelectArea("SZ3")
RetIndex("SZ3")

cArqTrab := cString
cArq     := cArqcopy
dbUseArea( .T.,,cArqTrab,cArq, if(.F. .OR. .F., !.F., NIL), .F. )

dbSelectArea(cArq)
DbGoTop()

ProcRegua(RecCount())

While !Eof()
	IncProc("Ajustando "+StrZero(Recno(),7))
	RecLock(cArq,.F.)
	REPLACE Z3_CODPROD With MV_PAR02
	REPLACE Z3_TITULO  With MV_PAR03
	MsUnlock()
	Dbskip()
End

DbSelectArea("SZ3")
DbGoTop()

cIndex  := CriaTrab(Nil,.F.)
cChave  := IndexKey()
cFiltro := "Z3_CODPROD == '" + MV_PAR02 + "'"
MsAguarde({|| IndRegua("SZ3",cIndex,cChave,,cFiltro,"Filtrando Pedidos...")},"Aguarde","Filtrando Pedidos...")

DbGoTop()

ProcRegua(RecCount())

While !Eof()
	IncProc("Ajustando "+StrZero(Recno(),7))
	RecLock("SZ3",.F.)
	DBDelete()
	MsUnlock()
	Dbskip()
End

Return

Static Function _ValidPerg()

_sAlias := Alias()
DbSelectArea("SX1")
DbSetOrder(1)
cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
aRegs   := {}

// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3
AADD(aRegs,{cPerg,"01","Poduto Base........:","mv_ch1","C",15,0,0,"G","","mv_par01","","0108001","","","","","","","","","","","","","SZ3"})
AADD(aRegs,{cPerg,"02","Produto Novo.......:","mv_ch2","C",15,0,0,"G","","mv_par02","","0108003","","","","","","","","","","","","","SZ3"})
AADD(aRegs,{cPerg,"03","Titulo Novo Produto:","mv_ch3","C",40,0,0,"G","","mv_par03","","MADRIAS","","","","","","","","","","","","",""})

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