-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! SCALAR FUNCTION: Order Cost Calculator
--* Purpose: Calculates the total cost of an order based on unit prices and quantities
--* Input: Order ID
--* Output: Total cost as REAL value
CREATE FUNCTION calcCost (@orderId INT)
RETURNS REAL
AS
BEGIN
    DECLARE @totalCost REAL;

    --* Calculate raw sum of (price × quantity) for all order items
    SELECT @totalCost = SUM(P.unitPrice * OD.quantity)
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId;

    --? Safety check: Handle non-existent orders or orders with no items
    IF @totalCost IS NULL
        SET @totalCost = 0.0;

    RETURN @totalCost;
END;
GO

--! USAGE EXAMPLES

--* Example 1: Simple function call to get order total
SELECT dbo.calcCost(1) AS Order1TotalCost;

--* Example 2: Use in a query with multiple orders
-- SELECT oid, dbo.calcCost(oid) AS CalculatedTotal FROM Orders;

--? Example 3: Update order costs in bulk (use with caution)
--? This demonstrates using the function as part of a data update operation
-- UPDATE Orders
-- SET cost = dbo.calcCost(oid)
-- WHERE cost IS NULL;

--TODO: Consider enhancing this function to also apply discounts from orderDetails