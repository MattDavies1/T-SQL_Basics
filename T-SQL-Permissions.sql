-- To access a DB_Engine, users need a login
-- This can be a windows login OR a SQL Server specific login

-- SYSTEM ADMINS by default have access to SQL Servers

-- Give access to SQL Server
CREATE LOGIN [GAMING-PC\Mary]
	FROM WINDOWS
	WITH DEFAULT_DATABASE = [TestData];
GO

-- Give Access to Database 'TestData'
USE [TestData];
GO

CREATE USER [Mary] FOR LOGIN [GAMING-PC\Mary];
GO

-- Give permission for Mary to use the 'pr_Names' procedure
GRANT EXECUTE ON pr_Names TO Mary;
GO