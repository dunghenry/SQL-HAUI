CREATE DATABASE ThucTap
go

use ThucTap

go

create table Khoa
(
	makhoa char(10) primary key,
	tenkhoa char(30) not null,
	dienthoai char(10) not null
)

create table GiangVien
(
	magv int primary key,
	hotengv char(30) not null,
	luong decimal(5,2) not null,
	makhoa char(10) FOREIGN KEY(makhoa) REFERENCES Khoa(makhoa) ON UPDATE CASCADE ON DELETE CASCADE
)

create table SinhVien
(
	masv int primary key,
	hotensv char(30) not null,
	makhoa char(10) FOREIGN KEY(makhoa) REFERENCES Khoa(makhoa) ON UPDATE CASCADE ON DELETE CASCADE,
	namsinh int not null,
	quequan char(30) not null
)

create table DeTai
(
	madt char(10) primary key,
	tendt char(30) not null,
	kinhphi int not null,
	NoiThucTap char(30)
)
create table HuongDan
(
	masv int primary key,
	madt char(10),
	magv int FOREIGN KEY(magv) REFERENCES GiangVien(magv) ON UPDATE CASCADE ON DELETE CASCADE,
	ketqua decimal(5, 2) not null
)




SELECT magv, hotengv, tenkhoa 
FROM Khoa INNER JOIN GiangVien
ON Khoa.makhoa = GiangVien.makhoa


SELECT magv, hotengv, tenkhoa 
FROM Khoa INNER JOIN GiangVien
ON Khoa.makhoa = GiangVien.makhoa
WHERE tenkhoa = N'DIA LY' OR tenkhoa = N'QLTN'

SELECT tenkhoa, COUNT(masv)
FROM Khoa INNER JOIN SinhVien
ON Khoa.makhoa = SinhVien.makhoa
WHERE tenkhoa = N'CONG NGHE SINH HOC'
GROUP BY tenkhoa

SELECT masv as 'masv', hotensv, namsinh, YEAR(GETDATE()) - YEAR(namsinh) 'Tuoi'
FROM Khoa INNER JOIN SinhVien
ON Khoa.makhoa = SinhVien.makhoa
WHERE tenkhoa = N'TOAN'


SELECT COUNT(magv)
FROM Khoa INNER JOIN GiangVien
ON Khoa.makhoa = GiangVien.makhoa
WHERE tenkhoa = N'CONG NGHE SINH HOC'

SELECT SinhVien.masv, hotensv, makhoa, namsinh, quequan
FROM SinhVien INNER JOIN HuongDan
ON SinhVien.masv = HuongDan.masv
WHERE madt is not null


SELECT Khoa.makhoa, tenkhoa, COUNT(tenkhoa)
FROM Khoa INNER JOIN GiangVien
ON Khoa.makhoa = GiangVien.makhoa
GROUP BY tenkhoa

SELECT dienthoai
FROM Khoa INNER JOIN SinhVien
ON Khoa.makhoa = SinhVien.makhoa
WHERE hotensv LIKE 'Le van son%'