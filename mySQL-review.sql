### MYSQL REVIEW ###

USE employees;

SHOW tables;

DESCRIBE employees;

SELECT 
	CONCAT(first_name, ' ', last_name) as full_name,
	birth_date, 
	hire_date,
	(DATEDIFF(curdate(), hire_date)) as number_of_days_employed
FROM employees
WHERE hire_date LIKE '199%'
	AND birth_date LIKE '%-12-25'
ORDER BY number_of_days_employed DESC;

SELECT CONCAT(
		LOWER(SUBSTR(first_name, 1, 1)), # lower-case first letter of first name 
		LOWER(SUBSTR(last_name, 1, 4)), # lower-case first four letters of last name
		'_', # add underscore
		SUBSTR(birth_date, 6, 2), # month born
		SUBSTR(YEAR(birth_date), 3, 2) # last 2 digits of year born
		     ) as username, #create alias
		   first_name, last_name, birth_date
FROM employees;

SELECT CONCAT(
		LOWER(SUBSTR(first_name, 1, 1)), # lower-case first letter of first name 
		LOWER(SUBSTR(last_name, 1, 4)), # lower-case first four letters of last name
		'_', # add underscore
		SUBSTR(birth_date, 6, 2), # month born
		SUBSTR(birth_date, 3, 2) # last 2 digits of year born
		     ) as username, #create alias
		   first_name, last_name, birth_date
FROM employees;

SELECT first_name, last_name
FROM employees
WHERE last_name LIKE 'E%e'
GROUP BY first_name, last_name;

SELECT CONCAT(first_name, ' ', last_name) as full_name, COUNT(*) as n_same_name
FROM employees
WHERE last_name LIKE 'E%e'
GROUP BY full_name
HAVING n_same_name > 1;

SELECT d.dept_name AS 'Department Name', CONCAT(e.first_name, ' ', e.last_name) AS 'Department Manager' #select columns to be displayed and use aliases to rename
FROM employees AS e #select starting table that we will be joining to and rename to facilitate referencing columns
JOIN dept_manager AS dm #join with inner join to the employees the dept_manager table (associative table) renaming using an alias again
ON dm.emp_no = e.emp_no #we are using column in common emp_no to connect the two tables
JOIN departments AS d #join with inner join to the table the departments table renaming using alias again
ON d.dept_no = dm.dept_no #we are using column in common (dept_no) to connect the two tables
WHERE dm.to_date > curdate() AND e.gender = 'F' #Set condition to make sure we are only getting back current managers that are female
ORDER BY d.dept_name; #order results to match order shown in exercises - can reference column name using original name or aliases

# Find all the current employees with the same hire date as employee 101010 using a sub-query.

# Create subqueries first
SELECT hire_date
FROM employees
WHERE emp_no = '101010';

SELECT emp_no
FROM dept_emp
WHERE to_date > curdate();

# Now use subqueries as where clause in final query
SELECT *
FROM employees
WHERE hire_date = (
	SELECT hire_date
	FROM employees
	WHERE emp_no = '101010')
AND emp_no IN (
	SELECT emp_no
	FROM dept_emp
	WHERE to_date > CURDATE());
	
	
### Cognizant Tekstac Problems ###

-- CREATE TABLE IF NOT EXISTS department (
--     department_id INT,
--     department_name VARCHAR(30),
--     department_block_number INT,
--     PRIMARY KEY (department_id)
-- );
    

INSERT INTO department(department_id, department_name, department_block_number)
VALUES
    (1, 'CSE', 3),
    (2, 'IT', 3),
    (3, 'SE', 3);

SELECT department_name
FROM department
WHERE department_block_number = 3
ORDER BY department_name;

SELECT partner_id, partner_name, phone_no
FROM delivery_partners
WHERE rating BETWEEN 3 AND 5
ORDER BY partner_id;

SELECT car_id, car_name, owner_id
FROM cars
WHERE car_type IN ('Hatchback', 'SUV')
ORDER BY car_id;

SELECT hotel_id, hotel_name, rating
FROM hotel_details
WHERE hotel_id IN
    (SELECT DISTINCT hotel_id
    FROM orders
    WHERE order_date LIKE '%07%')
ORDER BY hotel_id;

SELECT student_name, department_name
FROM student
JOIN department using(department_id)
WHERE city = 'Coimbatore'
ORDER BY student_name;

SELECT CONCAT(address, ', ', city) AS Address
FROM student
ORDER BY Address DESC;

SELECT NAME, CONCAT(SUBSTR(NAME, 1, 3), SUBSTR(PHNO, 1, 3)) AS PASSWORD
FROM USERS
ORDER BY NAME;

SELECT rental_id, car_id, customer_id, km_driven
FROM rentals
WHERE pickup_date LIKE '2019-08%';

INSERT INTO rentals(rental_id, customer_id, car_id, pickup_date, return_date, km_driven, fare_amount)
VALUES
    ('R001', 'C007', 'V004', '2018-03-10', '2018-03-10', 800, 9000),
    ('R002', 'C001', 'V007', '2018-03-11', '2018-03-12', 200, 3000),
    ('R003', 'C007', 'V003', '2018-04-15', '2018-04-15', 100, 1500),
    ('R004', 'C007', 'V001', '2018-05-16', '2018-05-18', 1000, 10000),
    ('R005', 'C004', 'V005', '2018-05-10', '2018-05-12', 900, 11000),
    ('R006', 'C004', 'V006', '2018-05-20', '2018-05-21', 200, 2500);
    
UPDATE customers SET phone_no = '9876543210' WHERE customer_id = 'CUST1004';

SELECT customer_id, customer_name, address, phone_no
FROM customers
WHERE email_id LIKE '%@gmail.com'
ORDER BY customer_id;

SELECT car_id, car_name, car_type
FROM cars
WHERE car_name LIKE 'Maruthi%'
    AND car_type = 'Sedan'
ORDER BY car_id;

SELECT CONCAT(hotel_name, ' is a ', hotel_type, ' hotel') AS HOTEL_INFO
FROM hotel_details
ORDER BY HOTEL_INFO DESC;

/* What I want to do is check if the user has booked at a specific hotel once, if they have, they should be removed from list of users to display
In python, you could loop through and create lists of all users and hotels and then if the hotel was in the list, remove them or add all others
to another list and then filter by that final list, not sure how to do it in SQL */

SELECT DISTINCT NAME, ADDRESS
FROM USERS
WHERE USER_ID NOT IN (
    SELECT USER_ID
    FROM BOOKINGDETAILS
    WHERE name = 'HDFC')
AND
    USER_ID IN (
    SELECT USER_ID
    FROM BOOKINGDETAILS
    )
ORDER BY 1;

SELECT order_date, SUM(order_amount) AS TOTAL_SALE
FROM orders
GROUP BY order_date
ORDER BY order_date;

-- use a subquery to get list of all hotel_ids that did take an order in May 19
-- use NOT in to get hotel info for those not in this list
SELECT hotel_id, hotel_name, hotel_type
FROM hotel_details
WHERE hotel_id NOT IN
    (SELECT hotel_id
    FROM orders
    WHERE order_date LIKE '2019-05%')
ORDER BY 1;

SELECT hotel_id, hotel_name, COUNT(*) AS NO_OF_ORDERS
FROM orders
JOIN hotel_details USING(hotel_id)
GROUP BY hotel_id
HAVING NO_OF_ORDERS > 5
ORDER BY 1;

SELECT DISTINCT owner_id, owner_name, address, phone_no
FROM owners
JOIN cars USING(owner_id)
WHERE car_name LIKE 'Maruthi%'
ORDER BY 1;

SELECT car_id, car_name, car_type
FROM cars
WHERE car_id NOT IN
    (SELECT DISTINCT car_id
    FROM rentals)
ORDER BY 1;

-- Not sure how this works, didn't submit it since it wasn't my code and I couldn't even decipher it fully
SELECT MAX(tour_count.tours) 
FROM 
( 
    SELECT
        ( SELECT COUNT(*) AS num 
        FROM COUNTRIES c 
        WHERE c.MIN_SIZE <= f.FAMILY_SIZE ) AS tours 
FROM FAMILIES f ) 
AS tour_count

SELECT CONCAT(customer_id, ' mail id is ', email_id) AS CUSTOMER_MAIL_INFO
FROM customers
ORDER BY 1;

SELECT order_id, customer_name, hotel_name, order_amount
FROM orders
JOIN customers USING(customer_id)
JOIN hotel_details USING(hotel_id)
ORDER BY 1;

-- Not sure how these joins with commas work, need to figure it out
SELECT b.bus_no, b.bus_name
FROM buses as b, schedule as s1, schedule as s2
WHERE b.bus_no = s1.bus_no AND s1.source = s2.destination
    AND s2.source = s1.destination AND s1.bus_no != s2.bus_no
ORDER BY 1;

-- SELECT b.bus_no, b.bus_name
-- FROM buses as b 
-- JOIN schedule as s1 USING(bus_no)
-- JOIN schedule as s2 USING(bus_no)
-- WHERE b.bus_no = s1.bus_no
--     AND s1.source = s2.destination
--     AND s2.source = s1.destination 
--     AND s1.bus_no != s2.bus_no
-- ORDER BY 1;

SELECT user_id, count(bd_id) as no_of_times
FROM bookingdetails
GROUP BY user_id
ORDER BY 1;

SELECT car_id, count(rental_id)
FROM rentals
GROUP BY car_id
ORDER BY 1;

SELECT CONCAT(owner_name, owner_id) AS USERNAME, 
        CONCAT(SUBSTR(owner_name, 1, 3), owner_id) AS PASSWORD
FROM owners
ORDER BY 1;

CREATE TABLE owners(
    owner_id VARCHAR(10),
    owner_name VARCHAR(20),
    address VARCHAR(20),
    phone_no BIGINT,
    email_id VARCHAR(20),
    PRIMARY KEY (owner_id)
);

ALTER TABLE cars
ADD COLUMN car_regno VARCHAR(10);

ALTER TABLE customers
MODIFY customer_id INT;

ALTER TABLE hotel_details
CHANGE rating hotel_rating INT;