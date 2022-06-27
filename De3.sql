create database QLBenhVien
go 
use QLBenhVien
go

create table BenhVien(
	MaBV char(6) primary key,
	TenBV nvarchar(40) not null
)
create table KhoaKham(
	MaKhoa char(6) primary key,
	TenKhoa nvarchar(40) not null,
	SoBenhNhan int,
	MaBV char(6) not null,
	constraint pk_KhoaKham_MaBV foreign key(MaBV) references BenhVien(MaBV) on delete cascade on update cascade
)

create table BenhNhan(
	MaBN char(6) primary key,
	HoTen nvarchar(30) not null,
	GioiTinh bit,
	SoNgayNV int not null,
	MaKhoa char(6) not null
	constraint pk_BenhNhan_MaKhoa foreign key(MaKhoa) references KhoaKham(MaKhoa) on delete cascade on update cascade
)

insert into BenhVien values('BV01', N'Bệnh viện 1'),
							('BV02', N'Bệnh viện 2'),
							('BV03', N'Bệnh viện 3'),
							('BV04', N'Bệnh viện 4')

insert into KhoaKham values('Khoa01', N'Khoa chinh hinh', 10, 'BV01'),
							('Khoa02', N'Khoa phuc hoi', 30, 'BV02'),
							('Khoa03', N'Khoa da lieu', 20, 'BV03'),
							('Khoa04', N'Khoa xuong khop', 50, 'BV04'),
							('Khoa05', N'Khoa san', 100, 'BV01')

insert into BenhNhan values('BN01', N'Tran Van A', 1, 10, 'Khoa01'),
							('BN02', N'Tran Thi B', 0, 13, 'Khoa02'),
							('BN03', N'Tran Van C', 1, 15, 'Khoa03'),
							('BN04', N'Tran Thi D', 0, 20, 'Khoa04')

select * from BenhNhan
select * from BenhVien
select * from KhoaKham


--Câu 2: Tạo hàm đưa ra số bệnh nhân có giới tính do người dùng nhập vào
create function hienthi(@gioiTinh bit)
returns @bang table(TenBV nvarchar(40), TongSoBN int)
as
begin
	insert into @bang
	select TenBV, count(BenhNhan.MaBN) as N'Tong so benh nhan'
	from BenhVien inner join KhoaKham
	on BenhVien.MaBV = KhoaKham.MaBV
	inner join BenhNhan
	on BenhNhan.MaKhoa = KhoaKham.MaKhoa
	where GioiTinh = @gioiTinh
	group by TenBV
	return 
end

select * from hienthi(1)

--Câu 3: Tọa thủ tục in ra số bệnh nhân của một khoa với dl đầu vào là tên khoa và tên bệnh viện
create proc tongSoBN(@tenKhoa nvarchar(40), @tenBenhVien nvarchar(40))
as
begin
	if(not exists(select * from BenhVien inner join KhoaKham
								on KhoaKham.MaBV = BenhVien.MaBV
								where TenKhoa = @tenKhoa and TenBV = @tenBenhVien))
		begin
			declare @notification nvarchar(100)
			set @notification = N'Không có ' + @tenKhoa + N' hoặc bệnh viện ' + @tenBenhVien
			raiserror(@notification, 16, 1)
			rollback tran
		end
	else
		begin
			select sum(SoBenhNhan) as N'Tổng số bệnh nhân'
			from BenhVien inner join KhoaKham
			on KhoaKham.MaBV = BenhVien.MaBV
			where TenKhoa = @tenKhoa and TenBV = @tenBenhVien
		end
end

exec tongSoBN N'Khoa chinh hinh', N'Bệnh viện 1'

--Câu 4: Tạo trigger để tự động tăng số bệnh nhân trong bảng KhoaKham, mỗi khi thêm dl cho bảng Bệnh Nhân, sobenhnhan > 100 ko cho thêm va đưa ra cảnh báo(chứa tên khoa, tên bệnh viện

create trigger tangSoBN
on BenhNhan
for insert
as
begin
	declare @soBNTrongKhoa int =(select SoBenhNhan from KhoaKham inner join inserted on KhoaKham.MaKhoa = inserted.MaKhoa)
	if(@soBNTrongKhoa > 100)
		begin
			declare @tenKhoa nvarchar(40) = (select TenKhoa from KhoaKham inner join inserted on KhoaKham.MaKhoa = inserted.MaKhoa)
			declare @tenBV nvarchar(40) = (select TenBV from BenhVien inner join KhoaKham on BenhVien.MaBV = KhoaKham.MaBV where TenKhoa = @tenKhoa)
			declare @notification nvarchar(100)
			set @notification = N'Không thể thêm vào bệnh viện: ' + @tenBV + N' của khoa: ' + @tenKhoa
			raiserror(@notification, 16, 1)
			rollback tran
		end
	else
		begin
			update KhoaKham
			set SoBenhNhan = SoBenhNhan + 1
			where KhoaKham.MaKhoa = (select MaKhoa from inserted)
		end
end

INSERT INTO BenhNhan VALUES ('BN05', N'Tran Thi D', 0, 5, 'Khoa01')
SELECT * FROM KhoaKham
SELECT * FROM BenhNhan