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

--! STORED PROCEDURE WITH OUTPUT PARAMETER: Total Order Value Calculator
--* Purpose: Calculates the total value of an order with discount applied
--* Demonstrates using OUTPUT parameters to return values

CREATE PROCEDURE CalcOrderAmount
    @orderId INT,                  -- Input: Order ID to calculate
    @totalAmount MONEY OUTPUT      -- Output: Calculated order total
AS
BEGIN
    SET NOCOUNT ON;

    --* Calculate the order total with discounts applied
    SELECT @totalAmount = SUM(P.unitPrice * OD.quantity * (1 - OD.discount))
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId;

    --? Handle case where order doesn't exist or has no items
    IF @totalAmount IS NULL
        SET @totalAmount = 0;
END;
GO

--! USAGE EXAMPLES

--* Example 1: Calculate and display order total
DECLARE @total MONEY;
EXEC CalcOrderAmount @orderId = 1, @totalAmount = @total OUTPUT;
SELECT @total AS OrderTotal;

--* Example 2: Using the output in subsequent operations
-- DECLARE @total MONEY, @tax MONEY;
-- EXEC CalcOrderAmount @orderId = 1, @totalAmount = @total OUTPUT;
-- SET @tax = @total * 0.15; -- Calculate 15% tax
-- SELECT @total AS OrderTotal, @tax AS Tax, @total + @tax AS TotalWithTax;

--TODO: Add currency parameter and currency conversion functionality