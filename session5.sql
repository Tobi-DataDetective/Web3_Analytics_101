select block_time, block_number, "from", "to", value as eth_value, (gas_used * gas_price)/power(10,18) as tx_fee,
cast(bytearray_to_uint256('0x' || substring(data,77,64)) as double) / power(10,18) as token_amount
from ethereum.transactions
where hash = lower('0x5bc65206dae7a3bbc84638cc31e33492845e60ce4f7aaddbf9d5760c0c60ae56')
and block_number = 300290
limit 100




select *
from erc20_ethereum.evt_Transfer
where evt_tx_hash = lower('0x5bc65206dae7a3bbc84638cc31e33492845e60ce4f7aaddbf9d5760c0c60ae56')
and evt_block_number = 300290



select
    date_trunc('{{time interval}}', block_time) as dt,
    count(hash) as num_tx,
    count(distinct "from") as num_addrs,
    sum(gas_used) as total_gas_used,
    avg(gas_used) as avg_gas_used,
    avg(gas_price)/1e9 as avg_gas_price
from ethereum.transactions
where
    block_time > cast('2022-01-01' as date)
    and success
    group by 1




select 
    contract_address,
    evt_tx_hash,
    offerer as sender,
    consideration as receiver,
    vals.val
from seaport_ethereum.Seaport_evt_OrderFulfilled, unnest(consideration) as vals(val)
where
evt_block_time > current_timestamp - interval '7' day
limit 100



select
    t.nft_contract_address,
    t.collection,
    count(distinct t.tx_hash) as num_txs,
    count(distinct t.buyer) as num_buyers,
    sum(t.amount_usd) as volume_usd,
    sum(case when wt.is_wash_trade then t.amount_usd end) as wash_trade_amount_usd,
    sum(case when wt.is_wash_trade then t.amount_usd end) / sum(t.amount_usd) as perc_wash_trade_volume
from nft.trades as t
join nft.wash_trades as wt
    on t.block_number = wt.block_number
    and t.unique_trade_id = wt.unique_trade_id
where
    t.blockchain = 'ethereum'
    and t.block_time > current_timestamp - interval '7' day
    and t.amount_usd > 0
    
group by 1,2
order by 5 desc
limit 100