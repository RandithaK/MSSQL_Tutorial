-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! VIEW WITH CHECK OPTION: USA Customers Filter
--* Purpose: Demonstrates data integrity enforcement using WITH CHECK OPTION
--* This view restricts access to only USA customers and prevents modifications 
--* that would make rows invisible to the view

CREATE VIEW UsaCustomersView AS
SELECT cid, name, phone, country
FROM Customers
WHERE country = 'USA'
WITH CHECK OPTION; --! Critical clause that enforces the WHERE condition on all modifications
GO

--! USAGE EXAMPLES

--* 1. Basic view query - shows only USA customers
SELECT * FROM UsaCustomersView;

--* 2. Valid modification - doesn't change filtered column
UPDATE UsaCustomersView SET phone = '1112223333' WHERE cid = 'C002';

--? 3. Valid insert - maintains the filter criteria
-- INSERT INTO UsaCustomersView (cid, name, phone, country) VALUES ('C005', 'Peter', '2223334444', 'USA');

--! ERROR CASES

--* 4. Invalid update - attempts to change the filtered column (will fail)
-- UPDATE UsaCustomersView SET country = 'Canada' WHERE cid = 'C002';
--? Error message: Msg 550, Level 16, State 1
--? The attempted update failed because the target view specifies WITH CHECK OPTION

--* 5. Invalid insert - violates the filter condition (will fail)
-- INSERT INTO UsaCustomersView (cid, name, phone, country) VALUES ('C006', 'Anil', '077...', 'Sri Lanka');
--? Same error as above - the insert is rejected by CHECK OPTION

--* Cleanup test data
-- DELETE FROM Customers WHERE cid = 'C005';

--TODO: Consider creating similar CHECK OPTION views for other regions