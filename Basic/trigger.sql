USE QLBANHANG
/*1. Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng nhập, hãy kiểm tra các ràng buộc toàn vẹn: 
MaSP có trong bảng sản phẩm chưa? Kiểm tra các ràng buộc dữ liệu: SoLuongN và DonGiaN>0? 
Sau khi nhập thì SoLuong ở bảng SanPham sẽ được cập nhật theo*/
CREATE TRIGGER TG_NHAP
ON Nhap
FOR INSERT
AS
DECLARE @maSP char(10), @soLuongNhap int, @donGiaNhap money
SELECT @maSP=MaSP, @soLuongNhap=SoLuongN, @donGiaNhap=DonGiaN
FROM inserted
IF NOT EXISTS(SELECT * FROM SanPham WHERE MaSP=@maSP)
BEGIN
	PRINT N'KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM'
	ROLLBACK TRANSACTION
END
ELSE
	IF(@soLuongNhap<=0 OR @donGiaNhap<=0)
	BEGIN
		PRINT N'SỐ LƯỢNG NHẬP VÀ ĐƠN GIÁ NHẬP PHẢI LỚN HƠN 0'
		ROLLBACK TRANSACTION
	END
	ELSE 
	UPDATE SanPham
	SET SoLuong=SoLuong+@soLuongNhap
	WHERE MaSP=@maSP
--THỰC THI 
--TH1: KHÔNG CÓ MASP TRONG BẢNG SP
ALTER TABLE NHAP NOCHECK CONSTRAINT ALL
INSERT INTO Nhap VALUES('PN01','SP10',20,2000)
--TH2: SỐ LƯỢNG NHẬP <=0
INSERT INTO Nhap VALUES('PN01','SP03',0,2000)
--TH3: ĐƠN GIÁ NHẬP <=0
INSERT INTO Nhap VALUES('PN01','SP03',20,0)
--TH4: CHÈN THÀNH CÔNG
SELECT * FROM Nhap
SELECT * FROM SanPham
INSERT INTO Nhap VALUES('PN01','SP03',20,20000)
SELECT * FROM Nhap
SELECT * FROM SanPham
/*2. Tạo Trigger kiểm soát việc nhập dữ liệu cho bảng xuất, hãy kiểm tra các ràng buộc 
toàn vẹn: MaSP có trong bảng sản phẩm chưa? 
kiểm tra các ràng buộc dữ liệu: SoLuongX <= SoLuong trong bảng SanPham? 
Sau khi xuất thì SoLuong ở bảng SanPham sẽ được cập nhật theo*/
CREATE TRIGGER TG_CHENDLXUAT
ON Xuat
FOR INSERT
AS
IF NOT EXISTS(SELECT * FROM SanPham INNER JOIN inserted ON SanPham.MaSP= inserted.MaSP)
BEGIN
	RAISERROR(N'KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM',16,1)
	ROLLBACK TRANSACTION
END
ELSE
	IF EXISTS(SELECT * FROM SanPham INNER JOIN inserted ON
					SanPham.MaSP= inserted.MaSP
					WHERE inserted.SoLuongX > SanPham.SoLuong)
	BEGIN
		RAISERROR(N'SỐ LƯỢNG XUẤT PHẢI NHỎ HƠN SỐ LƯỢNG SẢN PHẨM CÓ TRONG KHO',16,1)
		ROLLBACK TRANSACTION
	END
	ELSE
	UPDATE SanPham
	SET SoLuong=SoLuong - inserted.SoLuongX
	FROM SanPham INNER JOIN inserted 
	ON SanPham.MaSP=inserted.MaSP
--THỰC THI TRIGGER
--TH1: KHÔNG CÓ SẢN PHẨM TRONG BẢNG SẢN PHẨM
ALTER TABLE XUAT NOCHECK CONSTRAINT ALL
INSERT INTO Xuat VALUES('HDX01','SP10',10)
--TH2: SỐ LƯỢNG XUẤT LỚN HƠN SỐ LƯỢNG CÓ TRONG SẢN PHẨM
INSERT INTO Xuat VALUES('HDX02','SP02',30)
--TH3: SỐ LƯỢNG XUẤT NHỎ HƠN SỐ LƯỢNG CÓ TRONG SẢN PHẨM
SELECT * FROM XUAT
SELECT * FROM SANPHAM
INSERT INTO Xuat VALUES('HDX02','SP02',5)
SELECT * FROM XUAT
SELECT * FROM SANPHAM
/*3. Tạo Trigger kiểm soát việc xóa dòng dữ liệu bảng xuất, 
khi một dòng bảng xuất xóa thì số lượng hàng trong bảng SanPham
sẽ được cập nhật tăng lên*/
CREATE TRIGGER TG_XOAXUAT
ON XUAT
FOR DELETE
AS
UPDATE SanPham
SET SoLuong=SoLuong + deleted.SoLuongX
FROM SanPham INNER JOIN deleted
ON SanPham.MaSP=deleted.MaSP
--THỰC THI TRIGGER
SELECT * FROM XUAT
SELECT * FROM SANPHAM
DELETE FROM Xuat 
WHERE SoHDX='HDX01' AND MaSP='SP01'
SELECT * FROM XUAT
SELECT * FROM SANPHAM
/*4. Tạo Trigger cho việc cập nhật lại số lượng xuất trong bảng xuất, 
nếu số bản ghi thay đổi lớn hơn 1 thì thông báo ko được thay đổi.
không được chỉnh sửa cột SoHDX và cột MaSP, chỉ được chỉnh sửa cột số lượng
hãy kiểm tra xem số lượng xuất thay đổi có nhỏ hơn 
SoLuong trong bảng SanPham hay ko?
nếu thỏa mãn thì cho phép Update bảng xuất và Update lại SoLuong trong bảng SanPham*/
CREATE TRIGGER TG_SUASOlUONGXUAT
ON XUAT
FOR UPDATE
AS
DECLARE @soLuongXuatMoi int, @soLuongXuatCu int, @soLuongCo int, @maSP char(10)
IF(@@ROWCOUNT>1)
BEGIN
	RAISERROR (N'KHÔNG ĐƯỢC SỬA NHIỀU HƠN 1 BẢN GHI', 16,1)
	ROLLBACK TRANSACTION
END
SELECT @soLuongXuatMoi=SoLuongX, @maSP=MaSP FROM inserted
SELECT @soLuongXuatCu=SoLuongX FROM deleted
SELECT @soLuongCo=SoLuong FROM SanPham WHERE MaSP=@maSP
IF( UPDATE(SoHDX) OR UPDATE(MaSP))
BEGIN
	RAISERROR(N'KHÔNG CHỈNH SỬA DỮ LIỆU Ở CỘT SỐ HÓA ĐƠN VÀ MÃ SẢN PHẨM',16,1)
	ROLLBACK TRANSACTION
END
ELSE
	IF(@soLuongCo<(@soLuongXuatMoi-@soLuongXuatCu))
	BEGIN
		RAISERROR(N'KHÔNG ĐỦ SỐ LƯỢNG ĐỂ CẬP NHẬT',16,1)
		ROLLBACK TRANSACTION
	END
	ELSE
	UPDATE SanPham
	SET SoLuong=SoLuong-(@soLuongXuatMoi-@soLuongXuatCu)
	WHERE MaSP=@maSP
--THỰC THI TRIGGER
--TH1: CẬP NHẬT NHIỀU HƠN 1 DÒNG
UPDATE Xuat SET SoLuongX=8
--TH2: CẬP NHẬT CỘT SOHDX
UPDATE Xuat SET SoHDX='HDXO2'
WHERE SoHDX='HDX01'
--TH3: CẬP NHẬT CỘT MASP
UPDATE Xuat SET MaSP='SP01'
WHERE SoHDX='HDX01'
--TH4: CẬP NHẬT SỐ LƯỢNG VƯỢT QUÁ SỐ LƯỢNG CÓ TRONG CSDL
UPDATE Xuat SET SoLuongX=100
WHERE SoHDX='HDX01'
--TH5: CẬP NHẬT THÀNH CÔNG
SELECT * FROM SanPham
SELECT * FROM Xuat
UPDATE Xuat SET SoLuongX=10
WHERE SoHDX='HDX01' AND MaSP='SP02'
SELECT * FROM SanPham
SELECT * FROM Xuat