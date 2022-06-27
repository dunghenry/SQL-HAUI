create database QLSinhVien
go

use QLSinhVien
go

create table Khoa(
	MaKhoa char(6) primary key,
	TenKhoa nvarchar(30) not null
)
go

create table Lop(
	MaLop char(6) primary key,
	TenLop nvarchar(30) not null,
	SiSo int,
	MaKhoa char(6) not null,
	constraint pk_Lop_MaKhoa foreign key(MaKhoa) references Khoa(MaKhoa) on update cascade on delete cascade
)
go

create table SinhVien(
	MaSV char(60) primary key,
	HoTen nvarchar(30) not null,
	NgaySinh date not null,
	GioiTinh bit not null,
	MaLop char(6) not null
	constraint pk_SinhVien_MaLop foreign key(MaLop) references Lop(MaLop) on update cascade on delete cascade
)
go

insert into Khoa values('K01', 'Khoa 1'),
						('K02', 'Khoa 2'),
						('K03', 'Khoa 3')

insert into Lop values('L01', N'Lop 1', 20, 'K01'),
('L02', N'Lop 2', 25, 'K02'),
('L03', N'Lop 3', 30, 'K03')

insert into SinhVien values('SV01', N'Tran Van A','2001-1-1', 1, 'L01'),
('SV02', N'Tran Thi B','2000-5-10', 0, 'L02'),
('SV03', N'Tran Van C','2005-10-1', 1, 'L03'),
('SV04', N'Tran Thi D','1999-12-15', 0, 'L01'),
('SV05', N'Tran Van F','1990-8-20', 1, 'L02')

select * from Khoa
select * from Lop
select * from SinhVien
--Cau2: Viet ham dua ra danh sach it tuoi nhat cua mot khoa nao do vs ten khoa nhap vaof tu ban phim

alter function fn_DanhSach(@tenKhoa nvarchar(30))
returns @table table(MaSV char(6), HoTen nvarchar(30), NgaySinh date, Tuoi date )
as
begin
	insert into @table
	select MaSV, HoTen, NgaySinh, format(NgaySinh,'dd/MM/yyyy') as Tuoi
	from Khoa inner join Lop
	on Khoa.MaKhoa = Lop.MaKhoa
	inner join SinhVien
	on Lop.MaKhoa = SinhVien.MaLop
	where TenKhoa = @tenKhoa and year(NgaySinh) = (select max(year(NgaySinh))
													from SinhVien innser join Lop
													on SinhVien.MaLop = Lop.MaLop
													inner join Khoa
													on Khoa.MaKhoa = Lop.MaKhoa
													where TenKhoa = @tenKhoa
													)
	
	return
end

select * from dbo.fn_DanhSach('Khoa 2')




--Cau3 Thu tuc tim kiem sinh vien theo khoang tuoi vs 2 tham so la tu bao nhieu den bao nhieu

create proc pr_timkiem(@tuTuoi int, @denTuoi int)
as
begin
	select MaSV, HoTen, TenKhoa, year(getdate()) - year(NgaySinh) as N'Tuoi'
	from SinhVien inner join Lop
	on SinhVien.MaLop = Lop.MaLop
	inner join Khoa
	on Khoa.MaKhoa = Lop.MaKhoa
	where year(getdate()) - year(NgaySinh) between @tuTuoi and @denTuoi
end

exec pr_timkiem 10, 25

--Cau4: tao trigger khi them hoac xoa sinh vien thi cap nhat si so sv trong bang lop tuong ung, neu si so > 80	 thi ko cho phep them va dua ra thong bao
create trigger tg_themHoacXoaSV
on SinhVien
for delete, insert
as
begin	
	declare @action char(1)
	set @action = (case when exists(select * from inserted) then 'I'
					when exists (select * from deleted) then 'D'
					end)
	if(@action = 'D')
		begin
			update Lop
			set SiSo = SiSo - 1
			where MaLop = (select MaLop from deleted)
		end
	else
		begin
			declare @siSo int
			set @siSo = (select SiSo from Lop inner join inserted on Lop.MaLop = inserted.MaLop)
			if(@siSo > 80)
				begin
					declare @lop nvarchar(30)
					set @lop = (select TenLop from Lop inner join inserted on Lop.MaLop = inserted.MaLop)
					declare @notification nvarchar(100)
					set @notification = N'Không thể thêm sinh viên vào lớp ' + @lop
					raiserror(@notification, 16, 1)
					rollback tran
				end
			else
				begin
					update Lop
					set SiSo = SiSo + 1
					where MaLop = (select MaLop from inserted)
				end
		end
end