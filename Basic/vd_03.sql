CREATE DATABASE QLDETAI_SV
GO

USE QLDETAI_SV
GO

CREATE TABLE SINHVIEN(
 MASV CHAR(6) NOT NULL,
 TENSV NVARCHAR(30) NOT NULL,
 SODT VARCHAR(10),
 LOP CHAR(6) NOT NULL,
 DIACHI NVARCHAR(50) NOT NULL,
 CONSTRAINT pk_SINHVIEN PRIMARY KEY(MASV)
 )
 GO

 CREATE TABLE DETAI(
 MADT CHAR(6) NOT NULL,
 TENDT NVARCHAR(50)  NOT NULL
 CONSTRAINT pk_DETAI PRIMARY KEY(MADT)
 )
 GO 

CREATE TABLE SINHVIEN_DETAI(
 MASV CHAR(6) NOT NULL,
 MADT CHAR(6) NOT NULL,
 NGAYBAOCAO DATETIME,
 CONSTRAINT pk_SINHVIEN_DETAI PRIMARY KEY(MASV, MADT)
 )
GO

INSERT INTO SINHVIEN(MASV,TENSV,SODT,LOP,DIACHI) VALUES('SV0001',N'Nguyễn Văn A', '0909029530','DTH04',N'Bình Chánh')
INSERT INTO SINHVIEN(MASV,TENSV,SODT,LOP,DIACHI) VALUES('SV0002',N'Nguyễn Văn B', '0909029531','DTH04',N'Bình Chánh')
INSERT INTO SINHVIEN(MASV,TENSV,SODT,LOP,DIACHI) VALUES('SV0003',N'Nguyễn Văn C', '0909029531','DTH04',N'Bình Chánh')

INSERT INTO DETAI(MADT,TENDT) VALUES('DT0001',N'Đồ Án Cơ Sở')
INSERT INTO DETAI(MADT,TENDT) VALUES('DT0002',N'Đồ Án Tốt Nghiệp')


INSERT INTO SINHVIEN_DETAI(MASV,MADT) VALUES('SV0001',N'DT0001')
INSERT INTO SINHVIEN_DETAI(MASV,MADT) VALUES('SV0001',N'DT0002')

INSERT INTO SINHVIEN_DETAI(MASV,MADT) VALUES('SV0002',N'DT0001')
INSERT INTO SINHVIEN_DETAI(MASV,MADT) VALUES('SV0002',N'DT0002')

INSERT INTO SINHVIEN_DETAI(MASV,MADT,NGAYBAOCAO) VALUES('SV0003',N'DT0001',getdate())
INSERT INTO SINHVIEN_DETAI(MASV,MADT,NGAYBAOCAO) VALUES('SV0003',N'DT0002',getdate())

--Sửa mã sinh viên:nếu sinh viên đã báo cáo thì không thể sửa còn nếu sinh viên chưa báo cáo mới có thể sửa lại mã sinh viên
CREATE TRIGGER Trigger_SinhVien_UpdateMaSV on SinhVien for update
as
begin
	if(@@ROWCOUNT = 0)
	begin
		print N'Bảng sinh viên không có dữ liệu'
		return
	end
	if exists (select t1.MASV from SINHVIEN_DETAI t1, DELETED t2 where t1.MASV = t2.MASV and t1.NGAYBAOCAO is not null)
	begin 
		print N'Sinh viên này đã báo cáo không thể update MSV'
		rollback transaction
	end
	update t1 set t1.MASV = t3.MASV
	from SINHVIEN_DETAI t1, deleted t2, inserted t3
	where t1.MASV = t2.MASV
end

--thực thi
select * from SINHVIEN
select * from SINHVIEN_DETAI

update SINHVIEN set MASV = 'SV0004' where MASV ='SV0003'
update SINHVIEN set MASV = 'SV0004' where MASV ='SV0002'


delete SINHVIEN
delete SINHVIEN_DETAI
delete DETAI

update SINHVIEN set MASV = 'SV0004' where MASV ='SV0001'

--Xóa dữ liệu


--use [QLDETAI_SV]
--go

create trigger [dbo].[Trigger_SinhVienCapnhatVaXoaSinhVien] 
on [dbo].[SINHVIEN]
for delete
as
begin
	if(@@ROWCOUNT = 0 )
	begin
		print N'Table sinh viên không có dữ liệu'
		return
	end
	if exists(select t1.MASV from SINHVIEN_DETAI t1, deleted t2 where t1.MASV = t2.MASV and t1.NGAYBAOCAO is not null)
	begin
		print N'Sinh viên đã báo cáo không thể xóa'
		rollback transaction
	end

	delete SINHVIEN_DETAI
	from SINHVIEN_DETAI t1, deleted t2
	where t1.MASV = t2.MASV
end

delete from SINHVIEN where MASV = 'SV0002'


--Function
