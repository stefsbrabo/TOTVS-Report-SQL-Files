SELECT 

	Z01010.Z01_CODGER AS 'COD GERAL',
	Z01010.Z01_FILIAL AS 'FILIAL', 
	Z01010.Z01_COD AS 'ARMAZÉM', 
	Z01010.Z01_DESC AS 'DESCRIÇÃO ARMAZÉM',
	
	(
		SELECT SUM(SD1010.D1_TOTAL)
		FROM PROTHEUS.dbo.SD1010 SD1010
		WHERE
			--SOMENTE PARA ARMAZÉNS
			(SD1010.D1_CC='') AND
			--DESCONSIDERA DELETADOS
			(SD1010.D_E_L_E_T_<>'*') AND 
			--ESPECIFICA A TES
			(SD1010.D1_TES='451' OR SD1010.D1_TES='101' OR SD1010.D1_TES='102' OR SD1010.D1_TES='105' OR SD1010.D1_TES='106' OR SD1010.D1_TES='461' OR SD1010.D1_TES='465' OR SD1010.D1_TES='472') AND
			--ESPECIFICA LOCAL
			((SD1010.D1_FILIAL=Z01010.Z01_FILIAL) AND (SD1010.D1_LOCAL=Z01010.Z01_COD)) AND 
			--ESPECIFICA PERIODO
			(SD1010.D1_DTDIGIT>='20160101') AND (SD1010.D1_DTDIGIT<='20160930')
	) AS 'ENTRADA-PRENOTA',
	
	(
		SELECT SUM(SD3010.D3_CUSTO1) 
		FROM PROTHEUS.dbo.SD3010 SD3010
		WHERE 
			--IGNORAR DELETADOS
			(SD3010.D_E_L_E_T_<>'*') AND 
			--VALIDAÇÃO DE TIPO DE MOVIMENTO
			(LEFT(SD3010.D3_CF,2) = 'DE') AND
			--IGNORA ESTORNO
			(SD3010.D3_ESTORNO='') AND
			--IGNORA INVENTARIO
			(SD3010.D3_DOC NOT LIKE '%INVENT%') AND
			--INFORMAÇÕES DE TRANSFERÊNCIAS
			(SD3010.D3_TM='499') AND
			--ESPECIFICA FILIAL
			(SD3010.D3_FILIAL=Z01010.Z01_FILIAL) AND (SD3010.D3_LOCAL=Z01010.Z01_COD)  AND
			--ESPECIFICA PERIODO
			(SD3010.D3_EMISSAO>='20160101') AND (SD3010.D3_EMISSAO<='20160930')
	) AS 'ENTRADA-TRANSF',
	
	(
		SELECT SUM(SB2010.B2_VATU1)
		FROM PROTHEUS.dbo.SB2010 SB2010
		WHERE (SB2010.D_E_L_E_T_<>'*') AND (SB2010.B2_FILIAL=Z01010.Z01_FILIAL) AND (SB2010.B2_LOCAL=Z01010.Z01_COD)
	) AS 'SALDO DE ESTOQUE',
	
	(
	SELECT SUM((SD3010.D3_QUANT * SB1010.B1_UPRC)*-1)
	FROM PROTHEUS.dbo.SD3010 SD3010
	--PRODUTOS
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
	WHERE 
		--IGNORAR DELETADOS
		(SD3010.D_E_L_E_T_<>'*') AND 
		--VALIDAÇÃO DE TIPO DE MOVIMENTO
		(LEFT(SD3010.D3_CF,2) = 'RE') AND
		--IGNORA ESTORNO
		(SD3010.D3_ESTORNO='') AND
		--IGNORA INVENTARIO
		(SD3010.D3_DOC NOT LIKE '%INVENT%') AND
		--IGNORA ALGUNS MOVIMENTOS INTERNOS
			(
			SD3010.D3_TM<>'499' AND
			SD3010.D3_TM<>'999' AND
			SD3010.D3_TM<>'502' AND
			SD3010.D3_TM<>'503' AND
			SD3010.D3_TM<>'504'
			) AND
		--ESPECIFICA FILIAL
		(SD3010.D3_FILIAL=Z01010.Z01_FILIAL) AND (SD3010.D3_LOCAL=Z01010.Z01_COD) 
		AND
		--ESPECIFICA PERIODO
		(SD3010.D3_EMISSAO>='20160101') AND (SD3010.D3_EMISSAO<='20160930')
	) AS 'SAÍDAS ARMAZÉM',
	
	(
	SELECT SUM(SD3010.D3_QUANT * SB1010.B1_UPRC)
	FROM PROTHEUS.dbo.SD3010 SD3010
	--PRODUTOS
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
	WHERE 
		--IGNORAR DELETADOS
		(SD3010.D_E_L_E_T_<>'*') AND 
		--VALIDAÇÃO DE TIPO DE MOVIMENTO
		(LEFT(SD3010.D3_CF,2) = 'DE') AND
		--IGNORA ESTORNO
		(SD3010.D3_ESTORNO='') AND
		--IGNORA INVENTARIO
		(SD3010.D3_DOC NOT LIKE '%INVENT%') AND
		--IGNORA ALGUNS MOVIMENTOS INTERNOS
			(
			SD3010.D3_TM<>'499' AND
			SD3010.D3_TM<>'002' AND
			SD3010.D3_TM<>'003' AND
			SD3010.D3_TM<>'004'
			) AND
		--ESPECIFICA FILIAL
		(SD3010.D3_FILIAL=Z01010.Z01_FILIAL) AND (SD3010.D3_LOCAL=Z01010.Z01_COD)
		AND
		--ESPECIFICA PERIODO
		(SD3010.D3_EMISSAO>='20160101') AND (SD3010.D3_EMISSAO<='20160930')
		) AS 'DEVOLUÇÕES ARMAZÉM',
	
	CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
	CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
	CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
	CASE WHEN Z01010.Z01_OBRA = 'N' THEN 'Não' WHEN Z01010.Z01_OBRA = 'S' THEN 'Sim' ELSE 'ERRO' END AS 'OBRIGA OBRA?'

FROM PROTHEUS.dbo.Z01010 Z01010

WHERE
	(Z01010.D_E_L_E_T_<>'*')
	
ORDER BY Z01010.Z01_FILIAL, Z01010.Z01_COD