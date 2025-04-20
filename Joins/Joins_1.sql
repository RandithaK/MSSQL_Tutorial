-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! INNER JOIN: Orders with Customer Information
--* Purpose: Combines order data with corresponding customer details
--* This fundamental join type only shows records where the join condition is satisfied

--? INNER JOIN is the most common join type, showing only matching records
--? It answers the question: "Which orders were placed by which customers?"

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

--! BUSINESS USE CASES:
--* 1. Order reports showing customer information
--* 2. Sales analysis by customer country
--* 3. Customer purchase history tracking

--TODO: Extend with order total calculation