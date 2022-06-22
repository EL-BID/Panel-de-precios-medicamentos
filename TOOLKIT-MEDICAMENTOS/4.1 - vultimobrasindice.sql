-- View: vultimobrasindice

-- DROP VIEW vultimobrasindice;

CREATE OR REPLACE VIEW vultimobrasindice AS 
 WITH edicao AS (
         SELECT b.cean_int, max(b.edicao) AS edicao
           FROM listaprecobrasindice b
          GROUP BY b.cean_int
        )
 SELECT br.edicao, br.codlaboratorio, br.nomelaboratorio, br.codbrasindice, br.nomemedicamento, br.codapresentacao, br.nomeapresentacao, br.precopmc, br.precopmcfracionado, br.precopfb, br.precopfbfracionado, br.qtdfracionamento, br.edicaoultalteracao, br.ipi, br.portariapiscofins, br.generico, br.oncologico, br.restrito, br.codean, br.codtuss, br.codtiss, br.liberado, br.codgrupoproduto, br.dieta, br.codhierarquia, br.datainiciovigencia, br.datafimvigencia, br.cean_int, br.qtdfracionamentoajustado, br.precopmcfracionadoajustado, br.precopfbfracionadoajustado
   FROM listaprecobrasindice br
   JOIN edicao e ON br.edicao = e.edicao AND br.cean_int = e.cean_int;

ALTER TABLE vultimobrasindice
  OWNER TO qualidadegasto_admin;
GRANT ALL ON TABLE vultimobrasindice TO qualidadegasto_admin;
GRANT SELECT ON TABLE vultimobrasindice TO qualidadegasto_dataread;
