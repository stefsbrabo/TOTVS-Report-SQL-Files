SELECT
	SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+Z01010.Z01_DESC AS 'DESCRIÇÃO ARMAZÉM',
	CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',
	SD1010.D1_DOC AS 'DOCUMENTO',
	SD1010.D1_ITEM AS 'ITEM',
	SD1010.D1_COD AS 'CODIGO',
	SD1010.D1_DESCRI AS 'DESCRIÇÃO',
	SD1010.D1_UM AS 'UND',
	SD1010.D1_QUANT AS 'QTDE DOC',
	SD1010.D1_PEDIDO AS 'NUM PEDIDO',
	SD1010.D1_ITEMPC AS 'ITEM PEDIDO',

	SC7010.C7_NUMSC AS 'NUM SC',
	SC7010.C7_ITEMSC AS 'ITEM SC',
	SC7010.C7_OBS AS 'OBSERVAÇÃO',

	SD1010.D1_QTDPEDI AS 'QTDE PEDIDO',
	SD1010.D1_FORNECE AS 'FORNECEDOR',
	CASE WHEN SD1010.D1_FORNECE = '      ' THEN '' ELSE RTRIM(SA2010.A2_NOME)  END AS 'NOME FORNECEDOR',

	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',

	Case RTrim(Coalesce(SC1010.C1_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(DATETIME, SC1010.C1_EMISSAO, 112) END AS 'EMISSÃO SC',

  CONVERT(DATETIME,(
    SELECT MAX(LastUpdateDate)
      FROM (VALUES (SC1010.C1_DTLIB1),(SC1010.C1_DTLIB2),(SC1010.C1_DTLIB3),(SC1010.C1_DTLIB4),(SC1010.C1_DTLIB5),(SC1010.C1_DTLIB6),(SC1010.C1_DTLIB7), (SC1010.C1_EMISSAO), (SC1010.C1_ALTDATA)) AS UpdateDate(LastUpdateDate)
  ), 112) AS 'DT APROVAÇÃO',

	Case RTrim(Coalesce(SF1010.F1_RECBMTO,'')) WHEN ''  THEN Null ELSE convert(DATETIME,SF1010.F1_RECBMTO, 112) END AS 'DT RECEBIMENTO',

  DATEDIFF(DAY,
           CONVERT(DATETIME, (SELECT MAX(LastUpdateDate)
                          FROM (VALUES (SC1010.C1_DTLIB1), (SC1010.C1_DTLIB2), (SC1010.C1_DTLIB3), (SC1010.C1_DTLIB4),
                            (SC1010.C1_DTLIB5), (SC1010.C1_DTLIB6), (SC1010.C1_DTLIB7), (SC1010.C1_EMISSAO),
                            (SC1010.C1_ALTDATA)) AS UpdateDate(LastUpdateDate))),
          CONVERT(DATETIME, SF1010.F1_RECBMTO, 112)
  ) AS 'LEADTIME',



	SF1010.F1_NMUSER AS 'USUÁRIO INCLUIU PRENOTA'

FROM PROTHEUS.dbo.SD1010 SD1010
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SD1010.D1_FILIAL+SD1010.D1_LOCAL) AND Z01010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SD1010.D1_CONTA=CT1010.CT1_CONTA AND CT1010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SD1010.D1_FORNECE=SA2010.A2_COD AND SD1010.D1_LOJA=SA2010.A2_LOJA AND SA2010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA AND SF1010.D_E_L_E_T_ <> '*'
	LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES AND SF4010.D_E_L_E_T_ <> '*'
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD1010.D1_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_<>'*'
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO AND SBM010.D_E_L_E_T_<>'*'

	LEFT JOIN PROTHEUS.dbo.SC7010 SC7010 ON (SD1010.D1_PEDIDO=SC7010.C7_NUM AND SD1010.D1_ITEMPC=SC7010.C7_ITEM) AND SC7010.D_E_L_E_T_ <>'*'
	LEFT JOIN PROTHEUS.dbo.SC1010 SC1010 ON (SC7010.C7_NUMSC=SC1010.C1_NUM AND SC7010.C7_ITEMSC=SC1010.C1_ITEM) AND SC1010.D_E_L_E_T_<>'*'

WHERE
	(SD1010.D1_CC = '         ') AND -- para estoque
	(SD1010.D_E_L_E_T_<>'*') AND -- retira excluído excluído
	(SF4010.F4_ESTOQUE = 'S') AND
	(SD1010.D1_QUANT<>'0') AND --retira complemento de preço de frete
	(
		(SF4010.F4_TEXTO NOT LIKE '%*%') AND -- retira importação 1
		(SF1010.F1_ESPECIE <> 'SPE  ' OR SF1010.F1_ESPECIE <> 'SPE') AND -- retira importação 2
		(SF1010.F1_ESPECIE NOT LIKE 'NFE') -- retira importação 3
	) AND
	(
		LEFT(SA2010.A2_CGC,8)<>'05061494' AND -- ENDICON
		SA2010.A2_CGC<>'07047251000170' -- COELCE
	) AND -- RETIRA TRANSFERÊNCIA E ARMAZÉM CLIENTE

	(SF1010.F1_RECBMTO>='20170101' AND SF1010.F1_RECBMTO<='20181231') AND -- fixa período

	(SD1010.D1_GRUPO NOT IN ('4005','4004','4006','4009','4010','0176','4007','0176','0171')) AND -- retira grupo
	(SD1010.D1_COD NOT IN ('00525957','00526672','00528766','01320532','01321108','02500159','02520001','02550387','02570001','40030015','40030018','40030019','40070086','40070065','01730062','02550337','02550286')) --AND -- retira produto
	--(SD1010.D1_TES NOT IN ('417','451')) AND --retira TES de transf e cliente

  (
    CONVERT(DATETIME, (SELECT MAX(LastUpdateDate)
                          FROM (VALUES (SC1010.C1_DTLIB1), (SC1010.C1_DTLIB2), (SC1010.C1_DTLIB3), (SC1010.C1_DTLIB4),
                            (SC1010.C1_DTLIB5), (SC1010.C1_DTLIB6), (SC1010.C1_DTLIB7), (SC1010.C1_EMISSAO),
                            (SC1010.C1_ALTDATA)) AS UpdateDate(LastUpdateDate)))
  ) IS NOT NULL --LEADTIMES VÁLIDOS



