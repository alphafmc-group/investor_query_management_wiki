-- ============================================================
-- AEM Investor Query Hub — Investor table DDL
-- Database: MariaDB
-- Created:  2026-04-16
-- ============================================================

-- ------------------------------------------------------------
-- AEM_INVESTOR_ENTITY
-- Top-level LP firm / fund entity.
-- ------------------------------------------------------------
CREATE TABLE AEM_INVESTOR_ENTITY (
    ID              INT             NOT NULL AUTO_INCREMENT,
    NAME            VARCHAR(255)    NOT NULL,
    TYPE            ENUM(
                        'PENSION_FUND',
                        'FAMILY_OFFICE',
                        'ENDOWMENT',
                        'SOVEREIGN_WEALTH',
                        'FUND_OF_FUNDS',
                        'INSURANCE',
                        'OTHER'
                    )               NOT NULL DEFAULT 'OTHER',
    IS_ACTIVE       TINYINT(1)      NOT NULL DEFAULT 1,
    NOTES           TEXT            NULL,
    CREATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT PK_AEM_INVESTOR_ENTITY PRIMARY KEY (ID)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- AEM_INVESTOR_ENTITY_RM
-- Maps relationship managers to an investor entity.
-- Multiple RMs per entity supported; one IS_PRIMARY = 1
-- per ENTITY_ID is enforced in application logic.
-- ------------------------------------------------------------
CREATE TABLE AEM_INVESTOR_ENTITY_RM (
    ID              INT             NOT NULL AUTO_INCREMENT,
    ENTITY_ID       INT             NOT NULL,
    USER_ID         INT             NOT NULL,
    IS_PRIMARY      TINYINT(1)      NOT NULL DEFAULT 0,
    CREATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT PK_AEM_INVESTOR_ENTITY_RM  PRIMARY KEY (ID),
    CONSTRAINT FK_IER_ENTITY              FOREIGN KEY (ENTITY_ID)
        REFERENCES AEM_INVESTOR_ENTITY (ID),
    -- Prevent duplicate RM rows for the same entity
    CONSTRAINT UQ_IER_ENTITY_USER         UNIQUE (ENTITY_ID, USER_ID)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;


-- ------------------------------------------------------------
-- AEM_INVESTOR_CONTACT
-- Individual person at an LP firm.
-- EMAIL_ADDRESS is the match key used during case ingest
-- resolution and auto-assignment Rule 1.
-- ------------------------------------------------------------
CREATE TABLE AEM_INVESTOR_CONTACT (
    ID              INT             NOT NULL AUTO_INCREMENT,
    ENTITY_ID       INT             NOT NULL,
    EMAIL_ADDRESS   VARCHAR(320)    NOT NULL,
    FULL_NAME       VARCHAR(255)    NOT NULL,
    TITLE           VARCHAR(255)    NULL,
    IS_PRIMARY      TINYINT(1)      NOT NULL DEFAULT 0,
    IS_ACTIVE       TINYINT(1)      NOT NULL DEFAULT 1,
    SOURCE          ENUM(
                        'MANUAL',
                        'CRM_IMPORT'
                    )               NOT NULL DEFAULT 'MANUAL',
    IMPORTED_AT     DATETIME        NULL,
    CREATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    UPDATED_AT      DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
                                             ON UPDATE CURRENT_TIMESTAMP,

    CONSTRAINT PK_AEM_INVESTOR_CONTACT    PRIMARY KEY (ID),
    CONSTRAINT FK_IC_ENTITY               FOREIGN KEY (ENTITY_ID)
        REFERENCES AEM_INVESTOR_ENTITY (ID),
    -- Email must be globally unique — it is the ingest match key
    CONSTRAINT UQ_IC_EMAIL_ADDRESS        UNIQUE (EMAIL_ADDRESS),

    -- Index for "get all contacts for entity" queries
    INDEX IDX_IC_ENTITY_ID (ENTITY_ID)

) ENGINE=InnoDB
  DEFAULT CHARSET=utf8mb4
  COLLATE=utf8mb4_unicode_ci;
