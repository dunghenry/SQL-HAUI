--View
create view vw_ThongTinSinhVien
as
select sv.MASV, sv.TENSV, sv.LOP, sv_dt.MADT from SINHVIEN sv
inner join SINHVIEN_DETAI sv_dt
on sv.MASV = sv_dt.MASV

--SD view
select * from vw_ThongTinSinhVien

select * from vw_ThongTinSinhVien vwSV
inner join DETAI dt
on vwSV.MADT = dt.MADT



--Thủ tục
create proc proc_UpdateSinhVien(@MASV char(10), @TENSV nvarchar(30), @SODT varchar(10), @DIACHI nvarchar(50))
as
begin
	if exists(select MASV from SINHVIEN where MASV = @MASV)
	begin
		update SINHVIEN
		set TENSV = @TENSV,
		SODT = @SODT,
		DIACHI = @DIACHI
		where MASV = @MASV
		print N'Đã cập nhật thành công' + @MASV
		return 1
	end
	else
		print N'Khong tồn tai sinh viên có msv ' + @MASV
		return 0
end

--Thực thi store
exec proc_UpdateSinhVien 'SV00011', 'Tran Van Dung',  '123456789', N'Ninh Bình'
select * from SINHVIEN



---Trigger
--Sửa mã sinh viên:nếu sinh viên đã báo cáo thì không thể sửa còn nếu sinh viên chưa báo cáo mới có thể sửa lại mã sinh viên
CREATE TRIGGER Trigger_SinhVien_UpdateMaSV 
on SinhVien
for update
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

--function
create function fnc_XepLoai(
	@TongSoDiem as float,
	@TongSoDeTai as int
)
returns nvarchar(50)
as
begin
	declare @result as nvarchar(50) = ''
	declare @diemTrungBinh as float
if @TongSoDeTai = 0
	return N'Chu co de tai'
set @diemTrungBinh = Round(@TongSoDiem/ @TongSoDeTai, 1)
if @diemTrungBinh < 5
	set @result = convert(nvarchar(5), @diemTrungBinh) + N' Yeu'
else if @diemTrungBinh >= 5 and @diemTrungBinh < 6.5
	set @result = convert(nvarchar(5), @diemTrungBinh) + N' Trung binh'
else if @diemTrungBinh >= 6.5 and @diemTrungBinh < 8
	set @result = convert(nvarchar(5), @diemTrungBinh) + N' Kha'
else
	set @result = convert(nvarchar(5), @diemTrungBinh) + N' Gioi'
return @result
end

select dbo.fnc_XepLoai(15, 2)


select sv.MASV, sv.TENSV, dbo.fnc_XepLoai( sum(sv_dt.DIEM_TB), count (sv_dt.MASV)) as XepLoai
from SINHVIEN sv left join SINHVIEN_DETAI sv_dt
on sv.MASV = sv_dt.MASV
group by sv.MASV, sv.TENSV