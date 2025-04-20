-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! LEFT JOIN: All Customers with Their Orders
--* Purpose: Shows all customers and any orders they've placed
--* Demonstrates how LEFT JOIN preserves all records from the "left" table (Customers)

--? LEFT JOIN ensures all customers appear in results, even if they haven't placed orders
--? This is critical for customer activity analysis and identifying inactive customers

INSERT INTO Customers (cid, name, phone, country)
VALUES ('C004', 'Nayana', '0761112233', 'Sri Lanka');
GO

SELECT
    C.cid,               -- Customer ID
    C.name,              -- Customer Name
    C.country,           -- Customer Country
    O.oid,               --! NULL indicates customer with no orders 
    O.orderDate          --! NULL indicates customer with no orders
FROM
    Customers AS C       --* Left Table (ALL customers will be included)
LEFT JOIN
    Orders AS O          --* Right Table (matching only if exists)
ON
    C.cid = O.cid;       --* Join condition based on customer ID

--! BUSINESS USE CASES:
--* 1. Identifying customers who haven't placed orders yet
--* 2. Complete customer reporting regardless of activity
--* 3. Customer engagement and retention analysis  

--TODO: Add order count and total spend per customer