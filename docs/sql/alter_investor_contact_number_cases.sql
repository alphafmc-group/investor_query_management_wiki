-- ============================================================
-- AEM Investor Query Hub — Add NUMBER_CASES to AEM_INVESTOR_CONTACT
-- Database: MariaDB
-- Generated: 2026-04-16
-- ============================================================

ALTER TABLE AEM_INVESTOR_CONTACT
    ADD COLUMN NUMBER_CASES INT NOT NULL DEFAULT 0
        AFTER IMPORTED_AT;


-- ------------------------------------------------------------
-- Populate NUMBER_CASES with a random integer between 1 and 10
-- for all existing rows.
-- FLOOR(1 + RAND() * 10) produces a uniform distribution
-- over {1, 2, 3, 4, 5, 6, 7, 8, 9, 10}.
-- ------------------------------------------------------------

UPDATE AEM_INVESTOR_CONTACT
SET    NUMBER_CASES = FLOOR(1 + RAND() * 10);
