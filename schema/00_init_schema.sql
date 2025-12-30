/*
 *  DATABASE SCHEMA & SEED DATA
 * Context: SaaS Platform (Subscription Model)
 * Dialect: PostgreSQL
 */

-- 1. USERS TABLE (The core entity)
CREATE TABLE users
(
    user_id      SERIAL PRIMARY KEY,
    email        VARCHAR(255) UNIQUE NOT NULL,
    country_code CHAR(2),                     -- ISO 3166-1 alpha-2
    created_at   TIMESTAMP   DEFAULT CURRENT_TIMESTAMP,
    status       VARCHAR(50) DEFAULT 'active' -- 'active', 'churned'
);

-- 2. PAYMENTS TABLE (Financial ledger)
-- Used for: MRR Calculation, LTV Analysis
CREATE TABLE payments
(
    transaction_id SERIAL PRIMARY KEY,
    user_id        INTEGER REFERENCES users (user_id),
    amount         DECIMAL(10, 2) NOT NULL, -- Numeric for financial precision
    currency       CHAR(3) DEFAULT 'EUR',
    status         VARCHAR(20)    NOT NULL, -- 'paid', 'failed', 'refunded'
    type           VARCHAR(20)    NOT NULL, -- 'subscription', 'one-off'
    payment_date   TIMESTAMP      NOT NULL
);

-- 3. LOGIN_LOGS TABLE (Audit trail)
-- Used for: Forensic Analysis, Account Sharing Detection
CREATE TABLE login_logs
(
    id         SERIAL PRIMARY KEY,
    user_id    INTEGER REFERENCES users (user_id),
    ip_address VARCHAR(45) NOT NULL, -- IPv4 or IPv6
    country    VARCHAR(100),         -- GeoIP resolved country
    user_agent TEXT,
    login_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- indexes for performance (Best Practice)
CREATE INDEX idx_payments_date ON payments (payment_date);
CREATE INDEX idx_logs_user_time ON login_logs (user_id, login_time);

/*
 *  SEED DATA (Mocking a scenario)
 */

-- Insert some users
INSERT INTO users (user_id, email, country_code, created_at)
VALUES (1, 'alice@company.com', 'ES', '2025-01-01 10:00:00'),
       (2, 'bob@whalecorp.com', 'US', '2025-01-02 11:30:00'), -- The "Whale" client
       (3, 'charlie@frauder.com', 'RU', '2025-02-01 09:00:00');
-- The suspicious user

-- Insert payments (Alice pays monthly, Bob pays a lot, Charlie pays once)
INSERT INTO payments (user_id, amount, status, type, payment_date)
VALUES (1, 29.99, 'paid', 'subscription', '2025-01-01 10:05:00'),
       (1, 29.99, 'paid', 'subscription', '2025-02-01 10:05:00'),
       (2, 999.00, 'paid', 'subscription', '2025-01-02 12:00:00'), -- High LTV
       (2, 500.00, 'paid', 'one-off', '2025-01-15 14:00:00'),      -- Upsell
       (3, 9.99, 'paid', 'subscription', '2025-02-01 09:05:00');

-- Insert logs (Normal vs Impossible Travel)
INSERT INTO login_logs (user_id, ip_address, country, login_time)
VALUES
-- Alice: Normal behavior (Madrid)
(1, '192.168.1.10', 'Spain', '2025-02-01 08:00:00'),
(1, '192.168.1.10', 'Spain', '2025-02-01 18:00:00'),

-- Charlie: Impossible Travel (Moscow -> New York in 5 minutes)
(3, '85.10.10.5', 'Russia', '2025-02-10 10:00:00'),
(3, '45.20.20.9', 'USA', '2025-02-10 10:05:00');