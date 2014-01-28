#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

User Function MT440LIB()        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("_NQTDLIB,_NQTDJALIB,")


/*/
����������������������������������������������������������������������������
����������������������������������������������������������������������������
�����������������������������������������������������������������������Ŀ ��
��Programa: MT440LIB  �Autor: Fabio William          � Data:   07/07/97 � ��
�����������������������������������������������������������������������Ĵ ��
��Descri�ao: Retorna a quantida a ser liberada.                         � ��
�����������������������������������������������������������������������Ĵ ��
��Uso      : M�dulo de Faturamento                                      � ��
������������������������������������������������������������������������� ��
����������������������������������������������������������������������������
����������������������������������������������������������������������������

Grupo de perguntas Ativo MTALIB
//���������������������������������������������������������������Ŀ
//� mv_par01 Ordem Processmento ?  Ped.+Item /Dt.Entrega+Ped.+Item�
//� mv_par02 Pedido de          ?                                 �
//� mv_par03 Pedido ate         ?                                 �
//� mv_par04 Cliente de         ?                                 �
//� mv_par05 Cliente ate        ?                                 �
//� mv_par06 Dta Entrega de     ?                                 �
//� mv_par07 Dta Entrega ate    ?                                 �
//� mv_par08 Lote de                                              �
//� mv_par09 Lote Ate                                             �
//� mv_par10 Data Lote de                                         �
//� mv_par11 Data Lote Ate                                        �
//� mv_par12 Pedido da Publicidade                                �
//� mv_par13 Data Liberacao                                       �
//� mv_par14 Vendedor De                                          �
//� mv_par15 Vendedor Ate                                         �
//� mv_par16 Da Cond. Pagto                                       �
//� mv_par17 Ate a Cond de Pagto                                  �
//�����������������������������������������������������������������

/*/
If SC5->C5_DIVVEN #'PUBL'
	Return
EndIf

//���������������������������������������������Ŀ
//�Calcula a quantidade maxima a ser liberada   �
//�����������������������������������������������
_nQtdLib  := ( SC6->C6_QTDVEN - ( SC6->C6_QTDEMP + SC6->C6_QTDENT ) )

//���������������������������������������������Ŀ
//�Verifica a quantidade a ser liberada         �
//�����������������������������������������������
dbSelectArea("SC5")
dbSeek(xFilial()+SC6->C6_NUM)

If SC5->C5_DIVVEN == "PUBL"
	
	//����������������������������������������������������������Ŀ
	//�Para Publicidade deve ser calculada a quantidade na hora  �
	//������������������������������������������������������������
	
	_nQtdLib := 0
	_nQtdJALib := 0
	
	//������������������������������������Ŀ
	//�Conta no SC9 a Quantidade Liberada  �
	//��������������������������������������
	DbSelectArea("SC9")
	DbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)
	Do While !eof() .and. SC9->C9_PEDIDO+SC9->C9_ITEM == SC6->C6_NUM+SC6->C6_ITEM
		IF Empty(SC9->C9_NFISCAL)
			_nQtdJALib := SC9->C9_QTDLIB + _nQtdJALib
			RecLock("SC9",.F.)
			DbDelete()
			Msunlock()
		Endif
		DbSelectarea("SC9")
		DbSkip()
	Enddo
	if _nQtdJALib > 0
		RecLock("SC6",.F.)
		SC6->C6_QTDEMP := SC6->C6_QTDEMP - _nQtdJALib
		IF SC6->C6_QTDEMP <= 0
			SC6->C6_QTDEMP := 0
		Endif
		msunlock()
	Endif
	
	
	IF SC5->C5_AVESP == "N" // Somente AV Com pagamento normal
		
		//���������������������������������������������Ŀ
		//�Verifica a quantidade a ser liberada         �
		//�����������������������������������������������
		DbSelectArea("SZS")
		DbSetOrder(01)
		DbSeek(xFilial()+SC6->C6_NUM+SC6->C6_ITEM)
		Do While !eof() .AND. SC6->C6_NUM+SC6->C6_ITEM == SZS->ZS_NUMAV+SZS->ZS_ITEM
			IF SC5->C5_TPTRANS#'02' .AND. SC5->C5_TPTRANS#'03'
				If VAL(SZS->ZS_NFISCAL) == 0 // Libera Somente Itens que temnha
					If Month(MV_PAR13) == Month(SZS->ZS_LIBPROG)
						IF Year(MV_PAR13) == Year(SZS->ZS_LIBPROG)
							IF SC5->C5_VEND1 >= MV_PAR14 .and. SC5->C5_VEND1 <= MV_PAR15
								IF "AA" $(SC6->C6_SITUAC)
									IF SZS->ZS_SITUAC == "AA"
										IF SC5->C5_CONDPAG>=MV_PAR16 .AND. SC5->C5_CONDPAG<=MV_PAR17
											IF !EMPTY(SZS->ZS_CODMAT)
												_nQtdLib := _nQtdLib + 1
												RecLock("SZS",.F.)
												SZS->ZS_LIBFAT:=dDataBase
												MsUnlock()
											Endif
										ENDIF
									Endif
								Endif
							Endif
						Endif
					endif
				Endif
			ENDIF
			DbSelectArea("SZS")
			DbSkip()
		Enddo
		
	Else // Programacao AV Especiais
		
		DbSelectArea("SZV")
		DbSetOrder(01)
		DbSeek(xFilial()+SC6->C6_NUM)
		Do While !eof() .AND. SC6->C6_NUM == SZV->ZV_NUMAV
			IF Month(SZV->ZV_ANOMES) == Month(MV_PAR13) .AND. ;
					YEAR(SZV->ZV_ANOMES) ==  YEAR(MV_PAR13) .AND. EMPTY(SZV->ZV_NFISCAL)
				_nQtdLib := _nQtdLib + 1
			Endif
			DbSelectArea("SZV")
			DbSkip()
		Enddo
	Endif
	
Endif


//
if _nqtdlib < 1
	_nqtdlib := 0
endif
// Substituido pelo assistente de conversao do AP5 IDE em 13/03/02 ==> __return(_nQtdLib)
Return(_nQtdLib)        // incluido pelo assistente de conversao do AP5 IDE em 13/03/02


