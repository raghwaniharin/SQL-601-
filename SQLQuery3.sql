use [XtremeQC]


-- Table colours
CREATE TABLE Colours (
    ColourID INT IDENTITY(1,1) PRIMARY KEY,
    Colour_Description VARCHAR(15) NOT NULL
);

-- Table customers
CREATE TABLE Customer (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    Customer_First_Name VARCHAR(20) NOT NULL,
    Customer_Last_Name VARCHAR(20) NOT NULL,
    gender CHAR(1) CHECK (gender IN ('M', 'F','O')),
    Customer_Address1 VARCHAR(20) NOT NULL,
    Customer_Address2 VARCHAR(20) NOT NULL,
    Customer_Address3 VARCHAR(20),
    Customer_phone VARCHAR(10) NOT NULL
);

-- Table sales_persons
CREATE TABLE Sales_Person (
    Sales_PersonID VARCHAR(5) PRIMARY KEY,
    Sales_Person_First_Name VARCHAR(20) NOT NULL,
    Sales_Person_Last_Name VARCHAR(20) NOT NULL,
    Sales_Person_start_Date DATE NOT NULL,
    Sales_person_Phone VARCHAR(10) NOT NULL,
    Sales_Person_Comm_Rate DECIMAL(3, 2) NOT NULL,
    Sales_Person_Supervisor varchar(5),
	FOREIGN KEY (Sales_Person_supervisor) REFERENCES Sales_Person(Sales_PersonID)
);

-- Table vehicles
CREATE TABLE Vehicles (
	Vehicle_regno varchar(10) NOT NULL PRIMARY KEY,
    Vehicle_make VARCHAR(10) NOT NULL,
    Vehicle_model VARCHAR(15) NOT NULL,
    Vehicle_year INT NOT NULL CHECK (Vehicle_year >= 1990),
    Vehicle_num_of_owners INT DEFAULT 0 CHECK (Vehicle_num_of_owners <= 5),
    Vehicle_price DECIMAL(7, 2) NOT NULL,
    Vehicle_miledge INT NOT NULL,
    ColourID INT NOT NULL,
    FOREIGN KEY (ColourID) REFERENCES Colours(ColourID)
);

-- Table sales_purchases
CREATE TABLE Sales_Purchases (
    Sales_purchase_Invoice INT IDENTITY(1,1) PRIMARY KEY,
    Sales_purchase_Datesold DATE NOT NULL,
    Sales_Purchase_Saleprice DECIMAL(7, 2),
    Sales_Purchase_Addncost DECIMAL(7, 2),
    Sales_Purchase_Deposit DECIMAL(7, 2),
    Sales_Purchase_Total DECIMAL(7, 2),
    Sales_PersonID VARCHAR(5) NOT NULL,
    CustomerID INT NOT NULL,
    Vehicle_regno VARCHAR(10) NOT NULL UNIQUE,
    FOREIGN KEY (Sales_PersonID) REFERENCES Sales_Person(Sales_PersonID),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (Vehicle_regno) REFERENCES Vehicles(Vehicle_regno)
);

-- Table payments
CREATE TABLE Payments (
    Payment_Invoice INT IDENTITY(1,1) PRIMARY KEY,
    Payment_Date DATE NOT NULL,
    Payment_Amount DECIMAL(7, 2) NOT NULL,
    CustomerID INT NOT NULL,
    Sales_Purchase_Invoice INT NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (Sales_Purchase_Invoice) REFERENCES Sales_Purchases(Sales_purchase_Invoice)
);

-- Table suppliers
CREATE TABLE Suppliers (
    Supplier_Code INT IDENTITY(1,1) PRIMARY KEY,
    Supplier_Name VARCHAR(25) NOT NULL,
    Supplier_Address1 VARCHAR(20) NOT NULL,
    SupplierAddress2 VARCHAR(20) NOT NULL,
    Supplier_Address3 VARCHAR(20) NOT NULL,
    Supplier_Contact VARCHAR(20) NOT NULL,
    Supplier_Contact2 VARCHAR(10) NOT NULL
);


-- Table items
CREATE TABLE Items (
    ItemID INT IDENTITY(1,1) PRIMARY KEY,
    Item_Make VARCHAR(10) NOT NULL,
    Item_Model VARCHAR(15) NOT NULL,
    Item_Year INT NOT NULL CHECK (Item_Year >= 1990),
    Item_Price DECIMAL(7, 2),
    CONSTRAINT uk_items UNIQUE (Item_Make,Item_Model,Item_Year)
);

-- Table orders
CREATE TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    Order_Date DATE NOT NULL,
    Order_Total_Qty INT,
    Order_Total DECIMAL(9, 2),
    Supplier_Code INT NOT NULL,
    Sales_PersonID varchar(5) NOT NULL,
    FOREIGN KEY (Supplier_Code) REFERENCES Suppliers(Supplier_Code),
    FOREIGN KEY (Sales_PersonID) REFERENCES Sales_Person(Sales_PersonID)
);

-- Table order_lines
CREATE TABLE Order_Lines (
    OrderID INT NOT NULL,
    ItemID  INT NOT NULL,
    Item_Make VARCHAR(10),
    Item_Model VARCHAR(15),
    Item_Price DECIMAL(7, 2),
    Item_year INT,
    Order_Line_qty INT DEFAULT 1,
    Order_Line_Subtotal DECIMAL(7, 2),
    PRIMARY KEY (OrderID, ItemID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ItemID) REFERENCES items(ItemID)
);


-- Insert Colour Data 
INSERT INTO Colours(Colour_Description) VALUES
('Red'),
('Black'),
('Silver'),
('White'),
('Blue'),
('Purple'),
('Yellow'),
('Paua'),
('Orange'),
('Green');


SELECT * FROM colours;


-- Insert Car Data
INSERT INTO Vehicles VALUES
('GKN534', 'Mazda', '626', 2014, 2, 14599, 59633,1),
('ALP394', 'Nissan', 'Bluebird', 2012, 1, 15995, 59000, 2), 
('NT6776', 'Toyota', 'Corolla', 2015, 1, 24990, 20565, 8),
('KGH334', 'Toyota', 'Rav4', 2014, 1, 36990, 6509, 3),
('PHG902', 'Toyota', 'Rav4', 2016, 0, 46990, 14, 6),
('GLM123', 'Honda', 'Accord', 2010, 2, 9995, 119000, 4), 
('OM1122', 'Mazda', '323', 2012, 1, 12995, 89000, 5),
('RS3456', 'Mazda', '323', 2013, 1, 13995, 110000, 1), 
('ZHU123', 'Nissan', 'Note', 2009, 2, 9995, 89000, 3),
('PRH345', 'Honda', 'Accord', 2014, 1, 41885, 5500, 9),
('SUT143', 'Nissan', 'Bluebird', 2013, 1, 17995, 61000, 6),
('GBR553', 'Nissan', 'X-Trail', 2016, 0, 39995, 12, 3), 
('LQRT67', 'Toyota', 'Yaris', 2015, 1, 20990, 6825, 2), 
('SALES1', 'BMW', '525i', 2009, 1, 27440, 39400, 7),
('LMV541', 'BMW', 'M3', 2010, 2, 54990, 77000, 2),
('NIS123', 'Nissan', 'Pulsar', 2016, 0, 24989, 3, 9),
('TGY683', 'Nissan', 'Navara', 2016, 0, 54989, 13, 1),
('GTF098', 'Honda', 'Accord', 2012, 1, 12995, 110000, 9), 
('OMG765', 'Mazda', '323', 2014, 1, 17995, 59000, 7),
 ('LOL201', 'Nissan', 'Bluebird', 2013, 1, 19995, 41000, 1),
('YTY561', 'Honda', 'Crossroad', 2010, 2, 25500, 95500, 2),
('MMH291', 'Nissan', 'Altima', 2013, 1, 25995, 5000, 1), 
('YQTA23', 'Toyota', 'Yaris', 2014, 1, 18990, 36000, 8),
('OUP887', 'BMW', '525i', 2010, 1, 32440, 29400, 9), 
('QPL322', 'BMW', 'M3', 2009, 1, 44990, 69000, 3),
('ZQP311', 'Nissan', 'Skyline', 2012, 2, 22980,65040,3),
('QPLO31', 'Nissan', 'Skyline', 2014, 1, 38500, 6500, 1),
('POOE23', 'Honda', 'Accord', 2013, 1, 13995, 120000, 7), 
 ('PLKI21', 'Mazda', '323', 2014, 1, 16995, 79000, 2),
 ('HWY231', 'Nissan', 'Bluebird', 2013, 2, 19995, 39000, 1),
 ('SHEEPS', 'Holden', 'Commodore SsV', 2013, 1, 29995, 49000,3),
 ('TPGEAR', 'Nissan', 'Bluebird', 2011, 2, 12995, 89000, 4), 
 ('YTT342', 'Honda', 'VTR250F', 2011, 2, 9995, 89000, 1),
 ('GO4T53', 'Honda', 'CB900F Hornet', 2010, 2, 7995, 95000, 5),
 ('GO4T99', 'Honda', 'Jazz', 2011, 2, 7995, 89000, 4),
 ('EATPOO', 'BMW', 'Z4', 2012, 1, 39995, 49000, 4),
 ('KFK122', 'Ford', 'Falcon', 2013, 1, 24995, 59000, 3),
 ('KER123', 'Mazda', 'Familia', 2010, 2, 8995, 85900, 1),
 ('PKR111', 'Mazda', 'Familia', 2010, 2, 7995, 95000, 5),
 ('FJW125', 'Holden', 'Commodore', 2015, 1, 39999, 15000, 4);
 
 
SELECT * FROM Vehicles;


-- Insert Customer Data
INSERT INTO Customer  VALUES 
('Katniss', 'Everde', 'F', '45 Dinsdale Rd', 'Frankton', 'Hamilton', '8123456'),
('Peeta', 'Mallark', 'M', '123 Anglesea St', 'Maeora', 'Hamilton', '8111111'),
('Gale', 'Hawthorne', 'M', '717 River Rd', 'Melville', 'Hamilton', '8221122'),
('Haymitch', 'Avern', 'M', '24 Duke St', 'Park View', 'Cambridge', '8881888'),
('Primrose', 'Suzci', 'F', 'RD1', 'Park View', 'Cambridge', '8112211'),
('Effie', 'Trinket', 'F', '655 Tristram St', 'Frankton', 'Hamilton', '8181818'),
('Hamilon', 'Hardna', 'M', '23 Lake Rd', 'Frankton', 'Hamilton', '8151156'),
('Kermin', 'Shaldon', 'M', '23 Rimu St', 'Maeroa', 'Hamilton', '8113121'),
('Sukki', 'Rightson', 'F', '252 Fast Rd', 'Silverdale', 'Hamilton', '8222322'),
('Mathew', 'Allen', 'M', '45 Shelfin St', 'West Side View', 'Cambridge', '8816988'),
('Frank', 'Smith', 'M', '45 Dinsdale Rd', 'Dinsdale', 'Hamilton', '8183456'),
('Tody', 'Ever', 'M', '49 Queen St', 'Park View', 'Cambridge', '8823346'),
('Toby', 'Deen', 'M', '45 Queen St', 'Hamilton Central', 'Hamilton', '8623456'),
('Pip', 'Jett', 'M', '423 Anglesea St', 'Hamilton Central', 'Hamilton', '8456123'),
('John', 'Mack', 'M', '43 Cresent St', 'Melville', 'Hamilton', '8443143');


SELECT *FROM Customer;


-- Insert Sales Person Data
INSERT INTO Sales_Person VALUES
('MK201', 'Michael', 'Knapp', '10-Jun-15', '0213390823', 0.25, NULL),
('KK634', 'Kelly', 'Knapp', '10-Jul-15', '0213390823', 0.15, NULL),
('BP301', 'Bradley', 'Palmer', '24-Aug-15', '0219878123', 0.15, 'MK201'),
('KC312', 'Karen', 'Craften', '21-Aug-15', '0213940903', 0.25, 'KK634'),
('KH981', 'Kane', 'Hunter', '12-Mar-16', '0212132231', 0.15, 'MK201'),
('JW351', 'John', 'Wrights', '20-Mar-16', '0210998212', 0.15, NULL);


SELECT * FROM Sales_Person;
--OpenAI. (2023). ChatGPT (September 25 Version) [Large language model]. https://chat.openai.com

-- Insert Sales Purchase Data using combination of INSERT...SELECT and UPDATE Commands

INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID, CustomerID, Vehicle_regno) SELECT ('17-Jun-2015'), Vehicles.Vehicle_price, 2000.00, 'MK201', 1, 'GKN534' FROM vehicles WHERE Vehicles.Vehicle_regno = 'GKN534';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID, CustomerID, Vehicle_regno) SELECT ('27-Jun-2015'), Vehicles.Vehicle_price, 2000.00, 'MK201', 2, 'ALP394' FROM vehicles WHERE Vehicles.Vehicle_regno = 'ALP394';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID, CustomerID, Vehicle_regno) SELECT ('07-Jul-2015'), Vehicles.Vehicle_price, 5000.00, 'MK201', 3, 'NT6776' FROM vehicles WHERE Vehicles.Vehicle_regno = 'NT6776';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID, CustomerID, Vehicle_regno) SELECT ('11-Jul-2015'), Vehicles.Vehicle_price, 1500.00, 'MK201', 4, 'KGH334' FROM vehicles WHERE Vehicles.Vehicle_regno = 'KGH334';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('17-Jul-2015'), Vehicles.Vehicle_price, 0.00, 'KK634', 5, 'PHG902' FROM vehicles WHERE Vehicles.Vehicle_regno = 'PHG902';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('19-Jul-2015'), Vehicles.Vehicle_price, 0.00, 'MK201', 6, 'GLM123' FROM vehicles WHERE Vehicles.Vehicle_regno = 'GLM123';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('07-Aug-2015'), Vehicles.Vehicle_price, 1500.00, 'KK634', 7, 'OM1122' FROM vehicles WHERE Vehicles.Vehicle_regno = 'OM1122';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('10-Aug-2015'), Vehicles.Vehicle_price, 3000.00, 'KK634', 8, 'RS3456' FROM vehicles WHERE Vehicles.Vehicle_regno = 'RS3456';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('27-Aug-2015'), Vehicles.Vehicle_price, 0.00, 'BP301', 9, 'ZHU123' FROM vehicles WHERE Vehicles.Vehicle_regno = 'ZHU123';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('01-Oct-2015'), Vehicles.Vehicle_price, 0.00, 'BP301', 10, 'PRH345' FROM vehicles WHERE Vehicles.Vehicle_regno = 'PRH345';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('11-Oct-2015'), Vehicles.Vehicle_price, 0.00, 'MK201', 11, 'SUT143' FROM vehicles WHERE Vehicles.Vehicle_regno = 'SUT143';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('10-Nov-2015'), Vehicles.Vehicle_price, 2000.00, 'BP301', 12, 'GBR553' FROM vehicles WHERE Vehicles.Vehicle_regno = 'GBR553';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('11-Dec-2015'), Vehicles.Vehicle_price, 3000.00, 'KC312', 13, 'LQRT67' FROM vehicles WHERE Vehicles.Vehicle_regno = 'LQRT67';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('12-Dec-2015'), Vehicles.Vehicle_price, 3000.00, 'KC312', 14, 'SALES1' FROM vehicles WHERE Vehicles.Vehicle_regno = 'SALES1';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT ('12-Jan-2016'), Vehicles.Vehicle_price, 2500.00, 'BP301', 15, 'LMV541' FROM vehicles WHERE Vehicles.Vehicle_regno = 'LMV541';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT('15-Jan-2016'), Vehicles.Vehicle_price, 2000.00, 'KC312', 1, 'NIS123' FROM vehicles WHERE Vehicles.Vehicle_regno = 'NIS123';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT('17-Mar-2016'), Vehicles.Vehicle_price, 3000.00, 'KH981', 2, 'TGY683' FROM vehicles WHERE Vehicles.Vehicle_regno = 'TGY683';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT('20-Mar-2016'), Vehicles.Vehicle_price, 2000.00, 'KK634', 3, 'GTF098' FROM vehicles WHERE Vehicles.Vehicle_regno = 'GTF098';
INSERT INTO sales_purchases(Sales_purchase_Datesold, Sales_Purchase_Saleprice, Sales_Purchase_Deposit, Sales_PersonID,CustomerID, Vehicle_regno) SELECT('20-Apr-2016'), Vehicles.Vehicle_price, 0.00, 'KH981', 4, 'OMG765' FROM vehicles WHERE Vehicles.Vehicle_regno = 'OMG765';


-- #################################################################
-- Update Sales Purchases
UPDATE sales_purchases SET Sales_Purchase_Addncost = Sales_Purchase_Saleprice*0.2;
UPDATE sales_purchases SET Sales_Purchase_Total = (Sales_Purchase_Saleprice + Sales_Purchase_Addncost) - Sales_Purchase_Deposit;


SELECT * FROM sales_purchases

-- #################################################################
-- Insert Payment Data
INSERT INTO payments (Payment_Date, Payment_Amount, CustomerID, Sales_Purchase_Invoice) VALUES

(('27-Jul-2015'), 1000, 1, 1),
(('27-Aug-2015'), 1000, 1, 1),
(('27-Sep-2015'), 1000, 1, 1),
(('17-Aug-2015'), 1000, 2, 2),
(('17-Sep-2015'), 1000, 2, 2),
(('17-Oct-2015'), 1000, 2, 2),
(('17-Nov-2015'), 1000, 2, 2),
(('7-Jul-2015'), 1000, 3, 3),
(('11-Jul-2015'), 1000, 4, 4),
(('17-Jul-2015'), 1000, 5, 5),
(('19-Aug-2015'), 1000, 6, 6),
(('19-Sep-2015'), 1000, 6, 6),
(('19-Oct-2015'), 1000, 6, 6),
(('7-Aug-2015'), 1000, 7, 7),
(('7-Jan-2016'), 1000, 7, 7),
(('7-Feb-2016'), 1000, 7, 7),
(('10-Sep-2015'), 1000, 8, 8),
(('10-Oct-2015'), 1000, 8, 8),
(('10-Nov-2015'), 1000, 8, 8),
(('10-Feb-2016'), 1000, 8, 8);

SELECT * FROM payments


-- Insert Item Data
INSERT INTO items (Item_Make, Item_Model, Item_Year, Item_Price) VALUES
('Honda', 'Accord', 2010, 3000),
('Honda', 'Accord', 2012, 5000),
('Honda', 'Accord', 2013, 7000),
('Honda', 'Accord', 2014, 13000),
('Honda', 'CRZ', 2012, 4000),
('Honda', 'Civic', 2015, 5000),
('Honda', 'Jazz', 2011, 2500),
('Honda', 'Jazz', 2012, 3500), 
('Honda', 'Crossroad', 2010, 8000), 
('Honda', 'VTR250F', 2011, 3000),
('Honda', 'CB900F Hornet', 2010,2500), 
('Toyota', 'Aurion', 2013, 10000),
('Toyota', 'Hiace', 2014, 8000),
('Toyota', 'Hilux', 2012, 9000),
('Toyota', 'Camry', 2013, 12000),
('Toyota', 'Vitz', 2010, 8000),
('Toyota', 'Prius', 2012, 9000),
('Toyota', 'Corolla', 2015, 8000),
('Toyota', 'Yaris', 2014, 6000),
('Toyota', 'Yaris', 2015, 7000), 
('Toyota', 'Rav4', 2014, 12000), 
('Toyota', 'Rav4', 2016, 14000), 
('Mazda', '323', 2012, 4000),
('Mazda', '323', 2013, 4500), 
('Mazda', '323', 2014, 5500), 
('Mazda', '353', 2013, 5000), 
('Mazda', '353', 2014, 6000), 
('Mazda', '626', 2014, 5000), 
('Mazda', 'Familia', 2010, 2500), 
('Nissan', 'Muruno', 2014, 9000), 
('Nissan', 'Pulsar', 2016, 8000),
('Nissan', 'Bluebird', 2011, 4000),
('Nissan', 'Bluebird', 2012, 5000),
('Nissan', 'Bluebird', 2013, 6000),
('Nissan', 'X-Trail', 2016, 12000), 
('Nissan', 'Navara', 2016, 16000),
('Nissan', 'Altima', 2013, 8000), 
('Nissan', 'Note', 2009, 3000),
('Nissan', 'Skyline', 2014, 15000), 
('Nissan', 'Skyline', 2012, 7000),
('Ford', 'Falcon', 2012, 7000),
('Ford', 'Falcon', 2013, 8000), 
('Ford', 'Falcon', 2014, 9000), 
('BMW', '322', 2010, 15000),
('BMW', '727', 2013, 18000),
('BMW', 'X5', 2014, 18000),
('BMW', '525i', 2009, 9000), 
('BMW', '525i', 2010, 10000), 
('BMW', 'M3', 2010, 17000),
('BMW', 'Z4', 2012, 12000), 
('Holden', 'Commodore SsV', 2013, 10000), 
('Holden', 'Commodore', 2015, 13000),
('Holden', 'Commodore XR6', 2011, 15000), 
('Holden', 'Commodore XR6', 2012, 17000), 
('Holden', 'Commodore XR6', 2013, 19000),
('Holden', 'Clubsport', 2013, 19000),
('Holden', 'Clubsport', 2014, 21000), 
('Holden', 'Clubsport', 2015, 22000);

SELECT * FROM items;

-- Insert Supplier Data

INSERT INTO suppliers (Supplier_Name, Supplier_Address1, SupplierAddress2, Supplier_Address3, Supplier_Contact, Supplier_Contact2)
VALUES ('XTREME Quality Cars Inc', '22A Great North Rd', 'Pimbroke', 'Auckland', 'Murray Knapp', '096666432');

SELECT * FROM suppliers

-- Insert Order Data
INSERT INTO orders (Order_Date, Supplier_Code, Sales_PersonID) VALUES
('01-Jun-2015',1,'MK201'),
('05-Jun-2015',1,'MK201'),
('06-Jun-2015', 1,'MK201'),
('10-Jun-2015',1,'MK201'),
('11-Jun-2015',1,'MK201'),
('12-Jun-2015',1,'MK201'),
('21-Jul-2015',1,'KK634'),
('01-Aug-2015',1,'KK634'),
('11-Aug-2015',1,'KK634'),
('21-Aug-2015',1,'KK634');


SELECT * FROM orders;





INSERT INTO order_lines (OrderID, ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_Year, 1 FROM items WHERE items.ItemID = 28;
INSERT INTO order_lines (OrderID, ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 33;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 18;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 21;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 22;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 1;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 23;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 24;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 38;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 1, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 4;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 3 FROM items WHERE items.ItemID = 34;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 35;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 20;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 47;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 49;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 31;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 36;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 2;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 25;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 2, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 27;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 3, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 9;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 3, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 36;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 3, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 19;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 3, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 48;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 3, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 51;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 4, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 40;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 4, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 39;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 4, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 3;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 4, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 3 FROM items WHERE items.ItemID = 25;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 5, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 34;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 5, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 52;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 5, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 32;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 5, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 10;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 5, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 11;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 6, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 7;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 6, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 51;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 6, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 42;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 6, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 3 FROM items WHERE items.ItemID = 29;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 6, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 53;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 7, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 44;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 7, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 3;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 7, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 3 FROM items WHERE items.ItemID = 58;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 7, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 45;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 7, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 23;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 8, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 42;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 8, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 43;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 8, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 55;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 8, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 50;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make,Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 8, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID= 51;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 52;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 29;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 2 FROM items WHERE items.ItemID = 30;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 3 FROM items WHERE items.ItemID = 55;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 3;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 5;
INSERT INTO order_lines (OrderID,  ItemID, Item_Make, Item_Model, Item_Price, Item_year, Order_Line_qty) SELECT 9, items.ItemID, items.Item_Make, items.Item_Model, items.Item_Price, items.Item_year, 1 FROM items WHERE items.ItemID = 9;

SELECT * FROM order_lines



--PROCEDURES
use [XtremeQC]

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
use [XtremeQC]
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
EXEC uspAddPurchaseOrderItem 10,1,3;
SELECT * FROM orders


/*
There are 2 different user stated procedures listed above. The first rule about a procedure is that it should be declared with
a unique name which is done above.One of the procedure is called ' uspAddPurchseSale' at the beginnning there are some
declarations of the input variables and their data types. We then have the 'AS' and 'BEGIN' Statement which now includes
the body of the procedure. we then declare a variable then there is a select statement and insert statement and a few update 
statments.There is also exception handling at the end of the procedure which will undo any changes that are made and then an
error occurs.The purpose of the procedure is that a salesperson can add an entry into the salespurchase table. 
All they need to give are the parameters which are datesold,deposit,salespersonID,customerID and vehicle Registration Number.

The 2nd procedure also has a unique name 'uspAddPurchaseOrderItem' . This procedure has a similar structure which has
parameters and the as and begin statements. It aslo has a body that adds an entry in the orders table. It will insert 
into the orders table and also update a few fields. This procedure also has error handling which will also undo the
changes made incase of an error. the procedure is called via a unique word called the 'Execute' statement which is
then followed by the unique procedure name and its input parameters.This procedure has 3 input parameters and adds
an entry into the orders table

A procedure must have a unique name and must contain a body within a begin and end statement as shown above.


*/

--TRIGGERS
--Question 5
use [XtremeQC]
-- Create the trigger in MSSQL
CREATE TRIGGER usptrigger_sales
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
/*
DECLARATION

I declare that this work is mine and unique. I have created it myself and with the help of
CHATGPT OpenAI. (2023). ChatGPT (September 25 Version) [Large language model]. https://chat.openai.com
which helped me in troubleshooting some minute problems along the way.
I have changed all field names to something more understandable and commented so that future database administrators can understand
the code.

*/


