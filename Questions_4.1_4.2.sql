use [XtremeQC2.3]

-- Question 4.1
CREATE PROCEDURE uspAddPurchaseSale
    @in_sp_datesold DATE,
    @in_sp_deposit DECIMAL(18, 2),
    @in_sp_ID VARCHAR(50),
    @in_c_id INT,
    @in_v_regno VARCHAR(20)
AS
BEGIN
    DECLARE @max_invoice INT;

    INSERT INTO sales_purchases (Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID, CustomerID, Vehicle_regno) 
    SELECT @in_sp_datesold, Vehicle_price, @in_sp_deposit, @in_sp_ID, @in_c_id, @in_v_regno 
    FROM vehicles WHERE Vehicle_regno = @in_v_regno;

    SELECT @max_invoice = MAX(Sales_purchase_Invoice)
    FROM sales_purchases;

    UPDATE sales_purchases SET Sales_Purchase_Addncost = Sales_Purchase_Saleprice * 0.2
    WHERE Sales_purchase_Invoice = @max_invoice;

    UPDATE sales_purchases SET Sales_Purchase_Total = Sales_Purchase_Saleprice + Sales_Purchase_Addncost - Sales_Purchase_Deposit
    WHERE Sales_purchase_Invoice = @max_invoice;

    
    -- Error handling
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK;
    END;
END;

EXEC uspAddPurchaseSale '2017-06-02', 2000, 'MK201', 1, 'FJW125';

SELECT * FROM sales_purchases;


-- Find unsold vehicles
SELECT Vehicle_regno FROM VEHICLES
EXCEPT
SELECT Vehicle_regno FROM SALES_PURCHASES;




-- Question 4.2
use [XtremeQC2.3]
-- Create the AddPurchaseOrderItem stored procedure
CREATE PROCEDURE uspAddPurchaseOrderItem
    @OrderID INT,
    @ItemNumber INT,
    @Quantity INT
AS
BEGIN
    -- Insert into the order_lines table
    INSERT INTO order_lines (OrderID, ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) 
    SELECT @OrderID, @ItemNumber, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_Year, @Quantity 
    FROM items WHERE items.ItemID = @ItemNumber;

    -- Calculate the subtotal for the order line
    UPDATE order_lines 
    SET Order_Line_Subtotal =Order_Line_qty * Item_Price
    WHERE OrderID = @OrderID; 

    -- Update the total order amount in the orders table
    UPDATE orders SET Order_Total = (
        SELECT SUM(Order_Line_Subtotal)
        FROM order_lines
        WHERE order_lines.OrderID = @OrderID);

    -- Update the total order quantity in the orders table
    UPDATE orders SET Order_Total_Qty = (
        SELECT SUM(Order_Line_qty)
        FROM order_lines
        WHERE order_lines.OrderID = @OrderID);
    -- Error handling
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK;
    END;
END;
-- Insert into orders
EXEC uspAddPurchaseOrderItem '2021-06-05', 'XTRQC', 'MK201';
-- Execute the uspAddPurchaseOrderItem stored procedure with parameter values
EXEC uspAddPurchaseOrderItem
    @OrderID = 123, 
    @ItemNumber = 456,
    @Quantity = 5; 

SELECT * FROM orders


/*
There are 2 different user stated procedures listed above. The first rule about a procedure is that it should be declared with a unique name which is done
above.One of the procedure is called ' uspAddPurchseSale' at the beginnning there are some declarations of the input variables and their data types.
We then have the 'AS' and 'BEGIN' Statement which now includes the body of the procedure. we then declare a variable then there is a select 
statement and insert statement and a few update statments.There is also exception handling at the end of the procedure which will undo
any changes that are made and then an error occurs.
The purpose of the procedure is that a salesperson can add an entry into the salespurchase table. All they need to give aare the parameters 
which are datesold,deposit,salespersonID,customerID and vehicle Registration Number.

The 2nd procedure also has a unique name 'uspAddPurchaseOrderItem' . This procedure has a similar structure which has parameters and the 
as and begin statements. It aslo has a body that adds an entry in the orders table. It will insert into the orders table and also
update a few fields. This procedure also has error handling which will also undo the changes made incase of an error. the procedure is called 
via a unique word called the 'Execute' statement which is then followed by the unique procedure name and its input parameters.This procedure has
3 input parameters and adds an entry into the orders table

A procedure must have a uique name and must contain a body within a begin and end statement as shown above.


*/

