CREATE DATABASE MarkManagement
GO

USE MarkManagement
GO

CREATE TABLE Students(
	StudentID nvarchar(12) PRIMARY KEY,
	StudentName nvarchar(25) NOT NULL,
	DateofBirth datetime NOT NULL,
	Email nvarchar(40),
	Phone nvarchar(12),
	Class nvarchar(10),
)
INSERT INTO Students VALUES('AV0807005', N'Mail Trung Hiếu', '1989/10/11', 'trunghieu@yahoo.com', '0904115116', 'AV1'),
							('AV0807006', N'Nguyễn Quý Hùng', '1988/12/2', 'quyhung@yahoo.com', '0955667787', 'AV2'),
							('AV0807007', N'Đỗ Đắc Huỳnh', '1990/1/2', 'dachuynh@yahoo.com', '0988574747', 'AV2'),
							('AV0807009', N'An Đăng Khuê', '1986/3/6', 'dangkhue@yahoo.com', '0986757463', 'AV1'),
							('AV0807010', N'Nguyễn T.Tuyết Lan', '1989/7/12', 'tuyetlan@yahoo.com', '0983310342', 'AV2'),
							('AV0807011', N'Đinh Phụng Long', '1990/12/2', 'phunglong@yahoo.com', null, 'AV1'),
							('AV0807012', N'Nguyễn Tuấn Nam', '1989/3/2', 'tuannam@yahoo.com', null, 'AV1')
							

CREATE TABLE Subjects(
	SubjectID nvarchar(10) PRIMARY KEY,
	SubjectName nvarchar(25) NOT NULL
)

INSERT INTO Subjects VALUES('S001', 'SQL'),
							('S002', 'Java Simplefield'),
							('S003', 'Active Server Page')
			


CREATE TABLE Mark(
	StudentID nvarchar(12),
	SubjectID nvarchar(10),
	Date datetime,
	Theory tinyint,
	Practical tinyint,
	PRIMARY KEY(StudentID, SubjectID),
)

INSERT INTO Mark(StudentID, SubjectID, Theory, Practical, Date) VALUES ('AV0807005', 'S001', 8, 25, '2008/5/6'),
																		('AV0807006', 'S002', 16, 30, '2008/5/6'),
																		('AV0807007', 'S001', 10, 25, '2008/5/6'),
																		('AV0807008', 'S003', 7, 13, '2008/5/6'),
																		('AV0807010', 'S003', 9, 16, '2008/5/6'),
																		('AV0807011', 'S002', 8, 30, '2008/5/6'),
																		('AV0807012', 'S001', 7, 31, '2008/5/6'),
																		('AV0807005', 'S002', 12, 11, '2008/6/6'),
																		('AV0807009', 'S003', 11, 20, '2008/6/6'),
																		('AV0807010', 'S001', 7, 6, '2008/6/6')

SELECT * FROM Students

SELECT * FROM Students
WHERE Class = 'AV1'

UPDATE Students
SET Class = 'AV2'
WHERE StudentID ='AV0807012'

SELECT Students.Class, COUNT(StudentID) AS SOLUONG
FROM Students
GROUP BY Students.Class

SELECT * FROM Students
WHERE Class ='AV2'
ORDER BY StudentName 

SELECT Students.StudentID, StudentName, SubjectID, Theory, Date
FROM Students INNER JOIN Mark
ON Students.StudentID = Mark.StudentID
WHERE SubjectID = 'S001' AND Theory < 10 AND Date = '2008/5/6'

SELECT COUNT(Students.StudentID) AS SOLUONG
FROM Students INNER JOIN Mark
ON Students.StudentID = Mark.StudentID
WHERE SubjectID = 'S001' AND Theory < 10

SELECT * FROM Students
WHERE(YEAR(DateofBirth) > YEAR('1980/1/1') AND Class = 'AV1')

DELETE FROM Students
WHERE StudentID = 'AV0807011'

SELECT Students.StudentID, Mark.SubjectID, StudentName, SubjectName, Theory,  Mark.Practical, Date
FROM Students INNER JOIN Mark
ON Students.StudentID = Mark.StudentID
INNER JOIN Subjects
ON Subjects.SubjectID = Mark.SubjectID
WHERE Mark.SubjectID = 'S001' AND Date = '2008/5/6'