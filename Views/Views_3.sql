-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- View for USA Customers with Check Option
CREATE VIEW UsaCustomersView AS
SELECT cid, name, phone, country
FROM Customers
WHERE country = 'USA'
WITH CHECK OPTION; -- Ensures modifications keep country = 'USA'
GO

-- How to use it:
SELECT * FROM UsaCustomersView;

-- This UPDATE should work
UPDATE UsaCustomersView SET phone = '1112223333' WHERE cid = 'C002';

-- This INSERT should work
-- INSERT INTO UsaCustomersView (cid, name, phone, country) VALUES ('C005', 'Peter', '2223334444', 'USA');

-- This UPDATE should FAIL because it violates the WHERE clause
-- UPDATE UsaCustomersView SET country = 'Canada' WHERE cid = 'C002';
-- (Msg 550, Level 16, State 1, Line ...)
-- (The attempted insert or update failed because the target view either specifies WITH CHECK OPTION ...)

-- This INSERT should FAIL
-- INSERT INTO UsaCustomersView (cid, name, phone, country) VALUES ('C006', 'Anil', '077...', 'Sri Lanka');
-- (Msg 550, Level 16, State 1, Line ...)

-- Clean up the test insert if it worked
-- DELETE FROM Customers WHERE cid = 'C005';