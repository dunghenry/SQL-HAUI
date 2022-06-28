CREATE TABLE NhanVien(
	MaNV char(10) PRIMARY KEY,
	HoTen nvarchar(50) NOT NULL,
	NgaySinh datetime,
	DienThoai nvarchar(10),
	HSLuong decimal(3,2) DEFAULT(1.92)
)

INSERT INTO NhanVien VALUES('NV01', 'Le Van A', '2/4/75', '12345678', 2.14)
INSERT INTO NhanVien(MaNV, HoTen) VALUES('NV02', 'Mai Thi B')
INSERT INTO NhanVien(MaNV, HoTen, DienThoai) VALUES('NV03', 'Tran Thi C', '0346588890')

SELECT * FROM NhanVien
