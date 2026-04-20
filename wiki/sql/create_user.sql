-- ============================================================
-- AEM Investor Query Hub — AEM_USER DDL and seed data
-- 20 users: 3 managers · 16 case workers · 1 admin
-- Database: MariaDB
-- Generated: 2026-04-16
-- ============================================================
--
-- NOTE: In production, Appian manages users natively.
-- This table is the application-level user record that mirrors
-- Appian's internal user, providing the ID referenced by FKs
-- across the data model (assigned_to, InvestorEntityRM, etc.).
-- The USERNAME field must match the Appian username exactly.
-- ============================================================


-- ------------------------------------------------------------
-- AEM_USER
-- ------------------------------------------------------------

CREATE TABLE AEM_USER (
    ID              INT             NOT NULL AUTO_INCREMENT,
    USERNAME        VARCHAR(100)    NOT NULL,
    FULL_NAME       VARCHAR(255)    NOT NULL,
    EMAIL           VARCHAR(320)    NOT NULL,
    ROLE            ENUM(
                        'CASE_WORKER',
                        'MANAGER',
                        'ADMIN'
                    )               NOT NULL DEFAULT 'CASE_WORKER',
    IS_ACTIVE       TINYINT(1)      NOT NULL DEFAULT 1,
    CREATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT PK_AEM_USER          PRIMARY KEY (ID),
    CONSTRAINT UQ_USER_USERNAME     UNIQUE (USERNAME),
    CONSTRAINT UQ_USER_EMAIL        UNIQUE (EMAIL)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- Seed data  (20 rows)
-- IDs 1–3   MANAGER      — oversee workload, access all cases
-- IDs 4–19  CASE_WORKER  — manage and respond to cases
-- ID  20    ADMIN        — system configuration
-- ------------------------------------------------------------

INSERT INTO AEM_USER
    (ID, USERNAME, FULL_NAME, EMAIL, ROLE, IS_ACTIVE, CREATED_AT, UPDATED_AT)
VALUES

-- MANAGERS
(  1, 'sarah.mitchell',    'Sarah Mitchell',    'sarah.mitchell@alphafmc.com',    'MANAGER',     1, '2022-01-10 09:00:00', '2022-01-10 09:00:00'),
(  2, 'james.park',        'James Park',        'james.park@alphafmc.com',        'MANAGER',     1, '2022-01-10 09:00:00', '2022-01-10 09:00:00'),
(  3, 'priya.mehta',       'Priya Mehta',       'priya.mehta@alphafmc.com',       'MANAGER',     1, '2022-01-10 09:00:00', '2022-01-10 09:00:00'),

-- CASE WORKERS
(  4, 'david.chen',        'David Chen',        'david.chen@alphafmc.com',        'CASE_WORKER', 1, '2022-01-10 09:00:00', '2022-01-10 09:00:00'),
(  5, 'emma.richardson',   'Emma Richardson',   'emma.richardson@alphafmc.com',   'CASE_WORKER', 1, '2022-01-10 09:00:00', '2022-01-10 09:00:00'),
(  6, 'oliver.thompson',   'Oliver Thompson',   'oliver.thompson@alphafmc.com',   'CASE_WORKER', 1, '2022-01-10 09:00:00', '2022-01-10 09:00:00'),
(  7, 'aisha.patel',       'Aisha Patel',       'aisha.patel@alphafmc.com',       'CASE_WORKER', 1, '2022-02-14 09:00:00', '2022-02-14 09:00:00'),
(  8, 'marcus.webb',       'Marcus Webb',       'marcus.webb@alphafmc.com',       'CASE_WORKER', 1, '2022-02-14 09:00:00', '2022-02-14 09:00:00'),
(  9, 'charlotte.davies',  'Charlotte Davies',  'charlotte.davies@alphafmc.com',  'CASE_WORKER', 1, '2022-02-14 09:00:00', '2022-02-14 09:00:00'),
( 10, 'liam.obrien',       'Liam O''Brien',      'liam.obrien@alphafmc.com',       'CASE_WORKER', 1, '2022-03-01 09:00:00', '2022-03-01 09:00:00'),
( 11, 'natasha.kowalski',  'Natasha Kowalski',  'natasha.kowalski@alphafmc.com',  'CASE_WORKER', 1, '2022-03-01 09:00:00', '2022-03-01 09:00:00'),
( 12, 'ben.harrison',      'Ben Harrison',      'ben.harrison@alphafmc.com',      'CASE_WORKER', 1, '2022-05-16 09:00:00', '2022-05-16 09:00:00'),
( 13, 'zoe.fitzgerald',    'Zoe Fitzgerald',    'zoe.fitzgerald@alphafmc.com',    'CASE_WORKER', 1, '2022-05-16 09:00:00', '2022-05-16 09:00:00'),
( 14, 'raj.sharma',        'Raj Sharma',        'raj.sharma@alphafmc.com',        'CASE_WORKER', 1, '2022-09-05 09:00:00', '2022-09-05 09:00:00'),
( 15, 'isabel.moreau',     'Isabel Moreau',     'isabel.moreau@alphafmc.com',     'CASE_WORKER', 1, '2022-09-05 09:00:00', '2022-09-05 09:00:00'),
( 16, 'tom.lawson',        'Tom Lawson',        'tom.lawson@alphafmc.com',        'CASE_WORKER', 1, '2023-03-20 09:00:00', '2023-03-20 09:00:00'),
( 17, 'hannah.yuen',       'Hannah Yuen',       'hannah.yuen@alphafmc.com',       'CASE_WORKER', 1, '2023-03-20 09:00:00', '2023-03-20 09:00:00'),
( 18, 'alex.drummond',     'Alex Drummond',     'alex.drummond@alphafmc.com',     'CASE_WORKER', 1, '2023-09-11 09:00:00', '2023-09-11 09:00:00'),
( 19, 'chloe.nakamura',    'Chloe Nakamura',    'chloe.nakamura@alphafmc.com',    'CASE_WORKER', 1, '2024-01-15 09:00:00', '2024-01-15 09:00:00'),

-- ADMIN
( 20, 'daniel.okafor',     'Daniel Okafor',     'daniel.okafor@alphafmc.com',     'ADMIN',       1, '2022-01-10 09:00:00', '2022-01-10 09:00:00');
