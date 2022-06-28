CREATE DATABASE BanHang
ON PRIMARY(
	NAME = "Sales_dat",
	FILENAME = "D:\SQL-HAUI\Day01\data\saledat.mdf",
	SIZE = 15MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 20%
	)
LOG ON(
	NAME = "Sales_log",
	FILENAME = "D:\SQL-HAUI\Day01\data\salelog.ldf",
	SIZE = 5MB,
	MAXSIZE = 50MB,
	FILEGROWTH = 1MB
)