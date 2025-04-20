-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! SIMPLE VIEW: Sri Lankan Customers
--* Purpose: Creates a filtered view of customers from Sri Lanka
--* Demonstrates basic view creation for data abstraction

CREATE VIEW SriLankanCustomers AS
SELECT cid, name, phone
FROM Customers
WHERE country = 'Sri Lanka';
GO

--! USAGE EXAMPLES

--* Basic usage - retrieve all Sri Lankan customers
SELECT * FROM SriLankanCustomers;

--* Join with other tables using the view
-- SELECT 
--     SLC.name AS CustomerName,
--     O.oid AS OrderID,
--     O.orderDate AS OrderDate
-- FROM SriLankanCustomers SLC
-- JOIN Orders O ON SLC.cid = O.cid;

--TODO: Consider adding more customer details to the view