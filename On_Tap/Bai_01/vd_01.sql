--File dữ liệu(primary data file): .mdf, .ndf
--File nhật kí(log file): .ldf
--Tạo cơ sở dữ liệu BanHang, bắt đầu có kích thước 20MB - trong  đó  15MB dành cho lưu dữ liệu và 5MB dành cho file nhật kí
CREATE DATABASE BanHang
ON PRIMARY(
	NAME = Sales_dat,
	FILENAME = 'D:\SQL-HAUI\OnTap\Bai_01.mdf',
	SIZE = 15MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 20%
)
LOG ON(
	NAME = Sales_log,
	FILENAME = 'D:\SQL-HAUI\OnTap\Bai_01.ldf',
	SIZE = 5MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 1MB
)
GO 
USE
BanHang
--Xóa cơ sở dữ liệu
DROP DATABASE BanHang

--Sửa đổi cơ sở dữ liệu: ALTER DATABASE
--ALTER DATABASE databasename 
--ADD FILE<Thông tin file dl>[,...n]
--ADD LOG FILE <Thông tin file log>[,...n]
--REMOVE FILE <Tên logic>
--MODIFY FILE<Thông tin file>

--Tạo bảng: CREATE TABLE
CREATE TABLE NhanVien(
	MaNV nvarchar(10) PRIMARY KEY,
	HoTen nvarchar(50) not null,
	NgaySinh datetime null,
	DienThoai nvarchar(10) null,
	HsLuong decimal(3, 2) default(1.92)
)
--Chèn dữ liệu: INSERT INTO
INSERT INTO NhanVien VALUES('NV01', 'TRAN VAN DUNG', '2001/8/30', '0866778584', 2.1)

--Lấy tất cả dl từ bảng NhanVien
SELECT * FROM NhanVien

--Check
CREATE TABLE DiemTN(
	HoTen nvarchar(30) not null,
	NgaySinh datetime,
	DiemVan decimal(4, 2),
	CONSTRAINT ck_DiemVan
	CHECK(DiemVan >= 0 AND DiemVan <= 10),
	DiemToan decimal(4, 2),
	CONSTRAINT ck_DiemToan
	CHECK(DiemToan >= 0 AND DiemToan <= 10)
)

INSERT INTO DiemTN VALUES('TRAN DUNG', '2001/8/30', 10.5, 5.5) --Error
INSERT INTO DiemTN VALUES('TRAN DUNG', '2001/8/30', 10, 5.5) --Success

--Table primary key
--VD khóa chính là MSV
CREATE TABLE SinhVien(
	MaSV nvarchar(10)
	CONSTRAINT pk_SinhVien_MaSV PRIMARY KEY,
	HoDem nvarchar(25) not null,
	Ten nvarchar(10) not null,
	NgaySinh datetime,
	GioiTinh bit,
	NoiSinh nvarchar(255),
	MaLop nvarchar(10)
)

--VD khóa chính là tập hợp bao gồm hai cột MaMH va MaSV
CREATE TABLE DiemThi(
	MaMH nvarchar(10) not null,
	MaSV nvarchar(10) not null,
	DiemLan1 numeric(4, 2),
	DiemLan2 numeric(4, 2),
	CONSTRAINT pk_DiemThi PRIMARY KEY(MaMH, MaSV)
)

--TABLE UNIQUE
--VD: Giả sử ta cần định nghĩa bảng lớp với khóa chính là cột mã lớp nhưng đồng thời lại ko cho phép các lớp khác nhau đc trùng tên lớp với nhau
CREATE TABLE Lop(
	MaLop nvarchar(10) not null,
	TenLop nvarchar(30) not null,
	Khoa smallint null,
	HeDaoTao nvarchar(25)  null,
	NamNhapHoc int null,
	MaKhoa nvarchar(5),
	CONSTRAINT pk_Lop PRIMARY KEY(MaLop),
	CONSTRAINT unique_Lop_TenLop UNIQUE(TenLop)
)

--Table foreign key
--VD:
CREATE TABLE diemthi(
	mamonhoc nvarchar(10) not null,
	masv nvarchar(10) not null,
	diemlan1 numeric(4, 2),
	diemlan2 numeric(4, 2),
	CONSTRAINT pk_diemthi PRIMARY KEY(mamonhoc, masv),
	CONSTRAINT fk_diemthi_mamonhoc FOREIGN KEY(mamonhoc) REFERENCES monhoc(mamonhoc) ON DELETE CASCADE ON UPDATE CASCADE,
	CONSTRAINT fk_diemthi_masv FOREIGN KEY(masv) REFERENCES sinhvien(masv) ON DELETE CASCADE ON UPDATE CASCADE,
)