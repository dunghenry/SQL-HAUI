create database QLHang
go

use QLHang
go

create table Hang(
	MaHang char(6) primary key,
	TenHang nvarchar(30) not null,
	DVTinh nvarchar(20) not null,
	SLTon int
)


create table HDBan(
	MaHD char(6) primary key,
	NgayBan date,
	HoTenKhachHang nvarchar(30) not null,
)

create table HangBan(
	MaHD char(6) not null,
	MaHang char(6) not null,
	DonGia int,
	SoLuong int,
	constraint fk_HangBan primary key(MaHD, MaHang)
)

insert into Hang values('H01', N'Kẹo dẻo', N'Chiếc', 100),
						('H02', N'Sữa chua', N'Hộp', 20),
						('H03', N'Bút bi', N'Chiếc', 50)

insert into HDBan values('HD01', '2021-1-1', N'Trần Văn A'),
						('HD02', '2022-5-5', N'Trần Văn B'),
						('HD03', '2021-1-1', N'Trần Văn C')


insert into HangBan values('HD01', 'H01', 1000, 5),
('HD02', 'H02', 5000, 10),
('HD03', 'H03', 2000, 11)


select * from Hang
select * from HangBan
select * from HDBan

--Cau2
create function fn_DS(@thang int, @nam int)
returns @bang table(MaHD char(6), NgayBan date, TongTien int)
as
begin
	insert into @bang
	select HDBan.MaHD, NgayBan, sum(SoLuong * DonGia) as TongTien
	from HDBan inner join HangBan
	on HDBan.MaHD = HangBan.MaHD
	where YEAR(NgayBan) = @nam and MONTH(NgayBan) = @thang and  sum(SoLuong * DonGia) > 500
	GROUP BY HDBan.MaHD, NgayBan
	return
end

--Cau 3:

create proc pr_themHangBan(@maHD char(6),@tenHang nvarchar(30), @donGia int, @soLuong int)
as
begin
	if(not exists(select * from Hang where TenHang = @tenHang))
		begin
			print N'Không có tên hàng này'
			return 0
		end
	if(not exists (select * from HDBan where MaHD = @maHD))
		begin
			print N'Không có hóa đơn này'
			return 0
		end
	declare @maHang char(6) = (select MaHang from Hang where TenHang = @tenHang)
	insert into HangBan values(@maHD, @maHang, @donGia, @soLuong)
	return 1
end

--cau4
create trigger tr_capNhat
on HangBan
for update
as
begin
	declare @slMoi int  = (select SoLuong from inserted)
	declare @slCu int  = (select SoLuong from deleted)
	declare @slTon int  = (select SLTon from Hang inner join inserted on Hang.MaHang = inserted.MaHang)
	declare @slChenhLech int = @slMoi - @slCu
	if(@slChenhLech > @slTon)
		begin
			raiserror(N'Không thể cập nhập vì số lượng tồn không đủ', 16, 1)
			rollback tran
		end
	else
		begin
			update Hang 
			set SLTon = SLTon - @slChenhLech
			where MaHang = (select MaHang from inserted)
		end
end