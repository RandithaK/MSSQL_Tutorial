-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! TABLE-VALUED FUNCTION: Detailed Order Information
--* Purpose: Returns comprehensive product and pricing details for an order
--* Input: Order ID
--* Output: Table with detailed line item information and calculations

CREATE FUNCTION orderInfo (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.productName,
        OD.quantity AS qty,
        P.unitPrice AS unitAmt,
        (P.unitPrice * OD.quantity) AS totAmt,
        (P.unitPrice * OD.quantity * OD.discount) AS discountAmt,
        (P.unitPrice * OD.quantity * (1 - OD.discount)) AS payAmt
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

--! USAGE EXAMPLES

--* Example 1: Retrieve detailed information for Order #1
SELECT * FROM dbo.orderInfo(1);

--* Example 2: Calculate order summary metrics
-- SELECT 
--     SUM(totAmt) AS TotalBeforeDiscount,
--     SUM(discountAmt) AS TotalDiscount,
--     SUM(payAmt) AS FinalAmount
-- FROM dbo.orderInfo(1);

--TODO: Add product category and inventory information