-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! VIEW: Department Manager Details
-- This view joins Department and Employees tables to provide a consolidated
-- view of department information along with their assigned manager details
CREATE VIEW DeptMgr_Details AS
SELECT
    D.did,                                     -- Department ID
    D.dname,                                   -- Department Name
    D.budget,                                  -- Department Budget
    D.mgrid,                                   -- Manager ID reference
    E.ename AS mgrname,                        -- Manager Name
    --* Age calculation derived from birthdate column
    DATEDIFF(YEAR, E.birthdate, GETDATE()) AS MgrAge,
    E.salary AS MgrSalary,                     -- Manager Salary
    E.supervld AS MgrSupervisorId              -- Manager's own supervisor
FROM Department D
--? LEFT JOIN ensures departments without assigned managers still appear in results
LEFT JOIN Employees E ON D.mgrid = E.eid;
GO

--! USAGE EXAMPLES
-- Basic usage - retrieve all departments with manager details:
SELECT * FROM DeptMgr_Details;

--? Filter for departments with high-budget managers:
-- SELECT * FROM DeptMgr_Details WHERE budget > 400000 AND MgrSalary > 60000;

--TODO: Consider creating an indexed view if this query is frequently used