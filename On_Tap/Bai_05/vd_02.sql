--Tạo khung nhìn
--create view  tên_khung_nhìn [(danh_sach_tên_cot)]
--as
--câu lệnh select

--VD: Tạo khung nhìn có tên dssv từ câu lệnh select truy vấn dl từ hai bảng sv và lớp
create view dssv
as
	select masv, hodem, ten, datediff(yy, ngaysinh, getdate()) as tuoi, tenlop
	from sinhvien, lop
	where sinhvien.malop = lop.malop

--thực hiện câu lệnh
select * from dssv


--C2
create view dssv(ma, ho, ten, tuoi lop)
as
	select masv, hodem, ten, datediff(yy, ngaysinh, getdate()) as tuoi, tenlop
	from sinhvien, lop
	where sinhvien.malop = lop.malop

--View ko đc dùng từ khóa distinct , top , group by và union


--scalar valued function
create function tenham(@thambien1 kieudl1, @ thambien2 kieudl2, ...)
returns kieudltrave
as
	begin --bắt đầu khối lệnh
		declare @bien kieudltrave --khaibaobiencubo
		--Xl thay đổi
		return @bien
	end

--Thực thi hàm
--select dbo.tenham(ds1, ds2, ..)

