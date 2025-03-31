-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Function to get detailed info for each order item
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
        -- Calculate discount amount: total amount * discount rate
        (P.unitPrice * OD.quantity * OD.discount) AS discountAmt,
        -- Calculate payable amount: total amount - discount amount
        (P.unitPrice * OD.quantity) - (P.unitPrice * OD.quantity * OD.discount) AS payAmt
        -- Alternative payAmt: (P.unitPrice * OD.quantity * (1 - OD.discount))
    FROM orderDetails OD
    JOIN Products P ON OD.productId = P.productId
    WHERE OD.oid = @orderId
);
GO

-- How to use it:
-- Get detailed info for Order ID 1
SELECT * FROM dbo.orderInfo(1);