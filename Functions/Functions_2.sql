-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Function to get product names and quantities for an order
CREATE FUNCTION productsOfOrder (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT P.productName, OD.quantity
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

-- How to use it:
-- Get products for Order ID 1
SELECT * FROM dbo.productsOfOrder(1);
