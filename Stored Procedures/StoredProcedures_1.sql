-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Procedure to get details for a specific product
CREATE PROCEDURE GetProductInfo
    @prodId CHAR(4) -- Input parameter
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    SELECT *
    FROM Products
    WHERE productId = @prodId;
END;
GO

-- How to use it:
EXEC GetProductInfo @prodId = 'P001';
-- Or positional:
EXEC GetProductInfo 'P002';