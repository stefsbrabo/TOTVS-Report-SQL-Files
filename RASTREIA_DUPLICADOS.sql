SELECT
	Z01010.Z01_CODGER+' - '+Z01010.Z01_DESC AS 'CÓDIGO GERAL - DESCRIÇÃO ARMAZÉM',
	RTRIM(SB2010.B2_COD) AS 'COD PRODUTO',
	RTRIM(SB1010.B1_DESC) AS 'DESCRIÇÃO',
	SB2010.B2_QATU AS 'SALDO',
	SB2010.B2_CM1 AS 'CUSTO SYS',
	SB2010.B2_VATU1 AS 'VALOR SYS',
	SB1010.B1_UPRC AS 'CUSTO UPC',
	SB1010.B1_UPRC*SB2010.B2_QATU AS 'VALOR UPC',

	CASE
		WHEN
			(
				SELECT SUM(SC7010.C7_QUJE)
				FROM PROTHEUS.dbo.SC7010 SC7010
				WHERE
					(SC7010.D_E_L_E_T_<>'*') AND
					(SC7010.C7_CONAPRO='L') AND
					((SC7010.C7_QUJE+SC7010.C7_QTDACLA)>0) AND
					(SC7010.C7_RESIDUO<>'S') AND
					(SB1010.B1_COD=SC7010.C7_PRODUTO) AND
					(SC7010.C7_CC = '         ') AND
					(SC7010.C7_EMISSAO>='20170101')  --SOMENTE APÓS 2017
			)>0
			THEN 'SIM'
		ELSE 'NÃO'
	END AS 'ESTOCÁVEL?',

	--PRE-NOTA PENDENTE DE CLASSIFICAÇÃO
	(
		SELECT SUM(SD1010.D1_QUANT)
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SD1010.D1_FORNECE
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
		WHERE (LEFT(SA2010.A2_CGC,8)<>'05061494') AND SD1010.D1_FILIAL=SB2010.B2_FILIAL AND  SD1010.D1_LOCAL=SB2010.B2_LOCAL AND SD1010.D1_COD=SB2010.B2_COD AND SD1010.D1_CC='          ' AND SD1010.D1_TES='   ' AND SF1010.F1_DTDIGIT>='20171001' AND SD1010.D_E_L_E_T_<>'*'
	) AS 'QTDE PRE-NOTA',

	--TRANSFERÊNCIA EXTERNA PENDENTE DE CLASSIFICAÇÃO
	(
		SELECT SUM(SD1010.D1_QUANT)
		FROM PROTHEUS.dbo.SD1010 SD1010
			LEFT JOIN PROTHEUS.dbo.SA2010 SA2010 ON  SA2010.A2_COD=SD1010.D1_FORNECE
			LEFT JOIN PROTHEUS.dbo.SF1010 SF1010 ON SD1010.D1_DOC=SF1010.F1_DOC AND SD1010.D1_SERIE=SF1010.F1_SERIE AND SD1010.D1_FORNECE=SF1010.F1_FORNECE AND SD1010.D1_LOJA=SF1010.F1_LOJA
		WHERE (LEFT(SA2010.A2_CGC,8)='05061494') AND SD1010.D1_FILIAL=SB2010.B2_FILIAL AND  SD1010.D1_LOCAL=SB2010.B2_LOCAL AND SD1010.D1_COD=SB2010.B2_COD AND SD1010.D1_CC='          ' AND SD1010.D1_TES='   ' AND SF1010.F1_DTDIGIT>='20171001' AND SD1010.D_E_L_E_T_<>'*'
	) AS 'QTDE PRE-NOTA',

	--TRANSFERENCIA INTERNA PENDENTE DE APROVAÇÃO
	(
		SELECT
			SUM(Z22010.Z22_QUANT)
		FROM PROTHEUS.dbo.Z22010 Z22010
		WHERE
			(Z22010.D_E_L_E_T_<>'*') AND
			(Z22010.Z22_FILIAL+Z22010.Z22_ALMORI=Z01010.Z01_CODGER) AND
			(Z22010.Z22_PRDORI = SB2010.B2_COD) AND
			(Z22010.Z22_APROV = 'B')
	) AS 'ENTRADA TRANSF',

	--PENDÊNCIA DE COMPRA - SC
	(
		SELECT
			SUM(SC1010.C1_QUANT-SC1010.C1_QUJE)
		FROM PROTHEUS.dbo.SC1010 SC1010
		WHERE
			(SC1010.D_E_L_E_T_<>'*') AND
			(SC1010.C1_RESIDUO= ' ') AND
			(SC1010.C1_FILIAL+SC1010.C1_LOCAL = Z01010.Z01_CODGER) AND
			(SC1010.C1_PRODUTO = SB2010.B2_COD) AND
			(SC1010.C1_QUANT-SC1010.C1_QUJE > 0) AND
			(SC1010.C1_APROV <> 'R') AND
			(SC1010.C1_EMISSAO>='20171001')
	) AS 'QTDE EM SC',

	--COMPRAS PENDENTES DE CHEGADA - PC
	(
  SELECT
    SUM(SC7010.C7_QUANT-SC7010.C7_QUJE)
  FROM PROTHEUS.dbo.SC7010 SC7010
  WHERE
   	(SC7010.D_E_L_E_T_<>'*') AND
    (SC7010.C7_RESIDUO <> 'S') AND
    (SC7010.C7_FILIAL+SC7010.C7_LOCAL = Z01010.Z01_CODGER) AND
    (SC7010.C7_PRODUTO = SB2010.B2_COD) AND
    (SC7010.C7_QUANT-SC7010.C7_QUJE > 0) AND
    (SC7010.C7_ENCER <> 'E') AND
		(SC7010.C7_EMISSAO>='20171001')
	) AS 'QTDE EM PC',

  --PENDENCIA DE SAÍDA DE ARMAZÉM - SA

	--S.A. BLOQUEADA
	(
		SELECT
			SUM(SCP010.CP_QUANT)
		FROM PROTHEUS.dbo.SCP010 SCP010
		WHERE
			(SCP010.D_E_L_E_T_<>'*') AND
			(SCP010.CP_FILIAL+SCP010.CP_LOCAL = Z01010.Z01_CODGER) AND
			(SCP010.CP_PRODUTO = SB2010.B2_COD) AND
			(SCP010.CP_PREREQU= ' ') AND
			(SCP010.CP_QUJE= 0) AND
			(SCP010.CP_STATUS= ' ') AND
			(SCP010.CP_STATSA= 'B') AND
			(SCP010.CP_EMISSAO>='20180101') --TRÊS MESES DE CORTE
		) AS 'S.A. BLOQUEADA',

	--S.A. APROVADA PENDENTE PRÉ-REQUISIÇÃO
	(
		SELECT
			SUM(SCP010.CP_QUANT)
		FROM PROTHEUS.dbo.SCP010 SCP010
		WHERE
			(SCP010.D_E_L_E_T_<>'*') AND
			(SCP010.CP_FILIAL+SCP010.CP_LOCAL = Z01010.Z01_CODGER) AND
			(SCP010.CP_PRODUTO = SB2010.B2_COD) AND
			(SCP010.CP_PREREQU= ' ') AND
			(SCP010.CP_QUJE= 0) AND
			(SCP010.CP_STATUS= ' ') AND
			(SCP010.CP_STATSA= 'L') AND
			(SCP010.CP_EMISSAO>='20180101') --TRÊS MESES DE CORTE
	) AS 'S.A. PEND DE PRÉ-REQ',

	--S.A. COM PRE-REQUISIÇÃO PENDENTE DE BAIXA
  (
	SELECT
		SUM(SCP010.CP_QUANT-SCP010.CP_QUJE)
	FROM PROTHEUS.dbo.SCP010 SCP010
	WHERE
		(SCP010.D_E_L_E_T_<>'*') AND
		(SCP010.CP_FILIAL+SCP010.CP_LOCAL = Z01010.Z01_CODGER) AND
		(SCP010.CP_PRODUTO = SB2010.B2_COD) AND
		(SCP010.CP_PREREQU='S') AND
		(SCP010.CP_STATUS=' ') AND
		(SCP010.CP_STATSA='L') AND
		(SCP010.CP_QUANT-SCP010.CP_QUJE)>0 AND
		(SCP010.CP_EMISSAO>='20180101')
	) AS 'S.A. PEND DE BAIXA',

	Case RTrim(Coalesce(SB2010.B2_USAI,'')) WHEN ''  THEN Null ELSE convert(datetime,SB2010.B2_USAI, 112)END AS 'DT ULT SAÍDA',
	Case RTrim(Coalesce(SB2010.B2_DINVENT,'')) WHEN ''  THEN Null ELSE convert(datetime,SB2010.B2_DINVENT, 112)END AS 'DT INVENT',

	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO'

FROM PROTHEUS.dbo.SB1010 SB1010
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SB2010.B2_FILIAL+SB2010.B2_LOCAL)
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SB2010.B2_COD=SB1010.B1_COD AND SB1010.D_E_L_E_T_ <> '*'
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO

WHERE
	--(SB2010.B2_QATU<>0) AND --TIRA ITENS COM SALDO ZERO
	(Z01010.Z01_MSBLQL = 2) AND --SOMENTE DESBLOQUEADOS
	(SB2010.D_E_L_E_T_<>'*') AND --TIRA DELETADOS
	(Z01010.Z01_TME = '001') AND --SOMENTE ARMAZÉNS ENDICON
	(SB2010.B2_COD IN ('00140027','00520261','00520370','00520383','00520519','00521221','00521386','00522958','00524226','00524233','00524234','00524343','00524404','00524442','00524468','00524530','00524596','00524639','00524736','00524739','00524900','00524989','00525007','00525008','00525027','00525044','00525065','00525091','00525139','00525150','00525156','00525177','00525183','00525196','00525201','00525258','00525329','00525350','00525540','00525556','00525591','00525721','00525766','00527180','00527294','00527948','00528302','00528404','00528507','00528509','00530002','00530033','00530041','01300028','01300081','01300148','01300150','01300162','01300209','01300262','01300381','01310076','01310077','01310078','01310079','01310144','01310174','01310246','01310247','01310272','01310273','01310302','01310305','01310307','01310309','01310318','01310321','01310322','01310323','01310366','01310395','01310411','01310415','01310435','01310436','01310437','01310438','01310439','01310440','01310441','01310442','01310443','01310444','01310469','01310500','01310520','01310554','01320050','01320061','01320217','01320314','01320335','01320361','01320394','01320413','01320447','01320564','01320578','01320917','01320972','01321236','01321237','01330012','01330014','01330054','01330055','01330056','01330065','01330093','01330094','01330106','01330198','01330201','01330203','01330204','01330205','01330218','01330264','01330271','01330272','01330283','01330284','01330285','01700002','01720260','01720359','01730057','01730077','01730223','01731133','01731265','01731310','01731345','01750021','01760039','01770021','02230050','02230055','02290016','02500117','02500126','02500143','02500396','02500662','02500700','02500737','02500790','02500793','02501012','02501072','02502426','02502428','02502458','02502628','02502713','02502794','02502881','02502951','02503151','02503174','02503367','02503400','02503467','02503503','02503569','02503595','02503603','02503641','02503711','02503748','02510129','02510139','02510363','02510385','02510395','02510505','02510652','02510713','02510746','02510776','02510782','02510796','02510817','02510830','02530004','02550137','02550140','02550143','02550157','02550169','02550184','02550266','02550311','02550366','02550426','02550446','02550573','02560038','02560053','02560065','02560154','02560174','02560292','02560295','02560296','02560297','02560300','02560384','02560394','02560397','02560409','02560433','02560475','02560566','02560627','02560630','02566038','07120005','40070012','40070014'))