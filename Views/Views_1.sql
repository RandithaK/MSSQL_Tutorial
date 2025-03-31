-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- View for Sri Lankan Customers
CREATE VIEW SriLankanCustomers AS
SELECT cid, name, phone
FROM Customers
WHERE country = 'Sri Lanka';
GO

-- How to use it:
SELECT * FROM SriLankanCustomers;

-- Try inserting (will likely work as it's based on one table and includes necessary columns if no defaults)
-- INSERT INTO SriLankanCustomers (cid, name, phone) VALUES ('C004', 'Nimal', '0711234567');
-- SELECT * FROM Customers; -- Verify if C004 was added