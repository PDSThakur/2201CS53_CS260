-- Create tables
CREATE TABLE students (
    student_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    age INT,
    city VARCHAR(100)
);
CREATE TABLE instructors (
    instructor_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50)
);
CREATE TABLE courses (
    course_id INT PRIMARY KEY,
    course_name VARCHAR(100),
    instructor_id INT,
    FOREIGN KEY (instructor_id) REFERENCES instructors(instructor_id)
);

CREATE TABLE enrollments (
    enrollment_id INT PRIMARY KEY,
    student_id INT,
    course_id INT,
    grade VARCHAR(2),
    FOREIGN KEY (student_id) REFERENCES students(student_id),
    FOREIGN KEY (course_id) REFERENCES courses(course_id)
);

-- Insert data into tables
INSERT INTO students (student_id, first_name, last_name, age, city)
VALUES
(1, 'Rahul', 'Kumar', 20, 'Delhi'),
(2, 'Neha', 'Sharma', 22, 'Mumbai'),
(3, 'Krishna', 'Singh', 21, 'Bangalore'),
(4, 'Pooja', 'Verma', 23, 'Kolkata'),
(5, 'Rohan', 'Gupta', 22, 'Hyderabad');

INSERT INTO instructors (instructor_id, first_name, last_name)
VALUES
(1, 'Dr. Akhil', 'Singh'),
(2, 'Dr. Neha', 'Agarwal'),
(3, 'Dr. Nitin', 'Warrier');

INSERT INTO courses (course_id, course_name, instructor_id)
VALUES
(101, 'Mathematics', 1),
(102, 'Physics', 2),
(103, 'History', 3),
(104, 'Chemistry', 1),
(105, 'Computer Science', 2);


INSERT INTO enrollments (enrollment_id, student_id, course_id, grade)
VALUES
(1, 1, 101, 'A'),
(2, 2, 102, 'B+'),
(3, 3, 104, 'A-'),
(4, 4, 103, 'B'),
(5, 5, 105, 'A');

-- 1. Display the first name and last name of all students along with their enrolled courses
SELECT s.first_name, s.last_name, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 2. List the course names along with the grades of students who have enrolled in them
SELECT c.course_name, e.grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id;

-- 3. Display the first name, last name, and course name of all students along with their instructors
SELECT s.first_name, s.last_name, c.course_name, i.first_name AS instructor_first_name, i.last_name AS instructor_last_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id;

-- 4. Show the first name, last name, age, and city of all students who are enrolled in the 'Mathematics' course
SELECT s.first_name, s.last_name, s.age, s.city
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE c.course_name = 'Mathematics';

-- 5. List the course names along with the names of instructors teaching those courses
SELECT c.course_name, i.first_name AS instructor_first_name, i.last_name AS instructor_last_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id;

-- 6. Display the first name, last name, and grade of all students along with their enrolled courses
SELECT s.first_name, s.last_name, e.grade, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id;

-- 7. Show the first name, last name, and age of all students who are enrolled in more than one course
SELECT s.first_name, s.last_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id
HAVING COUNT(e.enrollment_id) > 1;

-- 8. Write a query to display the course names and the number of students enrolled in each course
SELECT c.course_name, COUNT(e.student_id) AS num_students
FROM courses c
LEFT JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- 9. Display the first name, last name, and age of students who have not enrolled in any courses
SELECT s.first_name, s.last_name, s.age
FROM students s
LEFT JOIN enrollments e ON s.student_id = e.student_id
WHERE e.enrollment_id IS NULL;

-- 10. List the course names along with the average grades obtained by students in each course
SELECT c.course_name, AVG(grade) AS avg_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- 11. Show the first name, last name, and course name of all students who have received grades above 'B'
SELECT s.first_name, s.last_name, c.course_name, e.grade
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.grade > 'B';

-- 12. Write a query to display the course names and the names of instructors with a last name starting with 'S'
SELECT c.course_name, i.first_name AS instructor_first_name, i.last_name AS instructor_last_name
FROM courses c
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.last_name LIKE 'S%';

-- 13. Display the first name, last name, and age of students who are enrolled in courses taught by 'Dr. Akhil'
SELECT s.first_name, s.last_name, s.age
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
JOIN instructors i ON c.instructor_id = i.instructor_id
WHERE i.first_name = 'Dr. Akhil';

-- 14. Show the course names and the maximum grade obtained in each course
SELECT c.course_name, MAX(e.grade) AS max_grade
FROM courses c
JOIN enrollments e ON c.course_id = e.course_id
GROUP BY c.course_id;

-- 15. Write a query to display the first name, last name, and age of students along with the course names they have enrolled in, sorted by course name in ascending order
SELECT s.first_name, s.last_name, s.age, c.course_name
FROM students s
JOIN enrollments e ON s.student_id = e.student_id
JOIN courses c ON e.course_id = c.course_id
ORDER BY c.course_name ASC;
