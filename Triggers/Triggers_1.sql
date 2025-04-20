-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

--! TRIGGER: Stock Re-Order Level Check
-- This trigger monitors product stock levels and automatically creates 
-- re-order notices when stock falls below the defined threshold (ROL)
CREATE TRIGGER TR_Products_CheckROL
ON Products 
AFTER UPDATE -- Fires after an update occurs on Products table
AS
BEGIN
    SET NOCOUNT ON;

    --* Step 1: Check if stock levels were modified in this update
    IF UPDATE(unitInStock)
    BEGIN
        --* Step 2: Find products that need reordering
        INSERT INTO Items_to_Order (ProductId, DateNotified)
        SELECT i.productId, GETDATE()
        FROM inserted i -- 'inserted' contains the rows AFTER the update
        WHERE i.unitInStock < i.ROL -- Check if new stock is below Re-Order Level
          AND NOT EXISTS (
              --? Only create new notice if stock wasn't already below ROL
              --? This prevents duplicate notices when stock fluctuates
              SELECT 1
              FROM deleted d -- 'deleted' contains the rows BEFORE the update
              WHERE d.productId = i.productId AND d.unitInStock < d.ROL
          );
    END;
END;
GO

--TODO: Consider adding email notification functionality to this trigger

--! TEST SCRIPT: Verify Trigger Functionality
-- Step 1: Check current status
PRINT 'Before Update:';
SELECT productId, unitInStock, ROL FROM Products WHERE productId = 'P004'; -- Current stock 15, ROL 20
SELECT * FROM Items_to_Order;

-- Step 2: Simulate stock reduction
PRINT 'Updating P004 stock...';
UPDATE Products SET unitInStock = unitInStock - 5 WHERE productId = 'P004'; -- Stock becomes 10, below ROL (20)

-- Step 3: Verify trigger executed correctly
PRINT 'After Update:';
SELECT productId, unitInStock, ROL FROM Products WHERE productId = 'P004';
SELECT * FROM Items_to_Order; -- Should now contain an entry for P004

--? Additional Test Case (commented out to prevent execution)
-- Update stock but stay above ROL (should not trigger insert)
-- UPDATE Products SET unitInStock = 60 WHERE productId = 'P001'; -- Stock 60, ROL 50
-- SELECT * FROM Items_to_Order;