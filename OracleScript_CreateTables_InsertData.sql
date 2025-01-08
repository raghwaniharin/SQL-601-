-- Sample Database for EXTREME QC Hamilton Database Assignment 2
-- @'G:\New Degree Development\INFO601\Assessments\Assignment 2\XTREMEQCHamiltonDatabase.sql';
--
-- Commands for efficiency and manageability
-- #################################################################
DROP TABLE order_lines CASCADE CONSTRAINTS;
DROP TABLE sales_purchases CASCADE CONSTRAINTS;
DROP TABLE orders CASCADE CONSTRAINTS;
DROP TABLE payments CASCADE CONSTRAINTS;
DROP TABLE vehicles CASCADE CONSTRAINTS;
DROP TABLE customers CASCADE CONSTRAINTS;
DROP TABLE sales_persons CASCADE CONSTRAINTS;
DROP TABLE suppliers CASCADE CONSTRAINTS;
DROP TABLE items CASCADE CONSTRAINTS;
DROP TABLE lu_colours CASCADE CONSTRAINTS;

-- #################################################################
-- Create database structure
-- #################################################################

-- Lookup Table Colour
CREATE TABLE lu_colours (
	c_no NUMBER(3) PRIMARY KEY,
	c_colour VARCHAR2(15) NOT NULL
);

DROP SEQUENCE lu_colours_seq;
CREATE SEQUENCE lu_colours_seq
	START WITH 1
	INCREMENT BY 1;

CREATE OR REPLACE TRIGGER lu_colours_seq_trg
	BEFORE INSERT ON lu_colours
	REFERENCING NEW AS NEW
	FOR EACH ROW
	BEGIN
		SELECT lu_colours_seq.NEXTVAL INTO :NEW.c_no FROM DUAL;
	END;
	/
	
-- Table Customer
CREATE TABLE customers (
	c_id NUMBER(6) PRIMARY KEY,
	c_fname VARCHAR2(20) NOT NULL,
	c_lname VARCHAR2(20) NOT NULL,
	c_gender CHAR(1) CHECK (
		c_gender IN ('M','F')
	),
	c_address1 VARCHAR2(20) NOT NULL,
	c_address2 VARCHAR2(20) NOT NULL,
	c_address3 VARCHAR2(20),
	c_ph VARCHAR2(10) NOT NULL
);

DROP SEQUENCE customers_seq;
CREATE SEQUENCE customers_seq
	START WITH 1
	INCREMENT BY 1;

CREATE OR REPLACE TRIGGER customers_seq_trg
	BEFORE INSERT ON customers
	REFERENCING NEW AS NEW
	FOR EACH ROW
	BEGIN
		SELECT customers_seq.NEXTVAL INTO :NEW.c_id FROM DUAL;
	END;
	/

-- Table Sales Person
CREATE TABLE sales_persons (
	sp_id VARCHAR2(5) PRIMARY KEY,
	sp_fname VARCHAR2(20) NOT NULL,
	sp_lname VARCHAR2(20) NOT NULL,
	sp_startdate DATE NOT NULL,
	sp_cellph VARCHAR2(10) NOT NULL,
	sp_comrate NUMBER(3,2) NOT NULL,
	sp_sup VARCHAR2(5)
);

-- Table Vehicle
CREATE TABLE vehicles (
	v_regno VARCHAR2(7) PRIMARY KEY,
	v_make VARCHAR2(10) NOT NULL,
	v_model VARCHAR2(15) NOT NULL,
	v_year NUMBER(4) NOT NULL CHECK (
			v_year >= 1990
		),
	v_numowners NUMBER(1) DEFAULT 0 CHECK (
		v_numowners <= 5
	),
	v_price NUMBER(7,2) NOT NULL,
	v_miledge NUMBER(6) NOT NULL,
	c_no NUMBER(3),
	FOREIGN KEY (c_no) REFERENCES lu_colours(c_no)
);

-- Table Sales Purchase with invoice# starting at 10000000
CREATE TABLE sales_purchases (
	sp_invoice NUMBER(8) PRIMARY KEY,
	sp_datesold DATE NOT NULL,
	sp_saleprice NUMBER(7,2),
	sp_addncost NUMBER(7,2),
	sp_deposit NUMBER(7,2),
	sp_total NUMBER(7,2),
	sp_id VARCHAR2(5),
	c_id NUMBER(6),
	v_regno VARCHAR2(7) UNIQUE,
	FOREIGN KEY (sp_id) REFERENCES sales_persons(sp_id),
	FOREIGN KEY (c_id) REFERENCES customers(c_id),
	FOREIGN KEY (v_regno) REFERENCES vehicles(v_regno)
);

DROP SEQUENCE sp_seq;
CREATE SEQUENCE sp_seq
	START WITH 10000000
	INCREMENT BY 1;

CREATE OR REPLACE TRIGGER sp_seq_trg
	BEFORE INSERT ON sales_purchases
	REFERENCING NEW AS NEW
	FOR EACH ROW
	BEGIN
		SELECT sp_seq.NEXTVAL INTO :NEW.sp_invoice FROM DUAL;
	END;
	/

-- Table Payment with invoice# starting at 90000000
CREATE TABLE payments (
	p_invoice NUMBER(8) PRIMARY KEY,
	p_date DATE NOT NULL,
	p_amount NUMBER(7,2) NOT NULL,
	c_id NUMBER(6),
	sp_invoice NUMBER(8),
	FOREIGN KEY (c_id) REFERENCES customers(c_id),
	FOREIGN KEY (sp_invoice) REFERENCES sales_purchases(sp_invoice)
);

DROP SEQUENCE payments_seq;
CREATE SEQUENCE payments_seq
	START WITH 90000000
	INCREMENT BY 1;

CREATE OR REPLACE TRIGGER payments_seq_trg
	BEFORE INSERT ON payments
	REFERENCING NEW AS NEW
	FOR EACH ROW
	BEGIN
		SELECT payments_seq.NEXTVAL INTO :NEW.p_invoice FROM DUAL;
	END;
	/
	
-- Table Supplier
CREATE TABLE suppliers (
	s_code VARCHAR2(5) PRIMARY KEY,
	s_name VARCHAR2(25) NOT NULL,
	s_address1 VARCHAR2(20) NOT NULL,
	s_address2 VARCHAR2(20) NOT NULL,
	s_address3 VARCHAR2(20) NOT NULL,
	s_contactp VARCHAR2(20) NOT NULL,
	s_contactph VARCHAR2(10) NOT NULL
);

-- Table Item
CREATE TABLE items (
	i_no NUMBER(5) PRIMARY KEY,
	i_make VARCHAR2(10) NOT NULL,
	i_model VARCHAR2(15) NOT NULL,
	i_year NUMBER(4) NOT NULL CHECK (
			i_year >= 1990
		),
	i_price NUMBER(7,2),
	CONSTRAINT uk_items UNIQUE (i_make, i_model, i_year)	
);

DROP SEQUENCE items_seq;
CREATE SEQUENCE items_seq
	START WITH 1
	INCREMENT BY 1;

CREATE OR REPLACE TRIGGER items_seq_trg
	BEFORE INSERT ON items
	REFERENCING NEW AS NEW
	FOR EACH ROW
	BEGIN
		SELECT items_seq.NEXTVAL INTO :NEW.i_no FROM DUAL;
	END;
	/

-- Table Order with order number starting at 90000000
CREATE TABLE orders (
	o_id NUMBER(8) PRIMARY KEY,
	o_date DATE NOT NULL,
	o_totalqty NUMBER(2),
	o_total NUMBER(9,2),
	s_code VARCHAR2(5),
	sp_id VARCHAR2(5),
	FOREIGN KEY (s_code) REFERENCES suppliers(s_code),
	FOREIGN KEY (sp_id) REFERENCES sales_persons(sp_id)
);

DROP SEQUENCE orders_seq;
CREATE SEQUENCE orders_seq
	START WITH 80000000
	INCREMENT BY 1;

CREATE OR REPLACE TRIGGER orders_seq_trg
	BEFORE INSERT ON orders
	REFERENCING NEW AS NEW
	FOR EACH ROW
	BEGIN
		SELECT orders_seq.NEXTVAL INTO :NEW.o_id FROM DUAL;
	END;
	/

-- Table Order Line
CREATE TABLE order_lines (
	o_id NUMBER(8),
	i_no NUMBER(5),
	i_make VARCHAR2(10),
	i_model VARCHAR2(15),
	i_price NUMBER(7,2),
	i_year NUMBER(4),
	ol_qty NUMBER(2) DEFAULT 1,
	ol_subtotal NUMBER(7,2),
	PRIMARY KEY (o_id, i_no),
	FOREIGN KEY (o_id) REFERENCES orders(o_id),
	FOREIGN KEY (i_no) REFERENCES items(i_no)
);

-- #################################################################
-- Data for the Database
-- #################################################################

-- Insert Colour Data - 10 rows
INSERT INTO lu_colours (c_colour) VALUES ('Red');
INSERT INTO lu_colours (c_colour) VALUES ('Black');
INSERT INTO lu_colours (c_colour) VALUES ('Silver');
INSERT INTO lu_colours (c_colour) VALUES ('White');
INSERT INTO lu_colours (c_colour) VALUES ('Blue');
INSERT INTO lu_colours (c_colour) VALUES ('Purple');
INSERT INTO lu_colours (c_colour) VALUES ('Yellow');
INSERT INTO lu_colours (c_colour) VALUES ('Paua');
INSERT INTO lu_colours (c_colour) VALUES ('Orange');
INSERT INTO lu_colours (c_colour) VALUES ('Green');

COMMIT;
SELECT * FROM lu_colours;

-- #################################################################
-- Insert Car Data
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('GKN534', 'Mazda', '626', 2014, 2, 14599, 59633,1);
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('ALP394', 'Nissan', 'Bluebird', 2012, 1, 15995, 59000, 2); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('NT6776', 'Toyota', 'Corolla', 2015, 1, 24990, 20565, 8); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('KGH334', 'Toyota', 'Rav4', 2014, 1, 36990, 6509, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('PHG902', 'Toyota', 'Rav4', 2016, 0, 46990, 14, 6); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('GLM123', 'Honda', 'Accord', 2010, 2, 9995, 119000, 4); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('OM1122', 'Mazda', '323', 2012, 1, 12995, 89000, 5); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('RS3456', 'Mazda', '323', 2013, 1, 13995, 110000, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('ZHU123', 'Nissan', 'Note', 2009, 2, 9995, 89000, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('PRH345', 'Honda', 'Accord', 2014, 1, 41885, 5500, 9); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('SUT143', 'Nissan', 'Bluebird', 2013, 1, 17995, 61000, 6); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('GBR553', 'Nissan', 'X-Trail', 2016, 0, 39995, 12, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('LQRT67', 'Toyota', 'Yaris', 2015, 1, 20990, 6825, 2); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('SALES1', 'BMW', '525i', 2009, 1, 27440, 39400, 7); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('LMV541', 'BMW', 'M3', 2010, 2, 54990, 77000, 2); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('NIS123', 'Nissan', 'Pulsar', 2016, 0, 24989, 3, 9); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('TGY683', 'Nissan', 'Navara', 2016, 0, 54989, 13, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('GTF098', 'Honda', 'Accord', 2012, 1, 12995, 110000, 9); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('OMG765', 'Mazda', '323', 2014, 1, 17995, 59000, 7); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('LOL201', 'Nissan', 'Bluebird', 2013, 1, 19995, 41000, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('YTY561', 'Honda', 'Crossroad', 2010, 2, 25500, 95500, 2); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('MMH291', 'Nissan', 'Altima', 2013, 1, 25995, 5000, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('YQTA23', 'Toyota', 'Yaris', 2014, 1, 18990, 36000, 8); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('OUP887', 'BMW', '525i', 2010, 1, 32440, 29400, 9); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('QPL322', 'BMW', 'M3', 2009, 1, 44990, 69000, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('ZQP311', 'Nissan', 'Skyline', 2012, 2, 22980 65040, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('QPLO31', 'Nissan', 'Skyline', 2014, 1, 38500, 6500, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('POOE23', 'Honda', 'Accord', 2013, 1, 13995, 120000, 7); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('PLKI21', 'Mazda', '323', 2014, 1, 16995, 79000, 2); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('HWY231', 'Nissan', 'Bluebird', 2013, 2, 19995, 39000, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('SHEEPS', 'Holden', 'Commodore SsV', 2013, 1, 29995, 49000, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('TPGEAR', 'Nissan', 'Bluebird', 2011, 2, 12995, 89000, 4); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('YTT342', 'Honda', 'VTR250F', 2011, 2, 9995, 89000, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('GO4T53', 'Honda', 'CB900F Hornet', 2010, 2, 7995, 95000, 5); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('GO4T99', 'Honda', 'Jazz', 2011, 2, 7995, 89000, 4); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('EATPOO', 'BMW', 'Z4', 2012, 1, 39995, 49000, 4); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('KFK122', 'Ford', 'Falcon', 2013, 1, 24995, 59000, 3); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('KER123', 'Mazda', 'Familia', 2010, 2, 8995, 85900, 1); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('PKR111', 'Mazda', 'Familia', 2010, 2, 7995, 95000, 5); 
INSERT INTO vehicles (v_regno, v_make, v_model, v_year, v_numowners, v_price, v_miledge, c_no) VALUES ('FJW125', 'Holden', 'Commodore', 2015, 1, 39999, 15000, 4); 

COMMIT;
SELECT v_regno, v_make, v_model, c_colour FROM vehicles, lu_colours WHERE vehicles.c_no = lu_colours.c_no;

-- #################################################################
-- Insert Customer Data
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Katniss', 'Everde', 'F', '45 Dinsdale Rd', 'Frankton', 'Hamilton', '8123456');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Peeta', 'Mallark', 'M', '123 Anglesea St', 'Maeora', 'Hamilton', '8111111');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Gale', 'Hawthorne', 'M', '717 River Rd', 'Melville', 'Hamilton', '8221122');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Haymitch', 'Avern', 'M', '24 Duke St', 'Park View', 'Cambridge', '8881888');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Primrose', 'Suzci', 'F', 'RD1', 'Park View', 'Cambridge', '8112211');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Effie', 'Trinket', 'F', '655 Tristram St', 'Frankton', 'Hamilton', '8181818');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Hamilon', 'Hardna', 'M', '23 Lake Rd', 'Frankton', 'Hamilton', '8151156');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Kermin', 'Shaldon', 'M', '23 Rimu St', 'Maeroa', 'Hamilton', '8113121');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Sukki', 'Rightson', 'F', '252 Fast Rd', 'Silverdale', 'Hamilton', '8222322');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Mathew', 'Allen', 'M', '45 Shelfin St', 'West Side View', 'Cambridge', '8816988');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Frank', 'Smith', 'M', '45 Dinsdale Rd', 'Dinsdale', 'Hamilton', '8183456');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Tody', 'Ever', 'M', '49 Queen St', 'Park View', 'Cambridge', '8823346');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Toby', 'Deen', 'M', '45 Queen St', 'Hamilton Central', 'Hamilton', '8623456');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('Pip', 'Jett', 'M', '423 Anglesea St', 'Hamilton Central', 'Hamilton', '8456123');
INSERT INTO customers (c_fname, c_lname, c_gender, c_address1, c_address2, c_address3, c_ph) VALUES ('John', 'Mack', 'M', '43 Cresent St', 'Melville', 'Hamilton', '8443143');

COMMIT;
SELECT c_id, c_fname, c_lname, c_address3 FROM customers;

-- #################################################################
-- Insert Sales Person Data
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('MK201', 'Michael', 'Knapp', '10-Jun-15', '0213390823', 0.25, '');
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('KK634', 'Kelly', 'Knapp', '10-Jul-15', '0213390823', 0.15, '');
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('BP301', 'Bradley', 'Palmer', '24-Aug-15', '0219878123', 0.15, 'MK201');
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('KC312', 'Karen', 'Craften', '21-Aug-15', '0213940903', 0.25, 'KK634');
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('KH981', 'Kane', 'Hunter', '12-Mar-16', '0212132231', 0.15, 'MK201');
INSERT INTO sales_persons (sp_id, sp_fname, sp_lname, sp_startdate, sp_cellph, sp_comrate, sp_sup) VALUES ('JW351', 'John', 'Wrights', '20-Mar-16', '0210998212', 0.15, '');

COMMIT;
SELECT sp_id, sp_fname, sp_lname, sp_cellph, sp_sup FROM sales_persons;

-- #################################################################
-- Insert Sales Purchase Data using combination of INSERT...SELECT and UPDATE Commands
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('17-Jun-2015','dd-mm-yyyy'), vehicles.v_price, 2000.00, 'MK201', 1, 'GKN534' FROM vehicles WHERE vehicles.v_regno = 'GKN534';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('27-Jun-2015','dd-mm-yyyy'), vehicles.v_price, 2000.00, 'MK201', 2, 'ALP394' FROM vehicles WHERE vehicles.v_regno = 'ALP394';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('07-Jul-2015','dd-mm-yyyy'), vehicles.v_price, 5000.00, 'MK201', 3, 'NT6776' FROM vehicles WHERE vehicles.v_regno = 'NT6776';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('11-Jul-2015','dd-mm-yyyy'), vehicles.v_price, 1500.00, 'MK201', 4, 'KGH334' FROM vehicles WHERE vehicles.v_regno = 'KGH334';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('17-Jul-2015','dd-mm-yyyy'), vehicles.v_price, 0.00, 'KK634', 5, 'PHG902' FROM vehicles WHERE vehicles.v_regno = 'PHG902';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('19-Jul-2015','dd-mm-yyyy'), vehicles.v_price, 0.00, 'MK201', 6, 'GLM123' FROM vehicles WHERE vehicles.v_regno = 'GLM123';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('07-Aug-2015','dd-mm-yyyy'), vehicles.v_price, 1500.00, 'KK634', 7, 'OM1122' FROM vehicles WHERE vehicles.v_regno = 'OM1122';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('10-Aug-2015','dd-mm-yyyy'), vehicles.v_price, 3000.00, 'KK634', 8, 'RS3456' FROM vehicles WHERE vehicles.v_regno = 'RS3456';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('27-Aug-2015','dd-mm-yyyy'), vehicles.v_price, 0.00, 'BP301', 9, 'ZHU123' FROM vehicles WHERE vehicles.v_regno = 'ZHU123';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('01-Oct-2015','dd-mm-yyyy'), vehicles.v_price, 0.00, 'BP301', 10, 'PRH345' FROM vehicles WHERE vehicles.v_regno = 'PRH345';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('11-Oct-2015','dd-mm-yyyy'), vehicles.v_price, 0.00, 'MK201', 11, 'SUT143' FROM vehicles WHERE vehicles.v_regno = 'SUT143';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('10-Nov-2015','dd-mm-yyyy'), vehicles.v_price, 2000.00, 'BP301', 12, 'GBR553' FROM vehicles WHERE vehicles.v_regno = 'GBR553';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('11-Dec-2015','dd-mm-yyyy'), vehicles.v_price, 3000.00, 'KC312', 13, 'LQRT67' FROM vehicles WHERE vehicles.v_regno = 'LQRT67';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('12-Dec-2015','dd-mm-yyyy'), vehicles.v_price, 3000.00, 'KC312', 14, 'SALES1' FROM vehicles WHERE vehicles.v_regno = 'SALES1';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('12-Jan-2016','dd-mm-yyyy'), vehicles.v_price, 2500.00, 'BP301', 15, 'LMV541' FROM vehicles WHERE vehicles.v_regno = 'LMV541';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('15-Jan-2016','dd-mm-yyyy'), vehicles.v_price, 2000.00, 'KC312', 1, 'NIS123' FROM vehicles WHERE vehicles.v_regno = 'NIS123';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('17-Mar-2016','dd-mm-yyyy'), vehicles.v_price, 3000.00, 'KH981', 2, 'TGY683' FROM vehicles WHERE vehicles.v_regno = 'TGY683';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('20-Mar-2016','dd-mm-yyyy'), vehicles.v_price, 2000.00, 'KK634', 3, 'GTF098' FROM vehicles WHERE vehicles.v_regno = 'GTF098';
INSERT INTO sales_purchases(sp_datesold, sp_saleprice, sp_deposit, sp_id, c_id, v_regno) SELECT TO_DATE('20-Apr-2016','dd-mm-yyyy'), vehicles.v_price, 0.00, 'KH981', 4, 'OMG765' FROM vehicles WHERE vehicles.v_regno = 'OMG765';

-- #################################################################
-- Update Sales Purchases
UPDATE sales_purchases SET sp_addncost = sp_saleprice*0.2;
UPDATE sales_purchases SET sp_total = (sp_saleprice + sp_addncost) - sp_deposit;

COMMIT;
SELECT sp_invoice, sp_saleprice, sp_deposit, sp_total, c_fname, v_regno FROM sales_purchases, customers WHERE sales_purchases.c_id = customers.c_id;

-- #################################################################
-- Insert Payment Data
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('27-Jul-2015','dd-mm-yyyy'), 1000, 1, 10000000);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('27-Aug-2015','dd-mm-yyyy'), 1000, 1, 10000000);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('27-Sep-2015','dd-mm-yyyy'), 1000, 1, 10000000);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('17-Aug-2015','dd-mm-yyyy'), 1000, 2, 10000001);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('17-Sep-2015','dd-mm-yyyy'), 1000, 2, 10000001);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('17-Oct-2015','dd-mm-yyyy'), 1000, 2, 10000001);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('17-Nov-2015','dd-mm-yyyy'), 1000, 2, 10000001);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('7-Jul-2015','dd-mm-yyyy'), 1000, 3, 10000002);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('11-Jul-2015','dd-mm-yyyy'), 1000, 4, 10000003);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('17-Jul-2015','dd-mm-yyyy'), 1000, 5, 10000004);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('19-Aug-2015','dd-mm-yyyy'), 1000, 6, 10000005);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('19-Sep-2015','dd-mm-yyyy'), 1000, 6, 10000005);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('19-Oct-2015','dd-mm-yyyy'), 1000, 6, 10000005);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('7-Aug-2015','dd-mm-yyyy'), 1000, 7, 10000006);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('7-Jan-2016','dd-mm-yyyy'), 1000, 7, 10000006);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('7-Feb-2016','dd-mm-yyyy'), 1000, 7, 10000006);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('10-Sep-2015','dd-mm-yyyy'), 1000, 8, 10000007);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('10-Oct-2015','dd-mm-yyyy'), 1000, 8, 10000007);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('10-Nov-2015','dd-mm-yyyy'), 1000, 8, 10000007);
INSERT INTO payments (p_date, p_amount, c_id, sp_invoice) VALUES (TO_DATE('10-Feb-2016','dd-mm-yyyy'), 1000, 8, 10000007);

COMMIT;
SELECT p_invoice, p_date, p_amount, c_fname, sp_invoice FROM payments, customers WHERE payments.c_id = customers.c_id;

-- #################################################################
-- Insert Item Data
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Accord', 2010, 3000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Accord', 2012, 5000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Accord', 2013, 7000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Accord', 2014, 13000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'CRZ', 2012, 4000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Civic', 2015, 5000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Jazz', 2011, 2500);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Jazz', 2012, 3500); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'Crossroad', 2010, 8000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'VTR250F', 2011, 3000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Honda', 'CB900F Hornet', 2010, 2500); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Aurion', 2013, 10000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Hiace', 2014, 8000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Hilux', 2012, 9000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Camry', 2013, 12000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Vitz', 2010, 8000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Prius', 2012, 9000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Corolla', 2015, 8000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Yaris', 2014, 6000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Yaris', 2015, 7000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Rav4', 2014, 12000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Toyota', 'Rav4', 2016, 14000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', '323', 2012, 4000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', '323', 2013, 4500); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', '323', 2014, 5500); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', '353', 2013, 5000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', '353', 2014, 6000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', '626', 2014, 5000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Mazda', 'Familia', 2010, 2500); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Muruno', 2014, 9000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Pulsar', 2016, 8000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Bluebird', 2011, 4000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Bluebird', 2012, 5000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Bluebird', 2013, 6000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'X-Trail', 2016, 12000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Navara', 2016, 16000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Altima', 2013, 8000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Note', 2009, 3000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Skyline', 2014, 15000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Nissan', 'Skyline', 2012, 7000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Ford', 'Falcon', 2012, 7000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Ford', 'Falcon', 2013, 8000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Ford', 'Falcon', 2014, 9000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', '322', 2010, 15000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', '727', 2013, 18000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', 'X5', 2014, 18000);
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', '525i', 2009, 9000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', '525i', 2010, 10000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', 'M3', 2010, 17000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('BMW', 'Z4', 2012, 12000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Commodore SsV', 2013, 10000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Commodore', 2015, 13000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Commodore XR6', 2011, 15000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Commodore XR6', 2012, 17000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Commodore XR6', 2013, 19000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Clubsport', 2013, 19000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Clubsport', 2014, 21000); 
INSERT INTO items (i_make, i_model, i_year, i_price) VALUES ('Holden', 'Clubsport', 2015, 22000); 

COMMIT;
SELECT * FROM items;

-- #################################################################
-- Insert Supplier Data
INSERT INTO suppliers (s_code, s_name, s_address1, s_address2, s_address3, s_contactp, s_contactph) VALUES ('XTRQC','XTREME Quality Cars Inc','22A Great North Rd','Pimbroke', 'Auckland', 'Murray Knapp', '096666432');
COMMIT;

-- #################################################################
-- Insert Order Data
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('01-Jun-2015','dd-mm-yyyy'),'XTRQC','MK201');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('05-Jun-2015','dd-mm-yyyy'),'XTRQC','MK201');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('06-Jun-2015','dd-mm-yyyy'),'XTRQC','MK201');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('10-Jun-2015','dd-mm-yyyy'),'XTRQC','MK201');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('11-Jun-2015','dd-mm-yyyy'),'XTRQC','MK201');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('12-Jun-2015','dd-mm-yyyy'),'XTRQC','MK201');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('21-Jul-2015','dd-mm-yyyy'),'XTRQC','KK634');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('01-Aug-2015','dd-mm-yyyy'),'XTRQC','KK634');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('11-Aug-2015','dd-mm-yyyy'),'XTRQC','KK634');
INSERT INTO orders (o_date, s_code, sp_id) VALUES (TO_DATE('21-Aug-2015','dd-mm-yyyy'),'XTRQC','KK634');

COMMIT;
SELECT * FROM orders;

-- #################################################################
-- Insert Order Line Data
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 28;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 33;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 18;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 21;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 22;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 1;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 23;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 24;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 38;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000000, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 4;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 3 FROM items WHERE items.i_no = 34;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 35;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 20;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 47;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 49;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 31;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 36;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 2;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 25;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000001, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 27;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000002, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 9;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000002, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 36;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000002, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 19;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000002, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 48;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000002, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 51;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000003, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 40;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000003, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 39;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000003, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 3;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000003, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 3 FROM items WHERE items.i_no = 25;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000004, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 34;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000004, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 52;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000004, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 32;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000004, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 10;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000004, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 11;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000005, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 7;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000005, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 51;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000005, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 42;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000005, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 3 FROM items WHERE items.i_no = 29;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000005, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 53;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000006, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 44;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000006, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 3;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000006, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 3 FROM items WHERE items.i_no = 58;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000006, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 45;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000006, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 23;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000007, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 42;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000007, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 43;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000007, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 55;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000008, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 50;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000008, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 51;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 52;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 29;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 2 FROM items WHERE items.i_no = 30;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 3 FROM items WHERE items.i_no = 55;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 3;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 5;
INSERT INTO order_lines (o_id, i_no, i_make, i_model, i_price, i_year, ol_qty) SELECT 80000009, items.i_no, items.i_make, items.i_model, items.i_price, items.i_year, 1 FROM items WHERE items.i_no = 9;

COMMIT;

-- #################################################################
-- Update the Order Line Data and Update the Orders
UPDATE order_lines SET ol_subtotal = ol_qty * i_price;
SELECT o_id, i_no, i_price, ol_qty, ol_subtotal FROM order_lines;

UPDATE orders SET o_total = (
	SELECT SUM (ol_subtotal)
	FROM order_lines
	WHERE orders.o_id = order_lines.o_id );

UPDATE orders SET o_totalqty = (
	SELECT SUM (ol_qty)
	FROM order_lines
	WHERE orders.o_id = order_lines.o_id );

SELECT * FROM orders;





