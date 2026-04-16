--ALL_IN_ONE.sql
USE master;

--CREATE DATABASE ALL_IN_ONE
--ON
--(
--	NAME = ALL_IN_ONE_dat,
--	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ALL_IN_ONE.mdf',
--	SIZE = 8MB,
--	MAXSIZE = 500MB,
--	FILEGROWTH = 8MB
--)
--LOG ON
--(
--	NAME = ALL_IN_ONE_log,
--	FILENAME = 'C:\Program Files\Microsoft SQL Server\MSSQL14.SQLEXPRESS\MSSQL\DATA\ALL_IN_ONE.log',
--	SIZE = 8MB,
--	MAXSIZE = 500MB,
--	FILEGROWTH = 8MB
--)

USE ALL_IN_ONE; 
GO

CREATE TABLE Directions (
    direction_id TINYINT PRIMARY KEY,
    direction_name NVARCHAR(150) NOT NULL
);
GO

CREATE TABLE Teachers (
    teacher_id INT PRIMARY KEY,
    last_name NVARCHAR(50) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    middle_name NVARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    email NVARCHAR(50),
    phone NVARCHAR(20),
    photo VARBINARY(MAX),
    work_since DATE NOT NULL,
    rate MONEY NOT NULL
);
GO

CREATE TABLE Disciplines (
    discipline_id SMALLINT PRIMARY KEY,
    discipline_name NVARCHAR(150) NOT NULL,
    number_of_lessons SMALLINT NOT NULL
);
GO

CREATE TABLE Groups (
    group_id INT PRIMARY KEY,
    group_name NVARCHAR(16) NOT NULL,
    direction TINYINT NOT NULL 
    CONSTRAINT FK_Groups_Directions FOREIGN KEY REFERENCES Directions(direction_id)
);
GO

CREATE TABLE TeacherDisciplinesRelation (
    teacher INT CONSTRAINT FK_TDR_Teachers FOREIGN KEY REFERENCES Teachers(teacher_id),
    discipline SMALLINT CONSTRAINT FK_TDR_Disciplines FOREIGN KEY REFERENCES Disciplines(discipline_id),
    PRIMARY KEY (teacher, discipline)
);
GO

CREATE TABLE DisciplinesDirectionsRelation (
    discipline SMALLINT,
    direction TINYINT,
    PRIMARY KEY(discipline, direction),
    CONSTRAINT FK_DDR_Disciplines FOREIGN KEY(discipline) REFERENCES Disciplines(discipline_id),
    CONSTRAINT FK_DDR_Directions FOREIGN KEY(direction) REFERENCES Directions(direction_id)
);
GO

CREATE TABLE Students (
    student_id INT PRIMARY KEY,
    last_name NVARCHAR(50) NOT NULL,
    first_name NVARCHAR(50) NOT NULL,
    middle_name NVARCHAR(50) NOT NULL,
    birth_date DATE NOT NULL,
    email NVARCHAR(50),
    phone NVARCHAR(50),
    photo VARBINARY(MAX),
    [group] INT CONSTRAINT FK_Students_Groups FOREIGN KEY REFERENCES Groups(group_id)
);
GO

CREATE TABLE Schedule (
    lesson_id BIGINT PRIMARY KEY IDENTITY(1,1),
    [date] DATE NOT NULL,
    [time] TIME(0) NOT NULL,
    [group] INT NOT NULL CONSTRAINT FK_Schedule_Groups FOREIGN KEY REFERENCES Groups(group_id),
    discipline SMALLINT NOT NULL CONSTRAINT FK_Schedule_Disciplines FOREIGN KEY REFERENCES Disciplines(discipline_id),
    teacher INT NOT NULL CONSTRAINT FK_Schedule_Teachers FOREIGN KEY REFERENCES Teachers(teacher_id),
    [subject] NVARCHAR(256) NULL,
    spent BIT NOT NULL
);
GO

CREATE TABLE Grades (
    student INT CONSTRAINT FK_Grades_Students FOREIGN KEY REFERENCES Students(student_id),
    lesson BIGINT CONSTRAINT FK_Grades_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
    grade_1 TINYINT CONSTRAINT CK_Grade_1 CHECK(grade_1 > 0 AND grade_1 <= 12),
    grade_2 TINYINT CONSTRAINT CK_Grade_2 CHECK(grade_2 > 0 AND grade_2 <= 12),
    PRIMARY KEY(student, lesson)
);
GO

CREATE TABLE Exams (
    student INT CONSTRAINT FK_Exams_Students FOREIGN KEY REFERENCES Students(student_id),
    teacher INT CONSTRAINT FK_Exams_Teachers FOREIGN KEY REFERENCES Teachers(teacher_id),
    discipline SMALLINT CONSTRAINT FK_Exams_Disciplines FOREIGN KEY REFERENCES Disciplines(discipline_id),
    grade TINYINT CONSTRAINT CK_Grade CHECK(grade > 0 AND grade <= 12),
    PRIMARY KEY(student, teacher, discipline)
);
GO

CREATE TABLE Homeworks (
    lesson BIGINT PRIMARY KEY CONSTRAINT FK_Homeworks_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
    task VARBINARY(1000) NULL,
    deadline date NULL
);
GO

CREATE TABLE HWresults (
    student INT CONSTRAINT FK_HWresults_Students FOREIGN KEY REFERENCES Students(student_id),
    lesson BIGINT CONSTRAINT FK_HWresults_Schedule FOREIGN KEY REFERENCES Schedule(lesson_id),
    data VARBINARY(1000) NULL,
    grade TINYINT NULL CONSTRAINT CK_HWresults_Grade CHECK(grade > 0 AND grade <= 12),
    answer INT NULL,
    PRIMARY KEY(student, lesson)