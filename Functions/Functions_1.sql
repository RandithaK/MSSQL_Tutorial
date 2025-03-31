-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Function to calculate the total cost of a given order
CREATE FUNCTION calcCost (@orderId INT)
RETURNS REAL
AS
BEGIN
    DECLARE @totalCost REAL;

    SELECT @totalCost = SUM(P.unitPrice * OD.quantity)
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId;

    -- Handle cases where the order ID doesn't exist or has no items
    IF @totalCost IS NULL
        SET @totalCost = 0.0;

    RETURN @totalCost;
END;
GO

-- How to use it:
-- Calculate cost for Order ID 1
SELECT dbo.calcCost(1) AS Order1TotalCost;

-- You could even update the Orders table using this function (use with caution)
-- UPDATE Orders
-- SET cost = dbo.calcCost(oid)
-- WHERE oid = 1;
-- SELECT * FROM Orders WHERE oid = 1;