--Chèn dl
insert into HangSX values('H04', N'Xiaomi', N'China', 'xm@gmail.com.cn')

--update dl
update HangSX 
set TenHang=N'Xiao-Mi',
	SoDT = '012345678',
	Email = 'xmi@gmail.com.cn'
where MaHang = 'H04'

--Xóa toàn bộ bảng
delete HangSX
delete HangSX where MaHang = 'H02'

--create view
create view vw_DSSP
as
	select masp, tensp, mausac, soluong, giaban
	from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	where TenHang = N'Samsung'

--Thay đổi nd view
alter view vw_DSSP
as
	select masp, tensp, mausac, soluong, giaban
	from SanPham inner join HangSX on SanPham.MaHangSX = HangSX.MaHangSX
	where TenHang = N'Nokia'

--Xóa view 
drop view vw_DSSP

--Gọi khung nhìn
select * from vw_DSSP

select masp, tensp from vw_DSSP
where soluong >= 100

--Kết nối view vs bảng khác
select vw_DSSP.masp, tensp, SoLuongX
from vw_DSSP inner join Xuat
on vw_DSSP.MaSP = Xuat.MaSP