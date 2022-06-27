create database QLHANG
go

use QLHANG
go

create table Hang(
	MaHang nchar(6) primary key,
	TenHang nvarchar(40) not null,
	DonViTinh nchar(10) not null,
	SLTon int not null
)

create table HDBan(
	MaHD char(6) primary key,
	NgayBan datetime,
	HoTenKhach nvarchar(50) not null,
)

create table HangBan(
	MaHD char(6) not null,
	MaHang char(6) not null,
	DonGia float,
	SoLuong int not null
	constraint fk_HangBan primary key(MaHD, MaHang)
)


insert into Hang values ('MH01', N'Kẹo dẻo', 'Gói', 100),
						('MH02', N'Nước giải khát sting', 'Chai', 10),
						('MH03', N'Áo thun nam', N'Chiếc', 50)

insert into HDBan values ('HD01', GETDATE(), N'Trần Văn A'),
						('HD02', GETDATE(), N'Trần Văn B')
drop table HDBan


insert into HangBan values ('HD01', 'MH01', 15000, 10),
							('HD02', 'MH02', 20000, 5),
							('HD01', 'MH03', 100000, 1),
							('HD02', 'MH01', 15000, 20)

select * from Hang
select * from HDBan
select * from HangBan

--Câu 2
alter view ThongKe
as
select HDBan.MaHD, HDBan.NgayBan, sum(HangBan.DonGia * HangBan.SoLuong) as Tong
from HDBan inner join HangBan
on HDBan.MaHD = HangBan.MaHD
inner join Hang
on Hang.MaHang = HangBan.MaHang
group by HDBan.MaHD, HDBan.NgayBan

select * from ThongKe


--Câu 3
--create function
create function fnc_NgayThu(@ngaythu int)
returns nvarchar(10)
as
begin
	declare @result as nvarchar(10) = ''
	if @ngaythu = 0
		return N'Chưa xác định được ngày'
	else if @ngaythu = 1
		set @result = N'Chủ nhật'
	else if @ngaythu = 2
		set @result = N'Thứ hai'
	else if @ngaythu = 3
		set @result = N'Thứ ba'
	else if @ngaythu = 4
		set @result = N'Thứ tư'
	else if @ngaythu = 5
		set @result = N'Thứ năm'
	else if @ngaythu = 6
		set @result = N'Thứ sáu'
	else if @ngaythu = 7
		set @result = N'Thứ bảy'
return @result
end
select dbo.fnc_NgayThu(1)

--Tìm kiếm hàng theo tháng và năm dùng thủ tục
create proc pr_timKiem(@thang int, @nam int)
as
begin
	if(not exists(select NgayBan from HDBan where MONTH(NgayBan) = @thang and year(NgayBan) = @nam))
		begin
			print N'Khong tồn tại sản phẩm'
			return
		end
	else
		begin
			select Hang.MaHang, Hang.TenHang, HDBan.NgayBan, HangBan.SoLuong,  dbo.fnc_NgayThu(DATEPART(dw, HDBan.NgayBan))  from Hang inner join  HangBan
			on Hang.MaHang = HangBan.MaHang
			inner join HDBan
			on HDBan.MaHD = HDBan.MaHD
			where MONTH(NgayBan) = @thang and year(NgayBan)=@nam
		end
			
end

--Thực thi proc
select * from HDBan
exec pr_timKiem 1, 2021

SELECT DATEPART(dw,GETDATE()) -- Lấy ra thứ 1 - 7

create trigger tg_insertHangBan
on HangBan
for insert
as
declare @MaHD char(6), @MaHang char(6), @DonGia float, @Soluong int
select @MaHD=MaHD, @MaHang=MaHang, @DonGia=DonGia, @Soluong = SoLuong
from inserted
if not exists(select * from HangBan where MaHang = @MaHang)
begin
	print N'KHÔNG TỒN TẠI MÃ HÀNG'
	rollback transaction
end
else
	if(@Soluong <= 0 OR @DonGia < =0)
	begin
		print N'SỐ LƯỢNG NHẬP VÀ ĐƠN GIÁ NHẬP PHẢI LỚN HƠN 0'
		rollback transaction
	end
	else 
	update Hang
	set SLTon= SLTon - @Soluong

insert into HangBan values ('HD05', 'MH01', 15000, 5)

select * from Hang
select * from HangBan
--Xóa HangBan cập nhật lại SLTon