-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

-- Insert sample data into departments table
INSERT INTO departments (department_id, department_name, location)
VALUES
(1, 'Engineering', 'New Delhi'),
(2, 'Sales', 'Mumbai'),
(3, 'Finance', 'Kolkata');

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL,
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Insert sample data into employees table
INSERT INTO employees (emp_id, first_name, last_name, salary, department_id)
VALUES
(1, 'Rahul', 'Kumar', 60000, 1),
(2, 'Neha', 'Sharma', 55000, 2),
(3, 'Krishna', 'Singh', 62000, 1),
(4, 'Pooja', 'Verma', 58000, 3),
(5, 'Rohan', 'Gupta', 59000, 2);

-- Create projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget DECIMAL,
    start_date DATE,
    end_date DATE
);

-- Insert sample data into projects table
INSERT INTO projects (project_id, project_name, budget, start_date, end_date)
VALUES
(101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
(102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
(103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');

-- 1. Display the first name and last name of all employees
SELECT first_name, last_name FROM employees;

-- 2. List all departments along with their locations
SELECT department_name, location FROM departments;

-- 3. Display the project names along with their budgets
SELECT project_name, budget FROM projects;

-- 4. Show the first name, last name, and salary of all employees in the 'Engineering' department
SELECT e.first_name, e.last_name, e.salary 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE d.department_name = 'Engineering';

-- 5. List the project names and their corresponding start dates
SELECT project_name, start_date FROM projects;

-- 6. Display the first name, last name, and department name of all employees
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id;

-- 7. Show the project names with budgets greater than ?90000
SELECT project_name FROM projects WHERE budget > 90000;

-- 8. Calculate the total budget allocated to projects
SELECT SUM(budget) AS total_budget FROM projects;

-- 9. Display the first name, last name, and salary of employees earning more than ?60000
SELECT first_name, last_name, salary FROM employees WHERE salary > 60000;

-- 10. List the project names and their corresponding end dates
SELECT project_name, end_date FROM projects;

-- 11. Show the department names with locations in 'North India' (Delhi or nearby regions)
SELECT department_name, location 
FROM departments 
WHERE location IN ('New Delhi', 'NearbyRegion2', 'NearbyRegion3');

-- 12. Calculate the average salary of all employees
SELECT AVG(salary) AS average_salary FROM employees;

-- 13. Display the first name, last name, and department name of employees in the 'Finance' department
SELECT e.first_name, e.last_name, d.department_name 
FROM employees e 
JOIN departments d ON e.department_id = d.department_id 
WHERE d.department_name = 'Finance';

-- 14. List the project names with budgets between ?70000 and ?100000
SELECT project_name 
FROM projects 
WHERE budget BETWEEN 70000 AND 100000;

-- 15. Show the department names along with the count of employees in each department
SELECT d.department_name, COUNT(e.emp_id) AS employee_count 
FROM departments d 
LEFT JOIN employees e ON d.department_id = e.department_id 
GROUP BY d.department_name;

