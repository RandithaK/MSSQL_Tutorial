-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! FULL OUTER JOIN: All Customers and All Orders
--* Purpose: Demonstrates how to retrieve complete sets from both tables
--* regardless of whether corresponding records exist in the other table

--? When to use FULL OUTER JOIN:
--? 1. Data integrity checks - finding "orphaned" records in either table
--? 2. Comprehensive reporting requiring ALL records from both sides
--? 3. Migration scenarios when verifying data completeness

SELECT
    C.cid AS CustomerID,
    C.name AS CustomerName,
    --! NULL indicates customer without orders
    O.oid AS OrderID,  
    O.orderDate AS OrderDate,
    --* Add visual indicator for orphaned records
    CASE 
        WHEN C.cid IS NULL THEN 'Orphaned Order' 
        WHEN O.oid IS NULL THEN 'Customer with No Orders'
        ELSE 'Matched Record'
    END AS RecordStatus
FROM
    Customers AS C -- Left Table
FULL OUTER JOIN
    Orders AS O    -- Right Table
ON
    C.cid = O.cid  -- Join condition
ORDER BY
    C.cid, O.oid;

--! VISUAL REPRESENTATION
/*
  Customers            Orders
  +-----+------+      +-----+-----+------+
  | cid | name |      | oid | cid | date |
  +-----+------+      +-----+-----+------+
  | C001| Saman|----->| 1   | C001| 2020 |  <- Matching records
  | C002| John |      | 2   | C003| 2023 |  
  | C003|Mashato|---->| ... | ... | ...  |  
  +-----+------+      +-----+-----+------+
       ^                     ^
       |                     |
  These records           These records
  appear even with        appear even with
  no matching orders      no matching customers
*/

--TODO: Extend with statistical analysis of unmatched records