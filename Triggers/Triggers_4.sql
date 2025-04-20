-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! INSTEAD OF TRIGGER: View-Based Department Creation
--* Purpose: Intercepts INSERT operations on the DeptMgr_Details view
--* Demonstrates how to make a complex view updatable with custom logic

CREATE TRIGGER TR_DeptMgrDetails_InsteadOfInsert
ON DeptMgr_Details 
INSTEAD OF INSERT 
AS
BEGIN
    SET NOCOUNT ON;

    --! Input Validation
    --* Step 1: Check for required fields
    IF EXISTS (SELECT 1 FROM inserted WHERE did IS NULL OR dname IS NULL)
    BEGIN
        RAISERROR('Department ID and Name are required.', 16, 1);
        RETURN;
    END;

    --* Step 2: Verify manager exists if specified
    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN Employees E ON i.mgrid = E.eid 
               WHERE i.mgrid IS NOT NULL AND E.eid IS NULL)
    BEGIN
        RAISERROR('Specified Manager ID (mgrid) does not exist in the Employees table.', 16, 1);
        RETURN;
    END;

    --* Step 3: Check for duplicate department ID
    IF EXISTS (SELECT 1 FROM Department D JOIN inserted i ON D.did = i.did)
    BEGIN
        RAISERROR('Department ID already exists.', 16, 1);
        RETURN;
    END;

    --! Perform actual insert into base table
    INSERT INTO Department (did, dname, budget, mgrid)
    SELECT
        i.did,
        i.dname,
        i.budget, --? Takes budget from the view insert statement
        i.mgrid   --? Takes manager ID from the view insert statement
    FROM inserted i;

    PRINT 'Department record(s) inserted successfully via view.';
END;
GO

--! TEST SCENARIOS

--* Scenario 1: View current departments
SELECT * FROM DeptMgr_Details ORDER BY did;

--* Scenario 2: Insert valid department with existing manager
PRINT 'Inserting d005 via view (valid)...';
INSERT INTO DeptMgr_Details (did, dname, budget, mgrid, mgrname, MgrAge, MgrSalary, MgrSupervisorId)
VALUES ('d005', 'Marketing', 450000.00, 'E004', NULL, NULL, NULL, NULL);

--* Verification query
SELECT * FROM Department WHERE did = 'd005';
SELECT * FROM DeptMgr_Details WHERE did = 'd005';

--? Additional test cases (commented out to prevent execution)
--? Test invalid manager ID:
-- INSERT INTO DeptMgr_Details (did, dname, budget, mgrid)
-- VALUES ('d006', 'Research', 600000.00, 'E999');

--? Test duplicate department ID:
-- INSERT INTO DeptMgr_Details (did, dname, budget, mgrid)
-- VALUES ('d001', 'HR New', 300000.00, 'E002');