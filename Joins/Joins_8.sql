-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! CROSS JOIN: All Possible Customer-Product Combinations
--* Purpose: Creates a cartesian product between customers and products
--* This join produces every possible combination of records from both tables

--? CROSS JOIN does not require a join condition
--? It's useful for generating combinations for pricing scenarios or product offerings

SELECT
    C.cid,               -- Customer ID
    C.name,              -- Customer Name
    P.productId,         -- Product ID
    P.productName,       -- Product Name
    P.unitPrice          -- Unit Price
FROM
    Customers AS C       -- First Table
CROSS JOIN
    Products AS P;       -- Second Table (No ON clause needed)

--! BUSINESS USE CASES:
--* 1. Creating product catalogs customized for each customer
--* 2. Generating potential sales scenarios for forecasting
--* 3. Building decision matrices for product recommendations

--TODO: Add filtering to exclude certain products or customers