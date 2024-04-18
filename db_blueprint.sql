-- Active: 1708887434952@@127.0.0.1@3306
-- Create database
CREATE DATABASE db_s2_project_1
DEFAULT CHARACTER SET = 'utf8mb4';

-- SELECT @@global.time_zone, @@session.time_zone;

-- SET time_zone = '+07:00';

USE db_s2_project_1;

CREATE TABLE lecturers(  
    nid         CHAR(10) NOT NULL,
    full_name   VARCHAR(50) NOT NULL,
    gender      BOOLEAN NOT NULL DEFAULT 1,
    phone       VARCHAR(20),
    email       VARCHAR(30),
    adress      VARCHAR(100),
    password    VARCHAR(50) NOT NULL,
    PRIMARY KEY (nid)
);
CREATE TABLE classes(  
    class_id    CHAR(5) NOT NULL,
    nid         CHAR(10) NOT NULL,
    class_name  VARCHAR(25) NOT NULL,
    PRIMARY KEY (class_id),
    FOREIGN KEY (nid) REFERENCES lecturers(nid)
);
CREATE TABLE students(  
    nis         CHAR(10) NOT NULL,
    class_id    CHAR(5) NOT NULL,
    full_name   VARCHAR(50) NOT NULL,
    gender      BOOLEAN NOT NULL DEFAULT 1,
    phone       VARCHAR(20) NOT NULL,
    email       VARCHAR(30) NOT NULL,
    adress      VARCHAR(100),
    PRIMARY KEY (nis),
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON UPDATE CASCADE
);
CREATE Table lecturer_attendance (
    la_id       INTEGER NOT NULL AUTO_INCREMENT,
    class_id    CHAR(5) NOT NULL,
    nid         CHAR(10) NOT NULL,
    timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (la_id),
    FOREIGN KEY (class_id) REFERENCES classes(class_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (nid) REFERENCES lecturers(nid) ON UPDATE CASCADE ON DELETE CASCADE
);
CREATE Table student_attendance (
    sa_id       INTEGER NOT NULL AUTO_INCREMENT,
    nis         CHAR(10) NOT NULL,
    status      INTEGER(1) NOT NULL DEFAULT 0,
    timestamp   TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (sa_id),
    FOREIGN KEY (nis) REFERENCES students(nis) ON UPDATE CASCADE ON DELETE CASCADE
);

-- Insert data

INSERT INTO lecturers 
VALUES
('1453495138', 'Hj. Ilsa Marpaung, S.Sos', '1', '+62 (0537) 958 9944', 'asmadi56@gmail.com', 'Gg. Sentot Alibasa No. 501', '12345'),
('0885060416', 'Aisyah Hasanah, S.Pd', '0', '0835165292', 'lanangnapitupulu@gmail.com', 'Jl. Dr. Djunjunan No. 3', '12346');

INSERT INTO classes
VALUES
('2ISA1', '1453495138', '2 ISA 1'),
('2CS1', '0885060416', '2 CS 1'),
('2WD1', '0885060416', '2 WD 1');

INSERT INTO students
VALUES
('5649727559', '2WD1', 'Humaira Santoso', '1', '085 135 2598', 'hafshah06@yahoo.com', 'Gang Gegerkalong Hilir No. 2'),
('5857628352', '2WD1', 'Hesti Sirait', '0', '081 429 1676', 'wmarpaung@gmail.com', 'Jalan Jend. Sudirman No. 5'),
('2937546910', '2WD1', 'Tgk. Dadap Mardhiyah', '1', '+62-0262-671-2921', 'indra51@hotmail.com', 'Gang Kapten Muslihat No. 4'),
('2561472035', '2WD1', 'Mahfud Anggraini', '1', '+62-85-586-0306', 'jabalnugroho@gmail.com', 'Gang Kiaracondong No. 102'),
('8329571520', '2WD1', 'Respati Marpaung', '0', '+62-0266-421-3368', 'situmorangsiska@yahoo.com', 'Jl. Lembong No. 1'),
('2122059598', '2WD1', 'R. Wirda Waskita', '0', '+62 (0048) 029 5277', 'qsinaga@gmail.com', 'Gg. Cihampelas No. 02'),
('8520944211', '2WD1', 'Vega Mardhiyah', '1', '0819545233', 'bagya05@gmail.com', 'Jalan Merdeka No. 9'),
('4020846939', '2WD1', 'Latika Pradana', '0', '+62 (764) 981-9490', 'halimahxanana@hotmail.com', 'Jalan Jend. Sudirman No. 838'),
('6418833471', '2WD1', 'Cornelia Mardhiyah', '0', '+62 (061) 705 8227', 'entengsitompul@hotmail.com', 'Jalan Jamika No. 45'),
('9857320445', '2WD1', 'Yuliana Putra', '1', '+62 (0331) 693 3502', 'wadi45@hotmail.com', 'Gang Indragiri No. 6'),
('0578425904', '2WD1', 'Ami Sitompul', '0', '0883325858', 'gasti01@gmail.com', 'Gg. Sentot Alibasa No. 59'),
('4794548312', '2WD1', 'Cakrawangsa Nashiruddin', '1', '+62-091-609-0463', 'galar58@yahoo.com', 'Gang Pelajar Pejuang No. 55'),
('1194836062', '2WD1', 'Keisha Rahmawati', '0', '0882467086', 'mayasusanti@hotmail.com', 'Gang HOS. Cokroaminoto No. 402'),
('4646916545', '2WD1', 'Caturangga Suwarno', '1', '082 720 3035', 'hani61@yahoo.com', 'Gg. HOS. Cokroaminoto No. 1'),
('0550095906', '2WD1', 'Nova Kusumo', '1', '+62 (048) 151 7156', 'unggulwinarsih@gmail.com', 'Gg. Astana Anyar No. 9'),
('5677380173', '2ISA1', 'R. Mila Hartati', '0', '+62 (862) 415 2081', 'ghartati@gmail.com', 'Jalan Waringin No. 9'),
('0930364789', '2ISA1', 'Digdaya Agustina, S.Pd', '0', '+62 (007) 860 9968', 'ytampubolon@gmail.com', 'Jalan Tebet Barat Dalam No. 0'),
('7144990249', '2ISA1', 'Ir. Usyi Hastuti', '0', '0828362765', 'drajata@gmail.com', 'Gg. Otto Iskandardinata No. 8'),
('5812329477', '2ISA1', 'drg. Farah Usada', '0', '+62-06-930-5231', 'ajiminzulkarnain@yahoo.com', 'Jalan Jend. A. Yani No. 540'),
('5112831150', '2ISA1', 'KH. Ade Narpati', '1', '0812574976', 'wibisonodadi@gmail.com', 'Gang Asia Afrika No. 483'),
('2361832765', '2ISA1', 'Dina Dongoran', '0', '+62 (25) 457 5162', 'rahman41@hotmail.com', 'Gang Tebet Barat Dalam No. 899'),
('7689713938', '2ISA1', 'Drs. Mitra Maheswara', '1', '+62 (092) 037 6546', 'dmarbun@gmail.com', 'Gg. Ronggowarsito No. 943'),
('3361814306', '2ISA1', 'Ian Palastri', '1', '+62-0172-448-0402', 'drahayu@hotmail.com', 'Jalan Jamika No. 7'),
('4327635272', '2ISA1', 'dr. Daruna Damanik', '1', '+62 (071) 635-9022', 'mandalabakiman@gmail.com', 'Gang Sadang Serang No. 26'),
('3988254383', '2ISA1', 'Bakti Mandasari, S.Pt', '0', '+62 (02) 839 4958', 'faizah85@hotmail.com', 'Gg. Laswi No. 346'),
('6681041596', '2ISA1', 'Rudi Hutapea', '1', '0852371939', 'hamzahnainggolan@gmail.com', 'Jl. PHH. Mustofa No. 4'),
('0339525289', '2ISA1', 'Cemeti Farida', '0', '+62-771-626-4624', 'cager39@yahoo.com', 'Gg. Sentot Alibasa No. 694'),
('8922432502', '2ISA1', 'Uda Widodo', '1', '+62-025-017-1462', 'naradi20@yahoo.com', 'Jl. Sadang Serang No. 124'),
('7678425866', '2ISA1', 'Drajat Rajasa', '1', '0872074756', 'prastutiparman@gmail.com', 'Gang Soekarno Hatta No. 278'),
('7516982939', '2ISA1', 'Manah Hutapea', '0', '+62-0563-999-2363', 'olgapertiwi@yahoo.com', 'Jalan Dipatiukur No. 61'),
('5953018039', '2CS1', 'Kanda Prastuti', '0', '+62 (61) 070-1361', 'jsuryatmi@gmail.com', 'Gg. Cikutra Barat No. 67'),
('1552384338', '2CS1', 'Cut Cinthia Ardianto', '0', '+62-018-433-3794', 'oprastuti@hotmail.com', 'Jalan Gedebage Selatan No. 788'),
('9794705145', '2CS1', 'Prasetyo Uyainah', '1', '(0210) 945-9276', 'jumadihandayani@yahoo.com', 'Gg. PHH. Mustofa No. 5'),
('3064357718', '2CS1', 'Gasti Kusmawati', '0', '(025) 014 4124', 'lpudjiastuti@yahoo.com', 'Gg. PHH. Mustofa No. 834'),
('6851959479', '2CS1', 'Tgk. Usyi Hartati', '0', '+62 (97) 525-7325', 'yahya47@yahoo.com', 'Gg. Surapati No. 52'),
('3404163975', '2CS1', 'Atma Adriansyah', '1', '+62 (0467) 035-5478', 'dwinatsir@yahoo.com', 'Gang Moch. Toha No. 29'),
('4392950594', '2CS1', 'dr. Zelaya Wibowo, S.H.', '1', '+62 (358) 627-2665', 'wira03@yahoo.com', 'Gg. Jend. A. Yani No. 72'),
('6890274285', '2CS1', 'Ir. Cindy Gunarto, S.Psi', '0', '0856182993', 'lestarimuni@yahoo.com', 'Gg. Tebet Barat Dalam No. 97'),
('7202814759', '2CS1', 'Icha Jailani', '0', '+62 (0107) 035-6915', 'onapitupulu@hotmail.com', 'Gang Jamika No. 252'),
('6002510617', '2CS1', 'Siska Pranowo, M.Pd', '0', '+62 (771) 115 4066', 'darmanayulianti@hotmail.com', 'Gang Rajawali Barat No. 601'),
('0623309489', '2CS1', 'Tgk. Dalima Wacana', '1', '+62 (153) 808-3730', 'ophelia01@hotmail.com', 'Gang Abdul Muis No. 2'),
('7664560861', '2CS1', 'Dt. Ganda Saragih, S.IP', '1', '+62-474-528-0851', 'opermadi@yahoo.com', 'Jl. Kebonjati No. 86'),
('9712238148', '2CS1', 'Maryadi Kusumo', '1', '+62-382-888-2116', 'diananuraini@hotmail.com', 'Jalan Dipenogoro No. 817'),
('2750814402', '2CS1', 'Dwi Sirait', '0', '+62 (0973) 454-9781', 'endah24@yahoo.com', 'Jl. Dipatiukur No. 85'),
('7951722613', '2CS1', 'dr. Rina Nuraini, S.Farm', '0', '+62-0850-468-4417', 'galak61@yahoo.com', 'Gg. M.H Thamrin No. 752');

INSERT INTO student_attendance(nis, status, timestamp)
VALUES
('7144990249', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('5812329477', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('5112831150', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('2361832765', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('2937546910', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('2561472035', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('8329571520', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('2122059598', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('8520944211', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('4020846939', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('6890274285', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('7202814759', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('6002510617', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('0623309489', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('7664560861', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('9712238148', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('2750814402', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('7951722613', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -1 DAY)),
('7144990249', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('5812329477', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('5112831150', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('2361832765', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('2937546910', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('2561472035', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('8329571520', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('2122059598', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('8520944211', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('4020846939', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('6890274285', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('7202814759', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('6002510617', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('0623309489', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('7664560861', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('9712238148', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('2750814402', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
('7951722613', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -2 DAY)),
(
    '0623309489', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('7664560861', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('9712238148', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('2750814402', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('7951722613', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('8329571520', 1, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('2122059598', 2, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('8520944211', 2, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('4020846939', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('6890274285', 0, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('7202814759', 2, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY)),
('6002510617', 2, ADDDATE(CURRENT_TIMESTAMP, INTERVAL -3 DAY));