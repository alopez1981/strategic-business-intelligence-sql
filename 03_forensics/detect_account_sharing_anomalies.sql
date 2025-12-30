/*
 *  BUSINESS CONTEXT:
 * Security Ops detected potential revenue leakage due to unauthorized account sharing.
 * We need to identify users logging in from geographically impossible locations
 * within short timeframes ("Impossible Travel").
 *
 *  TECHNICAL SOLUTION:
 * - Implements a Self-Join pattern on the access logs table.
 * - Uses Interval Arithmetic (Epoch/Timestamp math) to calculate velocity.
 * - Filters for high-confidence anomalies to reduce false positives.
 *
 * Author: Albert López | Engineering Manager
 */
SELECT
    l1.user_id,
    l1.ip_address as ip_start,
    l2.ip_address as ip_end,
    l1.login_time as time_start,
    l2.login_time as time_end,
    EXTRACT(EPOCH FROM (l2.login_time - l1.login_time)) / 60 as minutes_diff
FROM login_logs l1
         JOIN login_logs l2 ON l1.user_id = l2.user_id
WHERE
    l1.id < l2.id
  AND l2.login_time > l1.login_time
  AND (l2.login_time - l1.login_time) < INTERVAL '10 minutes' -- Same user, different login < 10 mins
  AND l1.ip_address != l2.ip_address -- Different IP
  AND l1.country != l2.country -- Different Country (Impossible travel)
ORDER BY l1.login_time DESC;