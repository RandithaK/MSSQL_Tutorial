-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Modify the function to filter by product name
ALTER FUNCTION productsOfOrder (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT P.productName, OD.quantity
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId AND P.productName LIKE '%Disk%'
);
GO

-- How to use it:
-- Get 'disk' products for Order ID 1
SELECT * FROM dbo.productsOfOrder(1);