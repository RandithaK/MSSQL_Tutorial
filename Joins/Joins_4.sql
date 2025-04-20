-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! LEFT JOIN: Employees with Departments
--* Purpose: This query retrieves all employees and their associated departments
--* Demonstrates how LEFT JOIN preserves all records from the "left" table (Employees)
--* even when there's no corresponding match in the "right" table (Departments)

--? LEFT JOIN ensures employees with no department assignment still appear
--? This is critical for HR reporting where you need a complete employee list

SELECT
    E.eid AS EmployeeID,
    E.ename AS EmployeeName,
    D.dname AS DepartmentName  --! NULL indicates employee without department assignment
FROM
    Employees AS E  --* Left Table (ALL employees will be included)
LEFT JOIN
    Department AS D --* Right Table (matching only if exists)
ON
    E.did = D.did;  --* Join condition based on department ID

--! BUSINESS USE CASES:
--* 1. HR reports requiring complete employee lists
--* 2. Finding employees not assigned to any department
--* 3. Auditing department assignments

--TODO: Extend query to include additional employment details