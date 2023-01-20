
-- UNION and UNION ALL

DROP TABLE IF EXISTS employees_dup;
CREATE TABLE employees_dup (
  emp_no int,
  birth_date date,
  first_name varchar(14),
  last_name varchar(16),
  gender enum('M','F'),
  hire_date date
  );

INSERT INTO employees_dup
SELECT
	e.* 
FROM 
	employees e
LIMIT 20;

SELECT * FROM employees_dup;

INSERT INTO employees_dup VALUES ('10001', '1953-09-02', 'Georgi', 'Facello', 'M', '1986-06-26');

SELECT 
	e.emp_no,
	e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM 
	employees_dup e
WHERE
    e.emp_no = 10001
UNION ALL SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM 
	dept_manager m;
    
    
SELECT 
	e.emp_no,
	e.first_name,
    e.last_name,
    NULL AS dept_no,
    NULL AS from_date
FROM 
	employees_dup e
WHERE
    e.emp_no = 10001
UNION SELECT
	NULL AS emp_no,
    NULL AS first_name,
    NULL AS last_name,
    m.dept_no,
    m.from_date
FROM 
	dept_manager m;
    

# Union of employees named Denis and Manager department

SELECT 
    *
FROM
    (SELECT 
        e.emp_no,
            e.first_name,
            e.last_name,
            NULL AS dept_no,
            NULL AS from_date
    FROM
        employees e
    WHERE
        last_name = 'Denis' UNION SELECT 
        NULL AS emp_no,
            NULL AS first_name,
            NULL AS last_name,
            dm.dept_no,
            dm.from_date
    FROM
        dept_manager dm) AS a
ORDER BY  -a.emp_no DESC;



-- SUBQUERIES

-- Subqueries with IN nested inside WHERE

SELECT 
    *
FROM
    dept_manager;
    
SELECT 
	e.first_name, e.last_name
FROM
	employees e
WHERE 
	e.emp_no IN (SELECT 
				dm.emp_no
			FROM
				dept_manager dm);
                
                
# Extract the information about all department managers who were hired between the 1st of January 1990 and the 1st of January 1995.

SELECT 
    e.emp_no, e.first_name, e.last_name
FROM
    employees e
WHERE
    e.emp_no IN (SELECT 
            dm.emp_no
        FROM
            dept_manager dm
        WHERE
            e.hire_date BETWEEN '1990-01-01' AND '1995-01-01');
            

-- Subqueries with EXISTS-NOT EXISTS nested inside WHERE

SELECT 
    e.first_name, e.last_name
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            dept_manager dm
        WHERE
            dm.emp_no = e.emp_no)
ORDER BY emp_no;
            
		
# Select the entire information for all employees whose job title is “Assistant Engineer”. 

SELECT 
    *
FROM
    employees e
WHERE
    EXISTS( SELECT 
            *
        FROM
            titles t
        WHERE
            t.emp_no = e.emp_no
                AND t.title = 'Assistant Engineer')
ORDER BY emp_no;


-- Subqueries nested in SELECT and FROM

# Assign employee number 110022 to all employees from 10001 to 10022, and employee number 110039 as a manager to all employees from 10021 to 10040.

SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
UNION SELECT 
		 B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no BETWEEN 10021 AND 10040
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS B;
    
# Fill emp_manager with data about employees, the number of the department they are working in, and their managers.

DROP TABLE IF EXISTS emp_manager;

CREATE TABLE emp_manager (
    emp_no INT(11) NOT NULL,
    dept_no CHAR(4) NULL,
    manager_no INT(11) NOT NULL
);

SELECT 
    A.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no <= 10020
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS A
UNION SELECT 
		 B.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no BETWEEN 10021 AND 10040
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS B
UNION SELECT
		C.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110039) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 100022
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS C
    UNION SELECT
		D.*
FROM
    (SELECT 
        e.emp_no AS employee_ID,
            MIN(de.dept_no) AS department_code,
            (SELECT 
                    emp_no
                FROM
                    dept_manager
                WHERE
                    emp_no = 110022) AS manager_ID
    FROM
        employees e
    JOIN dept_emp de ON e.emp_no = de.emp_no
    WHERE
        e.emp_no = 100039
    GROUP BY e.emp_no
    ORDER BY e.emp_no) AS D;


--  SELF JOIN

# From the emp_manager table, extract the record data only of those employees who are managers as well.

SELECT DISTINCT
	e1.*
FROM 
	emp_manager e1
JOIN
	emp_manager e2 ON e1.emp_no = e2.manager_no;

SELECT 
	e1.*
FROM 
	emp_manager e1
JOIN
	emp_manager e2 ON e1.emp_no = e2.manager_no
WHERE 
	e2.emp_no IN (SELECT 
				manager_no
			FROM 
				emp_manager);
		

        