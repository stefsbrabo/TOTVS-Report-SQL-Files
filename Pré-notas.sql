SELECT
	
	SD1010.D1_FILIAL AS 'FILIAL',
	SD1010.D1_LOCAL AS 'LOCAL',
	SD1010.D1_FILIAL+SD1010.D1_LOCAL+'-'+Z01010.Z01_DESC AS 'DESCRIÇÃO ARMAZÉM',
	SD1010.D1_TES AS 'TES', 
	SF4010.F4_TEXTO AS 'DESCRIÇÃO TES',
	SD1010.D1_CC AS 'CENTRO DE CUSTO',
	CASE WHEN SF4010.F4_ESTOQUE = 'S' THEN 'SIM' ELSE 'NÃO' END AS 'ATUALIZOU ESTOQUE?',	
	SF4010.F4_ESTOQUE AS 'PN-ATU. ESTOQUE',
	SF4010.F4_ATUATF AS 'PN-ATU. ATIVO',
	SF4010.F4_CF AS 'CFOP',
	SX5010.X5_DESCRI AS 'DESCRIÇÃO CFOP',
	SD1010.D1_DOC AS 'DOCUMENTO',
	SD1010.D1_ITEM AS 'ITEM',
	SD1010.D1_COD AS 'CODIGO',
	SD1010.D1_DESCRI AS 'DESCRIÇÃO',
	SD1010.D1_UM AS 'UND',
	SD1010.D1_QUANT AS 'QTDE DOC',
	SD1010.D1_VUNIT	AS 'VAL UND',
	SD1010.D1_TOTAL AS 'VAL TOTAL',
	CASE WHEN SD1010.D1_TES = '   ' THEN 'NÃO CLASSIFICADA' ELSE 'CLASSIFICADA' END AS 'CLASSIFICAÇÃO',	
	SF1010.F1_NMCLASS AS 'USUÁRIO CLASSIFICOU',
	SD1010.D1_CONTA AS 'CONTA CONTÁBIL',
	CASE WHEN SD1010.D1_CONTA = '                    ' THEN 'ATIVO FIXO' ELSE RTRIM(CT1010.CT1_DESC01) END AS 'DESC CONT CONTÁBIL',
	CASE WHEN SD1010.D1_CC = '         ' THEN 'PROCESSO PARA ARMAZÉM' ELSE RTRIM(CTT010.CTT_DESC01) END AS 'DESCRIÇÃO CENTRO DE CUSTO', 
	SD1010.D1_PEDIDO AS 'NUM PEDIDO',
	SD1010.D1_ITEMPC AS 'ITEM PEDIDO',
	SC7010.C7_NUMSC AS 'NUM SC',
	SC7010.C7_ITEMSC AS 'ITEM SC', 
	SC1010.C1_SOLICIT AS 'NOME SOLICITANTE SC',  
	SD1010.D1_QTDPEDI AS 'QTDE PEDIDO',
	SD1010.D1_FORNECE AS 'FORNECEDOR',
	CASE WHEN SD1010.D1_FORNECE = '      ' THEN '' ELSE RTRIM(SA2010.A2_NOME)  END AS 'NOME FORNECEDOR',
	SA2010.A2_TIPO AS 'PESSOA JUR\FIS',
	SA2010.A2_CGC AS 'CNPJ\CPF',
	
	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',
	
	Case RTrim(Coalesce(SD1010.D1_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime,SD1010.D1_EMISSAO, 112)END AS 'DT EMISSÃO', --DT EMISSÃO DA NF
	Case RTrim(Coalesce(SF1010.F1_DTDIGIT,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTDIGIT, 112)END AS 'DT DIGITAÇÃO', --DT EM QUE OCORREU A CLASSIFICAÇÃO
	Case RTrim(Coalesce(SF1010.F1_DTINCL,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTINCL, 112)END AS 'DT INCLUSÃO',
	Case RTrim(Coalesce(SF1010.F1_DTLANC,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_DTLANC, 112)END AS 'DT CLASSIFICAÇÃO',  --DT DA CONTABILIZAÇÃO
	Case RTrim(Coalesce(SF1010.F1_RECBMTO,'')) WHEN ''  THEN Null ELSE convert(datetime,SF1010.F1_RECBMTO, 112)END AS 'DT RECEBIMENTO', --DT EM QUE O MATERIAL FOI RECEBIDO
	
	SD1010.D1_CLVL AS 'COD DE OBRA',
	RTRIM(SD1010.D1_CLVL+' - '+CTH010.CTH_DESC01) AS 'DESC OBRA/PROJETO',
	SD1010.D1_SERIE AS 'SERIE',
	SD1010.D1_LOJA  AS 'LOJA',
	SF1010.F1_NMUSER AS 'USUÁRIO INCLUIU PRENOTA',
	CASE WHEN Z01010.Z01_MSBLQL = 1 THEN 'Bloqueado' WHEN Z01010.Z01_MSBLQL = 2 THEN 'Desbloqueado' ELSE 'ERRO' END AS 'SITUAÇÃO',
	CASE WHEN Z01010.Z01_TME = '001' THEN 'Endicon' WHEN Z01010.Z01_TME = '002' THEN 'Cliente' ELSE 'ERRO' END AS 'TIPO',
	CASE WHEN Z01010.Z01_INVET = 1 THEN 'Sim' WHEN Z01010.Z01_INVET = 2 THEN 'Não' ELSE 'ERRO' END AS 'INVENTARIADO?',
	CASE WHEN Z01010.Z01_OBRA = 'N' THEN 'Não' WHEN Z01010.Z01_OBRA = 'S' THEN 'Sim' ELSE 'ERRO' END AS 'OBRIGA OBRA?',
	SD1010.D1_NFORI AS 'NF ORIGEM', 
	SF1010.F1_LOGNF AS 'HISTORICO NF',
	SF1010.F1_OBS AS 'OBS. PRE-NOTA', 
	SF1010.F1_MOTRET AS 'MOT. RETORNO', 
	SF1010.F1_OBSCLA AS 'OBS. CLASSIF',

	CASE
		WHEN (SD1010.D1_CC<>'          ' AND SF4010.F4_ESTOQUE = 'S')
			THEN 'COMPRA: AP DIRETA/ESTOQUE: SIM'
		WHEN (SD1010.D1_CC='          ' AND SF4010.F4_ESTOQUE <> 'S')
			THEN 'COMPRA: ESTOQUE/ESTOQUE: NÃO'
		ELSE 'ERRO'
	END AS 'TIPO PROCESSO',

	SC1010.C1_OBS AS 'OBSERVAÇÃO',
	SC1010.C1_SOLICIT AS 'NOME SOLICITANTE SC',
	CASE WHEN SC1010.C1_TPCOMPR='2' THEN 'APLICAÇÃO DIRETA' WHEN SC1010.C1_TPCOMPR='1' THEN 'ESTOQUE' END AS 'TIPO DE COMPRA ',
	SF1010.F1_ESPECIE AS 'ESPEC. DOC'
	
FROM PROTHEUS.dbo.SD1010 SD1010
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SD1010.D1_FILIAL+SD1010.D1_LOCAL)
	LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SD1010.D1_CONTA=CT1010.CT1_CONTA
	LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SD1010.D1_CC=CTT010.CTT_CUSTO
	LEFT JOIN PROTHEUS.dbo.CTH010 CTH010 ON SD1010.D1_CLVL=CTH010.CTH_CLVL
	LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON SD1010.D1_FORNECE=SA2010.A2_COD AND SD1010.D1_LOJA=SA2010.A2_LOJA
	LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
	LEFT JOIN PROTHEUS.dbo.SF4010 SF4010 ON SF4010.F4_CODIGO=SD1010.D1_TES
	LEFT JOIN PROTHEUS.dbo.SX5010 SX5010 ON SX5010.X5_TABELA='13' AND SX5010.X5_CHAVE=SF4010.F4_CF
	LEFT JOIN PROTHEUS.dbo.SC7010 SC7010 ON (SD1010.D1_PEDIDO=SC7010.C7_NUM AND SD1010.D1_ITEMPC=SC7010.C7_ITEM)
	LEFT JOIN PROTHEUS.dbo.SC1010 SC1010 ON (SC7010.C7_NUMSC=SC1010.C1_NUM AND SC7010.C7_ITEMSC=SC1010.C1_ITEM)
	
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SD1010.D1_COD=SB1010.B1_COD
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO
	
WHERE
	(
		(SD1010.D1_CC<>'          ' AND SF4010.F4_ESTOQUE = 'S') OR
		(SD1010.D1_CC='          ' AND SF4010.F4_ESTOQUE <> 'S')
	) AND
	(SD1010.D_E_L_E_T_<>'*') AND
	(
		SF1010.F1_DTDIGIT>=DATEADD(DAY,-730,GETDATE()) AND SF1010.F1_DTDIGIT<=GETDATE()
	) AND

	(
		(SF4010.F4_TEXTO NOT LIKE '%*%') AND -- retira importação 1
		(SF1010.F1_ESPECIE <> 'SPE  ' OR SF1010.F1_ESPECIE <> 'SPE') AND -- retira importação 2
		(SF1010.F1_ESPECIE NOT LIKE 'NFE') -- retira importação 3
	)