#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function tmkvhi()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CCLITMK,CLOJA,_SALVAHEADER,_SALVCOLS,_CALIAS,_NINDORDSC6")
SetPrvt("_NREGORDSC6,_NINDORDSE1,_NREGORDSE1,_NINDORDSZ5,_NREGORDSZ5,AHEADER")
SetPrvt("_NUSADO,_NCNT,ACOLS,_X,_CCAMPO,_CVAR1")
SetPrvt("_CVAR2,_CVAR3,_CVAR4,_CVAR5,_ACAMPOS,_CAUX")


 /*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿟MKMHI    � Autor � Fabio William         � Data � 15.04.97 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿍rowse p/ Consulta dos Itens do Pedido.                     낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣erifica se o Cliente foi Preenchido�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//cCliTmk := "026770"
//cLoja   := "00"

If Empty(cCliTmk)
   MsgAlert("O Codigo do Cliente nao foi preenchido...")
   return nil
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿞alva o Aheader                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
_SalvAheader := Aheader
_SalvCols    := ACols


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿞alva o Alias                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

_cAlias := Alias()
DbSelectarea("SC6")
_nIndOrdSC6 := IndexOrd()
_nRegOrdSC6 := Recno()
DbSetOrder(09)  // Cliente
DBSelectArea("SE1")
_nIndOrdSE1 := IndexOrd()
_nRegOrdSE1 := Recno()
DbOrderNickName("C6_CLI") //dbSetOrder(10) 20130225 // Cliente + Loja
DBSelectArea("SZ5")
_nIndOrdSZ5 := IndexOrd()
_nRegOrdSZ5 := Recno()
DbsetOrder(1) // Cliente + Loja


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿛osiciona arquivo de Cobranca    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
DbSelectarea("SZ5")
DbSeek(xFilial()+cCLITMK+CLOJA)



//   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//   � Chama a tela de Processamento                          �
//   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Processa( {|| RunProc() } )// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Processa( {|| Execute(RunProc) } )

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿝unProc   � Autor � Fabio William         � Data � 22/04/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿐xecuta o Processamento de montagem dos menus               낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Function RunProc
Static Function RunProc()


_cAlias := "SC6"
dbSelectArea( _cAlias )
dbGoTop()
aHeader := {}
Select Sx3
DbSetOrder(02)
DbSeek("C6_NUM")
AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
    X3_TAMANHO, X3_DECIMAL, " ",;
    X3_USADO, X3_TIPO, X3_ARQUIVO } )
DbSetOrder(01)
Seek _cAlias
_nUsado := 1
While !EOF() .And. X3_ARQUIVO == _cAlias
        If x3_usado != " " .And. cNivel >= X3_NIVEL .and. !RTRIM(X3_CAMPO) $ "C6_FILIAL/C6_COMIS1/C6_TIPOREV"
           _nUsado := _nUsado + 1
             AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
                 X3_TAMANHO, X3_DECIMAL, " ",;
                 X3_USADO, X3_TIPO, X3_ARQUIVO } )
	EndIf
        Skip
EndDo


//   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//   � Conta quantos registros seram mostrados                �
//   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea( _cAlias )
DbSeek(xFilial()+cCliTMK)
_nCnt := 0
While !EOF() .AND. SC6->C6_CLI == cCLITMK //.AND. SC6->C6_LOJA == CLOJA
     _nCnt := _nCnt + 1
    DbSkip()
EndDo

//   旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//   � Atualiza os campos a serem mostrados                   �
//   읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
IF _nCnt == 0
   _nCnt := 1
Endif
aCOLS := Array(_nCnt,_nUsado+1)
dbSelectArea( _cAlias )
DbSeek(xFilial()+cCliTMK)
_nCnt := 0
While !EOF() .AND. SC6->C6_CLI == cCLITMK .AND. SC6->C6_LOJA == CLOJA
      _nCnt := _nCnt+1
//      _nUsado:=1
//      Select SX3
//      aCOLS[_nCnt][_nUsado] := SC6->C6_NUM
//      Seek _cAlias
      For _x := 1 to len (aHeader)
           _cCampo := aHeader[_x][2]
            aCOLS[_nCnt][_x] := &(_cAlias+"->"+_cCampo)
      Next _x
      aCOLS[_nCnt][_x] := .f. //Flag de Delecao
      dbSelectArea( _cAlias )
      Skip
EndDo
If _nCnt == 0
   DbGoBottom()
   dbskip()
      For _x := 1 to len (aHeader)
           _cCampo := aHeader[_x][2]
            aCOLS[1][_x] := &(_cAlias+"->"+_cCampo)
      Next _x
      aCOLS[1][_x] := .f. //Flag de Delecao
Endif
dbSelectArea( _cAlias )
@ 200,1 TO 500,640 DIALOG _odlg3 TITLE "Consulta dos Pedidos"
@ 08,5 SAY "Dados do Pedidos Venda"
@ 20,5 TO 93,300 MULTILINE  FREEZE 2
@ 130,100 BUTTON "_Ok" SIZE 40,15 ACTION Fecha()// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> @ 130,100 BUTTON "_Ok" SIZE 40,15 ACTION Execute(Fecha)
@ 130,150 BUTTON "_Titulos" SIZE 40,15 ACTION TitAberto()// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> @ 130,150 BUTTON "_Titulos" SIZE 40,15 ACTION Execute(TitAberto)


// implementa os dados de cobranca
_cVar1 := sz5->z5_end
_cVar2 := sz5->z5_bairro
_cvar3 := sz5->z5_cidade
_cvar4 := sz5->z5_estado
_cvar5 := sz5->z5_cep
@ 100,5 SAY "Cliente : "
@ 100,35 GET _cVar1
@ 110,5 SAY "Endereco : "
@ 110,35 GET _cVAR2
@ 120,5 SAY "Cidade  : "
@ 120,35 GET _cVAR3
@ 130,5 SAY "Estado : "
@ 130,35 GET _cVAR4
ACTIVATE DIALOG _odlg3 CENTERED
Fecha()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣olta o Aheader                  �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Aheader := _SalvAheader
ACols   := _SalvCols
Return

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑echa     � Autor � Fabio William         � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿑echa a Janela e Volta o Alias Correto                      낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Function Fecha
Static Function Fecha()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣olta o Alias                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
DbSelectArea("SC6")
DbSetOrder(_nIndOrdSC6)
DbGoTo(_nRegOrdSC6)
DBSelectArea("SE1")
DbSetOrder(_nIndOrdSE1)
DbGoTo(_nRegOrdSE1)
DbSelectArea(_cAlias)
DBSelectArea("SZ5")
DbSetOrder(_nIndOrdSZ5)
DbGoTo(_nRegOrdSZ5)
Close(_odlg3)
Return


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿗ineOk    � Autor � Ary Medeiros          � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿣alidacao da linha digitada na funcao MultiLine             낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Function LineOk
Static Function LineOk()
Return .t.



/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿟iteAberto� Autor � Fabio William         � Data � 29/04/98 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿘ostra os titulos em aberto                                 낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Function TitAberto
Static Function TitAberto()

_cAlias := "SE1"
dbSelectArea( _cAlias )
_aCAMPOS := {'E1_NUM','E1_PARCELA','E1_VALOR','E1_EMISSAO','E1_VENCTO','E1_BAIXA','E1_PORTADO','E1_PEDIDO'}
aHeader := {}
Select Sx3
DbSetOrder(02)
_nUsado := 0
For _x := 1 to len(_aCampos)
    DbSeek(_aCampos[_x])
    _nUsado := _nUsado + 1
    AADD(aHeader,{ TRIM(X3_TITULO), X3_CAMPO, X3_PICTURE,;
                 X3_TAMANHO, X3_DECIMAL, " ",;
                 X3_USADO, X3_TIPO, X3_ARQUIVO } )
Next _x
DbSetOrder(01)

dbSelectArea( _cAlias )
dbSeek(xFilial()+cCliTmk+CLOJA)
_nCnt := 0
While !EOF() .And. SE1->E1_CLIENTE == cCLITMK .AND. SE1->E1_LOJA == CLOJA
//    IF SE1->E1_BAIXA == stod("")
       _nCnt := _nCnt+1
//    Endif
    DbSkip()
EndDo
if _nCnt == 0
   _nCnt := 1
Endif
aCOLS := Array(_nCnt+1,_nUsado+1)
_nCnt := 1

// inicializa  a primeira linha p/ evitar erros de interpretacao
For _x := 1 to len(_aCampos)
    IF _aCampos[_x] == "E1_NUM"
      _cAux := "ABAIXO"
    ELSE
    _cAux := CriaVar(_aCampos[_x])
    ENDIF
    aCOLS[_nCnt][_x] := _cAux
Next _x
aCOLS[_nCnt][len(_aCampos)+1] := .f. //Flag de Delecao

dbSelectArea( _cAlias )
DbSeek(xFilial()+cCLITMK+cLOJA)

While !EOF() .And. SE1->E1_CLIENTE == cCLITMK .AND. SE1->E1_LOJA == CLOJA

//    IF SE1->E1_BAIXA == CTOD(" /  /  ")
       _nCnt := _nCnt+1
        For _x := 1 to len(_aCampos)
            _cAux := &(_cAlias+"->"+_aCampos[_x])
            aCOLS[_nCnt][_x] := _cAux
        Next _x
        aCOLS[_nCnt][len(_aCampos)+1] := .f. //Flag de Delecao
//    endif
    dbSelectArea( _cAlias )
    Skip
EndDo
If _nCnt == 1
   msgalert("Nao ha titulos ")
   return
Endif


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿯echa a janela anterior          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Close(_odlg3)

dbSelectArea( _cAlias )
@ 200,1 TO 500,640 DIALOG _odlg4 TITLE "Titulos "
@ 20,5 TO 93,300 MULTILINE FREEZE 1
@ 120,100 BUTTON "_Ok" SIZE 40,15 ACTION Fecha2()// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> @ 120,100 BUTTON "_Ok" SIZE 40,15 ACTION Execute(Fecha2)
ACTIVATE DIALOG _odlg4 CENTERED
Return


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇙o    쿑echa2    � Autor � Fabio William         � Data � 15.02.96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇙o 쿑echa a Janela e Volta o Alias Correto                      낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/  
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> Function Fecha2
Static Function Fecha2()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣olta o Alias                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
DbSelectArea("SC6")
DbSetOrder(_nIndOrdSC6)
DbGoTo(_nRegOrdSC6)
DBSelectArea("SE1")
DbSetOrder(_nIndOrdSE1)
DbGoTo(_nRegOrdSE1)
DbSelectArea(_cAlias)
Close(_odlg4)
Return
