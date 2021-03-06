#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function Ljtm001()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_SLINHA,_STITULO,_SNOMVEN,_SLINIMP,_SDESPRO,_SCONPGTO")
SetPrvt("_I,")

/*/
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un눯o    � LJTM001  � Autor � F쟟io F. Pessoa       � Data � 05/10/97 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri눯o � Rotina para impress꼘 de Cupom sem Validade Fiscal.        낢�
굇�          � Imprime na porta Paralela do terminal.                     낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � TALIC - via RDMake                                         낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

_sLinha   := Replicate("=", 48)              // Divis�o da linha
_sTitulo  := "Cupom sem valor fiscal"        // Titulo do Cupom
_sNomVen  := ""                              // Nome do Vendedor
_sLinImp  := ""                              // Linha a ser impressa
_sDesPro  := ""                              // Descri눯o do Produto
_sConPgto := ""                              // Condi눯o de Pagamento

dbSelectArea( "SA3" )
dbSetOrder( 1 )
If dbSeek(xFilial("SA3") + aCodVen[terminal+1])
  _sNomVen := Substr(aCodVen[terminal+1] + " - " + A3_NOME, 1, 38)
EndIf

dbSelectArea( "SL1" )
dbSetOrder( 1 )
If dbSeek(xFilial("SL1") + aNumOrc[terminal+1])

  dbSelectArea("SE4")
  dbSetOrder(1)
  If dbSeek( xFilial("SE4") + SL1->L1_CONDPG )
	 _sConPgto := Substr(SE4->E4_DESCRI, 1, 32)
  EndIf
  dbSelectArea( "SL1" )

  GPrint( Replicate(" ",(48 - Len(_sTitulo)) / 2 ) + _sTitulo + Chr(10) + Chr(13), terminal )
  GPrint( Replicate(" ",(48 - Len(cNomEmp)) / 2 ) + cNomEmp + Chr(10) + Chr(13), terminal )
  GPrint( _sLinha                            + Chr(10) + Chr(13), terminal )
  GPrint( "Pedido  : " + aNumOrc[terminal+1] + Chr(10) + Chr(13), terminal )
  GPrint( "Vendedor: " + _sNomVen            + Chr(10) + Chr(13), terminal )
  GPrint( ""                                 + Chr(10) + Chr(13), terminal )
  GPrint( "Qtd.    Descricao            Vl.Unit.   Vl.Total" + Chr(10) + Chr(13), terminal )
  //        123456789012345678901234567890123456789012345678
  //        1234.67 1234567890123456789 123456.89 1234567.90
  GPrint( _sLinha                              + Chr(10) + Chr(13), terminal )
  GPrint( ""                                   + Chr(10) + Chr(13), terminal )

  dbSelectArea("SL2")
  dbSetOrder( 1 )
  If dbSeek(xFilial("SL2") + aNumOrc[terminal+1])

	 While !Eof() .And. L2_NUM == aNumOrc[terminal+1]

		 _sDesPro := IIf( Len(AllTrim(L2_DESCRI)) < 19, AllTrim(L2_DESCRI) + Replicate(" ", 19 - Len(AllTrim(L2_DESCRI))), Substr(AllTrim(L2_DESCRI), 1, 19) )
		 _sLinImp := Str(L2_QUANT, 7, 2) + " " + _sDesPro + " " + Str(L2_VRUNIT, 9, 2) + " " + Str(L2_VLRITEM, 10, 2)
		 GPrint( _sLinImp + Chr(10) + Chr(13), terminal )
		 Skip

	 EndDo

  EndIf

  GPrint( Replicate("-",48)  + Chr(10) + Chr(13), terminal )
  GPrint( "Sub-total     : " + Str(SL1->L1_VLRTOT                  , 9, 2) + Chr(10) + Chr(13), terminal )
  GPrint( "Desconto      : " + IIf(SL1->L1_DESCONT > 0, Str(SL1->L1_VLRTOT - SL1->L1_DESCONT, 9, 2), " ") + Chr(10) + Chr(13), terminal )
  GPrint( _sLinha            + Chr(10) + Chr(13), terminal )
  GPrint( "TOTAL ----->> : " + Str(SL1->L1_VLRLIQ, 10, 2) + Chr(10) + Chr(13), terminal )
  GPrint( "Cond. de Pgto.: " + _sConPgto + Chr(10) + Chr(13), terminal )
  GPrint( Replicate("-",48)  + Chr(10) + Chr(13), terminal )
  GPrint("Sigaloja"          + Chr(10) + Chr(13), terminal )

  // Imprime 6 linhas em branco para dar a altura do corte do papel
  For _i := 1 To 3
	 GPrint( "" + Chr(10) + Chr(13), terminal )
  Next _i

  GPrint( Replicate("-",48)  + Chr(10) + Chr(13), terminal )

  For _i := 1 To 6
	 GPrint( "" + Chr(10) + Chr(13), terminal )
  Next _i

  GFlushPrn()

EndIf

Return(nil)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

