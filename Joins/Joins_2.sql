-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This SQL query retrieves details of a specific order by joining the orderDetails table with the Products table.
-- It uses an INNER JOIN to ensure that only records with matching product IDs in both tables are included.
-- The result set will contain details of the order, including the product name, quantity, unit price, and discount.
-- This is useful for scenarios where you want to see the details of a specific order and the products associated with it.
SELECT
    OD.oid,         -- Order ID from orderDetails
    P.productName,  -- Product Name from Products
    OD.quantity,    -- Quantity from orderDetails
    P.unitPrice,    -- Unit Price from Products
    OD.discount     -- Discount from orderDetails
FROM
    orderDetails AS OD
INNER JOIN
    Products AS P
ON
    OD.productId = P.productId -- Join based on the product ID
WHERE
    OD.oid = 1;     -- Filter for a specific order