#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/03/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

User Function Pfat148()        // incluido pelo assistente de conversao do AP5 IDE em 14/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CARQPATH,MCONTA,MCONTA1,MCONTA2,CARQ,CPERG")
SetPrvt("LEND,BBLOCO,_CSTRING,CINDEX,CKEY,CFILTRO")
SetPrvt("CIND,MTESTE,MOBS1,MAT,MSTATUS2,_SALIAS")
SetPrvt("AREGS,I,J,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 14/03/02 ==>     #DEFINE PSAY SAY
#ENDIF
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컴컴컴컴컴컴커 굇
굇쿛rograma: PFAT148   쿌utor: Raquel Ramalho         � Data:   06/09/01 � 굇
굇쳐컴컴컴컴컴컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴좔컴컴컴컴컴컴컴컴캑 굇
굇쿏escri놹o: Adiciona registro no cadastro de ocorrencias               � 굇
굇쳐컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴캑 굇
굇쿢so      : M줰ulo de Faturamento                                      � 굇
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸 굇
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
/*/

//旼컴컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� MV_PAR01 � Arquivo de trabalho  ?                         �
//� MV_PAR02 � Cod. Promo눯o        ?                         �
//읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

#IFNDEF WINDOWS
    ScreenDraw("SMT050", 3, 0, 0, 0)
    SetCursor(1)
    SetColor("B/BG")
#ENDIF

cArqPath  :=GetMv("MV_PATHTMP")
mConta    :=0
mConta1   :=0
mConta2   :=0
cArq      :=MV_PAR01

cPerg:="PFT148"
_ValidPerg()

If !Pergunte(cPerg)
   Return
Endif

IF Lastkey()==27
   Return
Endif


#IFNDEF WINDOWS
    DrawAdvWin(" AGUARDE - ATUALIZANDO ARQUIVO DAS OCORRENCIAS" , 8, 0, 15, 75 )
    OCORR()               // para funcionar a partir do SC6.
#ELSE
    lEnd:= .F.
       bBloco:= { |lEnd| OCORR()  }// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==>        bBloco:= { |lEnd| Execute(OCORR)  }
    MsAguarde( bBloco, "Aguarde" ,"Processando...", .T. )
#ENDIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Retorna indices originais...                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

DbSelectArea('Arq')
DbCloseArea()
DbSelectArea("SZ1")
Retindex("SZ1")
Return

//旼컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Function  � Ocorr                                                         �
//쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Descricao � Atualiza Arquivo                                              �
//쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Observ.   �                                                               �
//읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function Ocorr
Static Function Ocorr()
   _cString  :=cArqPath+AllTrim(MV_PAR01)+'.DBF'
   dbUseArea( .T.,, _cString,'ARQ', if(.F. .OR. .F., !.F., NIL), .F. )
   dbSelectArea('ARQ')
   cIndex:=CriaTrab(Nil,.F.)
   cKey:="Z1_CODCLI+Z1_PEDIDO"
   Indregua("ARQ",cIndex,ckey,,,"Indexando......")

   dbSelectArea('SZ1')
   cFiltro:='Z1_CODPROM=="'+MV_PAR02+'".and. Z1_STATUSI<>"600"'
   cKey   := IndexKey()
   cInd   := CriaTrab(NIL,.f.)
   IndRegua("SZ1",cInd,cKey,,cFiltro,"Filtrando Pedidos...")
   dbGotop()
   Do While !Eof()
      #IFNDEF WINDOWS
         @ 10,05 SAY "Finalizando Ocorrencias...." +StrZero(RECNO(),7)
         @ 11,05 SAY "Ocorrencias finalizadas...." +StrZero(mConta2,7)
      #ELSE
         MsProcTxt("Finalizando Ocorrencias...."+Str(Recno(),7)+" Ocorrencias Finalizadas...."+Str(mConta2,7))
      #ENDIF
      dbSelectArea('ARQ')
      DbSeek(SZ1->Z1_CODCLI+SZ1->Z1_PEDIDO)
      If !Found()
         mConta2:=mConta2+1
         dbSelectArea('SZ1')
         Reclock("SZ1",.F.)
         Repla Z1_STATUS2 With '600'
         Repla Z1_STATUSI With '600'
         Msunlock()
      Endif
      dbSelectArea('SZ1')
      dbSkip()
   Enddo
   mteste:=0
   Do While .t.
      mteste:=mteste+1
      if mteste==1000
         exit
      else
         loop
      endif
   Enddo
   dbSelectArea('ARQ')
   dbGotop()
   Do While .Not. Eof()
      mObs1:=DESCR+'/'+STR(EDVENC,4)+'/'+DTOC(ULTCOM)
      mAT:='N'
      Dbselectarea('SZ1')
      DbSeek(xFilial()+Arq->Z1_CODCLI)
      If Found()
         Do While SZ1->Z1_CODCLI==ARQ->Z1_CODCLI
            If SZ1->Z1_PEDIDO==ARQ->Z1_PEDIDO;
               .and. SZ1->Z1_STATUSI>='500';

               mStatus2:=SZ1->Z1_STATUS2

               mConta1:=mConta1+1
               Reclock("SZ1",.F.)
               Repla Z1_Nome     With  ARQ->Z1_Nome
               Repla Z1_NDest    With  ARQ->Z1_NDest
               Repla Z1_End      With  ARQ->Z1_End
               Repla Z1_Bairro   With  ARQ->Z1_Bairro
               Repla Z1_MUN      With  ARQ->Z1_MUN
               Repla Z1_UF       With  ARQ->Z1_UF
               Repla Z1_CEP      With  ARQ->Z1_CEP
               Repla Z1_Fone     With  ARQ->Z1_Fone
               Repla Z1_Fax      With  ARQ->Z1_Fax
               Repla Z1_EMAIL    With  ARQ->Z1_EMAIL
               Repla Z1_obs1     with  mObs1
               Repla Z1_Status2  With  mStatus2
               Repla Z1_codprom  With  MV_PAR02
               Msunlock()
               mat:='S'
               Exit
            Endif
            DbSkip()
         Enddo
      Endif

      If mAT=='N'
         mConta:=mConta+1
         Reclock("SZ1",.t.)
         Repla Z1_Pedido   With  ARQ-> Z1_Pedido
         Repla Z1_CodCli   With  ARQ-> Z1_CodCli
         Repla Z1_CEP      With  ARQ-> Z1_CEP
         Repla Z1_Nome     With  ARQ-> Z1_Nome
         Repla Z1_NDest    With  ARQ-> Z1_NDest
         Repla Z1_End      With  ARQ-> Z1_End
         Repla Z1_Bairro   With  ARQ-> Z1_Bairro
         Repla Z1_MUN      With  ARQ-> Z1_MUN
         Repla Z1_UF       With  ARQ-> Z1_UF
         Repla Z1_Fone     With  ARQ-> Z1_Fone
         Repla Z1_Fax      With  ARQ-> Z1_Fax
         Repla Z1_EMAIL    With  ARQ-> Z1_EMAIL
         Repla Z1_CodProm  With  MV_PAR02
         Repla Z1_StatusI  With  '501'
         Repla Z1_DTOCORR  With  date()
         Repla Z1_obs1     with  mObs1
         Msunlock()
      Endif

      #IFNDEF WINDOWS
         @ 10,05 SAY "LENDO REGISTROS..................." +StrZero(RECNO(),7)
         @ 11,05 SAY "GRAVANDO.........................." +STR(MCONTA,7)
         @ 12,05 SAY "REGRAVANDO........................" +STR(MCONTA1,7)
      #ELSE
         MsProcTxt("Lendo Registros : "+Str(Recno(),7)+"  Regravando.... "+StrZero(mConta1,7)+"  Gravando...... "+StrZero(mConta,7))
      #ENDIF
      DbSelectArea('Arq')
      DbSkip()
   Enddo
   mteste:=0
   Do While .t.
      mteste:=mteste+1
      if mteste==1000
         exit
      else
         loop
      endif
   Enddo
Return
//旼컴컴컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Function  � _ValidPerg                                                    �
//쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Descricao � Valida grupo de perguntas                                     �
//쳐컴컴컴컴컴탠컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Observ.   �                                                               �
//읕컴컴컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function _ValidPerg
Static Function _ValidPerg()

         _sAlias := Alias()
         DbSelectArea("SX1")
         DbSetOrder(1)
         cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
         aRegs:={}

         // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

         AADD(aRegs,{cPerg,"01","Arq. de Trabalho:","mv_ch1","C",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"02","Cod. A눯o ......:","mv_ch2","C",03,0,0,"G","","mv_par02","","","","","","","","","","","","","","","SZA"})
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

