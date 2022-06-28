--select [all | distinct] [top n] danh_sach_chon
--[into ten_bang_moi]
--from danhsachbang, khung nhin
--[where dk]
--[group by danhsachcot]
--[having dieukien]
--[order by cot_sap_xep ASC/DES]
--[compute danhsachhamgop [bydanhsachcot]]

--Chọn tất cả các cột trong bảng
--select * from bang

--Tên cột trong danh sách chọn
--select a, b, c from bang

--Thay đổi tiêu đề các cột 
--'tieudecot' = ten_truong hoặc tên_trường AS 'tiêu đề cột' hoặc tên_trường 'tiêu đề cột'
--VD select 'Mã lớp' =  malop, tenlop 'Tên lớp', khoa as 'Khóa' from lop

--Cấu trúc sử dụng case
--case biểu thức when biểu_thức_kiểm tra then kết_quả [...] [else kết quả của else] end
--case when điều_kiện then kết_quả [...] [else kết quả của else] end

--V:Hiển thị mã, họ tên, và giới tính  nam hoặc nữ của sinh viên  ta sd câu lệnh
select masv, hodem, ten, case gioitinh when 1 then 'Nam' else 'Nữ' end  as gioitinh from sinhvien
select masv, hodem, ten, case when gioitinh = 1 then 'Nam' else 'Nữ' end as gioitinh from sinhvien

--Loại bỏ các kết quả trùng nhau trong kết quả truy vấn
select distinct field from table
--top n/top n percent - lấy ra n / n phần trăm bản ghi đầu tiên

--Mệnh đề where  là phép học kết quả truy vấn.mệnh đề where sd  = , >, <... các phép toán logic and, or, not

--Kiểm tra giới hạn của dl
--giá trị between a and b hoặc a <= giá trị and giá trị  < b

--giá trị null
-where tencot is null
hoac tencot is not null
--DS in và not in
select * from monhoc where sodvht = 2 or sodvht = 4 or sodvht =5
select * from monhoc where sodvht in(2, 4, 5)

--Like: % chuỗi kí tự bất kì, - kí tự đơn bất kì, []: [a-f], [^a-f]
select hodem, ten from sinhvien where hodem like 'Lê%'
select hodem, ten from sinhvien where hodem like 'Lê%' and ten like '[AB]%'
 

 --Tạo bảng dl 

 select hodem, ten, YEAR(getdate()) - year(ngaysinh) as tuoi into tuoisv from sinhvien

--Sap xep kq truy van
--sau order by là các cột cần sắp xếp tối đa là 16 cột.Dl đc sắp xếp có thể theo chiều tăng dần asc hoặc giảm desc mặc định theo chiều tăng asc
--Nếu sau order by có nhiều cột thì việc sắp xếp dl sẽ đc ưu tiên theo thứ tự từ trái qua phải
--VD:
select hodem, ten, gioitinh, year(getdate()) - year(ngaysinh) as tuoi
from sinhvien
where ten ='Bình'
order by gioitinh, tuoi