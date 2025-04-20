-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! SELF JOIN: Employee-Supervisor Relationship
--* This query demonstrates the powerful self-join technique where a table is joined with itself
--* In this example, we show a hierarchical relationship between employees and their supervisors

--? CONCEPT: Self-joining allows us to represent and query hierarchical relationships
--? within a single table without needing a separate "supervisors" table

--* KEY POINTS:
--* 1. Same table (Employees) is used twice with different aliases
--* 2. LEFT JOIN preserves employees without supervisors (e.g., CEO)
--* 3. The supervld column links an employee to their supervisor's eid

SELECT
    Emp.eid AS EmployeeID,
    Emp.ename AS EmployeeName,
    Emp.salary AS EmployeeSalary,
    Sup.eid AS SupervisorID,
    Sup.ename AS SupervisorName,
    Sup.salary AS SupervisorSalary
FROM
    Employees AS Emp  -- First instance represents each employee record
LEFT JOIN 
    Employees AS Sup  -- Second instance represents potential supervisors
ON
    Emp.supervld = Sup.eid; -- Employee's supervisor ID matches supervisor's employee ID

--! VISUALIZATION OF THE JOIN
/*
 Employee Table (as Emp)        Employee Table (as Sup)
 +---------+---------+          +---------+---------+
 | eid     | supervld|          | eid     | name    |
 +---------+---------+          +---------+---------+
 | E001    | null    |---+      | E001    | Kasun   |
 | E003    | null    |---+      | E003    | Saman   |
 | E004    | E003    |--------->| E003    | Saman   |
 | E005    | E003    |--------->| E003    | Saman   |
 +---------+---------+          +---------+---------+
*/

--TODO: Extend this query to show multiple levels of hierarchy (supervisor's supervisor)