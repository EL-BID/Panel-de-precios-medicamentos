-- Function: atualiza_fracionamento_nfemedicamentos(integer)

-- DROP FUNCTION atualiza_fracionamento_nfemedicamentos(integer);

CREATE OR REPLACE FUNCTION atualiza_fracionamento_nfemedicamentos(p_periodo integer)
  RETURNS numeric AS
$BODY$
DECLARE

BEGIN	

   PERFORM cria_temp_nfemedicamentos_fracionamento(p_periodo);

   PERFORM calcula_fracionamento_nfemedicamentos(p_periodo);

   PERFORM atualiza_nfemedicamentos_periodo(p_periodo);

   RETURN 1;
  
END; 
$BODY$
  LANGUAGE plpgsql VOLATILE;
ALTER FUNCTION atualiza_fracionamento_nfemedicamentos(integer)
  OWNER TO qualidadegasto_admin;
GRANT EXECUTE ON FUNCTION atualiza_fracionamento_nfemedicamentos(integer) TO public;
GRANT EXECUTE ON FUNCTION atualiza_fracionamento_nfemedicamentos(integer) TO qualidadegasto_dataread;
REVOKE ALL ON FUNCTION atualiza_fracionamento_nfemedicamentos(integer) FROM qualidadegasto_admin;
