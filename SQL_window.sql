-- MySQL Window fucntions 

-- The ROW_NUMBER() Ranking Window Function

USE employees;

SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER () AS row_num
FROM
	salaries;
    
SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM
	salaries;
    
-- The ROW_NUMBER() Ranking Window Function with PARTITION BY

SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num
FROM
	salaries;
    
SELECT 
	emp_no,
    salary,
    ROW_NUMBER() OVER w AS row_num
FROM
	salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);
    
# Write a query that upon execution, assigns a row number to all managers we have information for in the "employees" database (regardless of their department).
# Let the numbering disregard the department the managers have worked in. Also, let it start from the value of 1. Assign that value to the manager with the lowest employee number.

SELECT 
	emp_no,
    dept_no,
    ROW_NUMBER() OVER (ORDER BY emp_no) AS row_num
FROM
	dept_manager;

# Write a query that upon execution, assigns a sequential number for each employee number registered in the "employees" table. Partition the data by the employee's first name and order it by their last name in ascending order (for each partition).

SELECT 
	emp_no,
    first_name,
    last_name,
    ROW_NUMBER() OVER (PARTITION BY first_name ORDER BY last_name) AS row_num
FROM
	employees;
    
# Write a query that provides row numbers for all workers from the "employees" table, partitioning the data by their first names and ordering each partition by their employee number in ascending order.

SELECT
emp_no,
first_name,
ROW_NUMBER() OVER w AS row_num
FROM
employees
WINDOW w AS (PARTITION BY first_name ORDER BY emp_no);

    
# Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.
# Add a column containing the row number of each row from the obtained dataset, starting from 1.
# A column containing the sequential row numbers associated to the rows for each manager, where their highest salary has been given a number equal to the number of rows in the given partition, and their lowest - the number 1
# Finally, while presenting the output, make sure that the data has been ordered by the values in the first of the row number columns, and then by the salary values for each partition in ascending order.

SELECT
dm.emp_no,
    salary,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary ASC) AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2   
FROM
dept_manager dm
    JOIN 
    salaries s ON dm.emp_no = s.emp_no;
    
# Obtain a result set containing the salary values each manager has signed a contract for. To obtain the data, refer to the "employees" database.
# Add a column containing the row numbers associated to each manager, where their highest salary has been given a number equal to the number of rows in the given partition, and their lowest - the number 1.
# A column containing the row numbers associated to each manager, where their highest salary has been given the number of 1, and the lowest - a value equal to the number of rows in the given partition.
# Let your output be ordered by the salary values associated to each manager in descending order.

SELECT
dm.emp_no,
    salary,
    ROW_NUMBER() OVER () AS row_num1,
    ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary DESC) AS row_num2
FROM
dept_manager dm
    JOIN 
    salaries s ON dm.emp_no = s.emp_no
ORDER BY row_num1, emp_no, salary ASC;



-- The PARTITION BY Clause VS the GROUP BY Clause

# Find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword.

SELECT a.emp_no,
       MIN(salary) AS min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
GROUP BY emp_no;

# find out the lowest salary value each employee has ever signed a contract for. Once again, to obtain the desired output, use a subquery containing a window function. This time, however, introduce the window specification in the field list of the given subquery.

SELECT a.emp_no,
       MIN(salary) AS min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER (PARTITION BY emp_no ORDER BY salary) AS row_num
FROM
salaries) a
GROUP BY emp_no;

# find out the lowest salary value each employee has ever signed a contract for. This time, to obtain the desired output, avoid using a window function. Just use an aggregate function and a subquery.

SELECT
    a.emp_no, MIN(salary) AS min_salary
FROM
    (SELECT
        emp_no, salary
    FROM
        salaries) a
GROUP BY emp_no;

# Once more, find out the lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. Moreover, obtain the output without using a GROUP BY clause in the outer query.

SELECT a.emp_no,
a.salary as min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=1;

# Find out the second-lowest salary value each employee has ever signed a contract for. To obtain the desired output, use a subquery containing a window function, as well as a window specification introduced with the help of the WINDOW keyword. Moreover, obtain the desired result set without using a GROUP BY clause in the outer query.

SELECT a.emp_no,
a.salary as min_salary FROM (
SELECT
emp_no, salary, ROW_NUMBER() OVER w AS row_num
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)) a
WHERE a.row_num=2;


-- The MySQL RANK() and DENSE_RANK() Window Functions

# Write a query containing a window function to obtain all salary values that employee number 10560 has ever signed a contract for.

SELECT
emp_no,
salary,
ROW_NUMBER() OVER w AS row_num
FROM
salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);

# Write a query that upon execution, displays the number of salary contracts that each manager has ever signed while working in the company.

SELECT
    dm.emp_no, (COUNT(salary)) AS no_of_salary_contracts
FROM
    dept_manager dm
        JOIN
    salaries s ON dm.emp_no = s.emp_no
GROUP BY emp_no
ORDER BY emp_no;

# Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are allowed.

SELECT
emp_no,
salary,
RANK() OVER w AS rank_num
FROM
salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);


# Write a query that upon execution retrieves a result set containing all salary values that employee 10560 has ever signed a contract for. Use a window function to rank all salary values from highest to lowest in a way that equal salary values bear the same rank and that gaps in the obtained ranks for subsequent rows are not allowed.

SELECT
emp_no,
salary,
DENSE_RANK() OVER w AS rank_num
FROM
salaries
WHERE emp_no = 10560
WINDOW w AS (PARTITION BY emp_no ORDER BY salary DESC);


-- Ranking Window Functions and Joins

# Write a query that ranks the salary values in descending order of all contracts signed by employees numbered between 10500 and 10600 inclusive. Let equal salary values for one and the same employee bear the same rank. Also, allow gaps in the ranks obtained for their subsequent rows.

SELECT
    e.emp_no,
    RANK() OVER w as employee_salary_ranking,
    s.salary
FROM
employees e
JOIN
    salaries s ON s.emp_no = e.emp_no
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);

# Write a query that ranks the salary values in descending order of the following contracts from the "employees" database:
# contracts that have been signed by employees numbered between 10500 and 10600 inclusive.
# contracts that have been signed at least 4 full-years after the date when the given employee was hired in the company for the first time.
# In addition, let equal salary values of a certain employee bear the same rank. Do not allow gaps in the ranks obtained for their subsequent rows.

SELECT
    e.emp_no,
    DENSE_RANK() OVER w as employee_salary_ranking,
    s.salary,
    e.hire_date,
    s.from_date,
    (YEAR(s.from_date) - YEAR(e.hire_date)) AS years_from_start
FROM
employees e
JOIN
    salaries s ON s.emp_no = e.emp_no
    AND YEAR(s.from_date) - YEAR(e.hire_date) >= 5
WHERE e.emp_no BETWEEN 10500 AND 10600
WINDOW w as (PARTITION BY e.emp_no ORDER BY s.salary DESC);


-- The LAG() and LEAD() Value Window Functions

# Write a query that can extract the following information from the "employees" database:
# the salary values (in ascending order) of the contracts signed by all employees numbered between 10500 and 10600 inclusive
# a column showing the previous salary from the given ordered list
# a column showing the subsequent salary from the given ordered list
# a column displaying the difference between the current salary of a certain employee and their previous salary
# a column displaying the difference between the next salary of a certain employee and their current salary
# Limit the output to salary values higher than $80,000 only.
# to obtain a meaningful result, partition the data by employee number.

SELECT
emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
    LEAD(salary) OVER w AS next_salary,
    salary - LAG(salary) OVER w AS diff_salary_current_previous,
LEAD(salary) OVER w - salary AS diff_salary_next_current
FROM
salaries
    WHERE salary > 80000 AND emp_no BETWEEN 10500 AND 10600
WINDOW w AS (PARTITION BY emp_no ORDER BY salary);


# Create a query whose result set contains data arranged by the salary values associated to each employee number (in ascending order). Let the output contain the following six columns:
# The employee number, the salary value of an employee's contract, the employee's previous salary, the employee's contract salary value preceding their previous salary, the employee's next salary, and the employee's contract salary value subsequent to their next salary.
# Restrict the output to the first 1000 records you can obtain

SELECT
emp_no,
    salary,
    LAG(salary) OVER w AS previous_salary,
LAG(salary, 2) OVER w AS 1_before_previous_salary,
LEAD(salary) OVER w AS next_salary,
    LEAD(salary, 2) OVER w AS 1_after_next_salary
FROM
salaries
WINDOW w AS (PARTITION BY emp_no ORDER BY salary)
LIMIT 1000;


-- Aggregate Functions in the Context of Window Functions

# Create a query that upon execution returns a result set containing the employee numbers, contract salary values, start, and end dates of the first ever contracts that each employee signed for the company.

SELECT
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
        JOIN
    (SELECT
        emp_no, MIN(from_date) AS from_date
    FROM
        salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.from_date = s1.from_date;
    
    
# Consider the employees' contracts that have been signed after the 1st of January 2000 and terminated before the 1st of January 2002 (as registered in the "dept_emp" table).
# Create a MySQL query that will extract the following information about these employees:
# Their employee number, salary values of the latest contracts they have signed during the suggested time period, The department they have been working in (as specified in the latest contract they've signed during the suggested time period).
# Use a window function to create a fourth field containing the average salary paid in the department the employee was last working in during the suggested time period. Name that field "average_salary_per_department".

SELECT
    de2.emp_no, d.dept_name, s2.salary, AVG(s2.salary) OVER w AS average_salary_per_department
FROM
    (SELECT
    de.emp_no, de.dept_no, de.from_date, de.to_date
FROM
    dept_emp de
        JOIN
(SELECT
emp_no, MAX(from_date) AS from_date
FROM
dept_emp
GROUP BY emp_no) de1 ON de1.emp_no = de.emp_no
WHERE
    de.to_date < '2002-01-01'
AND de.from_date > '2000-01-01'
AND de.from_date = de1.from_date) de2
JOIN
    (SELECT
    s1.emp_no, s.salary, s.from_date, s.to_date
FROM
    salaries s
    JOIN
    (SELECT
emp_no, MAX(from_date) AS from_date
FROM
salaries
    GROUP BY emp_no) s1 ON s.emp_no = s1.emp_no
WHERE
    s.to_date < '2002-01-01'
AND s.from_date > '2000-01-01'
AND s.from_date = s1.from_date) s2 ON s2.emp_no = de2.emp_no
JOIN
    departments d ON d.dept_no = de2.dept_no
GROUP BY de2.emp_no, d.dept_name
WINDOW w AS (PARTITION BY de2.dept_no)
ORDER BY de2.emp_no, salary;


-- MySQL Common Table Expressions 

# Use a CTE (a Common Table Expression) and a SUM() function in the SELECT statement in a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average.

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;

# Use a CTE (a Common Table Expression) and (at least one) COUNT() function in the SELECT statement of a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average.

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
COUNT(CASE WHEN s.salary < c.avg_salary THEN s.salary ELSE NULL END) AS no_salaries_below_avg_w_count,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' JOIN cte c;

# Use MySQL joins (and don’t use a Common Table Expression) in a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).

SELECT
    SUM(CASE
        WHEN s.salary < a.avg_salary THEN 1
        ELSE 0
    END) AS no_salaries_below_avg,
    COUNT(s.salary) AS no_of_salary_contracts
FROM
    (SELECT
        AVG(salary) AS avg_salary
    FROM
        salaries s) a
        JOIN
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'M';

# Use a cross join (and don’t use a Common Table Expression or MySQL Joins) in a query to find out how many male employees have never signed a contract with a salary value higher than or equal to the all-time company salary average (i.e. to obtain the same result as in the previous exercise).

WITH cte AS (
SELECT AVG(salary) AS avg_salary FROM salaries
)
SELECT
SUM(CASE WHEN s.salary < c.avg_salary THEN 1 ELSE 0 END) AS no_salaries_below_avg_w_sum,
COUNT(s.salary) AS no_of_salary_contracts
FROM salaries s JOIN employees e ON s.emp_no = e.emp_no AND e.gender = 'M' CROSS JOIN cte c;


-- CTEs Subclauses in a WITH Clause-Exercise


# Use two common table expressions and a SUM() function in the SELECT statement of a query to obtain the number of male employees whose highest salaries have been below the all-time average.

WITH cte1 AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte2 AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s
JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no
)
SELECT
SUM(CASE WHEN c2.max_salary < c1.avg_salary THEN 1 ELSE 0 END) AS highest_salaries_below_avg
FROM employees e
JOIN cte2 c2 ON c2.emp_no = e.emp_no
JOIN cte1 c1;


# Use two common table expressions and a COUNT() function in the SELECT statement of a query to obtain the number of male employees whose highest salaries have been below the all-time average.

WITH cte_avg_salary AS (
SELECT AVG(salary) AS avg_salary FROM salaries
),
cte_m_highest_salary AS (
SELECT s.emp_no, MAX(s.salary) AS max_salary
FROM salaries s JOIN employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no
)
SELECT
COUNT(CASE WHEN c2.max_salary < c1.avg_salary THEN c2.max_salary ELSE NULL END) AS max_salary
FROM employees e
JOIN cte_m_highest_salary c2 ON c2.emp_no = e.emp_no
JOIN cte_avg_salary c1;


-- MySQL Temporary Tables

# Store the highest contract salary values of all male employees in a temporary table called male_max_salaries.

CREATE TEMPORARY TABLE male_max_salaries
SELECT
    s.emp_no, MAX(s.salary)
FROM
    salaries s
        JOIN
    employees e ON e.emp_no = s.emp_no AND e.gender = 'M'
GROUP BY s.emp_no;


# Write a query that, upon execution, allows you to check the result set contained in the male_max_salaries temporary table you created in the previous exercise.

SELECT 
    *
FROM
    male_max_salaries;
    
    
# Create a temporary table called dates containing the following three columns:
# one displaying the current date and time, another one displaying two months earlier than the current date and time, and a third column displaying two years later than the current date and time.
# Write a query that, upon execution, allows you to check the result set contained in the dates temporary table you created in the previous exercise.

CREATE TEMPORARY TABLE dates
SELECT
    NOW(),
    DATE_SUB(NOW(), INTERVAL 2 MONTH) AS two_months_earlier,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS two_years_later;

SELECT 
    *
FROM
    dates dates;


# Create a query joining the result sets from the dates temporary table you created during the previous lecture with a new Common Table Expression (CTE) containing the same columns. Let all columns in the result set appear on the same row.

WITH cte AS (SELECT
    NOW(),
    DATE_SUB(NOW(), INTERVAL 2 MONTH) AS cte_a_month_earlier,
    DATE_SUB(NOW(), INTERVAL -2 YEAR) AS cte_a_year_later)
SELECT * FROM dates d1 JOIN cte c;


# Create a query joining the result sets from the dates temporary table you created during the previous lecture with a new Common Table Expression (CTE) containing the same columns. This time, combine the two sets vertically.

WITH cte AS (SELECT
    NOW(),
    DATE_SUB(NOW(), INTERVAL 1 MONTH) AS cte_a_month_earlier,
    DATE_SUB(NOW(), INTERVAL -1 YEAR) AS cte_a_year_later)
SELECT * FROM dates UNION SELECT * FROM cte;


DROP TABLE IF EXISTS male_max_salaries;
DROP TABLE IF EXISTS dates;
