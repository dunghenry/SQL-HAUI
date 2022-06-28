--Quản lý đề tài sinh viên
create database QuanLyDeTaiSinhVien
go

use QuanLyDeTaiSinhVien

go

create table SinhVien(
	MASV char(6) not null,
	TENSV nvarchar(30) not null,
	SODT varchar(10),
	LOP char(6) not null,
	DIACHI nvarchar(50) not null,
	constraint pk_SinhVien primary key(MASV)
)

go

create table DeTai(
	MADT char(6) not null,
	TENDT nvarchar(50) not null,
	constraint pk_DeTai primary key(MADT)
)

go

create table SinhVien_DeTai(
	MASV char(6) not null,
	MADT char(6) not null,
	NGAYBAOCAO datetime,
	constraint pk_SinhVien_DeTai primary key(MASV, MADT),
	constraint fk_sinhvien_SinhVien_DeTai foreign key (MASV) references SinhVien(MASV) on update cascade on delete cascade,
	constraint fk_detai_SinhVien_DeTai foreign key(MADT) references DeTai(MADT) on update cascade on delete cascade
)

--insert dl

insert into SinhVien(MASV, TENSV, SODT, LOP, DIACHI) values ('SV01', N'Nguyễn Văn A', '1234567890', 'CNTT01', N'Hà Nội')
insert into SinhVien(MASV, TENSV, SODT, LOP, DIACHI) values ('SV02', N'Nguyễn Văn B', '1234567890', 'KTPM02', N'Ninh Bình')

insert into DeTai values ('DT01', N'Đồ án tốt nghiệp'),
							('DT02', N'Đồ án cơ sở')

insert into SinhVien_DeTai(MASV, MADT) values ('SV01', 'DT01'),
									('SV01', 'DT02')
insert into SinhVien_DeTai(MASV, MADT) values('SV02', 'DT01'),
									('SV02', 'DT02')

insert into SinhVien_DeTai(MASV, MADT) values('SV02', null),
									('SV02', null)
--get dl

select * from SinhVien
select * from DeTai
select * from SinhVien_DeTai

select top 1 * from SinhVien

--Get date
select GETDATE()

--Đổi tên table SinhVien thanh SinhVien1
execute sp_rename N'dbo.SinhVien1', N'SinhVien', 'object'
go

--Thay đổi tên colunm
execute sp_rename N'dbo.SinhVien_DeTai.NGAYBAOCAO', N'NgayBaoCao', 'column'
go

--Thay đổi data type
alter table SinhVien_DeTai alter column NgayBaoCao time
go


--Thay đổi data type
alter table DeTai alter column TENDT nvarchar(50) null
go

--Thêm cột ghi chú vào table
alter table SinhVien_DeTai add GHICHU nvarchar(50) null
go

--Tạo khóa chính cho table
alter table SinhVien_DeTai add constraint pk_SinhVien_DeTai primary key(MASV, MADT)
go

--Tạo khóa ngoại cho table
alter table SinhVien_DeTai add constraint fk_sinhvien_SinhVien_DeTai foreign key(MASV) references SinhVien1(MASV)
go
alter table SinhVien_DeTai add constraint fk_Detai_SinhVien_DeTai foreign key(MADT) references DeTai(MADT)
go