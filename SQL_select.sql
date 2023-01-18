-- SELECT command 

SELECT 
    *
FROM
    employees;

SELECT 
    first_name, last_name
FROM
    employees;
    
    SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis';
    
    
    -- SELECT command with WHERE condition
    
     SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Elvis';
    
        -- select commands with WHERE + AND condition
        
SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis' AND gender = 'M';
    
    SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' AND  gender = 'F';
    
    
            -- select commands with WHERE + OR condition
 
 SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis' OR first_name = 'Elvis';
    
     SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Denis' OR last_name = 'Nicolson';
    
    
     SELECT 
    *
FROM
    employees
WHERE
    first_name = 'Kellie' OR first_name = 'Aruna';
    
    
                -- select commands with WHERE + AND + OR condition
                
     SELECT 
    *
FROM
    employees
WHERE
    last_name = 'Denis'
        AND (gender = 'M' OR gender = 'F');
        
             SELECT 
    *
FROM
    employees
WHERE
    gender = 'F'
        AND (first_name = 'Kellie'
        OR first_name = 'Aruna');
        
        
                        -- select commands with WHERE + IN / NOT IN condition
     
                  SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Cathie' , 'Mark', 'Nathan');
    
                      SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('Cathie' , 'Mark', 'Nathan');
    
                      SELECT 
    *
FROM
    employees
WHERE
    first_name IN ('Denis', 'Elvis');
      
      
                      SELECT 
    *
FROM
    employees
WHERE
    first_name NOT IN ('John', 'Mark', 'Jacob');
    
    
                            -- select commands with WHERE + LIKE / NOT LIKE condition
			
		
        SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('%Ar%');      
    
    
            SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('_Ar_'); 
 
 	
        SELECT 
    *
FROM
    employees
WHERE
    first_name NOT LIKE ('%Ar%');      
    
    
            SELECT 
    *
FROM
    employees
WHERE
    first_name NOT LIKE ('_Ar_'); 
    
            SELECT 
    *
FROM
    employees
WHERE
    first_name LIKE ('Mark%') AND hire_date LIKE ('2000%') ;
    
    
                SELECT 
    *
FROM
    employees
WHERE
    hire_date LIKE ('2000%');
    
    
SELECT 
    *
FROM
    employees
WHERE
   emp_no LIKE ('1000_'); 
   
   
   -- wildcard characters %, _, *
   # employees whose first name is jack
   SELECT 
    *
FROM
    employees
WHERE
   first_name LIKE ('%Jack%');
   # employees whose first name isn't jack
    SELECT 
    *
FROM
    employees
WHERE
   first_name NOT LIKE ('%Jack%');
   
   -- select commands with WHERE + BETWEEN ... AND.../NOT BETWEEN ... AND... condition

   SELECT 
    *
FROM
    employees
WHERE
    hire_date BETWEEN '1990-01-01' AND '2000-01-01';

       SELECT 
    *
FROM
    employees
WHERE
    hire_date NOT BETWEEN '1990-01-01' AND '2000-01-01';
   # information from the “salaries” table regarding contracts from 66,000 to 70,000 dollars per year.    
           SELECT 
    *
FROM
    salaries
WHERE
   salary BETWEEN '66000' AND '70000';
     # list with all individuals whose employee number is not between ‘10004’ and ‘10012’.  
              SELECT 
    *
FROM
    employees
WHERE
   emp_no NOT BETWEEN '10004' AND '10012';
   # names of all departments with numbers between ‘d003’ and ‘d006’.
                 SELECT 
    dept_name
FROM
    departments
WHERE
   dept_no BETWEEN 'd003' AND 'd006';
   
    -- select commands with WHERE + IS NOT NULL / IS NULL condition
    
                  SELECT 
    *
FROM
    employees
WHERE
    first_name IS NOT NULL;
    
                      SELECT 
    *
FROM
    employees
WHERE
    first_name IS NULL;
    
    # the names of all departments whose department number value is not null.
                   SELECT 
    dept_name
FROM
    departments
WHERE
   dept_no IS NOT NULL;
   
   -- Comparison operators 
  # a list with data about all female employees who were hired in the year 2000 or after.
                        SELECT 
    *
FROM
    employees
WHERE
    gender = 'F' AND hire_date >= '2000-01-01';
    
    # a list with all employees’ salaries higher than $150,000 per annum.
    
                            SELECT 
    *
FROM
    salaries
WHERE
    salary > '150000';
    
     -- SELECT DISTINCT command
    SELECT DISTINCT
    gender
FROM
    employees; 
    
    # a list with all different “hire dates” from the “employees” table.
        SELECT DISTINCT
    hire_date
FROM
    employees; 
    
    -- Aggregate functions: COUNT()
    # how many employees are present in the database
SELECT 
    COUNT(emp_no)
FROM
    employees;
    # how many different names are present in the employees table
SELECT 
    COUNT(distinct first_name)
FROM
    employees;
    
    # How many annual contracts with a value higher than or equal to $100,000 have been registered in the salaries table?
     SELECT 
    COUNT(*)
FROM
    salaries
WHERE
    salary >= '100000';
    
    # How many managers do we have in the “employees” database?
SELECT 
    COUNT(*)
FROM
    dept_manager;
    
        -- ORDER BY command
        # order employees by hire date in descending order.
SELECT 
    *
FROM
    employees
ORDER BY hire_date DESC;

        -- GROUP BY + AS command
# list of firs names and how many times they were encountered on the database.
SELECT 
    first_name, COUNT(first_name) AS names_count
FROM
    employees
GROUP BY first_name
ORDER BY first_name DESC;

# Write a query that obtains two columns. The first column must contain annual salaries higher than 80,000 dollars. The second column, renamed to “emps_with_same_salary”, must show the number of employees contracted to that salary. Lastly, sort the output by the first column.
SELECT salary, COUNT(emp_no) AS emps_with_same_salary
FROM salaries
WHERE salary > 80000
GROUP BY salary
ORDER BY salary;

-- HAVING command 
# extract all first names that appear more than 250 times in the employees table.
SELECT first_name, COUNT(first_name) AS names_count
FROM employees
GROUP BY first_name
HAVING COUNT(first_name) > 250
ORDER BY first_name;

# employees whose average salary is higher than $120,000 per annum.
SELECT emp_no, AVG(salary) AS salary_avg
FROM salaries
GROUP BY emp_no
HAVING AVG(salary) > 120000
ORDER BY emp_no;

# List of all names that are encountered less than 200 times. let the data refer to people hired after 1999-01-01.
SELECT first_name, COUNT(first_name) AS names_count
FROM employees
WHERE hire_date > '1999-01-01'
GROUP BY first_name
HAVING COUNT(first_name) < 200
ORDER BY first_name DESC;

# Select the employee numbers of all individuals who have signed more than 1 contract after the 1st of January 2000.
SELECT from_date FROM dept_emp;
SELECT emp_no, COUNT(from_date) AS contract_count
FROM dept_emp
WHERE from_date > '2000-01-01'
GROUP BY emp_no
HAVING COUNT(from_date) > 1
ORDER BY emp_no;

-- LIMIT command
# the first 100 rows from the ‘dept_emp’ table. 
SELECT 
    *
FROM
    dept_emp
LIMIT 100;
