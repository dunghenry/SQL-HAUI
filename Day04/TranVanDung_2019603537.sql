CREATE DATABASE QLBanHang

GO

USE QLBanHang

GO

CREATE TABLE HangSX(
	MaHangSX char(10) PRIMARY KEY,
	TenHang nvarchar(30) NOT NULL,
	DiaChi nvarchar(50) NOT NULL DEFAULT N'Hà Nội',
	SoDT varchar(11),
	Email varchar(40)
)

CREATE TABLE SanPham
(
	MaSP char(10) PRIMARY KEY,
	MaHangSX char(10) FOREIGN KEY (MaHangSX) REFERENCES HangSX(MaHangSX) ON UPDATE CASCADE ON DELETE CASCADE,
	TenSP nvarchar(30) NOT NULL,
	SoLuong int NOT NULL,
	MauSac nvarchar(10) NOT NULL,
	GiaBan money,
	DonViTinh nvarchar(20),
	MoTa nvarchar(30)
)

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

INSERT INTO HangSX VALUES ('HSX01', N'Hải Hà', N'Hồ Chí Minh', '12345678', 'hh@gmail.com'),
							('HSX02', N'Hải Châu', N'Hà Nội', '123456789', 'hc@gmail.com'),
							('HSX03', N'Tiền Phong', DEFAULT, '0123456789', 'tp@gmail.com'),
							('HSX04', N'Phong Phú', N'Hải Phòng', '0987654321', 'pp@gmail.com')
SELECT * FROM HangSX

INSERT INTO SanPham VALUES('SP01', 'HSX01', N'Kẹo Dẻo', 20, 2000, N'Kẹo cho trẻ em', N'Đỏ', N'Gói'),
							('SP02', 'HSX02', N'Kẹo Kéo', 30, 20000, N'Kẹo cho trẻ em', N'Trắng', N'Chiếc'),
							('SP01', 'HSX02', N'Kẹo Dừa', 15, 10000, N'Kẹo cho trẻ em', N'Xanh Ngọc', N'Túi'),
							('SP02', 'HSX01', N'Kẹo Lạc', 10, 20000, N'Kẹo cho trẻ em', N'Nâu', N'Chiếc')

SELECT * FROM SanPham

INSERT INTO PNhap VALUES ('HDN01', '2022/03/15', 'NV03'),
						('HDN02', '2022/03/15', 'NV01'),
						('HDN03', '2022/03/15', 'NV02'),
						('HDN04', '2022/03/15', 'NV04'),
						('HDN04', '2022/03/15', 'NV04')
SELECT * FROM PNhap

INSERT INTO Nhap VALUES ('HDN01', 'SP01', 3, 5000),
						('HDN02', 'SP02', 2, 2000),
						('HDN01', 'SP03', 4, 4000),
						('HDN02', 'SP04', 5, 3000)

SELECT * FROM Nhap


--Bài 1:

--a, Đưa ra các thông tin về các hóa đơn mã hàng  Samsung đã nhập trong năm 2022, gồm: SoHDN, MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong.
SELECT Nhap.SoHDN, SanPham.MaSP, TenSP, SoLuongN, DonGiaN, NgayNhap, TenNV, TenPhong
FROM SanPham INNER JOIN Nhap
ON SanPham.MaSP = Nhap.MaSP
INNER JOIN PNhap
ON Nhap.SoHDN = PNhap.SoHDN
INNER JOIN NhanVien
ON NhanVien.MaNV = PNhap.MaNV
INNER JOIN HangSX
ON HangSX.MaHangSX = SanPham.MaHangSX
WHERE TenHang = 'Samsung' AND YEAR(NgayNhap) = 2020

--b,Đưa ra Top 10 hóa đơn xuất có số lượng xuất nhiều nhất trong năm 2020, sắp xếp theo chiều giảm dần của SoLuongX.
SELECT TOP 10 Xuat.SoHDX, SoLuongX,  NgayXuat
FROM Xuat INNER JOIN PXuat
ON Xuat.SoHDX = PXuat.SoHDX
WHERE YEAR(NgayXuat) = 2020
ORDER BY SoLuongX

--c,Đưa ra thông tin 10 sản phẩm có giá bán cao nhất trong cữa hàng, theo chiều giảm dần giá bán.SELECT TOP 10 *FROM SanPhamORDER BY GiaBan DESC--d. Đưa ra các thông tin sản phẩm có giá bán từ 100.000 đến 500.000 của hãng Samsung. SELECT * FROM SanPham INNER JOIN HangSX ON SanPham.MaHangSX = HangSX.MaHangSXWHERE GiaBan >= 100000 AND GiaBan <= 500000 AND TenHang = 'Samsung'--e. Tính tổng tiền đã nhập trong năm 2020 của hãng Samsung. SELECT SUM(SoLuongN * DonGiaN) AS 'Tong tien nhap'FROM SanPham INNER JOIN NhapON SanPham.MaSP = Nhap.MaSPINNER JOIN HangSXON HangSX.MaHangSX = SanPham.MaHangSXINNER JOIN PNhapON PNhap.SoHDN = Nhap.SoHDNWHERE TenHang = 'Samsung' AND YEAR(NgayNhap) = 2020--f,Thống kê tổng tiền đã xuất trong ngày 14/06/2020.SELECT SUM(SoLuongX * GiaBan) AS N'Tong tien xuat'FROM Xuat INNER JOIN PXuatON Xuat.SoHDX = PXuat.SoHDXINNER JOIN SanPhamON SanPham.MaHangSX = Xuat.MaSPWHERE NgayXuat = '2020-06-14'--g, Đưa ra SoHDN, NgayNhap có tiền nhập phải trả cao nhất trong năm 2020.SELECT Nhap.SoHDN, NgayNHap FROM Nhap INNER JOIN PNhapON Nhap.SoHDN = PNhap.SoHDNWHERE YEAR(NgayNhap) = 2020 AND SoLuongN * DonGiaN = (SELECT MAX(SoLuongN * DonGiaN)														FROM Nhap INNER JOIN PNhap														ON Nhap.SoHDN = PNhap.SoHDN														WHERE YEAR(NgayNhap) = 2020													)--Bài 2,--a, Hãy thống kê xem mỗi hãng sản xuất có bao nhiêu loại sản phẩmSELECT SanPham.MaHangSX, TenHang, COUNT(*) AS N'Số lượng sản phẩm'FROM SanPham INNER JOIN HangSXON SanPham.MaHangSX = HangSX.MaHangSXGROUP BY SanPham.MaHangSX, TenHang--b. Hãy thống kê xem tổng tiền nhập của mỗi sản phẩm trong năm 2020.SELECT SanPham.MaSP,TenSP, SUM(SoLuongN * DonGiaN) AS N'Tổng tiền nhập'
FROM Nhap INNER JOIN SanPham ON Nhap.MaSP = SanPham.MaSP
INNER JOIN PNhap ON PNhap.SoHDN=Nhap.SoHDN
Where YEAR(NgayNhap) = 2020
Group BY SanPham.MaSP,TenSP

--c. Hãy thống kê các sản phẩm có tổng số lượng xuất năm 2020 là lớn hơn 10.000 sản phẩm của hãng Samsung.

SELECT SanPham.MaSP,TenSP,SUM(SoLuongX) AS N'Tổng xuất'
FROM Xuat INNER JOIN SanPham ON 
Xuat.MaSP = SanPham.MaSP
INNER JOIN HangSX ON HangSX.MaHangSX = SanPham.MaHangSX
INNER JOIN PXuat ON Xuat.SoHDX=PXuat.SoHDX
WHERE YEAR(NgayXuat)=2018 AND TenHang = 'Samsung'
GROUP BY SanPham.MaSP,TenSP
HAVING SUM(SoLuongX) >=10000

--d. Thống kê số lượng nhân viên Nam của mỗi phòng ban.

SELECT COUNT(MaNV) AS N'Số lượng nhân viên nam mỗi phòng ban'
FROM NhanVien
WHERE GioiTinh = 1
GROUP BY TenPhong
 --e, Thống kê tổng số lượng nhập của mỗi hãng sản xuất trong năm 2018.
