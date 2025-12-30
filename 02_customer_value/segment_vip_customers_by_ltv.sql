/*
 *  BUSINESS CONTEXT:
 * Marketing needs to identify the top 5% of our user base ("Whales") based on
 * their Lifetime Value (LTV) to create look-alike audiences and optimize CAC.
 *
 *  TECHNICAL SOLUTION:
 * - Performs complex aggregations on transaction history.
 * - Uses Analytic Functions (PERCENT_RANK) to dynamically segment users
 * into percentiles without hardcoding threshold values.
 *
 * Author: Albert López | Engineering Manager
 */
WITH customer_ltv AS (
    SELECT
        user_id,
        SUM(amount) as total_spent,
        COUNT(transaction_id) as transaction_count,
        MAX(payment_date) - MIN(payment_date) as retention_days
    FROM payments
    GROUP BY user_id
),
     ranked_customers AS (
         SELECT
             *,
             -- Rank customers by spend to find the top percentile
             PERCENT_RANK() OVER (ORDER BY total_spent DESC) as percentile
         FROM customer_ltv
     )
SELECT *
FROM ranked_customers
WHERE percentile <= 0.05 -- Select top 5%
ORDER BY total_spent DESC;