-- Function: atualiza_nfemedicamentos_periodo(integer)

-- DROP FUNCTION atualiza_nfemedicamentos_periodo(integer);

CREATE OR REPLACE FUNCTION atualiza_nfemedicamentos_periodo(p_periodo integer)
  RETURNS numeric AS
$BODY$
DECLARE
    v_sql text;
BEGIN	

      EXECUTE 'ALTER TABLE qualidadegasto.nfemedicamentos  DROP PARTITION IF EXISTS p' || p_periodo::text;
      EXECUTE 'ALTER TABLE qualidadegasto.nfemedicamentos  ADD PARTITION p' ||p_periodo::text || ' VALUES(' ||p_periodo::text ||') WITH (appendonly=true, orientation=column, compresstype=zlib, compresslevel=5); ';     

      

      v_sql = 'insert into nfemedicamentos ( periodo, nfuid, nitem, demi, ncm, icmsorig, cfop, icmscst, ucom, qcom,
	vuncom, vunitario, vnf, vprod, vfrete, vseg, vdesc, cean, ceantrib, cean_int, xprod, icmsvicms, icmsvicmsst,
	icmsvbc, icmsvbcst, icmspicms, icmspicmsst, emituf, destuf, emitcnpj, destcnpj, emitcnpj8, destcnpj8, xprodlimpo,
	fracionado_c1, fracionado_c2, fracionado_c3, qcom_fracionado, vunitario_fracionado, prp_fracionado_c1, prp_fracionado_c2,
	prp_fracionado_c3, prp_qcom_fracionado, prp_vunitario_fracionado) 
	
SELECT p.periodo
      ,p.nfuid
      ,p.nitem
      ,p.demi
      ,p.ncm
      ,p.icmsorig
      ,p.cfop
      ,p.icmscst
      ,p.ucom
      ,p.qcom
      ,p.vuncom
      ,p.vunitario      
      ,p.vnf
      ,p.vprod
      ,p.vfrete
      ,p.vseg
      ,p.vdesc
      ,NULLIF(p.cean, $$Não Informado$$) as cean
      ,p.ceantrib
      ,CAST(NULLIF(NULLIF(p.cean,$$Não Informado$$),$$SEM GTIN$$) AS BIGINT) cean_int
      ,p.xprod
      ,p.icmsvicms
      ,p.icmsvicmsst
      ,p.icmsvbc
      ,p.icmsvbcst
      ,p.icmspicms
      ,p.icmspicmsst
      ,p.emituf
      ,p.destuf
      ,p.emitcnpj
      ,p.destcnpj
      ,p.emitcnpj8
      ,p.destcnpj8
      ,p.xprodlimpo
      ,r.c1 as fracionado_c1
      ,r.c2 as fracionado_c2
      ,r.c3 as fracionado_c3
      ,COALESCE(r.qtd_comprada_fracionada, p.qcom) as qcom_fracionado
      ,COALESCE(CASE WHEN (p.qcom = 0) THEN 0
         ELSE p.vnf / 
		( CASE WHEN ( COALESCE(r.c3,$$?$$) IN ($$?$$, $$S/NFe$$, $$Fracionado1$$, $$Fracionado2$$, $$Fracionado3$$, $$Fracionado4$$)) 
		       THEN p.qcom ELSE r.qtd_comprada_fracionada 
		   END) 
	END , p.vunitario)AS   vunitario_fracionado
      ,r_prp.c1 as prp_fracionado_c1 
      ,r_prp.c2 as prp_fracionado_c2 
      ,r_prp.c3 as prp_fracionado_c3 
      ,COALESCE(r_prp.qtd_comprada_fracionada, p.qcom) AS qcom_fracionado 
      ,COALESCE(CASE WHEN (p.qcom = 0) THEN 0
         ELSE p.vnf / 
		( CASE WHEN ( COALESCE(r_prp.c3,$$?$$) IN ($$?$$, $$S/NFe$$, $$Fracionado1$$, $$Fracionado2$$, $$Fracionado3$$, $$Fracionado4$$)) 
		       THEN p.qcom ELSE r_prp.qtd_comprada_fracionada 
		   END) 
	END , p.vunitario)AS   prp_vunitario_fracionado
  FROM temp_nfemedicamentos_calc_fracionamento p
  LEFT JOIN resultado_fracionamento_nfemedicamentos r
    ON p.nfuid = r.nfuid 
   AND p.nitem = r.nitem
  LEFT JOIN resultado_fracionamento_prp_nfemedicamentos r_prp 
    ON r_prp.nfuid = p.nfuid
   AND r_prp.nitem = p.nitem;';
   

		
        EXECUTE v_sql;


  
   RETURN 1;
  
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION atualiza_nfemedicamentos_periodo(integer)
  OWNER TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION atualiza_nfemedicamentos_periodo(integer) TO public;
GRANT EXECUTE ON FUNCTION atualiza_nfemedicamentos_periodo(integer) TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION atualiza_nfemedicamentos_periodo(integer) TO qualidadegasto_dataread;
