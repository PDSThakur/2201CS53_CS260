-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(100),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Create projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(100),
    budget DECIMAL(15, 2),
    start_date DATE,
    end_date DATE
);

-- Insert values into employees table
INSERT INTO employees (emp_id, first_name, last_name, salary, department_id)
VALUES
(1, 'Rahul', 'Kumar', 60000, 1),
(2, 'Neha', 'Sharma', 55000, 2),
(3, 'Krishna', 'Singh', 62000, 1),
(4, 'Pooja', 'Verma', 58000, 3),
(5, 'Rohan', 'Gupta', 59000, 2);

-- Insert values into departments table
INSERT INTO departments (department_id, department_name, location, manager_id)
VALUES 
(1, 'Engineering', 'New Delhi', 3),
(2, 'Sales', 'Mumbai', 5),
(3, 'Finance', 'Kolkata', 4);

-- Insert values into projects table
INSERT INTO projects (project_id, project_name, budget, start_date, end_date)
VALUES
(101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
(102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
(103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');



-- 2. Projection to display only the first names and salaries of all employees
SELECT first_name, salary 
FROM employees;

-- 4. Selection to retrieve employees earning a salary greater than ?60000
SELECT * 
FROM employees 
WHERE salary > 60000;

-- 6. Cartesian product between employees and projects
SELECT * 
FROM employees 
CROSS JOIN projects;

-- 8. Natural join between departments and projects
SELECT * 
FROM departments 
NATURAL JOIN projects;

-- 10. Selection to retrieve projects with budgets greater than ?100000
SELECT * 
FROM projects 
WHERE budget > 100000;

-- 12. Union operation between two sets of employees from the 'Engineering' and 'Finance' departments
SELECT * FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Engineering')
UNION
SELECT * FROM employees WHERE department_id = (SELECT department_id FROM departments WHERE department_name = 'Finance');

-- 14. Join operation to display employees along with their project assignments
SELECT * 
FROM employees 
LEFT JOIN projects ON employees.emp_id = projects.emp_id;
