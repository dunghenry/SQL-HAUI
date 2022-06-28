CREATE TABLE SinhVien(
	MaSV nvarchar(10) PRIMARY KEY,
	HoDem nvarchar(25) NOT NUll,
	Ten nvarchar(10) NOT NULL,
	NgaySinh datetime,
	GioiTinh bit,
	NoiSinh nvarchar(255),
	MaLop nvarchar(10)
)
CREATE TABLE DiemThi(
	MaMH nvarchar(10) NOT NULL,
	MaSV nvarchar(10) NOT NULL,
	DiemLan1 numeric(4,2),
	DiemLan2 numeric(4, 2),
	CONSTRAINT pk_DiemThi PRIMARY KEY(MaMH, MaSV)
)

