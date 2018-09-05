SELECT 
	Z01010.Z01_CODGER AS 'COD GERAL',
	SB2010.B2_FILIAL AS 'FILIAS', 
	SB2010.B2_LOCAL AS 'ARMAZÉM', 
	Z01010.Z01_DESC AS 'DESCRIÇÃO ARMAZÉM',
	CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
	CASE WHEN Z01010.Z01_TIPO = 1 THEN 'ESTOQUE' WHEN Z01010.Z01_TIPO = 2 THEN 'APLIC. DIRETA' ELSE 'ERRO' END AS 'TIPO ARMAZÉM',
	CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' WHEN Z01010.Z01_TME = '006' THEN 'Usados' ELSE 'ERRO' END AS 'TIPO',
	--CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
	--CASE WHEN Z01010.Z01_OBRA = 'N' THEN 'Não' WHEN Z01010.Z01_OBRA = 'S' THEN 'Sim' ELSE 'ERRO' END AS 'OBRIGA OBRA?',
	RTRIM(SB2010.B2_COD) AS 'COD PRODUTO', 
	RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO', 
	SB2010.B2_QATU AS 'QTD', 
	SB2010.B2_CM1 AS 'CUSTO UND - SISTEMA',
	SB2010.B2_VATU1 AS 'VALOR EM ESTOQUE - SISTEMA',
	SB1010.B1_UPRC AS 'CUSTO UND - ULT PREC COMPR',
	SB1010.B1_UPRC*SB2010.B2_QATU AS 'VALOR EM ESTOQUE - ULT PREC COMPR',
	
	-- (
		-- SELECT AVG(SC7010.C7_PRECO)
		-- FROM PROTHEUS.dbo.SC7010 SC7010
		-- WHERE (SC7010.D_E_L_E_T_<>'*') AND (SC7010.C7_EMISSAO>'20140312') AND (SC7010.C7_CONAPRO='L') AND (SC7010.C7_QUJE>0) AND (SC7010.C7_RESIDUO<>'S') AND (SB2010.B2_COD=SC7010.C7_PRODUTO)
	-- ) AS 'VAL. MEDIO COMPRA',
	
	-- (
		-- SELECT SUM(SD1010.D1_QUANT)
		-- FROM PROTHEUS.dbo.SD1010 SD1010
		-- WHERE SD1010.D1_FILIAL=SB2010.B2_FILIAL AND  SD1010.D1_LOCAL=SB2010.B2_LOCAL AND SD1010.D1_COD=SB2010.B2_COD AND SD1010.D1_CC='' AND SD1010.D1_TES='   ' AND SD1010.D_E_L_E_T_<>'*'
	-- ) AS 'QTDE PRE-NOTA',
	
	-- (
		-- SELECT SUM(SD1010.D1_TOTAL)
		-- FROM PROTHEUS.dbo.SD1010 SD1010
		-- WHERE SD1010.D1_FILIAL=SB2010.B2_FILIAL AND  SD1010.D1_LOCAL=SB2010.B2_LOCAL AND SD1010.D1_COD=SB2010.B2_COD AND SD1010.D1_CC='' AND SD1010.D1_TES='   ' AND SD1010.D_E_L_E_T_<>'*'
	-- ) AS 'VAL TOTAL PRE-NOTA',
	
	Case RTrim(Coalesce(SB2010.B2_USAI,'')) WHEN ''  THEN Null ELSE convert(datetime,SB2010.B2_USAI, 112)END AS 'DT ULT SAÍDA',
	Case RTrim(Coalesce(SB2010.B2_DINVENT,'')) WHEN ''  THEN Null ELSE convert(datetime,SB2010.B2_DINVENT, 112)END AS 'DT INVENT',
	
	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO'

FROM PROTHEUS.dbo.SB2010 SB2010
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SB2010.B2_FILIAL+SB2010.B2_LOCAL)
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SB2010.B2_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO
	
WHERE 
	--(SB2010.B2_QATU<>'0') AND
	--(Z01010.Z01_MSBLQL = 2) AND
	--SB1010.B1_MSBLQL='2' AND
	(SB2010.D_E_L_E_T_<>'*') --AND
	--SB2010.B2_FILIAL='13' AND
	--Z01010.Z01_CODGER IN ('0951','0952','0220','0235','0749','1293','1289', '0201','0211','0216','0218','0221','0222','0225','0228','0231','0232','0238','0239','0242','0243','0244','0740','0742','0743','0744','0745','0746','0950','0963','0965','0975','0982','1289','1290','1291','1292','1293','1294','1303','1304','1305','1395','1396','1397')