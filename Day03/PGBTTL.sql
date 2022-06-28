CREATE DATABASE QLDiem

GO

USE QLDiem

GO

CREATE TABLE Lop
(
	MaLop char(3) PRIMARY KEY,
	TenLop nvarchar(50) NOT NULL,
	Khoa char(4) NOT NULL
)

INSERT INTO Lop VALUES ('L01', N'Công nghệ thông tin', 'CNTT'),
						('L02', N'Điện tử 4', 'DT'),
						('L04', N'Kĩ thuật phần mềm 3', 'CNTT')
INSERT INTO Lop VALUES('L03',N'Cơ khí 3','CK')

GO

CREATE TABLE SinhVien(
	MaSV char(4) PRIMARY KEY,
	HoDem nvarchar(50) NOT NULL,
	Ten nvarchar(50) NOT NULL,
	NgaySinh date,
	MaLop char(3) NOT NULL FOREIGN KEY REFERENCES Lop(MaLop) ON UPDATE CASCADE ON DELETE CASCADE
)

INSERT INTO SinhVien VALUES('SV01',N'Lê Ngọc', N'Hải','2000-2-14','L01')
INSERT INTO SinhVien VALUES('SV02',N'Lê Văn', N'Trung','2001-2-20','L02')
INSERT INTO SinhVien VALUES('SV03',N'Nguyễn Ngọc', N'Hà','2000-6-25','L03')
INSERT INTO SinhVien VALUES('SV04',N'Trần Vũ', N'Thanh','2000-12-14','L02')
INSERT INTO SinhVien VALUES('SV05',N'Lý Thanh', N'Tuyền','2000-7-16','L01')
INSERT INTO SinhVien VALUES('SV06',N'Lê Nguyễn Hồng', N'Hoa','2000-3-18','L01')
GO

CREATE TABLE MonHoc
(
	MaMonHoc char(3) PRIMARY KEY,
	TenMonHoc nvarchar(50) NOT NULL,
	SoDVHT int
)

INSERT INTO MonHoc VALUES ('M01', N'Toán cao cấp', 3),
							('M02', N'Tin học văn phòng', 2),
							('M03', N'Tiếng anh chuyên ngành', 4),
							('M04', N'Cơ sở dữ liệu', 3),
							('M05', N'Triết học', 2)

GO

CREATE TABLE DiemThi
(
	MaSV char(4),
	MaMonHoc char(3) 
	PRIMARY KEY(MaSV, MaMonHoc),
	DiemLan1 decimal(4, 2),
	DiemLan2 decimal(4, 2),
	FOREIGN KEY (MaSV) REFERENCES SinhVien(MaSV) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (MaMonHoc) REFERENCES MonHoc(MaMonHoc) ON UPDATE CASCADE ON DELETE CASCADE
)

INSERT INTO DiemThi VALUES ('SV01', 'M01', 10, NULL),
							('SV01', 'M03', 5, 8.75),
							('SV02', 'M04', 8.5, NULL),
							('SV03', 'M01', 4, 9)

SELECT * FROM Lop
SELECT * FROM SinhVien
SELECT * FROM MonHoc
SELECT * FROM DiemThi
				
--Đưa ra tên sinh viên và tên lớp mà sinh viên đó đang học
--Dùng mệnh đề where
SELECT Ten, TenLop	
FROM Lop, SinhVien
WHERE Lop.MaLop = SinhVien.MaLop
--Kết nối bằng phép kết nối trong
SELECT Ten, TenLop
FROM Lop INNER JOIN SinhVien
ON Lop.MaLop = SinhVien.MaLop

--Đưa ra họ đệm, tên , tên lớp, tên môn học và điểm lần 1 của môn học của tất cả các sinh viên
SELECT HoDem, Ten, TenLop, TenMonHoc, DiemLan1
FROM Lop INNER JOIN SinhVien
ON Lop.MaLop = SinhVien.MaLop
	INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
	INNER JOIN MonHoc
ON DiemThi.MaMonHoc = MonHoc.MaMonHoc

--Dùng mệnh đề where

SELECT HoDem, Ten, TenLop, TenMonHoc, DiemLan1
FROM Lop, SinhVien, DiemThi, MonHoc
WHERE Lop.MaLop = SinhVien.MaLop
		AND SinhVien.MaSV = DiemThi.MaSV
		AND DiemThi.MaMonHoc = MonHoc.MaMonHoc


--Đưa ra tên sinh viên, tên môn học, điểm thi lần 1, điểm thi lần 2 của sinh viên đó và đặt bí danh cho bảng

SELECT Ten, TenMonHoc, DiemLan1, DiemLan2
FROM SinhVien SV INNER JOIN DiemThi AS DT
ON SV.MaSV = DT.MaSV
INNER JOIN MonHoc MH
ON MH.MaMonHoc = DT.MaMonHoc


--Đưa ra mã sinh viên, tên sinh viên, tên môn học, điểm thi lần 1, điểm thi lần 2
--C1
SELECT SinhVien.MaSV, Ten, TenMonHoc, DiemLan1, DiemLan2
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
INNER JOIN MonHoc
ON DiemThi.MaMonHoc = MonHoc.MaMonHoc
--C2
SELECT DiemThi.MaSV, Ten, TenMonHoc, DiemLan1, DiemLan2
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
INNER JOIN MonHoc
ON DiemThi.MaMonHoc = MonHoc.MaMonHoc

--Đưa ra tên sinh viên, điểm thi lần 1, điểm thi lần 2, có mã sinh viên là SV01

SELECT Ten, DiemLan1, DiemLan2
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE SinhVien.MaSV = 'SV01'


SELECT Ten AS 'Tên', DiemLan1 'Điểm lần 1', DiemLan2 'Điểm lần 2'
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE SinhVien.MaSV = 'SV01'

--Đưa ra tên, điểm trung bình của sinh viên có mã sinh viên là SV01 biết điểm trung bình = (điểm lần 1 + điểm lần 2) /2

SELECT Ten AS 'Tên', (DiemLan1 + DiemLan2) / 2 'Điểm trung bình'
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE SinhVien.MaSV = 'SV01'

--Đưa ra tên, điểm thi lần 1 và đánh giá điểm thi của tất cả các sinh viên
--Biết điểm lần 1  <= 3 TB,
--Điểm lần 1 > 4 và  <= 8 Khá 
--Điểm lần 1 > 8 và <=10 Giỏi

--Search case
SELECT Ten, DiemLan1, CASE
WHEN DiemLan1 <= 4 THEN N'Trung bình'
WHEN DiemLan1 <= 8 THEN N'Khá'
WHEN DiemLan1 <= 10 THEN N'Giỏi'
END AS TrangThai
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV

--Simple case
SELECT Ten, DiemLan1, CASE DiemLan1
WHEN 1 THEN N'Trung bình'
WHEN 2 THEN N'Trung bình'
WHEN 3 THEN N'Trung bình'
WHEN 3 THEN N'Trung bình'
WHEN 5 THEN N'Khá'
WHEN 6 THEN N'Khá'
WHEN 7 THEN N'Khá'
WHEN 8 THEN N'Khá'
WHEN 9 THEN N'Giỏi'
WHEN 10 THEN N'Giỏi'
END AS TranngThai
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV

--Đưa ra tên các sinh viên đã có điểm thi

SELECT Ten 
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV

--Đưa ra tên sinh viên khác nhau đã có điểm thi 

SELECT DISTINCT Ten
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV

--Đưa ra danh sách 2 sv đã có điểm thi

SELECT TOP 2 Ten
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV

--Mệnh đề WHERE 
--Sau mệnh đề where là một biểu thức điều kiện, tên cột phép so sánh một giá trị so sánh
--Đưa ra họ đệm, tên của tất cả sinh viên học ở khoa cntt

SELECT HoDem, Ten
FROM SinhVien INNER JOIN Lop
ON SinhVien.MaLop = Lop.MaLop
WHERE Khoa = N'CNTT'


--Đưa ra tên của sinh viên có điểm thi lần 1 từ 5 đến 9 điểm
--BETWEEN...AND
SELECT Ten 
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE DiemLan1 >= 5 AND DiemLan1 <= 9

--
SELECT Ten 
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE DiemLan1 BETWEEN 5 AND 9


--Đưa ra tên các sinh viên đã học các môn học có mã là M01 or M02 or M03

SELECT Ten
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE MaMonHoc = 'M01' or MaMonHoc = 'M02' or MaMonHoc = 'M03'

SELECT Ten
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE MaMonHoc IN('M01', 'M02', 'M03')

-- Đưa ra tên sinh có họ bắt đầu bằng chữ Lê
SELECT HoDem,Ten
FROM SinhVien
WHERE HoDem LIKE 'Lê%'

--Đưa ra họ đệm và tên sinh viên biết các sinh viên đó có họ đệm bắt đầu bằng chữ Lê và tên bắt đầu bằng chữ H hoặc chữ A

SELECT HoDem, Ten 
FROM SinhVien
WHERE HoDem LIKE 'Lê%' AND Ten LIKE '[A, H]%'

--Đưa ra danh sách sinh viên  chưa có điểm thi lần 2

SELECT SinhVien.MaSV, HoDem, Ten, NgaySinh, MaLop
FROM SinhVien INNER JOIN DiemThi
ON SinhVien.MaSV = DiemThi.MaSV
WHERE DiemLan2 IS NULL

--C2

SELECT * FROM SinhVien
WHERE MaSV IN (SELECT MaSV FROM DiemThi WHERE DiemLan2 IS NULL)


--Tạo một bảng chứa họ đệm, tên sinh viên, tuổi sinh viên

SELECT HoDem, Ten, YEAR(GETDATE()) - YEAR(NgaySinh) AS Tuoi
INTO TuoiSV
FROM SinhVien

SELECT * FROM TuoiSV

--DROP TABLE TuoiSV

--Mệnh đề order by
--Đưa ra họ đệm, tên sinh viên, ngày sinh , sắp xếp theo chiều giảm dần của ngày sinh, tăng dần của tên

SELECT HoDem, Ten, NgaySinh
FROM SinhVien
ORDER BY NgaySinh DESC, Ten


--GROUP BY...HAVING

--Đưa ra mã môn học và số lượng sinh viên đã có điểm lần 2 của môn học đó
SELECT * FROM DiemThi

SELECT MaMonHoc, COUNT(MaSV) SOLUONGSV
FROM DiemThi
WHERE DiemLan2 IS NOT NULL
GROUP BY MaMonHoc 

SELECT MaMonHoc, COUNT(DiemLAN2) SOLUONGSVDL2
FROM DiemThi
GROUP BY MaMonHoc

--Đưa ra mã lớp và số lượng sinh viên trong lớp đó

SELECT MaLop, COUNT(MaSV)
FROM SinhVien
GROUP BY MaLop

--Đưa ra mã lớp, số lượng sinh viên trong lớp của những lớp có số lượng sinh vien từ 2 trở nên
SELECT MaLop, COUNT(MaSV) AS SOLUONGSV
FROM SinhVien
GROUP BY MaLop
HAVING COUNT(MaSV) >= 2


--Đưa ra tên lớp, số lượng sinh viên từng lớp
SELECT TenLop, COUNT(MaSV)
FROM SinhVien INNER JOIN Lop
ON SinhVien.MaLop = Lop.MaLop
GROUP BY TenLop


SELECT TenLop, COUNT(*) --Lấy ra số lượng tất cả các dòng kể cả có gt null
FROM SinhVien INNER JOIN Lop
ON SinhVien.MaLop = Lop.MaLop
GROUP BY TenLop

--Đưa ra tên tất cả các lớp, số lượng sinh viên của từng lớp

SELECT TenLop, COUNT(MaSV)
FROM SinhVien LEFT JOIN Lop
ON SinhVien.MaLop = Lop.MaLop
GROUP BY TenLop

SELECT TenLop, COUNT(MaSV)
FROM SinhVien RIGHT JOIN Lop
ON SinhVien.MaLop=Lop.MaLop
GROUP BY TenLop

--Phân biệt COUNT(Tên cột) và COUNT(*)

SELECT TenLop, COUNT(*)
FROM SinhVien RIGHT JOIN Lop
ON SinhVien.MaLop=Lop.MaLop
GROUP BY TenLop

SELECT * FROM Lop LEFT JOIN SinhVien ON SinhVien.MaLop=Lop.MaLop