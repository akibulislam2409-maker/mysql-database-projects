# CLH Movie Database - Complete SQL Scripts

================================================================================
CREATE TABLE STATEMENTS
================================================================================

--- Create-table-Genre.sql ---
CREATE TABLE GENRE (
GenreID INT PRIMARY KEY AUTO_INCREMENT,
GenreName VARCHAR(50) NOT NULL UNIQUE
);

--- Create-Table-Member.sql ---
CREATE TABLE MEMBER (
MemberID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(100) NOT NULL,
Address VARCHAR(255) NOT NULL,
DOB DATE NOT NULL,
Gender CHAR(1) NOT NULL,
RegistrationDate DATE NOT NULL,
Status VARCHAR(20) NOT NULL
);

--- Create-Table-Staff.sql ---
CREATE TABLE STAFF (
StaffID INT PRIMARY KEY AUTO_INCREMENT,
Name VARCHAR(100) NOT NULL,
Address VARCHAR(255) NOT NULL,
DOB DATE NOT NULL,
Gender CHAR(1) NOT NULL,
HireDate DATE NOT NULL,
MemberID INT UNIQUE,
FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
ON DELETE SET NULL
ON UPDATE CASCADE
);

--- Create-table-Movie.sql ---
CREATE TABLE MOVIE (
MovieID INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR(255) NOT NULL UNIQUE,
Director VARCHAR(100) NOT NULL,
FilmCompany VARCHAR(100),
ISBN VARCHAR(20) UNIQUE,
ReleaseYear INT NOT NULL,
Synopsis TEXT
);

--- Create-Table-Movie_Genre.sql ---
CREATE TABLE MOVIE_GENRE (
MovieID INT NOT NULL,
GenreID INT NOT NULL,
PRIMARY KEY (MovieID, GenreID),
FOREIGN KEY (MovieID) REFERENCES MOVIE(MovieID),
FOREIGN KEY (GenreID) REFERENCES GENRE(GenreID)
);

--- Create-table-Movie_Copy.sql ---
CREATE TABLE MOVIE_COPY (
CopyID INT PRIMARY KEY AUTO_INCREMENT,
MovieID INT NOT NULL,
Format VARCHAR(50) NOT NULL,
Status VARCHAR(20) NOT NULL,
FOREIGN KEY (MovieID) REFERENCES MOVIE(MovieID)
);

--- Create-Table-Acquisition.sql ---
CREATE TABLE ACQUISITION (
AcquisitionID INT PRIMARY KEY AUTO_INCREMENT,
CopyID INT NOT NULL UNIQUE,
AcquisitionType VARCHAR(20) NOT NULL,
AcquisitionDate DATE NOT NULL,
Cost DECIMAL(10,2),
FOREIGN KEY (CopyID) REFERENCES MOVIE_COPY(CopyID)
);

--- Create-Table-Contact_Method.sql ---
CREATE TABLE CONTACT_METHOD (
ContactID INT PRIMARY KEY AUTO_INCREMENT,
MemberID INT NOT NULL,
Method VARCHAR(20) NOT NULL,
Value VARCHAR(100) NOT NULL,
FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

--- Create-table-renewal.sql ---
CREATE TABLE RENEWAL (
RenewalID INT PRIMARY KEY AUTO_INCREMENT,
MemberID INT NOT NULL,
CopyID INT NOT NULL,
RenewalDate DATE NOT NULL,
DueDate DATE NOT NULL,
FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (CopyID) REFERENCES MOVIE_COPY(CopyID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

--- Create-table-Fine.sql ---
CREATE TABLE FINE (
FineID INT PRIMARY KEY AUTO_INCREMENT,
MemberID INT NOT NULL,
CopyID INT NOT NULL,
Amount DECIMAL(10,2) NOT NULL,
FineDate DATE NOT NULL,
Status VARCHAR(20) NOT NULL,
FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (CopyID) REFERENCES MOVIE_COPY(CopyID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

--- Create-table-Payment.sql ---
CREATE TABLE PAYMENT (
PaymentID INT PRIMARY KEY AUTO_INCREMENT,
MemberID INT NOT NULL,
FineID INT NOT NULL,
Amount DECIMAL(10,2) NOT NULL,
PaymentDate DATE NOT NULL,
Method VARCHAR(30) NOT NULL,
FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (FineID) REFERENCES FINE(FineID)
ON DELETE CASCADE
ON UPDATE CASCADE
);

--- Create-Table-Loan.sql ---
CREATE TABLE LOAN (
LoanID INT PRIMARY KEY AUTO_INCREMENT,
CopyID INT NOT NULL,
MemberID INT NOT NULL,
StaffID INT NOT NULL,
IssueDate DATE NOT NULL,
DueDate DATE NOT NULL,
ReturnDate DATE,
Status VARCHAR(20) NOT NULL DEFAULT 'Active' CHECK (Status IN ('Active', 'Returned', 'Overdue')),
CONSTRAINT fk_loan_copy FOREIGN KEY (CopyID) REFERENCES MOVIE_COPY(CopyID) ON DELETE RESTRICT,
CONSTRAINT fk_loan_member FOREIGN KEY (MemberID) REFERENCES MEMBER(MemberID) ON DELETE CASCADE ON UPDATE CASCADE,
CONSTRAINT fk_loan_staff FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID) ON DELETE RESTRICT,
CONSTRAINT chk_loan_dates CHECK (IssueDate = DueDate AND (ReturnDate IS NULL OR ReturnDate = IssueDate)),
INDEX idx_loan_member (MemberID),
INDEX idx_loan_status (Status)
)
ENGINE=InnoDB
COMMENT='Loan transactions with full audit trail (member, staff, dates)';

--- Create-table-sale.sql ---
CREATE TABLE SALE (
SaleID INT PRIMARY KEY AUTO_INCREMENT,
CopyID INT NOT NULL UNIQUE,
SaleDate DATE NOT NULL,
SalePrice DECIMAL(10,2) NOT NULL,
StaffID INT,
FOREIGN KEY (CopyID) REFERENCES MOVIE_COPY(CopyID)
ON DELETE CASCADE
ON UPDATE CASCADE,
FOREIGN KEY (StaffID) REFERENCES STAFF(StaffID)
ON DELETE SET NULL
ON UPDATE CASCADE
);


================================================================================
ALTER TABLE STATEMENTS
================================================================================

--- alter_table_acquistion.sql ---
ALTER TABLE ACQUISITION ADD COLUMN Premise VARCHAR(50);


================================================================================
INSERT STATEMENTS
================================================================================

--- genre-1.sql ---
INSERT INTO GENRE (GenreName)
VALUES ('Christmas'),
('Drama'),
('Comedy'),
('Action'),
('Horror'),
('Science Fiction'),
('Romance'),
('Adventure');

--- member-2.sql ---
INSERT INTO MEMBER (Name, Address, DOB, Gender, RegistrationDate, Status)
VALUES ('John Smith', '12 Saul Street', '1988-12-10', 'M', '2019-05-01', 'Active'),
('Jane Doe', '34 Main Road', '1991-04-21', 'F', '2021-07-15', 'Active'),
('Michael Johnson', '56 Oak Avenue', '1985-03-15', 'M', '2020-11-20', 'Active'),
('Sarah Williams', '78 Elm Street', '1993-08-09', 'F', '2022-01-10', 'Active'),
('David Brown', '90 Pine Road', '1980-06-25', 'M', '2018-09-05', 'Active'),
('Emma Davis', '111 Birch Lane', '1995-11-14', 'F', '2023-02-28', 'Inactive'),
('James Wilson', '123 Cedar Close', '1987-02-17', 'M', '2021-03-12', 'Active'),
('Lisa Anderson', '145 Maple Drive', '1992-09-30', 'F', '2020-08-18', 'Active'),
('Robert Taylor', '167 Spruce Road', '1984-01-22', 'M', '2019-07-11', 'Active'),
('Karen Martinez', '189 Ash Street', '1990-05-08', 'F', '2022-10-03', 'Active');

--- staff-3.sql ---
INSERT INTO STAFF (Name, Address, DOB, Gender, HireDate, MemberID)
VALUES ('John Smith', '12 Saul Street', '1988-12-10', 'M', '2020-01-15', 1),
('Michael Johnson', '56 Oak Avenue', '1985-03-15', 'M', '2020-06-22', 3),
('David Brown', '90 Pine Road', '1980-06-25', 'M', '2018-10-01', 5),
('James Wilson', '123 Cedar Close', '1987-02-17', 'M', '2021-04-05', 7);

--- movie-4.sql ---
INSERT INTO MOVIE (Title, Director, FilmCompany, ISBN, ReleaseYear, Synopsis)
VALUES ('Home for Christmas', 'Anna Clark', 'CineMagic', '1234567891234', 2018, 'A family returns home for the holidays'),
('Drama Days', 'Ben Rivers', 'StudioX', '2345678912345', 2019, 'A serious drama unfolds.'),
('Laugh Out Loud', 'Chris Miller', 'FilmWorks', '3456789123456', 2020, 'A hilarious comedy about office life'),
('Action Heroes', 'Diana Prince', 'ActionPics', '4567891234567', 2021, 'Explosive action sequences and thrills'),
('Midnight Horror', 'Edward Grim', 'ScareLabs', '5678912345678', 2019, 'A terrifying night unfolds'),
('Space Odyssey', 'Frank Wells', 'CosmicStudios', '6789123456789', 2022, 'Journey through the stars'),
('Love in Paris', 'Grace Laurent', 'RomanceFilms', '7891234567890', 2021, 'A romantic tale in the city of love'),
('Mountain Quest', 'Henry Brooks', 'AdventureInc', '8912345678901', 2020, 'An epic adventure in the wilderness'),
('Winter Wonderland', 'Isabel Snow', 'HolidayStudio', '9123456789012', 2023, 'A magical Christmas story'),
('The Last Stand', 'Jack Thunder', 'ActionPics', '0234567890123', 2022, 'Heroes make their final stand');

--- movie_genre-5.sql ---
INSERT INTO MOVIE_GENRE (MovieID, GenreID)
VALUES (1, 1), -- Home for Christmas - Christmas
(2, 2), -- Drama Days - Drama
(3, 3), -- Laugh Out Loud - Comedy
(4, 4), -- Action Heroes - Action
(5, 5), -- Midnight Horror - Horror
(6, 6), -- Space Odyssey - Science Fiction
(7, 7), -- Love in Paris - Romance
(8, 8), -- Mountain Quest - Adventure
(9, 1), -- Winter Wonderland - Christmas
(10, 4); -- The Last Stand - Action

--- movie_copy-6.sql ---
INSERT INTO MOVIE_COPY (MovieID, Format, Status)
VALUES
(1, 'DVD', 'Available'),
(2, 'Blu-ray', 'Available'),
(3, 'DVD', 'Borrowed'),
(3, 'Blu-ray', 'Available'),
(4, 'DVD', 'Available'),
(4, '4K Ultra HD', 'Borrowed'),
(5, 'DVD', 'Damaged'),
(6, 'Blu-ray', 'Available'),
(7, 'DVD', 'Available'),
(8, 'Blu-ray', 'Available'),
(9, 'DVD', 'Available'),
(10, '4K Ultra HD', 'Available');

--- acquistion-7.sql ---
INSERT INTO ACQUISITION (CopyID, AcquisitionType, AcquisitionDate, Cost)
VALUES (1, 'Purchase', '2019-05-10', 25.00),
(2, 'Purchase', '2020-06-01', 32.50),
(3, 'Purchase', '2020-08-15', 20.00),
(4, 'Purchase', '2020-08-20', 28.00),
(5, 'Purchase', '2021-09-10', 22.50),
(6, 'Purchase', '2021-09-12', 38.00),
(7, 'Donation', '2019-10-25', 0.00),
(8, 'Purchase', '2022-11-01', 35.50),
(9, 'Purchase', '2021-12-05', 24.99),
(10, 'Purchase', '2020-10-18', 29.99),
(11, 'Purchase', '2023-03-20', 26.50),
(12, 'Purchase', '2022-12-30', 45.00);

--- insert_acquistion.sql (Updated with Premise column) ---
INSERT INTO ACQUISITION (CopyID, AcquisitionType, AcquisitionDate, Cost, Premise)
VALUES (1, 'Purchase', '2019-05-10', 25.00, 'Saul'),
(2, 'Purchase', '2020-06-01', 32.50, 'Downtown'),
(3, 'Purchase', '2020-08-15', 20.00, 'Westside'),
(4, 'Purchase', '2020-08-20', 28.00, 'Downtown'),
(5, 'Purchase', '2021-09-10', 22.50, 'Saul'),
(6, 'Purchase', '2021-09-12', 38.00, 'Eastside'),
(7, 'Donation', '2019-10-25', 0.00, 'Saul'),
(8, 'Purchase', '2022-11-01', 35.50, 'Downtown'),
(9, 'Purchase', '2019-05-15', 24.99, 'Saul'),
(10, 'Purchase', '2020-10-18', 29.99, 'Westside'),
(11, 'Purchase', '2023-03-20', 26.50, 'Downtown'),
(12, 'Purchase', '2022-12-30', 45.00, 'Eastside');

--- contact_method-8.sql ---
INSERT INTO CONTACT_METHOD (MemberID, Method, Value)
VALUES (1, 'Email', 'john.smith@email.com'),
(1, 'Phone', '0215554321'),
(2, 'Email', 'jane.doe@email.com'),
(3, 'Email', 'michael.johnson@email.com'),
(3, 'Phone', '0215554567'),
(4, 'Email', 'sarah.williams@email.com'),
(4, 'Phone', '0215558901'),
(5, 'Email', 'david.brown@email.com'),
(6, 'Phone', '0215559876'),
(7, 'Email', 'james.wilson@email.com'),
(8, 'Email', 'lisa.anderson@email.com'),
(8, 'Phone', '0215552345'),
(9, 'Email', 'robert.taylor@email.com'),
(10, 'Phone', '0215556789');

--- renewal-9.sql ---
INSERT INTO RENEWAL (MemberID, CopyID, RenewalDate, DueDate)
VALUES (1, 1, '2023-02-01', '2023-02-15'),
(2, 2, '2023-03-05', '2023-03-19'),
(3, 3, '2023-04-10', '2023-04-24'),
(4, 4, '2023-05-15', '2023-05-29'),
(5, 5, '2023-06-01', '2023-06-15'),
(7, 9, '2023-07-12', '2023-07-26'),
(8, 10, '2023-08-20', '2023-09-03'),
(9, 6, '2023-09-18', '2023-10-02');

--- fine-10.sql ---
INSERT INTO FINE (MemberID, CopyID, Amount, FineDate, Status)
VALUES (1, 1, 5.00, '2019-06-01', 'Paid'),
(3, 3, 3.50, '2023-04-28', 'Paid'),
(5, 5, 7.50, '2023-06-20', 'Unpaid'),
(2, 2, 2.50, '2023-03-25', 'Paid'),
(7, 9, 4.00, '2023-08-05', 'Paid'),
(4, 4, 6.00, '2023-06-10', 'Unpaid');

--- payment-11.sql ---
INSERT INTO PAYMENT (MemberID, FineID, Amount, PaymentDate, Method)
VALUES (1, 1, 5.00, '2019-06-02', 'Card'),
(3, 2, 3.50, '2023-05-02', 'Cash'),
(2, 4, 2.50, '2023-03-28', 'Card'),
(7, 5, 4.00, '2023-08-12', 'Online Transfer');

--- loan-12.sql ---
INSERT INTO LOAN (CopyID, MemberID, StaffID, IssueDate, DueDate, ReturnDate, Status)
VALUES (1, 1, 1, '2023-01-10', '2023-01-24', '2023-01-22', 'Returned'),
(2, 2, 1, '2023-02-15', '2023-03-01', '2023-02-28', 'Returned'),
(3, 3, 3, '2023-04-05', '2023-04-19', NULL, 'Active'),
(4, 4, 3, '2023-05-10', '2023-05-24', '2023-05-20', 'Returned'),
(5, 5, 4, '2023-06-01', '2023-06-15', NULL, 'Overdue'),
(6, 7, 2, '2023-07-08', '2023-07-22', '2023-07-21', 'Returned'),
(9, 8, 1, '2023-08-12', '2023-08-26', NULL, 'Active'),
(10, 9, 2, '2023-09-05', '2023-09-19', '2023-09-18', 'Returned'),
(7, 2, 4, '2023-03-18', '2023-04-01', '2023-03-31', 'Returned'),
(12, 4, 1, '2023-11-20', '2023-12-04', NULL, 'Active'),
(8, 6, 4, '2023-10-10', '2023-10-24', NULL, 'Overdue'),
(11, 1, 2, '2023-12-01', '2023-12-15', NULL, 'Active');

--- sale-13.sql ---
INSERT INTO SALE (CopyID, SaleDate, SalePrice, StaffID)
VALUES (1, '2023-01-25', 15.99, 1),
(2, '2023-03-05', 22.50, 3),
(5, '2023-06-20', 18.75, 2),
(7, '2023-04-10', 12.50, 4),
(4, '2023-05-28', 20.00, 1),
(10, '2023-09-20', 26.50, 2),
(6, '2023-08-15', 28.00, 3),
(12, '2023-12-10', 35.99, 4),
(3, '2023-05-05', 16.50, 1),
(8, '2023-10-30', 14.99, 2);


================================================================================
CREATE INDEX STATEMENTS
================================================================================

--- 5.sql ---
CREATE INDEX idx_movie_title ON MOVIE (Title);
CREATE INDEX idx_fine_date ON FINE (FineDate);

-- Example query using index hint (MySQL syntax)
SELECT + INDEX(f idx_fine_date)  Amount
FROM FINE f
WHERE YEAR(FineDate) = 2019;


================================================================================
SELECT QUERY EXAMPLES
================================================================================

--- 1.sql - Member and Staff Contact Information ---
SELECT m.Name, m.DOB, c.Method, c.Value
FROM MEMBER m
LEFT JOIN CONTACT_METHOD c ON m.MemberID = c.MemberID
UNION
SELECT s.Name, s.DOB, c.Method, c.Value
FROM STAFF s
LEFT JOIN CONTACT_METHOD c ON s.MemberID = c.MemberID;

--- 2.sql - Renewal Information with Member and Movie Details ---
SELECT m.Name, mov.Title, r.RenewalDate AS DateHired, r.DueDate
FROM RENEWAL r
JOIN MEMBER m ON r.MemberID = m.MemberID
JOIN MOVIE_COPY mc ON r.CopyID = mc.CopyID
JOIN MOVIE mov ON mc.MovieID = mov.MovieID;

--- 3.sql - Christmas Movies Purchased in May 2019 at Saul Premise ---
SELECT
mov.Title,
mov.FilmCompany,
acq.AcquisitionDate,
acq.Cost
FROM MOVIE mov
JOIN MOVIE_COPY mc ON mov.MovieID = mc.MovieID
JOIN MOVIE_GENRE mg ON mov.MovieID = mg.MovieID
JOIN GENRE g ON mg.GenreID = g.GenreID
JOIN ACQUISITION acq ON mc.CopyID = acq.CopyID
WHERE
g.GenreName = 'Christmas'
AND acq.AcquisitionType = 'Purchase'
AND MONTH(acq.AcquisitionDate) = 5
AND YEAR(acq.AcquisitionDate) = 2019
AND acq.Premise = 'Saul';

--- 4.sql - Total Fine Income by Genre in 2019 ---
SELECT g.GenreName, SUM(f.Amount) AS TotalIncome
FROM FINE f
JOIN MOVIE_COPY mc ON f.CopyID = mc.CopyID
JOIN MOVIE mov ON mc.MovieID = mov.MovieID
JOIN MOVIE_GENRE mg ON mov.MovieID = mg.MovieID
JOIN GENRE g ON mg.GenreID = g.GenreID
WHERE YEAR(f.FineDate) = 2019
GROUP BY g.GenreName;


================================================================================
DATABASE EXECUTION ORDER
================================================================================

1. Genre (no dependencies)
2. Member (no dependencies)
3. Staff (depends on Member)
4. Movie (no dependencies)
5. Movie_Genre (depends on Movie and Genre)
6. Movie_Copy (depends on Movie)
7. Acquisition (depends on Movie_Copy) - ALTER to add Premise column
8. Contact_Method (depends on Member)
9. Renewal (depends on Member and Movie_Copy)
10. Fine (depends on Member and Movie_Copy)
11. Payment (depends on Member and Fine)
12. Loan (depends on Movie_Copy, Member, and Staff)
13. Sale (depends on Movie_Copy and Staff)
14. Create indexes for optimization

================================================================================
END OF DOCUMENT
================================================================================