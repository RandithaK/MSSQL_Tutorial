-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! RIGHT JOIN WITH NULL FILTER: Finding Products Never Ordered
--* This demonstrates an important pattern for identifying "orphaned" or unused records
--* using RIGHT JOIN + NULL check (a common inventory management requirement)

--? WHY RIGHT JOIN? We're ensuring ALL products appear, even those with no orders
--? The NULL filter then finds only products that have never appeared in any order

SELECT
    P.productId,
    P.productName,
    P.unitPrice,       -- Product price 
    P.unitInStock,     -- Current stock level
    OD.oid,            --! Will be NULL for never-ordered products
    OD.quantity        --! Will be NULL for never-ordered products
FROM
    orderDetails AS OD -- Left Table
RIGHT JOIN
    Products AS P      -- Right Table (ALL products included)
ON
    OD.productId = P.productId
WHERE
    OD.oid IS NULL;    --* Critical filter: only show products with no matching orders

--! BUSINESS USE CASES:
--* 1. Identify slow-moving inventory that may need promotion
--* 2. Find products that could be discontinued
--* 3. Verify product catalog accuracy against actual sales

--? Alternative approach using NOT EXISTS (often more efficient):
/* 
SELECT 
    P.productId,
    P.productName,
    P.unitPrice,
    P.unitInStock
FROM Products P
WHERE NOT EXISTS (
    SELECT 1 FROM orderDetails OD 
    WHERE OD.productId = P.productId
);
*/

--TODO: Extend query to include how long products have been in inventory without orders