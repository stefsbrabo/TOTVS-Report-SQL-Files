WITH NFS AS
(
	SELECT
		SD1010.D1_DOC AS 'DOCUMENTO',
		SD1010.D1_SERIE AS 'SERIE',
		SD1010.D1_FORNECE AS 'FORNECE',
		SD1010.D1_LOJA AS 'LOJA',
		COUNT(DISTINCT SD1010.D1_FILIAL+SD1010.D1_LOCAL) AS 'REPETICOES'
	FROM PROTHEUS.dbo.SD1010 SD1010
		LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES AND SF4010.D_E_L_E_T_<>'*'
		LEFT JOIN PROTHEUS.dbo.SC7010 SC7010 ON SD1010.D1_PEDIDO=SC7010.C7_NUM AND SD1010.D1_ITEMPC=SC7010.C7_ITEM AND SC7010.D_E_L_E_T_<>'*'
	WHERE
		(SD1010.D1_CC='          ') AND
		(SD1010.D_E_L_E_T_<>'*') AND
		(SF1010.F1_DTDIGIT>=DATEADD(DAY,-730,GETDATE()) AND SF1010.F1_DTDIGIT<=GETDATE()) AND

		(
			(SD1010.D1_FILIAL <> SC7010.C7_FILIAL AND SD1010.D1_LOCAL <> SC7010.C7_LOCAL) OR
			(SD1010.D1_FILIAL = SC7010.C7_FILIAL AND SD1010.D1_LOCAL <> SC7010.C7_LOCAL) OR
			(SD1010.D1_FILIAL <> SC7010.C7_FILIAL AND SD1010.D1_LOCAL = SC7010.C7_LOCAL)
		) AND
	
		(
			(SF4010.F4_TEXTO NOT LIKE '%*%') AND -- retira importação 1
			(SF1010.F1_ESPECIE <> 'SPE  ' OR SF1010.F1_ESPECIE <> 'SPE') AND -- retira importação 2
			(SF1010.F1_ESPECIE NOT LIKE 'NFE') -- retira importação 3
		)
	GROUP BY
		SD1010.D1_DOC,
		SD1010.D1_SERIE,
		SD1010.D1_FORNECE,
		SD1010.D1_LOJA
	HAVING
		COUNT(DISTINCT SD1010.D1_FILIAL+SD1010.D1_LOCAL) > 1
)
SELECT 
	* 
FROM NFS