-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! TRIGGER: Employee Salary Validation
-- This trigger enforces organizational hierarchy by ensuring that no employee
-- can have a salary higher than their direct supervisor
CREATE TRIGGER TR_Employees_CheckSalary
ON Employees -- Trigger on Employees table (using the schema from Trigger Part 2)
AFTER INSERT, UPDATE -- Fires after INSERT or UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    --* Step 1: Check only if the salary column was potentially affected
    IF UPDATE(salary)
    BEGIN
        --* Step 2: Check if any inserted/updated employee's salary exceeds their supervisor's
        IF EXISTS (
            SELECT 1
            FROM inserted i --? New/updated employee data
            JOIN Employees supervisor ON i.supervld = supervisor.eid --? Find the supervisor
            WHERE i.salary > supervisor.salary --? The condition to check
              AND i.supervld IS NOT NULL --? Only check if there IS a supervisor
        )
        BEGIN
            --* Step 3: If the condition is met, raise an error and roll back
            RAISERROR ('Employee salary cannot exceed supervisor''s salary. Transaction rolled back.', 16, 1);
            ROLLBACK TRANSACTION;
            RETURN;
        END;
    END;
END;
GO

--! TEST SCRIPT: Verify Trigger Functionality
--* Step 1: Check current salaries
PRINT 'Supervisor (e001) Salary:';
SELECT salary FROM Employees WHERE eid = 'e001'; --? Saman's salary (70000)

PRINT 'Employee (e002) Salary:';
SELECT salary FROM Employees WHERE eid = 'e002'; --? Kamal's salary (34000), supervisor is e001

--* Step 2: Try updating with valid salary (should work)
PRINT 'Updating Kamal salary (valid)...';
UPDATE Employees SET salary = 60000.00 WHERE eid = 'e002';
SELECT salary FROM Employees WHERE eid = 'e002'; --? Should show 60000

--* Step 3: Try updating with invalid salary (should fail)
PRINT 'Updating Kamal salary (invalid)...';
UPDATE Employees SET salary = 80000.00 WHERE eid = 'e002'; --? This should raise an error

--* Step 4: Verify salary after failed attempt
--? Verify Kamal's salary after the failed attempt (should be rolled back to 60000)
SELECT salary FROM Employees WHERE eid = 'e002';

--* Step 5: Test insert scenario
PRINT 'Inserting new employee (invalid salary)...';
--? Assuming e001's salary is 70000
--? INSERT INTO Employees (eid, ename, birthdate, salary, did, supervld)
--? VALUES ('E008', 'Test', '2000-01-01', 90000.00, 'd001', 'E001'); -- This should raise an error

--TODO: Consider adding logging functionality to track failed salary updates