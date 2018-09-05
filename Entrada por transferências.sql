SELECT
	SD3010.D3_FILIAL AS 'FILIAL',
	SD3010.D3_LOCAL AS 'ARMAZÉM',
	RTRIM(Z01010.Z01_DESC) AS 'DESC_ALMOX',
	CASE WHEN SD3010.D3_TM = '499' THEN 'Entrada-Transf' END AS 'TM',
	SD3010.D3_TM AS 'TM-2',
	SD3010.D3_CF AS 'CF', 
	'ENTRADA' AS 'TIPO MOV',
	SD3010.D3_DOC AS 'DOCUMENTO RM',
	RTRIM(SD3010.D3_COD) AS 'COD',
	RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
	SD3010.D3_UM AS 'UND', 
	SD3010.D3_QUANT AS 'QTDE', 
	CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'EMISSÃO',
	LEFT(SD3010.D3_EMISSAO,6) AS 'ANO-MÊS',
	SD3010.D3_OSCLI AS 'HORA ENTREGA',
	SD3010.D3_USUARIO AS 'ALMOXARIFE',
	SD3010.D3_CLVL AS 'OBRA/PROJETO',
	CTH010.CTH_DESC01 AS 'DESC OBRA',
	SD3010.D3_TIPO AS 'TIPO',
	RTRIM(SD3010.D3_CONTA) AS 'CONTA CONTABIL',
	RTRIM(CT1010.CT1_DESC01) AS 'DESC CONTA',
	SD3010.D3_GRUPO AS 'GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO', 
	RTRIM(SD3010.D3_CC) AS 'CENTRO DE CUSTO',
	RTRIM(CTT010.CTT_DESC01) AS 'DESC CENTRO DE CUSTO',
	SD3010.D3_ESTORNO AS 'ESTORNO', 
	SD3010.D3_ITEMCTA AS 'CARRO', 
	SD3010.D3_FORNECE AS 'FORNECEDOR', 
	SD3010.D3_MEMO AS 'OBSERVACAO', 
	SD3010.D3_CUSTO1 AS 'CUSTO TOTAL - SISTEMA',
	SB1010.B1_UPRC AS 'VAL UND ULT. PREÇ. COMPRA',
	SB1010.B1_UPRC*SD3010.D3_QUANT AS 'VAL TOTAL ULT. PREÇ. COMPRA'

FROM 
--TABELA DE MOVIMENTOS
PROTHEUS.dbo.SD3010 SD3010
	--CONTA CONTABIL
	LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SD3010.D3_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_ <> '*'
	--OBRA-PROJETO
	LEFT JOIN PROTHEUS.dbo.CTH010 CTH010 ON SD3010.D3_CLVL=CTH010.CTH_CLVL AND CTH010.D_E_L_E_T_ <> '*'
	--CENTRO DE CUSTO
	LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SD3010.D3_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_ <> '*' 
	--ARMAZÉNS
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*'
	--GRUPO DE PRODUTO
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*' 
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
	--INFORMAÇÕES DE TRANSFERÊNCIAS
	(SD3010.D3_TM='499') AND
	--ESPECIFICA FILIAL
	(SD3010.D3_FILIAL='02') AND (SD3010.D3_LOCAL='22') AND
	--ESPECIFICA PERIODO
	(SD3010.D3_EMISSAO>='20160101') AND (SD3010.D3_EMISSAO<='20160930')