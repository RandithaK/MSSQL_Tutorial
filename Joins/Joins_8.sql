-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This SQL script demonstrates the use of a CROSS JOIN to create a Cartesian product between two tables: Customers and Products.
-- It selects the customer names and the products offered, resulting in a combination of every customer with every product.
-- This is useful for scenarios where you want to see all possible combinations of customers and products.
-- The script uses the CROSS JOIN syntax, which is a straightforward way to achieve this Cartesian product.
SELECT
    C.name AS CustomerName,
    P.productName AS ProductOffered
FROM
    Customers AS C
CROSS JOIN
    Products AS P;

-- Older (less recommended) syntax that produces the same result:
-- SELECT C.name, P.productName FROM Customers C, Products P;
-- (If you forget a WHERE clause here, you get a CROSS JOIN)