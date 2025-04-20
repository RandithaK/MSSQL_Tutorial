-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! COMPLEX VIEW: Detailed Order Information
--* Purpose: Creates a comprehensive view joining multiple tables
--* Provides a single access point for order reporting

CREATE VIEW OrderDetailView AS
SELECT 
    O.oid AS OrderID,
    O.orderDate AS OrderDate,
    O.shippedDate AS ShippedDate,
    C.cid AS CustomerID,
    C.name AS CustomerName,
    C.country AS CustomerCountry,
    E.eid AS EmployeeID,
    E.ename AS EmployeeName,
    P.productId AS ProductID,
    P.productName AS ProductName,
    OD.quantity AS Quantity,
    P.unitPrice AS UnitPrice,
    OD.discount AS DiscountRate,
    (P.unitPrice * OD.quantity) AS GrossAmount,
    (P.unitPrice * OD.quantity * OD.discount) AS DiscountAmount,
    (P.unitPrice * OD.quantity * (1 - OD.discount)) AS NetAmount
FROM Orders O
JOIN Customers C ON O.cid = C.cid
JOIN Employees E ON O.eid = E.eid
JOIN orderDetails OD ON O.oid = OD.oid
JOIN Products P ON OD.productId = P.productId;
GO

--! USAGE EXAMPLES

--* Basic usage - retrieve all order details
SELECT * FROM OrderDetailView;

--* Filtering and aggregation using the view
-- SELECT 
--     CustomerName,
--     CustomerCountry,
--     COUNT(DISTINCT OrderID) AS TotalOrders,
--     SUM(NetAmount) AS TotalSpend
-- FROM OrderDetailView
-- GROUP BY CustomerName, CustomerCountry
-- ORDER BY TotalSpend DESC;

--TODO: Add order status and delivery time calculations