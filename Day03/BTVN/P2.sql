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

SELECT DeTai.madt, tendt
FROM GiangVien INNER JOIN HuongDan
ON GiangVien.magv = HuongDan.magv
INNER JOIN DeTai
ON DeTai.madt = HuongDan.madt
WHERE hotengv = 'Tran son%'

SELECT tendt, COUNT(masv)
FROM DeTai INNER JOIN HuongDan
ON DeTai.madt = HuongDan.madt
GROUP BY tendt
HAVING COUNT(masv) = 0

SELECT GiangVien.magv, hotengv, tenkhoa, COUNT(masv)
FROM GiangVien INNER JOIN HuongDan
ON GiangVien.magv = HuongDan.magv
INNER JOIN Khoa
ON Khoa.makhoa = GiangVien.makhoa
GROUP BY madt
HAVING COUNT(masv) >= 3


SELECT DeTai.madt, tendt, MAX(kinhphi)
FROM DeTai INNER JOIN HuongDan
ON DeTai.madt = HuongDan.madt
GROUP BY tendt

SELECT DeTai.madt, tendt, COUNT(masv)
FROM DeTai INNER JOIN HuongDan
ON DeTai.madt = HuongDan.madt
GROUP BY tendt
HAVING COUNT(masv) > 2

SELECT SinhVien.masv, hotensv, ketqua
FROM SinhVien INNER JOIN HuongDan
ON SinhVien.masv = HuongDan.masv
INNER JOIN Khoa
ON Khoa.makhoa = SinhVien.makhoa
WHERE tenkhoa = 'DIA LY' OR tenkhoa ='QLTN'

SELECT tenkhoa, COUNT(masv) as SOLUONG
FROM Khoa INNER JOIN SinhVien
ON Khoa.makhoa = SinhVien.makhoa
GROUP BY tenkhoa