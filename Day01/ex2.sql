CREATE DATABASE BanHang1
ON(
	NAME = "Sale_dat1",
	FILENAME = "D:\SQL-HAUI\Day01\data\saledat1.mdf",
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
),
PRIMARY(
	NAME = "Sale_dat2",
	FILENAME = "D:\SQL-HAUI\Day01\data\saledat2.ndf",
	SIZE = 10MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 5MB
)

LOG ON(
	NAME = "Sale_log1",
	FILENAME = "D:\SQL-HAUI\Day01\data\salelog1.ldf",
	SIZE = 10MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 5MB
),(
	NAME = "Sale_log2",
	FILENAME = "D:\SQL-HAUI\Day01\data\salelog2.ldf",
	SIZE = 10MB,
	MAXSIZE = 20MB,
	FILEGROWTH = 5MB
)
--Sale_dat2 là file chính vì có từ khóa PRIMARY, Nếu không có thì file Sale_dat1 là file chính
