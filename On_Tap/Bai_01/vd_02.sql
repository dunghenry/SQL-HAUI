--Cú pháp alter table
--ALTER TABLE tên-bảng

--ADD định_nghĩa_cột

--ALTER COLUMN tên_cột kiểu_dl[null | not null]

--DROP COLUMN  tên_cột

--ADD CONSTRAINT tên_ràng_buộc_định_nghĩa_ràng_buộc

--DROP CONSTRAINT tên_ràng_buộc

--VD:
CREATE TABLE donvi(
	madv int not null primary key,
	tendv nvarchar(30) not null
)

create table nhanvien(
	manv nvarchar(10) not null,
	hoten nvarchar(30) not null,
	ngaysinh datetime,
	diachi nvarchar(30) not null
)
--Bổ sung vào bảng nhân viên cột đt với ràng buộc check nhằm quy định đt của nhân viên là 1 chuỗi 6 số
alter table nhanvien add dienthoai nvarchar(6)
constraint chk_nhanvien_dienthoai check(dienthoai LIKE '[0-9][0-9][0-9][0-9][0-9][0-9]')

--Bổ sung cột madv vào bảng nhân viên
alter table nhanvien add madv int null

--Định nghĩa lại cột dl của cột địa chỉ trong bảng nhân viên và cho phép cột này chấp nhận giá trị null
alter table nhanvien alter column diachi nvarchar(100) null

--Xóa cột ngày sinh khỏi bảng nhân viên
alter table nhanvien drop column ngaysinh

--định nghĩa khóa chính (ràng buộc primary key) cho bảng nhân viên là cột manv
alter table nhanvien add constraint pk_nhanvien primary key(manv)

--định nghĩa khóa ngoài cho bảng nhân viên trên cột madv tham chiếu đến cột madv của bảng đơn vị
alter table nhanvien add constraint fk_nhanvien_madv foreign key(madv) references donvi(madv) on delete cascade on update cascade

--xóa bỏ ràng buộc kiểm tra số đt của nhân viên 
alter table nhanvien
drop constraint ck_nhanvien_dienthoai

--Xóa bảng
--drop table tên_bảng
--VD: Xóa bỏ ràng buộc fk_nhanvien_madv khỏi bảng nhân viên:
alter table nhanvien drop constraint fk_nhanvien_madv

--Xóa bảng đơn vị
drop table donvi