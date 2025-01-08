--Question 5
-- Create the trigger in MSSQL
CREATE TRIGGER trg_sales
ON Sales_Person
AFTER INSERT, UPDATE
AS
BEGIN
    DECLARE @count_sale INT;

    -- Using a JOIN with the INSERTED table to count supervisors
    SELECT @count_sale = COUNT(sp.Sales_PersonID)
    FROM Sales_Person sp
    JOIN INSERTED i ON sp.Sales_Person_Supervisor = sp.Sales_Person_Supervisor;

    IF @count_sale >= 2
    BEGIN
        -- Using THROW for raising errors in MSSQL
        THROW 51000, 'INSERT DENIED: A supervisor cannot supervise more than 2 people', 1;
        ROLLBACK TRANSACTION; -- Rollback the transaction
        RETURN; -- Exit the trigger
    END;
END;


BEGIN TRY
    -- Insert statement
    INSERT INTO Sales_Person (Sales_PersonID, Sales_Person_First_Name, Sales_Person_Last_Name, Sales_Person_start_Date, Sales_person_Phone, Sales_Person_Comm_Rate, Sales_Person_Supervisor) 
    VALUES ('PW501', 'Mavis', 'Halmer', '2015-08-24', '0219338123', 0.15, 'MK201');
END TRY
BEGIN CATCH
    -- Display error message
    PRINT ERROR_MESSAGE();
END CATCH;

