-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This SQL query retrieves all customers and their orders, including customers without orders and orders without customers.
-- It uses a FULL OUTER JOIN to ensure that all records from both tables are included in the result set.
-- The result set will contain NULL values for the columns of the table that does not have a matching record.
-- This is useful for scenarios where you want to see all customers and all orders, regardless of whether they are related.
SELECT
    C.cid,
    C.name,
    O.oid,
    O.orderDate
FROM
    Customers AS C -- Left Table
FULL OUTER JOIN
    Orders AS O    -- Right Table
ON
    C.cid = O.cid  -- Join condition
ORDER BY
    C.cid, O.oid;