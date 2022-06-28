CREATE DATABASE DeptEmp
GO 

USE DeptEmp

GO

CREATE TABLE Department(
	DepartmentNo int PRIMARY KEY,
	DepartmentName char(25) NOT NULL,
	Location char(25) NOT NULL,
)

INSERT INTO Department VALUES (10, 'Accounting', 'Melbourne'),
						(20, 'Research', 'Adealide'),
						(30, 'Sales', 'Sydney'),
						(40, 'Operations', 'Perth')

CREATE TABLE Employee(
	EmpNo int PRIMARY KEY,
	Fname varchar(15) NOT NULL,
	Lname varchar(15) NOT NULL,
	Job varchar(25) NOT NULL,
	HireDate datetime NOT NULL, 
	Salary numeric NOT NULL,
	Commision numeric,
	DepartmentNo int FOREIGN KEY (DepartmentNo) REFERENCES Department(DepartmentNo) ON UPDATE CASCADE ON DELETE CASCADE,
)

INSERT INTO Employee VALUES (1, 'John', 'Smith', 'Clerk', '1980-12-17', 800, null, 20),
							(2, 'Peter', 'Allen', 'Saleman', '1981-11-20', 1600, 300, 30),
							(3, 'Kate', 'Ward', 'Saleman', '1981-11-22', 1250, 500, 30),
							(4, 'Jack', 'Jones', 'Manager', '1981-07-02', 2975, null, 20),
							(5, 'Joe', 'Martin', 'Saleman', '1981-09-28', 1250, 1400, 30)

SELECT * FROM Department

SELECT * FROM Employee

SELECT EmpNo, Fname, Lname
FROM Employee
WHERE Fname = N'Kate'


SELECT (Fname + ' '+ Lname) FullName, (Salary + Salary * 0.1) AS SalaryNew
FROM Employee


SELECT Fname, Lname, HireDate
FROM Employee
WHERE YEAR(HireDate) = 1981
ORDER BY Lname


SELECT Employee.DepartmentNo, MAX(Salary)
FROM Employee INNER JOIN Department
ON Employee.DepartmentNo = Department.DepartmentNo
GROUP BY Employee.DepartmentNo

SELECT Employee.DepartmentNo, MIN(Salary)
FROM Employee INNER JOIN Department
ON Employee.DepartmentNo = Department.DepartmentNo
GROUP BY Employee.DepartmentNo

SELECT Employee.DepartmentNo, AVG(Salary)
FROM Employee INNER JOIN Department
ON Employee.DepartmentNo = Department.DepartmentNo
GROUP BY Employee.DepartmentNo

SELECT Employee.DepartmentNo, COUNT(Employee.DepartmentNo) AS SOLUONG
FROM Employee
GROUP BY Employee.DepartmentNo

SELECT Employee.DepartmentNo, DepartmentName, (Fname + ' '+ Lname) FullName, Job, Salary
FROM Employee INNER JOIN Department
ON Employee.DepartmentNo = Department.DepartmentNo


