-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Procedure to get ROL using an OUTPUT parameter
CREATE PROCEDURE GetProductROL
    @prodId CHAR(4),       -- Input parameter
    @ReorderLevel INT OUTPUT -- Output parameter
AS
BEGIN
    SET NOCOUNT ON;

    SELECT @ReorderLevel = ROL
    FROM Products
    WHERE productId = @prodId;

    -- Handle product not found scenario
    IF @ReorderLevel IS NULL
        PRINT 'Warning: Product ID not found.';
        -- Optionally set a default or error value, e.g., SET @ReorderLevel = -1;

END;
GO

-- How to use it:
DECLARE @rolValue INT; -- Declare a variable to receive the output

EXEC GetProductROL @prodId = 'P003', @ReorderLevel = @rolValue OUTPUT; -- Pass variable with OUTPUT keyword

PRINT 'The Re-Order Level for P003 is: ' + CAST(@rolValue AS VARCHAR);

-- Test with a non-existent product
DECLARE @rolValueNotFound INT;
EXEC GetProductROL @prodId = 'P999', @ReorderLevel = @rolValueNotFound OUTPUT;
PRINT 'The Re-Order Level for P999 is: ' + ISNULL(CAST(@rolValueNotFound AS VARCHAR), 'Not Found');