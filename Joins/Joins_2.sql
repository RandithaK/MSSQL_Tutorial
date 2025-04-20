-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! INNER JOIN: Order Details with Product Information
--* Purpose: Combines order line items with their corresponding product details
--* This join enriches order details with product names and pricing information

--? This query is essential for generating detailed order reports and invoices
--? It answers the question: "What products were included in each order?"

SELECT
    OD.oid,              -- Order ID
    P.productName,       -- Product Name
    OD.quantity,         -- Quantity Ordered
    P.unitPrice,         -- Unit Price
    OD.discount,         -- Discount Rate
    (P.unitPrice * OD.quantity) AS totalAmount, -- Raw Total
    (P.unitPrice * OD.quantity * (1 - OD.discount)) AS discountedAmount -- After Discount
FROM
    orderDetails AS OD   -- Alias 'OD' for the Order Details table
INNER JOIN
    Products AS P        -- Alias 'P' for the Products table
ON
    OD.productId = P.productId; -- Join condition: match product IDs

--! BUSINESS USE CASES:
--* 1. Invoice generation with product details
--* 2. Sales analysis by product
--* 3. Discount effectiveness reporting

--TODO: Add grouping by order ID with order subtotals