-- INSERT statement 

INSERT INTO employees 
( 	emp_no,
	birth_date,
    first_name,
    last_name,
    gender,
    hire_date	)
VALUES 
(	999901,
	'1986-04-21',
    'John',
    'Smith',
    'M',
    '2011-01-01'	);
    
INSERT INTO employees 
( 	emp_no,
	birth_date,
    first_name,
    last_name,
    gender,
    hire_date	)
	VALUES 
	(	999902,
		'1973-03-26',
		'Patricia',
		'Lawrence',
		'F',
		'2005-01-01'	);
    
        INSERT INTO employees 
VALUES 
(	999903,
	'1977-09-14',
    'Johnathan',
    'Creek',
    'M',
    '1999-01-01'	);
    
    SELECT 
    *
FROM
    employees
    ORDER BY emp_no DESC
LIMIT 10;

# ten records from the “titles” table to get a better idea about its content.

SELECT 
    *
FROM
    titles
LIMIT 10;

# insert information about employee number 999903, a “Senior Engineer”, with hire date on October 1st, 1997.

INSERT INTO titles VALUES (999903, 'Senior Engineer', '1997-10-01', '9999-01-01');

# check if insertion was successful
SELECT 
    *
FROM
    titles
ORDER BY emp_no DESC
LIMIT 10;

# Insert individual with employee number 999903 into the “dept_emp” table, working for department number 5, with hire date on October 1st, 1997; contract is for an indefinite period of time.
SELECT 
    *
FROM
    dept_emp;
INSERT INTO dept_emp VALUES (999903, 'd005', '1997-10-01', '9999-01-01');

SELECT 
    *
FROM
    dept_emp
ORDER BY emp_no DESC
LIMIT 10;

-- INSERT INTO SELECT statement

SELECT 
    *
FROM
    departments
ORDER BY dept_no DESC
LIMIT 10;

CREATE TABLE departments_dup
( dept_no CHAR(4) NOT NULL,
dept_name VARCHAR(40) NOT NULL);

INSERT INTO departments_dup (dept_no, dept_name)
SELECT * FROM departments;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no DESC
LIMIT 10;

# Create a new department called “Business Analysis”. Register it under number ‘d010’.

INSERT INTO departments VALUES ('d010', 'Business Analysis');

