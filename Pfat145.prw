#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/03/02
#IFNDEF WINDOWS
    #DEFINE PSAY SAY
#ENDIF

/*/ Atualizado por Danilo C S Pala, em 20040311
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
������������������������������������������������������������������������Ŀ ��
���Programa: PFAT145   �Autor: Raquel Ramalho         � Data:   28/11/01 � ��
������������������������������������������������������������������������Ĵ ��
���Descri�ao: Gera Posicao de Fornecedores                               � ��
������������������������������������������������������������������������Ĵ ��
���Uso      : M�dulo de Faturamento                                      � ��
�������������������������������������������������������������������������� ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/



User Function Pfat145()        // incluido pelo assistente de conversao do AP5 IDE em 14/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("PROGRAMA,MHORA,CARQ,CSTRING,WNREL,NLASTKEY")
SetPrvt("L,NORDEM,M_PAG,NCARACTER,TAMANHO,CCABEC1")
SetPrvt("CCABEC2,LCONTINUA,CARQPATH,_CSTRING,_CSTRING2,CPERG")
SetPrvt("MCONTA1,MCONTA2,MCONTA3,LEND,BBLOCO,CMSG")
SetPrvt("CCHAVE,CFILTRO,CIND,MCONTA,MNUM,MFORNECE")
SetPrvt("MVENCTO,MEMISSAO,MNOMFOR,MPREFIXO,MPARCELA,MVALOR")
SetPrvt("MBAIXA,MHIST,MDESCONT,MMULTA,MJUROS,MCORREC")
SetPrvt("MVALLIQ,MVENCORI,MSALDO,MNATUREZA,_ACAMPOS,_CNOME")
SetPrvt("CINDEX,CKEY,_SALIAS,AREGS,I,J, mDescNatureza")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 14/03/02 ==>     #DEFINE PSAY SAY
#ENDIF

//�������������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                    �
//�������������������������������������������������������������������������Ĵ
//� mv_par01 Vencimento De......:                                           �
//� mv_par02 Vencimento At�.....:                                           �
//� mv_par03 Fornecedor De......:                                           �
//� mv_par04 Fornecedor At�.....:                                           �
//� mv_par05 Baixado   Em Aberto    Ambos                                   �
//���������������������������������������������������������������������������

#IFNDEF WINDOWS
    ScreenDraw("SMT050", 3, 0, 0, 0)
    SetCursor(1)
    SetColor("B/BG")
#ENDIF

Programa  :="PFAT145"
MHORA     :=TIME()
cArq      :=SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
cString   :=SUBS(CUSUARIO,7,3)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
wnrel     :=SUBS(CUSUARIO,7,6)+SUBS(MHORA,1,2)+SUBS(MHORA,7,2)
nLastKey  := 00
L         := 00
nOrdem    := 00
m_pag     := 01
nCaracter := 10
tamanho   := "M"
cCabec1   := ""
cCabec2   := ""
lContinua := .T.
cArqPath  :=GetMv("MV_PATHTMP")
_cString  :=cArqPath+cString+".DBF"
_cString2 :=cString+".DBF"


//��������������������������������������������������������������Ŀ
//� Caso nao exista, cria grupo de perguntas.                    �
//����������������������������������������������������������������

cPerg:="PFT145"

//_ValidPerg()

If !Pergunte(cPerg)
   Return
Endif

IF Lastkey()==27
   Return
Endif

mConta1   :=0
mConta2   :=0
mConta3   :=0

FArqTrab()

Filtra()

#IFNDEF WINDOWS
    DrawAdvWin(" AGUARDE - GERANDO POSICAO DE FORNECEDORES EM DBF" , 8, 0, 15, 75 )
    PRODUTOS()
#ELSE
    lEnd:= .F.
       bBloco:= { |lEnd| PRODUTOS()  }// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==>        bBloco:= { |lEnd| Execute(PRODUTOS)  }
    MsAguarde( bBloco, "Aguarde" ,"Processando...", .T. )
#ENDIF

Do While .T.
  #IFNDEF WINDOWS
      ScreenDraw("SMT050", 3, 0, 0, 0)
      SetCursor(1)
      SetColor("B/BG")

      If !Pergunte(cPerg)
         Exit
      Endif

      If LastKey()== 27
         Exit
      Endif

     DrawAdvWin(" AGUARDE  - GERANDO RESUMO DO FATURAMENTO -  " , 8, 0, 15, 75 )
     Filtra()
     PRODUTOS()
  #ELSE

      If !Pergunte(cPerg)
         Exit
      Endif

      If LastKey()== 27
         Exit
      Endif

      Filtra()

      lEnd  := .F.
      bBloco:= { |lEnd| PRODUTOS()  }// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==>       bBloco:= { |lEnd| Execute(PRODUTOS)  }
      MsAguarde( bBloco, "Aguarde" ,"Processando...", .T. )
  #ENDIF
End-While

cMsg:= "Arquivo Gerado com Sucesso em: "+_cString
#IFNDEF WINDOWS
   DrawAdvWin(" AGUARDE  - COPIANDO ARQUIVO   " , 8, 0, 15, 75 )
   DbSelectArea(cArq)
   dbGoTop()
   COPY TO &_cString VIA "DBFCDXADS" // 20121106 
   ALERT(cMsg)
#ELSE
   //MsAguarde("Aguarde" ,"Copinado Arquivo...", .T. )
   DbSelectArea(cArq)
   dbGoTop()
   COPY TO &_cString VIA "DBFCDXADS" // 20121106                  
   MSGINFO(cMsg)
#ENDIF

//��������������������������������������������������������������Ŀ
//� Retorna indices originais...                                 �
//����������������������������������������������������������������

DbSelectArea(cArq)
DbCloseArea()
DbSelectArea("SE2")
Retindex("SE2")
DbSelectArea("SA2")
Retindex("SA2")

Return

//���������������������������������������������������������������������������Ŀ
//� Function  � Filtra()                                                      �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Filtra arquivo SE2 para ser utilizado no programa.            �
//���������������������������������������������������������������������������Ĵ
//�����������������������������������������������������������������������������

// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function FILTRA
Static Function FILTRA()
         DbSelectArea("SE2")
         DbGoTop()
         cChave := IndexKey()
         cFiltro:= 'DTOS(E2_VENCTO)>="'+DTOS(MV_PAR01)+'" .AND. DTOS(E2_VENCTO)<="'+DTOS(MV_PAR02)+'"'
         cFiltro:= Alltrim(cFiltro)+'.AND.E2_FORNECE>="'+MV_PAR03+'".AND.E2_FORNECE<="'+MV_PAR04+'"'
         cInd   := CriaTrab(NIL,.f.)
         IndRegua("SE2",cInd,cChave,,cFiltro,"Filtrando Pedidos...")
         Dbgotop()
Return


//���������������������������������������������������������������������������Ŀ
//� Function  � PRODUTOS()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza leitura dos registros do SE2 ja filtrado e aplica     �
//�           � restante dos filtros de parametros. Prepara os dados para     �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������

// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function PRODUTOS
Static Function PRODUTOS()
         mConta :=0

         DbSelectArea("SE2")
         DbGoTop()
         Do While !EOF()
            mNum      :=SE2->E2_Num
            mFornece  :=SE2->E2_Fornece
            mVencto   :=SE2->E2_Vencto
            mEmissao  :=SE2->E2_Emissao
            mNomfor   :=SE2->E2_Nomfor
            mPrefixo  :=SE2->E2_Prefixo
            mParcela  :=SE2->E2_Parcela
            mValor    :=SE2->E2_Valor
            mBaixa    :=SE2->E2_Baixa
            mHist     :=SE2->E2_Hist
            mDescont  :=SE2->E2_Descont
            mMulta    :=SE2->E2_Multa
            mJuros    :=SE2->E2_Juros
            mCorrec   :=SE2->E2_Correc
            mValliq   :=SE2->E2_Valliq
            mVencori  :=SE2->E2_Vencori
            mSaldo    :=SE2->E2_Saldo
            mNatureza :=SE2->E2_NATUREZ

            If MV_PAR05==1 .and. Empty(DTOS(SE2->E2_BAIXA))
               DbSkip()
               Loop
            Endif

            If MV_PAR05==2 .and. !Empty(DTOS(SE2->E2_BAIXA))
               DbSkip()
               Loop
            Endif
            
            //20040311
            DbSelectArea("SED")
			DbSetOrder(1)
			If DbSeek(xFilial("SED")+mNatureza)
				mDescNatureza := SED->ED_DESCRIC
			Else
				mDescNatureza := ""
			EndIf
			//ateh aki

            #IFNDEF WINDOWS
                Grava()
            #ELSE
                GRAVA()// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==>                 Execute(GRAVA)
            #ENDIF

            #IFNDEF WINDOWS
                @ 10,05 SAY "LENDO REGISTROS......." +StrZero(RECNO(),7)
                @ 11,05 SAY "GRAVANDO.............." +STR(MCONTA1,7)
            #ELSE
                MsProcTxt("Lendo Registros : "+Str(Recno(),7)+"  Gravando...... "+StrZero(mConta1,7))
            #ENDIF

            DbSelectArea("SE2")
            If Eof()
               Exit
            Else
               DbSkip()
            Endif
         End-While
Return

//���������������������������������������������������������������������������Ŀ
//� Function  � GRAVA()                                                       �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Realiza gravacao dos registros ideais (conforme parametros)   �
//�           � para impressao de Relatorio.                                  �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������
// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function GRAVA
Static Function GRAVA()

         mConta1:= mConta1+1

         #IFNDEF WINDOWS
             @ 10,05 SAY "LENDO REGISTROS......." +StrZero(RECNO(),7)
             @ 11,05 SAY "GRAVANDO.............." +STR(MCONTA1,7)
         #ELSE
             MsProcTxt("Lendo Registros : "+Str(Recno(),7)+"  Gravando...... "+StrZero(mConta1,7))
         #ENDIF

         DbSelectArea(cArq)
         RecLock(cArq,.T.)
         Repla Num      With  mNum
         Repla Fornece  With  mFornece
         Repla Vencto   With  mVencto
         Repla Emissao  With  mEmissao
         Repla Nomfor   With  mNomfor
         Repla Prefixo  With  mPrefixo
         Repla Parcela  With  mParcela
         Repla Valor    With  mValor
         Repla Baixa    With  mBaixa
         Repla Hist     With mHist
         Repla Descont  With  mDescont
         Repla Multa    With  mMulta
         Repla Juros    With  mJuros
         Repla Correc   with  mCorrec
         Repla Valliq   With  mValliq
         Repla Vencori  With  mVencori
         Repla Saldo    With  mSaldo
         Repla Natureza with  mNatureza
         Repla Desc_Natur with mDescNatureza // 20040311

         MsUnlock()
Return

//���������������������������������������������������������������������������Ŀ
//� Function  � FARQTRAB()                                                    �
//���������������������������������������������������������������������������Ĵ
//� Descricao � Cria arquivo de trabalho para guardar registros que serao     �
//�           � impressos em forma de etiquetas.                              �
//�           � serem gravados. Faz chamada a funcao GRAVA.                   �
//���������������������������������������������������������������������������Ĵ
//� Observ.   �                                                               �
//�����������������������������������������������������������������������������
// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function FARQTRAB
Static Function FARQTRAB()

         _aCampos := {}
         AADD(_aCampos,{"Num","C",9,0})
         AADD(_aCampos,{"Fornece","C",6,0})
         AADD(_aCampos,{"Vencto ","D",8,0})
         AADD(_aCampos,{"Natureza","C",10,0})
         AADD(_aCampos,{"Desc_Natur","C",30,0})  // 20040311
         AADD(_aCampos,{"Emissao","D",8,0})
         AADD(_aCampos,{"Nomfor ","C",20,0})
         AADD(_aCampos,{"Prefixo","C",3,0})
         AADD(_aCampos,{"Parcela","C",1,0})
         AADD(_aCampos,{"Valor","N",17,2})
         AADD(_aCampos,{"Baixa","D",8,0})
         AADD(_aCampos,{"Hist","C",25,0})
         AADD(_aCampos,{"Descont","N",17,2})
         AADD(_aCampos,{"Multa","N",17,2})
         AADD(_aCampos,{"Juros","N",17,2})
         AADD(_aCampos,{"Correc","N",17,2})
         AADD(_aCampos,{"Valliq","N",17,2})
         AADD(_aCampos,{"Vencori","D",8,0})
         AADD(_aCampos,{"Saldo","N",17,2})

         _cNome := CriaTrab(_aCampos,.t.)
         cIndex := CriaTrab(Nil,.F.)
         cKey   := "Prefixo+Num+Parcela"
         dbUseArea(.T.,, _cNome,cArq,.F.,.F.)
         dbSelectArea(cArq)
         Indregua(cArq,cIndex,ckey,,,"Selecionando Registros do Arq")
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

// Substituido pelo assistente de conversao do AP5 IDE em 14/03/02 ==> Function _ValidPerg
Static Function _ValidPerg()

         _sAlias := Alias()
         DbSelectArea("SX1")
         DbSetOrder(1)
         cPerg    := PADR(cPerg,10) //mp10 x1_grupo char(10)
         aRegs:={}

         // Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05/F3

         AADD(aRegs,{cPerg,"01","Vencimento De......:","mv_ch1","D",08,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"02","Vencimento At�.....:","mv_ch2","D",08,0,0,"G","","mv_par02","","","","","","","","","","","","","","",""})
         AADD(aRegs,{cPerg,"03","Fornecedor De......:","mv_ch3","C",06,0,0,"G","","mv_par03","","","","","","","","","","","","","","","SA2"})
         AADD(aRegs,{cPerg,"04","Fornecedor At�.....:","mv_ch4","C",06,0,0,"G","","mv_par04","","","","","","","","","","","","","","","SA2"})
         AADD(aRegs,{cPerg,"05","Situacao...........:","mv_ch5","C",01,0,4,"C","","mv_par05","Baixados","","","Em Aberto","","","Todos",""})

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
