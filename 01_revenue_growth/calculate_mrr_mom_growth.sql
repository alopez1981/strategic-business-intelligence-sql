/*
 *  BUSINESS CONTEXT:
 * The Executive Team needs to track the velocity of our recurring revenue (MRR)
 * to measure the real impact of recent marketing campaigns, excluding one-off payments.
 *
 *  TECHNICAL SOLUTION:
 * - Uses Common Table Expressions (CTEs) for readability.
 * - Implements Window Functions (LAG) to calculate Month-over-Month (MoM)
 * variance directly in SQL, avoiding external BI processing overhead.
 *
 * Author: Albert López | Engineering Manager
 */
WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', payment_date) as revenue_month,
        SUM(amount) as mrr
    FROM payments
    WHERE status = 'paid' AND type = 'subscription'
    GROUP BY 1
),
     growth_calculation AS (
         SELECT
             revenue_month,
             mrr,
             -- Window Function to get previous month's value
             LAG(mrr) OVER (ORDER BY revenue_month) as previous_month_mrr
         FROM monthly_revenue
     )
SELECT
    revenue_month,
    mrr,
    ROUND(((mrr - previous_month_mrr) / previous_month_mrr) * 100, 2) as growth_percentage
FROM growth_calculation
ORDER BY revenue_month DESC;