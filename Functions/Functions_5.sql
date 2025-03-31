-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Modify orderInfo to apply discount only if quantity > 2
ALTER FUNCTION orderInfo (@orderId INT)
RETURNS TABLE
AS
RETURN
(
    SELECT
        P.productName,
        OD.quantity AS qty,
        P.unitPrice AS unitAmt,
        (P.unitPrice * OD.quantity) AS totAmt,
        -- Apply discount amount conditionally using CASE
        CASE
            WHEN OD.quantity > 2 THEN (P.unitPrice * OD.quantity * OD.discount)
            ELSE 0 -- No discount if quantity is 2 or less
        END AS discountAmt,
        -- Calculate payable amount based on the potentially zero discountAmt
        (P.unitPrice * OD.quantity) -
            (CASE
                WHEN OD.quantity > 2 THEN (P.unitPrice * OD.quantity * OD.discount)
                ELSE 0
            END)
        AS payAmt
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

-- How to use it:
-- Get detailed info for Order ID 1 with conditional discount
SELECT * FROM dbo.orderInfo(1);