
-- ==============================
--             users
-- ==============================

CREATE USER TestAdmin PASSWORD 'foobar' ADMIN;
CREATE USER TestDataAnalyst PASSWORD 'foobar';
CREATE USER TestViewer PASSWORD 'foobar';

GRANT Admin TO TestAdmin;
GRANT DataAnalyst TO TestDataAnalyst;
GRANT Viewer TO TestViewer;

-- ==============================
--          whitelists
-- ==============================

-- active whitelist
INSERT INTO Whitelists (id, name, description, createdBy, createdAt, isArchived) VALUES (1, 'whitelist 1', 'test description', 'test', '2018-06-08T15:09:15', 0)
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (1, 1, '2.A', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (2, 1, '2.A', 'ZT2112_F');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (3, 1, '1.A', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (4, 1, '2.B', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (5, 1, '2.C', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (6, 1, '3.A', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (7, 1, '3.B', 'ZT2111_P');

-- archived whitelist
INSERT INTO Whitelists (id, name, description, createdBy, createdAt, isArchived) VALUES (2, 'whitelist 2', 'test description', 'test', '2018-06-08T15:09:15', 1);
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES ( 8, 2, '2.A', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES ( 9, 2, '2.A', 'ZT2112_F');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (10, 2, '1.A', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (11, 2, '2.B', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (12, 2, '2.C', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (13, 2, '3.A', 'ZT2111_P');
INSERT INTO WhitelistEntries (id, whitelistId, username, usecaseId) VALUES (14, 2, '3.B', 'ZT2111_P');

-- ==============================
--      use cases (active)
-- ==============================

-- use case with profile condition (NONE linkage, use case 3.A from examples)
INSERT INTO AccessPatterns (id, isArchived, createdAt, createdBy, usecaseId, description, linkage) VALUES (1, 0, '2018-06-08T15:09:15', 'test', '3.A', 'test description', 'None');
INSERT INTO AccessConditions (id, type, patternId) VALUES (1, 'Profile', 1);
INSERT INTO AccessProfileConditions (condition_id, profile) VALUES (1, 'SAP_ALL');

-- use case with pattern condition (AND linkage, use case 1.A from examples)
INSERT INTO AccessPatterns (id, isArchived, createdAt, createdBy, usecaseId, description, linkage) VALUES (2, 0, '2018-06-08T15:09:15', 'test', '1.A', 'Unexpected users are authorized to copy a client (local copy wo user/profiles)', 'And');
INSERT INTO AccessConditions (id, type, patternId) VALUES (2, 'Pattern', 2);
INSERT INTO AccessPatternConditions (condition_id) VALUES (2);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (1, 'S_TCODE',    'TCD',        'SCCL', 'SCC9', NULL, NULL, 2);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (2, 'S_ADMI_FCD', 'S_ADMI_FCD', 'T000',  NULL,  NULL, NULL, 2);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (3, 'S_TABU_DIS', 'ACTVT',      '02',    NULL,  NULL, NULL, 2);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (4, 'S_TABU_DIS', 'DICBERCLS',  '"*"',   NULL,  NULL, NULL, 2);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (5, 'S_TABU_CLI', 'CLIIDMAINT', 'X',     NULL,  NULL, NULL, 2);
INSERT INTO AccessConditions (id, type, patternId) VALUES (3, 'Pattern', 2);
INSERT INTO AccessPatternConditions (condition_id) VALUES (3);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (6,  'S_TCODE',    'TCD',      'SCCL', 'SCC9', NULL, NULL, 3);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (7,  'S_DATASET',  'PROGRAM',  '"*"',   NULL,  NULL, NULL, 3);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (8,  'S_DATASET',  'ACTVT',    '"*"',   NULL,  NULL, NULL, 3);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (9,  'S_DATASET',  'FILENAME', '"*"',   NULL,  NULL, NULL, 3);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (10, 'S_CLNT_IMP', 'ACTVT',    '60',    NULL,  NULL, NULL, 3);

-- use case with pattern condition (OR linkage, use case 2.B from examples)
INSERT INTO AccessPatterns (id, isArchived, createdAt, createdBy, usecaseId, description, linkage) VALUES (3, 0, '2018-06-08T15:09:15', 'test', '2.B', 'Unexpected users with unrestricted access to workbench components', 'Or');
INSERT INTO AccessConditions (id, type, patternId) VALUES (4, 'Pattern', 3);
INSERT INTO AccessPatternConditions (condition_id) VALUES (4);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (11, 'S_DEVELOP', 'DEVCLASS', '"*"', NULL, NULL, NULL, 4);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (12, 'S_DEVELOP', 'OBJTYPE',  '"*"', NULL, NULL, NULL, 4);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (13, 'S_DEVELOP', 'OBJNAME',  '"*"', NULL, NULL, NULL, 4);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (14, 'S_DEVELOP', 'P_GROUP',  '"*"', NULL, NULL, NULL, 4);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (15, 'S_DEVELOP', 'ACTVT',    '"*"', NULL, NULL, NULL, 4);
INSERT INTO AccessConditions (id, type, patternId) VALUES (5, 'Pattern', 3);
INSERT INTO AccessPatternConditions (condition_id) VALUES (5);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (16, 'S_DEVELOP', 'DEVCLASS', '*',     NULL,   NULL, NULL, 5);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (17, 'S_DEVELOP', 'OBJTYPE',  'DEBUG', 'PROG', NULL, NULL, 5);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (18, 'S_DEVELOP', 'OBJNAME',  '*',     NULL,   NULL, NULL, 5);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (19, 'S_DEVELOP', 'P_GROUP',  '*',     NULL,   NULL, NULL, 5);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (20, 'S_DEVELOP', 'ACTVT',    '01',    '02',   NULL, NULL, 5);

-- ==============================
--      use cases (archived)
-- ==============================

-- use case with profile condition (NONE linkage, use case 3.A from examples)
INSERT INTO AccessPatterns (id, isArchived, createdAt, createdBy, usecaseId, description, linkage) VALUES (4, 1, '2018-06-08T15:09:15', 'test', '3.A', 'test description', 'None');
INSERT INTO AccessConditions (id, type, patternId) VALUES (6, 'Profile', 4);
INSERT INTO AccessProfileConditions (condition_id, profile) VALUES (6, 'SAP_ALL');

-- use case with pattern condition (AND linkage, use case 1.A from examples)
INSERT INTO AccessPatterns (id, isArchived, createdAt, createdBy, usecaseId, description, linkage) VALUES (5, 1, '2018-06-08T15:09:15', 'test', '1.A', 'Unexpected users are authorized to copy a client (local copy wo user/profiles)', 'And');
INSERT INTO AccessConditions (id, type, patternId) VALUES (7, 'Pattern', 5);
INSERT INTO AccessPatternConditions (condition_id) VALUES (7);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (21, 'S_TCODE',    'TCD',        'SCCL', 'SCC9', NULL, NULL, 7);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (22, 'S_ADMI_FCD', 'S_ADMI_FCD', 'T000',  NULL,  NULL, NULL, 7);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (23, 'S_TABU_DIS', 'ACTVT',      '02',    NULL,  NULL, NULL, 7);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (24, 'S_TABU_DIS', 'DICBERCLS',  '"*"',   NULL,  NULL, NULL, 7);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (25, 'S_TABU_CLI', 'CLIIDMAINT', 'X',     NULL,  NULL, NULL, 7);
INSERT INTO AccessConditions (id, type, patternId) VALUES (8, 'Pattern', 5);
INSERT INTO AccessPatternConditions (condition_id) VALUES (8);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (26,  'S_TCODE',    'TCD',      'SCCL', 'SCC9', NULL, NULL, 8);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (27,  'S_DATASET',  'PROGRAM',  '"*"',   NULL,  NULL, NULL, 8);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (28,  'S_DATASET',  'ACTVT',    '"*"',   NULL,  NULL, NULL, 8);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (29,  'S_DATASET',  'FILENAME', '"*"',   NULL,  NULL, NULL, 8);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (30,  'S_CLNT_IMP', 'ACTVT',    '60',    NULL,  NULL, NULL, 8);

-- use case with pattern condition (OR linkage, use case 2.B from examples)
INSERT INTO AccessPatterns (id, isArchived, createdAt, createdBy, usecaseId, description, linkage) VALUES (6, 1, '2018-06-08T15:09:15', 'test', '2.B', 'Unexpected users with unrestricted access to workbench components', 'Or');
INSERT INTO AccessConditions (id, type, patternId) VALUES (9, 'Pattern', 6);
INSERT INTO AccessPatternConditions (condition_id) VALUES (9);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (31, 'S_DEVELOP', 'DEVCLASS', '"*"', NULL, NULL, NULL, 9);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (32, 'S_DEVELOP', 'OBJTYPE',  '"*"', NULL, NULL, NULL, 9);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (33, 'S_DEVELOP', 'OBJNAME',  '"*"', NULL, NULL, NULL, 9);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (34, 'S_DEVELOP', 'P_GROUP',  '"*"', NULL, NULL, NULL, 9);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (35, 'S_DEVELOP', 'ACTVT',    '"*"', NULL, NULL, NULL, 9);
INSERT INTO AccessConditions (id, type, patternId) VALUES (10, 'Pattern', 6);
INSERT INTO AccessPatternConditions (condition_id) VALUES (10);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (36, 'S_DEVELOP', 'DEVCLASS', '*',     NULL,   NULL, NULL, 10);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (37, 'S_DEVELOP', 'OBJTYPE',  'DEBUG', 'PROG', NULL, NULL, 10);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (38, 'S_DEVELOP', 'OBJNAME',  '*',     NULL,   NULL, NULL, 10);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (39, 'S_DEVELOP', 'P_GROUP',  '*',     NULL,   NULL, NULL, 10);
INSERT INTO AccessPatternConditionProperties (id, authObject, authObjectProperty, value1, value2, value3, value4, conditionId) VALUES (40, 'S_DEVELOP', 'ACTVT',    '01',    '02',   NULL, NULL, 10);

-- ==============================
--         sap settings
-- ==============================

-- active config
INSERT INTO SapConfigurations (ID, DESCRIPTION, CLIENT, CREATEDAT, CREATEDBY, ISARCHIVED, LANGUAGE, POOLCAPACITY, SERVERDESTINATION, SYSNR) VALUES (1, 'a description', '001', '2018-06-08T15:09:15', 'test', 0, 'EN', '0', 'ec2-54-209-137-85.compute-1.amazonaws.com', '00');

-- archived config
INSERT INTO SapConfigurations (ID, DESCRIPTION, CLIENT, CREATEDAT, CREATEDBY, ISARCHIVED, LANGUAGE, POOLCAPACITY, SERVERDESTINATION, SYSNR) VALUES (2, 'a description', '001', '2018-06-08T15:09:15', 'test', 1, 'EN', '0', 'ec2-54-209-137-85.compute-1.amazonaws.com', '00');

-- ==============================
--        configurations
-- ==============================

-- active configs
INSERT INTO Configurations (ID, CREATEDAT, CREATEDBY, DESCRIPTION, ISARCHIVED, NAME, WHITELISTID) VALUES (1, '2018-06-08T15:09:15', 'test', 'a test description', 0, 'foo config 1', 1);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (1, 1);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (1, 3);

INSERT INTO Configurations (ID, CREATEDAT, CREATEDBY, DESCRIPTION, ISARCHIVED, NAME, WHITELISTID) VALUES (2, '2018-06-08T15:09:15', 'test', 'a test description', 0, 'foo config 2', 2);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (2, 1);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (2, 2);

-- archived configs
INSERT INTO Configurations (ID, CREATEDAT, CREATEDBY, DESCRIPTION, ISARCHIVED, NAME, WHITELISTID) VALUES (3, '2018-06-08T15:09:15', 'test', 'a test description', 1, 'foo config 1', 1);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (3, 1);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (3, 3);

INSERT INTO Configurations (ID, CREATEDAT, CREATEDBY, DESCRIPTION, ISARCHIVED, NAME, WHITELISTID) VALUES (4, '2018-06-08T15:09:15', 'test', 'a test description', 1, 'foo config 2', 2);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (4, 1);
INSERT INTO nm_Configuration_AccessPattern (CONFIGID, ACCESSPATTERNID) VALUES (4, 2);

-- ==============================
--    critical access queries
-- ==============================

-- query without archived references
INSERT INTO CriticalAccessQueries (ID, CONFIGID, SAPCONFIGID, CREATEDAT, CREATEDBY , ISARCHIVED) VALUES (1, 1, 1, '2018-06-08T15:09:15', 'test', 0);
INSERT INTO CriticalAccessEntries (ID, USERNAME, VIOLATEDPATTERNID, QUERYID) VALUES (1, 'foo123', 1, 1);
INSERT INTO CriticalAccessEntries (ID, USERNAME, VIOLATEDPATTERNID, QUERYID) VALUES (2, 'foobar', 3, 1);

-- query with archived references
INSERT INTO CriticalAccessQueries (ID, CONFIGID, SAPCONFIGID, CREATEDAT, CREATEDBY , ISARCHIVED) VALUES (2, 3, 2, '2018-06-08T15:09:15', 'test', 0);
INSERT INTO CriticalAccessEntries (ID, USERNAME, VIOLATEDPATTERNID, QUERYID) VALUES (3, 'foo123', 4, 2);
INSERT INTO CriticalAccessEntries (ID, USERNAME, VIOLATEDPATTERNID, QUERYID) VALUES (4, 'foobar', 6, 2);

-- ==============================
-- authors: Marco Tröster,
--          Joshua SChreibeis
-- last modified: 12.06.2018
-- ==============================