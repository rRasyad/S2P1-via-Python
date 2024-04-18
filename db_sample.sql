-- Active: 1708887434952@@127.0.0.1@3306@db_s2_project_1

---------- Sample LOGIN, Get Password ----------

SELECT password FROM lecturers WHERE nid = '0885060416';



---------- Sample CLASS, Fetch Class ----------

SELECT * FROM classes WHERE nid = '0885060416';



---------- Sample MAIN MENU ----------
-- Check Today Attendance

SELECT timestamp
FROM lecturer_attendance
WHERE
    DATE(timestamp) = CURRENT_DATE
    AND class_id = '2ISA1'
    AND nid = '1453495138';

-- Insert Attendance if no record today

INSERT INTO
    lecturer_attendance (class_id, nid)
VALUES ('2ISA1', '1453495138');



---------- Sample LECTURER PROFILE ----------
-- Fetch All Detail

SELECT nid, full_name, gender, phone, email, adress
FROM lecturers 
WHERE nid = '1453495138';

-- Fetch all class
SELECT *
FROM classes
WHERE nid = '1453495138';

-- Overview Own Status

SELECT 
    COUNT(la_id) AS num
FROM lecturer_attendance
WHERE 
    nid = '1453495138' 
    AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y');



---------- Sample RESET PASSWORD ----------

UPDATE lecturers
SET password = 'aaa'
WHERE nid = '1453495138';



---------- Sample STUDENTS LIST ----------

SELECT nis, full_name
FROM students
WHERE class_id = '2ISA1'
ORDER BY full_name;



---------- Sample STUDENT DETAIL ----------
-- same as profile student



---------- Sample STUDENT ATTENDANCE PAGE 2 ----------
-- List Students with status

SELECT 
    COALESCE(sa.sa_id, null) as id,
    s.nis as nis,
    s.full_name as name,
    COALESCE(sa.status, null) AS status,
    sa.timestamp as timestamp
FROM students s
LEFT JOIN student_attendance sa 
ON 
    s.nis = sa.nis 
    AND DATE(sa.timestamp) = DATE(ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY))
WHERE s.class_id = '2CS1'
ORDER BY s.full_name;

-- Today Overview

SELECT 
    sa.status,
    COUNT(sa.nis) AS num_students
FROM student_attendance sa
LEFT JOIN students s
ON 
    s.nis = sa.nis 
    AND DATE(timestamp) = DATE(ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY))
WHERE s.class_id = '2CS1'
GROUP BY 
    status;



---------- Sample STUDENT ATTENDANCE PAGE 3 ----------

-- Sample 1 for Update status
IF EXISTS (SELECT * FROM student_attendance WHERE sa_id = 1)
BEGIN
    -- Update existing data
    UPDATE student_attendance
    SET status = 3
    WHERE sa_id = 1;
END
ELSE
BEGIN
    -- Insert new data
    INSERT INTO student_attendance (nis, status)
    VALUES ('7144990249', 3);
END;

-- Sample 2 for update status
INSERT INTO student_attendance (nis, status)
VALUES ('7144990249', 3)
ON DUPLICATE KEY UPDATE status = 2 WHERE sa_id = 1;

INSERT INTO student_attendance(nis, status) 
VALUES
('5953018039', 1),
('1552384338', 1),
('9794705145', 1),
('3064357718', 1);

-- Test Attendance
-- INSERT INTO student_attendance(nis, status, timestamp) 
-- VALUES
-- ('6890274285', 3, DATETIME(CURRENT_TIMESTAMP, '3 days'));



---------- Sample PROFILE STUDENT ----------
-- Check Today Attendance

SELECT status, timestamp
FROM student_attendance
WHERE
    DATE(timestamp) = DATE(CURRENT_DATE, '-2 days')
    AND nis = '6890274285';

-- fetch all detail

SELECT *
FROM students
WHERE nis = '6890274285';

-- Overview Status by Student

SELECT 
    sa.status,
    COUNT(sa.nis) AS num
FROM student_attendance sa
LEFT JOIN students s
ON 
    s.nis = sa.nis
    AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y')
WHERE s.nis = '6890274285'
GROUP BY 
    status
ORDER BY status;

-- Sample 2
SELECT 
    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS absent_count,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS attend_count,
    SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS sick_count,
    SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS permit_count
FROM student_attendance
WHERE nis = '6890274285'
AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y');

-- Sample 3
SELECT 
        SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS attend_count,
        SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS sick_count,
        SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS permit_count,
        (SELECT COUNT(DISTINCT timestamp) FROM student_attendance sa2 
            WHERE sa1.nis = sa2.nis 
            AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y')) - COUNT(*) AS absent_count
    FROM 
        student_attendance sa1
    WHERE 
        nis = '6890274285'
        AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y')

-- Sample 4 Kepake Overview Students
SELECT 
    CAST(SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS SIGNED) AS attend_count,
    CAST(SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS SIGNED) AS sick_count,
    CAST(SUM(CASE WHEN status = 3 THEN 1 ELSE 0 END) AS SIGNED) AS permit_count
FROM student_attendance
WHERE nis = '6890274285'
    AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y');

-- Sample 5
SELECT 
        sa.nis,
        SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS attend_count,
        SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS sick_count,
        SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS permit_count
    FROM 
        student_attendance sa
        LEFT JOIN students s
        ON s.nis = sa.nis
        AND DATE_FORMAT(timestamp, '%m-%Y') = DATE_FORMAT(CURRENT_TIMESTAMP, '%m-%Y')
    WHERE s.class_id = '2ISA1'
    GROUP BY 
        sa.nis;

-- Sample Overview Class
SELECT 
    SUM(CASE WHEN status = 0 THEN 1 ELSE 0 END) AS attend_count,
    SUM(CASE WHEN status = 1 THEN 1 ELSE 0 END) AS sick_count,
    SUM(CASE WHEN status = 2 THEN 1 ELSE 0 END) AS permit_count
FROM student_attendance sa
JOIN students s ON sa.nis = s.nis
WHERE s.class_id = '2CS1'
AND DATE(timestamp) = '2024-04-17';
-- AND DATE(timestamp) = DATE(ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY));

-- SELECT DATE(ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY))
-- Check if it right
-- SELECT * FROM student_attendance WHERE nis = '6890274285'