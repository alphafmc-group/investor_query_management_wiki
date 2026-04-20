-- ============================================================
-- AEM Investor Query Hub — Extended fields on AEM_INVESTOR_ENTITY
-- Adds: commitment amount, AUM, fund/vintage, domicile, KYC/AML
-- Database: MariaDB
-- Generated: 2026-04-16
-- ============================================================


-- ------------------------------------------------------------
-- ALTER TABLE — add all columns in one statement
-- ------------------------------------------------------------

ALTER TABLE AEM_INVESTOR_ENTITY
    ADD COLUMN COMMITMENT_AMOUNT    DECIMAL(15,2)                                               NULL  AFTER NOTES,
    ADD COLUMN COMMITMENT_CURRENCY  CHAR(3)                                                     NULL  AFTER COMMITMENT_AMOUNT,
    ADD COLUMN AUM_USD_MILLIONS     DECIMAL(15,2)                                               NULL  AFTER COMMITMENT_CURRENCY,
    ADD COLUMN FUND_NAME            VARCHAR(100)                                                NULL  AFTER AUM_USD_MILLIONS,
    ADD COLUMN VINTAGE_YEAR         SMALLINT                                                    NULL  AFTER FUND_NAME,
    ADD COLUMN DOMICILE_COUNTRY     VARCHAR(100)                                                NULL  AFTER VINTAGE_YEAR,
    ADD COLUMN DOMICILE_REGION      ENUM('AMERICAS', 'EMEA', 'APAC', 'OTHER')                  NULL  AFTER DOMICILE_COUNTRY,
    ADD COLUMN KYC_AML_STATUS       ENUM('PENDING', 'APPROVED', 'UNDER_REVIEW', 'REJECTED')  NOT NULL DEFAULT 'PENDING'  AFTER DOMICILE_REGION,
    ADD COLUMN KYC_AML_REVIEWED_AT  DATETIME                                                    NULL  AFTER KYC_AML_STATUS;


-- ------------------------------------------------------------
-- Dummy data — one UPDATE per entity for clarity
--
-- COMMITMENT_AMOUNT is in the native currency of the investor.
-- AUM_USD_MILLIONS is normalised to USD for comparability.
-- KYC_AML_REVIEWED_AT is NULL for any row with UNDER_REVIEW.
-- ------------------------------------------------------------

-- Entity 1 — Ontario Teachers' Pension Plan
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 250.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 247000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'Canada',             DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-04-12 09:00:00'
WHERE ID = 1;

-- Entity 2 — CalPERS Capital Partners
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 500.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 440000.00,
    FUND_NAME           = 'Alpha FMC Fund III', VINTAGE_YEAR = 2016,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-04-15 09:00:00'
WHERE ID = 2;

-- Entity 3 — APG Asset Management
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 400.00,    COMMITMENT_CURRENCY = 'EUR',
    AUM_USD_MILLIONS    = 620000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'Netherlands',        DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-05-03 09:00:00'
WHERE ID = 3;

-- Entity 4 — Alecta Pension Insurance
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 150.00,    COMMITMENT_CURRENCY = 'EUR',
    AUM_USD_MILLIONS    = 105000.00,
    FUND_NAME           = 'Alpha FMC Fund III', VINTAGE_YEAR = 2016,
    DOMICILE_COUNTRY    = 'Sweden',             DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-05-10 09:00:00'
WHERE ID = 4;

-- Entity 5 — AustralianSuper Investments
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 300.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 215000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'Australia',          DOMICILE_REGION = 'APAC',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-06-20 09:00:00'
WHERE ID = 5;

-- Entity 6 — New York State Common Retirement Fund
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 350.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 248000.00,
    FUND_NAME           = 'Alpha FMC Fund III', VINTAGE_YEAR = 2016,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-07-01 09:00:00'
WHERE ID = 6;

-- Entity 7 — Universities Superannuation Scheme
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 200.00,    COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 78000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-08-12 09:00:00'
WHERE ID = 7;

-- Entity 8 — Rothbury Capital Partners
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 50.00,     COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 3200.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-09-05 09:00:00'
WHERE ID = 8;

-- Entity 9 — Meridian Family Wealth
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 35.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 4800.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-10-14 09:00:00'
WHERE ID = 9;

-- Entity 10 — Ashford & Partners
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 25.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 2100.00,
    FUND_NAME           = 'Alpha FMC Fund III', VINTAGE_YEAR = 2016,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2022-11-03 09:00:00'
WHERE ID = 10;

-- Entity 11 — Wavecrest Private Holdings
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 75.00,     COMMITMENT_CURRENCY = 'CHF',
    AUM_USD_MILLIONS    = 8500.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'Switzerland',        DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-02-09 09:00:00'
WHERE ID = 11;

-- Entity 12 — Thornton Capital Group
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 40.00,     COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 1800.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-02-25 09:00:00'
WHERE ID = 12;

-- Entity 13 — Hargreaves Family Office
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 30.00,     COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 1200.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-03-14 09:00:00'
WHERE ID = 13;

-- Entity 14 — Pemberton Private Wealth
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 45.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 5600.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-04-22 09:00:00'
WHERE ID = 14;

-- Entity 15 — Westbrook University Endowment
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 60.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 12000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-05-11 09:00:00'
WHERE ID = 15;

-- Entity 16 — Trinity College Investment Office
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 40.00,     COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 4200.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-06-03 09:00:00'
WHERE ID = 16;

-- Entity 17 — Northfield University Foundation
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 25.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 3100.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-07-08 09:00:00'
WHERE ID = 17;

-- Entity 18 — Lakeside College Endowment Fund
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 20.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 1800.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-08-17 09:00:00'
WHERE ID = 18;

-- Entity 19 — Eastgate Foundation
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 30.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 2400.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-09-29 09:00:00'
WHERE ID = 19;

-- Entity 20 — Gulf Capital Authority
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 500.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 280000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'United Arab Emirates', DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-11-04 09:00:00'
WHERE ID = 20;

-- Entity 21 — Nordic Sovereign Fund
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 350.00,    COMMITMENT_CURRENCY = 'EUR',
    AUM_USD_MILLIONS    = 185000.00,
    FUND_NAME           = 'Alpha FMC Fund IV',  VINTAGE_YEAR = 2019,
    DOMICILE_COUNTRY    = 'Norway',             DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2023-12-15 09:00:00'
WHERE ID = 21;

-- Entity 22 — Temasek Strategic Reserve
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 250.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 320000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'Singapore',          DOMICILE_REGION = 'APAC',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2024-02-08 09:00:00'
WHERE ID = 22;

-- Entity 23 — Abu Dhabi Alpha Fund
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 400.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 850000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United Arab Emirates', DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'UNDER_REVIEW',       KYC_AML_REVIEWED_AT = NULL
WHERE ID = 23;

-- Entity 24 — Apex Multi-Manager
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 100.00,    COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 22000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2024-04-12 09:00:00'
WHERE ID = 24;

-- Entity 25 — Crossroads Alternative Investments
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 75.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 18500.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2024-05-09 09:00:00'
WHERE ID = 25;

-- Entity 26 — Pinnacle Capital Solutions
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 50.00,     COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 9200.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2024-06-22 09:00:00'
WHERE ID = 26;

-- Entity 27 — Harbourview Fund Advisors
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 80.00,     COMMITMENT_CURRENCY = 'CAD',
    AUM_USD_MILLIONS    = 14000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'Canada',             DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2024-07-18 09:00:00'
WHERE ID = 27;

-- Entity 28 — Meridian Life Assurance
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 125.00,    COMMITMENT_CURRENCY = 'GBP',
    AUM_USD_MILLIONS    = 45000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United Kingdom',     DOMICILE_REGION = 'EMEA',
    KYC_AML_STATUS      = 'APPROVED',           KYC_AML_REVIEWED_AT = '2024-08-03 09:00:00'
WHERE ID = 28;

-- Entity 29 — Northern Mutual Insurance
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 150.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 62000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'United States',      DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'UNDER_REVIEW',       KYC_AML_REVIEWED_AT = NULL
WHERE ID = 29;

-- Entity 30 — Centennial Re Group
UPDATE AEM_INVESTOR_ENTITY SET
    COMMITMENT_AMOUNT   = 100.00,    COMMITMENT_CURRENCY = 'USD',
    AUM_USD_MILLIONS    = 28000.00,
    FUND_NAME           = 'Alpha FMC Fund V',   VINTAGE_YEAR = 2022,
    DOMICILE_COUNTRY    = 'Bermuda',            DOMICILE_REGION = 'AMERICAS',
    KYC_AML_STATUS      = 'UNDER_REVIEW',       KYC_AML_REVIEWED_AT = NULL
WHERE ID = 30;
