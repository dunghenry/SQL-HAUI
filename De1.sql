create database QLSinhVien
go

use QLSinhVien
go

create table Khoa(
	MaKhoa char(6) primary key,
	TenKhoa nvarchar(30) not null,
	NgayThanhLap date not null,
)
go

create table Lop(
	MaLop char(6) primary key,
	TenLop nvarchar(20) not null,
	SiSo int not null,
	MaKhoa char(6) foreign key(MaKhoa) references Khoa(MaKhoa),
)
go

create table SinhVien(
	MaSV char(6) primary key,
	HoTen nvarchar(30) not null,
	NgaySinh date,
	MaLop char(6)
	constraint fk_Lop_SinhVien foreign key(MaLop) references Lop(MaLop)
)
go

--Chen dl
INSERT INTO Khoa (MaKhoa, TenKhoa, NgayThanhLap)
VALUES ('K01', N'Khoa 1', '2020-01-01')
INSERT INTO Khoa (MaKhoa, TenKhoa, NgayThanhLap)
VALUES ('K02', N'Khoa 2', '2019-01-01')
INSERT INTO Khoa (MaKhoa, TenKhoa, NgayThanhLap)
VALUES ('K03', N'Khoa 3', '2018-01-01')

INSERT INTO Lop VALUES 
('L01', N'Lớp 1', 20, 'K01'),
('L02', N'Lớp 2', 3, 'K01'),
('L03', N'Lớp 3', 10, 'K02')

INSERT INTO SinhVien VALUES 
('SV01', N'Sinh viên 1', '2001-01-01', 'L01'),
('SV02', N'Sinh viên 2', '2001-01-02', 'L01'),
('SV03', N'Sinh viên 3', '2001-01-03', 'L02'),
('SV04', N'Sinh viên 4', '2001-01-04', 'L02'),
('SV05', N'Sinh viên 5', '2001-01-05', 'L03')

select * from SinhVien
select * from Lop
select * from Khoa

--Tạo hàm đưa ra danh sách sinh viên gồm MaSV, HoTen, Tuoi, TenKhoa và TenLop nhập từ bàn phím
create function fnc_DSSV(@tenLop nvarchar(20))
returns @bang table(MaSV char(5), HoTen nvarchar(30), Tuoi int, TenKhoa nvarchar(30))
as
begin
	insert into @bang
	select MaSV, HoTen, (YEAR(GETDATE() - YEAR(NgaySinh))) Tuoi, TenKhoa
	from SinhVien inner join Lop
	on SinhVien.MaLop = Lop.MaLop
	inner join Khoa
	on Khoa.MaKhoa = Lop.MaKhoa
	where TenLop = @tenLop
	return
end

select * from fnc_DSSV(N'Lớp 2')

--Thủ tục đưa danh sách các lớp gồm mã lớp tên lớp, sĩ số trong khoa có sĩ số lớn hơn x
create proc pr_DSL(@tenKhoa nvarchar(30), @x int)
as
begin
	if not exists (select * from Khoa where TenKhoa = @tenKhoa)
		begin
			print N'Ten khoa khong ton tai'
		end
	else
		begin
			select MaLop, TenLop, SiSo
			from Khoa inner join Lop
			on Khoa.MaKhoa = Lop.MaKhoa
			where TenKhoa = @tenKhoa and SiSo > @x
		end
end

exec pr_DSL 'Khoa 10', 5

--Trigger khi xóa một dòng dl trong bảng sv, hãy kt mã sinh viên muốn xóa có trong bảng hay ko.Nếu ko có thì hiển thông báo và ngược lại cập nhật sĩ số trong bảng lớp
create trigger tg_deleteSV
on SinhVien
instead of delete
as
begin
	declare @maSV char(6)
	select @maSV = MaSV from deleted
	if(not exists(select * from SinhVien where MaSV = @maSV))
		begin
			raiserror(N'Không có mã sinh viên này', 16, 1)
			rollback tran
		end
	else
		begin
			delete from SinhVien 
			where MaSV = @maSV
			update Lop 
			set SiSo = SiSo - 1 
			where MaLop = (select MaLop from deleted)
		end
end

select * from SinhVien
select * from Lop

DELETE SinhVien WHERE MaSV = 'SV01'