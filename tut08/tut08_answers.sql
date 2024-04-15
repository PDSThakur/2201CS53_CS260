-- Create departments table
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50),
    manager_id INT
);

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    salary DECIMAL(10, 2),
    department_id INT,
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create projects table
CREATE TABLE projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    budget DECIMAL(10, 2),
    start_date DATE,
    end_date DATE
);

-- Create works_on table
CREATE TABLE works_on (
    emp_id INT,
    project_id INT,
    hours_worked INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (project_id) REFERENCES projects(project_id)
);

-- Create salary_audit table for logging salary updates
CREATE TABLE salary_audit (
    audit_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    old_salary DECIMAL(10, 2),
    new_salary DECIMAL(10, 2),
    updated_at TIMESTAMP
);


-- Trigger 1: Increase salary by 10% for employees below $60,000
DELIMITER $$
CREATE TRIGGER increase_salary_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary < 60000 THEN
        SET NEW.salary = NEW.salary * 1.1;
    END IF;
END$$
DELIMITER ;

-- Trigger 2: Prevent deleting records from departments table if employees are assigned to that department
DELIMITER $$
CREATE TRIGGER prevent_delete_department_trigger
BEFORE DELETE ON departments
FOR EACH ROW
BEGIN
    DECLARE count_emp INT;
    SELECT COUNT(*) INTO count_emp FROM employees WHERE department_id = OLD.department_id;
    IF count_emp > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot delete department with assigned employees';
    END IF;
END$$
DELIMITER ;

-- Trigger 3: Log salary updates into an audit table
DELIMITER $$
CREATE TRIGGER log_salary_update_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit (emp_id, old_salary, new_salary, updated_at)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary, NOW());
END$$
DELIMITER ;

-- Trigger 4: Automatically assign a department based on salary range
DELIMITER $$
CREATE TRIGGER assign_department_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    IF NEW.salary <= 60000 THEN
        SET NEW.department_id = 3; -- Assuming department_id 3 is for low salary employees
    END IF;
END$$
DELIMITER ;

-- Trigger 5: Update the salary of the manager in each department when a new employee is hired
DELIMITER $$
CREATE TRIGGER update_manager_salary_trigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE highest_salary DECIMAL(10, 2);
    SELECT MAX(salary) INTO highest_salary FROM employees WHERE department_id = NEW.department_id;
    UPDATE employees SET salary = NEW.salary WHERE emp_id = NEW.manager_id;
END$$
DELIMITER ;

-- Trigger 6: Prevent updating the department_id of an employee if they have worked on projects
DELIMITER $$
CREATE TRIGGER prevent_update_department_trigger
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE count_projects INT;
    SELECT COUNT(*) INTO count_projects FROM works_on WHERE emp_id = NEW.emp_id;
    IF count_projects > 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Cannot update department_id for employees with assigned projects';
    END IF;
END$$
DELIMITER ;

-- Trigger 7: Calculate and update the average salary for each department whenever a salary change occurs
DELIMITER $$
CREATE TRIGGER update_avg_salary_trigger
AFTER INSERT, UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE avg_salary DECIMAL(10, 2);
    SELECT AVG(salary) INTO avg_salary FROM employees WHERE department_id = NEW.department_id;
    UPDATE departments SET avg_salary = avg_salary WHERE department_id = NEW.department_id;
END$$
DELIMITER ;

-- Trigger 8: Automatically delete all records from the works_on table for an employee when that employee is deleted from the employees table
DELIMITER $$
CREATE TRIGGER delete_employee_works_on_trigger
AFTER DELETE ON employees
FOR EACH ROW
BEGIN
    DELETE FROM works_on WHERE emp_id = OLD.emp_id;
END$$
DELIMITER ;

-- Trigger 9: Prevent inserting a new employee if their salary is less than the minimum salary set for their department
DELIMITER $$
CREATE TRIGGER prevent_insert_employee_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    DECLARE min_salary DECIMAL(10, 2);
    SELECT MIN(salary) INTO min_salary FROM employees WHERE department_id = NEW.department_id;
    IF NEW.salary < min_salary THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Salary cannot be less than minimum salary for the department';
    END IF;
END$$
DELIMITER ;

-- Trigger 10: Automatically update the total salary budget for a department whenever an employee's salary is updated
DELIMITER $$
CREATE TRIGGER update_total_budget_trigger
AFTER UPDATE ON employees
FOR EACH ROW
BEGIN
    DECLARE total_budget DECIMAL(10, 2);
    SELECT SUM(salary) INTO total_budget FROM employees WHERE department_id = NEW.department_id;
    UPDATE departments SET total_budget = total_budget WHERE department_id = NEW.department_id;
END$$
DELIMITER ;

-- Trigger 11: Send an email notification to HR whenever a new employee is hired
-- (Assuming a procedure or function exists for sending emails)
DELIMITER $$
CREATE TRIGGER send_email_notification_trigger
AFTER INSERT ON employees
FOR EACH ROW
BEGIN
    CALL send_email_to_hr('New employee hired: ' || NEW.first_name || ' ' || NEW.last_name);
END$$
DELIMITER ;

-- Trigger 12: Prevent inserting a new department if the location is not specified
DELIMITER $$
CREATE TRIGGER prevent_insert_department_trigger
BEFORE INSERT ON departments
FOR EACH ROW
BEGIN
    IF NEW.location IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Location must be specified for a new department';
    END IF;
END$$
DELIMITER ;

-- Trigger 13: Update the department_name in the employees table when the corresponding department_name is updated in the departments table
DELIMITER $$
CREATE TRIGGER update_department_name_trigger
AFTER UPDATE ON departments
FOR EACH ROW
BEGIN
    UPDATE employees SET department_name = NEW.department_name WHERE department_id = NEW.department_id;
END$$
DELIMITER ;

-- Trigger 14: Log all insert, update, and delete operations on the employees table into a separate audit table
DELIMITER $$
CREATE TRIGGER log_employee_operations_trigger
AFTER INSERT, UPDATE, DELETE ON employees
FOR EACH ROW
BEGIN
    DECLARE operation VARCHAR(10);
    IF INSERTING THEN
        SET operation = 'INSERT';
    ELSEIF UPDATING THEN
        SET operation = 'UPDATE';
    ELSE
        SET operation = 'DELETE';
    END IF;
    
    INSERT INTO employee_operations_log (operation_type, emp_id, operation_time)
    VALUES (operation, COALESCE(NEW.emp_id, OLD.emp_id), NOW());
END$$
DELIMITER ;

-- Trigger 15: Automatically generate an employee ID using a sequence whenever a new employee is inserted
-- (Assuming a sequence named employee_id_seq exists)
DELIMITER $$
CREATE TRIGGER generate_employee_id_trigger
BEFORE INSERT ON employees
FOR EACH ROW
BEGIN
    SET NEW.emp_id = NEXTVAL('employee_id_seq');
END$$
DELIMITER ;
