--Tạo cơ sở DL
CREATE DATABASE QLBanHang

GO
--Điều hướng  csdl hiện hành từ master sang csdl vừa tạo
USE QLBanHang2

GO

--Tạo bảng
CREATE TABLE HangSX(
	MaHangSX char(10) PRIMARY KEY,
	TenHang nvarchar(30) NOT NULL,
	DiaChi nvarchar(50) NOT NULL DEFAULT N'Hà Nội',
	SoDT varchar(11),
	Email varchar(40)
)
--DROP TABLE HangSX

--ALTER TABLE HangSX 
	--ALTER COLUMN Email char(10)

--ALTER TABLE HangSX
	--DROP CONSTRAINT [PK__HangSX__8C6D28FEDFB65624]

CREATE TABLE SanPham(
	MaSP char(10) PRIMARY KEY,
	MaHangSX char(10) FOREIGN KEY (MaHangSX) REFERENCES HangSX(MaHangSX) ON UPDATE CASCADE ON DELETE CASCADE,
	TenSP nvarchar(30) NOT NULL,
	SoLuong int NOT NULL,
	GiaBan money,
	DonViTinh nvarchar(20),
	MoTa nvarchar(30)
)

SELECT * FROM SanPham

--Thêm một cột vào bảng
ALTER TABLE SanPham
	ADD DonViTinh nvarchar(20)
ALTER TABLE SanPham
	ADD MauSac nvarchar(10)

CREATE TABLE NhanVien(	
	MaNV char(10) PRIMARY KEY,
	TenNV nvarchar(30) NOT NULL,
	GioiTinh bit,
	DiaChi nvarchar(50),
	SoDT nvarchar(11) NOT NULL UNIQUE,
	Email varchar(40),
	TenPhong nvarchar(40)
)

CREATE TABLE PNhap(
	SoHDN char(10) PRIMARY KEY,
	NgayNhap date NOT NULL,
	MaNV char(10) FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE Nhap(
	SoHDN char(10) FOREIGN KEY (SoHDN) REFERENCES PNhap(SoHDN) ON UPDATE CASCADE ON DELETE CASCADE,
	MaSP char(10) FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	SoLuongN int NOT NULL CHECK (SoLuongN > 2),
	DonGiaN int NOT NULL,
	PRIMARY KEY(SoHDN, MaSP)
)

CREATE TABLE PXuat(
	SoHDX char(10) PRIMARY KEY,
	NgayXuat date NOT NULL DEFAULT GETDATE(),
	MaNV char(10) FOREIGN KEY (MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE
)

CREATE TABLE Xuat(
	SoHDX char(10) FOREIGN KEY (SoHDX) REFERENCES PXuat(SoHDX) ON UPDATE CASCADE ON DELETE CASCADE,
	MaSP char(10) FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	SoLuongX int CHECK (SoLuongX > 0 AND SoLuongX < 100),
	PRIMARY KEY(SoHDX, MaSP)
)

--INSERT, UPADTE, DELETE
--Cách1
INSERT INTO HangSX VALUES ('HSX01', N'Hải Hà', N'Hồ Chí Minh', '12345678', 'hh@gmail.com')
INSERT INTO HangSX VALUES ('HSX02', N'Hải Châu', N'Hà Nội', '123456789', 'hc@gmail.com')
INSERT INTO HangSX VALUES ('HSX03', N'Tiền Phong', DEFAULT, '0123456789', 'tp@gmail.com')

--Cách2
INSERT INTO HangSX VALUES ('HSX01', N'Hải Hà', N'Hồ Chí Minh', '12345678', 'hh@gmail.com'),
							('HSX02', N'Hải Châu', N'Hà Nội', '123456789', 'hc@gmail.com'),
							('HSX03', N'Tiền Phong', DEFAULT, '0123456789', 'tp@gmail.com'),
							('HSX04', N'Phong Phú', N'Hải Phòng', '0987654321', 'pp@gmail.com')

--Hiển thị dữ liệu
SELECT * FROM HangSX

--Hiển thị hãng sx ở HCM

SELECT * FROM HangSX
WHERE DiaChi = N'Hà Nội'

--Sửa dl của hsx02
UPDATE HangSX
SET TenHang = N'Hải Châu',
	DiaChi = N'Hồ Chí Minh'
WHERE MaHangSX = 'HSX02'

--Sửa địa chỉ của tất cả các hãng sx thành Hà Nội
UPDATE HangSX
SET DiaChi = N'Hà Nội'

--Xóa những hãng sx có tên bắt đầu bằng chữ T
DELETE FROM HangSX
WHERE TenHang LIKE 'T%'

 --Xóa tất cả
DELETE FROM HangSX


INSERT INTO SanPham VALUES('SP01', 'HSX01', N'Kẹo Dẻo', 20, 2000, N'Kẹo cho trẻ em', N'Đỏ', N'Gói'),
							('SP02', 'HSX02', N'Kẹo Kéo', 20, 20000, N'Kẹo cho trẻ em', N'Trắng', N'Chiếc')

SELECT * FROM SanPham

INSERT INTO NhanVien VALUES ('NV01', N'Nguyễn Thị Hoa', 1, N'Hà Nội', '0123456789', 'hoa@gmail.com', N'Hành chính'),
							('NV02', N'Nguyễn Thị Hoài', 1, N'Hà Nội', '123456789', 'hoai@gmail.com', N'Hành chính'),
							('NV03', N'Nguyễn Văn Nam', 0, N'Ninh Bình', '234567890', 'nam@gmail.com', N'Kinh doanh')
SELECT * FROM NhanVien
DELETE FROM NhanVien

INSERT INTO PNhap VALUES ('HDN01', '2022/03/15', 'NV03')
SELECT * FROM PNhap

--Trả về ngày giờ hiện tại
SELECT GETDATE()

INSERT INTO Nhap VALUES ('HDN01', 'SP01', 3, 5000)
SELECT * FROM Nhap

--Chèn 4 dòng dl vào mỗi bảng
--Nộp file .sql trên hệ thống hạn tối 16/3
--Làm bt về nhà sau khi lên lớp hạn tối thứ hai tuần sau