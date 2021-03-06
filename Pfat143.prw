#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

User Function Pfat143()        // incluido pelo assistente de conversao do AP5 IDE em 26/02/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("ARETURN,CPROGRAMA,CDESC1,CDESC2,CDESC3,CTITULO")
SetPrvt("CSTRING,NLASTKEY,WNREL,L,NORDEM,TAMANHO")
SetPrvt("NCARACTER,LCONTINUA,CPERG,MDTSIS,MNOMEARQ,MARQ")
SetPrvt("MDIR,MCAMINHO,_ACAMPOS,_CNOME,CINDEX,CKEY")
SetPrvt("CCHAVE,LIN,COL,LI,MCONTA,NRECNO")
SetPrvt("_SALIAS,AREGS,I,J,mhora")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: PFAT143   �  Autor: CLAUDIO              � Data: 19/10/01   � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o:  ETIQUETAS P/ ARQUIVO TXT / DBF                            � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : Liberado Para Imprimir Etiquetas dos Arquivos              � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Arquivo   C-8                        �
//� mv_par02             // Extens�o  C-1  SDF   TXT   DBF       �
//� mv_par03             // Diretorio C-30                       �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

ScreenDraw("SMT050", 3, 0, 0, 0)
SetCursor(1)
SetColor("B/BG")

aReturn   :={ "Especial", 1,"Administra눯o", 1, 2, 1,"",1 }
cPrograma :="PFAT143"
cDesc1    :=PADC("Este programa ira gerar o arquivo de etiquetas" ,74)
cDesc2    :=""
cDesc3    :=""
cTitulo   :=PADC("ETIQUETAS",74)
cString   :="PFAT143"
nLastKey  :=0
MHORA      := TIME()
wnrel     :="PFAT143_" + SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
L         :=0
nOrdem    :=0
tamanho   :="P"
nCaracter :=10
lContinua :=.T.
cPerg     :="PFT143"

MDTSIS  :=DTOC(DATE())
MNOMEARQ:='ET'+SUBS(MDTSIS,1,2)+SUBS(MDTSIS,4,2)+'.TXT'
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Verifica as perguntas selecionadas                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

_validPerg()

If .Not. PERGUNTE(cPerg)
    Return
Endif

MARQ :=MV_PAR01
MDIR :=MV_PAR03
MCAMINHO:=ALLTRIM(MDIR)+ALLTRIM(MARQ)


_aCampos := {}
AADD(_aCampos,{"PEDIDO"   ,"C",6, 0})
AADD(_aCampos,{"ITEM"     ,"C",2, 0})
AADD(_aCampos,{"CODCLI"   ,"C",6, 0})
AADD(_aCampos,{"PORTE"    ,"C",2, 0})
AADD(_aCampos,{"CODDEST"  ,"C",6, 0})
AADD(_aCampos,{"NOME"     ,"C",40,0})
AADD(_aCampos,{"DEST"     ,"C",40,0})
AADD(_aCampos,{"V_END"      ,"C",40,0})
AADD(_aCampos,{"BAIRRO"   ,"C",20,0})
AADD(_aCampos,{"MUN"      ,"C",20,0})
AADD(_aCampos,{"CEP"      ,"C",8, 0})
AADD(_aCampos,{"ESTADO"   ,"C",2, 0})
AADD(_aCampos,{"BRANCO"   ,"C",3, 0})
AADD(_aCampos,{"TELEFONE" ,"C",15,0})
AADD(_aCampos,{"DESC"     ,"C",30,0})


_cNome := CriaTrab(_aCampos,.t.)
dbUseArea(.T.,, _cNome,"PFAT143",.F.,.F.)

IF MV_PAR02==1
   DBSELECTAREA("PFAT143")
   APPEND FROM &MCAMINHO SDF
   MSUNLOCK()
   DBGOTOP()
ENDIF

IF MV_PAR02==2
   DBSELECTAREA("PFAT143")
   APPEND FROM &MCAMINHO DELI
   PFAT143->(MSUNLOCK())
   DBGOTOP()
ENDIF

IF MV_PAR02==3
   DBSELECTAREA("PFAT143")
   APPEND FROM &MCAMINHO
     PFAT143->(MSUNLOCK())
   DBGOTOP()
ENDIF

wnrel:=SetPrint(cString,wnrel,cPerg,cTitulo,cDesc1,cDesc2,cDesc3,.F.)
SetDefault(aReturn,cString)
If nLastKey == 27
   DBCLOSEAREA()
   Return
Endif

DBSELECTAREA("PFAT143")
cIndex:=CriaTrab(Nil,.F.)
cKey  :="CEP"
Indregua("PFAT143",cIndex,ckey,,,"Selecionando Registros do Arq")
cChave := IndexKey()
DBGOTOP()
IMPRIME()

DBSELECTAREA("PFAT143")
DBCLOSEAREA()

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> FUNCTION IMPRIME
Static FUNCTION IMPRIME()
   SETPRC(0,0)
   LIN   :=0
   COL   :=1
   LI    :=0
   MCONTA:=0
   DBSELECTAREA('PFAT143')
   DELE ALL FOR EMPTY(PEDIDO)
   DELE ALL FOR EMPTY(NOME)
   SetRegua(RecCount())
   DBGOTOP()
   DO WHILE .NOT. EOF()
      nRecno:=Recno()
      @ LIN+LI,001 PSAY ALLTRIM(NOME)
      DBSKIP()
      @ LIN+LI,043 PSAY ALLTRIM(NOME)
      DBSKIP()
      @ LIN+LI,087 PSAY ALLTRIM(NOME)
      dbGoto(nRecno)
      LI:=LI+1

      @ LIN+LI,001 PSAY ALLTRIM(DEST)
      DBSKIP()
      @ LIN+LI,043 PSAY ALLTRIM(DEST)
      DBSKIP()
      @ LIN+LI,087 PSAY ALLTRIM(DEST)
      dbGoto(nRecno)
      LI:=LI+1

      @ LIN+LI,001 PSAY ALLTRIM(V_END)
      DBSKIP()
      @ LIN+LI,043 PSAY ALLTRIM(V_END)
      DBSKIP()
      @ LIN+LI,087 PSAY ALLTRIM(V_END)
      dbGoto(nRecno)
      LI:=LI+1

      @ LIN+LI,001 PSAY ALLTRIM(BAIRRO)+'       '+'('+PEDIDO+')'
      DBSKIP()
      @ LIN+LI,043 PSAY ALLTRIM(BAIRRO)+'       '+'('+PEDIDO+')'
      DBSKIP()
      @ LIN+LI,087 PSAY ALLTRIM(BAIRRO)+'       '+'('+PEDIDO+')'
      dbGoto(nRecno)
      LI:=LI+1

      @ LIN+LI,001 PSAY SUBS(CEP,1,5)+'-'+SUBS(CEP,6,3)+'   ' +ALLTRIM(MUN)+' ' +ALLTRIM(ESTADO)
      DBSKIP()
      @ LIN+LI,043 PSAY SUBS(CEP,1,5)+'-'+SUBS(CEP,6,3)+'   ' +ALLTRIM(MUN)+' ' +ALLTRIM(ESTADO)
      DBSKIP()
      @ LIN+LI,087 PSAY SUBS(CEP,1,5)+'-'+SUBS(CEP,6,3)+'   ' +ALLTRIM(MUN)+' ' +ALLTRIM(ESTADO)
      LI:=LI+1
      DBSKIP()

      LI:=2
      setprc(0,0)
      lin:=prow()
      IncRegua()
   ENDDO
   DBGOTOP()
   COUNT TO MCONTA
   @ LIN+LI  ,001 PSAY '****************************************'
   @ LIN+LI+1,001 PSAY 'TOTAL DE ETIQUETAS...:' + STR(MCONTA,7)
   @ LIN+LI+2,001 PSAY '****************************************'

   SET DEVI TO SCREEN
   IF aRETURN[5] == 1
     Set Printer to
     dbcommitAll()
     ourspool(WNREL)
   ENDIF
   MS_FLUSH()
RETURN

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    쿣ALIDPERG � Autor �  Luiz Carlos Vieira   � Data � 16/07/97 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Verifica as perguntas inclu죒do-as caso n꼘 existam        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Espec죉ico para clientes Microsiga                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 26/02/02 ==> Function _ValidPerg
Static Function _ValidPerg()

      _sAlias := Alias()
      DbSelectArea("SX1")
      DbSetOrder(1)
      cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
      aRegs:={}

      // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

      AADD(aRegs,{cPerg,"01","Arquivo.........:","mv_ch1","C",12,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
      AADD(aRegs,{cPerg,"02","Extens�o........:","mv_ch2","C",01,0,0,"C","","mv_par02","SDF","","","TXT","","","DBF","","","","","","","",""})
      AADD(aRegs,{cPerg,"03","Diret줿io.......:","mv_ch3","C",30,0,3,"G","","mv_par03","","","","","","","","","","","","","","",""})

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
