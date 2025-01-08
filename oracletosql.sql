CREATE TABLE Colour(
ColourID int identity(1,1) PRIMARY KEY,
ColourDesc varchar(10) NOT NULL
)
CREATE TABLE Customer(
CustomerID int identity(1,1) PRIMARY KEY,
First_Name varchar(10) NOT NULL,
Last_Name varchar(10) NOT NULL,
Gender char(1) check(gender in('M','F','O')),
Address1 varchar(20) NOT NULL,
Phone varchar(10)
)

CREATE TABLE Sales_Person(
Sales_PersonID INT IDENTITY(1,1) PRIMARY KEY,
First_Name varchar(10) NOT NULL,
Last_Name varchar(10) NOT NULL,
Gender char(1) check(gender in('M','F','O')),
StartDate date NOT NULL,
Phone varchar(10),
Rate decimal(3,2),
SupervisorID int FOREIGN KEY REFERENCES Sales_Person(Sales_PersonID),
)

CREATE TABLE Vehicle(
VehicleID INT IDENTITY(1,1) PRIMARY KEY,
Vehicle_Rego VARCHAR(7) NOT NULL,
Make VARCHAR(12),
Model VARCHAR(16),
Vehicle_Year_Manufactured INT NOT NULL check(Vehicle_Year_Manufactured >=1990),
NumOfOwners INT check(NumOfOwners <=5),
Price decimal(7,2) NOT NULL,
Mileage INT NOT NULL,
CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID)
)

CREATE TABLE Sales_Purchase(
Sales_PurchaseID INT IDENTITY(1,1) PRIMARY KEY,
Date_Sold date NOT NULL,
Sale_Price decimal(7,2) NOT NULL,
Additional_Cost decimal(7,2),
Deposit decimal(7,2),
total decimal(7,2),
Sales_PersonID INT FOREIGN KEY REFERENCES Sales_Person(Sales_PersonID),
CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
VehicleID INT FOREIGN KEY REFERENCES Vehicle(VehicleID),
)


CREATE TABLE Payment(
PaymentID INT IDENTITY(1,1) PRIMARY KEY,
Payment_Date date NOT NULL,
Payment_Amount decimal(7,2) NOT NULL,
CustomerID INT FOREIGN KEY REFERENCES Customer(CustomerID),
Sales_PersonID INT FOREIGN KEY REFERENCES Sales_Person(Sales_PersonID),
)

CREATE TABLE Supplier(
SupplierID INT IDENTITY(1,1) PRIMARY KEY,
Supplier_Name VARCHAR(12),
Address1 varchar(35) NOT NULL,
Phone varchar(10) NOT NULL,
Secondary_Phone varchar(10),
)

CREATE TABLE Items(
ItemID INT IDENTITY(1,1) PRIMARY KEY,
Item_Make VARCHAR(20),
Item_Model VARCHAR(20),
Item_Year_Manufactured INT NOT NULL check(Item_Year_Manufactured >=1990) ,
Item_Price decimal(7,2),
CONSTRAINT Unique_Items UNIQUE (Item_Make,Item_Model,Item_Year_Manufactured),

)
CREATE TABLE Orders(
OrderID INT IDENTITY(1,1) PRIMARY KEY,
Order_Date date NOT NULL,
Total_Quantity INT,
Total_Price decimal(7,2),
SupplierID INT FOREIGN KEY REFERENCES Supplier(SupplierID),
Sales_PersonID INT FOREIGN KEY REFERENCES Sales_Person(Sales_PersonID),
)
CREATE TABLE Order_Lines(
OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
ItemID INT FOREIGN KEY REFERENCES Items(ItemID),
Order_Line_Quantity INT DEFAULT 1,
Order_line_Subtotal decimal(7,2),
PRIMARY KEY(OrderID,ItemID),
)
