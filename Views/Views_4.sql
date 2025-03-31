-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- View joining Department and Employee (for manager details)
CREATE VIEW DeptMgr_Details AS
SELECT
    D.did,
    D.dname,
    D.budget,
    D.mgrid,
    E.ename AS mgrname,
    E.salary AS MgrSalary,
    E.supervld AS MgrSupervisorId -- Manager's supervisor
FROM Department D
LEFT JOIN Employees E ON D.mgrid = E.eid; -- Use LEFT JOIN if a dept might not have a manager assigned yet
GO

-- How to use it:
SELECT * FROM DeptMgr_Details;