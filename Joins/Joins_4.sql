-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Left Join Example
-- This SQL query retrieves all employees and their associated departments, including employees without departments.
-- It uses a LEFT JOIN to ensure that all employees are included in the result set, even if they have no associated department.
-- The result set will contain NULL values for the department columns if an employee has no matching department.
-- This is useful for scenarios where you want to see all employees and their associated departments, regardless of whether they are related.

SELECT
    E.eid,
    E.ename,
    D.dname -- Department Name (could be NULL if no match)
FROM
    Employees AS E -- Left Table (All Employees)
LEFT JOIN
    Department AS D -- Right Table
ON
    E.did = D.did; -- Join on Department ID