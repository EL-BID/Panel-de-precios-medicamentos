-- Function: calcula_fracionamento_nfemedicamentos(integer)

-- DROP FUNCTION calcula_fracionamento_nfemedicamentos(integer);

CREATE OR REPLACE FUNCTION calcula_fracionamento_nfemedicamentos(p_periodo integer)
  RETURNS text AS
$BODY$
DECLARE
   vPeriodoIni INT;
   vPeriodoFim INT;
   vPeriodoTemp INT;
   vSQL TEXT;
BEGIN	

   SELECT TO_CHAR(TO_DATE(CAST(p_periodo AS VARCHAR(6)), 'yyyymm') - INTERVAL '10 month', 'yyyymm') INTO vPeriodoIni;
   SELECT CAST(p_periodo AS VARCHAR(6)) INTO vPeriodoFim;
   --SELECT MIN(periodo) INTO vPeriodoTemp FROM produto_ext;

 
   -- Calculo Max Media
   BEGIN
	vSQL = ' CREATE GLOBAL TEMPORARY TABLE temp_maiorvalorvendaproduto (
			cean bigint NOT NULL,
			maxmedia numeric,
			periodoinicial integer,
			periodofinal integer
		 ) ON COMMIT DELETE ROWS DISTRIBUTED BY (cean) ';
	EXECUTE vSQL;
   EXCEPTION
	WHEN others THEN
	   EXECUTE 'TRUNCATE TABLE temp_maiorvalorvendaproduto';
   END;		


   BEGIN
	vSQL = ' CREATE GLOBAL TEMPORARY TABLE temp_produto_edicaobrasindice (
			nfuid varchar(32),
			nitem smallint,
			qcom numeric(17,4),
			vunitario numeric(17,4),
			cean bigint,
			edicaobrasindice integer,
			demi date
		 ) ON COMMIT DELETE ROWS DISTRIBUTED BY (nfuid) ';
	EXECUTE vSQL;
   EXCEPTION
	WHEN others THEN
	   EXECUTE 'TRUNCATE TABLE temp_produto_edicaobrasindice';
   END;	

   



   
   INSERT INTO temp_maiorvalorvendaproduto
   SELECT cean_int, MAX(media) media, vPeriodoIni, vPeriodoFim
     FROM ( SELECT p.cean_int, UPPER(p.uCom), SUM(p.vNF) / SUM(p.qCom) media
	      FROM temp_nfemedicamentos_calc_fracionamento p -- apenas os dados do mes
             WHERE p.periodo = p_periodo
               AND p.emitCNPJ8 != p.destcnpj8
               AND (p.vProd - p.vDesc) > 0 
               AND p.cean_int > 0
             GROUP BY p.cEAN_INT, UPPER(p.uCom)
            HAVING SUM(qCom) > 0 
            ) as a
      GROUP BY cean_int;
   
/*   SELECT cEAN, MAX(media) media, vPeriodoIni, vPeriodoFim
     FROM ( SELECT CAST(p.cEAN AS BIGINT) cEAN, UPPER(p.uCom), SUM(p.vNF) / SUM(p.qCom) media
	      FROM Produto_ext p -- apenas os dados do mes
             WHERE --periodo BETWEEN vPeriodoIni AND vPeriodoFim
                   p.emitCNPJ8 != p.destcnpj8
               AND (p.vProd - p.vDesc) > 0 
               AND NULLIF(NULLIF(p.cEAN,'Não Informado'),'SEM GTIN') IS NOT NULL
             GROUP BY CAST(p.cEAN AS BIGINT), UPPER(p.uCom)
            HAVING SUM(qCom) > 0 
            ) as a
      GROUP BY cEAN;
      */
      
     
   /*
   SELECT cEAN, MAX(media) media, vPeriodoIni, vPeriodoFim
     FROM ( SELECT CAST(p.cEAN AS BIGINT) cEAN, p.uCom, SUM(p.vNF) / SUM(p.qCom) media
	      FROM Produto p
             WHERE periodo BETWEEN vPeriodoIni AND vPeriodoFim
               AND p.emitCNPJ8 != p.destcnpj8
               AND (p.vProd - p.vDesc) > 0 
                AND NULLIF(p.cEAN,'Não Informado') IS NOT NULL
             GROUP BY CAST(p.cEAN AS BIGINT), p.uCom
            HAVING SUM(qCom) > 0 
            ) as a
      GROUP BY cEAN; */

      

   -- Identifica Edicao BrasIndice
   INSERT INTO temp_produto_edicaobrasindice
   SELECT prod.nfuid, prod.nitem, prod.qcom, prod.vunitario, prod.cean_int cean
	 ,CASE	WHEN (medicamentos.cean_int IS NULL) THEN -- Nao e medicamento
		   NULL 
		WHEN (b.edicao IS NOT NULL) THEN
		   b.edicao
          END AS edicaoBrasIndice
         ,prod.demi
     FROM temp_nfemedicamentos_calc_fracionamento AS prod 
     LEFT JOIN (SELECT DISTINCT cean_int FROM listaprecobrasindice) medicamentos
       ON medicamentos.cean_int = CAST(prod.cean AS BIGINT)
     LEFT JOIN listaprecobrasindice b -- vigencia dentro do periodo
       ON b.cean_int =  medicamentos.cean_int
      AND prod.demi BETWEEN b.datainiciovigencia AND b.datafimvigencia
     LEFT JOIN (SELECT cean_int, MAX(edicao) maxEdicao, MIN(edicao) minEdicao, MAX(datainiciovigencia) maxDatainiciovigencia, MIN(datainiciovigencia) MinDataIniciovigencia FROM listaprecobrasindice GROUP BY cean_int) as b1
       ON b1.cean_int = medicamentos.cean_int
    WHERE prod.periodo = p_periodo
      AND prod.cean_int > 0;   
/*   SELECT prod.nfuid, prod.nitem, prod.qcom, prod.vunitario, cast(cean AS BIGINT) cean
	 ,CASE	WHEN (medicamentos.cean_int IS NULL) THEN -- Nao e medicamento
		   NULL 
		WHEN (b.edicao IS NOT NULL) THEN
		   b.edicao
          END AS edicaoBrasIndice
         ,prod.demi
     FROM produto_ext AS prod 
     LEFT JOIN (SELECT DISTINCT cean_int FROM listaprecobrasindice) medicamentos
       ON medicamentos.cean_int = CAST(prod.cean AS BIGINT)
     LEFT JOIN listaprecobrasindice b -- vigencia dentro do periodo
       ON b.cean_int =  medicamentos.cean_int
      AND prod.demi BETWEEN b.datainiciovigencia AND b.datafimvigencia
     LEFT JOIN (SELECT cean_int, MAX(edicao) maxEdicao, MIN(edicao) minEdicao, MAX(datainiciovigencia) maxDatainiciovigencia, MIN(datainiciovigencia) MinDataIniciovigencia FROM listaprecobrasindice GROUP BY cean_int) as b1
       ON b1.cean_int = medicamentos.cean_int
    WHERE prod.periodo = p_periodo
      AND NULLIF(NULLIF(prod.cean, 'Não Informado'),'SEM GTIN') IS NOT NULL;
      */
   

   TRUNCATE TABLE resultado_fracionamento_nfemedicamentos;

   -- Resultado do fracionamento
   INSERT INTO resultado_fracionamento_nfemedicamentos
   (nfuid, nitem, cean, qcom, vunitario, demi, periodo,  max_media, qtd_fracionamento, precopmc, precopmcfracionado, precopfb, precopfbfracionado, qtd_comprada, qtd_comprada_fracionada, edicaobrasindice, c1, c2, c3)
   SELECT v2.nfuid, v2.nitem, v2.cean, v2.qcom, v2.vunitario, v2.demi, p_periodo, v2.maxmedia, v2.qtdfracionamento, v2.precopmc, v2.precopmcfracionado, v2.precopfb, v2.precopfbfracionado, v2.qcom, 
          NULLIF(CASE WHEN (v2.c3 LIKE 'Frac%' AND COALESCE(v2.qtdFracionamento,0) > 0) THEN v2.qcom ELSE v2.qcom * v2.qtdFracionamento END,0) AS qtd_comprada_fracionada, v2.edicaobrasindice, v2.c1, v2.c2, v2.c3
     FROM (
  
   SELECT v.*,
		CASE 
		   WHEN (COALESCE(v.precoPMC,0) > 0 AND COALESCE(v.vUnitario,0) > COALESCE(v.PrecoPmc,0))
	              THEN '?'
	           WHEN (COALESCE(v.vUnitario,0) = 0)  
		      THEN 'S/NFe'
	           WHEN (COALESCE(v.qtdFracionamento,0) = 1)
		      THEN 'Não Fracionado1'
		   WHEN (v.c1 != 'F' AND v.c2 = 'NF' AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0) AND v.vUnitario > COALESCE(v.PrecoPfbFracionado,0))
		      THEN 'Não Fracionado2'
	           WHEN (COALESCE(v.PrecoPfb,0) > 0 AND v.vUnitario > COALESCE(v.PrecoPfb,0) AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0))
		      THEN 'Não Fracionado3'
	           WHEN (v.vUnitario > COALESCE(v.PrecoPmcFracionado,0) AND
		        ( (COALESCE(v.qtdFracionamento,0) > 10 AND COALESCE(v.qtdFracionamento,0) < 500 AND COALESCE(v.PrecoPfbFracionado,0) > 0 AND v.vUnitario > v.PrecoPfbFracionado * 10 ) 
		     OR   (COALESCE(v.qtdFracionamento,0) >= 500 AND COALESCE(v.PrecoPfbFracionado,0) > 0 AND v.vUnitario > v.PrecoPfbFracionado * 20)
		     OR   (COALESCE(v.qtdFracionamento,0) < 5 AND COALESCE(v.PrecoPfb,0) > 0 AND v.vUnitario > COALESCE(v.PrecoPfb,0) * 0.7)
		     OR   (COALESCE(v.qtdFracionamento,0) > 10 AND COALESCE(v.qtdFracionamento,0) < 50 AND COALESCE(v.Maxmedia,0) > 0 AND COALESCE(v.PrecoPfbFracionado,0) > 0 AND v.vUnitario > v.PrecoPfbFracionado * 3 AND v.vUnitario > v.Maxmedia / 2 )))
		      THEN 'Não Fracionado4'
                   WHEN (COALESCE(v.PrecoPmcFracionado,0) > 0 AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0))
                      THEN '?'
  	           WHEN (COALESCE(v.PrecoPfbFracionado,0) > 0 AND COALESCE(v.qtdFracionamento,0) > 10 AND v.vUnitario < v.PrecoPfbFracionado)
		      THEN 'Fracionado1'
	           WHEN (v.c1 = 'F' AND v.c2 = 'F')
		      THEN 'Fracionado2'
	           WHEN (COALESCE(v.PrecoPfbFracionado,0) > 0 AND COALESCE(v.qtdFracionamento,0) > 5 AND (v.c2 = 'F' OR v.vUnitario < COALESCE(v.PrecoPfbFracionado,0)) )
		      THEN 'Fracionado3'
	           WHEN (v.c1 = 'F' AND v.c2 != 'NF')
		      THEN 'Fracionado4'
		   ELSE 
		      '?'
		   END AS c3
   /* --Regra de acordo com o documento, 1 versao 
	  CASE WHEN (COALESCE(v.precoPMC,0) > 0 AND COALESCE(v.vUnitario,0) > COALESCE(v.PrecoPmc,0))
	          THEN '> PMC Brasíndice'
	       WHEN (COALESCE(v.vUnitario,0) = 0)  
		  THEN 'S/NFe'
	       WHEN (COALESCE(v.qtdFracionamento,0) = 1)
		  THEN 'Não Fracionado1'
	       WHEN (v.c1 != 'F' AND v.c2 = 'NF' AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0) AND v.vUnitario > COALESCE(v.PrecoPfbFracionado,0))
		  THEN 'Não Fracionado2'
	       WHEN (COALESCE(v.PrecoPfb,0) > 0 AND v.vUnitario > COALESCE(v.PrecoPfb,0) AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0))
		  THEN 'Não Fracionado3'
	       WHEN (v.vUnitario > COALESCE(v.PrecoPmcFracionado,0) AND
		   ( (COALESCE(v.qtdFracionamento,0) > 10 AND COALESCE(v.qtdFracionamento,0) < 500 AND v.vUnitario > COALESCE(v.PrecoPfbFracionado,0) * 10 ) 
		OR   (COALESCE(v.qtdFracionamento,0) >= 500 AND v.vUnitario > COALESCE(v.PrecoPfbFracionado,0) * 20)
		OR   (COALESCE(v.qtdFracionamento,0) < 5 AND COALESCE(v.PrecoPfb,0) != 0 AND v.vUnitario > COALESCE(v.PrecoPfb,0) * 0.7)
		OR   (COALESCE(v.qtdFracionamento,0) > 10 AND COALESCE(v.qtdFracionamento,0) < 50 AND v.vUnitario > COALESCE(v.PrecoPfbFracionado,0) * 3 AND v.vUnitario > COALESCE(v.Maxmedia,0) / 2 )))
		  THEN 'Não Fracionado4'
	       WHEN (COALESCE(v.PrecoPmcFracionado,0) > 0 AND v.vUnitario > v.PrecoPmcFracionado)
		  THEN '?'
	       WHEN (COALESCE(v.PrecoPfbFracionado,0) > 0 AND COALESCE(v.qtdFracionamento,0) > 10 AND v.vUnitario < v.PrecoPfbFracionado)
		  THEN 'Fracionado1'
	       WHEN (v.c1 = 'F' AND v.c2 = 'F')
		  THEN 'Fracionado2'
	       WHEN (COALESCE(v.PrecoPfbFracionado,0) > 0 AND COALESCE(v.qtdFracionamento,0) > 5 AND (v.c2 = 'F' OR v.vUnitario < COALESCE(v.PrecoPfbFracionado,0)) )
		  THEN 'Fracionado3'
	       WHEN (v.c1 = 'F' AND v.c2 != 'NF')
		  THEN 'Fracionado4'
	       WHEN (COALESCE(v.PrecoPfbFracionado,0) = 0)
		 THEN 'Sem PF/RS Frac Brasíndice'
	       WHEN (COALESCE(v.MaxMedia,0) = 0)
		 THEN 'MaxMedia inconsistente'
	       ELSE '?'
	  END as c3 
	  */

	  /* Regra do C4.1 do Qlik
	  CASE 
		WHEN (COALESCE(v.vUnitario,0) = 0)  
		   THEN 'S/NFe'
		WHEN (COALESCE(v.qtdFracionamento,0) = 1)
		   THEN 'Não Fracionado1'
		WHEN (COALESCE(v.PrecoPfbFracionado,0) > 0 AND COALESCE(v.qtdFracionamento,0) > 10 AND v.vUnitario < COALESCE(v.PrecoPfbFracionado,0))
		   THEN 'Fracionado1'
		WHEN (v.c1 = 'F' AND v.c2 = 'F')
		   THEN 'Fracionado2'
		WHEN (COALESCE(v.PrecoPfbFracionado,0) > 0 AND COALESCE(v.qtdFracionamento,0) > 5 AND (v.vUnitario < COALESCE(v.PrecoPfbFracionado,0) OR v.c2 = 'F'))
		   THEN 'Fracionado3'
		WHEN (v.c1 = 'F' AND v.c2 != 'NF')
		   THEN 'Fracionado4'
		WHEN (v.c1 != 'F' AND v.c2 = 'NF' AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0) AND v.vUnitario > COALESCE(v.PrecoPfbFracionado,0))
		   THEN 'Não Fracionado2'
		WHEN (COALESCE(v.PrecoPfb,0) > 0 AND v.vUnitario > COALESCE(v.PrecoPfb,0) AND v.vUnitario > COALESCE(v.PrecoPmcFracionado,0))
		  THEN 'Não Fracionado3'
		ELSE '?'
	   END as c3 
	   */
	  
     FROM ( SELECT p.nfUID, p.nItem, p.cEAN, p.qCom, p.vUnitario, p.dEmi, mv.MaxMedia, b.precoPFB, b.precoPFBFracionado, b.precoPMC, b.precoPMCFracionado, b.qtdFracionamento, p.edicaobrasindice,
			CASE WHEN (COALESCE(p.vUnitario,0) = 0)
					THEN 'S/NFe'
				 WHEN (COALESCE(mv.MaxMedia,0) = 0)
					THEN 'MaxMedia inconsistente'
				 WHEN (COALESCE(b.qtdFracionamento,0) = 0)
					THEN 'Qtd. Frac Brasíndice inconsistente'
				 WHEN (COALESCE(b.qtdFracionamento,0) > 1 AND 
						(abs((p.vUnitario - (mv.MaxMedia / b.qtdFracionamento)) / (mv.MaxMedia/ b.qtdFracionamento)) < 0.5))
					THEN 'F'
				 ELSE 'NF'
			END AS c1,

			CASE WHEN (COALESCE(p.vUnitario,0) = 0)
					THEN 'S/NFe'
				WHEN (COALESCE(b.qtdFracionamento,0) = 1)
					THEN 'NF'
				WHEN COALESCE(b.precoPFB,0) = 0
					THEN 'Sem PF/RS Brasíndice'
				WHEN ((abs(p.vUnitario-b.precoPFB)/p.vUnitario) < 0.5)
					THEN 'NF'
				WHEN (COALESCE(b.precoPFBFracionado,0) = 0)
					THEN 'Sem PF/RS Frac Brasíndice'
				WHEN ((ABS(p.vUnitario-b.precoPFBFracionado)/b.precoPFBFracionado) < 0.5)
					THEN 'F'
				ELSE 'Dúvida'
			END AS c2
	  FROM temp_produto_edicaobrasindice p
	  LEFT JOIN ( SELECT cean_int, edicao, precoPMC, precoPFB, COALESCE(precoPMCFracionadoAjustado, precoPMCFracionado) precoPMCFracionado, COALESCE(precoPFBFracionadoAjustado, precoPFBFracionado) precoPFBFracionado, COALESCE(qtdFracionamentoAjustado, qtdFracionamento) qtdFracionamento
	                FROM listaprecobrasindice ) b
	    ON p.cean = b.cean_int
	   AND p.edicaobrasindice = b.edicao
	 INNER JOIN temp_maiorvalorvendaproduto mv
	    ON mv.cEAN = p.cEAN
		   ) v
		     ) v2   ;
		   
 
  
   RETURN 'ok';
  
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION calcula_fracionamento_nfemedicamentos(integer)
  OWNER TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION calcula_fracionamento_nfemedicamentos(integer) TO public;
GRANT EXECUTE ON FUNCTION calcula_fracionamento_nfemedicamentos(integer) TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION calcula_fracionamento_nfemedicamentos(integer) TO qualidadegasto_dataread;

