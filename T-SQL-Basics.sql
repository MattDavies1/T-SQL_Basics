-- ========================================
-- Tutorial DB work: Learning T-SQL
-- ========================================

CREATE DATABASE TestData
GO

-- Select the dbo that we want
USE TestData
GO

-- Create the table we want
CREATE TABLE dbo.Products
	(ProductID int PRIMARY KEY NOT NULL,
	ProductName varchar(25) NOT NULL,
	Price money NULL,
	ProductDescription varchar(max) NULL)
GO

-- Insert Values into the TABLE
INSERT dbo.Products (ProductID, ProductName, Price, ProductDescription)
	VALUES(1, 'Clamp', 12.48, 'Workbench clamp')
GO

-- ProdcutID is PK and needs to be unique
-- IF ProductID has a row with the value '1', you can TRUNCATE TABLE to remove all rows then reinsert

-- Change order of columns to insert
INSERT dbo.Products (ProductName, ProductID, Price, ProductDescription)  
    VALUES ('Screwdriver', 50, 3.17, 'Flat head')  
GO

-- Skipping the column list, but keeping the values in order  
INSERT dbo.Products  
    VALUES (75, 'Tire Bar', NULL, 'Tool for changing tires.')  
GO

-- Dropping the optional dbo and dropping the ProductDescription column  
INSERT Products (ProductID, ProductName, Price)  
    VALUES (3000, '3 mm Bracket', 0.52)  
GO

-- Updating rows in a table
UPDATE dbo.Products  
    SET ProductName = 'Flat Head Screwdriver'  
    WHERE ProductID = 50  
GO

-- Views are stored SELECT statements
CREATE VIEW vw_Names  
   AS  
   SELECT ProductName, Price FROM Products;  
GO

-- Treat views like tables
SELECT * FROM vw_Names;
GO

-- Procedures can store what are effectively functions
CREATE PROCEDURE pr_Names @VarPrice money  
   AS  
   BEGIN  
      -- The print statement returns text to the user  
      PRINT 'Products less than ' + CAST(@VarPrice AS varchar(10));  
      -- A second statement starts here  
      SELECT ProductName, Price FROM vw_Names  
            WHERE Price < @varPrice;  
   END  
GO

-- Test stored procedure
EXECUTE pr_Names 10.00;
GO

