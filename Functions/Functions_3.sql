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

--! TABLE-VALUED FUNCTION WITH FILTERING: Order Products by Price Range
--* Purpose: Returns order details filtered by product price range
--* Input: Order ID and minimum price threshold
--* Output: Table of products meeting the criteria

CREATE FUNCTION productsOverPrice (@orderId INT, @minPrice REAL)
RETURNS TABLE
AS
RETURN
(
    --* Only include products above the specified price threshold
    SELECT 
        P.productId,
        P.productName,
        OD.quantity,
        P.unitPrice,
        (P.unitPrice * OD.quantity) AS LineTotal
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
      AND P.unitPrice > @minPrice
);
GO

-- How to use it:
-- Get 'disk' products for Order ID 1
SELECT * FROM dbo.productsOfOrder(1);

--! USAGE EXAMPLES

--* Example 1: Find all products in order 1 priced over 10000
SELECT * FROM dbo.productsOverPrice(1, 10000);

--* Example 2: With dynamic price threshold
-- DECLARE @threshold REAL = 5000;
-- SELECT * FROM dbo.productsOverPrice(1, @threshold);

--TODO: Add sorting options and additional filter parameters