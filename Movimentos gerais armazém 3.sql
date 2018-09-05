/* -- ENTRADA POR PRÉ-NOTA */
	SELECT
		SD1010.D1_FILIAL AS 'FILIAL',
		SD1010.D1_LOCAL AS 'LOCAL',
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
		SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		CAST(SF1010.F1_DTDIGIT AS DATETIME) AS 'DT EMISSÃO', 
		SD1010.D1_DOC AS 'DOCUMENTO',
		'NOTA FISCAL FORNECEDOR' AS 'TIPO DOCUMENTO',
		SD1010.D1_TES AS 'TM/TES',
		SB1010.B1_GRUPO AS 'COD GRUPO',
		RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
		SD1010.D1_COD AS 'CODIGO',
		RTRIM(SD1010.D1_DESCRI) AS 'DESCRIÇÃO',
		SUM(SD1010.D1_QUANT) AS 'QUANTIDADE',
		SUM(SD1010.D1_TOTAL) AS 'VAL TOTAL',
		CASE WHEN RTRIM(SD1010.D1_CLVL)='001' THEN 'ENTRADA - PRÉ-NOTA: INVESTIMENTO/MOBILIZAÇÃO' WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ENTRADA - ESTORNO DE NF' ELSE 'ENTRADA - PRÉ-NOTA: CUSTEIO' END AS 'TIPO DE MOVIMENTO',
		CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
		CASE WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ESTORNO DE DOCUMENTO | NF ORIGEM: '+RTRIM(SD1010.D1_NFORI) ELSE 'PC: '+RTRIM(SD1010.D1_PEDIDO)+' | USER INCLU: '+RTRIM(SF1010.F1_NMUSER)+' | USER CLA: '+RTRIM(SF1010.F1_NMCLASS) END AS 'DETALHE',
		RTRIM(SF1010.F1_NMUSER) AS 'USER MOVIMENTO'
	FROM PROTHEUS.dbo.SD1010 SD1010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SD1010.D1_FILIAL+SD1010.D1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD1010.D1_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES  AND SF4010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*'
	WHERE
		(SD1010.D_E_L_E_T_<>'*') AND
		(SD1010.D1_FILIAL='09' AND (SD1010.D1_LOCAL IN ('63'))) AND
		(LEFT(SA2010.A2_CGC,8)<>'05061494') AND
		(
			(SF1010.F1_DTDIGIT>='20161201' AND SF1010.F1_DTDIGIT<='20181231') AND
			(
				((SF4010.F4_ESTOQUE='S') OR (SF4010.F4_CODIGO='103' OR SF4010.F4_CODIGO='140')) OR (SD1010.D1_CC='          ' AND SD1010.D1_TES='   ') --CONSIDERA TAMBÉM NF'S NÃO CLASSIFICADAS
			)
		)
	GROUP BY
		SD1010.D1_FILIAL,
		SD1010.D1_LOCAL,
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
		SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
		CAST(SF1010.F1_DTDIGIT AS DATETIME),
		SD1010.D1_DOC,
		SD1010.D1_TES,
		SB1010.B1_GRUPO,
		SBM010.BM_DESC,
		SD1010.D1_COD,
		SD1010.D1_DESCRI,
		CASE WHEN RTRIM(SD1010.D1_CLVL)='001' THEN 'ENTRADA - PRÉ-NOTA: INVESTIMENTO/MOBILIZAÇÃO' WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ENTRADA - ESTORNO DE NF' ELSE 'ENTRADA - PRÉ-NOTA: CUSTEIO' END,
		SF4010.F4_ESTOQUE,
		CASE WHEN RTRIM(SD1010.D1_NFORI)<>'' THEN 'ESTORNO DE DOCUMENTO | NF ORIGEM: '+RTRIM(SD1010.D1_NFORI) ELSE 'PC: '+RTRIM(SD1010.D1_PEDIDO)+' | USER INCLU: '+RTRIM(SF1010.F1_NMUSER)+' | USER CLA: '+RTRIM(SF1010.F1_NMCLASS) END,
		RTRIM(SF1010.F1_NMUSER)

Union ALL

		/* -- MOVIMENTOS POR TRANSFERÊNCIA INTERNA */
	SELECT
		SD3010.D3_FILIAL AS 'FILIAL',
		SD3010.D3_LOCAL AS 'LOCAL',
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
		SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'DT EMISSÃO',
		SD3010.D3_DOC AS 'DOCUMENTO',
		'RM-TRANSF. INTERN.' AS 'TIPO DOCUMENTO',
		SD3010.D3_TM AS 'TM/TES',
		SB1010.B1_GRUPO AS 'COD GRUPO',
		RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
		SD3010.D3_COD AS 'COD',
		RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
		CASE WHEN SD3010.D3_TM = '499' THEN SUM(SD3010.D3_QUANT) WHEN SD3010.D3_TM = '999' THEN SUM(SD3010.D3_QUANT*-1) END AS 'QUANTIDADE',
		CASE WHEN SD3010.D3_TM = '499' THEN SUM(SB1010.B1_UPRC*SD3010.D3_QUANT)  WHEN SD3010.D3_TM = '999' THEN SUM((SB1010.B1_UPRC*SD3010.D3_QUANT)*-1) END AS 'VAL TOTAL', --ULT. PREÇ. COMPRA
		CASE WHEN SD3010.D3_DOC='INVENT' THEN 'ENTRADA/SAÍDA - INVENTÁRIO' WHEN SD3010.D3_TM = '499' THEN 'ENTRADA - TRANSF. INTERNA' WHEN SD3010.D3_TM = '999' THEN 'SAÍDA - TRANSF. INTERNA' END AS 'TIPO DE MOVIMENTO',
		'SIM' AS 'ATUALIZOU ESTOQUE?',
		CASE
			WHEN SD3010.D3_DOC='INVENT'
				THEN 'INVENTÁRIO. OPERADOR: '+RTRIM(SD3010.D3_USUARIO)
			WHEN SD3010.D3_TM = '499'
				THEN
					RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMORI)+'->'+RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(ENTRADA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(ENTRADA.Z22_SD3DOC)+' SOLIC: '+RTRIM(ENTRADA.Z22_USUARI)+' OBS: '+RTRIM(ENTRADA.Z22_OBS)
			WHEN SD3010.D3_TM = '999'
				THEN
					RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMORI)+'->'+RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(SAIDA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(SAIDA.Z22_SD3DOC)+' SOLIC: '+RTRIM(SAIDA.Z22_USUARI)+' OBS: '+RTRIM(SAIDA.Z22_OBS)
		END AS 'DETALHE',
		RTRIM(SD3010.D3_USUARIO) AS 'USER MOV'
	FROM PROTHEUS.dbo.SD3010 SD3010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
		--JOIN ENTRADA: 499
		LEFT JOIN PROTHEUS.dbo.Z22010 ENTRADA ON
			(ENTRADA.D_E_L_E_T_<>'*') AND
			(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMDES=SD3010.D3_FILIAL+SD3010.D3_LOCAL) AND
			(ENTRADA.Z22_SD3DOC=SD3010.D3_DOC) AND
			(ENTRADA.Z22_PRDDES=SD3010.D3_COD) AND
			(ENTRADA.Z22_APROV='L')
		--JOIN SAIDA: 999
		LEFT JOIN PROTHEUS.dbo.Z22010 SAIDA ON
			(SAIDA.D_E_L_E_T_<>'*') AND
			(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMORI=SD3010.D3_FILIAL+SD3010.D3_LOCAL) AND
			(SAIDA.Z22_SD3DOC=SD3010.D3_DOC) AND
			(SAIDA.Z22_PRDDES=SD3010.D3_COD) AND
			(SAIDA.Z22_APROV='L')
	WHERE
		(SD3010.D_E_L_E_T_<>'*') AND
		(SD3010.D3_ESTORNO='') AND
		--(SD3010.D3_DOC NOT LIKE '%INVENT%') AND
		(SD3010.D3_TM='499' OR SD3010.D3_TM='999') AND
		((SD3010.D3_EMISSAO>='20161201') AND (SD3010.D3_EMISSAO<='20181231')) AND
		SD3010.D3_FILIAL = '09' AND
		SD3010.D3_LOCAL IN ('63')
	GROUP BY
		SD3010.D3_FILIAL,
		SD3010.D3_LOCAL,
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
		SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
		CAST(SD3010.D3_EMISSAO AS DATETIME),
		SD3010.D3_DOC,
		SD3010.D3_TM,
		SB1010.B1_GRUPO,
		SBM010.BM_DESC,
		SD3010.D3_COD,
		SB1010.B1_DESC,
		SD3010.D3_TM,
		CASE
			WHEN SD3010.D3_DOC='INVENT'
				THEN 'INVENTÁRIO. OPERADOR: '+RTRIM(SD3010.D3_USUARIO)
			WHEN SD3010.D3_TM = '499'
				THEN
					RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMORI)+'->'+RTRIM(ENTRADA.Z22_FILIAL+ENTRADA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(ENTRADA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(ENTRADA.Z22_SD3DOC)+' SOLIC: '+RTRIM(ENTRADA.Z22_USUARI)+' OBS: '+RTRIM(ENTRADA.Z22_OBS)
			WHEN SD3010.D3_TM = '999'
				THEN
					RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMORI)+'->'+RTRIM(SAIDA.Z22_FILIAL+SAIDA.Z22_ALMDES)+' | DOC TRF:'+RTRIM(SAIDA.Z22_DOC)+
					' - DOC SD3: '+RTRIM(SAIDA.Z22_SD3DOC)+' SOLIC: '+RTRIM(SAIDA.Z22_USUARI)+' OBS: '+RTRIM(SAIDA.Z22_OBS)
		END,
		RTRIM(SD3010.D3_USUARIO)

Union ALL

	/* -- MOVIMENTOS POR TRANSFERÊNCIA EXTERNA - ENTRADA*/
	SELECT
		SD1010.D1_FILIAL AS 'FILIAL',
		SD1010.D1_LOCAL AS 'LOCAL',
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
		SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		CAST(SF1010.F1_DTDIGIT AS DATETIME) AS 'DT EMISSÃO',
		RTRIM(SD1010.D1_DOC)+'-'+SD1010.D1_SERIE AS 'DOCUMENTO',
		'NF REMESSA ENDICON' AS 'TIPO DOCUMENTO',
		SD1010.D1_TES AS 'TM/TES',
		SB1010.B1_GRUPO AS 'COD GRUPO',
		RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
		SD1010.D1_COD AS 'CODIGO',
		RTRIM(SD1010.D1_DESCRI) AS 'DESCRIÇÃO',
		SUM(SD1010.D1_QUANT) AS 'QUANTIDADE',
		SUM(SD1010.D1_TOTAL) AS 'VAL TOTAL',
		'ENTRADA - TRANSF. EXTERNA' AS 'TIPO DE MOVIMENTO',
		CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
		CASE WHEN SD1010.D1_SERIE='40' THEN 'TRANSF FILIAL PARA FILIAL' ELSE 'PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) END AS 'DETALHE',
		RTRIM(SC5010.C5_USUINL) AS 'USER MOV'
	FROM PROTHEUS.dbo.SD1010 SD1010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SD1010.D1_FILIAL+SD1010.D1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD1010.D1_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES AND SF4010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SA2010.A2_COD=SD1010.D1_FORNECE AND SD1010.D1_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*'
		--LINK COM GERAÇÃO DE PV PARA SAÍDA
		LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SD1010.D1_DOC=SC5010.C5_NOTA AND SD1010.D1_SERIE=SC5010.C5_SERIE AND SC5010.C5_FILIAL='02' AND SC5010.D_E_L_E_T_<>'*'
	WHERE
		(SD1010.D_E_L_E_T_<>'*') AND
		(SD1010.D1_FILIAL='09' AND (SD1010.D1_LOCAL IN ('63'))) AND
		(LEFT(SA2010.A2_CGC,8)='05061494') AND
		(
			(SF1010.F1_DTDIGIT>='20161201' AND SF1010.F1_DTDIGIT<='20181231') AND
			(
				((SF4010.F4_ESTOQUE='S') OR (SF4010.F4_CODIGO='103' OR SF4010.F4_CODIGO='140')) OR
				(SD1010.D1_CC='          ' AND SD1010.D1_TES='   ')
			)
		)
	GROUP BY
		SD1010.D1_FILIAL,
		SD1010.D1_LOCAL,
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
		SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
		SUBSTRING(SF1010.F1_DTDIGIT,5,2)+' - '+LEFT(SF1010.F1_DTDIGIT,4),
		SF1010.F1_DTDIGIT,
		RTRIM(SD1010.D1_DOC)+'-'+SD1010.D1_SERIE,
		SD1010.D1_TES,
		SB1010.B1_GRUPO,
		SBM010.BM_DESC,
		SD1010.D1_COD,
		SD1010.D1_DESCRI,
		SD1010.D1_CLVL,
		SF4010.F4_ESTOQUE,
		CASE WHEN SD1010.D1_SERIE='40' THEN 'TRANSF FILIAL PARA FILIAL' ELSE 'PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) END,
		RTRIM(SC5010.C5_USUINL)

UNION ALL

	/* -- MOVIMENTOS POR TRANSFERÊNCIA EXTERNA - SAÍDA*/
	SELECT
		SD2010.D2_FILIAL AS 'FILIAL',
		SD2010.D2_LOCAL AS 'LOCAL',
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
		SD2010.D2_FILIAL+SD2010.D2_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		CAST(SD2010.D2_EMISSAO AS DATETIME) AS 'DT EMISSÃO',
		RTRIM(SD2010.D2_DOC)+'-'+SD2010.D2_SERIE AS 'DOCUMENTO',
		'NF REMESSA ENDICON' AS 'TIPO DOCUMENTO',
		SD2010.D2_TES AS 'TM/TES',
		SB1010.B1_GRUPO AS 'COD GRUPO',
		RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
		SD2010.D2_COD AS 'CODIGO',
		RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
		CASE WHEN SD2010.D2_TIPO = 'D' THEN SUM(SD2010.D2_QUANT*-1) ELSE SUM(SD2010.D2_QUANT*-1) END AS 'QUANTIDADE',
		CASE WHEN SD2010.D2_TIPO = 'D' THEN SUM(SD2010.D2_TOTAL*-1) ELSE SUM(SD2010.D2_TOTAL*-1) END AS 'VAL TOTAL',
		CASE WHEN SD2010.D2_TIPO = 'D' THEN 'SAÍDA - DEVOLUÇÃO DE TRANSF. EXTERNA' ELSE 'SAÍDA - TRANSF. EXTERNA' END AS 'TIPO DE MOVIMENTO',
		CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
		CASE WHEN RTRIM(SD2010.D2_NFORI)<>'' THEN 'NF ORIGEM: '+RTRIM(SD2010.D2_NFORI)+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) WHEN SD2010.D2_SERIE='40' THEN 'TRANSF FILIAL PARA FILIAL' ELSE SD2010.D2_FILIAL+SD2010.D2_LOCAL+'->'+SC5010.C5_FILDEST+SC5010.C5_LOCDEST+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) END AS 'DETALHE',
		RTRIM(SC5010.C5_USUINL)  AS 'USER MOV'
	FROM PROTHEUS.dbo.SD2010 SD2010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER=(SD2010.D2_FILIAL+SD2010.D2_LOCAL) AND Z01010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD2010.D2_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD2010.D2_TES AND SF4010.D_E_L_E_T_ <> '*'
		--LINK COM GERAÇÃO DE PV PARA SAÍDA
		LEFT JOIN PROTHEUS.dbo.SC5010 SC5010 ON SC5010.C5_NOTA=SD2010.D2_DOC AND SD2010.D2_SERIE=SC5010.C5_SERIE AND SC5010.C5_FILIAL=SD2010.D2_FILIAL AND SC5010.D_E_L_E_T_<>'*'
	WHERE
		SD2010.D_E_L_E_T_<>'*' AND
		((SD2010.D2_EMISSAO>='20161201') AND (SD2010.D2_EMISSAO<='20181231')) AND
		SF4010.F4_ESTOQUE='S' AND
		SD2010.D2_FILIAL = '09' AND
		SD2010.D2_LOCAL IN ('63')
	GROUP BY
		SD2010.D2_FILIAL,
		SD2010.D2_LOCAL,
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
		SD2010.D2_FILIAL+SD2010.D2_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
		CAST(SD2010.D2_EMISSAO AS DATETIME),
		RTRIM(SD2010.D2_DOC)+'-'+SD2010.D2_SERIE,
		SD2010.D2_TES,
		SB1010.B1_GRUPO,
		SBM010.BM_DESC,
		SD2010.D2_COD,
		SB1010.B1_DESC,
		SD2010.D2_TIPO,
		SF4010.F4_ESTOQUE,
		CASE WHEN RTRIM(SD2010.D2_NFORI)<>'' THEN 'NF ORIGEM: '+RTRIM(SD2010.D2_NFORI)+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) WHEN SD2010.D2_SERIE='40' THEN 'TRANSF FILIAL PARA FILIAL' ELSE SD2010.D2_FILIAL+SD2010.D2_LOCAL+'->'+SC5010.C5_FILDEST+SC5010.C5_LOCDEST+' | PV: '+RTRIM(SC5010.C5_NUM) + ' | USER: ' + RTRIM(SC5010.C5_USUINL) + ' | OBS: ' + RTRIM(SC5010.C5_MENNOTA) END,
		RTRIM(SC5010.C5_USUINL)

Union ALL

	/* -- MOVIMENTOS SOLICITAÇÃO AO ARMAZÉM - SAÍDA */
	SELECT
		SD3010.D3_FILIAL AS 'FILIAL',
		SD3010.D3_LOCAL AS 'LOCAL',
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
		SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'DT EMISSÃO',
		SD3010.D3_DOC AS 'DOCUMENTO',
		'RM-BAIXA DE SA' AS 'TIPO DOCUMENTO',
		SD3010.D3_TM AS 'TM/TES',
		SB1010.B1_GRUPO AS 'COD GRUPO',
		RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
		SD3010.D3_COD AS 'COD',
		RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
		SUM(SD3010.D3_QUANT*-1) AS 'QUANTIDADE',
		SUM((SB1010.B1_UPRC*SD3010.D3_QUANT)*-1) AS 'VAL TOTAL', --VALORIZADO POR UPC, NÃO PEGA AS CORREÇÕES DE VALOR TOTAL
		CASE
			WHEN SD3010.D3_TM = '501' AND RTRIM(SD3010.D3_CLVL)='001' THEN 'SAÍDA - INVESTIMENTO/MOBILIZAÇÃO SA ENDICON'
			WHEN SD3010.D3_TM = '501' AND RTRIM(SD3010.D3_CLVL)<>'001' THEN 'SAÍDA - APLICAÇÃO SA ENDICON'
			WHEN SD3010.D3_TM = '502' THEN 'SAÍDA - APLICAÇÃO SA CLIENTE'
			WHEN SD3010.D3_TM = '503' THEN 'SAÍDA - AJUSTE DE ESTOQUE'
			WHEN SD3010.D3_TM = '505' THEN 'SAÍDA - APLICAÇÃO SA ATIVO'
			WHEN SD3010.D3_TM = '506' THEN 'SAÍDA - ERRO SA S/ESTOQUE'
			WHEN SD3010.D3_TM = '507' THEN 'SAÍDA - MAT RECONDICIONADO'
			ELSE 'ERRO - TM NOVA - SAÍDA'
		END AS 'TIPO DE MOVIMENTO',
		'SIM' AS 'ATUALIZOU ESTOQUE?',
		--DADOS DE DETALHE SOBRE MOVIMENTO
		'SA: '+RTRIM(SCQ010.CQ_NUM)+' | SOLIC: '+RTRIM(SCP010.CP_SOLICIT)+' | OBS: '+RTRIM(SCP010.CP_OBS)+' | MAT: '+ CASE WHEN SCP010.CP_FORNECE='      ' THEN '' ELSE RTRIM(SCP010.CP_FORNECE)+'-'+RTRIM(SA2010.A2_NOME) END AS 'DETALHE',
		RTRIM(SD3010.D3_USUARIO)  AS 'USER MOV'
	FROM PROTHEUS.dbo.SD3010 SD3010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
		--DADOS DE SA
		LEFT JOIN PROTHEUS.dbo.SCQ010 SCQ010 ON SD3010.D3_NUMSEQ=SCQ010.CQ_NUMREQ AND SCQ010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SCP010 SCP010 ON SCP010.CP_NUM+SCP010.CP_ITEM=SCQ010.CQ_NUM+SCQ010.CQ_ITEM AND SCP010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SCP010.CP_FORNECE AND SA2010.D_E_L_E_T_ <> '*'
	WHERE
		(SD3010.D_E_L_E_T_<>'*') AND
		(LEFT(SD3010.D3_CF,2) = 'RE') AND
		(SD3010.D3_ESTORNO='') AND
		--(SD3010.D3_DOC NOT LIKE '%INVENT%') AND
		(SD3010.D3_TM<>'999') AND
		((SD3010.D3_EMISSAO>='20161201') AND (SD3010.D3_EMISSAO<='20181231')) AND
		SD3010.D3_FILIAL = '09' AND
		SD3010.D3_LOCAL IN ('63')
	GROUP BY
		SD3010.D3_FILIAL,
		SD3010.D3_LOCAL,
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
		SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
		CAST(SD3010.D3_EMISSAO AS DATETIME),
		SD3010.D3_DOC,
		SD3010.D3_TM,
		SB1010.B1_GRUPO,
		SBM010.BM_DESC,
		SD3010.D3_COD,
		SB1010.B1_DESC,
		SD3010.D3_TM,
		SD3010.D3_CLVL,
		--COMPLEMENTO DE GROUP BY
		SD3010.D3_EMISSAO,
		'SA: '+RTRIM(SCQ010.CQ_NUM)+' | SOLIC: '+RTRIM(SCP010.CP_SOLICIT)+' | OBS: '+RTRIM(SCP010.CP_OBS)+' | MAT: '+ CASE WHEN SCP010.CP_FORNECE='      ' THEN '' ELSE RTRIM(SCP010.CP_FORNECE)+'-'+RTRIM(SA2010.A2_NOME) END,
		RTRIM(SD3010.D3_USUARIO)

Union ALL

	/* -- MOVIMENTOS SOLICITAÇÃO AO ARMAZÉM - ENTRADA */
	SELECT
		SD3010.D3_FILIAL AS 'FILIAL',
		SD3010.D3_LOCAL AS 'LOCAL',
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
		SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC) AS 'DESCRIÇÃO ARMAZÉM',
		CAST(SD3010.D3_EMISSAO AS DATETIME) AS 'DT EMISSÃO',
		SD3010.D3_DOC AS 'DOCUMENTO',
		'RM-DEVOLUÇÃO AO ARMAZÉM' AS 'TIPO DOCUMENTO',
		SD3010.D3_TM AS 'TM/TES',
		SB1010.B1_GRUPO AS 'COD GRUPO',
		RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
		SD3010.D3_COD AS 'COD',
		RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
		SUM(SD3010.D3_QUANT) AS 'QUANTIDADE',
		SUM((SB1010.B1_UPRC*SD3010.D3_QUANT)) AS 'VAL TOTAL', --VALORIZADO POR UPC, NÃO PEGA AS CORREÇÕES DE VALOR TOTAL
		CASE
			WHEN SD3010.D3_TM = '001' AND RTRIM(SD3010.D3_CLVL)='001' THEN 'ENTRADA - DEVOLUÇÃO INVESTIMENTO/MOBILIZAÇÃO SA ENDICON'
			WHEN SD3010.D3_TM = '001' AND RTRIM(SD3010.D3_CLVL)<>'001' THEN 'ENTRADA - DEVOLUÇÃO APLICAÇÃO SA ENDICON'
			WHEN SD3010.D3_TM = '002' THEN 'ENTRADA - DEVOLUÇÃO SA CLIENTE'
			WHEN SD3010.D3_TM = '003' THEN 'ENTRADA - AJUSTE DE ESTOQUE'
			WHEN SD3010.D3_TM = '005' THEN 'ENTRADA - DEVOLUÇÃO SA ATIVO'
			WHEN SD3010.D3_TM = '006' THEN 'ENTRADA - SEM APLICAÇÃO'
			WHEN SD3010.D3_TM = '007' THEN 'ENTRADA - MAT RECONDICIONADO'
			ELSE 'ERRO - TM NOVA - ENTRADA'
		END AS 'TIPO DE MOVIMENTO',
		'SIM' AS 'ATUALIZOU ESTOQUE?',
		'USER: '+RTRIM(SD3010.D3_USUARIO)+' | CC: '+RTRIM(SD3010.D3_CC)+'-'+RTRIM(CTT010.CTT_DESC01)+' | OBS: '+RTRIM(SD3010.D3_MEMO) AS 'DETALHE',
		RTRIM(SD3010.D3_USUARIO)  AS 'USER MOV'
	FROM PROTHEUS.dbo.SD3010 SD3010
		LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON SD3010.D3_LOCAL=Z01010.Z01_COD AND SD3010.D3_FILIAL=Z01010.Z01_FILIAL AND Z01010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD3010.D3_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SD3010.D3_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_ <> '*'
		LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SD3010.D3_CC=CTT010.CTT_CUSTO AND CTT010.D_E_L_E_T_ <> '*'
	WHERE
		(SD3010.D_E_L_E_T_<>'*') AND
		(LEFT(SD3010.D3_CF,2) = 'DE') AND
		(SD3010.D3_ESTORNO='') AND
		--(SD3010.D3_DOC NOT LIKE '%INVENT%') AND
		(SD3010.D3_TM<>'499') AND
		((SD3010.D3_EMISSAO>='20161201') AND (SD3010.D3_EMISSAO<='20181231')) AND
		SD3010.D3_FILIAL = '09' AND
		SD3010.D3_LOCAL IN ('63')
	GROUP BY 
		SD3010.D3_FILIAL,
		SD3010.D3_LOCAL,
		CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END,
		CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END,
		SD3010.D3_FILIAL+SD3010.D3_LOCAL+'-'+RTRIM(Z01010.Z01_DESC),
		CAST(SD3010.D3_EMISSAO AS DATETIME),
		SD3010.D3_DOC,
		SD3010.D3_TM,
		SB1010.B1_GRUPO,
		SBM010.BM_DESC,
		SD3010.D3_COD,
		SB1010.B1_DESC,
		SD3010.D3_TM,
		SD3010.D3_CLVL,
		'USER: '+RTRIM(SD3010.D3_USUARIO)+' | CC: '+RTRIM(SD3010.D3_CC)+'-'+RTRIM(CTT010.CTT_DESC01)+' | OBS: '+RTRIM(SD3010.D3_MEMO),
		RTRIM(SD3010.D3_USUARIO)