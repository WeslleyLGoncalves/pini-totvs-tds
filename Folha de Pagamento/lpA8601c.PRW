#INCLUDE "RWMAKE.CH"
User Function LPA8601C()
Local mctaCRED := ''
IF SUBS(SRZ->RZ_CC,1,3) $ "41 /410/411/21 /211/2  " //ADM
	MCTAcred := "42010204006"
ELSEIF SUBS(SRZ->RZ_CC,1,2) $"22" // PRODUCAO
	MCTAcred := "41010104003"
ELSEIF SUBS(SRZ->RZ_CC,1,2) $"23" // VENDAS
	MCTAcred := "42010105006"
ELSEIF SUBS(SRZ->rZ_CC,1,3) $"412" // PROD.SOFTWARE
	MCTAcred := "41010503003"
ELSEIF SUBS(SRZ->rZ_CC,1,3) $"414" // PESQUISA
	MCTAcred := "41020903003"	
ELSEIF SUBS(SRZ->RZ_CC,1,3) $"413" // PROD.WEB
	MCTAcred := "41010603003"
ELSEIF SUBS(SRZ->RZ_CC,1,3) $"415" // JORNALISMO
	MCTAcred := "41010503003"
ELSEIF SUBS(SRZ->RZ_CC,1,3) $"416" // COMERCIAL
	MCTAcred := "42010105006"    
ELSEIF SUBS(SRZ->RZ_CC,1,2) $"31" // ENGENHARIA
	MCTAcred := "41020103006"
ELSEIF SUBS(SRZ->RZ_CC,1,2) $"32" // CURSOS
	MCTAcred := "41020303006"
else
	MCTAcred := "CC INVALIDO"
ENDIF
RETURN(MCTAcred)