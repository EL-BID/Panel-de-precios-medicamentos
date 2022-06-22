-- Function: cria_temp_nfemedicamentos_fracionamento(integer)

-- DROP FUNCTION cria_temp_nfemedicamentos_fracionamento(integer);

CREATE OR REPLACE FUNCTION cria_temp_nfemedicamentos_fracionamento(p_periodo integer)
  RETURNS numeric AS
$BODY$
DECLARE
    v_sql text;
BEGIN	

    BEGIN
		EXECUTE ' CREATE GLOBAL TEMPORARY TABLE temp_nfemedicamentos_calc_fracionamento ON COMMIT DROP 
				AS ( SELECT * FROM nfemedicamentos WHERE periodo = ' || p_periodo ||')';
	EXCEPTION
	WHEN OTHERS THEN
		EXECUTE 'TRUNCATE TABLE temp_nfemedicamentos_calc_fracionamento;';
    END;

   RETURN 1;
  
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION cria_temp_nfemedicamentos_fracionamento(integer)
  OWNER TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION cria_temp_nfemedicamentos_fracionamento(integer) TO public;
GRANT EXECUTE ON FUNCTION cria_temp_nfemedicamentos_fracionamento(integer) TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION cria_temp_nfemedicamentos_fracionamento(integer) TO qualidadegasto_dataread;
