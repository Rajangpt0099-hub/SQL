/* ============================================================
   PRACTICE FILE: AGGREGATE FUNCTIONS & TEXT FUNCTIONS
   Table: Products
   Instructions: Write the SQL query below each question.
   ============================================================ */


/* ------------------------------------------------------------
   STEP 1: CREATE TABLE
   ------------------------------------------------------------ */



create database practice
use practice
CREATE TABLE Products (
    product_id INT,
    product_name VARCHAR(50),
    category VARCHAR(50),
    city VARCHAR(50),
    price INT,
    description VARCHAR(100)
);


/* ------------------------------------------------------------
   STEP 2: INSERT DATA
   ------------------------------------------------------------ */

INSERT INTO Products VALUES
(1, 'wireless mouse', 'Electronics', 'Bangalore', 799, 'compact wireless mouse'),
(2, 'Office Chair', 'Furniture', 'Delhi', 4500, 'ergonomic office chair'),
(3, 'BLUETOOTH SPEAKER', 'Electronics', 'Bangalore', 2200, 'portable bluetooth speaker'),
(4, 'Study Table', 'Furniture', 'Mumbai', 3800, 'wooden study table'),
(5, 'laptop stand', 'Electronics', 'Pune', 1200, 'adjustable laptop stand'),
(6, 'Bookshelf', 'Furniture', 'Delhi', 3200, 'wall mounted bookshelf'),
(7, 'Table Lamp', 'Electronics', 'Mumbai', 950, 'LED table lamp'),
(8, '  Yoga Mat  ', 'Fitness', 'Bangalore', 600, 'non-slip yoga mat');
 select * from products;
 

/* ============================================================
   SECTION A: AGGREGATE FUNCTIONS
   ============================================================ */

-- Q1. Find the total number of products.
SELECT COUNT(*) AS total_products
FROM products;

-- Q2. Find the total value of all products (sum of prices).
SELECT SUM(price) AS total_value
FROM products;


-- Q3. Find the average price of products.

SELECT AVG(price) AS average_price
FROM products;

-- Q4. Find the most expensive and least expensive product price.
SELECT 
    MAX(price) AS most_expensive_price,
    MIN(price) AS least_expensive_price
FROM products;

-- Q5. Find how many products exist in each category.
SELECT category,
COUNT(*) AS total_products
FROM products
GROUP BY category;

-- Q6. Find the average price per city.

SELECT city,
AVG(price) AS average_price
FROM products
GROUP BY city;
-- Q7. Find categories where the average price is more than 2000.
SELECT category,
AVG(price) AS average_price
FROM products
GROUP BY category
HAVING AVG(price) > 2000;


-- Q8. Find the total price of products per city, sorted from highest to lowest.

SELECT city,
SUM(price) AS total_price
FROM products
GROUP BY city
ORDER BY total_price DESC;
-- Q9. Find the number of distinct cities the products are available in.
SELECT COUNT(DISTINCT city) AS distinct_cities
FROM products;


/* ============================================================
   SECTION B: TEXT FUNCTIONS
   ============================================================ */

-- Q1. Display all product names in uppercase and lowercase.

SELECT
TRIM(product_name) AS product_name,
LENGTH(TRIM(product_name)) AS name_length
FROM products;



-- Q2. Remove the extra spaces from the product_name column and display the cleaned result.

SELECT
TRIM(product_name) AS cleaned_product_name
FROM products;

-- Q3. Find the length of each product_name (after removing spaces).

SELECT
TRIM(product_name) AS product_name,
LENGTH(TRIM(product_name)) AS name_length
FROM products;

-- Q4. Extract the first 5 characters of each description.
SELECT
SUBSTRING(description, 1, 5) AS first_5_characters
FROM products;

-- Q5. Combine product_name and category into a single column separated by a hyphen.
SELECT
CONCAT(product_name, ' - ', category) AS product_details
FROM products;

-- Q6. Replace the word 'table' with 'desk' in the description column.
SELECT
REPLACE(description, 'table', 'desk') AS updated_description
FROM products;

-- Q7. Convert each product_name into proper case (first letter capital, rest lowercase).


-- Q8. Find all products whose description contains the word 'wireless'.
SELECT *
FROM products
WHERE description LIKE '%wireless%';

-- Q9. Find all products whose product_name starts with the letter 'B' (case-insensitive).
SELECT *
FROM products
WHERE LOWER(product_name) LIKE 'b%';
