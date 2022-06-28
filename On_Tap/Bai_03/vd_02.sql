--Phép hợp
select ho, ten from sv1
union
select ho, ten from sv2
--Hợp kết quả của 2 bảng.Nếu có nhiều giá trị giống nhau chỉ lấy duy nhất 1 giá trị

--Giữ lại kết quả giống nhau
select ho, ten from sv1
union all
select ho, ten from sv2

--Phép nối bảng
--VD:đưa ra mã lớp , tên lớp của khoa cntt
select malop, tenlop
from khoa, lop
where khoa.makhoa = lop.makhoa
and tenkhoa = N'Khoa Công nghệ Thông tin'

--VD: Hiển thị họ tên, ngày sinh của các sinh viên khoa cntt 
select hodem, ten, ngaysinh
from sinhvien, khoa, lop
where tenkhoa = N'Khoa Công nghệ Thông tin' and sinhvien.malop = lop.malop and lop.makhoa = khoa.makhoa
 --Phép tự nối và các bí danh 
 select b.hodem, b.ten, b.ngaysinh
 from sinhvien a, lop b
 where a.hodem = N'Trần Thị Kim' and a.ten='Anh' and a.ngaysinh = b.ngaysinh and a.masv<>b.masv

 --Phep noi trong
 --ten bang 1 inner join  ten bang 2 on dk ket noi
 --VD: Hiển thị họ tên , ngày sinh của các sinh viên lớp tin k24:
 select hodem, ten, ngaysinh 
 from sinhvien, lop
where tenlop = 'K24' and sinhvien.malop = lop.malop

select hodem, ten, ngaysinh
from sinhvien inner join lop
on sinhvien.malop = lop.malop
where tenlop = 'K24'

--Thực hiện phép nối trên nhiều bảng
--VD:Hiển thị tên , ngày sinh của các sinh viên thuộc khoa  cntt
select hodem, ten, ngaysinh
from sinhvien inner join lop
on sinhvien.malop = lop.malop
inner join khoa 
on lop.makhoa = khoa.makhoa
where tenkhoa = N'Khoa công nghệ thông tin'

--Thống kê dl vs group by
--sum([all | distinct] biểu_thức) tính tổng các giá trị
--avg([all | distinct] biểu_thức) tính trung bình các giá trị
--count([all | distinct] biểu_thức) đếm số các giá trị trong biểu thức
--count(*) đếm các dòng đc chọn
--max(biểu thức) tính giá trị lớn nhất
--min(biểu thức) tính giá trị nhỏ nhất

--VD: đưa ra điểm trung bình lần 1
select avg(diemlan1) as 'diemlan1' from diemthi

--VD:Cho biết tuổi lớn nhất, tuổi nhỏ nhất và độ tuổi tb của tất cả các sinh viên tại HN
select max(year(getdate()) - year(ngaysinh))
from sinhvien
where noisinh = 'HN'
select min(year(getdate()) - year(ngaysinh))
from sinhvien
where noisinh = 'HN'
select avg(year(getdate()) - year(ngaysinh))
from sinhvien
where noisinh = 'HN'

--Thống kê dl trên các nhóm
--VD: cho biết sĩ số(số lượng sinh viên của mỗi lớp)
select lop.malop, tenlop, count(masv) as siso
from lop, sinhvien
where lop.malop = sinhvien.malop
group by lop.malop, tenlop

--Cho biết điểm thi trung bình lần 1 các môn học của các sinh viên
select sinhvien.masv, hodem, ten, sum(diemlan1 * sodvht) / sum(sodvht)
from sinhvien, diemthi, monhoc
where sinhvien.masv = diemthi.masv and diemthi.mamonhoc = monhoc.mamonhoc
group by sinhvien.masv, hodem, ten

--group by - having: having cho sd các hàm gộp còn where thì ko
--VD: tìm điểm tb lần 1 của các sinh viên có điểm trung bình lớn hơn hoặc bằng 5
select sinhvien.masv, hodem, ten, sum(diemlan1 * sodvht) / sum(sodvht)
from sinhvien, diemthi, monhoc
where sinhvien.masv = diemthi.masv and diemthi.mamonhoc = monhoc.mamonhoc
group by sinhvien.masv, hodem, ten
having sum(diemlan1 * sodvht) / sum(sodvht) >= 5

--truy vấn con vs mệnh đề having
--VD:CHo biết danh sách các môn học có số đơn vị học trình lớn hơn hoặc bằng số đơn vị học trình lớn hơn hoặc bằng số dvht của môn học có mã là TI-001
select * from monhoc
where sodvht >= (select sodvht from monhoc
					where mamonhoc = 'TI-001')

--VD:Cho biết họ tên của những sinh viên lớp tin k25 sinh trước tất cả  các sinh viên của lớp toán k25
select hodem, ten
from sinhvien join lop on sinhvien.malop = lop.malop
where tenlop = 'Tin K25' and ngaysinh < all(select ngaysinh from sinhvien join lop on sinhvien.malop = lop.malop where lop.tenlop = 'Toán K25')

--subquery vs toán tử in not in , exits
--where biểu_thức [not] in (truy vấn con)
--VD:Hiển thị họ tên của những sinh viên lớp tin k25 có năm sinh bằng với năm sinh của một sinh viên nào đó trong lớp toán k25
select hodem, ten
from sinhvien join lop 
on sinhvien.malop = lop.malop
where tenlop = 'Tin K25' and 
year(ngaysinh) in (select year(ngaysinh)
					from sinhvien join lop
					on sinhvien.malop = lop.malop
					where lop.tenlop = 'Toan K25'
				)
					
--exists: kiểm tra bản ghi có tồn tại
--VD:	CHo biết họ tên của những sinh viên hiện chưa có điểm thi của bất cứ môn nào
select hodem, ten
from sinhvien
where masv not exists(select masv from diemthi where diemthi.masv = sinhvien.masv)


--subquery với mệnh đề having
--VD: cho biết mã, tên và trung bình điểm lần 1 của các môn học có tb lớn hơn tb điểm lần 1 của tất cả các môn học

select diemthi.mamonhoc, tenmonhoc, avg(diemlan1)
from diemthi, monhoc
where diemthi.mamonhoc = monhoc.mamonhoc
group by diemthi.mamonhoc, tenmonhoc
having avg(diemlan1) > (select avg(diemlan1) from diemthi)