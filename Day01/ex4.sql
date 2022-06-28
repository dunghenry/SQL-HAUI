CREATE DATABASE SinhVien
CREATE TABLE DiemTotNghiep(
	HoTen nvarchar(30) NOT NULL,
	NgaySinh datetime,
	DiemVan decimal(4,2)
	CONSTRAINT chk_DiemVan
	CHECK(DiemVan >= 0 AND DiemVan <= 10),
	DiemToan decimal(4,2)
	CONSTRAINT chk_DiemToan
	CHECK(DiemToan >= 0 AND DiemToan <= 10)
)

INSERT INTO DiemTotNghiep VALUES('Tran Van Dung', '1/1/75', 5, 10)

SELECT * FROM DiemTotNghiep