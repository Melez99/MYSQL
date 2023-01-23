-- SQL views

SELECT 
    *
FROM
    dept_emp;
    
SELECT emp_no, from_date, to_date, COUNT(emp_no) AS num
FROM dept_emp
GROUP BY emp_no
HAVING num > 1
ORDER BY emp_no;


# visualise only the period encompassing the last contract of each employee

CREATE OR REPLACE VIEW v_department_employee_latest_date AS
    SELECT 
        emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
    FROM
        dept_emp
    GROUP BY emp_no;
    
SELECT * FROM employees.v_department_employee_latest_date;

# Create a view that will extract the average salary of all managers registered in the database. Round this value to the nearest cent.

CREATE OR REPLACE VIEW v_salaries_average_manager_salary AS
    SELECT 
    ROUND(AVG(salary), 2) AS average_salary
FROM
    salaries s
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            s.emp_no = t.emp_no
                AND t.title = 'Manager');
                
    
CREATE OR REPLACE VIEW v_salaries_average_manager_salary2 AS
    SELECT 
    ROUND(AVG(salary), 2)
FROM
    salaries s
        JOIN
    dept_manager m ON s.emp_no = m.emp_no;
    

-- Stored routines

use employees;

DROP PROCEDURE IF EXISTS select_employees;

DELIMITER //
CREATE PROCEDURE select_employees()
BEGIN
		SELECT * FROM employees
        LIMIT 1000;
END //
DELIMITER ;

CALL employees.select_employees();

# Procedure that will provide the average salary of all employees.

DROP PROCEDURE IF EXISTS average_salary_employees;

DELIMITER //
CREATE PROCEDURE average_salary_employees()
BEGIN
		SELECT AVG(salary) FROM salaries
        LIMIT 1000;
END //
DELIMITER ;

CALL employees.average_salary_employees();


-- Stored procedures with an input parameter

# Retrieve the salary of any selected employee (excecute from stored procedures in schema section)

DROP PROCEDURE IF EXISTS emp_salary;

DELIMITER //
USE employees //
CREATE PROCEDURE emp_salary(IN p_emp_no INTEGER)
BEGIN
		SELECT 
			e.first_name, e.last_name, s.salary, s.from_date, s.to_date
		FROM
			employees e
		JOIN
			salaries s ON e.emp_no = s.emp_no
		WHERE e.emp_no = p_emp_no;
END //
DELIMITER ;

CALL employees.emp_salary(33333);

DROP PROCEDURE IF EXISTS emp_average_salary;

DELIMITER //
USE employees //
CREATE PROCEDURE emp_average_salary(IN p_emp_no INTEGER)
BEGIN
		SELECT 
			e.first_name, e.last_name, AVG(s.salary)
		FROM
			employees e
		JOIN
			salaries s ON e.emp_no = s.emp_no
		WHERE e.emp_no = p_emp_no;
END //
DELIMITER ;

CALL employees.emp_average_salary(33333);


-- Stored procedures with an output parameter

# input emp_no to output the selected employee's salary

DROP PROCEDURE IF EXISTS emp_average_salary_out;
USE employees;

DELIMITER //
CREATE PROCEDURE emp_average_salary_out(IN p_emp_no INTEGER, out p_average_salary DECIMAL (10,2))
BEGIN
		SELECT 
			AVG(s.salary)
		INTO p_average_salary FROM
			employees e
		JOIN
			salaries s ON e.emp_no = s.emp_no
		WHERE e.emp_no = p_emp_no;
END //
DELIMITER ;

# Create a procedure called ‘emp_info’ that uses as parameters the first and the last name of an individual, and returns their employee number.

DROP PROCEDURE IF EXISTS emp_info;
USE employees;

DELIMITER $$
CREATE PROCEDURE emp_info(in p_first_name varchar(255), in p_last_name varchar(255), out p_emp_no integer)
BEGIN
	  SELECT
			e.emp_no
		INTO 
			p_emp_no 
        FROM 
			employees e
		WHERE
			e.first_name = p_first_name
		AND 
			e.last_name = p_last_name;
END$$
DELIMITER ;


-- Variables

SET @v_average_salary = 0;
CALL employees.emp_average_salary_out(33333, @v_average_salary);
SELECT @v_average_salary;

# Create a variable, called ‘v_emp_no’, where you will store the output of the procedure you created in the last exercise.
# Call the same procedure, inserting the values ‘Aruna’ and ‘Journel’ as a first and last name respectively.

SET @v_emp_no = 0;
CALL employees.emp_info('Aruna', 'Journel', @v_emp_no);
SELECT @v_emp_no;


-- User-defined functions

# DETERMISTIC solves error 1418. It states that the function will always return identical result given the same input

DROP FUNCTION IF EXISTS f_emp_average_salary;

DELIMITER //
CREATE FUNCTION f_emp_average_salary (p_emp_no INTEGER) RETURNS DECIMAL (10,2)
DETERMINISTIC
BEGIN
DECLARE v_average_salary DECIMAL (10,2);
SELECT 
	AVG(s.salary)
INTO v_average_salary FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
			WHERE e.emp_no = p_emp_no;
RETURN v_average_salary;
END //
DELIMITER ;

SELECT f_emp_average_salary(33333);


SET @v_emp_no = 33333;
SELECT
	emp_no,
    first_name,
    last_name,
    f_emp_average_salary(@v_emp_no) AS average_salary
FROM
	employees
WHERE
	emp_no = @v_emp_no;
    
    
    
    
# Create a function called ‘emp_info’ that takes for parameters the first and last name of an employee, and returns the salary from the newest contract of that employee.

DROP FUNCTION IF EXISTS f_emp_average_salary;

DELIMITER //
CREATE FUNCTION emp_info(p_first_name varchar(255), p_last_name varchar(255)) RETURNS decimal(10,2)
DETERMINISTIC 
BEGIN
DECLARE v_max_from_date date;
DECLARE v_salary decimal(10,2);
SELECT 
    MAX(from_date)
INTO v_max_from_date FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name;

SELECT 
    s.salary
INTO v_salary FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE
    e.first_name = p_first_name
        AND e.last_name = p_last_name
        AND s.from_date = v_max_from_date;

RETURN v_salary;

END//
DELIMITER ;

SELECT EMP_INFO('Aruna', 'Journel');


-- Type of variables

-- Local variables

DROP FUNCTION IF EXISTS f_emp_average_salary;

DELIMITER //
CREATE FUNCTION f_emp_average_salary (p_emp_no INTEGER) RETURNS DECIMAL (10,2)
DETERMINISTIC
BEGIN
DECLARE v_average_salary DECIMAL (10,2);
SELECT 
	AVG(s.salary)
INTO v_average_salary FROM
		employees e
			JOIN
		salaries s ON e.emp_no = s.emp_no
			WHERE e.emp_no = p_emp_no;
RETURN v_average_salary;
END //
DELIMITER ;


-- Session variables

SET @s_var1 = 3;

SELECT @s_var1;


-- Global connections 

SET GLOBAL max_connections = 1000;

SET @@global.max_connections = 1;


-- MySQL Triggers

USE employees;

COMMIT;


-- Before INSERT

DELIMITER //

CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0; 
	END IF; 
END //

DELIMITER ;


# insert a new entry for employee 10001, whose salary will be a negative number.

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    
INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');

SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    

-- Before UPDATE

DELIMITER //

CREATE TRIGGER trig_upd_salary
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = OLD.salary; 
	END IF; 
END //

DELIMITER ;

# modify the salary value of employee 10001 with another positive value.

UPDATE salaries 
SET 
    salary = 98765
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# Run another UPDATE statement, with which we will try to modify the salary earned by 10001 with a negative value, minus 50,000. It does not work due to the trigger.
        
UPDATE salaries 
SET 
    salary = - 50000
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        

-- System functions

# SYSDATE() delivers the date and time of the moment at which a function is invoked.
   
SELECT SYSDATE();

# “Date Format”, assigns a specific format to a given date.

SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;


# A new employee has been promted to manager. Annual salary should immediately become $20000 higher than the highest annual salary they'd ever earned until that moment.
# A new record needs to be created in the "department manager" table.
# Create a trigger that will apply several modifications to the "salaries" table once the relevant record in the "department manager" table has been inserted.
# An ‘after’ trigger that automatically adds $20,000 to the salary of the employee who was just promoted as a manager and sets the start date of her new contract to be the day on which the insert statement is executed.


DELIMITER //

CREATE TRIGGER trig_ins_dept_mng
AFTER INSERT ON dept_manager
FOR EACH ROW
BEGIN
	DECLARE v_curr_salary int;
    
SELECT 
    MAX(salary)
INTO v_curr_salary FROM
    salaries
WHERE
    emp_no = NEW.emp_no;

	IF v_curr_salary IS NOT NULL THEN
		UPDATE salaries 
		SET 
			to_date = SYSDATE()
		WHERE
			emp_no = NEW.emp_no and to_date = NEW.to_date;

		INSERT INTO salaries 
			VALUES (NEW.emp_no, v_curr_salary + 20000, NEW.from_date, NEW.to_date);
    END IF;
END //

DELIMITER ;

 
INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%y-%m-%d'), '9999-01-01');

SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no = 111534;
    
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = 111534;


ROLLBACK;


# Create a trigger that checks if the hire date of an employee is higher than the current date. If true, set this date to be the current date.

DELIMITER //

CREATE TRIGGER trig_hire_date  
BEFORE INSERT ON employees
FOR EACH ROW  
BEGIN 
       IF NEW.hire_date > date_format(sysdate(), '%Y-%m-%d') THEN     
       SET NEW.hire_date = date_format(sysdate(), '%Y-%m-%d');     
END IF;  
END //  

DELIMITER ;  

   
INSERT employees VALUES ('999904', '1970-01-31', 'John', 'Johnson', 'M', '2025-01-01');  

SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC;



-- MySQL Indexes

SELECT 
	*
FROM 
	employees
WHERE 
	hire_date > '2000-01-01';
    
CREATE INDEX i_hire_date ON employees(hire_date);
    
SELECT 
	*
FROM 
	employees
WHERE 
	first_name = 'Georgi'
	AND last_name = 'Facello';
    
CREATE INDEX i_composite ON employees(first_name, last_name);

SHOW INDEX FROM employees FROM employees;

ALTER TABLE employees
DROP INDEX i_hire_date;

# Select all records from the ‘salaries’ table of people whose salary is higher than $89,000 per annum.
# Create an index on the ‘salary’ column of that table, and check if it has sped up the search of the same SELECT statement

SELECT 
    *
FROM
    salaries
WHERE
    salary > 89000;
    
CREATE INDEX i_salary ON salaries(salary);

SELECT 
    *
FROM
    salaries
WHERE
    salary > 89000;
    
    
-- The CASE statement

SELECT 
	emp_no, 
    first_name,
    last_name,
CASE
	WHEN gender = 'M' THEN 'Male'
	ELSE 'Female'
END AS Gender
FROM 
	employees;
    
    
SELECT 
	emp_no, 
    first_name,
    last_name,
CASE gender
	WHEN 'M' THEN 'Male'
	ELSE 'Female'
END AS Gender
FROM 
	employees;

-- IF() instead of CASE statement

SELECT 
	emp_no, 
    first_name,
    last_name,
IF(gender = 'M', 'Male', 'Female') AS Gender
FROM 
	employees;
    
    
-- Case statement with IS NULL/IS NOT NULL

SELECT 
	e.emp_no, 
    e.first_name,
    e.last_name,
CASE 
	WHEN dm.emp_no IS NOT NULL THEN 'Manager'
	ELSE 'Employee'
END AS is_manager
FROM 
	employees e
LEFT JOIN
	dept_manager dm ON dm.emp_no = e.emp_no
WHERE
	e.emp_no > 109990;
    
    

SELECT 
	dm.emp_no, 
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
CASE 
	WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more than $30000'
    WHEN MAX(s.salary) - MIN(s.salary) BETWEEN 20000 AND 30000 THEN 'Salary was raised by more than $20000 but less than $30000'
	ELSE 'Salary was raised by more than $30000'
END AS salary_increase
FROM 
	employees e
	JOIN
	dept_manager dm ON e.emp_no = dm.emp_no
	JOIN
	salaries s ON dm.emp_no = s.emp_no
GROUP BY s.emp_no;


# Obtain a result set containing the employee number, first name, and last name of all employees with a number higher than 109990. Create a fourth column in the query, indicating whether this employee is also a manager, according to the data provided in the dept_manager table, or a regular employee. 
    
SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN dm.emp_no IS NOT NULL THEN 'Manager'
        ELSE 'Employee'
    END AS is_manager
FROM
    employees e
        LEFT JOIN
    dept_manager dm ON dm.emp_no = e.emp_no
WHERE
    e.emp_no > 109990;
    
    
# Extract a dataset containing the following information about the managers: employee number, first name, and last name. Add two columns at the end – one showing the difference between the maximum and minimum salary of that employee, and another one saying whether this salary raise was higher than $30,000 or NOT.

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    CASE
        WHEN MAX(s.salary) - MIN(s.salary) > 30000 THEN 'Salary was raised by more then $30,000'
        ELSE 'Salary was NOT raised by more then $30,000'
    END AS salary_raise
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;  

   

SELECT 
    dm.emp_no,
    e.first_name,
    e.last_name,
    MAX(s.salary) - MIN(s.salary) AS salary_difference,
    IF(MAX(s.salary) - MIN(s.salary) > 30000,
        'Salary was raised by more then $30,000',
        'Salary was NOT raised by more then $30,000') AS salary_increase
FROM
    dept_manager dm
        JOIN
    employees e ON e.emp_no = dm.emp_no
        JOIN
    salaries s ON s.emp_no = dm.emp_no
GROUP BY s.emp_no;


# Extract the employee number, first name, and last name of the first 100 employees, and add a fourth column, called “current_employee” saying “Is still employed” if the employee is still working in the company, or “Not an employee anymore” if they aren’t.

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    CASE
        WHEN MAX(de.to_date) > SYSDATE() THEN 'Is still employed'
        ELSE 'Not an employee anymore'
    END AS current_employee
FROM
    employees e
        JOIN
    dept_emp de ON de.emp_no = e.emp_no
GROUP BY de.emp_no
LIMIT 100;
