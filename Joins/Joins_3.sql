-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This script demonstrates a LEFT JOIN between Customers and Orders tables.
-- It retrieves all customers and their orders, including customers who have not placed any orders.
-- The result set will include NULL values for the order columns if a customer has no matching order.
-- This is useful for scenarios where you want to see all customers and their orders, regardless of whether they have placed any orders.
INSERT INTO Customers (cid, name, phone, country)
VALUES ('C004', 'Nayana', '0761112233', 'Sri Lanka');
GO

SELECT
    C.cid,          -- Customer ID
    C.name,         -- Customer Name
    O.oid,          -- Order ID (will be NULL if no order)
    O.orderDate     -- Order Date (will be NULL if no order)
FROM
    Customers AS C  -- Left Table (We want ALL customers)
LEFT JOIN
    Orders AS O     -- Right Table
ON
    C.cid = O.cid   -- Join condition
ORDER BY
    C.cid;