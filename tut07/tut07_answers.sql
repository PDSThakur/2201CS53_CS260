
-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(255),
    last_name VARCHAR(255),
    salary DECIMAL,
    department_id INT
);

-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255),
    location VARCHAR(255),
    manager_id INT,
    FOREIGN KEY (manager_id) REFERENCES employees(emp_id)
);

-- Create projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    budget DECIMAL,
    start_date DATE,
    end_date DATE
);

-- Insert data into employees table
-- Insert data into employees table
INSERT INTO employees (emp_id, first_name, last_name, salary, department_id)
VALUES (1, 'Rahul', 'Kumar', 60000, 1),
       (2, 'Neha', 'Sharma', 55000, 2),
       (3, 'Krishna', 'Singh', 62000, 1),
       (4, 'Pooja', 'Verma', 58000, 3),
       (5, 'Rohan', 'Gupta', 59000, 2);


-- Insert data into departments table
INSERT INTO departments (department_id, department_name, location, manager_id)
VALUES (1, 'Engineering', 'New Delhi', 3),
       (2, 'Sales', 'Mumbai', 5),
       (3, 'Finance', 'Kolkata', 4);

-- Insert data into projects table
INSERT INTO projects (project_id, project_name, budget, start_date, end_date)
VALUES (101, 'ProjectA', 100000, '2023-01-01', '2023-06-30'),
       (102, 'ProjectB', 80000, '2023-02-15', '2023-08-15'),
       (103, 'ProjectC', 120000, '2023-03-20', '2023-09-30');

-- Define procedures...


-- Procedure to calculate the average salary of employees in a given department
DELIMITER //
CREATE PROCEDURE CalculateAverageSalaryInDepartment(IN department_name VARCHAR(255), OUT avg_salary DECIMAL)
BEGIN
    SELECT AVG(salary) INTO avg_salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = department_name;
END //
DELIMITER ;

-- Procedure to update the salary of an employee by a specified percentage
DELIMITER //
CREATE PROCEDURE UpdateEmployeeSalaryByPercentage(IN emp_id INT, IN percentage DECIMAL)
BEGIN
    UPDATE employees
    SET salary = salary * (1 + percentage/100)
    WHERE emp_id = emp_id;
END //
DELIMITER ;

-- Procedure to list all employees in a given department
DELIMITER //
CREATE PROCEDURE ListEmployeesInDepartment(IN department_name VARCHAR(255))
BEGIN
    SELECT *
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = department_name;
END //
DELIMITER ;

-- Procedure to calculate the total budget allocated to a specific project
DELIMITER //
CREATE PROCEDURE CalculateTotalBudgetForProject(IN project_name VARCHAR(255), OUT total_budget DECIMAL)
BEGIN
    SELECT budget INTO total_budget
    FROM projects
    WHERE project_name = project_name;
END //
DELIMITER ;

-- Procedure to find the employee with the highest salary in a given department
DELIMITER //
CREATE PROCEDURE FindEmployeeWithHighestSalaryInDepartment(IN department_name VARCHAR(255), OUT emp_id INT, OUT first_name VARCHAR(255), OUT last_name VARCHAR(255), OUT salary DECIMAL)
BEGIN
    SELECT emp_id, first_name, last_name, salary
    INTO emp_id, first_name, last_name, salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = department_name
    ORDER BY salary DESC
    LIMIT 1;
END //
DELIMITER ;

-- Procedure to list all projects that are due to end within a specified number of days
DELIMITER //
CREATE PROCEDURE ListProjectsEndingWithinDays(IN num_days INT)
BEGIN
    SELECT *
    FROM projects
    WHERE end_date <= DATE_ADD(CURRENT_DATE(), INTERVAL num_days DAY);
END //
DELIMITER ;

-- Procedure to calculate the total salary expenditure for a given department
DELIMITER //
CREATE PROCEDURE CalculateTotalSalaryExpenditureForDepartment(IN department_name VARCHAR(255), OUT total_salary DECIMAL)
BEGIN
    SELECT SUM(salary) INTO total_salary
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    WHERE d.department_name = department_name;
END //
DELIMITER ;

-- Procedure to generate a report listing all employees along with their department and salary details
DELIMITER //
CREATE PROCEDURE GenerateEmployeeReport()
BEGIN
    SELECT e.emp_id, e.first_name, e.last_name, e.salary, d.department_name
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id;
END //
DELIMITER ;

-- Procedure to find the project with the highest budget
DELIMITER //
CREATE PROCEDURE FindProjectWithHighestBudget(OUT project_id INT, OUT project_name VARCHAR(255), OUT budget DECIMAL)
BEGIN
    SELECT project_id, project_name, budget
    INTO project_id, project_name, budget
    FROM projects
    ORDER BY budget DESC
    LIMIT 1;
END //
DELIMITER ;

-- Procedure to calculate the average salary of employees across all departments
DELIMITER //
CREATE PROCEDURE CalculateAverageSalaryAcrossDepartments(OUT avg_salary DECIMAL)
BEGIN
    SELECT AVG(salary) INTO avg_salary
    FROM employees;
END //
DELIMITER ;

-- Procedure to assign a new manager to a department and update the manager_id in the departments table
DELIMITER //
CREATE PROCEDURE AssignNewManagerToDepartment(IN department_id INT, IN new_manager_id INT)
BEGIN
    UPDATE departments
    SET manager_id = new_manager_id
    WHERE department_id = department_id;
END //
DELIMITER ;

-- Procedure to calculate the remaining budget for a specific project
DELIMITER //
CREATE PROCEDURE CalculateRemainingBudgetForProject(IN project_name VARCHAR(255), OUT remaining_budget DECIMAL)
BEGIN
    SELECT budget - SUM(amount_spent) INTO remaining_budget
    FROM projects p
    LEFT JOIN expenses e ON p.project_id = e.project_id
    WHERE p.project_name = project_name
    GROUP BY p.project_id;
END //
DELIMITER ;

-- Procedure to generate a report of employees who joined the company in a specific year
DELIMITER //
CREATE PROCEDURE GenerateEmployeeJoiningReport(IN join_year INT)
BEGIN
    SELECT *
    FROM employees
    WHERE YEAR(join_date) = join_year;
END //
DELIMITER ;

-- Procedure to update the end date of a project based on its start date and duration
DELIMITER //
CREATE PROCEDURE UpdateProjectEndDateBasedOnDuration(IN project_name VARCHAR(255), IN duration INT)
BEGIN
    UPDATE projects
    SET end_date = DATE_ADD(start_date, INTERVAL duration DAY)
    WHERE project_name = project_name;
END //
DELIMITER ;

-- Procedure to calculate the total number of employees in each department
DELIMITER //
CREATE PROCEDURE CalculateTotalEmployeesInEachDepartment()
BEGIN
    SELECT d.department_name, COUNT(e.emp_id) AS total_employees
    FROM employees e
    INNER JOIN departments d ON e.department_id = d.department_id
    GROUP BY d.department_name;
END //
DELIMITER ;
