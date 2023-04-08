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
SELECT collection,
SUM(amount_usd) AS "Total Volume"
FROM nft.trades
WHERE collection <> ''
GROUP BY 1
HAVING SUM(amount_usd) > 1000000000
ORDER BY 2 DESC


SELECT a.collection, b.buyer, b."Total Volume", b."Buyers"
FROM (SELECT collection, buyer FROM nft.trades WHERE collection <> '') a
INNER JOIN (SELECT buyer, SUM(amount_usd) AS "Total Volume", COUNT(distinct buyer) AS "Buyers" FROM nft.trades GROUP BY 1 ORDER BY 2 DESC LIMIT 5) b
ON a.buyer = b.buyer



-- Last script
SELECT d.collection, c.buyer, AVG(c."Total Volume") AS "Total Volume"
FROM (SELECT collection,
    SUM(amount_usd) AS "Total Volume"
    FROM nft.trades
    WHERE collection <> ''
    GROUP BY 1
    HAVING SUM(amount_usd) > 1000000000
    ORDER BY 2 DESC) d
INNER JOIN (SELECT a.collection, b.buyer, b."Total Volume", b."Buyers"
    FROM (SELECT collection, buyer FROM nft.trades WHERE collection <> '') a
    INNER JOIN (SELECT buyer, SUM(amount_usd) AS "Total Volume", COUNT(distinct buyer) AS "Buyers" FROM nft.trades GROUP BY 1 ORDER BY 2 DESC LIMIT 5) b
    ON a.buyer = b.buyer) c
ON d.collection = c.collection
GROUP BY 1,2,c."Total Volume"
