
CREATE DATABASE sicKode_tutors;    # Creating the database
USE sicKode_tutors;                # Use this database

# Create Normalised tables in the database
# Table for students details where student ID is the primary key
CREATE TABLE students (
    student_id VARCHAR(6) NOT NULL,   
    first_name CHAR(20) NOT NULL,
    last_name CHAR(20) NOT NULL,
    age INT,
    background VARCHAR(20),
    email VARCHAR(50) NOT NULL,
    CONSTRAINT pk_students PRIMARY KEY (student_id)
);

# Table holding instrucor details where primary key is instructor id
CREATE TABLE instructors (
    instructor_id VARCHAR(6) NOT NULL,
    first_name CHAR(20) NOT NULL,
    last_name CHAR(20) NOT NULL,
    proficiency_1 VARCHAR(20) NOT NULL,
    proficiency_2 VARCHAR(20),
    email VARCHAR(50),
    CONSTRAINT pk_instructors PRIMARY KEY (instructor_id)
);

# Table for the programming courses where course id is the primary key
CREATE TABLE courses (
    course_id VARCHAR(6) NOT NULL,
    instructor_id VARCHAR(6) NOT NULL,
    course_name VARCHAR(20) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    weeks INT,
    assessment VARCHAR(20),
    CONSTRAINT pk_courses PRIMARY KEY (course_id),
    CONSTRAINT instructor_id FOREIGN KEY (instructor_id)
        REFERENCES instructors (instructor_id)
);

# Table holding all the topics in the courses where primary key is topic id
CREATE TABLE topics (
	topic_id VARCHAR(6) NOT NULL,
    topic_name VARCHAR(30) NOT NULL,
    difficulty CHAR(20),
    CONSTRAINT pk_topics PRIMARY KEY (topic_id)
);

# Table of % grades for each student per course per topic
CREATE TABLE grades (
    student_id VARCHAR(6) NOT NULL,
    course_id VARCHAR(6) NOT NULL,
    topic_id VARCHAR(6) NOT NULL,
    percentage_grade FLOAT(1) NOT NULL,
    CONSTRAINT student_id FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT course_id FOREIGN KEY (course_id)
        REFERENCES courses (course_id),
    CONSTRAINT topic_id FOREIGN KEY (topic_id)
        REFERENCES topics (topic_id)
);

# Add data into the tables
# Adding student data into students table
INSERT INTO students
(student_id, first_name, last_name, age, background, email)
VALUES
('S1', 'Charlie', 'Smith', 20, 'Mathematics', 'csmith@hotmail.co.uk'),
('S2', 'Sheila', 'Patel', 21, 'Social Science', 'spatel@hotmail.co.uk'),
('S3', 'Josh', 'Taylor', 19, 'Engineering', 'jtaylor@hotmail.co.uk'),
('S4', 'Alisha', 'Khan', 22, 'Social Science', 'akhan@hotmail.co.uk'); 

# Adding instructor data into instructors table
INSERT INTO instructors
(instructor_id, first_name, last_name, proficiency_1, proficiency_2, email)
VALUES
('I1', 'Gemma', 'Clarke', 'Python', 'R', 'gclarke@hotmail.co.uk'),
('I2', 'Toby', 'Williams', 'Python', NULL, 'twilliams@hotmail.co.uk'),
('I3', 'Eliza', 'Snow', 'SQL', 'R', 'esnow@hotmail.co.uk'),
('I4', 'Hassan', 'Karim', 'HTML/CSS', NULL, 'hkarim@hotmail.co.uk'); 


# Adding course data into courses table
INSERT INTO courses
(course_id, instructor_id, course_name, start_date, end_date, weeks, assessment)
VALUES
('C1', 'I2', 'Python', '2021-04-05', '2021-05-05', 5, 'Coding Essay'),
('C2', 'I4', 'HTML/CSS', '2021-04-12', '2021-04-30', 3, 'Website'),
('C3', 'I3', 'SQL', '2021-04-26', '2021-05-21', 4, 'Database'),
('C4', 'I1', 'R', '2021-07-01', '2021-07-22', 4, 'Coding Essay');

# Adding course topics into topics table
INSERT INTO topics
(topic_id, topic_name, difficulty)
VALUES
('T1', 'Data Types', 'Beginner'),
('T2', 'Data Analysis', 'Advanced'),
('T3', 'Element Tags', 'Beginner'),
('T4', 'Nested Queries', 'Intermediate');

# Adding % grades per course per topic into grades table 
INSERT INTO grades
(student_id, course_id, topic_id, percentage_grade)
VALUES
('S1', 'C1', 'T1', 50.4),   # Student 1, python, data types topic
('S1', 'C1', 'T2', 67.3),   # Student 1, python, data analysis topic
('S1', 'C4', 'T1', 77.2),   # Student 1, R, data types topic
('S1', 'C4', 'T2', 20.8),   # Student 1, R, data analysis topic
('S2', 'C2', 'T3', 80.6),   # Student 2, HTML/CSS, element tags topic
('S2', 'C4', 'T1', 77.5),   # Student 2, R, data types topic
('S2', 'C4', 'T2', 55.2),   # Student 2, R, data analysis topic
('S3', 'C4', 'T1', 66.3),   # Student 3, R, data types topic
('S3', 'C4', 'T2', 62.5),   #Student 3, R, data analysis topic
('S4', 'C3', 'T4', 88.1);   # Student 4, SQL, nested queires topic

# JOINS
# What is the full name and email of the Python course instructor?
SELECT DISTINCT
    c.course_name, i.first_name, i.last_name, i.email
FROM
    instructors i
        INNER JOIN
    courses c USING (instructor_id)
WHERE
    c.course_name = 'Python';

# What courses include the Data Analysis topic? 
SELECT DISTINCT
    c.course_name, t.topic_name
FROM
    grades g
        INNER JOIN
    topics t USING (topic_id)
        INNER JOIN
    courses c USING (course_id)
WHERE
    t.topic_name = 'Data Analysis';

# SUBQUERY - Which students are taking the R course that have a background in social science?   
SELECT DISTINCT
    s.first_name, s.last_name, s.background, c.course_name
FROM
    grades g
        INNER JOIN
    students s USING (student_id)
        INNER JOIN
    courses c USING (course_id)
WHERE
    s.background = 'Social Science'
        AND c.course_id IN (SELECT 
            c.course_id
        FROM
            courses c
        WHERE
            c.course_name = 'R');


# Using GROUP BY and HAVING
# What are the names of the students who are enrolled on more than one coding course & how many are they enrolled on?
SELECT 
    s.first_name,
    s.last_name,
    COUNT(DISTINCT g.course_id) AS no_of_courses
FROM
    grades g
        INNER JOIN
    students s USING (student_id)
        INNER JOIN
    courses c USING (course_id)
GROUP BY s.student_id
HAVING COUNT(DISTINCT g.course_id) > 1;
      
      
# STORED PROCEDURE - used to add a new student to students table & info into grades table
DESCRIBE students; 

DELIMITER //   
CREATE PROCEDURE InsertStudent(IN sid_in VARCHAR(6),
								fname_in CHAR(20),
                                IN lname_in CHAR(20),
                                IN age_in INT,
                                IN bgd_in VARCHAR(20),
                                IN email_in VARCHAR(50),
                                IN cid_in VARCHAR(6),
                                IN tid_in VARCHAR(6),
                                IN perc_grade_in FLOAT)
BEGIN
	INSERT INTO students (student_id, first_name, last_name, age, background, email)
    VALUES (sid_in, fname_in, lname_in, age_in, bgd_in, email_in);
    
    INSERT INTO grades (student_id, course_id, topic_id, percentage_grade)
    VALUES (sid_in, cid_in, tid_in, perc_grade_in);
END//  
DELIMITER ;    

# Add new student to SQL course where T4 Nested Queries grade is 64.7%
CALL InsertStudent('S5', 'James', 'Clarke', 20, 'Physics', 'jclarke@hotmail.co.uk', 'C3', 'T4', 64.7);  


# STORED FUNCTION - Function classifies the % grade for each topic test as either Fail/pass/merit/distinction
DELIMITER //
CREATE FUNCTION grade_class(percentage_grade FLOAT)  # Checking % grade
RETURNS VARCHAR(15)  # Will return Fail/pass/merit/distinction
DETERMINISTIC 

BEGIN    # create new (temporary) classification variable
	DECLARE class VARCHAR(15);   
    IF percentage_grade >= 70 THEN
    SET class = 'DISTINCTION';
    
    ELSEIF percentage_grade >= 60 AND percentage_grade < 70 THEN
    SET class = 'MERIT';
    
    ELSEIF percentage_grade >= 50 AND percentage_grade < 60 THEN   
    SET class = 'PASS';    
    
    ELSEIF percentage_grade < 50 THEN
    SET class = 'FAIL';
 END IF;   #end the if series
 
 RETURN(class);   # get the returned value
 END//
DELIMITER ;

SELECT *, grade_class(percentage_grade) as class  #We can then use this function in the ususal select statements
FROM grades;  


# Create view using 4 base tables - students names, course name, topic name joined using grades table
# Display the grade class using the grade_class function previously created
CREATE VIEW vw_student_grade AS
    SELECT DISTINCT
		s.student_id,
        s.first_name,
        s.last_name,
        c.course_name,
        t.topic_name,
        GRADE_CLASS(percentage_grade) AS grade_class
    FROM
        grades g
            INNER JOIN
        students s USING (student_id)
            INNER JOIN
        courses c USING (course_id)
            INNER JOIN
        topics t USING (topic_id);

SELECT * FROM vw_student_grade;

# Qurey the view 
# Students must resit the entire course if they fail one topic within that course
# Find all students and course name where they failed a topic & hence must resit this course
SELECT 
    student_id, first_name, last_name, course_name
FROM
    vw_student_grade
WHERE
    grade_class = 'FAIL';





