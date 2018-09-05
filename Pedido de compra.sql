SELECT
	SC7010.C7_FILIAL+SC7010.C7_LOCAL+' - '+Z01010.Z01_DESC AS 'DESCRIÇÃO ARMAZÉM',
	SC7010.C7_NUM AS 'NUM PC',
	SC7010.C7_ITEM AS 'ITEM',
	SC7010.C7_PRODUTO AS 'CODIGO',
	RTRIM(SC7010.C7_DESCRI) AS 'DESCRIÇÃO',
	SC7010.C7_UM AS 'UND',
	SC7010.C7_QUANT AS 'QTDE',
	SC7010.C7_PRECO AS 'VAL UND',
	SC7010.C7_TOTAL AS 'TOTAL',
	
	SC7010.C7_QUJE+SC7010.C7_QTDACLA AS 'QUANTIDADE RECEBIDA',
	(SC7010.C7_QUJE+SC7010.C7_QTDACLA)*SC7010.C7_PRECO AS 'TOTAL RECEBIDO',

	SC7010.C7_QUANT-(SC7010.C7_QUJE+SC7010.C7_QTDACLA) AS 'QTDE FALTA',
  (SC7010.C7_QUANT-(SC7010.C7_QUJE+SC7010.C7_QTDACLA))*SC7010.C7_PRECO AS 'VALOR FALTA',

	SC7010.C7_NUMSC AS 'NUM SC',
	SC7010.C7_ITEMSC AS 'ITEM SC',
	SB1010.B1_GRUPO AS 'COD GRUPO',
	RTRIM(SBM010.BM_DESC) AS 'DESC GRUPO',

   SB1010.B1_TIPO+' - '+
	(
		SELECT SX5010.X5_DESCRI
		FROM PROTHEUS.dbo.SX5010 SX5010
		WHERE X5_TABELA='02' AND SX5010.X5_CHAVE=SB1010.B1_TIPO
	) AS 'DESCRIÇÃO TIPO DO PRODUTO',

	BM_TIPGRU+' - '+
	(
		SELECT SX5010.X5_DESCRI
		FROM PROTHEUS.dbo.SX5010 SX5010
		WHERE X5_TABELA='V0' AND SX5010.X5_CHAVE=BM_TIPGRU
	) AS 'DESCRIÇÃO TIPO DE GRUPO',

	--Case RTrim(Coalesce(SC7010.C7_DATPRF,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DATPRF, 112)END AS 'DT ENTREGA',
	SC7010.C7_OBS AS 'OBSERVAÇÃO',
	SC7010.C7_FORNECE AS 'FORNECEDOR',
	SC7010.C7_NOMFOR AS 'NOME FORNECEDOR',
	SC7010.C7_CC AS 'CENTRO DE  CUSTO',
	CASE WHEN SC7010.C7_CC = '         ' THEN 'PROCESSO PARA ARMAZÉM' ELSE RTRIM(CTT010.CTT_DESC01) END AS 'DESCRIÇÃO CENTRO DE CUSTO', 
	SC7010.C7_CONTA AS 'CONTA CONTÁBIL',
	CASE WHEN SC7010.C7_CONTA = '                    ' THEN 'ATIVO FIXO' ELSE RTRIM(CT1010.CT1_DESC01) END AS 'DESC CONT CONTÁBIL',
	SC7010.C7_ITEMCTA AS 'CARRO',
	RTRIM(SC7010.C7_ITEMCTA+' - '+CTD010.CTD_DESC01) AS 'DESC CARRO',
	SC7010.C7_QUJE AS 'QTDE ENTREGUE',
	SC7010.C7_QTDACLA AS 'QTDE A CLASSI',
	CASE WHEN SC7010.C7_CONAPRO = 'L' THEN 'APROVADO' ELSE 'BLOQUEADO' END AS 'SITUAÇÃO PC',
	SC7010.C7_CLVL AS 'OBRA',
	RTRIM(SC7010.C7_CLVL)+' - '+RTRIM(CTH010.CTH_DESC01) AS 'DESC OBRA/PROJETO',
	SC7010.C7_USER AS 'COD COMPRADOR',
	RTRIM(SY1010.Y1_NOME) AS 'NOME COMPRADOR',
	
	CASE WHEN SC7010.C7_USER IN ('000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655','000655') THEN 'COMPRA CORPORATIVA' ELSE 'COMPRA LOCAL'  END AS 'LOCAL DE COMPRA',
	
	CASE 
		WHEN SB1010.B1_GRUPO IN ('0229','0096','0211','0012','0013','0014','0052','0053','0054','0090','0091','0092','0093','0094','0095','0098','0099','0755','1021','4004','4005','4010') 
			THEN 'FROTA' 
		WHEN SB1010.B1_GRUPO IN ('0227','0226','0215','0254','0212','0050','0051','0130','0131','0132','0133','0250','0251','0252','0253','0255','0256','0257','0704','0713','0714','0716','4003','4008') 
			THEN 'SUPRIMENTOS' 
		WHEN SB1010.B1_GRUPO IN ('0223','0170','0171','0172','0173','0175','0176','0177','0216','0701','0709','0711','0712','0717','0718','0719','0740','0747','0748','0754','0756','0860','0861','0863','0864','0980','0982','0983','1020','4007','4009') 
			THEN 'ADMINISTRATIVO' 
		WHEN SB1010.B1_GRUPO NOT IN ('1218','1060','0174','3001','3005','0702','0703','0707','0710','1024','1025','3002','3003','3007','3050','3060','0720','0752','1200','3004','1203','0700','0706','0743','0780','0781','0782','0820','0822','0823','0825','1022','1065','1202','1204','1205','1206','1208','1211','1213','1215','1219','3000','3006','3008','3054','4006','7000')
			THEN 'GERAL' 
		ELSE 'ERRO' 
	END AS 'DEPARTAMENTO',
	
	CASE 
		WHEN (SC7010.C7_QUJE+SC7010.C7_QTDACLA)=SC7010.C7_QUANT THEN 'RECEBIDO TOTALMENTE'
		WHEN (SC7010.C7_QUJE+SC7010.C7_QTDACLA)=0 THEN 'FALTA RECEBER'
		WHEN (SC7010.C7_QUJE+SC7010.C7_QTDACLA)<SC7010.C7_QUANT AND (SC7010.C7_QUJE+SC7010.C7_QTDACLA)>0 THEN 'RECEBIDO PARCIAL'
		ELSE 'ERRO'
	END AS 'SITUAÇÃO DO PC',
	
	Case RTrim(Coalesce(SC7010.C7_EMISSAO,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_EMISSAO, 112)END AS 'EMISSÃO',
	Case RTrim(Coalesce(SC7010.C7_ALTDATA,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_ALTDATA, 112)END AS 'DT ALTERADO',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO1',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO2',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO3',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO4',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO5',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO6',
	Case RTrim(Coalesce(SC7010.C7_DTLIB1,'')) WHEN ''  THEN Null ELSE convert(datetime, SC7010.C7_DTLIB1, 112)END AS 'DT LIBERADO7',
	
	SC7010.C7_APROV1 AS 'APROVADOR 1',
	SC7010.C7_APROV2 AS 'APROVADOR 2',
	SC7010.C7_APROV3 AS 'APROVADOR 3',
	SC7010.C7_APROV4 AS 'APROVADOR 4',
	SC7010.C7_APROV5 AS 'APROVADOR 5',
	SC7010.C7_APROV6 AS 'APROVADOR 6',
	SC7010.C7_APROV7 AS 'APROVADOR 7',
	
	SC1010.C1_UM AS 'SC: UND', 
	SC1010.C1_QUANT AS 'SC: QTDE', 
	SC1010.C1_VLESTIM AS 'SC: VAL. UND.',
	SC1010.C1_VTOTAL AS 'SC: VAL TOTAL',
	SC1010.C1_TOTSC AS 'SC: VAL TOTAL SC',
	
	SC7010.C7_TPCOMPR AS 'TIPO DE COMPRA'

FROM PROTHEUS.dbo.SC7010 SC7010
	LEFT JOIN PROTHEUS.dbo.Z01010 Z01010 ON Z01010.Z01_CODGER = (SC7010.C7_FILIAL+SC7010.C7_LOCAL)
	LEFT JOIN PROTHEUS.dbo.CTT010 CTT010 ON SC7010.C7_CC=CTT010.CTT_CUSTO
	LEFT JOIN PROTHEUS.dbo.CT1010 CT1010 ON SC7010.C7_CONTA=CT1010.CT1_CONTA
	LEFT JOIN PROTHEUS.dbo.CTD010 CTD010 ON SC7010.C7_ITEMCTA=CTD010.CTD_ITEM
	LEFT JOIN PROTHEUS.dbo.CTH010 CTH010 ON SC7010.C7_CLVL=CTH010.CTH_CLVL
	LEFT JOIN PROTHEUS.dbo.SB1010 SB1010 ON SC7010.C7_PRODUTO=SB1010.B1_COD
	LEFT JOIN PROTHEUS.dbo.SBM010 SBM010 ON SB1010.B1_GRUPO=SBM010.BM_GRUPO
	LEFT JOIN PROTHEUS.dbo.SY1010 SY1010 ON SC7010.C7_USER=SY1010.Y1_USER
	
	LEFT JOIN PROTHEUS.dbo.SC1010 SC1010 ON SC1010.C1_NUM+SC1010.C1_ITEM = SC7010.C7_NUMSC+SC7010.C7_ITEMSC
	
WHERE 
	(SC7010.C7_EMISSAO>='20170101' AND SC7010.C7_EMISSAO<=GETDATE()) AND
	(SC7010.D_E_L_E_T_<>'*') AND 
-- 	(SC7010.C7_CONAPRO = 'L') AND
	--GRUPOS QUE NÃO PERTENCEM À ANÁLISE (GERALMENTE PARTENCENTES AO RH)
	(SB1010.B1_GRUPO NOT IN ('0053','4009','0052','0090','4007','0092','0093','0096','0174','0700','0702','0703','0706','0707','0710','0720','0740','0743','0752','0780','0781','0782','0820','0822','0823','0825','0864','0980','1022','1024','1025','1060','1065','1200','1202','1203','1204','1205','1206','1208','1211','1213','1215','1218','1219','3000','3001','3002','3003','3004','3005','3006','3007','3008','3050','3054','3060','4004','4005','4006','4010','7000')) AND
-- 	(SC7010.C7_QUJE+SC7010.C7_QTDACLA)<SC7010.C7_QUANT AND
	(SC7010.C7_RESIDUO<>' ') AND
-- 	(SC7010.C7_CC = '         ') AND
	(SC7010.C7_FILIAL='12') AND
	SC7010.C7_LOCAL = '90'
	--SC7010.C7_CLVL<>'001'
-- 	(SC7010.C7_USER IN ('000044','000053'))
ORDER BY 
	SC7010.C7_EMISSAO,
	SC7010.C7_NUM,
	SC7010.C7_ITEM