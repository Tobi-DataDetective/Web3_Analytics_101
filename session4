
SELECT 
  INPUT_DATA,
  SUBSTR(INPUT_DATA,1,10) as function_signature_substring,
  origin_function_signature
FROM ethereum.core.fact_transactions
	WHERE tx_hash = '0x29381510131c8b46c2150c6d859b3771705aa3606d9e9255749f6c11069ac795' AND block_timestamp::DATE = '2022-10-31'



-- TOPICS column describes the event that is happening on the chain. The transfer event always has a special address/alphanum
SELECT 
  event_index,
  contract_address,
  topics,
  data,
  ethereum.public.udf_hex_to_int(data) --converts the data to numeric
FROM ethereum.core.fact_event_logs
  	WHERE block_timestamp::date = '2022-08-15'
	AND tx_hash = '0xa3aa33ac7e1618bb41c644f875249c100c0d9f1352f6f8ba550ba4707cc8a953'
	AND topics[0]='0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'



SELECT 
  event_index,
  contract_address,
  topics,
  data,
  ethereum.public.udf_hex_to_int(data)::INT AS raw_amount,  --cast the data column as an integer
  raw_amount /1e18, -- dividing the value by 10 to the power of 18
  raw_amount / pow(10,18) -- alterbative approach to the above
FROM ethereum.core.fact_event_logs
  	WHERE block_timestamp::date = '2022-08-15'
	AND tx_hash = '0xa3aa33ac7e1618bb41c644f875249c100c0d9f1352f6f8ba550ba4707cc8a953'
	AND topics[0]='0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef'



SELECT
  decoded_log:dst ::string AS destination,
  decoded_log:src ::string AS source,
  decoded_log:wad ::int / pow(10,18) AS amount
FROM ethereum.core.fact_decoded_event_logs
  	WHERE block_timestamp::date = '2022-08-15'
	AND tx_hash = '0xa66b38d1779078a7c7de220b5035552637dca22f247fd9b74ac63a4fd0a261b0'
	AND event_index = '57'




--TRACE TABLE
  SELECT 
  date_trunc('hour', block_timestamp) AS hourly,
  sum(eth_value) as total_fees_eth_collected
FROM ethereum.core.fact_traces
  WHERE block_timestamp::DATE = '2022-12-02'
  -- AND tx_hash = '0x9793dd49b9f58810c8ced6222678a483a2276550ffb109365cb3c5c0f7c5b864'
  AND eth_value > 8
  AND identifier != 'CALL_ORIGIN'
  AND to_address = '0x8755773dc777b9f9b2e2c86402a03f099f823691'
  GROUP BY hourly
LIMIT 10