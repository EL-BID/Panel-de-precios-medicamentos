-- Function: calcula_prm_cean_nao_ponderado(integer, integer, text, text, text, text)

-- DROP FUNCTION calcula_prm_cean_nao_ponderado(integer, integer, text, text, text, text);

CREATE OR REPLACE FUNCTION calcula_prm_cean_nao_ponderado(
    p_periodo_ini integer,
    p_periodo_fim integer,
    p_grupo_destinatario text,
    p_setor_especifico text,
    p_setor_geral text,
    p_osuser text)
  RETURNS integer AS
$BODY$
DECLARE
    r_produtos RECORD;
    r_stats prm_stats_type2;
    v_sql text;
    v_sql_where text;
    v_inicio TIMESTAMP;
    v_indicador_geral text;
    v_ic_lim_superior numeric;
    v_ic_lim_inferior numeric;
    v_ic_tam_amostra numeric;
    v_ic_tam_min_amostra numeric;
    v_ic_nivel_significancia numeric;
BEGIN	

   v_inicio = clock_timestamp();
   
   -- Criacao de temporarias
   BEGIN
      v_sql = ' CREATE GLOBAL TEMPORARY TABLE temp_total_cean (
		cean bigint,
		edicao int,
		qFornec int,
		qFornec_consist int) ON COMMIT DELETE ROWS DISTRIBUTED BY (cean);';
      EXECUTE v_sql;
   EXCEPTION
	WHEN OTHERS THEN
		EXECUTE 'TRUNCATE TABLE temp_total_cean;';
   END;
		
       	
   
   BEGIN
	v_sql = '   CREATE GLOBAL TEMPORARY TABLE temp_resultado_stat_preco_referencia(
			  periodoini integer,
			  periodofim integer,
			  cean character varying(14),
			  edicaobrasindice int,
			  principioativo character varying(50),
			  q25 double precision,
			  q50 double precision,
			  q75 double precision,
			  media double precision,
			  desvio double precision,
			  prm double precision,
			  coefvar double precision,
			  vtot double precision,
			  qtot double precision,
			  qfornec integer,
			  coefrep double precision,
			  qfornec_consist integer,
			  indicador_geral character varying(15),
			  ic_lim_inferior double precision, 
			  ic_lim_superior double precision, 
			  ic_tam_amostra double precision, 
			  ic_tam_min_amostra double precision, 
			  ic_nivel_significancia double precision
		) ON COMMIT DELETE ROWS DISTRIBUTED BY (cean); ';
	EXECUTE v_sql;		
   EXCEPTION
	WHEN others THEN
	   EXECUTE 'TRUNCATE TABLE temp_resultado_stat_preco_referencia';
   END;


    -- Contagens de Fornecedor
    v_sql = ' INSERT INTO temp_total_cean (cean, edicao, qFornec, qFornec_consist)
              SELECT 	p.cean_int, b.edicao, COUNT(DISTINCT p.emitcnpj8), 
			COUNT(DISTINCT( p.emitcnpj8)) FILTER(WHERE p.fracionado_c3 ILIKE $$Frac%$$ OR p.fracionado_c3 ILIKE $$Não Frac%$$) 
                FROM qualidadegasto.nfemedicamentos p
	       INNER JOIN qualidadegasto.vultimobrasindice b
	          ON b.cean_int = p.cean_int
	        LEFT JOIN qualidadegasto.classifhashcnpj8destinatario cf 
                  ON p.destcnpj8 = cf.cnpjbase 
	        LEFT JOIN qualidadegasto.grupodestinatario g 
	          ON cf.grupo_destinatario = g.grupodestinatario ';

     v_sql_where = ' WHERE p.periodo BETWEEN ' || p_periodo_ini || ' AND ' || p_periodo_fim || ' AND p.qcom >= 1 AND p.emitcnpj8 != p.destcnpj8 AND (p.vprod - p.vdesc) > 0 ';

     -- Filtro Grupo Destinatario
     IF NULLIF(TRIM(p_grupo_destinatario),'') IS NOT NULL THEN
 
	 IF p_grupo_destinatario LIKE 'NOT %' THEN
	     v_sql_where = v_sql_where || ' AND COALESCE(cf.grupo_destinatario,$$$$) != ANY($${' || SUBSTRING(p_grupo_destinatario,5) ||'}$$::text[]) ';
	 ELSE
	     v_sql_where = v_sql_where || ' AND COALESCE(cf.grupo_destinatario,$$$$) = ANY($${' || p_grupo_destinatario ||'}$$::text[]) ';
	 END IF;                                   

     END IF;

     -- Filtro Setor Especifico
     IF (NULLIF(TRIM(p_setor_especifico),'') IS NOT NULL) THEN
		IF p_setor_especifico LIKE 'NOT %' THEN
			v_sql_where = v_sql_where || ' AND g.setorespecifico IS NOT NULL AND g.setorespecifico != ANY($${' || SUBSTRING(p_setor_especifico,5) ||'}$$::text[]) ';
		ELSE
			v_sql_where = v_sql_where || ' AND COALESCE(g.setorespecifico,$$$$) = ANY($${' || p_setor_especifico ||'}$$::text[]) ';
		END IF;
     END IF;		            

     -- Filtro Setor Geral
     IF (NULLIF(TRIM(p_setor_geral),'') IS NOT NULL) THEN
		IF p_setor_geral LIKE 'NOT %' THEN
			v_sql_where = v_sql_where || ' AND COALESCE(g.setorgeral,$$Privado$$) != ANY($${' || SUBSTRING(p_setor_geral,5) ||'}$$::text[]) ';
		ELSE 
			v_sql_where = v_sql_where || ' AND COALESCE(g.setorgeral,$$Privado$$) = ANY($${' || p_setor_geral ||'}$$::text[]) ';
		END IF;
     END IF;


     v_sql = v_sql || v_sql_where || ' GROUP BY p.cean_int, b.edicao; ';

     RAISE NOTICE '%', v_sql;

     EXECUTE v_sql;
      	          
	          

     --
     v_sql = ' SELECT 	p.cean_int as cean, b.edicao as edicaobrasindice, anv.principioativo,
			array_agg(p.qcom_fracionado) qcom,  
			array_agg(p.vunitario_fracionado) vunitario, b.qFornec, b.qFornec_consist
		FROM qualidadegasto.nfemedicamentos p
	       INNER JOIN temp_total_cean b
	          ON b.cean = p.cean_int
	       LEFT JOIN (SELECT MAX(principioativo) principioativo, cean_int FROM qualidadegasto.listaprecoanvisa GROUP BY cean_int ) anv
	          ON anv.cean_int = p.cean_int';
         

      IF (NULLIF(TRIM(p_grupo_destinatario),'') IS NOT NULL OR
		NULLIF(TRIM(p_setor_especifico),'') IS NOT NULL OR 
			NULLIF(TRIM(p_setor_geral),'') IS NOT NULL )
      THEN
         v_sql = v_sql || ' LEFT JOIN qualidadegasto.classifhashcnpj8destinatario cf 
                                    ON p.destcnpj8 = cf.cnpjbase 
			    LEFT JOIN qualidadegasto.grupodestinatario g 
			            ON cf.grupo_destinatario = g.grupodestinatario ';
                                  
      END IF;


      v_sql_where = v_sql_where ||' AND (p.fracionado_c3 ILIKE $$Frac%$$ OR p.fracionado_c3 ILIKE $$Não Frac%$$) ';

      v_sql = v_sql || v_sql_where;
        
      v_sql = v_sql || ' GROUP BY p.cean_int, b.edicao, anv.principioativo, b.qfornec, b.qFornec_consist ';

      RAISE NOTICE '%', v_sql;
	
      FOR r_produtos IN EXECUTE (v_sql)
      LOOP

	 FOR r_stats IN SELECT * FROM qualidadegasto.prm_stats_nao_ponderado(r_produtos.qcom, r_produtos.vunitario) LIMIT 1
	 LOOP
	    SELECT * INTO v_ic_lim_inferior, v_ic_lim_superior, v_ic_tam_amostra, v_ic_tam_min_amostra, v_ic_nivel_significancia
	      FROM qualidadegasto.pr_intervalo_confianca(r_produtos.qcom, r_produtos.vunitario);
	 
	    IF (r_produtos.qFornec = 0) 
	    THEN
	       v_indicador_geral = 'NA';
	    ELSIF (r_produtos.qFornec < 3 OR r_stats.qtot < 50 OR r_stats.coefvar > .35 OR r_stats.coefrep < 0.45) 
	    THEN
	       v_indicador_geral = 'Inconsistente';
	    ELSE
	       v_indicador_geral = 'Consistente';
	    END IF;

 
	    -- Insere primeiro na temporaria 
	    INSERT INTO temp_resultado_stat_preco_referencia (cean, edicaobrasindice, principioativo, periodoini, periodofim, q25, q50, q75, media, desvio, prm, coefvar, vtot, qtot, coefrep, qfornec,
	     qFornec_consist, indicador_geral, ic_lim_inferior, ic_lim_superior, ic_tam_amostra, ic_tam_min_amostra, ic_nivel_significancia ) 
		 VALUES (r_produtos.cean, r_produtos.edicaobrasindice, r_produtos.principioativo, p_periodo_ini, p_periodo_fim, r_stats.q25, r_stats.q50, r_stats.q75, r_stats.media,
			r_stats.desvio, r_stats.prm, r_stats.coefvar, r_stats.vtot, r_stats.qtot, r_stats.coefrep, r_produtos.qFornec, r_produtos.qFornec_consist, v_indicador_geral,
			v_ic_lim_inferior, v_ic_lim_superior, v_ic_tam_amostra, v_ic_tam_min_amostra, v_ic_nivel_significancia);
			
	 END LOOP;			  


      END LOOP;


    DELETE FROM qualidadegasto.resultado_stat_preco_referencia_cean WHERE usuario = p_osuser;

    INSERT INTO qualidadegasto.resultado_stat_preco_referencia_cean (cean, edicaobrasindice, principioativo, periodoini, periodofim, q25, q50, q75, media, desvio, prm, coefvar, vtot, qtot, coefrep, 
    qfornec, qfornec_consist, usuario, datahora, indicador_geral, ic_lim_inferior, ic_lim_superior, ic_tam_amostra, ic_tam_min_amostra, ic_nivel_significancia ) 
    SELECT cean, edicaobrasindice, principioativo, periodoini, periodofim, q25, q50, q75, media, desvio, prm, coefvar, vtot, qtot, coefrep, 
    qfornec, qfornec_consist, p_osuser, current_timestamp, indicador_geral, ic_lim_inferior, ic_lim_superior, ic_tam_amostra, ic_tam_min_amostra, ic_nivel_significancia 
      FROM temp_resultado_stat_preco_referencia;


   DELETE 
     FROM tempo_stat_preco_referencia
    WHERE usuario = p_osuser
      AND categoria = 'cean';

   INSERT INTO tempo_stat_preco_referencia
   (usuario, inicio, fim, categoria)
   VALUES
   (p_osuser, v_inicio, clock_timestamp(), 'cean');
   
   RETURN 0;
  
END; $BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION calcula_prm_cean_nao_ponderado(integer, integer, text, text, text, text)
  OWNER TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION calcula_prm_cean_nao_ponderado(integer, integer, text, text, text, text) TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION calcula_prm_cean_nao_ponderado(integer, integer, text, text, text, text) TO public;
GRANT EXECUTE ON FUNCTION calcula_prm_cean_nao_ponderado(integer, integer, text, text, text, text) TO qualidadegasto_dataread;
