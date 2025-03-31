-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This SQL query retrieves all products from the Products table and their corresponding order details from the orderDetails table.
-- It uses a RIGHT JOIN to ensure that all products are included in the result set, even if they have never been ordered.
-- The result set will contain NULL values for the order details columns if a product has never been ordered.
SELECT
    P.productId,
    P.productName,
    OD.oid,         -- Order ID (NULL if never ordered)
    OD.quantity     -- Quantity (NULL if never ordered)
FROM
    orderDetails AS OD -- Left Table
RIGHT JOIN
    Products AS P      -- Right Table (We want ALL Products)
ON
    OD.productId = P.productId
WHERE
    OD.oid IS NULL;   -- Filter for products with no matching order details