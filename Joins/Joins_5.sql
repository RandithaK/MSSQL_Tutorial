-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Right Join Example
-- This SQL query retrieves all orders and their associated employees, including orders without employees.
-- It uses a RIGHT JOIN to ensure that all orders are included in the result set, even if they have no associated employee.
-- The result set will contain NULL values for the employee columns if an order has no matching employee.
-- This is useful for scenarios where you want to see all orders and their associated employees, regardless of whether they are related.
SELECT
    O.oid,
    O.orderDate,
    E.eid,       -- Employee ID (will be NULL if no matching employee)
    E.ename      -- Employee Name (will be NULL if no matching employee)
FROM
    Employees AS E -- Left Table
RIGHT JOIN
    Orders AS O    -- Right Table (We want ALL orders)
ON
    E.eid = O.eid; -- Join condition