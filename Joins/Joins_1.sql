-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This SQL query retrieves order details along with customer information by performing an inner join between the Orders and Customers tables.
-- It selects the order ID, order date, customer name, and customer country.
-- The join condition is based on the customer ID, ensuring that only orders with matching customers are included in the result set.
-- This is useful for scenarios where you want to see the details of orders along with the associated customer information.
SELECT
    O.oid,          -- Order ID from Orders table
    O.orderDate,    -- Order Date from Orders table
    C.name,         -- Customer Name from Customers table
    C.country       -- Customer Country from Customers table
FROM
    Orders AS O     -- Alias 'O' for the Orders table (left table)
INNER JOIN
    Customers AS C  -- Alias 'C' for the Customers table (right table)
ON
    O.cid = C.cid;  -- The join condition: match customer IDs