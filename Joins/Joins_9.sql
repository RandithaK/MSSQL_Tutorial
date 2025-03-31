-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- This SQL query retrieves employee and supervisor information from the Employee table.
-- It uses a LEFT JOIN to include all employees, even those without a supervisor (e.g., the CEO).
-- The query selects the employee's ID, name, and salary, as well as the supervisor's ID, name, and salary.
-- This is an Example of a self-join, where the same table is joined with itself to get related data.
SELECT
    Emp.eid AS EmployeeID,
    Emp.ename AS EmployeeName,
    Emp.salary AS EmployeeSalary,
    Sup.eid AS SupervisorID,
    Sup.ename AS SupervisorName,
    Sup.salary AS SupervisorSalary
FROM
    Employees AS Emp  -- Instance 1: Represents the Employee
LEFT JOIN -- Use LEFT JOIN to include employees with NO supervisor (e.g., the CEO)
    Employees AS Sup  -- Instance 2: Represents the Supervisor
ON
    Emp.supervld = Sup.eid; -- Join condition: Employee's supervisor ID matches Supervisor's employee ID