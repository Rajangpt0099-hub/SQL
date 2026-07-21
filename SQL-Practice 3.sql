/* ============================================================
/* ============================================================
   PRACTICE ASSIGNMENT: CONSTRAINTS (PK, FK, NOT NULL, UNIQUE,
   CHECK, DEFAULT) ACROSS FOUR CONNECTED TABLES
   Scenario: Library Management System

   Tables and how they connect:
     Authors  --(author_id)-->  Books
     Books    --(book_id)-->    Transactions
     Members  --(member_id)-->  Transactions

   So Transactions is linked to BOTH Books and Members.
   ============================================================

   WHAT YOU NEED TO DO:
   1. Write the CREATE TABLE statement for each table below,
      following the constraint requirements given in the comments.
   2. Insert 10 rows of realistic data into EACH table.
   3. Create tables and insert data in this ORDER: Authors, Books,
      Members, Transactions (parent tables must exist and have
      data before child tables can reference them).
   4. Write the constraint-violation INSERT statements to test
      each constraint (they should fail when run).
   ============================================================ */
CREATE DATABASE LibraryManagement;
 USE LibraryManagement;

/* ------------------------------------------------------------
   TABLE 1: Authors  (Parent table)
   ------------------------------------------------------------
   1. author_id     -> uniquely identifies each author, cannot be empty
   2. author_name   -> cannot be left empty
   3. country        -> should default to 'India' if not specified
   4. birth_year     -> must only allow years between 1800 and 2015

   Write your CREATE TABLE statement below:
   ------------------------------------------------------------ */
CREATE TABLE Authors
 ( author_id INT PRIMARY KEY,
 author_name VARCHAR(100) NOT NULL,
 country VARCHAR(50) DEFAULT 'India', 
 birth_year INT,
 CONSTRAINT chk_author_birth_year 
 CHECK (birth_year BETWEEN 1800 AND 2015) );



/* Insert 10 rows into Authors.
   At least 2 rows should rely on the DEFAULT country. */

INSERT INTO Authors
(author_id, author_name, country, birth_year)
 VALUES
 (1, 'R. K. Narayan', 'India', 1906),
 (2, 'William Shakespeare', 'England', 1864), 
 (3, 'J. K. Rowling', 'United Kingdom', 1965), 
 (4, 'George Orwell', 'England', 1903), 
 (5, 'Chetan Bhagat', 'India', 1974), 
 (6, 'Arundhati Roy', 'India', 1961),
 (7, 'Paulo Coelho', 'Brazil', 1947), 
(8, 'Sudha Murty', 'India', 1950);

INSERT INTO Authors
(author_id, author_name, birth_year) 
VALUES
(9, 'Ruskin Bond', 1934),
(10, 'Amish Tripathi', 1974);

SELECT * FROM Authors;

/* ------------------------------------------------------------
   TABLE 2: Books  (Child of Authors)
   ------------------------------------------------------------
   1. book_id         -> uniquely identifies each book, cannot be empty
   2. title            -> cannot be left empty
   3. isbn              -> must be unique across all books
   4. price              -> must only allow positive values, and
                             should default to 299.00 if not specified
   5. published_year     -> must only allow years between 1900 and 2026
   6. author_id           -> must reference a valid author from the
                              Authors table (Foreign Key)

   Write your CREATE TABLE statement below:
   ------------------------------------------------------------ */

CREATE TABLE Books
 ( book_id INT PRIMARY KEY, 
 title VARCHAR(150) NOT NULL,
 isbn VARCHAR(20) UNIQUE,
 price DECIMAL(10,2) DEFAULT 299.00,
 published_year INT, author_id INT NOT NULL,
 CONSTRAINT chk_book_price CHECK (price > 0),
 CONSTRAINT chk_published_year CHECK (published_year BETWEEN 1900 AND 2026), 
CONSTRAINT fk_books_authors FOREIGN KEY (author_id) REFERENCES Authors(author_id) );


/* Insert 10 rows into Books.
   Distribute books across the author_id values from Authors.
   At least 2 rows should rely on the DEFAULT price. */

INSERT INTO Books 
(book_id, title, isbn, price, published_year, author_id) 
VALUES
 (101, 'Malgudi Days', 'ISBN1001', 350.00, 1943, 1), 
 (102, 'Hamlet Modern Edition', 'ISBN1002', 250.00, 2005, 2),
 (103, 'Harry Potter and the Philosopher Stone', 'ISBN1003', 599.00, 1997, 3),
 (104, '1984', 'ISBN1004', 399.00, 1949, 4),
 (105, 'Five Point Someone', 'ISBN1005', 299.00, 2004, 5),
 (106, 'The God of Small Things', 'ISBN1006', 450.00, 1997, 6), 
 (107, 'The Alchemist', 'ISBN1007', 399.00, 1988, 7),
 (108, 'Wise and Otherwise', 'ISBN1008', 325.00, 2002, 8);

INSERT INTO Books
 (book_id, title, isbn, published_year, author_id)
 VALUES
 (109, 'The Blue Umbrella', 'ISBN1009', 1980, 9),
 (110, 'The Immortals of Meluha', 'ISBN1010', 2010, 10);

SELECT * FROM Books;

/* ------------------------------------------------------------
   TABLE 3: Members  (Parent table)
   ------------------------------------------------------------
   1. member_id      -> uniquely identifies each member, cannot be empty
   2. member_name    -> cannot be left empty
   3. age              -> must only allow members aged 12 or older
   4. email             -> must be unique across all members
   5. membership_type   -> should default to 'Standard' if not specified

   Write your CREATE TABLE statement below:
   ------------------------------------------------------------ */
CREATE TABLE Members
( member_id INT PRIMARY KEY, 
member_name VARCHAR(100) NOT NULL,
age INT, email VARCHAR(100) UNIQUE, 
membership_type VARCHAR(30) DEFAULT 'Standard', 
CONSTRAINT chk_member_age CHECK (age >= 12) );



/* Insert 10 rows into Members.
   At least 2 rows should rely on the DEFAULT membership_type.
   At least 1 row should have a NULL email (optional but unique
   when provided). */
INSERT INTO Members
 (member_id, member_name, age, email, membership_type) 
 
 VALUES
 (201, 'Rahul Sharma', 25, 'rahul@gmail.com', 'Premium'),
 (202, 'Priya Singh', 22, 'priya@gmail.com', 'Gold'),
 (203, 'Amit Kumar', 30, 'amit@gmail.com', 'Premium'),
 (204, 'Sneha Das', 19, 'sneha@gmail.com', 'Standard'),
 (205, 'Rohit Verma', 35, 'rohit@gmail.com', 'Gold'),
 (206, 'Anjali Patel', 28, 'anjali@gmail.com', 'Premium'),
 (207, 'Karan Mehta', 17, 'karan@gmail.com', 'Student'),
 (208, 'Neha Gupta', 21, NULL, 'Standard');

INSERT INTO Members
 (member_id, member_name, age, email)
 VALUES 
 (209, 'Suresh Rao', 40, 'suresh@gmail.com'),
 (210, 'Pooja Nair', 24, 'pooja@gmail.com');

select * from Members;
/* ------------------------------------------------------------
   TABLE 4: Transactions  (Child of Books AND Members)
   ------------------------------------------------------------
   1. transaction_id  -> uniquely identifies each transaction, cannot be empty
   2. book_id           -> must reference a valid book from the
                            Books table (Foreign Key)
   3. member_id          -> must reference a valid member from the
                             Members table (Foreign Key)
   4. issue_date          -> cannot be left empty
   5. return_date          -> no constraint (can be NULL if not yet returned)
   6. status                -> should default to 'Issued' if not specified
   7. fine                   -> must only allow values of 0 or more, and
                                 should default to 0.00 if not specified

   Write your CREATE TABLE statement below:
   ------------------------------------------------------------ */

CREATE TABLE Transactions 
( transaction_id INT PRIMARY KEY,
 book_id INT NOT NULL,
 member_id INT NOT NULL, 
 issue_date DATE NOT NULL, 
 return_date DATE, 
 status VARCHAR(30) DEFAULT 'Issued', 
 fine DECIMAL(10,2) DEFAULT 0.00, 
 CONSTRAINT chk_transaction_fine CHECK (fine >= 0),
 CONSTRAINT fk_transactions_books FOREIGN KEY (book_id) REFERENCES Books(book_id),
 CONSTRAINT fk_transactions_members FOREIGN KEY (member_id) REFERENCES Members(member_id) );


/* Insert 10 rows into Transactions.
   Mix book_id and member_id values from the tables above.
   At least 2 rows should rely on the DEFAULT status and/or fine.
   At least 2 rows should have a NULL return_date (not yet returned). */
INSERT INTO Transactions 
(transaction_id, book_id, member_id, issue_date, return_date, status, fine)
 VALUES
 (301, 101, 201, '2026-06-01', '2026-06-10', 'Returned', 0.00), 
 (302, 102, 202, '2026-06-03', '2026-06-14', 'Returned', 20.00),
 (303, 103, 203, '2026-06-05', NULL, 'Issued', 0.00),
 (304, 104, 204, '2026-06-07', '2026-06-18', 'Returned', 10.00),
 (305, 105, 205, '2026-06-10', '2026-06-20', 'Returned', 0.00),
 (306, 106, 206, '2026-06-12', NULL, 'Issued', 0.00), 
 (307, 107, 207, '2026-06-15', '2026-06-25', 'Returned', 0.00),
 (308, 108, 208, '2026-06-17', '2026-06-30', 'Returned', 30.00);

INSERT INTO Transactions 
(transaction_id, book_id, member_id, issue_date, return_date) 
VALUES 
(309, 109, 209, '2026-07-01', NULL), 
(310, 110, 210, '2026-07-02', NULL);


/* ============================================================
   CONSTRAINT-BREAKING DEMOS
   Write ONE INSERT statement for each case below. Run it,
   note the error, then write down (as a comment) which
   constraint caused it to fail.
   ============================================================ */

-- 1. Insert an Author with a NULL author_name
INSERT INTO Authors
(author_id, author_name, country, birth_year)
VALUES
(11, NULL, 'India', 1990);-- NOT NULL constraint on author_name

-- 2. Insert an Author with birth_year = 1750 (violates CHECK)
INSERT INTO Authors 
(author_id, author_name, country, birth_year)
 VALUES
 (12, 'Test Author', 'India', 1750);-- CHECK constraint because birth_year must be between 1800 and 2015

-- 3. Insert a Book with a duplicate isbn
INSERT INTO Books
(book_id, title, isbn, price, published_year, author_id) 
VALUES
(111, 'Duplicate ISBN Book', 'ISBN1001', 350.00, 2020, 1);-- UNIQUE constraint on isbn

-- 4. Insert a Book with price = -100 (violates CHECK)
INSERT INTO Books 
(book_id, title, isbn, price, published_year, author_id) 
VALUES 
(112, 'Negative Price Book', 'ISBN1012', -100.00, 2020, 1);-- CHECK constraint because price must be greater than 0

-- 5. Insert a Book with an author_id that does not exist in Authors
--    (violates FOREIGN KEY)
INSERT INTO Books 
(book_id, title, isbn, price, published_year, author_id) 
VALUES
(113, 'Unknown Author Book', 'ISBN1013', 300.00, 2021, 999);-- FOREIGN KEY constraint because author_id 999 does not exist

-- 6. Insert a Member with a duplicate member_id
INSERT INTO Members
(member_id, member_name, age, email, membership_type)
VALUES
(201, 'Duplicate Member', 25, 'duplicate@gmail.com', 'Standard');-- PRIMARY KEY constraint on member_id

-- 7. Insert a Member with age = 9 (violates CHECK)
INSERT INTO Members 
(member_id, member_name, age, email, membership_type)
VALUES
(211, 'Young Member', 9, 'young@gmail.com', 'Standard');-- CHECK constraint because age must be 12 or older

-- 8. Insert a Member with a duplicate email
INSERT INTO Members
(member_id, member_name, age, email, membership_type)
VALUES
(212, 'Duplicate Email Member', 28, 'rahul@gmail.com', 'Premium');-- UNIQUE constraint on email

-- 9. Insert a Transaction with a book_id that does not exist in Books
--    (violates FOREIGN KEY)
INSERT INTO Transactions
(transaction_id, book_id, member_id, issue_date, return_date, status, fine)
VALUES
(311, 999, 201, '2026-07-05', NULL, 'Issued', 0.00);-- FOREIGN KEY constraint because book_id 999 does not exist

-- 10. Insert a Transaction with a member_id that does not exist in Members
--     (violates FOREIGN KEY)
INSERT INTO Transactions
(transaction_id, book_id, member_id, issue_date, return_date, status, fine)
VALUES
(312, 101, 999, '2026-07-05', NULL, 'Issued', 0.00);-- FOREIGN KEY constraint because member_id 999 does not exist

-- 11. Insert a Transaction with a NULL issue_date
INSERT INTO Transactions
(transaction_id, book_id, member_id, issue_date, return_date, status, fine)
VALUES
(313, 101, 201, NULL, NULL, 'Issued', 0.00);-- NOT NULL constraint on issue_date

-- 12. Insert a Transaction with fine = -50 (violates CHECK)
INSERT INTO Transactions
(transaction_id, book_id, member_id, issue_date, return_date, status, fine)
VALUES
(314, 102, 202, '2026-07-05', NULL, 'Issued', -50.00);-- CHECK constraint because fine must be 0 or more
