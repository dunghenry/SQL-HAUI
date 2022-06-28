--insert
insert into luusinhvien
select hodem, ten, ngaysinh
from sinhvien
where noisinh like '%HN'

--update dl: cập nhật lại số đơn vị học trình của các mon học có số đơn vị học trình nhỏ hơn 2
update monhoc
set sodvht = 3
where sodvht <= 2
--Sd cấu trúc case
update nhatkyphong
set tienphong = songay * case when loaiphong='A' then 100
									loaiphong='B' then 100
									else 50
							end

--update trên nhiều bảng
update nhatkybanhang 
set thanhtien = soluong * dongia
from mathang
where nhatkybanhang.mathang = mathang.mahang

--update truy vấn con
update nhatkybanhang 
set thanhtien = soluong * dongia
from mathang
where mathang.mahang = (select mathang.mahang
						from mathang
						where mathang.mahang = nhatkybanhang.mahang)

--Xóa sv khi sv có nơi sinh tại HN

delete from sinhvien where noisinh like '%HN%'

--Xóa dl liên quan đến nhiều bảng: Xóa những sinh viên lớp k24
delete from sinhvien 
from lop
where lop.malop = sinhvien.malop and tenlop = 'Tin K24'

--Xóa dl dùng truy vấn con: xóa khỏi bảng lớp những lớp ko có sv nào học
delete from lop
where malop not in (select distinct malop from sinhvien) --Nếu mã lớp ko có trong bảng sv đồng nghĩa vs việc mã lớp đó ko có sv nào theo học nên ta xóa đi


--Xóa toàn bộ dl
delete from diemthi