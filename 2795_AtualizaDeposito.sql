/*
    PADM066 2795
    PADM054 2466
*/

BEGIN

FOR r_deposito IN (SELECT pcpopcomponente.empresa,
                          pcpopcomponente.deposito_baixa,
                          pcpopcomponente.op,
                          pcpopcomponente.etapa_aplicacao,
                          pcpopcomponente.componente,
                          pcpopcomponente.quantidade_aplicada,
                          pcpopcomponente.total_aplicado,
                          Nvl(pcpopgrupocomp.aplicador, 0) aplicador,
                          pcpopgrupocomp.seq_grupo,
                          pcpop.peso
                   FROM   pcpoprecurso,
                          pcpopcomponente,
                          estitem,
                          pcpopgrupocomp,
                          pcpop
                   WHERE  pcpoprecurso.empresa = 1
                          AND pcpoprecurso.situacao = 'F'
                          AND pcpoprecurso.etapa = 20
                          AND pcpoprecurso.empresa = pcpopcomponente.empresa
                          AND pcpoprecurso.op = pcpopcomponente.op
                          AND pcpoprecurso.etapa = Nvl(pcpopcomponente.etapa_aplicacao, 20)
                          AND pcpoprecurso.imprime = 'S'
                          AND pcpopcomponente.empresa = estitem.empresa
                          AND pcpopcomponente.componente = estitem.codigo
                          AND pcpopcomponente.empresa = pcpopgrupocomp.empresa
                          AND pcpopcomponente.seq_grupo =pcpopgrupocomp.seq_grupo
                          AND pcpopcomponente.op = pcpopgrupocomp.op
                          AND pcpopcomponente.empresa = pcpop.empresa
                          AND pcpopcomponente.op = pcpop.op
                          AND estitem.tipo_item IN ( 11, 33 ))
  LOOP
                            
      IF r_deposito.quantidade_aplicada <= 0 AND r_deposito.aplicador <= 0 THEN
        UPDATE pcpopcomponente
        SET    deposito_baixa = 33,
               quantidade_aplicada = 0.1,
               total_aplicado = 0.1 / 100 * r_deposito.peso
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND Nvl(etapa_aplicacao, 20) =
                   Nvl(r_deposito.etapa_aplicacao, 20)
               AND deposito_baixa = r_deposito.deposito_baixa
               AND componente = r_deposito.componente;

        UPDATE pcpopgrupocomp
        SET    aplicador = 2
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND seq_grupo = r_deposito.seq_grupo
               AND aplicador IS NULL;
               
      ELSIF r_deposito.quantidade_aplicada > 0 AND r_deposito.aplicador = 0 THEN
        UPDATE pcpopcomponente
        SET    deposito_baixa = 33,
               total_aplicado = quantidade_aplicada / 100 * r_deposito.peso
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND Nvl(etapa_aplicacao, 20) =
                   Nvl(r_deposito.etapa_aplicacao, 20)
               AND deposito_baixa = r_deposito.deposito_baixa
               AND componente = r_deposito.componente;

        UPDATE pcpopgrupocomp
        SET    aplicador = 2
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND seq_grupo = r_deposito.seq_grupo
               AND aplicador IS NULL;
      ELSIF r_deposito.quantidade_aplicada = 0
            AND r_deposito.aplicador <> 0 THEN
        UPDATE pcpopcomponente
        SET    deposito_baixa = 33,
               quantidade_aplicada = 0.1,
               total_aplicado = 0.1 / 100 * r_deposito.peso
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND Nvl(etapa_aplicacao, 20) =
                   Nvl(r_deposito.etapa_aplicacao, 20)
               AND deposito_baixa = r_deposito.deposito_baixa
               AND componente = r_deposito.componente;

        UPDATE pcpopgrupocomp
        SET    aplicador = 2
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND seq_grupo = r_deposito.seq_grupo
               AND aplicador IS NULL;
      ELSIF r_deposito.quantidade_aplicada > 0
            AND r_deposito.total_aplicado = 0 THEN
        UPDATE pcpopcomponente
        SET    deposito_baixa = 33,
               total_aplicado = quantidade_aplicada / 100 * r_deposito.peso
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND Nvl(etapa_aplicacao, 20) =
                   Nvl(r_deposito.etapa_aplicacao, 20)
               AND deposito_baixa = r_deposito.deposito_baixa
               AND componente = r_deposito.componente;

        UPDATE pcpopgrupocomp
        SET    aplicador = 2
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND seq_grupo = r_deposito.seq_grupo
               AND aplicador IS NULL;
      ELSE
        UPDATE pcpopcomponente
        SET    deposito_baixa = 33
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND Nvl(etapa_aplicacao, 20) =
                   Nvl(r_deposito.etapa_aplicacao, 20)
               AND deposito_baixa = r_deposito.deposito_baixa
               AND componente = r_deposito.componente;

        UPDATE pcpopgrupocomp
        SET    aplicador = 2
        WHERE  empresa = r_deposito.empresa
               AND op = r_deposito.op
               AND seq_grupo = r_deposito.seq_grupo
               AND aplicador IS NULL;
               
      END IF;
  END LOOP;

  -- Alteraçao de Insumos Base
  FOR r_tintas IN (SELECT pcpopcomponente.empresa,
                          pcpopcomponente.deposito_baixa,
                          pcpopcomponente.op,
                          pcpopcomponente.etapa_aplicacao,
                          pcpopcomponente.componente,
                          pcpopcomponente.quantidade_aplicada,
                          pcpopcomponente.total_aplicado,
                          Nvl(pcpopgrupocomp.aplicador, 0) aplicador,
                          pcpopgrupocomp.seq_grupo,
                          pcpop.peso
                   FROM   pcpoprecurso,
                          pcpopcomponente,
                          estitem,
                          pcpopgrupocomp,
                          pcpop
                   WHERE  pcpoprecurso.empresa = 1
                          AND pcpoprecurso.situacao = 'F'
                          AND pcpoprecurso.etapa = 100
                          AND pcpoprecurso.empresa = pcpopcomponente.empresa
                          AND pcpoprecurso.op = pcpopcomponente.op
                          AND pcpopcomponente.deposito_baixa <> 33
                          AND pcpopcomponente.empresa = estitem.empresa
                          AND pcpopcomponente.componente = estitem.codigo
                          AND pcpopcomponente.empresa = pcpopgrupocomp.empresa
                          AND pcpopcomponente.seq_grupo =
                              pcpopgrupocomp.seq_grupo
                          AND pcpopcomponente.op = pcpopgrupocomp.op
                          AND pcpopcomponente.empresa = pcpop.empresa
                          AND pcpopcomponente.op = pcpop.op
                          AND estitem.tipo_item IN ( 21 ))
                          
  LOOP
      UPDATE pcpopcomponente
      SET    etapa_aplicacao = 100,
             deposito_baixa = 33
      WHERE  empresa = r_tintas.empresa
             AND op = r_tintas.op;
             
  --  and deposito_baixa = r_tintas.deposito_baixa
  --  and etapa_aplicacao = r_tintas.etapa_aplicacao;
  
  END LOOP;
END;  
