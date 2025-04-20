-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! TABLE-VALUED FUNCTION WITH BUSINESS LOGIC: Conditional Discount Application
--* Purpose: Returns order details with conditional discounts applied
--* Business Rule: Discounts only apply when quantity exceeds 2 items

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
        
        --! CONDITIONAL DISCOUNT LOGIC
        --* Only apply discount when quantity > 2 (business rule)
        CASE
            WHEN OD.quantity > 2 THEN (P.unitPrice * OD.quantity * OD.discount)
            ELSE 0 -- No discount if quantity is 2 or less
        END AS discountAmt,
        
        --* Calculate final payable amount with discount (if applicable)
        --? Note how we reuse the same CASE expression to ensure consistency
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

--! USAGE EXAMPLES

--* Example 1: View detailed order information with conditional discounts
SELECT * FROM dbo.orderInfo(1);

--* Example 2: Summarize total payable amount for the order
-- SELECT 
--     @orderId AS OrderID,
--     SUM(totAmt) AS TotalBeforeDiscount,
--     SUM(discountAmt) AS TotalDiscount,
--     SUM(payAmt) AS FinalAmount
-- FROM dbo.orderInfo(1);

--TODO: Refactor to avoid repeating the CASE expression twice