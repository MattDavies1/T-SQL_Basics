-- Select correct DB
USE TestData;
GO

-- Revoke permission to use a stored procedure
REVOKE EXECUTE ON pr_Names FROM Mary;
GO

-- Remove Mary's access to the database
DROP USER Mary;
GO

-- Remove Mary's permission to access the SQL Server
DROP LOGIN [GAMING-PC\Mary];
GO

-- Drop a stored procedure
DROP PROC dbo.pr_Names;
GO

-- Drop a stored View
DROP VIEW dbo.vw_Names;
GO

-- Delete content from a table
DELETE FROM Products;
GO

-- Delete the table itself
DROP TABLE Products;
GO

-- Remove the database itself
USE MASTER;
GO
DROP DATABASE TestData;
GO