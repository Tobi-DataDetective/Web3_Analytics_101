SELECT 
	min(block_timestamp),
	max(block_timestamp)
FROM ethereum.core.fact_transactions
WHERE
	DATE_TRUNC('day',block_timestamp)='2023-01-22'
	-- you have to put the minimum value of day in the month for truncating in months
	-- DATE_TRUNC('month',block_timestamp)='2023-01-01'

	-- you have to put the minimum value of day the year for truncating in year
	-- DATE_TRUNC('year',block_timestamp)='2023-01-01'



	-- ALTERNATIVELY
	SELECT 
	min(block_timestamp),
	max(block_timestamp)
FROM ethereum.core.fact_transactions
WHERE
	block_timestamp::DATE = '2023-01-22'
	-- DATE_TRUNC('day',block_timestamp)='2023-01-22'


-- GROUP BY
SELECT 
  	currency_symbol,
    COUNT(DISTINCT tx_hash) AS "Number of Transactions",
    SUM(platform_fee) AS "Total_platform_fee, tx currency",
    SUM(platform_fee_usd) AS "Total_platform_fees_usd, USD"
FROM ethereum.core.ez_nft_sales
WHERE 
  	block_timestamp::DATE BETWEEN '2022-10-01' AND '2022-10-30'
    AND platform_name = 'opensea'
  	AND currency_symbol IS NOT NULL
  	-- AND "Number of Transactions"
  	AND platform_fee IS NOT NULL
  	AND platform_fee_usd IS NOT NULL
GROUP BY currency_symbol
ORDER BY "Total_platform_fees_usd, USD" DESC


-- HAVING CLAUSE
SELECT 
  	currency_symbol,
    COUNT(DISTINCT tx_hash) AS "Number of Transactions",
    SUM(platform_fee) AS "Total_platform_fee, tx currency",
    SUM(platform_fee_usd) AS "Total_platform_fees_usd, USD"
FROM ethereum.core.ez_nft_sales
WHERE 
  	block_timestamp::DATE BETWEEN '2022-10-01' AND '2022-10-30'
    AND platform_name = 'opensea'
  	AND currency_symbol IS NOT NULL
  	-- AND "Number of Transactions"
  	AND platform_fee IS NOT NULL
  	AND platform_fee_usd IS NOT NULL
GROUP BY currency_symbol
HAVING "Total_platform_fees_usd, USD" >= 1000
ORDER BY "Total_platform_fees_usd, USD" DESC


SELECT 
  	currency_symbol,
  	block_timestamp::DATE AS _date,
    COUNT(DISTINCT tx_hash) AS "Number of Transactions",
    SUM(platform_fee) AS "Total_platform_fee, tx currency",
    SUM(platform_fee_usd) AS "Total_platform_fees_usd, USD"
FROM ethereum.core.ez_nft_sales
WHERE 
  	block_timestamp::DATE BETWEEN '2022-10-01' AND '2022-10-30'
    AND platform_name = 'opensea'
  	AND currency_symbol IS NOT NULL
  	-- AND "Number of Transactions"
  	AND platform_fee IS NOT NULL
  	AND platform_fee_usd IS NOT NULL
GROUP BY currency_symbol, _date
HAVING "Total_platform_fees_usd, USD" >= 1000
ORDER BY "Total_platform_fees_usd, USD" DESC


-- CASE END
SELECT 
  	-- currency_symbol,
  	-- block_timestamp::DATE AS _date,
	CASE
		WHEN currency_symbol = 'ETH' THEN currency_symbol
		WHEN currency_symbol = 'WETH' THEN currency_symbol
  		ELSE 'Other'
  	END as "Currency symbol",
  
    COUNT(DISTINCT tx_hash) AS "Number of Transactions",
    SUM(platform_fee) AS "Total_platform_fee, tx currency",
    SUM(platform_fee_usd) AS "Total_platform_fees_usd, USD"
FROM ethereum.core.ez_nft_sales
WHERE 
  	block_timestamp::DATE BETWEEN '2022-10-01' AND '2022-10-30'
    AND platform_name = 'opensea'
  	AND currency_symbol IS NOT NULL
  	-- AND "Number of Transactions"
  	AND platform_fee IS NOT NULL
  	AND platform_fee_usd IS NOT NULL
GROUP BY "Currency symbol" --group by the resulting variable i.e case variable
ORDER BY "Total_platform_fees_usd, USD" DESC
  -- _date
-- HAVING "Total_platform_fees_usd, USD" >= 1000
-- ORDER BY 
--   _date,
--   "Total_platform_fees_usd, USD" DESC




--WITH CLAUSE
WITH opensea_sales AS
(SELECT *
FROM ethereum.core.ez_nft_sales
WHERE block_timestamp::DATE BETWEEN '2022-10-01' AND '2022-10-31'
  AND platform_name = 'opensea'
  AND currency_symbol is not NULL
  AND platform_fee_usd is not NULL
  AND platform_fee is not NULL
)

SELECT
	CASE
		WHEN currency_symbol = 'ETH' THEN currency_symbol
		WHEN currency_symbol = 'WETH' THEN currency_symbol
  		ELSE 'Other'
  	END as "Currency symbol",
    COUNT(DISTINCT tx_hash) AS "Number of Transactions",
        SUM(platform_fee) AS "Total_platform_fee, tx currency",
        SUM(platform_fee_usd) AS "Total_platform_fees_usd, USD"
FROM opensea_sales
GROUP BY "Currency symbol";



-- WITH and JOIN CLAUSE

WITH opensea_sales AS
( SELECT *
FROM ethereum.core.ez_nft_sales
WHERE block_timestamp::DATE BETWEEN '2022-10-01' AND '2022-10-31'
  AND platform_name = 'opensea'
  AND currency_symbol is not NULL
  AND platform_fee_usd is not NULL
  AND platform_fee is not NULL
),

prices AS
(
SELECT 
  symbol,
  price
FROM ethereum.core.fact_hourly_token_prices
WHERE hour::DATE = '2022-10-01'
-- GROUP BY symbol
  -- _date
  -- LIMIT 10
)


SELECT
   	opensea_sales.currency_symbol,
     COUNT(DISTINCT opensea_sales.tx_hash) AS "Number of Transactions",
         SUM(opensea_sales.platform_fee) AS "Total_platform_fee, tx currency",
  		avg(prices.price) as "Avg_price",
  		"Total_platform_fee, tx currency" * "Avg_price" as "Total platform fees (reconstructed), USD",
         SUM(opensea_sales.platform_fee_usd) AS "Total_platform_fees_usd, USD"
FROM opensea_sales

JOIN prices ON opensea_sales.currency_symbol = prices.symbol
GROUP BY currency_symbol


--   	currency_symbol,
--     COUNT(DISTINCT tx_hash) AS "Number of Transactions",
--         SUM(platform_fee) AS "Total_platform_fee, tx currency",
--         SUM(platform_fee_usd) AS "Total_platform_fees_usd, USD"
-- FROM opensea_sales
-- GROUP BY "Currency symbol"
-- ORDER BY "Total_platform_fees_usd, USD"
