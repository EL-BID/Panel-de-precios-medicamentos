-- Function: prm_stats_nao_ponderado(numeric[], numeric[])

-- DROP FUNCTION prm_stats_nao_ponderado(numeric[], numeric[]);

CREATE OR REPLACE FUNCTION prm_stats_nao_ponderado(
    p_qcom numeric[],
    p_vunitario numeric[])
  RETURNS SETOF prm_stats_type2 AS
$BODY$

	vQuartis <- quantile(p_vunitario)
	vQ25 <- vQuartis[2]
	vQ50 <- vQuartis[3]
	vQ75 <- vQuartis[4]
	vMedia <- mean(p_vunitario)
	vDesvio <- sd(p_vunitario)
	vPrm <- (vQuartis[2] + 2 * vQuartis[3] + vQuartis[4]) / 4
	vCoefvar <- vDesvio / vMedia	
	vValTot <- sum(rep(p_vunitario, times = p_qcom))
	vQtot <- sum(p_qcom)
	vQtotprm <- 0

	if (length(p_vunitario) > 0 && length(p_qcom) > 0)
	{
	   for(j in 1:length(p_vunitario)){
		if (p_vunitario[j] <= vPrm){
			vQtotprm <- vQtotprm + p_qcom[j]
		}
	   }
	}

	vCoefrep <- vQtotprm / vQtot

	df <- data.frame(q25=vQ25, q50=vQ50, q75=vQ75, media=vMedia, desvio=vDesvio, prm=vPrm, coefvar=vCoefvar, coefrep=vCoefrep, vtot=vValTot, qtot=vQtot, qtotprm=vQtotprm)


	rm(repeticao)
	rm(vQuartis)
	rm(vQ25)
	rm(vQ50)
	rm(vQ75)
	rm(vMedia)
	rm(vDesvio)
	rm(vPrm)
	rm(vCoefvar)
	rm(vCoefrep)
	rm(vValTot)
	rm(vQtot)
	rm(vQtotprm)

	return (df)
$BODY$
  LANGUAGE plr VOLATILE;
ALTER FUNCTION prm_stats_nao_ponderado(numeric[], numeric[])
  OWNER TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION prm_stats_nao_ponderado(numeric[], numeric[]) TO qualidadegasto_dataread;
REVOKE ALL ON FUNCTION prm_stats_nao_ponderado(numeric[], numeric[]) FROM public;
REVOKE ALL ON FUNCTION prm_stats_nao_ponderado(numeric[], numeric[]) FROM qualidadegasto_admin;
