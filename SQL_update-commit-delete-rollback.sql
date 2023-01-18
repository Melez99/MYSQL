
-- UPDATE statement

UPDATE employees 
SET 
    first_name = 'stella',
    last_name = 'Parkinson',
    birth_date = '1990-12-31',
    gender = 'F'
WHERE
    emp_no = 999901;
    
SELECT 
    *
FROM
    employees
ORDER BY emp_no DESC
LIMIT 10;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

-- COMMIT and ROLLBACK

COMMIT;

UPDATE departments_dup 
SET 
    dept_no = 'd011',
    dept_name = 'Quality Control';

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

ROLLBACK;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

COMMIT;

# Change the “Business Analysis” department name to “Data Analysis”.

UPDATE departments 
SET 
    dept_name = 'Data Analysis'
WHERE
    dept_no = 'd010';
    
COMMIT;

-- DELETE statement

SELECT 
    *
FROM
    employees
WHERE emp_no = 999903;

SELECT 
    *
FROM
    titles
WHERE emp_no = 999903;

DELETE FROM employees 
WHERE
    emp_no = 999903;
    
SELECT 
    *
FROM
    employees
WHERE emp_no = 999903;

SELECT 
    *
FROM
    titles
WHERE emp_no = 999903;

ROLLBACK;
COMMIT;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

DELETE FROM departments_dup;

SELECT 
    *
FROM
    departments_dup
ORDER BY dept_no;

ROLLBACK;
COMMIT;

# Remove the department number 10 record from the “departments” table.

DELETE FROM departments 
WHERE
    dept_no = 'd010';
    
COMMIT;
