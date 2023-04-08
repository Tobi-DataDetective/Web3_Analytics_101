-- Projects with more than 1000000000 dollar sales

SELECT collection,
SUM(amount_usd) AS "Total Volume",
COUNT(*) AS "Transactions",
COUNT(distinct buyer) AS "Buyers",
COUNT(distinct seller) AS "Sellers"
FROM nft.trades
GROUP BY 1
HAVING SUM(amount_usd) > 1000000000
ORDER BY 2 DESC;



-- buyer vs seller 
SELECT collection,
SUM(amount_usd) AS "Total Volume",
COUNT(*) AS "Transactions",
COUNT(distinct buyer) AS "Buyers",
COUNT(distinct seller) AS "Sellers"
FROM nft.trades
WHERE collection <> ''
GROUP BY 1
HAVING SUM(amount_usd) > 1000000000
ORDER BY 2 DESC;



---collection vs trade category$evt_type
SELECT collection, CONCAT(trade_category, ' ', evt_type) AS "Trade Details",COUNT(*) AS "Occurrence Count", SUM(amount_usd) AS "Total Volume"
FROM nft.trades
WHERE collection IN ('CryptoPunks','Terraforms','Meebits','Bored Ape Yacht Club','Dotdotdot','MutantApeYachtClubs','Dreadfulz','Otherdeed for Otherside','More Loot','Art Blocks Curated','Azuki','Loot')
GROUP BY 1, 2


-- /////////////////////////
-- getting the top buyers
WITH top_buyer AS (SELECT buyer, 
                    SUM(amount_usd) AS "Total Volume" 
                    FROM nft.trades
                    GROUP BY 1
                    ORDER BY 2 DESC
                    LIMIT 10),

     top_collections AS (SELECT collection,
                        SUM(amount_usd) AS "Total Volume"
                        FROM nft.trades
                        WHERE collection <> ''
                        GROUP BY 1
                        HAVING SUM(amount_usd) > 1000000000
                        ORDER BY 2 DESC),

    main_table AS (SELECT collection, amount_usd, buyer FROM nft.trades WHERE block_time >= (date_trunc('day', NOW())- interval '2' year)),

    top_collection_main_table AS (SELECT tc.collection, mt.amount_usd, mt.buyer
                                    FROM top_collections tc
                                    INNER JOIN main_table mt
                                    ON tc.collection = mt.collection)
                                    
SELECT tb.buyer, tcmt.collection,tcmt.amount_usd                                    
FROM top_buyer tb
INNER JOIN top_collection_main_table tcmt
ON tb.buyer = tcmt.buyer



-- Top project and their collections
-- get the top projects 
WITH top_collections AS (SELECT collection,
                        SUM(amount_usd) AS "Total Volume",
                        COUNT(*) AS "Transactions",
                        COUNT(distinct buyer) AS "Buyers",
                        COUNT(distinct seller) AS "Sellers"
                        FROM nft.trades
                        GROUP BY 1
                        HAVING SUM(amount_usd) > 1000000000
                        ORDER BY 2 DESC),

-- get the count of collections for each top projects
        top_projects AS (SELECT project, collection,
                        COUNT(*) AS "Transactions",
                        COUNT(distinct buyer) AS "Buyers",
                        COUNT(distinct seller) AS "Sellers"
                        FROM nft.trades
                        WHERE block_time >= (date_trunc('day', NOW())- interval '2' year)
                        GROUP BY 2,1
                        ORDER BY 3 DESC)

-- get the top counts
SELECT tc.collection, tp.project, tp.transactions
FROM top_collections tc
INNER JOIN top_projects tp
ON tc.collection = tp.collection

-- ////////////////////////////////
WITH seperated_volume AS (select date_trunc('day',block_time) AS "Date",
                            (CASE WHEN collection = 'Terraforms' THEN SUM(amount_usd)END)AS "Terraforms",
                            (CASE WHEN collection = 'Meebits' THEN SUM(amount_usd)END )AS "Meebits",
                            (CASE WHEN collection = 'Bored Ape Yacht Club' THEN SUM(amount_usd) END)AS "Bored Ape Yacht Club",
                            (CASE WHEN collection = 'Dotdotdot' THEN SUM(amount_usd)END )AS "Dotdotdot",
                            (CASE WHEN collection = 'CryptoPunk' THEN SUM(amount_usd)END )AS "CryptoPunk",
                            (CASE WHEN collection = 'MutantApeYachtClubs' THEN SUM(amount_usd)END )AS "MutantApeYachtClubs",
                            (CASE WHEN collection = 'Dreadfulz' THEN SUM(amount_usd)END )AS "Dreadfulz",
                            (CASE WHEN collection = 'Otherdeed for Otherside' THEN SUM(amount_usd)END )AS "Otherdeed for Otherside",
                            (CASE WHEN collection = 'More Loot' THEN SUM(amount_usd)END )AS "More Loot",
                            (CASE WHEN collection = 'Art Blocks Curated' THEN SUM(amount_usd)END )AS "Art Blocks Curated",
                            (CASE WHEN collection = 'Azuki' THEN SUM(amount_usd)END )AS "Azuki",
                            (CASE WHEN collection = 'Loot' THEN SUM(amount_usd)END )AS "Loot"


                        FROM nft.trades
                        WHERE block_time >= (date_trunc('day', NOW())- interval '2' year)
                        GROUP BY 1, collection)
-- SELECT distinct project FROM nft.trades

SELECT "Date",
SUM("Terraforms") AS "Terraforms",
SUM("Meebits") AS "Meebits",
SUM("Bored Ape Yacht Club") AS "Bored Ape Yacht Club",
SUM("Dotdotdot") AS "Dotdotdot",
SUM("CryptoPunk") AS "CryptoPunk",
SUM("MutantApeYachtClubs") AS "MutantApeYachtClubs",
SUM("Dreadfulz") AS "Dreadfulz",
SUM("Otherdeed for Otherside") AS "Otherdeed for Otherside",
SUM("More Loot") AS "More Loot",
SUM("Art Blocks Curated") AS "Art Blocks Curated",
SUM("Azuki") AS "Azuki",
SUM("Loot") AS "oneplanet"

FROM seperated_volume
GROUP BY 1