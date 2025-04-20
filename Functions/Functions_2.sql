-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! TABLE-VALUED FUNCTION: Order Products Lookup
--* Purpose: Returns a table containing products and quantities for a specific order
--* Input: Order ID
--* Output: Table with productName and quantity columns
CREATE FUNCTION productsOfOrder (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    --* Join orderDetails with Products to get product names
    SELECT 
        P.productName,  -- Name of ordered product
        OD.quantity     -- Quantity ordered
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

--! USAGE EXAMPLES

--* Basic usage - retrieve all products in order #1
SELECT * FROM dbo.productsOfOrder(1);

--* Advanced usage - filter results from the function
-- SELECT productName, quantity 
-- FROM dbo.productsOfOrder(1)
-- WHERE quantity > 2;

--* Join with other tables for more complex queries
-- SELECT 
--     O.orderDate,
--     PO.productName,
--     PO.quantity
-- FROM Orders O
-- CROSS APPLY dbo.productsOfOrder(O.oid) PO;

--TODO: Enhance to include product prices and calculated line totals
