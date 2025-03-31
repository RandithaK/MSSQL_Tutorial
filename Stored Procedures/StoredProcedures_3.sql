-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Procedure to update unit price with basic validation
CREATE PROCEDURE UpdateProductPrice
    @prodId CHAR(4),
    @newPrice REAL
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the product exists
    IF NOT EXISTS (SELECT 1 FROM Products WHERE productId = @prodId)
    BEGIN
        PRINT 'Error: Product ID ' + @prodId + ' not found. Record update terminated.';
        RETURN; -- Exit the procedure
    END;

    -- Check if the new price is valid (e.g., > 0)
    IF @newPrice <= 0
    BEGIN
        PRINT 'Error: Selling price must be greater than 0. Record update terminated.';
        RETURN; -- Exit the procedure
    END;

    -- If checks pass, perform the update
    UPDATE Products
    SET unitPrice = @newPrice
    WHERE productId = @prodId;

    PRINT 'Product ' + @prodId + ' price updated successfully to ' + CAST(@newPrice AS VARCHAR) + '.';

END;
GO

-- How to use it:
-- Successful update
EXEC UpdateProductPrice @prodId = 'P004', @newPrice = 5000.00;
SELECT productId, productName, unitPrice FROM Products WHERE productId = 'P004';

-- Failed update (invalid price)
EXEC UpdateProductPrice @prodId = 'P004', @newPrice = -100.00;

-- Failed update (product not found)
EXEC UpdateProductPrice @prodId = 'P999', @newPrice = 6000.00;