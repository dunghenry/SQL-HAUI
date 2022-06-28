/*SanPham(MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
HangSX(MaHangSX, TenHang, DiaChi, SoDT, Email)
NhanVien(MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
Nhap(SoHDN, MaSP, SoLuongN, DonGiaN)
PNhap(SoHDN,NgayNhap,MaNV)
Xuat(SoHDX, MaSP, SoLuongX)
PXuat(SoHDX,NgayXuat,MaNV)*/
--tạo cơ sở dữ liệu
CREATE DATABASE	QLBANHANG
--sử dụng CSDL vừa tạo (điều hướng csdl hiện hành từ master về csdl vừa tạo)
USE		QLBANHANG
GO
--Tạo bảng 
-- Thứ tự tạo bảng: tạo bảng cha trước (chứa khóa chính), bảng con sau (bảng chứa khóa ngoài)
--HangSX(MaHangSX, TenHang, DiaChi, SoDT, Email)
CREATE TABLE	HangSX(
	MaHangSX	char(10)	PRIMARY KEY,
	TenHang		nvarchar(30)	NOT NULL,
	DiaChi		nvarchar(50)	NOT NULL DEFAULT N'Hà Nội',
	SoDT		varchar(11),
	Email		varchar(40))
--SanPham(MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
CREATE TABLE SanPham(
	MaSP		char(10) PRIMARY KEY,
	MaHangSX	char(10) FOREIGN KEY(MaHangSX) REFERENCES HangSX(MaHangSX) ON UPDATE CASCADE ON DELETE CASCADE,
	TenSP		nvarchar(30) NOT NULL,
	SoLuong		int,
	MauSac		nvarchar(15),
	GiaBan		money,
	DonViTinh	nvarchar(20),
	MoTa		nvarchar(100))
--NhanVien(MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
CREATE TABLE NhanVien(
	MaNV		char(10) PRIMARY KEY,
	TenNV		nvarchar(30) NOT NULL,
	GioiTinh	bit,
	DiaChi		nvarchar(50),
	SoDT		varchar(11)	NOT NULL UNIQUE,
	Email		varchar(40),
	TenPhong	nvarchar(30)	NOT NULL)
--PNhap(SoHDN,NgayNhap,MaNV)
CREATE TABLE	PNhap(
	SoHDN		char(10)	PRIMARY KEY,
	NgayNhap	date CHECK (NgayNhap<=GETDATE()),-- Ngay Nhap phải trước hoặc bằng ngày hiện tại
	MaNV		char(10) FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE)
--Nhap(SoHDN, MaSP, SoLuongN, DonGiaN)
CREATE TABLE Nhap(
	SoHDN	char(10) FOREIGN KEY(SoHDN) REFERENCES	PNhap(SoHDN) ON UPDATE CASCADE ON DELETE CASCADE,
	MaSP	 char(10) FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	SoLuongN	int	NOT NULL,
	DonGiaN		money
	PRIMARY KEY(SoHDN,MaSP))
--PXuat(SoHDX,NgayXuat,MaNV)
CREATE TABLE PXuat(
	SoHDX	char(10)	 PRIMARY KEY,
	NgayXuat	date NOT NULL,
	MaNV	char(10) FOREIGN KEY(MaNV) REFERENCES NhanVien(MaNV) ON UPDATE CASCADE ON DELETE CASCADE)
--Xuat(SoHDX, MaSP, SoLuongX)
CREATE TABLE Xuat(
	SoHDX	char(10) FOREIGN KEY(SoHDX) REFERENCES PXuat(SoHDX) ON UPDATE CASCADE ON DELETE CASCADE,
	MaSP	char(10) FOREIGN KEY(MaSP) REFERENCES SanPham(MaSP) ON UPDATE CASCADE ON DELETE CASCADE,
	SoLuongX	int CHECK(SoLuongX>0 AND SoLuongX<=100))
--Thao tác với dữ liệu trên bảng (DML: insert, update, delete)
--Nhập dữ liệu vào bảng theo thứ tự tạo bảng, tạo bảng nào trước thì nhập dữ liệu vào bảng đó trước
--HangSX(MaHangSX, TenHang, DiaChi, SoDT, Email)
INSERT INTO HangSX VALUES ('HSX01',N'Hải Hà',N'Hồ Chí Minh','0123456789','haiha@hh.vn'),
							('HSX02',N'Hải Châu',N'Hồ Chí Minh','0147878300','hc@gmail.com'),
							('HSX03',N'Tiền Phong',DEFAULT, '0987634850','TP@gmail.com')
--hiển thị dữ liệu trên bảng
SELECT * FROM HangSX
--Liệt kê các hãng sản xuất ở thành phố hồ chí minh
SELECT * FROM HANGSX
WHERE DiaChi=N'Hồ Chí Minh'
-- chỉnh sửa dữ liệu của hãng sx 01 để có thể hiển thị tiếng việt
UPDATE HangSX
SET TenHang=N'Hải Hà',
	DiaChi=N'Hồ Chí Minh'
WHERE MaHangSX='HSX01'
--Chuyển tất cả các hãng sản xuất về hải phòng
UPDATE HangSX 
SET DiaChi=N'Hải Phòng'
--xóa 1 dòng trong bảng
DELETE FROM HangSX WHERE MaHangSX='HSX01'
--xóa tất cả các dòng trong bảng
DELETE FROM HangSX
--SanPham(MaSP, MaHangSX, TenSP, SoLuong, MauSac, GiaBan, DonViTinh, MoTa)
INSERT INTO SanPham VALUES ('SP01','HSX01',N'Kẹo dẻo',10,N'đỏ',20000,N'gói',N'Kẹo cho trẻ em'),
							('SP02','HSX02',N'Kẹo cứng', 20,N'trắng',30000,N'gói',N'Kẹo cho trẻ em'),
							('SP03','HSX01',N'Kẹo cam', 30,N'vàng', 10000, N'hộp',N'Kẹo ai cũng ăn được')
--hiển thị dữ liệu trong bảng
SELECT * FROM SanPham
--NhanVien(MaNV, TenNV, GioiTinh, DiaChi, SoDT, Email, TenPhong)
INSERT INTO NhanVien VALUES('NV01',N'Nguyễn Thị Hoa',0,N'Hà Nội','012345678','hoa@nv.com',N'Hành chính'),
							('NV02',N'Nguyễn Thị Hoaì',0,N'Hà Nội','012345698','hoai@nv.com',N'Hành chính'),
							('NV03',N'Phạm Văn Hà',1,N'Hà Nội','01234343545','ha@nv.com',N'Kinh doanh')
	INSERT INTO NhanVien VALUES('NV04',N'Bùi Văn Toàn',1,N'Hà Nội','0123456734','toan@nv.com',N'Hành chính')
SELECT * FROM NhanVien
--PNhap(SoHDN,NgayNhap,MaNV)
SELECT GETDATE()--trả về ngày tháng năm giờ phút giây  hiện tại
INSERT INTO PNhap VALUES('PN01','2022-03-19','NV03')
INSERT INTO PNhap VALUES('PN02','2020-03-20','NV03')
INSERT INTO PNhap VALUES('PN03','2022-03-19','NV02')
INSERT INTO PNhap VALUES('PN04','2020-10-20','NV01')
INSERT INTO PNhap VALUES('PN02','2022-04-19','NV01')--KO NHẬP ĐƯỢC DO NGÀY NHẬP SAU NGÀY HIỆN TẠI
SELECT * FROM PNhap
--Nhap(SoHDN, MaSP, SoLuongN, DonGiaN)
INSERT INTO Nhap VALUES('PN01','SP01',10,100000),
						('PN01','SP02',15,200000),
						('PN02','SP03',11,100000),
						('PN03','SP02',20,100000),
						('PN04','SP01',16,200000)
--PXuat(SoHDX,NgayXuat,MaNV)
INSERT INTO PXuat VALUES('HDX01','2022-3-20','NV01'),
('HDX02','2022-3-18','NV03'),
('HDX03','2022-3-5','NV01'),
('HDX04','2022-3-23','NV02')
--DELETE FROM PXUAT WHERE MANV='NV02'
UPDATE PXuat
SET NgayXuat='2020-6-13'
WHERE SoHDX='HDX04'
SELECT * FROM PXuat
--Xuat(SoHDX, MaSP, SoLuongX)
INSERT INTO Xuat VALUES('HDX01','SP01',5),
('HDX01','SP02',6),
('HDX02','SP01',4)
INSERT INTO Xuat VALUES('HDX04','SP01',5)
INSERT INTO Xuat VALUES('HDX04','SP02',9)

SELECT * FROM Xuat

