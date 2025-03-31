-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Trigger to add items to Items_to_Order when stock falls below ROL
CREATE TRIGGER TR_Products_CheckROL
ON Products -- Trigger is on the Products table
AFTER UPDATE -- Fires after an update occurs
AS
BEGIN
    SET NOCOUNT ON;

    -- Check if the unitInStock column was actually part of the update
    IF UPDATE(unitInStock)
    BEGIN
        -- Insert into Items_to_Order for products where the new stock is below ROL
        -- and the old stock (if available) was not below ROL (optional, prevents duplicates if stock fluctuates near ROL)
        INSERT INTO Items_to_Order (ProductId, DateNotified)
        SELECT i.productId, GETDATE()
        FROM inserted i -- 'inserted' contains the rows AFTER the update
        WHERE i.unitInStock < i.ROL -- Check if new stock is below Re-Order Level
          AND NOT EXISTS ( -- Optional: Only insert if it wasn't already below ROL before this update
              SELECT 1
              FROM deleted d
              WHERE d.productId = i.productId AND d.unitInStock < d.ROL
          );
          -- Simpler version without checking old stock:
          -- WHERE i.unitInStock < i.ROL;
    END;
END;
GO

-- How to test it:
PRINT 'Before Update:';
SELECT productId, unitInStock, ROL FROM Products WHERE productId = 'P004'; -- Current stock 15, ROL 20 (Should not be in Items_to_Order yet)
SELECT * FROM Items_to_Order;

PRINT 'Updating P004 stock...';
-- Update stock to fall below ROL (e.g., sell 5)
UPDATE Products SET unitInStock = unitInStock - 5 WHERE productId = 'P004'; -- Stock becomes 10, ROL is 20

PRINT 'After Update:';
SELECT productId, unitInStock, ROL FROM Products WHERE productId = 'P004';
SELECT * FROM Items_to_Order; -- Should now contain an entry for P004

-- Update stock but stay above ROL (should not trigger insert)
-- UPDATE Products SET unitInStock = 60 WHERE productId = 'P001'; -- Stock 60, ROL 50
-- SELECT * FROM Items_to_Order;