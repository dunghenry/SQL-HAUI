--inner join, left join , right join , full outer join, union

select * from SinhVien
where MASV = 'SV01' OR MASV = 'SV02'



select * from SinhVien
where MASV IN('SV01', 'SV02')

select * from SinhVien
where MASV IN('SV01', 'SV02')

select * from SinhVien
where MASV IN('SV01', 'SV02')
order by MASV desc

select * from SinhVien
where MASV IN('SV01', 'SV02')
order by MASV asc


--inner join

select sv.MASV, sv.TENSV, sv_dt.MADT, sv_dt.MADT from SinhVien sv
inner join SinhVien_DeTai sv_dt
on sv.MASV = sv_dt.MASV
where sv.MASV = 'SV01' OR sv.MASV = 'SV02'


select sv.MASV, sv.TENSV from SinhVien sv, SinhVien_DeTai sv_dt
where sv.MASV = sv_dt.MASV
group by sv.MASV, sv.TENSV


--left join: lấy phần bên trái đó là phần SinhVien
select sv.MASV, sv.TENSV, sv_dt.MADT from SinhVien sv
left join SinhVien_DeTai sv_dt
on sv.MASV = sv_dt.MASV


--left join: lấy phần bên phải đó là phần của SinhVien_DeTai
select sv.MASV, sv.TENSV, sv_dt.MADT from SinhVien sv
left join SinhVien_DeTai sv_dt
on sv.MASV = sv_dt.MASV


--full outer join: Lấy tất cả dl từ hai bảng

select sv.MASV, sv.TENSV, sv_dt.MADT, sv_dt.MASV from SinhVien sv
full outer join SinhVien_DeTai sv_dt
on sv.MASV = sv_dt.MASV


--Union: gộp dl của hai bảng
--Lấy ra sv có msv là SV01, SV02, SV03 và ko bị trùng lặp dl
select * from SinhVien
where MASV = 'SV01' OR MASV = 'SV02'
union
select * from SinhVien
where MASV = 'SV03' or MASV ='SV01'


--Lấy ra sv có msv là SV01, SV02, SV03 và bị trùng dl
select * from SinhVien
where MASV = 'SV01' OR MASV = 'SV02'
union all
select * from SinhVien
where MASV = 'SV03' OR MASV = 'SV02'

