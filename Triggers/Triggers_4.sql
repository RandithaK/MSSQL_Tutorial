-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- INSTEAD OF trigger on the DeptMgr_Details view for INSERTs
CREATE TRIGGER TR_DeptMgrDetails_InsteadOfInsert
ON DeptMgr_Details -- Trigger is on the VIEW
INSTEAD OF INSERT -- Fires INSTEAD OF the insert operation on the view
AS
BEGIN
    SET NOCOUNT ON;

    -- Insert into the base table(s) using data from the 'inserted' virtual table (which matches the view structure)

    -- Validation: Check if required values are provided and if manager exists
    IF EXISTS (SELECT 1 FROM inserted WHERE did IS NULL OR dname IS NULL)
    BEGIN
        RAISERROR('Department ID and Name are required.', 16, 1);
        RETURN;
    END;

    IF EXISTS (SELECT 1 FROM inserted i LEFT JOIN Employees E ON i.mgrid = E.eid WHERE i.mgrid IS NOT NULL AND E.eid IS NULL)
    BEGIN
        RAISERROR('Specified Manager ID (mgrid) does not exist in the Employees table.', 16, 1);
        RETURN;
    END;

    -- Check if department already exists
     IF EXISTS (SELECT 1 FROM Department D JOIN inserted i ON D.did = i.did)
    BEGIN
        RAISERROR('Department ID already exists.', 16, 1);
        RETURN;
    END;


    -- Perform the actual insert into the base table (Department)
    -- We are ONLY inserting into Department here. Inserting into Employee based on view data is tricky.
    INSERT INTO Department (did, dname, budget, mgrid)
    SELECT
        i.did,
        i.dname,
        i.budget, -- Takes budget from the view insert statement
        i.mgrid   -- Takes manager id from the view insert statement
    FROM inserted i;

    PRINT 'Department record(s) inserted successfully via view.';

END;
GO

-- How to test it:
SELECT * FROM DeptMgr_Details ORDER BY did;

-- Try inserting a new Department via the View (Manager e004 exists)
PRINT 'Inserting d005 via view (valid)...';
INSERT INTO DeptMgr_Details (did, dname, budget, mgrid, mgrname, MgrSalary, MgrSupervisorId)
VALUES ('d005', 'Marketing', 450000.00, 'e004', NULL, NULL, NULL); -- Manager details in the VALUES are ignored by this trigger

-- Verify in base table and view
SELECT * FROM Department WHERE did = 'd005';
SELECT * FROM DeptMgr_Details WHERE did = 'd005';

-- Try inserting with a non-existent manager (should fail)
PRINT 'Inserting d006 via view (invalid manager)...';
-- INSERT INTO DeptMgr_Details (did, dname, budget, mgrid)
-- VALUES ('d006', 'Research', 600000.00, 'e999'); -- e999 does not exist

-- Try inserting a duplicate department ID (should fail)
PRINT 'Inserting d001 again via view (duplicate)...';
-- INSERT INTO DeptMgr_Details (did, dname, budget, mgrid)
-- VALUES ('d001', 'HR New', 300000.00, 'e002');