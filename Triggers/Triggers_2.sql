-- Use the OnlineStoreDB database
USE OnlineStoreDB;
GO

-- Trigger to update product stock after an order detail is inserted
CREATE TRIGGER TR_OrderDetails_UpdateStock
ON orderDetails -- Trigger is on the orderDetails table
AFTER INSERT -- Fires after an insert occurs
AS
BEGIN
    SET NOCOUNT ON;

    -- Update the Products table by joining with the 'inserted' table
    UPDATE P
    SET P.unitInStock = P.unitInStock - i.quantity
    FROM Products P
    INNER JOIN inserted i ON P.productId = i.productId;

    -- Optional: Add check if stock becomes negative and raise an error/rollback
    IF EXISTS (SELECT 1 FROM Products P JOIN inserted i ON P.productId = i.productId WHERE P.unitInStock < 0)
    BEGIN
        RAISERROR ('Stock cannot go below zero. Transaction rolled back.', 16, 1);
        ROLLBACK TRANSACTION;
        RETURN;
    END

    -- Optional: Check if the update caused stock to fall below ROL
    -- This might be redundant if TR_Products_CheckROL exists, but shows how it could be done here.
    /*
    INSERT INTO Items_to_Order (ProductId, DateNotified)
    SELECT i.productId, GETDATE()
    FROM inserted i
    JOIN Products P ON i.productId = P.productId
    WHERE P.unitInStock < P.ROL
      AND (P.unitInStock + i.quantity) >= P.ROL; -- Check if it just crossed the threshold
    */

END;
GO

-- How to test it:
PRINT 'Before Insert:';
SELECT productId, unitInStock FROM Products WHERE productId = 'P001'; -- Current stock 80 (or less if previous trigger ran)

-- Add a new detail line to Order 1 (assuming P001 wasn't already there)
-- If P001 already exists for order 1, this insert will fail due to PK constraint. Let's use Order 2 created earlier.
PRINT 'Inserting into Order 2...';
INSERT INTO orderDetails (oid, productId, quantity, discount)
VALUES (2, 'P001', 5, 0.1); -- Sell 5 units of P001 for Order 2

PRINT 'After Insert:';
SELECT productId, unitInStock FROM Products WHERE productId = 'P001'; -- Stock should be reduced by 5
SELECT * FROM orderDetails WHERE oid = 2;