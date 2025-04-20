-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! BASIC STORED PROCEDURE: Product Information Lookup
--* Purpose: Retrieves information about a specific product by ID
--* Demonstrates simple procedure execution with parameters

CREATE PROCEDURE GetProductInfo
    @productId CHAR(4) -- Product ID to retrieve
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        productId,
        productName,
        unitPrice,
        unitInStock,
        ROL AS ReorderLevel
    FROM Products
    WHERE productId = @productId;
END;
GO

--! USAGE EXAMPLES

--* Example 1: Get information for product P001
EXEC GetProductInfo @productId = 'P001';

--* Example 2: Alternative syntax
-- EXECUTE GetProductInfo 'P002';

--TODO: Add error handling for non-existent product IDs