-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! STORED PROCEDURE: Product Price Updater with Validation
--* Purpose: Updates a product's price with input validation
--* Demonstrates: Parameter validation, error handling, and safe updates
CREATE PROCEDURE UpdateProductPrice
    @prodId CHAR(4),     -- Product ID to update
    @newPrice REAL       -- New price value
AS
BEGIN
    SET NOCOUNT ON;

    --* Step 1: Validate product exists
    IF NOT EXISTS (SELECT 1 FROM Products WHERE productId = @prodId)
    BEGIN
        --! ERROR: Product not found
        PRINT 'Error: Product ID ' + @prodId + ' not found. Record update terminated.';
        RETURN; -- Exit the procedure early
    END;

    --* Step 2: Validate price is reasonable
    IF @newPrice <= 0
    BEGIN
        --! ERROR: Invalid price
        PRINT 'Error: Selling price must be greater than 0. Record update terminated.';
        RETURN; -- Exit the procedure early
    END;

    --* Step 3: Perform the update if all validations pass
    UPDATE Products
    SET unitPrice = @newPrice
    WHERE productId = @prodId;

    --? Consider logging this change to an audit table
    PRINT 'Product ' + @prodId + ' price updated successfully to ' + CAST(@newPrice AS VARCHAR) + '.';
END;
GO

--! TEST SCENARIOS

--* Scenario 1: Successful update
EXEC UpdateProductPrice @prodId = 'P004', @newPrice = 5000.00;
SELECT productId, productName, unitPrice FROM Products WHERE productId = 'P004';

--* Scenario 2: Failed update - negative price
EXEC UpdateProductPrice @prodId = 'P004', @newPrice = -100.00;

--* Scenario 3: Failed update - product doesn't exist
EXEC UpdateProductPrice @prodId = 'P999', @newPrice = 6000.00;

--TODO: Enhance procedure to include transaction handling and audit logging