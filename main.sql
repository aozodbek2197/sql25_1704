-- 1-mashq
WITH cte AS (
    SELECT 
        transaction_id,
        transaction_date,
        amount,
        SUM(amount) OVER (ORDER BY transaction_date) AS running_total,
        SUM(CASE WHEN amount < 0 AND running_total < 0 THEN 1 ELSE 0 END) 
            OVER (ORDER BY transaction_date) AS reset_group
    FROM transactions
)
SELECT 
    transaction_id,
    transaction_date,
    amount,
    running_total - FIRST_VALUE(running_total) OVER (PARTITION BY reset_group ORDER BY transaction_date) 
        AS group_running_total
FROM cte
ORDER BY transaction_date;
-- 2-mashq
SELECT 
    f1.x, 
    f1.y
FROM functions f1
JOIN functions f2 ON f1.x = f2.y AND f1.y = f2.x
WHERE f1.x <= f1.y
GROUP BY f1.x, f1.y
HAVING COUNT(*) > 1 OR (f1.x = f1.y AND COUNT(*) = 2)
ORDER BY f1.x;
