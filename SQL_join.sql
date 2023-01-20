
-- JOIN statement

-- INNER JOIN

SELECT 
    *
FROM
    dept_manager_dup
ORDER BY dept_no;

 SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;   

SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
JOIN 
	departments_dup d ON m.dept_no = d.dept_no;
    
SELECT
	m.dept_no, m.emp_no, m.from_date, m.to_date, d.dept_name
FROM
	dept_manager_dup m
JOIN 
	departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;
    
    
# Extract a list containing information about all managers’ employee number, first and last name, department number, and hire date. 

SELECT 
    e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    employees e
        JOIN
    dept_manager m ON e.emp_no = m.emp_no;
    

# how to deal with duplicate records

INSERT INTO dept_manager_dup VALUES ('110228','d003','1992-03-21','9999-01-01');
INSERT INTO departments_dup VALUES ('d009','Customer Service');

SELECT 
    *
FROM
    dept_manager_dup
ORDER BY dept_no ASC;

 SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no ASC;

SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
JOIN 
	departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.dept_no, m.emp_no, d.dept_name
ORDER BY m.dept_no;

-- LEFT JOIN

DELETE FROM dept_manager_dup WHERE emp_no = '110228';
DELETE FROM departments_dup WHERE dept_no = 'd009';

INSERT INTO dept_manager_dup VALUES ('110228','d003','1992-03-21','9999-01-01');
INSERT INTO departments_dup VALUES ('d009','Customer Service');

SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
LEFT JOIN 
	departments_dup d ON m.dept_no = d.dept_no
GROUP BY m.dept_no, m.emp_no, d.dept_name
ORDER BY m.dept_no;


SELECT
	d.dept_no, m.emp_no, d.dept_name
FROM
	departments_dup d
LEFT JOIN 
	dept_manager_dup m ON m.dept_no = d.dept_no
ORDER BY d.dept_no;

# Obtain records of a table that are not in common with the other table

SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
LEFT JOIN 
	departments_dup d ON m.dept_no = d.dept_no
WHERE d.dept_name IS NULL
ORDER BY m.dept_no;

# Join the 'employees' and the 'dept_manager' tables to return a manager whose last name is Markovitch. 

SELECT
	m.emp_no, e.last_name
FROM
	dept_manager m 
LEFT JOIN 
	employees e ON m.emp_no = e.emp_no
WHERE e.last_name = 'Markovitch'
ORDER BY m.emp_no;


-- RIGHT JOIN

SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	dept_manager_dup m
RIGHT JOIN 
	departments_dup d ON m.dept_no = d.dept_no
ORDER BY m.dept_no;

SELECT
	m.dept_no, m.emp_no, d.dept_name
FROM
	departments_dup d 
LEFT JOIN 
	dept_manager_dup m ON m.dept_no = d.dept_no
ORDER BY m.dept_no;


-- Old JOIN syntax 

SELECT 
	m.dept_no, m.emp_no, d.dept_name
FROM 
	dept_manager_dup m,
    departments_dup d 
WHERE 
	m.dept_no = d.dept_no
ORDER BY m.dept_no;

# Extract a list containing information about all managers’ employee number, first and last name, department number, and hire date. Use the old type of join syntax to obtain the result.

SELECT 
    e.emp_no, e.first_name, e.last_name, m.dept_no, e.hire_date
FROM
    employees e,
    dept_manager m
WHERE
    e.emp_no = m.emp_no
ORDER BY e.emp_no;


-- JOIN + WHERE

SELECT 
    e.emp_no, e.first_name, e.last_name, s.salary
FROM
    employees e
        JOIN
    salaries s ON e.emp_no = s.emp_no
WHERE s.salary > 145000;

# Select the first and last name, the hire date, and the job title of all employees whose first name is “Margareta” and have the last name “Markovitch”

SELECT 
    e.emp_no, e.first_name, e.last_name, t.title
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
WHERE
    e.first_name = 'Margareta'
        AND last_name = 'Markovitch'
GROUP BY e.emp_no
ORDER BY e.emp_no; 


-- CROSS JOIN

SELECT
	dm.*, d.*
FROM
	dept_manager dm
CROSS JOIN 
	departments d 
ORDER BY dm.emp_no, d.dept_no;

SELECT
	dm.*, d.*
FROM
	dept_manager dm, 
	departments d
ORDER BY dm.emp_no, d.dept_no;

SELECT
	dm.*, d.*
FROM
	dept_manager dm
 JOIN 
	departments d 
ORDER BY dm.emp_no, d.dept_no;

# combine two tables to show all departments apart from the ones the manager is head of.

SELECT
	dm.*, d.*
FROM
	departments d 
CROSS JOIN 
	dept_manager dm
WHERE 
	d.dept_no <> dm.dept_no 
ORDER BY dm.emp_no, d.dept_no;

-- CROSS JOIN + JOIN

SELECT 
    e.*, d.*
FROM
    dept_manager dm
        CROSS JOIN
    departments d
        JOIN
    employees e ON dm.emp_no = e.emp_no
WHERE 
	d.dept_no <> dm.dept_no 
ORDER BY dm.emp_no, d.dept_no;

# Use a CROSS JOIN to return a list with all possible combinations between managers from the dept_manager table and department number 9.

SELECT
	dm.*, d.*
FROM
	dept_manager dm
CROSS JOIN 
	departments d 
WHERE d.dept_no = 'd009'
ORDER BY d.dept_no;

# Return a list with the first 10 employees with all the departments they can be assigned to.

SELECT
	e.*, d.*
FROM
	employees e
CROSS JOIN 
	departments d 
WHERE e.emp_no < 10011
ORDER BY e.emp_no;


-- JOIN + EGGREGATE FUNCTIONS

# Average salaries of men and women in the company

SELECT 
	e.gender, AVG(s.salary) AS average_salary
FROM 
	employees e
JOIN
	salaries s ON e.emp_no = s.emp_no
GROUP BY e.gender
ORDER BY average_salary;


-- JOIN more than two tables

SELECT 
	e.first_name,
    e.last_name,
    e.hire_date,
    m.from_date,
    d.dept_name
FROM
	employees e
JOIN
	dept_manager m ON e.emp_no = m.emp_no
JOIN 
	departments d ON m.dept_no = d.dept_no;
    
    
# Select all managers’ first and last name, hire date, job title, start date, and department name.

SELECT 
    e.emp_no,
    e.first_name,
    e.last_name,
    e.hire_date,
    t.title,
    dm.from_date,
    d.dept_name
FROM
    employees e
        JOIN
    titles t ON e.emp_no = t.emp_no
        JOIN
    dept_manager dm ON t.emp_no = dm.emp_no
        JOIN
    departments d ON dm.dept_no = d.dept_no
WHERE
    t.title = 'Manager'
ORDER BY e.emp_no;
    
# How many male and how many female managers do we have in the ‘employees’ database?

SELECT 
    e.gender, COUNT(dm.emp_no)
FROM
    employees e
        JOIN
    dept_manager dm ON e.emp_no = dm.emp_no
GROUP BY gender;