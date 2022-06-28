CREATE DATABASE QLBanHang

CREATE TABLE CongTy(
	MaCT nvarchar(10) PRIMARY KEY,
	TenCT nvarchar(30) NOT NULL,
	TrangThai bit NOT NULL,
	ThanhPho nvarchar(20) NOT NULL
)

CREATE TABLE SanPham(
	MaSP nvarchar(10),
	TenSP nvarchar(20) NOT NULL,
	MauSac nvarchar(10) DEFAULT 'Do',
	SoluongCo int NOT NULL,
	CONSTRAINT pk_SanPham PRIMARY KEY (TenSP, MaSP)
)

CREATE TABLE CungUng(
	MaCT nvarchar(10) NOT NULL,
	MaSP nvarchar(10) NOT NULL,
	SoluongBan int NOT NULL CHECK(SoluongBan > 0)
	CONSTRAINT pk_CungUng PRIMARY KEY (MaCT, MaSP)
)

INSERT INTO CongTy VALUES('CT01', 'Cong ty 1', 0, 'Ha Noi')
INSERT INTO CongTy VALUES('CT02', 'Cong ty 2', 1, 'Nam Dinh')
INSERT INTO CongTy VALUES('CT03', 'Cong ty 3', 0, 'Bac Ninh')

INSERT INTO SanPham VALUES('SP01', 'San pham 1', 'xanh', 10)
INSERT INTO SanPham VALUES('SP02', 'San pham 2', 'vang', 11)
INSERT INTO SanPham(MaSP, TenSP, SoluongCo) VALUES('SP03', 'San pham 3', 10)

INSERT INTO CungUng VALUES('CT01', 'SP01', 1)
INSERT INTO CungUng VALUES('CT02', 'SP02', 2)
INSERT INTO CungUng VALUES('CT03', 'SP03', 3)
INSERT INTO CungUng VALUES('CT04', 'SP04', 4)
INSERT INTO CungUng VALUES('CT05', 'SP05', 5)
INSERT INTO CungUng VALUES('CT06', 'SP06', 6)

SELECT * FROM CongTy
SELECT * FROM SanPham
SELECT * FROM CungUng