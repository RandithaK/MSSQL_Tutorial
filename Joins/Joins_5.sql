-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! RIGHT JOIN: All Orders with Customers
--* Purpose: Shows all orders including those without matching customer records
--* Demonstrates RIGHT JOIN preserving all records from "right" table (Orders)

--? RIGHT JOIN is like LEFT JOIN with tables reversed
--? It ensures all orders appear, regardless of customer match

SELECT
    O.oid,               -- Order ID
    O.orderDate,         -- Order Date
    C.cid,               --! NULL indicates order with no customer record
    C.name,              --! NULL indicates order with no customer record
    C.country            --! NULL indicates order with no customer record
FROM
    Customers AS C       --* Left Table
RIGHT JOIN
    Orders AS O          --* Right Table (ALL orders will be included)
ON
    C.cid = O.cid;       --* Join condition based on customer ID

--! BUSINESS USE CASES:
--* 1. Audit for orphaned order records
--* 2. Data quality checking
--* 3. Complete order reporting regardless of customer data integrity

--TODO: Add additional order details and status information