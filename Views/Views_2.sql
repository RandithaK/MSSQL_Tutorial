-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- View for Detailed Order Info (Mimicking the function)
CREATE VIEW DetailedOrderInfo AS
SELECT
    O.oid,
    O.orderDate,
    C.name AS CustomerName,
    E.ename AS EmployeeName,
    P.productName,
    OD.quantity,
    P.unitPrice,
    (P.unitPrice * OD.quantity) AS TotalProductPrice,
    OD.discount,
    (P.unitPrice * OD.quantity * (1 - OD.discount)) AS PayableProductPrice
FROM Orders O
JOIN Customers C ON O.cid = C.cid
JOIN Employees E ON O.eid = E.eid
JOIN orderDetails OD ON O.oid = OD.oid
JOIN Products P ON OD.productId = P.productId;
GO

-- How to use it:
SELECT * FROM DetailedOrderInfo WHERE oid = 1;

-- Try updating (will likely FAIL because it involves multiple base tables)
-- UPDATE DetailedOrderInfo SET quantity = 4 WHERE oid = 1 AND productName = 'Hard Disk';
-- (This will typically result in an error)