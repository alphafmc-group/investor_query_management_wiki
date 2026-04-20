-- ============================================================
-- AEM Investor Query Hub — Seed / test data
-- 30 investor entities · 59 contacts · 37 RM assignments
-- 20 case workers listed as reference (Appian-native users)
-- Generated: 2026-04-16
-- ============================================================

-- ------------------------------------------------------------
-- CASE WORKER REFERENCE
-- Users are managed natively by Appian — no INSERT required.
-- USER_IDs below are referenced in AEM_INVESTOR_ENTITY_RM.
-- Replace with actual Appian internal user IDs in production.
-- ------------------------------------------------------------
--
--  ID  | Name                | Role
-- -----|--------------------|-----------------------------
--   1  | Sarah Mitchell      | Senior IR Manager / RM
--   2  | James Park          | IR Manager / RM
--   3  | Priya Mehta         | IR Manager / RM
--   4  | David Chen          | IR Manager / RM
--   5  | Emma Richardson     | IR Manager / RM
--   6  | Oliver Thompson     | IR Manager / RM
--   7  | Aisha Patel         | IR Manager / RM
--   8  | Marcus Webb         | IR Manager / RM
--   9  | Charlotte Davies    | IR Manager / RM
--  10  | Liam O'Brien        | IR Manager / RM
--  11  | Natasha Kowalski    | IR Manager / RM
--  12  | Ben Harrison        | IR Manager / RM
--  13  | Zoe Fitzgerald      | IR Manager / RM
--  14  | Raj Sharma          | IR Manager / RM
--  15  | Isabel Moreau       | IR Manager / RM
--  16  | Tom Lawson          | IR Case Worker
--  17  | Hannah Yuen         | IR Case Worker
--  18  | Alex Drummond       | IR Case Worker
--  19  | Chloe Nakamura      | IR Case Worker
--  20  | Daniel Okafor       | IR Case Worker
--
-- ------------------------------------------------------------


-- ============================================================
-- AEM_INVESTOR_ENTITY  (30 rows)
-- Insert first — no foreign key dependencies.
-- ============================================================

INSERT INTO AEM_INVESTOR_ENTITY
    (ID, NAME, TYPE, IS_ACTIVE, NOTES, CREATED_AT, UPDATED_AT)
VALUES

-- PENSION FUND (7)
(  1, 'Ontario Teachers'' Pension Plan',        'PENSION_FUND',     1, 'Quarterly reporting preferred. Lead investor from Fund III onwards.',                              '2022-03-15 10:00:00', '2025-01-10 09:00:00'),
(  2, 'CalPERS Capital Partners',               'PENSION_FUND',     1, NULL,                                                                                              '2022-03-18 11:00:00', '2022-03-18 11:00:00'),
(  3, 'APG Asset Management',                   'PENSION_FUND',     1, NULL,                                                                                              '2022-04-02 09:30:00', '2022-04-02 09:30:00'),
(  4, 'Alecta Pension Insurance',               'PENSION_FUND',     1, NULL,                                                                                              '2022-04-10 14:00:00', '2022-04-10 14:00:00'),
(  5, 'AustralianSuper Investments',            'PENSION_FUND',     1, 'Key LP — co-investment interest flagged by RM.',                                                  '2022-05-20 09:00:00', '2024-06-03 10:00:00'),
(  6, 'New York State Common Retirement Fund',  'PENSION_FUND',     1, NULL,                                                                                              '2022-06-01 10:30:00', '2022-06-01 10:30:00'),
(  7, 'Universities Superannuation Scheme',     'PENSION_FUND',     1, NULL,                                                                                              '2022-07-12 11:00:00', '2022-07-12 11:00:00'),

-- FAMILY OFFICE (7)
(  8, 'Rothbury Capital Partners',              'FAMILY_OFFICE',    1, NULL,                                                                                              '2022-08-05 09:00:00', '2022-08-05 09:00:00'),
(  9, 'Meridian Family Wealth',                 'FAMILY_OFFICE',    1, NULL,                                                                                              '2022-09-14 10:00:00', '2022-09-14 10:00:00'),
( 10, 'Ashford & Partners',                     'FAMILY_OFFICE',    1, NULL,                                                                                              '2022-10-03 14:30:00', '2022-10-03 14:30:00'),
( 11, 'Wavecrest Private Holdings',             'FAMILY_OFFICE',    1, 'Prefers all communications routed via head of office. Do not contact portfolio team directly.',   '2023-01-09 09:00:00', '2025-02-14 11:00:00'),
( 12, 'Thornton Capital Group',                 'FAMILY_OFFICE',    1, NULL,                                                                                              '2023-01-25 10:00:00', '2023-01-25 10:00:00'),
( 13, 'Hargreaves Family Office',               'FAMILY_OFFICE',    1, NULL,                                                                                              '2023-02-14 11:00:00', '2023-02-14 11:00:00'),
( 14, 'Pemberton Private Wealth',               'FAMILY_OFFICE',    1, NULL,                                                                                              '2023-03-22 09:30:00', '2023-03-22 09:30:00'),

-- ENDOWMENT (5)
( 15, 'Westbrook University Endowment',         'ENDOWMENT',        1, NULL,                                                                                              '2023-04-11 10:00:00', '2023-04-11 10:00:00'),
( 16, 'Trinity College Investment Office',      'ENDOWMENT',        1, NULL,                                                                                              '2023-05-03 11:30:00', '2023-05-03 11:30:00'),
( 17, 'Northfield University Foundation',       'ENDOWMENT',        1, NULL,                                                                                              '2023-06-08 09:00:00', '2023-06-08 09:00:00'),
( 18, 'Lakeside College Endowment Fund',        'ENDOWMENT',        1, NULL,                                                                                              '2023-07-17 10:00:00', '2023-07-17 10:00:00'),
( 19, 'Eastgate Foundation',                    'ENDOWMENT',        1, NULL,                                                                                              '2023-08-29 09:30:00', '2023-08-29 09:30:00'),

-- SOVEREIGN WEALTH (4)
( 20, 'Gulf Capital Authority',                 'SOVEREIGN_WEALTH', 1, 'Committed to Fund IV. All outbound communications to be reviewed by RM before sending.',         '2023-10-04 10:00:00', '2025-01-22 14:00:00'),
( 21, 'Nordic Sovereign Fund',                  'SOVEREIGN_WEALTH', 1, NULL,                                                                                              '2023-11-15 11:00:00', '2023-11-15 11:00:00'),
( 22, 'Temasek Strategic Reserve',              'SOVEREIGN_WEALTH', 1, NULL,                                                                                              '2024-01-08 09:00:00', '2024-01-08 09:00:00'),
( 23, 'Abu Dhabi Alpha Fund',                   'SOVEREIGN_WEALTH', 1, NULL,                                                                                              '2024-02-20 10:30:00', '2024-02-20 10:30:00'),

-- FUND OF FUNDS (4)
( 24, 'Apex Multi-Manager',                     'FUND_OF_FUNDS',    1, NULL,                                                                                              '2024-03-12 09:00:00', '2024-03-12 09:00:00'),
( 25, 'Crossroads Alternative Investments',     'FUND_OF_FUNDS',    1, NULL,                                                                                              '2024-04-09 10:00:00', '2024-04-09 10:00:00'),
( 26, 'Pinnacle Capital Solutions',             'FUND_OF_FUNDS',    1, NULL,                                                                                              '2024-05-22 11:00:00', '2024-05-22 11:00:00'),
( 27, 'Harbourview Fund Advisors',              'FUND_OF_FUNDS',    1, NULL,                                                                                              '2024-06-18 09:30:00', '2024-06-18 09:30:00'),

-- INSURANCE (3)
( 28, 'Meridian Life Assurance',                'INSURANCE',        1, NULL,                                                                                              '2024-07-03 10:00:00', '2024-07-03 10:00:00'),
( 29, 'Northern Mutual Insurance',              'INSURANCE',        1, NULL,                                                                                              '2024-08-14 09:00:00', '2024-08-14 09:00:00'),
( 30, 'Centennial Re Group',                    'INSURANCE',        1, NULL,                                                                                              '2024-09-25 11:00:00', '2024-09-25 11:00:00');


-- ============================================================
-- AEM_INVESTOR_ENTITY_RM  (37 rows)
-- Primary RM listed first per entity, then secondary.
-- Depends on: AEM_INVESTOR_ENTITY
-- ============================================================

INSERT INTO AEM_INVESTOR_ENTITY_RM
    (ID, ENTITY_ID, USER_ID, IS_PRIMARY, CREATED_AT)
VALUES

-- Entity  1 — Ontario Teachers' Pension Plan
(  1,  1,  1, 1, '2022-03-15 10:00:00'),   -- Sarah Mitchell  (primary)
(  2,  1, 16, 0, '2022-03-15 10:00:00'),   -- Tom Lawson      (secondary)
-- Entity  2 — CalPERS Capital Partners
(  3,  2,  1, 1, '2022-03-18 11:00:00'),   -- Sarah Mitchell  (primary)
-- Entity  3 — APG Asset Management
(  4,  3,  2, 1, '2022-04-02 09:30:00'),   -- James Park      (primary)
(  5,  3, 17, 0, '2022-04-02 09:30:00'),   -- Hannah Yuen     (secondary)
-- Entity  4 — Alecta Pension Insurance
(  6,  4,  2, 1, '2022-04-10 14:00:00'),   -- James Park      (primary)
-- Entity  5 — AustralianSuper Investments
(  7,  5,  3, 1, '2022-05-20 09:00:00'),   -- Priya Mehta     (primary)
(  8,  5, 18, 0, '2022-05-20 09:00:00'),   -- Alex Drummond   (secondary)
-- Entity  6 — New York State Common Retirement Fund
(  9,  6,  3, 1, '2022-06-01 10:30:00'),   -- Priya Mehta     (primary)
-- Entity  7 — Universities Superannuation Scheme
( 10,  7,  4, 1, '2022-07-12 11:00:00'),   -- David Chen      (primary)
( 11,  7, 19, 0, '2022-07-12 11:00:00'),   -- Chloe Nakamura  (secondary)
-- Entity  8 — Rothbury Capital Partners
( 12,  8,  4, 1, '2022-08-05 09:00:00'),   -- David Chen      (primary)
-- Entity  9 — Meridian Family Wealth
( 13,  9,  5, 1, '2022-09-14 10:00:00'),   -- Emma Richardson (primary)
( 14,  9, 20, 0, '2022-09-14 10:00:00'),   -- Daniel Okafor   (secondary)
-- Entity 10 — Ashford & Partners
( 15, 10,  5, 1, '2022-10-03 14:30:00'),   -- Emma Richardson (primary)
-- Entity 11 — Wavecrest Private Holdings
( 16, 11,  6, 1, '2023-01-09 09:00:00'),   -- Oliver Thompson (primary)
-- Entity 12 — Thornton Capital Group
( 17, 12,  6, 1, '2023-01-25 10:00:00'),   -- Oliver Thompson (primary)
-- Entity 13 — Hargreaves Family Office
( 18, 13,  7, 1, '2023-02-14 11:00:00'),   -- Aisha Patel     (primary)
-- Entity 14 — Pemberton Private Wealth
( 19, 14,  7, 1, '2023-03-22 09:30:00'),   -- Aisha Patel     (primary)
-- Entity 15 — Westbrook University Endowment
( 20, 15,  8, 1, '2023-04-11 10:00:00'),   -- Marcus Webb     (primary)
-- Entity 16 — Trinity College Investment Office
( 21, 16,  9, 1, '2023-05-03 11:30:00'),   -- Charlotte Davies (primary)
-- Entity 17 — Northfield University Foundation
( 22, 17,  9, 1, '2023-06-08 09:00:00'),   -- Charlotte Davies (primary)
-- Entity 18 — Lakeside College Endowment Fund
( 23, 18, 10, 1, '2023-07-17 10:00:00'),   -- Liam O'Brien    (primary)
-- Entity 19 — Eastgate Foundation
( 24, 19, 10, 1, '2023-08-29 09:30:00'),   -- Liam O'Brien    (primary)
-- Entity 20 — Gulf Capital Authority
( 25, 20, 11, 1, '2023-10-04 10:00:00'),   -- Natasha Kowalski (primary)
( 26, 20, 14, 0, '2023-10-04 10:00:00'),   -- Raj Sharma      (secondary — cross-coverage for SWF portfolio)
-- Entity 21 — Nordic Sovereign Fund
( 27, 21, 11, 1, '2023-11-15 11:00:00'),   -- Natasha Kowalski (primary)
-- Entity 22 — Temasek Strategic Reserve
( 28, 22, 12, 1, '2024-01-08 09:00:00'),   -- Ben Harrison    (primary)
-- Entity 23 — Abu Dhabi Alpha Fund
( 29, 23, 12, 1, '2024-02-20 10:30:00'),   -- Ben Harrison    (primary)
-- Entity 24 — Apex Multi-Manager
( 30, 24, 13, 1, '2024-03-12 09:00:00'),   -- Zoe Fitzgerald  (primary)
( 31, 24, 15, 0, '2024-03-12 09:00:00'),   -- Isabel Moreau   (secondary)
-- Entity 25 — Crossroads Alternative Investments
( 32, 25, 13, 1, '2024-04-09 10:00:00'),   -- Zoe Fitzgerald  (primary)
-- Entity 26 — Pinnacle Capital Solutions
( 33, 26, 14, 1, '2024-05-22 11:00:00'),   -- Raj Sharma      (primary)
-- Entity 27 — Harbourview Fund Advisors
( 34, 27, 14, 1, '2024-06-18 09:30:00'),   -- Raj Sharma      (primary)
-- Entity 28 — Meridian Life Assurance
( 35, 28, 15, 1, '2024-07-03 10:00:00'),   -- Isabel Moreau   (primary)
-- Entity 29 — Northern Mutual Insurance
( 36, 29, 15, 1, '2024-08-14 09:00:00'),   -- Isabel Moreau   (primary)
-- Entity 30 — Centennial Re Group
( 37, 30, 15, 1, '2024-09-25 11:00:00');   -- Isabel Moreau   (primary)


-- ============================================================
-- AEM_INVESTOR_CONTACT  (59 rows)
-- Most sourced via CRM_IMPORT. MANUAL entries noted inline.
-- Depends on: AEM_INVESTOR_ENTITY
-- ============================================================

INSERT INTO AEM_INVESTOR_CONTACT
    (ID, ENTITY_ID, EMAIL_ADDRESS, FULL_NAME, TITLE, IS_PRIMARY, IS_ACTIVE, SOURCE, IMPORTED_AT, CREATED_AT, UPDATED_AT)
VALUES

-- Entity 1 — Ontario Teachers' Pension Plan
(  1,  1, 'm.robertson@ontarioteachers.ca',      'Michael Robertson',     'Chief Financial Officer',       1, 1, 'CRM_IMPORT', '2022-03-15 10:00:00', '2022-03-15 10:00:00', '2022-03-15 10:00:00'),
(  2,  1, 'j.walsh@ontarioteachers.ca',          'Jennifer Walsh',         'Head of External Managers',     0, 1, 'CRM_IMPORT', '2022-03-15 10:00:00', '2022-03-15 10:00:00', '2022-03-15 10:00:00'),
(  3,  1, 'r.chan@ontarioteachers.ca',            'Robert Chan',            'Senior Portfolio Manager',      0, 1, 'CRM_IMPORT', '2022-03-15 10:00:00', '2022-03-15 10:00:00', '2022-03-15 10:00:00'),

-- Entity 2 — CalPERS Capital Partners
(  4,  2, 'p.kim@calpers.ca.gov',                'Patricia Kim',           'Investment Director',           1, 1, 'CRM_IMPORT', '2022-03-18 11:00:00', '2022-03-18 11:00:00', '2022-03-18 11:00:00'),
(  5,  2, 's.huang@calpers.ca.gov',              'Steven Huang',           'Portfolio Manager',             0, 1, 'CRM_IMPORT', '2022-03-18 11:00:00', '2022-03-18 11:00:00', '2022-03-18 11:00:00'),

-- Entity 3 — APG Asset Management
(  6,  3, 'h.vanderberg@apg.nl',                 'Hendrik van der Berg',   'Managing Director',             1, 1, 'CRM_IMPORT', '2022-04-02 09:30:00', '2022-04-02 09:30:00', '2022-04-02 09:30:00'),
(  7,  3, 'a.smits@apg.nl',                      'Annika Smits',           'Investor Relations Manager',    0, 1, 'CRM_IMPORT', '2022-04-02 09:30:00', '2022-04-02 09:30:00', '2022-04-02 09:30:00'),

-- Entity 4 — Alecta Pension Insurance
(  8,  4, 'l.eriksson@alecta.se',                'Lars Eriksson',          'Chief Investment Officer',      1, 1, 'CRM_IMPORT', '2022-04-10 14:00:00', '2022-04-10 14:00:00', '2022-04-10 14:00:00'),
(  9,  4, 's.lindqvist@alecta.se',               'Sofia Lindqvist',        'Portfolio Manager',             0, 1, 'CRM_IMPORT', '2022-04-10 14:00:00', '2022-04-10 14:00:00', '2022-04-10 14:00:00'),

-- Entity 5 — AustralianSuper Investments
( 10,  5, 'a.morrison@australiansuper.com',      'Andrew Morrison',        'Head of Private Equity',        1, 1, 'CRM_IMPORT', '2022-05-20 09:00:00', '2022-05-20 09:00:00', '2022-05-20 09:00:00'),
( 11,  5, 'n.tran@australiansuper.com',          'Nicole Tran',            'Investment Manager',            0, 1, 'CRM_IMPORT', '2022-05-20 09:00:00', '2022-05-20 09:00:00', '2022-05-20 09:00:00'),
( 12,  5, 'p.williamson@australiansuper.com',    'Peter Williamson',       'Finance Director',              0, 1, 'CRM_IMPORT', '2022-05-20 09:00:00', '2022-05-20 09:00:00', '2022-05-20 09:00:00'),

-- Entity 6 — New York State Common Retirement Fund
( 13,  6, 'd.kowalczyk@osc.ny.gov',              'Diana Kowalczyk',        'Managing Director',             1, 1, 'CRM_IMPORT', '2022-06-01 10:30:00', '2022-06-01 10:30:00', '2022-06-01 10:30:00'),
( 14,  6, 'm.reed@osc.ny.gov',                   'Marcus Reed',            'Senior Analyst',                0, 1, 'CRM_IMPORT', '2022-06-01 10:30:00', '2022-06-01 10:30:00', '2022-06-01 10:30:00'),

-- Entity 7 — Universities Superannuation Scheme
( 15,  7, 'f.bradley@uss.co.uk',                 'Fiona Bradley',          'Head of Alternatives',          1, 1, 'CRM_IMPORT', '2022-07-12 11:00:00', '2022-07-12 11:00:00', '2022-07-12 11:00:00'),
( 16,  7, 'c.fraser@uss.co.uk',                  'Colin Fraser',           'Investment Manager',            0, 1, 'CRM_IMPORT', '2022-07-12 11:00:00', '2022-07-12 11:00:00', '2022-07-12 11:00:00'),

-- Entity 8 — Rothbury Capital Partners  [MANUAL — added by RM directly]
( 17,  8, 'e.rothbury@rothburycapital.com',      'Edward Rothbury',        'Principal',                     1, 1, 'MANUAL',     NULL,                  '2022-08-05 09:00:00', '2022-08-05 09:00:00'),
( 18,  8, 'c.moore@rothburycapital.com',         'Catherine Moore',        'Chief Financial Officer',       0, 1, 'MANUAL',     NULL,                  '2022-08-05 09:00:00', '2022-08-05 09:00:00'),

-- Entity 9 — Meridian Family Wealth  [MANUAL]
( 19,  9, 'j.hartley@meridianfamilywealth.com',  'Jonathan Hartley',       'Managing Partner',              1, 1, 'MANUAL',     NULL,                  '2022-09-14 10:00:00', '2022-09-14 10:00:00'),
( 20,  9, 'a.sterling@meridianfamilywealth.com', 'Amanda Sterling',        'Finance Director',              0, 1, 'MANUAL',     NULL,                  '2022-09-14 10:00:00', '2022-09-14 10:00:00'),

-- Entity 10 — Ashford & Partners
( 21, 10, 'w.ashford@ashfordpartners.com',       'William Ashford',        'Principal',                     1, 1, 'CRM_IMPORT', '2022-10-03 14:30:00', '2022-10-03 14:30:00', '2022-10-03 14:30:00'),
( 22, 10, 'r.stone@ashfordpartners.com',         'Rebecca Stone',          'Head of Investments',           0, 1, 'CRM_IMPORT', '2022-10-03 14:30:00', '2022-10-03 14:30:00', '2022-10-03 14:30:00'),

-- Entity 11 — Wavecrest Private Holdings
( 23, 11, 'k.zimmermann@wavecrestholdings.ch',   'Klaus Zimmermann',       'Director',                      1, 1, 'CRM_IMPORT', '2023-01-09 09:00:00', '2023-01-09 09:00:00', '2023-01-09 09:00:00'),
( 24, 11, 'm.bauer@wavecrestholdings.ch',        'Monika Bauer',           'Investment Manager',            0, 1, 'CRM_IMPORT', '2023-01-09 09:00:00', '2023-01-09 09:00:00', '2023-01-09 09:00:00'),

-- Entity 12 — Thornton Capital Group
( 25, 12, 'g.thornton@thorntoncapital.co.uk',    'Geoffrey Thornton',      'Chairman',                      1, 1, 'CRM_IMPORT', '2023-01-25 10:00:00', '2023-01-25 10:00:00', '2023-01-25 10:00:00'),
( 26, 12, 'l.barrett@thorntoncapital.co.uk',     'Louise Barrett',         'Chief Financial Officer',       0, 1, 'CRM_IMPORT', '2023-01-25 10:00:00', '2023-01-25 10:00:00', '2023-01-25 10:00:00'),

-- Entity 13 — Hargreaves Family Office
( 27, 13, 'c.hargreaves@hargreavesfamilyoffice.com', 'Charles Hargreaves', 'Principal',                     1, 1, 'CRM_IMPORT', '2023-02-14 11:00:00', '2023-02-14 11:00:00', '2023-02-14 11:00:00'),
( 28, 13, 's.price@hargreavesfamilyoffice.com',  'Samantha Price',         'Investment Director',           0, 1, 'CRM_IMPORT', '2023-02-14 11:00:00', '2023-02-14 11:00:00', '2023-02-14 11:00:00'),

-- Entity 14 — Pemberton Private Wealth  [MANUAL]
( 29, 14, 'v.pemberton@pembertonwealth.com',     'Victoria Pemberton',     'Chief Investment Officer',      1, 1, 'MANUAL',     NULL,                  '2023-03-22 09:30:00', '2023-03-22 09:30:00'),
( 30, 14, 'n.brooks@pembertonwealth.com',        'Nathan Brooks',          'Portfolio Manager',             0, 1, 'MANUAL',     NULL,                  '2023-03-22 09:30:00', '2023-03-22 09:30:00'),

-- Entity 15 — Westbrook University Endowment
( 31, 15, 't.wheeler@westbrook.edu',             'Dr. Thomas Wheeler',     'Chief Investment Officer',      1, 1, 'CRM_IMPORT', '2023-04-11 10:00:00', '2023-04-11 10:00:00', '2023-04-11 10:00:00'),
( 32, 15, 'k.nguyen@westbrook.edu',              'Karen Nguyen',           'Investment Manager',            0, 1, 'CRM_IMPORT', '2023-04-11 10:00:00', '2023-04-11 10:00:00', '2023-04-11 10:00:00'),

-- Entity 16 — Trinity College Investment Office
( 33, 16, 'j.whitfield@trinity.cam.ac.uk',       'Dr. James Whitfield',    'Bursar',                        1, 1, 'CRM_IMPORT', '2023-05-03 11:30:00', '2023-05-03 11:30:00', '2023-05-03 11:30:00'),
( 34, 16, 'h.cooper@trinity.cam.ac.uk',          'Helen Cooper',           'Investment Officer',            0, 1, 'CRM_IMPORT', '2023-05-03 11:30:00', '2023-05-03 11:30:00', '2023-05-03 11:30:00'),

-- Entity 17 — Northfield University Foundation
( 35, 17, 's.evans@northfieldfoundation.org',    'Sandra Evans',           'Executive Director',            1, 1, 'CRM_IMPORT', '2023-06-08 09:00:00', '2023-06-08 09:00:00', '2023-06-08 09:00:00'),
( 36, 17, 'b.powell@northfieldfoundation.org',   'Brian Powell',           'Investment Manager',            0, 1, 'CRM_IMPORT', '2023-06-08 09:00:00', '2023-06-08 09:00:00', '2023-06-08 09:00:00'),

-- Entity 18 — Lakeside College Endowment Fund  [MANUAL — single contact]
( 37, 18, 'a.drake@lakeside.edu',                'Prof. Alan Drake',       'Treasurer',                     1, 1, 'MANUAL',     NULL,                  '2023-07-17 10:00:00', '2023-07-17 10:00:00'),

-- Entity 19 — Eastgate Foundation
( 38, 19, 'm.liu@eastgatefoundation.org',        'Margaret Liu',           'Chief Investment Officer',      1, 1, 'CRM_IMPORT', '2023-08-29 09:30:00', '2023-08-29 09:30:00', '2023-08-29 09:30:00'),
( 39, 19, 'p.grant@eastgatefoundation.org',      'Philip Grant',           'Investment Analyst',            0, 1, 'CRM_IMPORT', '2023-08-29 09:30:00', '2023-08-29 09:30:00', '2023-08-29 09:30:00'),

-- Entity 20 — Gulf Capital Authority
( 40, 20, 'a.alrashidi@gulfcapitalauthority.ae', 'Ahmed Al-Rashidi',       'Director of Investments',       1, 1, 'CRM_IMPORT', '2023-10-04 10:00:00', '2023-10-04 10:00:00', '2023-10-04 10:00:00'),
( 41, 20, 'f.almansoori@gulfcapitalauthority.ae','Fatima Al-Mansoori',     'Senior Investment Manager',     0, 1, 'CRM_IMPORT', '2023-10-04 10:00:00', '2023-10-04 10:00:00', '2023-10-04 10:00:00'),

-- Entity 21 — Nordic Sovereign Fund
( 42, 21, 'e.bjornsson@nordicsovereign.no',      'Erik Bjornsson',         'Deputy Director',               1, 1, 'CRM_IMPORT', '2023-11-15 11:00:00', '2023-11-15 11:00:00', '2023-11-15 11:00:00'),
( 43, 21, 'a.halvorsen@nordicsovereign.no',      'Astrid Halvorsen',       'Portfolio Manager',             0, 1, 'CRM_IMPORT', '2023-11-15 11:00:00', '2023-11-15 11:00:00', '2023-11-15 11:00:00'),

-- Entity 22 — Temasek Strategic Reserve  [single contact]
( 44, 22, 'w.lin@temasekstrategic.sg',           'Wei Lin',                'Managing Director',             1, 1, 'CRM_IMPORT', '2024-01-08 09:00:00', '2024-01-08 09:00:00', '2024-01-08 09:00:00'),

-- Entity 23 — Abu Dhabi Alpha Fund
( 45, 23, 'm.alqassimi@abudhabialpha.ae',        'Mohammed Al-Qassimi',    'Chief Investment Officer',      1, 1, 'CRM_IMPORT', '2024-02-20 10:30:00', '2024-02-20 10:30:00', '2024-02-20 10:30:00'),
( 46, 23, 's.alhamdan@abudhabialpha.ae',         'Sara Al-Hamdan',         'Investment Director',           0, 1, 'CRM_IMPORT', '2024-02-20 10:30:00', '2024-02-20 10:30:00', '2024-02-20 10:30:00'),

-- Entity 24 — Apex Multi-Manager
( 47, 24, 's.clarke@apexmultimanager.co.uk',     'Simon Clarke',           'Managing Director',             1, 1, 'CRM_IMPORT', '2024-03-12 09:00:00', '2024-03-12 09:00:00', '2024-03-12 09:00:00'),
( 48, 24, 'r.murray@apexmultimanager.co.uk',     'Rachel Murray',          'Head of Private Equity',        0, 1, 'CRM_IMPORT', '2024-03-12 09:00:00', '2024-03-12 09:00:00', '2024-03-12 09:00:00'),

-- Entity 25 — Crossroads Alternative Investments
( 49, 25, 'j.fox@crossroadsalt.com',             'Jennifer Fox',           'Partner',                       1, 1, 'CRM_IMPORT', '2024-04-09 10:00:00', '2024-04-09 10:00:00', '2024-04-09 10:00:00'),
( 50, 25, 'd.stern@crossroadsalt.com',           'Daniel Stern',           'Portfolio Manager',             0, 1, 'CRM_IMPORT', '2024-04-09 10:00:00', '2024-04-09 10:00:00', '2024-04-09 10:00:00'),

-- Entity 26 — Pinnacle Capital Solutions  [MANUAL — single contact]
( 51, 26, 'r.halsey@pinnaclecapital.com',        'Robert Halsey',          'Managing Partner',              1, 1, 'MANUAL',     NULL,                  '2024-05-22 11:00:00', '2024-05-22 11:00:00'),

-- Entity 27 — Harbourview Fund Advisors
( 52, 27, 'c.lafleur@harbourviewfunds.ca',       'Christine Lafleur',      'Chief Investment Officer',      1, 1, 'CRM_IMPORT', '2024-06-18 09:30:00', '2024-06-18 09:30:00', '2024-06-18 09:30:00'),
( 53, 27, 'jp.bouchard@harbourviewfunds.ca',     'Jean-Pierre Bouchard',   'Senior Investment Manager',     0, 1, 'CRM_IMPORT', '2024-06-18 09:30:00', '2024-06-18 09:30:00', '2024-06-18 09:30:00'),

-- Entity 28 — Meridian Life Assurance
( 54, 28, 'r.marsh@meridianlife.co.uk',          'Richard Marsh',          'Head of Alternatives',          1, 1, 'CRM_IMPORT', '2024-07-03 10:00:00', '2024-07-03 10:00:00', '2024-07-03 10:00:00'),
( 55, 28, 's.crawley@meridianlife.co.uk',        'Susan Crawley',          'Investment Manager',            0, 1, 'CRM_IMPORT', '2024-07-03 10:00:00', '2024-07-03 10:00:00', '2024-07-03 10:00:00'),

-- Entity 29 — Northern Mutual Insurance
( 56, 29, 'g.walsh@northernmutual.com',          'Gregory Walsh',          'Chief Investment Officer',      1, 1, 'CRM_IMPORT', '2024-08-14 09:00:00', '2024-08-14 09:00:00', '2024-08-14 09:00:00'),
( 57, 29, 'p.olson@northernmutual.com',          'Patricia Olson',         'Portfolio Manager',             0, 1, 'CRM_IMPORT', '2024-08-14 09:00:00', '2024-08-14 09:00:00', '2024-08-14 09:00:00'),

-- Entity 30 — Centennial Re Group
( 58, 30, 'a.papadopoulos@centennialre.bm',      'Alexander Papadopoulos', 'Director of Investments',       1, 1, 'CRM_IMPORT', '2024-09-25 11:00:00', '2024-09-25 11:00:00', '2024-09-25 11:00:00'),
( 59, 30, 'l.fernandez@centennialre.bm',         'Laura Fernandez',        'Investment Manager',            0, 1, 'CRM_IMPORT', '2024-09-25 11:00:00', '2024-09-25 11:00:00', '2024-09-25 11:00:00');
