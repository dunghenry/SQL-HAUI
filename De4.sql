create database QLBV
go

use QLBV
go

create table BenhVien(
	MaBV char(6) primary key,
	TenBV nvarchar(30) not null,
	DiaChi nvarchar(30) not null
)

create table KhoaKham(
	MaKhoa char(6) primary key,
	TenKhoa nvarchar(30) not null,
	SoBenhNhan  int,
	MaBV char(6) not null,
	constraint pk_KhoaKham_MaBV foreign key(MaBV) references BenhVien(MaBV) on update cascade on delete cascade
)

create table BenhNhan(
	MaBN char(6) primary key,
	HoTen nvarchar(30) not null,
	GioiTinh bit,
	SoNgayNV int,
	MaKhoa char(6) not null,
	constraint pk_BenhNhan_MaKhoa foreign key(MaKhoa) references KhoaKham(MaKhoa) on update cascade on delete cascade
)

insert into BenhVien values('BV01', N'Bệnh viện 01', N'Hà Nội'),
							('BV02', N'Bệnh viện 02', N'Ninh Bình'),
							('BV03', N'Bệnh viện 03', N'Nam Định')


insert into KhoaKham values('K01', N'Khoa hồi sức', 10, 'BV01'),
							('K02', N'Khoa da liễu', 12, 'BV02'),
							('K03', N'Khoa chỉnh hình', 25, 'BV03')

insert into BenhNhan values ('BN01', N'Trần Văn A', 1, 5, 'K01'),
							('BN02', N'Trần Thị B', 0, 7, 'K02'),
							('BN03', N'Trần Văn C', 1, 10, 'K03'),
							('BN04', N'Trần Thị D', 0, 15, 'K01'),
							('BN05', N'Trần Văn E', 1, 20, 'K02')


select * from BenhNhan
select * from BenhVien
select * from KhoaKham

--Tạo view đưa ra thống kê số bệnh nhân nữ của từng khoa khám gồm các thông tin tên bệnh viện, tên khoa, số bệnh nhân

create view vw_DS
as
select TenBV, TenKhoa, KhoaKham.MaKhoa, count(MaBN) as N'So benh nhan nu'
from BenhVien inner join KhoaKham
on BenhVien.MaBV = KhoaKham.MaBV
inner join BenhNhan
on BenhNhan.MaKhoa = KhoaKham.MaKhoa
where GioiTinh = 0
group by TenBV, KhoaKham.MaKhoa, TenKhoa


select * from vw_DS

--Tạo hàm đưa ra tổng tiền thu đc của 1 khoa khám bệnh trong bệnh viện là bao nhiêu.Với tham số đầu vào là tên bệnh viện, tên khoa.Tiền nằm viện là 100k 1 người 1 ngày
create function tinhTien(@tenBV nvarchar(30), @tenKhoa nvarchar(30))
returns money
as
begin
	declare @tongTien money
	select @tongTien = (select sum(SoNgayNV * 100000)
						from BenhVien inner join KhoaKham
						on BenhVien.MaBV = KhoaKham.MaBV
						inner join BenhNhan
						on BenhNhan.MaKhoa = KhoaKham.MaKhoa
						where TenBV = @tenBV and TenKhoa = @tenKhoa
						)
	return @tongTien
end

select dbo.tinhTien(N'Bệnh viện 01', N'Khoa hồi sức') as N'Tổng tiền'


--Câu 4:

create trigger chuyenKhoa
on BenhNhan
for update
as
begin
	declare @soBenhNhanKhoaMoi int
	select @soBenhNhanKhoaMoi = (select SoBenhNhan from KhoaKham inner join inserted on KhoaKham.MaKhoa = inserted.MaKhoa)
	if(@soBenhNhanKhoaMoi >= 100)
		begin
			raiserror(N'Khong the chuyen khoa', 16, 1)
			rollback tran
		end
	else
		begin
			update KhoaKham
			set SoBenhNhan = SoBenhNhan - 1
			where MaKhoa = (select MaKhoa from deleted)
			update KhoaKham
			set SoBenhNhan = SoBenhNhan + 1
			where MaKhoa = (select MaKhoa from inserted)
		end
end

select * from KhoaKham
select * from BenhNhan

update BenhNhan 
set MaKhoa = 'K02'
where MaBN = 'BN01'
select * from KhoaKham
select * from BenhNhan