USE [master]
GO
/****** Object:  Database [FixMyCar]    Script Date: 05/11/2024 02:04:21 ******/
CREATE DATABASE [FixMyCar]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'FixMyCar', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FixMyCar.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'FixMyCar_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FixMyCar_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [FixMyCar] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [FixMyCar].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [FixMyCar] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [FixMyCar] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [FixMyCar] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [FixMyCar] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [FixMyCar] SET ARITHABORT OFF 
GO
ALTER DATABASE [FixMyCar] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [FixMyCar] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [FixMyCar] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [FixMyCar] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [FixMyCar] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [FixMyCar] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [FixMyCar] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [FixMyCar] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [FixMyCar] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [FixMyCar] SET  ENABLE_BROKER 
GO
ALTER DATABASE [FixMyCar] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [FixMyCar] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [FixMyCar] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [FixMyCar] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [FixMyCar] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [FixMyCar] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [FixMyCar] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [FixMyCar] SET RECOVERY FULL 
GO
ALTER DATABASE [FixMyCar] SET  MULTI_USER 
GO
ALTER DATABASE [FixMyCar] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [FixMyCar] SET DB_CHAINING OFF 
GO
ALTER DATABASE [FixMyCar] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [FixMyCar] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [FixMyCar] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [FixMyCar] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'FixMyCar', N'ON'
GO
ALTER DATABASE [FixMyCar] SET QUERY_STORE = OFF
GO
USE [FixMyCar]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[AuthTokens]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[AuthTokens](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [nvarchar](max) NOT NULL,
	[UserId] [int] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[Revoked] [datetime2](7) NULL,
 CONSTRAINT [PK_AuthTokens] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarManufacturers]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarManufacturers](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_CarManufacturers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarModels]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarModels](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarManufacturerId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[ModelYear] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_CarModels] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarPartsShopClientDiscounts]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarPartsShopClientDiscounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Value] [float] NOT NULL,
	[CarPartsShopId] [int] NOT NULL,
	[ClientId] [int] NULL,
	[CarRepairShopId] [int] NULL,
	[Created] [datetime2](7) NOT NULL,
	[Revoked] [datetime2](7) NULL,
	[SoftDelete] [bit] NULL,
 CONSTRAINT [PK_CarPartsShopClientDiscounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarRepairShopDiscounts]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarRepairShopDiscounts](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarRepairShopId] [int] NOT NULL,
	[Value] [float] NOT NULL,
	[ClientId] [int] NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[Revoked] [datetime2](7) NULL,
	[SoftDelete] [bit] NULL,
 CONSTRAINT [PK_CarRepairShopDiscounts] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CarRepairShopServices]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CarRepairShopServices](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarRepairShopId] [int] NOT NULL,
	[ServiceTypeId] [int] NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Price] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[DiscountedPrice] [float] NOT NULL,
	[State] [nvarchar](max) NOT NULL,
	[ImageData] [varbinary](max) NULL,
	[Details] [nvarchar](max) NULL,
	[Duration] [time](7) NOT NULL,
 CONSTRAINT [PK_CarRepairShopServices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[SenderUserId] [nvarchar](max) NOT NULL,
	[RecipientUserId] [nvarchar](max) NOT NULL,
	[Message] [nvarchar](max) NOT NULL,
	[SentAt] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ChatMessages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Cities]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Cities](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Cities] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[OrderDetails]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrderDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[OrderId] [int] NOT NULL,
	[StoreItemId] [int] NOT NULL,
	[Quantity] [int] NOT NULL,
	[UnitPrice] [float] NOT NULL,
	[TotalItemsPrice] [float] NOT NULL,
	[TotalItemsPriceDiscounted] [float] NOT NULL,
	[Discount] [float] NOT NULL,
 CONSTRAINT [PK_OrderDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Orders]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Orders](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarPartsShopId] [int] NOT NULL,
	[CarRepairShopId] [int] NULL,
	[ClientId] [int] NULL,
	[OrderDate] [datetime2](7) NOT NULL,
	[ShippingDate] [datetime2](7) NULL,
	[TotalAmount] [float] NOT NULL,
	[ClientDiscountId] [int] NULL,
	[State] [nvarchar](max) NOT NULL,
	[CityId] [int] NOT NULL,
	[ShippingAddress] [nvarchar](max) NOT NULL,
	[ShippingPostalCode] [nvarchar](max) NOT NULL,
	[PaymentIntentId] [nvarchar](max) NULL,
	[DeletedByShop] [bit] NOT NULL,
	[DeletedByCustomer] [bit] NOT NULL,
 CONSTRAINT [PK_Orders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ReservationDetails]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ReservationDetails](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[ReservationId] [int] NOT NULL,
	[CarRepairShopServiceId] [int] NOT NULL,
	[ServiceName] [nvarchar](max) NOT NULL,
	[ServicePrice] [float] NOT NULL,
	[ServiceDiscount] [float] NOT NULL,
	[ServiceDiscountedPrice] [float] NOT NULL,
 CONSTRAINT [PK_ReservationDetails] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reservations]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reservations](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CarRepairShopId] [int] NOT NULL,
	[ClientId] [int] NOT NULL,
	[OrderId] [int] NULL,
	[ClientOrder] [bit] NULL,
	[ReservationCreatedDate] [datetime2](7) NOT NULL,
	[ReservationDate] [datetime2](7) NOT NULL,
	[EstimatedCompletionDate] [datetime2](7) NULL,
	[CompletionDate] [datetime2](7) NULL,
	[TotalAmount] [float] NOT NULL,
	[CarModelId] [int] NOT NULL,
	[TotalDuration] [time](7) NOT NULL,
	[CarRepairShopDiscountId] [int] NULL,
	[State] [nvarchar](max) NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[PaymentIntentId] [nvarchar](max) NULL,
	[DeletedByShop] [bit] NOT NULL,
	[DeletedByCustomer] [bit] NOT NULL,
 CONSTRAINT [PK_Reservations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Roles]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Description] [nvarchar](max) NULL,
 CONSTRAINT [PK_Roles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ServiceTypes]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ServiceTypes](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Image] [varbinary](max) NOT NULL,
 CONSTRAINT [PK_ServiceTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreItemCarModels]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreItemCarModels](
	[StoreItemId] [int] NOT NULL,
	[CarModelId] [int] NOT NULL,
 CONSTRAINT [PK_StoreItemCarModels] PRIMARY KEY CLUSTERED 
(
	[StoreItemId] ASC,
	[CarModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreItemCategory]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreItemCategory](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_StoreItemCategory] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[StoreItems]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[StoreItems](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Price] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[DiscountedPrice] [float] NOT NULL,
	[State] [nvarchar](max) NOT NULL,
	[ImageData] [varbinary](max) NULL,
	[Details] [nvarchar](max) NULL,
	[CarPartsShopId] [int] NOT NULL,
	[StoreItemCategoryId] [int] NULL,
 CONSTRAINT [PK_StoreItems] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 05/11/2024 02:04:21 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](max) NOT NULL,
	[Surname] [nvarchar](max) NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[Phone] [nvarchar](max) NOT NULL,
	[Username] [nvarchar](max) NOT NULL,
	[Created] [datetime2](7) NOT NULL,
	[Gender] [nvarchar](max) NOT NULL,
	[Address] [nvarchar](max) NULL,
	[PostalCode] [nvarchar](max) NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
	[PasswordSalt] [nvarchar](max) NOT NULL,
	[Image] [varbinary](max) NULL,
	[RoleId] [int] NOT NULL,
	[CityId] [int] NOT NULL,
	[Active] [bit] NOT NULL,
	[CarPartsShop_WorkDaysAsString] [nvarchar](max) NULL,
	[CarPartsShop_OpeningTime] [time](7) NULL,
	[CarPartsShop_ClosingTime] [time](7) NULL,
	[CarPartsShop_WorkingHours] [time](7) NULL,
	[WorkDaysAsString] [nvarchar](max) NULL,
	[OpeningTime] [time](7) NULL,
	[ClosingTime] [time](7) NULL,
	[WorkingHours] [time](7) NULL,
	[Employees] [int] NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20241101005440_migration', N'6.0.9')
GO
SET IDENTITY_INSERT [dbo].[AuthTokens] ON 

INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (1, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ik5pY29sZSIsIm5hbWVpZCI6ImNhcnJlcGFpcnNob3AiLCJyb2xlIjoiY2FycmVwYWlyc2hvcCIsIm5iZiI6MTczMDc2NTAzNSwiZXhwIjoxNzMxMzY5ODM1LCJpYXQiOjE3MzA3NjUwMzV9.jYjvtFLyYzkd3lWjmu3-naOVjQO_SGGN62bmuooJfU4', 3, CAST(N'2024-11-05T01:03:55.9451677' AS DateTime2), CAST(N'2024-11-05T01:04:54.7841808' AS DateTime2))
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (2, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ik5pY29sZSIsIm5hbWVpZCI6ImNhcnJlcGFpcnNob3AiLCJyb2xlIjoiY2FycmVwYWlyc2hvcCIsIm5iZiI6MTczMDc2NzUyOCwiZXhwIjoxNzMxMzcyMzI4LCJpYXQiOjE3MzA3Njc1Mjh9.byLt_xkjSt0s8kPsa35wrk_JATvu2EBrInXNR_kxZwA', 3, CAST(N'2024-11-05T01:45:28.6501070' AS DateTime2), NULL)
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (3, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkppbSIsIm5hbWVpZCI6ImNhcnBhcnRzc2hvcCIsInJvbGUiOiJjYXJwYXJ0c3Nob3AiLCJuYmYiOjE3MzA3Njc2MzYsImV4cCI6MTczMTM3MjQzNiwiaWF0IjoxNzMwNzY3NjM2fQ.rfc3wcWASXPGfxddFRwZTAyBZAfwPH0U8eF-2B66Tn8', 2, CAST(N'2024-11-05T01:47:16.9168619' AS DateTime2), NULL)
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (4, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ik5pY29sZSIsIm5hbWVpZCI6ImNhcnJlcGFpcnNob3AiLCJyb2xlIjoiY2FycmVwYWlyc2hvcCIsIm5iZiI6MTczMDc2NzY5OSwiZXhwIjoxNzMxMzcyNDk5LCJpYXQiOjE3MzA3Njc2OTl9.oIOkp2Dst00vQS5SP1MAmulYeU-7Vu-2WhskPYBsMi4', 3, CAST(N'2024-11-05T01:48:19.1396606' AS DateTime2), CAST(N'2024-11-05T01:48:55.1170299' AS DateTime2))
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (5, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ik5hbmN5IiwibmFtZWlkIjoiY2xpZW50Iiwicm9sZSI6ImNsaWVudCIsIm5iZiI6MTczMDc2ODAxMCwiZXhwIjoxNzMxMzcyODEwLCJpYXQiOjE3MzA3NjgwMTB9.86_Sy_KVRdrlsSv6gy2XSaZ-zSSY_z7t0AgI7H8TPvc', 4, CAST(N'2024-11-05T01:53:30.6423357' AS DateTime2), CAST(N'2024-11-05T01:53:44.6024253' AS DateTime2))
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (6, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkZyZWRkaWUiLCJuYW1laWQiOiJjbGllbnQzIiwicm9sZSI6ImNsaWVudCIsIm5iZiI6MTczMDc2ODAzNiwiZXhwIjoxNzMxMzcyODM2LCJpYXQiOjE3MzA3NjgwMzZ9.TjgKlEDCmTXTZWF35z7yndb6EzkyqeD6EyRuYLe0Wwc', 6, CAST(N'2024-11-05T01:53:56.4025377' AS DateTime2), CAST(N'2024-11-05T01:58:06.1398219' AS DateTime2))
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (7, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6Ik5pY29sZSIsIm5hbWVpZCI6ImNhcnJlcGFpcnNob3AiLCJyb2xlIjoiY2FycmVwYWlyc2hvcCIsIm5iZiI6MTczMDc2ODQxNSwiZXhwIjoxNzMxMzczMjE1LCJpYXQiOjE3MzA3Njg0MTV9.CUJ-Jyl4xd8f3qml9I4FxmDbPTRDcvpBBgvbE7bAweg', 3, CAST(N'2024-11-05T02:00:15.8182176' AS DateTime2), CAST(N'2024-11-05T02:03:34.7661874' AS DateTime2))
INSERT [dbo].[AuthTokens] ([Id], [Value], [UserId], [Created], [Revoked]) VALUES (8, N'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1bmlxdWVfbmFtZSI6IkppbSIsIm5hbWVpZCI6ImNhcnBhcnRzc2hvcCIsInJvbGUiOiJjYXJwYXJ0c3Nob3AiLCJuYmYiOjE3MzA3Njg1MTksImV4cCI6MTczMTM3MzMxOSwiaWF0IjoxNzMwNzY4NTE5fQ.xDOLyJmxpoZSFqT-ATT20qzU7b2V1CmpK4egpDDoJMk', 2, CAST(N'2024-11-05T02:01:59.7604206' AS DateTime2), CAST(N'2024-11-05T02:02:24.0282272' AS DateTime2))
SET IDENTITY_INSERT [dbo].[AuthTokens] OFF
GO
SET IDENTITY_INSERT [dbo].[CarManufacturers] ON 

INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (1, N'Volkswagen')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (2, N'Toyota')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (3, N'Ford')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (4, N'Honda')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (5, N'BMW')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (6, N'Mercedes-Benz')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (7, N'Opel')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (8, N'Nissan')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (9, N'Hyundai')
INSERT [dbo].[CarManufacturers] ([Id], [Name]) VALUES (10, N'Audi')
SET IDENTITY_INSERT [dbo].[CarManufacturers] OFF
GO
SET IDENTITY_INSERT [dbo].[CarModels] ON 

INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (1, 1, N'Golf Mk4', N'1997-2003')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (2, 1, N'Passat B5/B5.5', N'1996-2005')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (3, 1, N'Passat B2', N'1981-1988')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (4, 1, N'Phaeton GP0/GP1', N'2002-2007')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (5, 1, N'Tiguan (AD/BW)', N'2016-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (6, 1, N'Polo Mk5', N'2009–2017')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (7, 2, N'Corolla (E140)', N'2006-2013')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (8, 2, N'Camry XV70', N'2017-2023')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (9, 2, N'Land Cruiser J100', N'1998-2007')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (10, 2, N'GR Yaris', N'2020-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (11, 2, N'Supra A80', N'1993-2002')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (12, 2, N'Prius XW30', N'2009-2015')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (13, 3, N'Mustang (5th gen)', N'2004-2014')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (14, 3, N'Fiesta (3rd gen)', N'1989-1997')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (15, 3, N'Focus (2nd gen)', N'2011-2014')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (16, 3, N'F-150 (11th gen)', N'2004–2008')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (17, 3, N'Explorer (4th gen)', N'2006–2010')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (18, 4, N'Civic (6th gen)', N'1996-2000')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (19, 4, N'Accord (9th gen)', N'2012–2017')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (20, 4, N'CR-V (3rd gen)', N'2006–2012')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (21, 4, N'Fit (1st gen)', N'2001–2008')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (22, 4, N'NSX (NA1/2)', N'1991–2005')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (23, 5, N'E30', N'1982–1994')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (24, 5, N'E34', N'1988–1995')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (25, 5, N'X5 (E70)', N'2007–2013')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (26, 5, N'i8', N'2014-2020')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (27, 5, N'M4 (F82)', N'2014-2020')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (28, 6, N'C-Class (W202)', N'1993-2000')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (29, 6, N'C-Class (W203)', N'2000-2007')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (30, 6, N'E-Class (W210)', N'1995-2002')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (31, 6, N'E-Class (W211)', N'2002-2009')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (32, 6, N'S-Class (W220)', N'1999-2005')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (33, 6, N'S-Class (W221)', N'2005-2013')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (34, 6, N'G-Class (W463)', N'1990-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (35, 7, N'Corsa A', N'1982-1993')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (36, 7, N'Corsa B', N'1993-2000')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (37, 7, N'Astra F', N'1991-1998')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (38, 7, N'Astra G', N'1998-2004')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (39, 7, N'Insignia A', N'2008-2017')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (40, 7, N'Zafira A', N'1999-2005')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (41, 7, N'Mokka X', N'2016-2019')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (42, 8, N'Altima L31', N'2001-2006')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (43, 8, N'Altima L32', N'2006-2012')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (44, 8, N'GT-R R35', N'2007-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (45, 8, N'Pathfinder R50', N'1995-2004')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (46, 8, N'Pathfinder R52', N'2012-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (47, 8, N'370Z Z34', N'2009-2020')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (48, 9, N'Elantra HD', N'2006-2010')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (49, 9, N'Elantra MD', N'2010-2015')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (50, 9, N'Tucson JM', N'2004-2009')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (51, 9, N'Tucson TL', N'2015-2020')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (52, 9, N'Santa Fe DM', N'2012-2018')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (53, 9, N'Santa Fe TM', N'2018-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (54, 9, N'Kona OS', N'2017-present')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (55, 10, N'A4 B6', N'2000–2006')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (56, 10, N'Quattro', N'1980–1991')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (57, 10, N'200 C4', N'1983–1992')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (58, 10, N'TT (8N)', N'1998-2006')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (59, 10, N'R8 (Typ 42)', N'2006-2015')
INSERT [dbo].[CarModels] ([Id], [CarManufacturerId], [Name], [ModelYear]) VALUES (60, 10, N'A7 (Typ 4K8)', N'2019-present')
SET IDENTITY_INSERT [dbo].[CarModels] OFF
GO
SET IDENTITY_INSERT [dbo].[CarPartsShopClientDiscounts] ON 

INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (1, 0.1, 2, 4, NULL, CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), 1)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (2, 0.15, 2, 4, NULL, CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-02T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (3, 0.2, 2, NULL, 3, CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (4, 0.13, 2, NULL, 3, CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), NULL, NULL)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (5, 0.05, 2, NULL, 8, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (6, 0.05, 2, 5, NULL, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (7, 0.03, 7, NULL, 8, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (8, 0.05, 7, 4, NULL, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 1)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (9, 0.1, 7, 6, NULL, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (10, 0.05, 7, 5, NULL, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (11, 0.05, 7, NULL, 3, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (12, 0.07, 7, NULL, 3, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 0)
INSERT [dbo].[CarPartsShopClientDiscounts] ([Id], [Value], [CarPartsShopId], [ClientId], [CarRepairShopId], [Created], [Revoked], [SoftDelete]) VALUES (13, 0.07, 2, 4, NULL, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, 0)
SET IDENTITY_INSERT [dbo].[CarPartsShopClientDiscounts] OFF
GO
SET IDENTITY_INSERT [dbo].[CarRepairShopDiscounts] ON 

INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (1, 3, 0.05, 4, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (2, 3, 0.02, 4, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (3, 3, 0.2, 5, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (4, 3, 0.15, 5, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (5, 3, 0.07, 5, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (6, 8, 0.1, 4, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (7, 8, 0.05, 5, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (8, 8, 0.09, 5, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, NULL)
INSERT [dbo].[CarRepairShopDiscounts] ([Id], [CarRepairShopId], [Value], [ClientId], [Created], [Revoked], [SoftDelete]) VALUES (9, 8, 0.1, 6, CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), NULL, NULL)
SET IDENTITY_INSERT [dbo].[CarRepairShopDiscounts] OFF
GO
SET IDENTITY_INSERT [dbo].[CarRepairShopServices] ON 

INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (1, 3, 1, N'Front Brakes Repair', 50, 0.05, 47.5, N'active', NULL, N'Full front brake repair. Discs and pads.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (2, 3, 1, N'Rear Brakes Repair', 40, 0, 40, N'active', NULL, N'Rear brake repair service (discs, pads, drums, handbrakes).', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (3, 3, 1, N'Tire Replacement', 30, 0, 30, N'active', NULL, N'Tire replacement and balancing.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (4, 3, 1, N'Oil Change', 45, 0, 45, N'active', NULL, N'Including: repairing any leaking oil lines and cleaning the whole oil distribution system.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (5, 3, 1, N'Battery Replacement', 20, 0.05, 19, N'active', NULL, N'Battery replacement', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (6, 3, 1, N'Suspension Repair', 90, 0, 90, N'active', NULL, N'Front and rear suspension repair (double wishbone, multi-link, trailing arm, MacPherson strut, leaf suspension).', CAST(N'03:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (7, 3, 1, N'Clutch Replacement', 120, 0, 120, N'active', NULL, N'Full clutch replacement (flywheel, pressure plate, clutch, oil change).', CAST(N'04:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (8, 3, 1, N'Exhaust System Repair', 30, 0.05, 28.5, N'active', NULL, N'Including: fixing leaks, clogged DPF systems, broken mufflers, resonators, full exhaust replacement', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (9, 3, 1, N'Engine Overhaul', 300, 0, 300, N'active', NULL, N'Replacing and fixing multiple vital parts at once like: pistons, rods, crankshafts, camshafts, timing chains, etc.', CAST(N'06:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (10, 3, 1, N'Timing Belt Replacement', 60, 0, 60, N'active', NULL, N'Timing belt replacement including belt tensioner and idler pulley.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (11, 3, 1, N'Transmission Repair', 260, 0.03, 252.2, N'active', NULL, N'Full transmission repair - worn out synchronizers, blown differentials, stuck gears, etc.', CAST(N'05:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (12, 3, 2, N'Engine Diagnostic', 40, 0, 40, N'active', NULL, N'Diagnosing mechanical errors related to ICE unit.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (13, 3, 2, N'Warning and Error Lights Diagnostic', 30, 0.05, 28.5, N'active', NULL, N'Diagnosing all kinds of warnings and errors that appear on your dash or infotainment system.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (14, 3, 2, N'Battery Health Check', 25, 0, 25, N'active', NULL, N'Testing the battery and charging system for proper voltage and capacity.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (15, 3, 2, N'Brake System Diagnostic', 30, 0, 30, N'active', NULL, N'Inspecting and testing the brake system, including pads, rotors, and brake fluid levels.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (16, 3, 2, N'Suspension Diagnostic', 40, 0, 40, N'active', NULL, N'Checking for wear or damage in shocks, struts, and other suspension components.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (17, 3, 2, N'Transmission Diagnostic', 70, 0.05, 66.5, N'active', NULL, N'Scanning and diagnosing transmission-related problems, such as shifting issues.', CAST(N'03:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (18, 3, 2, N'Electrical System Diagnostic', 40, 0, 40, N'active', NULL, N'Checking the car’s electrical system, including lights, alternator, and wiring for faults.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (19, 3, 2, N'Air Conditioning System Diagnostic', 30, 0, 30, N'active', NULL, N'Testing and inspecting the AC system for refrigerant leaks or compressor issues.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (20, 3, 2, N'Fuel System Diagnostic', 40, 0, 40, N'active', NULL, N'Analyzing fuel injectors, pumps, and filters for clogs or malfunctions.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (21, 3, 2, N'Exhaust Emissions Test', 30, 0.1, 27, N'active', NULL, N'Checking the vehicle’s emissions to ensure compliance with environmental standards.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (22, 8, 1, N'Wheel Alignment', 50, 0, 50, N'active', NULL, N'Wheel alignment using specialized laser tools.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (23, 8, 1, N'Head Gasket Repair', 95, 0, 95, N'active', NULL, N'Head gasket repair for all sorts of engines.', CAST(N'03:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (24, 8, 1, N'Fuel Injector Cleaning', 120, 0, 120, N'active', NULL, N'Cleaning clogged fuel injectors to improve fuel efficiency and engine performance.', CAST(N'03:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (25, 8, 1, N'Air Conditioning Recharge', 30, 0.05, 28.5, N'active', NULL, N'Recharging the air conditioning system with refrigerant to restore cooling.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (26, 8, 1, N'Power Steering Pump Replacement', 65, 0, 65, N'active', NULL, N'Replacing a failing power steering pump to restore smooth steering control.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (27, 8, 1, N'Serpentine Belt Replacement', 45, 0, 45, N'active', NULL, N'Replacing a worn or damaged serpentine belt that drives multiple engine components.', CAST(N'01:30:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (28, 8, 2, N'Emissions Test', 30, 0, 30, N'active', NULL, N'Analyzing exhaust emissions to ensure compliance with environmental standards and regulations.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (29, 8, 2, N'Fuel System Diagnostics', 45, 0, 45, N'active', NULL, N'Testing fuel pressure, injectors, and pump performance to identify fuel delivery problems.', CAST(N'02:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (30, 8, 2, N'Air Conditioning System Diagnostics', 35, 0.02, 34.3, N'active', NULL, N'Testing the air conditioning system for leaks, pressure issues, or compressor failures.', CAST(N'01:00:00' AS Time))
INSERT [dbo].[CarRepairShopServices] ([Id], [CarRepairShopId], [ServiceTypeId], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [Duration]) VALUES (31, 8, 2, N'Brake System Inspection', 65, 0, 65, N'active', NULL, N'Checking brake pads, rotors, calipers, and fluid levels to identify any wear or faults.', CAST(N'02:00:00' AS Time))
SET IDENTITY_INSERT [dbo].[CarRepairShopServices] OFF
GO
SET IDENTITY_INSERT [dbo].[ChatMessages] ON 

INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (1, N'client', N'admin', N'test', CAST(N'2024-11-02T00:20:02.9852424' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (2, N'carrepairshop', N'carpartsshop', N'Hello', CAST(N'2024-11-04T01:57:45.7319688' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (3, N'carpartsshop', N'carrepairshop', N'Hi', CAST(N'2024-11-04T01:59:40.7060301' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (4, N'carrepairshop', N'carpartsshop', N'Do you have new tires available right now?', CAST(N'2024-11-04T01:59:59.7051112' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (5, N'carpartsshop', N'carrepairshop', N'Yes we do, winter tires have arrived yesterday!', CAST(N'2024-11-04T02:00:23.1128549' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (6, N'carrepairshop', N'carpartsshop', N'That''s good to hear, we will order some.', CAST(N'2024-11-04T02:00:40.3129628' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (7, N'carpartsshop', N'carrepairshop', N'Glad we can help!', CAST(N'2024-11-04T02:00:46.0103335' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (8, N'carrepairshop', N'carpartsshop', N'Likewise!', CAST(N'2024-11-04T02:00:57.8337231' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (9, N'carrepairshop', N'client2', N'Hello', CAST(N'2024-11-04T02:01:39.1303694' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (10, N'carrepairshop', N'client2', N'We are just informing you that you will have to reschedule your appointment since we are overbooked', CAST(N'2024-11-04T02:02:00.4905966' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (11, N'carrepairshop', N'client2', N'I hope you understand', CAST(N'2024-11-04T02:02:03.6567632' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (12, N'carpartsshop', N'client2', N'Hello', CAST(N'2024-11-04T21:37:02.2393725' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (13, N'carpartsshop', N'client2', N'We decided to reward you with a 5% discount on our whole catalog', CAST(N'2024-11-04T21:37:26.6166479' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (14, N'carpartsshop', N'client2', N'Thank you for being a loyal customer', CAST(N'2024-11-04T21:37:35.2745863' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (15, N'carrepairshop2', N'carrepairshop', N'Hello', CAST(N'2024-11-04T21:47:27.4085411' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (16, N'carrepairshop2', N'carrepairshop', N'We are planning on renovating our garage next month', CAST(N'2024-11-04T21:47:39.4828713' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (17, N'carrepairshop2', N'carrepairshop', N'Therefore, we will have to work at a reduced pace', CAST(N'2024-11-04T21:47:52.0152256' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (18, N'carrepairshop2', N'carrepairshop', N'We will probably have to decline a lot of reservations', CAST(N'2024-11-04T21:48:54.6977861' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (19, N'carrepairshop2', N'carrepairshop', N'So, if you want, we will send them to you', CAST(N'2024-11-04T21:49:03.8327033' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (20, N'carrepairshop2', N'carrepairshop', N'Let us know what you think', CAST(N'2024-11-04T21:49:13.5135526' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (21, N'carrepairshop', N'carrepairshop2', N'Hello', CAST(N'2024-11-04T21:53:45.1509716' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (22, N'carrepairshop', N'carrepairshop2', N'That''s a nice offer', CAST(N'2024-11-04T21:53:50.3931690' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (23, N'carrepairshop', N'carrepairshop2', N'We will be happy to collaborate', CAST(N'2024-11-04T21:54:13.3375566' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (24, N'carrepairshop', N'carrepairshop2', N'Of course, we can share some revenue', CAST(N'2024-11-04T21:54:19.5455272' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (25, N'carrepairshop', N'carrepairshop2', N'Thank you for letting us know', CAST(N'2024-11-04T21:54:26.7934482' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (26, N'carrepairshop', N'carrepairshop2', N'If you need anything else, please let us know', CAST(N'2024-11-04T21:54:51.3689152' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (27, N'carrepairshop', N'carrepairshop2', N'Good luck with the renovation', CAST(N'2024-11-04T21:54:56.2392734' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (28, N'client', N'carpartsshop', N'Hello', CAST(N'2024-11-04T22:14:21.7824636' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (29, N'client', N'carpartsshop', N'Is it possible to order parts in bulk?', CAST(N'2024-11-04T22:14:39.2757766' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (30, N'client', N'carpartsshop', N'I am planning on engine rebuild', CAST(N'2024-11-04T22:14:49.6778635' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (31, N'client', N'carpartsshop', N'I will need a lot of parts', CAST(N'2024-11-04T22:14:57.4758766' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (32, N'client2', N'carrepairshop', N'No problem, thank you for informing me', CAST(N'2024-11-04T22:25:22.3280123' AS DateTime2))
INSERT [dbo].[ChatMessages] ([Id], [SenderUserId], [RecipientUserId], [Message], [SentAt]) VALUES (33, N'client2', N'carpartsshop', N'Thank you so much', CAST(N'2024-11-04T22:25:52.5802579' AS DateTime2))
SET IDENTITY_INSERT [dbo].[ChatMessages] OFF
GO
SET IDENTITY_INSERT [dbo].[Cities] ON 

INSERT [dbo].[Cities] ([Id], [Name]) VALUES (1, N'Mostar')
INSERT [dbo].[Cities] ([Id], [Name]) VALUES (2, N'Sarajevo')
INSERT [dbo].[Cities] ([Id], [Name]) VALUES (3, N'Banja Luka')
INSERT [dbo].[Cities] ([Id], [Name]) VALUES (4, N'Zenica')
INSERT [dbo].[Cities] ([Id], [Name]) VALUES (5, N'Livno')
INSERT [dbo].[Cities] ([Id], [Name]) VALUES (6, N'Trebinje')
SET IDENTITY_INSERT [dbo].[Cities] OFF
GO
SET IDENTITY_INSERT [dbo].[OrderDetails] ON 

INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (1, 1, 1, 2, 350, 700, 700, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (2, 1, 2, 1, 250, 250, 225, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (3, 2, 1, 5, 350, 1750, 1750, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (4, 2, 2, 1, 250, 250, 225, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (5, 3, 3, 4, 400, 1600, 1600, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (6, 3, 2, 3, 250, 750, 675, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (7, 4, 3, 2, 400, 800, 800, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (8, 4, 1, 1, 350, 350, 350, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (9, 5, 6, 1, 45, 45, 45, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (10, 6, 9, 2, 310, 620, 620, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (11, 7, 7, 1, 125, 125, 106.25, 0.15)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (12, 8, 15, 1, 170, 170, 170, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (13, 8, 22, 1, 85, 85, 80.75, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (14, 9, 11, 2, 70, 140, 133, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (15, 9, 3, 1, 400, 400, 400, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (16, 10, 6, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (17, 10, 12, 1, 550, 550, 550, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (18, 10, 7, 1, 125, 125, 106.25, 0.15)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (19, 11, 2, 1, 120, 120, 108, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (20, 11, 3, 1, 400, 400, 400, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (21, 12, 1, 1, 350, 350, 350, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (22, 12, 22, 1, 85, 85, 80.75, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (23, 13, 12, 2, 550, 1100, 1100, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (24, 13, 1, 1, 350, 350, 350, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (25, 13, 18, 1, 22.99, 22.99, 22.99, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (26, 14, 22, 1, 85, 85, 80.75, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (27, 14, 15, 1, 170, 170, 170, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (28, 14, 5, 1, 300, 300, 300, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (29, 15, 6, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (30, 16, 18, 2, 22.99, 45.98, 45.98, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (31, 17, 1, 2, 350, 700, 700, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (32, 18, 12, 2, 550, 1100, 1100, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (33, 19, 5, 4, 300, 1200, 1200, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (34, 20, 10, 1, 20, 20, 20, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (35, 21, 1, 2, 350, 700, 700, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (36, 21, 12, 2, 550, 1100, 1100, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (37, 22, 5, 4, 300, 1200, 1200, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (38, 22, 11, 2, 70, 140, 133, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (39, 22, 22, 1, 85, 85, 80.75, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (40, 23, 23, 2, 300, 600, 540, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (41, 23, 26, 1, 20, 20, 20, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (42, 24, 25, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (43, 24, 28, 1, 55, 55, 55, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (44, 24, 29, 1, 47, 47, 47, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (45, 25, 23, 4, 300, 1200, 1080, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (46, 25, 24, 1, 25, 25, 25, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (47, 26, 29, 1, 47, 47, 47, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (48, 26, 28, 2, 55, 110, 110, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (49, 27, 24, 2, 25, 50, 50, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (50, 27, 27, 1, 85, 85, 85, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (51, 27, 25, 1, 45, 45, 45, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (52, 28, 15, 3, 170, 510, 510, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (53, 28, 6, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (54, 28, 18, 1, 22.99, 22.99, 22.99, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (55, 29, 3, 2, 400, 800, 800, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (56, 29, 9, 1, 310, 310, 310, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (57, 30, 8, 2, 96.99, 193.98, 193.98, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (58, 31, 2, 3, 120, 360, 324, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (59, 31, 18, 1, 22.99, 22.99, 22.99, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (60, 32, 5, 1, 300, 300, 300, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (61, 32, 6, 1, 45, 45, 45, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (62, 33, 15, 2, 170, 340, 340, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (63, 33, 5, 1, 300, 300, 300, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (64, 34, 28, 2, 55, 110, 110, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (65, 34, 23, 2, 300, 600, 540, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (66, 35, 28, 2, 55, 110, 110, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (67, 35, 23, 2, 300, 600, 540, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (68, 36, 26, 1, 20, 20, 20, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (69, 36, 25, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (70, 36, 27, 2, 85, 170, 170, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (71, 37, 6, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (72, 37, 12, 1, 550, 550, 550, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (73, 38, 21, 1, 280, 280, 280, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (74, 39, 26, 2, 20, 40, 40, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (75, 39, 23, 1, 300, 300, 270, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (76, 39, 24, 1, 25, 25, 25, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (77, 40, 29, 2, 47, 94, 94, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (78, 40, 28, 1, 55, 55, 55, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (79, 40, 25, 1, 45, 45, 45, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (80, 41, 23, 1, 300, 300, 270, 0.1)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (81, 41, 24, 2, 25, 50, 50, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (82, 42, 21, 1, 280, 280, 280, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (83, 43, 15, 2, 170, 340, 340, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (84, 43, 12, 1, 550, 550, 550, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (85, 44, 13, 1, 360, 360, 360, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (86, 45, 6, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (87, 45, 1, 1, 350, 350, 350, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (88, 46, 6, 2, 45, 90, 90, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (89, 46, 19, 1, 225, 225, 225, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (90, 47, 15, 2, 170, 340, 340, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (91, 48, 1, 1, 350, 350, 350, 0)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (92, 49, 11, 2, 70, 140, 133, 0.05)
INSERT [dbo].[OrderDetails] ([Id], [OrderId], [StoreItemId], [Quantity], [UnitPrice], [TotalItemsPrice], [TotalItemsPriceDiscounted], [Discount]) VALUES (93, 50, 7, 1, 125, 125, 106.25, 0.15)
SET IDENTITY_INSERT [dbo].[OrderDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Orders] ON 

INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (1, 2, 3, NULL, CAST(N'2024-10-05T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 804.75, 4, N'accepted', 1, N'Kralja Tvrtka I bb', N'80101', NULL, 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (2, 2, 3, NULL, CAST(N'2024-10-05T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), 1718.25, 4, N'accepted', 1, N'Kralja Tvrtka I bb', N'80101', NULL, 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (3, 2, NULL, 4, CAST(N'2024-10-05T00:00:00.0000000' AS DateTime2), NULL, 1979.25, 2, N'rejected', 1, N'Kralja Tvrtka I bb', N'80101', NULL, 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (4, 2, NULL, 4, CAST(N'2024-10-06T00:00:00.0000000' AS DateTime2), NULL, 1000.5, 2, N'cancelled', 1, N'Kralja Tvrtka I bb', N'80101', NULL, 1, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (5, 2, NULL, 4, CAST(N'2024-10-06T01:56:27.9041815' AS DateTime2), CAST(N'2024-11-10T00:00:00.0000000' AS DateTime2), 38.25, 2, N'accepted', 1, N'Bulevar 4', N'88000', N'pi_3QGVdj2M5E7IFmhL1GB9mw6y', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (6, 2, NULL, 4, CAST(N'2024-10-07T02:56:59.8744261' AS DateTime2), CAST(N'2024-11-14T00:00:00.0000000' AS DateTime2), 527, 2, N'accepted', 1, N'Bulevar 4', N'88000', N'pi_3QGWaI2M5E7IFmhL1Rf771Js', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (7, 2, NULL, 4, CAST(N'2024-10-07T19:17:39.2893456' AS DateTime2), NULL, 90.3125, 2, N'rejected', 1, N'Bulevar 4', N'88000', N'pi_3QGltK2M5E7IFmhL1mGqpg9X', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (8, 2, NULL, 4, CAST(N'2024-10-08T19:20:55.2530990' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 213.1375, 2, N'accepted', 6, N'Avenija 88', N'87000', N'pi_3QGlwT2M5E7IFmhL0HskysaQ', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (9, 2, NULL, 4, CAST(N'2024-10-08T19:59:21.1966778' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 533, NULL, N'accepted', 1, N'Bulevar 4', N'88000', N'pi_3QGmXf2M5E7IFmhL1eT7A9UX', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (10, 2, 3, NULL, CAST(N'2024-10-09T23:23:28.8213927' AS DateTime2), NULL, 649.2375, 4, N'rejected', 1, N'Bulevar 3', N'88000', N'pi_3QGpjC2M5E7IFmhL0dSP2Awo', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (11, 2, 3, NULL, CAST(N'2024-10-10T23:25:57.4436035' AS DateTime2), CAST(N'2024-11-14T00:00:00.0000000' AS DateTime2), 441.96, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGpla2M5E7IFmhL0GHWuQRU', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (12, 2, 3, NULL, CAST(N'2024-10-10T00:03:22.3611723' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 374.7525, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGqLp2M5E7IFmhL1ydGd9sf', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (13, 2, 3, NULL, CAST(N'2024-10-11T00:04:03.3083901' AS DateTime2), NULL, 1281.5013, 4, N'rejected', 1, N'Bulevar 3', N'88000', N'pi_3QGqMS2M5E7IFmhL0Hxq7GD4', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (14, 2, 3, NULL, CAST(N'2024-10-11T00:04:35.1881382' AS DateTime2), CAST(N'2024-11-07T00:00:00.0000000' AS DateTime2), 479.15250000000003, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGqMy2M5E7IFmhL1m8gcDps', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (15, 2, 3, NULL, CAST(N'2024-10-09T00:16:21.2656583' AS DateTime2), NULL, 78.3, 4, N'rejected', 1, N'Bulevar 3', N'88000', N'pi_3QGqYM2M5E7IFmhL1NZgRrZ3', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (16, 2, 3, NULL, CAST(N'2024-10-12T00:16:47.0692632' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 40.0026, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGqYl2M5E7IFmhL05fCpfDd', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (17, 2, 3, NULL, CAST(N'2024-10-12T00:20:16.4190721' AS DateTime2), CAST(N'2024-11-09T00:00:00.0000000' AS DateTime2), 609, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGqc92M5E7IFmhL0cOWe66T', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (18, 2, 3, NULL, CAST(N'2024-10-13T00:21:08.8302278' AS DateTime2), CAST(N'2024-11-07T00:00:00.0000000' AS DateTime2), 957, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGqcz2M5E7IFmhL0sde7SyW', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (19, 2, 3, NULL, CAST(N'2024-10-13T00:21:32.7974294' AS DateTime2), CAST(N'2024-11-10T00:00:00.0000000' AS DateTime2), 1044, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QGqdN2M5E7IFmhL167AIlEg', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (20, 2, NULL, 5, CAST(N'2024-10-14T03:18:04.4079543' AS DateTime2), NULL, 20, NULL, N'rejected', 2, N'Kulina Bana bb', N'71000', N'pi_3QGtOE2M5E7IFmhL1tsMd1fU', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (21, 2, NULL, 5, CAST(N'2024-10-14T03:29:48.7775791' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 1800, NULL, N'accepted', 2, N'Kulina Bana bb', N'71000', N'pi_3QGtZa2M5E7IFmhL0ahThgDI', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (22, 2, NULL, 6, CAST(N'2024-10-15T03:40:11.6579207' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 1413.75, NULL, N'accepted', 5, N'Kraljice Katarine 32', N'80101', N'pi_3QGtje2M5E7IFmhL1lKEq3NV', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (23, 7, 8, NULL, CAST(N'2024-10-16T01:46:30.6005790' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 560, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHERB2M5E7IFmhL0UjjcdBJ', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (24, 7, 8, NULL, CAST(N'2024-10-17T01:46:43.6295349' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 192, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHERN2M5E7IFmhL0TzEgryf', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (25, 7, 8, NULL, CAST(N'2024-10-18T01:46:51.8167801' AS DateTime2), NULL, 1105, NULL, N'paymentfailed', 3, N'Bulevar 14', N'78000', N'pi_3QHERV2M5E7IFmhL1nx2nT5N', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (26, 7, 8, NULL, CAST(N'2024-10-19T01:47:35.3650176' AS DateTime2), CAST(N'2024-11-10T00:00:00.0000000' AS DateTime2), 157, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHESD2M5E7IFmhL1MKlBdTr', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (27, 7, 8, NULL, CAST(N'2024-10-20T01:47:44.0935786' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 180, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHESM2M5E7IFmhL1BuveauB', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (28, 2, 8, NULL, CAST(N'2024-10-21T01:48:00.5262552' AS DateTime2), CAST(N'2024-11-12T00:00:00.0000000' AS DateTime2), 622.99, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHESc2M5E7IFmhL0aFIZYkI', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (29, 2, 8, NULL, CAST(N'2024-10-22T01:48:27.0732988' AS DateTime2), CAST(N'2024-11-13T00:00:00.0000000' AS DateTime2), 1110, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHET32M5E7IFmhL0rA4pXf3', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (30, 2, 8, NULL, CAST(N'2024-10-23T01:48:36.1574264' AS DateTime2), CAST(N'2024-11-10T00:00:00.0000000' AS DateTime2), 193.98, NULL, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHETC2M5E7IFmhL1uDslF8V', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (31, 2, 8, NULL, CAST(N'2024-10-24T01:49:04.7092401' AS DateTime2), NULL, 346.99, NULL, N'paymentfailed', 3, N'Kulina bana 55', N'77000', N'pi_3QHETe2M5E7IFmhL0QlfpGvU', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (32, 2, NULL, 5, CAST(N'2024-10-25T02:18:21.5337850' AS DateTime2), CAST(N'2024-11-07T00:00:00.0000000' AS DateTime2), 345, NULL, N'accepted', 2, N'Kulina Bana bb', N'71000', N'pi_3QHEw02M5E7IFmhL1fOKN6Cf', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (33, 2, NULL, 5, CAST(N'2024-10-26T02:19:26.6754594' AS DateTime2), NULL, 640, NULL, N'paymentfailed', 2, N'Kulina Bana bb', N'71000', N'pi_3QHEx32M5E7IFmhL1XM0Bh9q', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (34, 7, NULL, 5, CAST(N'2024-10-27T02:28:53.3219017' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 650, NULL, N'accepted', 2, N'Kulina Bana bb', N'71000', N'pi_3QHF6B2M5E7IFmhL0HwwJWbK', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (35, 7, NULL, 5, CAST(N'2024-10-28T02:28:53.7966157' AS DateTime2), NULL, 650, NULL, N'rejected', 2, N'Kulina Bana bb', N'71000', N'pi_3QHF6B2M5E7IFmhL0jJhwaDA', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (36, 7, NULL, 5, CAST(N'2024-10-29T02:29:57.7413746' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 280, NULL, N'accepted', 2, N'Kulina Bana bb', N'71000', N'pi_3QHF7D2M5E7IFmhL0KOpEy4p', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (37, 2, 3, NULL, CAST(N'2024-10-30T02:38:02.9296315' AS DateTime2), CAST(N'2024-11-30T00:00:00.0000000' AS DateTime2), 556.8, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QHFF12M5E7IFmhL0WNRCsqr', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (38, 2, 3, NULL, CAST(N'2024-10-31T02:38:13.0093147' AS DateTime2), NULL, 243.6, 4, N'onhold', 1, N'Bulevar 3', N'88000', N'pi_3QHFFB2M5E7IFmhL08nD6FHd', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (39, 7, 3, NULL, CAST(N'2024-11-01T02:38:33.6454081' AS DateTime2), NULL, 335, NULL, N'onhold', 1, N'Bulevar 3', N'88000', N'pi_3QHFFW2M5E7IFmhL1DFTdmUP', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (40, 7, 3, NULL, CAST(N'2024-11-01T02:38:43.8610553' AS DateTime2), CAST(N'2024-11-10T00:00:00.0000000' AS DateTime2), 194, NULL, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QHFFg2M5E7IFmhL0vHwZJhs', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (41, 7, 3, NULL, CAST(N'2024-11-02T02:39:04.0312191' AS DateTime2), NULL, 320, NULL, N'onhold', 1, N'Bulevar 3', N'88000', N'pi_3QHFG02M5E7IFmhL0WiSTI3r', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (42, 2, 3, NULL, CAST(N'2024-11-02T02:39:16.8858884' AS DateTime2), NULL, 243.6, 4, N'paymentfailed', 1, N'Bulevar 3', N'88000', N'pi_3QHFGD2M5E7IFmhL0fT6he7P', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (43, 2, 8, NULL, CAST(N'2024-11-03T03:24:21.2900982' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), 845.5, 5, N'accepted', 3, N'Bulevar 14', N'78000', N'pi_3QHFxq2M5E7IFmhL0vPe98Vj', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (44, 2, NULL, 4, CAST(N'2024-11-04T23:20:18.2462072' AS DateTime2), NULL, 334.8, 13, N'onhold', 1, N'Bulevar 4', N'88000', N'pi_3QHYdE2M5E7IFmhL1g1BYi3x', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (45, 2, 3, NULL, CAST(N'2024-11-05T23:55:01.5573361' AS DateTime2), NULL, 382.8, 4, N'cancelled', 1, N'Bulevar 3', N'88000', N'pi_3QHZAp2M5E7IFmhL0cASi9cB', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (46, 2, 3, NULL, CAST(N'2024-11-05T23:55:37.9333189' AS DateTime2), NULL, 274.05, 4, N'missingpayment', 1, N'Bulevar 3', N'88000', NULL, 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (47, 2, 3, NULL, CAST(N'2024-10-15T02:00:36.5651008' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 295.8, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QHb8L2M5E7IFmhL09l2sU5t', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (48, 2, 3, NULL, CAST(N'2024-11-03T02:00:43.4444914' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), 304.5, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QHb8S2M5E7IFmhL0iwfVGcI', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (49, 2, 3, NULL, CAST(N'2024-11-03T02:00:50.0761745' AS DateTime2), CAST(N'2024-11-08T00:00:00.0000000' AS DateTime2), 115.71000000000001, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QHb8Y2M5E7IFmhL0WyZCO23', 0, 0)
INSERT [dbo].[Orders] ([Id], [CarPartsShopId], [CarRepairShopId], [ClientId], [OrderDate], [ShippingDate], [TotalAmount], [ClientDiscountId], [State], [CityId], [ShippingAddress], [ShippingPostalCode], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (50, 2, 3, NULL, CAST(N'2024-11-04T02:01:01.0887985' AS DateTime2), CAST(N'2024-11-07T00:00:00.0000000' AS DateTime2), 92.4375, 4, N'accepted', 1, N'Bulevar 3', N'88000', N'pi_3QHb8j2M5E7IFmhL0m7EYWAn', 0, 0)
SET IDENTITY_INSERT [dbo].[Orders] OFF
GO
SET IDENTITY_INSERT [dbo].[ReservationDetails] ON 

INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (1, 1, 14, N'Battery Health Check', 25, 0, 25)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (2, 1, 15, N'Brake System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (3, 1, 18, N'Electrical System Diagnostic', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (4, 2, 14, N'Battery Health Check', 25, 0, 25)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (5, 2, 15, N'Brake System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (6, 3, 1, N'Front Brakes Repair', 50, 0.05, 47.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (7, 4, 21, N'Exhaust Emissions Test', 30, 0.1, 27)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (8, 4, 20, N'Fuel System Diagnostic', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (9, 5, 13, N'Warning and Error Lights Diagnostic', 30, 0.05, 28.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (10, 5, 18, N'Electrical System Diagnostic', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (11, 6, 9, N'Engine Overhaul', 300, 0, 300)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (12, 7, 14, N'Battery Health Check', 25, 0, 25)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (13, 7, 5, N'Battery Replacement', 20, 0.05, 19)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (14, 8, 3, N'Tire Replacement', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (15, 9, 19, N'Air Conditioning System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (16, 9, 14, N'Battery Health Check', 25, 0, 25)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (17, 9, 4, N'Oil Change', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (18, 9, 2, N'Rear Brakes Repair', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (19, 10, 5, N'Battery Replacement', 20, 0.05, 19)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (20, 11, 19, N'Air Conditioning System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (21, 11, 14, N'Battery Health Check', 25, 0, 25)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (22, 11, 7, N'Clutch Replacement', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (23, 12, 5, N'Battery Replacement', 20, 0.05, 19)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (24, 12, 2, N'Rear Brakes Repair', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (25, 12, 4, N'Oil Change', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (26, 12, 11, N'Transmission Repair', 260, 0.03, 252.2)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (27, 13, 19, N'Air Conditioning System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (28, 13, 18, N'Electrical System Diagnostic', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (29, 13, 15, N'Brake System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (30, 14, 3, N'Tire Replacement', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (31, 14, 10, N'Timing Belt Replacement', 60, 0, 60)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (32, 15, 13, N'Warning and Error Lights Diagnostic', 30, 0.05, 28.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (33, 15, 17, N'Transmission Diagnostic', 70, 0.05, 66.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (34, 15, 20, N'Fuel System Diagnostic', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (35, 16, 30, N'Air Conditioning System Diagnostics', 35, 0.02, 34.3)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (36, 16, 25, N'Air Conditioning Recharge', 30, 0.05, 28.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (37, 16, 24, N'Fuel Injector Cleaning', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (38, 17, 27, N'Serpentine Belt Replacement', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (39, 17, 26, N'Power Steering Pump Replacement', 65, 0, 65)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (40, 17, 29, N'Fuel System Diagnostics', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (41, 18, 31, N'Brake System Inspection', 65, 0, 65)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (42, 18, 28, N'Emissions Test', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (43, 18, 30, N'Air Conditioning System Diagnostics', 35, 0.02, 34.3)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (44, 19, 25, N'Air Conditioning Recharge', 30, 0.05, 28.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (45, 19, 24, N'Fuel Injector Cleaning', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (46, 19, 26, N'Power Steering Pump Replacement', 65, 0, 65)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (47, 20, 31, N'Brake System Inspection', 65, 0, 65)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (48, 20, 30, N'Air Conditioning System Diagnostics', 35, 0.02, 34.3)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (49, 20, 25, N'Air Conditioning Recharge', 30, 0.05, 28.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (50, 21, 15, N'Brake System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (51, 21, 7, N'Clutch Replacement', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (52, 22, 25, N'Air Conditioning Recharge', 30, 0.05, 28.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (53, 22, 30, N'Air Conditioning System Diagnostics', 35, 0.02, 34.3)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (54, 23, 31, N'Brake System Inspection', 65, 0, 65)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (55, 23, 28, N'Emissions Test', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (56, 24, 22, N'Wheel Alignment', 50, 0, 50)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (57, 24, 27, N'Serpentine Belt Replacement', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (58, 24, 23, N'Head Gasket Repair', 95, 0, 95)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (59, 25, 7, N'Clutch Replacement', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (60, 26, 27, N'Serpentine Belt Replacement', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (61, 26, 26, N'Power Steering Pump Replacement', 65, 0, 65)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (62, 27, 7, N'Clutch Replacement', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (63, 28, 7, N'Clutch Replacement', 120, 0, 120)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (64, 28, 18, N'Electrical System Diagnostic', 40, 0, 40)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (65, 29, 19, N'Air Conditioning System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (66, 29, 15, N'Brake System Diagnostic', 30, 0, 30)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (67, 30, 9, N'Engine Overhaul', 300, 0, 300)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (68, 31, 11, N'Transmission Repair', 260, 0.03, 252.2)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (69, 32, 9, N'Engine Overhaul', 300, 0, 300)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (70, 33, 1, N'Front Brakes Repair', 50, 0.05, 47.5)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (71, 33, 4, N'Oil Change', 45, 0, 45)
INSERT [dbo].[ReservationDetails] ([Id], [ReservationId], [CarRepairShopServiceId], [ServiceName], [ServicePrice], [ServiceDiscount], [ServiceDiscountedPrice]) VALUES (72, 33, 2, N'Rear Brakes Repair', 40, 0, 40)
SET IDENTITY_INSERT [dbo].[ReservationDetails] OFF
GO
SET IDENTITY_INSERT [dbo].[Reservations] ON 

INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (1, 3, 4, NULL, NULL, CAST(N'2024-10-08T01:24:07.5219340' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-06T00:00:00.0000000' AS DateTime2), NULL, 95, 22, CAST(N'05:00:00' AS Time), NULL, N'accepted', N'Diagnostics', N'pi_3QGV8R2M5E7IFmhL1OzkKvoZ', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (2, 3, 4, NULL, NULL, CAST(N'2024-10-09T01:29:53.7820370' AS DateTime2), CAST(N'2024-11-28T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-28T00:00:00.0000000' AS DateTime2), NULL, 55, 32, CAST(N'03:00:00' AS Time), NULL, N'accepted', N'Diagnostics', N'pi_3QGVDz2M5E7IFmhL0lXkNdZt', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (3, 3, 4, 16, 0, CAST(N'2024-10-10T01:32:13.0768911' AS DateTime2), CAST(N'2024-11-07T00:00:00.0000000' AS DateTime2), NULL, NULL, 47.5, 1, CAST(N'02:00:00' AS Time), NULL, N'rejected', N'Repairs', N'pi_3QGVGH2M5E7IFmhL1DISTPsY', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (4, 3, 4, NULL, NULL, CAST(N'2024-10-11T01:37:10.2503110' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), NULL, 67, 14, CAST(N'03:00:00' AS Time), NULL, N'accepted', N'Diagnostics', N'pi_3QGVL22M5E7IFmhL19hCSAtc', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (5, 3, 4, NULL, NULL, CAST(N'2024-10-12T01:40:49.2085579' AS DateTime2), CAST(N'2024-11-15T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-15T00:00:00.0000000' AS DateTime2), NULL, 68.5, 10, CAST(N'03:00:00' AS Time), NULL, N'accepted', N'Diagnostics', N'pi_3QGVOb2M5E7IFmhL11zUzTqP', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (6, 3, 4, NULL, 1, CAST(N'2024-10-13T02:30:22.5885052' AS DateTime2), CAST(N'2024-11-12T00:00:00.0000000' AS DateTime2), NULL, NULL, 300, 57, CAST(N'06:00:00' AS Time), NULL, N'awaitingorder', N'Repairs', N'pi_3QGWAX2M5E7IFmhL1Qtv773i', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (7, 3, 4, NULL, 0, CAST(N'2024-10-14T02:33:29.6910837' AS DateTime2), CAST(N'2024-11-05T00:00:00.0000000' AS DateTime2), NULL, NULL, 44, 17, CAST(N'02:00:00' AS Time), NULL, N'cancelled', N'Repairs and Diagnostics', N'pi_3QGWDY2M5E7IFmhL0tqwNLDl', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (8, 3, 4, 6, 1, CAST(N'2024-10-15T02:48:38.8828748' AS DateTime2), CAST(N'2024-11-15T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-15T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-04T03:04:35.3789520' AS DateTime2), 30, 60, CAST(N'01:00:00' AS Time), NULL, N'completed', N'Repairs', N'pi_3QGWSD2M5E7IFmhL09E9a8Ok', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (9, 3, 4, 18, 0, CAST(N'2024-10-16T22:11:29.4893751' AS DateTime2), CAST(N'2024-11-13T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-13T00:00:00.0000000' AS DateTime2), NULL, 140, 29, CAST(N'06:00:00' AS Time), NULL, N'accepted', N'Repairs and Diagnostics', N'pi_3QGobY2M5E7IFmhL1M6CWenf', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (10, 3, 4, 11, 0, CAST(N'2024-10-17T02:40:05.1003735' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, 19, 22, CAST(N'01:00:00' AS Time), NULL, N'accepted', N'Repairs', N'pi_3QGsnV2M5E7IFmhL0HNsXiLv', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (11, 3, 5, NULL, 1, CAST(N'2024-10-18T03:09:12.2488247' AS DateTime2), CAST(N'2024-11-20T00:00:00.0000000' AS DateTime2), NULL, NULL, 175, 15, CAST(N'07:00:00' AS Time), NULL, N'awaitingorder', N'Repairs and Diagnostics', N'pi_3QGtFe2M5E7IFmhL1dso7Wka', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (12, 3, 5, 19, 0, CAST(N'2024-10-19T03:26:06.5387295' AS DateTime2), CAST(N'2024-11-20T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-20T00:00:00.0000000' AS DateTime2), NULL, 356.2, 50, CAST(N'09:00:00' AS Time), NULL, N'overbooked', N'Repairs', N'pi_3QGtW32M5E7IFmhL1Fam6SGS', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (13, 3, 5, NULL, NULL, CAST(N'2024-10-20T03:28:34.1093354' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), NULL, NULL, 100, 31, CAST(N'06:00:00' AS Time), NULL, N'ready', N'Diagnostics', N'pi_3QGtYO2M5E7IFmhL1g3qGrpm', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (14, 3, 6, 37, 0, CAST(N'2024-10-21T03:43:34.6738341' AS DateTime2), CAST(N'2024-11-29T00:00:00.0000000' AS DateTime2), NULL, NULL, 90, 32, CAST(N'03:00:00' AS Time), NULL, N'orderdateconflict', N'Repairs', N'pi_3QGtmv2M5E7IFmhL1uhcbf7G', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (15, 3, 6, NULL, NULL, CAST(N'2024-10-22T03:44:54.3810854' AS DateTime2), CAST(N'2024-11-28T00:00:00.0000000' AS DateTime2), NULL, NULL, 135, 7, CAST(N'06:00:00' AS Time), NULL, N'rejected', N'Diagnostics', N'pi_3QGtoC2M5E7IFmhL1Yx7FIHj', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (16, 8, 4, NULL, 0, CAST(N'2024-10-23T02:02:51.3733583' AS DateTime2), CAST(N'2024-11-21T00:00:00.0000000' AS DateTime2), NULL, NULL, 182.8, 44, CAST(N'05:00:00' AS Time), NULL, N'awaitingorder', N'Repairs and Diagnostics', N'pi_3QHEh12M5E7IFmhL1hF7RChL', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (17, 8, 4, NULL, 0, CAST(N'2024-10-24T02:03:58.2812171' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, NULL, 155, 12, CAST(N'05:30:00' AS Time), NULL, N'awaitingorder', N'Repairs and Diagnostics', N'pi_3QHEi52M5E7IFmhL1XVDmR3I', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (18, 8, 4, NULL, NULL, CAST(N'2024-10-25T02:04:57.2051655' AS DateTime2), CAST(N'2024-11-21T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-21T00:00:00.0000000' AS DateTime2), NULL, 129.3, 24, CAST(N'04:00:00' AS Time), NULL, N'accepted', N'Diagnostics', N'pi_3QHEj22M5E7IFmhL1s5JpAgb', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (19, 8, 4, 9, 1, CAST(N'2024-10-26T02:08:08.1419739' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), NULL, 213.5, 34, CAST(N'06:00:00' AS Time), NULL, N'accepted', N'Repairs', N'pi_3QHEm72M5E7IFmhL1TdqTR6y', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (20, 8, 4, NULL, 0, CAST(N'2024-10-27T02:11:04.3625323' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, NULL, 127.8, 55, CAST(N'04:00:00' AS Time), NULL, N'paymentfailed', N'Repairs and Diagnostics', N'pi_3QHEox2M5E7IFmhL1GNeWtV0', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (21, 3, 5, 17, 0, CAST(N'2024-10-28T02:13:57.0511474' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, 150, 56, CAST(N'06:00:00' AS Time), NULL, N'ongoing', N'Repairs and Diagnostics', N'pi_3QHErk2M5E7IFmhL1ag2Nt1T', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (22, 8, 5, NULL, 1, CAST(N'2024-10-29T02:14:57.8490172' AS DateTime2), CAST(N'2024-11-22T00:00:00.0000000' AS DateTime2), NULL, NULL, 62.8, 30, CAST(N'02:00:00' AS Time), NULL, N'awaitingorder', N'Repairs and Diagnostics', N'pi_3QHEsi2M5E7IFmhL1gR9A098', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (23, 8, 5, NULL, NULL, CAST(N'2024-10-30T02:15:58.6583278' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-25T00:00:00.0000000' AS DateTime2), NULL, 95, 3, CAST(N'03:00:00' AS Time), NULL, N'accepted', N'Diagnostics', N'pi_3QHEth2M5E7IFmhL1P4q4oQk', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (24, 8, 5, NULL, 0, CAST(N'2024-10-31T02:17:01.4438204' AS DateTime2), CAST(N'2024-11-28T00:00:00.0000000' AS DateTime2), NULL, NULL, 190, 37, CAST(N'05:30:00' AS Time), NULL, N'paymentfailed', N'Repairs', N'pi_3QHEui2M5E7IFmhL1ZRd1nZ1', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (25, 3, 4, 41, 0, CAST(N'2024-11-01T23:16:20.1466207' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, NULL, 117.6, 20, CAST(N'04:00:00' AS Time), 2, N'orderpendingapproval', N'Repairs', N'pi_3QHYZQ2M5E7IFmhL1KE7o3qy', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (26, 8, 5, NULL, 0, CAST(N'2024-11-02T23:26:46.7068779' AS DateTime2), CAST(N'2024-11-15T00:00:00.0000000' AS DateTime2), NULL, NULL, 100.1, 27, CAST(N'03:30:00' AS Time), 8, N'awaitingorder', N'Repairs', N'pi_3QHYjU2M5E7IFmhL1eXXwIQS', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (27, 3, 4, NULL, 0, CAST(N'2024-11-03T00:04:20.5516467' AS DateTime2), CAST(N'2024-12-03T00:00:00.0000000' AS DateTime2), NULL, NULL, 117.6, 59, CAST(N'04:00:00' AS Time), 2, N'awaitingorder', N'Repairs', N'pi_3QHZJq2M5E7IFmhL14eRzTFz', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (28, 3, 4, NULL, 0, CAST(N'2024-11-04T00:05:20.6059998' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, NULL, 156.8, 33, CAST(N'06:00:00' AS Time), 2, N'paymentfailed', N'Repairs and Diagnostics', N'pi_3QHZKo2M5E7IFmhL0DWdyy8w', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (29, 3, 4, NULL, NULL, CAST(N'2024-11-05T00:06:32.5396865' AS DateTime2), CAST(N'2024-11-19T00:00:00.0000000' AS DateTime2), NULL, NULL, 58.8, 35, CAST(N'04:00:00' AS Time), 2, N'missingpayment', N'Diagnostics', NULL, 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (30, 3, 6, 47, 0, CAST(N'2024-10-20T01:54:59.5167320' AS DateTime2), CAST(N'2024-11-27T00:00:00.0000000' AS DateTime2), CAST(N'2024-11-27T00:00:00.0000000' AS DateTime2), NULL, 300, 50, CAST(N'06:00:00' AS Time), NULL, N'accepted', N'Repairs', N'pi_3QHb2y2M5E7IFmhL09XeV3ji', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (31, 3, 6, 48, 0, CAST(N'2024-10-21T01:56:09.0997146' AS DateTime2), CAST(N'2024-12-12T00:00:00.0000000' AS DateTime2), CAST(N'2024-12-12T00:00:00.0000000' AS DateTime2), NULL, 252.2, 4, CAST(N'05:00:00' AS Time), NULL, N'accepted', N'Repairs', N'pi_3QHb432M5E7IFmhL1fIQdOEq', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (32, 3, 6, 49, 0, CAST(N'2024-11-02T01:56:59.3316898' AS DateTime2), CAST(N'2024-12-09T00:00:00.0000000' AS DateTime2), CAST(N'2024-12-09T00:00:00.0000000' AS DateTime2), NULL, 300, 41, CAST(N'06:00:00' AS Time), NULL, N'accepted', N'Repairs', N'pi_3QHb4r2M5E7IFmhL14uZygCh', 0, 0)
INSERT [dbo].[Reservations] ([Id], [CarRepairShopId], [ClientId], [OrderId], [ClientOrder], [ReservationCreatedDate], [ReservationDate], [EstimatedCompletionDate], [CompletionDate], [TotalAmount], [CarModelId], [TotalDuration], [CarRepairShopDiscountId], [State], [Type], [PaymentIntentId], [DeletedByShop], [DeletedByCustomer]) VALUES (33, 3, 6, 50, 0, CAST(N'2024-11-03T01:57:49.8189702' AS DateTime2), CAST(N'2024-12-13T00:00:00.0000000' AS DateTime2), CAST(N'2024-12-13T00:00:00.0000000' AS DateTime2), NULL, 132.5, 22, CAST(N'05:00:00' AS Time), NULL, N'accepted', N'Repairs', N'pi_3QHb5f2M5E7IFmhL0CliIOi5', 0, 0)
SET IDENTITY_INSERT [dbo].[Reservations] OFF
GO
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (1, N'admin', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (2, N'client', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (3, N'carrepairshop', NULL)
INSERT [dbo].[Roles] ([Id], [Name], [Description]) VALUES (4, N'carpartsshop', NULL)
SET IDENTITY_INSERT [dbo].[Roles] OFF
GO
SET IDENTITY_INSERT [dbo].[ServiceTypes] ON 

INSERT [dbo].[ServiceTypes] ([Id], [Name], [Image]) VALUES (1, N'Repairs', 0x89504E470D0A1A0A0000000D494844520000006400000064080600000070E295540000000473424954080808087C08648800000C2E49444154789CED9D79905C5515C67F7732996C401276C322A001241030025208C55A0A0865A1258516288B2188ECC52602058A2888B20B289BB8550165812046A1C44A8C1016512440113442C40A088901B23133FDF9C7775FFA4D4FF74CCFF4EBEE97E47D55EF8F79F3BAEFB9E77BF79E73CF39F736142850A001481A21693349EBB55B96351592C648DA44D28846BF6892A40725BD2AE97149BB6724E33A0349BB4B9A2D6981A487244D1AEE174D94344B7DF19AA46DB21579ED85A42D252DACD0E12C49136B7DA66380EFDB039852716F2BE0F42C845D477004B065C5BD2958B755311021E36AFCBF98B6EA47B591D081755B150311520BA386F199751543D6EF700809C3F84C813A311C420A3411052139434148CE501092331484E40C052139434148CED0D96E01002475001B001B011B028D4545EB470978077803581A4228B5A8DD9A683B219246019F06BE0CEC8789692556027F047E2CE9E110C2AA16B7DF076D27043806B804072EDB110518031C82837E1B02B7B74186D568AB0D913419B892F69191204419AE8C32B50D6D2344D2683C3236221FF1B18065B924CAD616B485104901382C5E79C361C06151C696A35D23640BE04BC0F836B53F10C663D9B66847E32D2724BAB8070107B4A3FD3AD081653B28CADAF2C65B8DCD801381F5C987EDA844C0B29D88656D291A767B258DC42EE3E694095E05CC07168610947A360027007B934F3212042CE30992AEA8D287AD80C994B3A7256011302F84D0DD48C359AC438E014E032651266425F002F06D6076EAD969B848A2552BF1463002CB3A137826757F1FE01BC04E40E28D9580FF0037007736451A49474A5AA2FE7832F5CC54498B2595AA3C5792F4ACA4AEF8EC2849F7D77836AF28C9328F8A7DE892FB54ABBF8B254D4DE9E7A22ACF2D9174642DBD376A433E812B2BAA4D3F01D815D82DFE7D787CBE17E85943AEDE28F3E1B10FBBC53ED5EAEFC4F8FCB0D1E894F522F02E3682D5B00A48E6D4C5C06DC0C806DB6C35DEC7B283FBB28AF254558977B14E868D4609F933701EF049ECBF8F0776C6C66E257023F092A40D81A954AF53CA3B7A81AD258D015EC27D3A1593B20A781E581AAFDF639D0C1B0D111242785FD26DC02FB1111C11853D0FF821700D7001F02416FE733880B7266111F0205E9BEC0D5C8BA7FA5380AB3041BDF15A1642E869A4B186BDAC28C0D2E46F493700FF051EC5847C1EBBC06702D3819BB17F9F67B71740384F7272FCFB07C0F6D8DDBD147805B82784F076968D66BE300C21BC85DFA87381CF60C52751DD1EDCC16728DB963CA21BCB783226E62A4C46C07D3A0778386B32A00984447B71317014D0156F076C5BAE037604CEC723A8A1E1DD24F4028F611977C432EF4C794477E1BE5D1CFB9A299A113A39092F16C7D1775A0AC0B6C0D7B16B7826F00BFC06E609733119FB6059B7A57F3FC6E13E9E9475E399660CE560DCE9D42EC80ED8133B273E733EF6C6BE80DFBC76D91561F7F63EE05B388E751AB5D3C901CB7FBAA4ABB2CCC5679DC21D096C52C7731B601BB331F65AE6021FA47DD1DF12F02AF0387E498EA73CDD0E844D709F33CBC3674D4807E5B7BC17BFFDA3A91EBBEAC281C6CD8059C09B19CB32548C07BE831354B516AFC27DEAC27D0A64FC12654D487ACA790E9881430D67033BD05FF8917897D141C0323C6DB4035DD82E8CA5FACB53025EC62EFB5FB0A19F16FF976B4236A74CCA18E0F510C25392EE078EC399B84D71C713A3DF012CC0E4CDC5D3D8988CE5AA8515C05BC0C7815B815DE2FD127E4196E3917B37705708E12D49E9355400B603FE9E9540991122693C700665613F04EC05FC2AAE4DAE967433F061E0A3C017711D56170E659F8D1D82B3B0F7D2EC12A51E4CC2B5B1ED9DA2ECDDD896DC0D3C0DBC12425896FADC5E78B4139F3F4DD2B92184A53413AA23FC5EF1FCF4187E4E87A3E7C41850E5B341D2F692EE91D41B9F5F21E92A493BCA3B559B19A62F499A2B691749D7C7B61565B957D2145549DFCAFBCDE754C8B658D2F41A3A6979F83D69B80BD8179890BA1D803D81E9AAA8E008212884F0328E073D116F8F06BE86039557030B69CE1A45C0BF71E4E053389C93446FE7025F0D21CCAB7465631FA6C73EA5FB3301D837EAA0616465904650DD33E9C4B557475713384E6597535EB18F8DCF8F067E02BC871598E5F50E701356EA05F40DA5DF1165EA8328FBD151B66A53E94832CA82B6A2947443ACF44D25CDC681C8B7B1410DD8B3EA49C93211CFE9976017732AD9BD3825E06F78545E4EFF74C018798A2D61C76223EC7CEC8B6D5BD323D5AD202409997C13F8176542966345A78B0588F7A6E105DA1F70BE214B4246E09CF81E55BEF7641C622FE1D19A10B20DB533A399A255C5D601AFCEA752DD2E54767424B03F564ED6762460CFAE1AC91F89D740B23515CD26E45D9C419B8CFD7518BC83495CE91D9A170DEEC42F4865FC6C20D9FE89F33A7B533B659D8960CDC4ED3858F723CA840C86E5780DF05BDCF1AC65ECC12FCAA178A15AF3988B0A3C8BD74717E3487553D06C425EC40A9E8737E50C5655DE8D53BFC9CA7E6FB22F8AE8C6A3F6AE28DB190CAE8795B80FCB69B0886130349B903DF128B909576E1C823D966A6FA5707EFA069CA13B92E684E485A305EBE3DCFF36C0676BB4B30C17FACDC47503DDB84F4D43B309390E7B5877E278D553F834A13421C2D3C84CE0FBD8BD3C8AE685E2935CC651C0EB380D30163818EB234DCC8A28F302BC603D1E877B9A866613320238305E9548BCA76E6C2F2E038EC5ABF7407356E96984D8D65BC045D8913894BE53E4C6D866B40CEDD863D88BE7F0DFE0397919F0279C20DA1EAF3F5A8937B17D380FF8351EBD9D78241C4A7D89AACCD00E42960177003FC30B3025D5E592EEA1F569DCA4FD9725CD8FED075C3CBD3F6B282143995E4AC0926A056551316D2B7A48B72F69E51065C944EE810C67AD06AAD5530D4591C2A4E41D2586D6A76ACFD6EA67CDEF1D6884BC063C82C3CBC93452021EAEF26C37F644BA197C88BF179FCD3B16605907AB474EF7BD12F380DF518E040BF81FD66D550458BD0B6A5F5C2F352ADEEFA4FA41988B80FB42082FA46F4ADA0ADB8603AB7C262DCCD9C04F4308BDB584CA03E4438F8FC525A4E997328D120E809E10425858F1F9C9D8B59E54F1D9243DDC8375B20A9803CC0E21740739F57A29CE69D793CB16AE3A3C17476DD3E8C401C46AFB0757E05D55EF525E7B2C0921B4ABB0A12A62EE6322E535C9FA38BD5BA91BE1BE3C47FF985B076537BE9E3CC90A9C4EBE2C483A1EB885A179133DD8654D581E2A4AB820FB6EE09ABC9012C9380BC7B83661F88BD3E428D891D4EF35BE0F9C1A243D84E34CEDC07260F7104253E343F542D20EB8CC676C9B4478B8032761DA8531E46B03682F2D5E7754606227F6A4A631B4E1D5830DD370DD5761AFE45EEC89E402218457245D8F0BA92BE35A43C558EA0F8E26FA783448DA14B802EF7BA8E7209824F4712BF69A8603E118D25FF3623F12443BB21B8E630D97904E7CFED7110CBEF816768E1E002E4CDCDECDB0CB3B99BE7B3A922B8DE538F6F4441E4E60CB2B244DC325B263E9ABC374050CD898CF07E68410DE487F4190D429EFC5EE92B49FA4A7E5DFBD48AE7F48BAB1355D5AF321E998A8B3B40E9F8EBA4DF4DC99AE5B5B3D9C621CA727F565137139E804FAE263CDEEC85A84ADE99FBA9E004CAC35550FE467D79A3FF3E415E51DB5F45BD336E5F178A4751A052139434148CE501092331484E40C052139434148CE501092331484E40C052139C3B0EBB2E22ED529786BD8CE349E3F589391C4019FC765A9FD368DD68BE110D21DAB540EC07BBC2B771CADCBD80EA730CE94F418C348E00D75CA2AE183BD0E06BE4B79037D813276C0BA3908D70D0F8994A11052C259AD47F0D17DBB0EF1F3EB0A3AB06EAEC5F5C10F300452EA99B2927CEF4CBCCFE3461CE72F501B1D78A4DC42797BC540A70CF5F9E060E8C6A3E2717CC2424146FDD80AEBEC315C823BE839938311224CC67CE02B782B5881A161323E176C163ED777C0C2C281A6ACB7819FE3A352CFA2451BE7D74274E0639F4EC1A3E555CA2765F7434D054B1A8799FD1EC58FDA678595F8BCC9BB2A8E7C5A8DAA5396A4E4074D2EA320234B8C261EB21975DC0FD5CE841A8577CF9E4FFF8A93028D6302D6ED7151D77DD06FCA92340357321636A37910B004B83084706BFA1FAB159E1A19D7514C53ADC22A7C92C45DC94FBE76C06A9B31031F935A90D13A8CC23A9F91D8948ED4696985CD680F129B72B4A4AE0E603D4CC807286C463B10B0EE8F06D6EBC43B4D1FC2A1E3B6FD06EC3A8E959883F7D2BB7037A7FEB3A30A648B65C0A2467F03B14081B51FFF07E27C234A7C47DD100000000049454E44AE426082)
INSERT [dbo].[ServiceTypes] ([Id], [Name], [Image]) VALUES (2, N'Diagnostics', 0x89504E470D0A1A0A0000000D494844520000006400000064080600000070E295540000000473424954080808087C08648800000D6549444154789CED9D7BB05C5595C67F2B747825864040090679044519832586C107A08481511C05C520850154C460293368A188A011157C1079188542061F833CA6140764C6290724888865A4A238420AE411218180496E0870C90DB9FDF9C7B70FDDB7D3EFDB7DBB6FEA7C555D9DDBE7B1F7D96BAFB5D7FAD6DA279023478E1C3972E4C89123478E1C3972E4C89123478E1C3972E4C8B16523C6BA4149DB029381AD7BD17E1D08D8003C1B111B7BD589311B1049056036F06EE0ADC0EEC084B16ABF090C030F008B815B80FF8F880D63DD8931114812C63B81F380594011F81B3090FEDD6B14805D801DB160EE052E01AE1B6B6DE9BA402405F0366011F01A6008B8227D06BADD7E0B980E9C0BBC078FCB2AE0C488F8654F7BD56948DA49D24D928A925E9074515A47FA0E92B69774B5A48D327ED3AF7D6D1B92E64A7A363DE0DD92A6F5BA4FF5206986A4DBCB26D0C949CBC73F24BD42D29FD2C33D2FE9845EF7A911246D25E9144903659368DF5EF7AB2390B450D270FADCD4EFDA9141D2744937A67E6F90F45549137BDDAF5141D241925624ED5821E9A8F1A4FA928E96F454EAFF1F25CDEE759FDA86A469927E986CF090A4CB25EDD4EB7EB50249DB4ABA2C096448D2259226F5BA5F2D23D9E0B99256A6877944D201BDEE573B90B4B7A447D373AC9234A7D77D6A19493B6E49F6B728E90C49FD1491B704499F48EB48312DF05D7583ABDAF4D4E80EC0C42AE70C03EB2262B0C6B5F380ABD2B5BF070EE92537345A24537B2D7024E6BB3E0E5C1111AA72EE24600AB01523C74DC026606DCB6321698AA4B325DD9B5CBF75159F1592CE9734BDCAB53325DD9FDCC5D5928E6EA9F13E4432C1F324FD2D69C97D926655396F1F49974A5A5E65CC06D2B89CDEB286A5C6D7A5C6ABA1981AF8B2A4EDCBAE2B48FA4E3A3E2CE91A493B74604C7A0E49BB25B73D738317563CFB2E92AE48C76AA12869ADA453EAB535C21C255BFF074C00D67351052C03E644C493E9DAC3811F01BBA6E38F609335D4FA10F41D2602070233D3DFF703A744C45D00920E05BE0FEC45E371BB07786344541D9742C5DF5B377153D2F1ED48F479B29DC762DBB93A9D330538BCC17DC61BD6A4EF9D8023242D4D14FDA4F46966DCA600DB5063A28E1048446C90F403E0A3E9A25A10B0162F54E0C4CEA5C0754D746A4B80801540B6400FA68FA8FFFC45E0B7C0B3B54EA8D410806FA4DFDF0F4C2DFB3DD24778A65C03AC4FC75E091C5AE37E5B2AF6037E012C07EE03FE1B3815C8166DA54F8641E056E0FC88A89903AAE5F64E0676C30209E065C0E9C06158D52EC4099C038007B18D5D08CCC1666B4B8780DF011FC293731A1E9785C007F0982D01BE093C8635633DB02A22D675A607D2FB656EE7EB92A64AFA68F2B6EE91F40649FBCAB4F5A63A9EC69680E725DD20693F49BB4AFA2F394478BB1C32FC50D23249477664E0EB08640F490B24ED20E978D9DF2ECA02B85DD29B65A1FC54CE7FD4729BC7333648BA4AD29E9266C9C2C818897B24BD43D2CEE97B6AE3511D9D4042D2369266CB144236E04539C3F6AB746C77495F518929DD523028077E2F9799EBDB65D2314351D68C6334565491A4D7C833A19A59DA24E9CFB2EAEE20E9F32A650AC73B3648FA96CCD31D26E9419534A31C19997A8CDA4C35347D91A4D7E2C0EF750D4E1D00CE06FE13F814F009CC8B7563D6087B2FCF33D2A3E9E4FD37013F0316E018E227D8E1A977CD1F8133226259AB0D36E5A64ADA110FEE7E4D9C3E1538070BFB42EC129E85A3FF4E7A6083D8A7BF197B7A2F74F0DE1984BDA787D2F7101E877AE39615DC3DA3EAD4D1865A513A0D6E5C8EFD80839B3C3F8019C0E7D2F722601D7001D6AE4E69CAAD78D6CE013EC8E60C6B3F42C06A493F066E8B88E1CA13367B007941DA13781525FAFD104C3B6FD762E343C0FFE218E6A5B8E66972B5765BBCAFB019998505FD007027DD315B9DC456780CEE054E8B88E59527BC38E3254D014E063E86F9AC6D18DDC0058E5ADF093C077C09B898CE0CDA3036591FC3FCDBCD11715E07EEDB75489A89AB24ABA6830BE9A45D813381D3B056AC6524F93509136A13F0803E0EFC15D837FD5E4F701381B9C0FE98FFE944E9E8E3983BCBCC5F3F94A3368B2275C6AB20F3FA1F073E8C49AFCB70D85F2E904381CF00590EE00EE08B7890E70247604F2AE3BBCA1158DBF6075E81E9FDD10CA0B0E66D91144D017835667787B18B7A73A51720E9658C34359B804781BFE04AF199C03CE004CCEBD45AFCEF074EC2E6663418A60E633A9E51008E037606BE0DFCBC8A30A6E045BD3CF5B8273023221E049E0696024B259D05BC1EE79F8FC25AB13D25AD998DDDC6CF61126E01356C69032CC78E42DF2039436FC3A4EB6E7802FF1A382E2236D5B974040AC01E78C6DD8303AC4ACC058EA76422026BD56C490F9753C911F10236774B245D8E9D84F9989E8F748F9371E0743BF03E2CBC565DE1414AE6B3E74851F90138EE1AC0134698E96DE9D90A9466EFC6CA4A0A49337090B763C575D3F00CBF955286700422628DA44BB159BB845226722AF06F38983B0B3B0507D29A47D737F14612C6FEC0A77190FA1FD86A883676633592DE3BB006550EC004BC909F5AEFE214F8FC02F80EA57563027E802F024F62EFEE71FA34869009D3C324D5722266E08D48CB808B23E2E188581311AD97FCD05820D3EA9CB30D708E5CAE5F33DD9B3A754BEA7036E8059C6FFF2C36950BB0ABDDAC50BA2E3CB98AE69F7100FAEFC0BB54C6E2CAECF7EEC0F730557279443C3DDA761B09A49169988453BE1F51FDDADDBF62BB5AD9F6697871FE3FACEACF518AC4EB7D8AB4E83ACBF555074A7AAFBC4DA2E6B3C9B553EFC1CEC78F7176703E6606CACDD49578725D9855DF8C169DC881EF82B7821D2CE96E1C6754A629A763D5AEC4B658208FE040EFF7582B1B4D8401AC714D21999B23802FE3B5EC57C02249BFAEE493E4FD90EFC2EEF922AC213BE138EC02490BF0B89D9B2E3903F853B37D69844E0824CBB9CF058EC66B45256956005E52E3FA5D80AF00D7634EAA99F8E2199A6477D36C7E0B703E76243E8B0B3816010B255D5D517470380E9417013F4B9EE32A49DFC455353FA55497767A44FCA5997E348B4E5589642EED76B44640824DD75E3887D22C566086B72EE44D366FC08BEE5DC0E723625DD2E4F978ED3A4CD279C0539891F81A2E4EB8B15C7B2262A5A493704EE879E0AC4E0B03DA1788F00C7D0C6BC33EB44FABABE2BB190CD3600D49B988133025743D706544AC078888A7252D04EEC613E1FB9845782D16C6B555A9F188E5928E05B6ABC6D47602ED0AA4887DEECBF08B00DA8D9A33A2F26A2CDC66853280135FD56F6A619C46691DB826229E293F2799A9DB24ADC2DAF20F581837551346D9751D59BC6BA15D810CE042B9C5F8C1DB0DD456E3586631D6B866EF538C88A2B4B9FCD2A27C2CA631E603BF4BEB405544C47D92CEC60EC6D3F584311668D7CC3C05AC4C91FD95789617697E8617B12B7C124EC39E0D3C818BC99AF9FC59D2C135EEBD1529E08C883BEB092343440CA640AEA7C280F6356457607F494B3127F5496CABF7A494DCAA8522A653BE8083C27370A2A99C846C84973092EC7C11891CFD9F26EFD3776857203BE275A308FC1CB811C71F737030B5479D6B9FC131C79DD897FF10AD7B667DC365751AED0A24B047723116C07A6C2AA6E1DC792D0C631AE23AE023C089B42E8C726426723C09A86E5F4713874CC0754A53AA1CABB6963C8785712EF02F381936B9C6B98D50C0A9E1C7D2DFFB487A13FD9FCA2D60733F44692BC76627741AC28BFE524A51F7264C8B5C8535E955981F5AD2661B83D8D3FB164E06BD0EF86EFB5D1E53ACC7C5762BAB1DEC9640EEC0398F6CFF481118CA288A44438CA6EDACC4A800FC2BCED58F871CBBF0241DA086E9EAD6069B3511F144AD83C9131AD5DE4349070117E168FB01FADF5C659806FC13B058D2D72BDF5A372E773CA5E0EF789C697C738FBBD32EA66313BEA2FCC74602C982BD56BD986E27906602FF88FBBF017898CD19E67E44600D998EE3B523308FF6221A096419164A2BF67918E794BB8294DB3804BBDD60C7E04CC68FC93A08D7184C044E95F4A3116C82A4EBE50D37F32AAF94DF887343DA0BD12C9E50175FD2226FA7BB31EDC5284AEAAB72A0469037343D94C66A48D2DBCB8FD7D590B44D7A3EE6868EA4065D518655382BB778349D6E80BDB18604F6586EE8625BDDC0001E9FBD705DF299926ECB0A220A94151E488ACA52A088589D66E154EA0BA4080C8CC1BB6E4FA45496B424221EEF727B9DC6208EC9E661CE6F162E20BC0B2C902771D4BD6F3A61B3014D2CE89ACADFC71AA972FC7D949C8C974BBA883E2D21AA81ACD03063DAA702EF96B424223685A4B7E264D35AE0A488B8A3471D6D084917E09C78269096AB4FFA04810592BD88E10EFCEE94870A98E2B81E9B826B257D0A33B14DD7A38E1176068E61A40B3E81D6733AC2D9C60BF1C699CCB57F81EAEF07AB86C0D5FE1F6664996D3B084CFD1C20E9E10090F44A9C9F782F7EC095946AA4FA01814B71A6337A8A64232E6EBB84D1EF4B9C81732F9347799F228E47CE78713648DA0317871D873D807E7A2DDFD63829D509BEAA88B752B492C3AF85AD315BD0897E3D091C55F9BEAC895815EB65FC7A81D998B7DABBD71DE9228AC027C74562277157BB533DF7B2A5A0083C3A5EC8C529583B466BABFB1902368E1781646FAC7B0BE323EFD12A84598E2F8D179395A58B5BA94C196FD8487FFD7F2A3972E4C89123478E1C3972E4C89123478E1C3972E4C89123478E1C5DC1DF0172A5C83341B426A90000000049454E44AE426082)
SET IDENTITY_INSERT [dbo].[ServiceTypes] OFF
GO
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (1, 1)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (3, 1)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (5, 1)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (22, 1)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (3, 2)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (5, 2)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (11, 2)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (15, 2)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (22, 2)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (13, 3)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (21, 3)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (15, 5)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (24, 6)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (8, 11)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (20, 11)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (18, 12)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (26, 14)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (19, 15)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (4, 21)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (12, 22)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (14, 24)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (23, 26)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (17, 27)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (23, 27)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (6, 28)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (27, 28)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (6, 29)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (6, 30)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (27, 30)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (2, 31)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (6, 31)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (23, 34)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (10, 36)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (10, 37)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (7, 42)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (25, 44)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (28, 45)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (25, 47)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (29, 48)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (16, 49)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (29, 50)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (16, 52)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (5, 55)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (11, 55)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (15, 55)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (22, 55)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (13, 56)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (21, 56)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (13, 57)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (21, 57)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (23, 59)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (9, 60)
INSERT [dbo].[StoreItemCarModels] ([StoreItemId], [CarModelId]) VALUES (23, 60)
GO
SET IDENTITY_INSERT [dbo].[StoreItemCategory] ON 

INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (1, N'Brakes')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (2, N'Engine Parts')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (3, N'Suspension')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (4, N'Exhaust Systems')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (5, N'Transmission')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (6, N'Electrical Systems')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (7, N'Tires')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (8, N'Wipers')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (9, N'Filters')
INSERT [dbo].[StoreItemCategory] ([Id], [Name]) VALUES (10, N'Cooling Systems')
SET IDENTITY_INSERT [dbo].[StoreItemCategory] OFF
GO
SET IDENTITY_INSERT [dbo].[StoreItems] ON 

INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (1, N'EBC-Turbo Discs', 350, 0, 350, N'active', 0x, N'The Turbo Groove Discs have unique wide slots which help cool the discs and brake pads alike, and together with the blind drilled dimples help clear surface gases without affecting the structure of the disc unlike through drilled discs.', 2, 1)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (2, N'Front Brake Pads', 120, 0.1, 108, N'active', 0x, N'Black Diamond discs. These award winning brake discs are made to the most exacting standards using computer aided design and computerised production.', 2, 1)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (3, N'OEM-R32 Brembo', 400, 0, 400, N'active', 0x, N'Pair of Mk4 Golf R32 334mm x 32mm Front Brake Discs. Mk4 Golf R32 Front Brake Disc Set - 334mm x 32mm. These are replacement discs for Mk4 Golf R32, or vehicles running this brake set up with 334mm front brake discs. This Kit Consists of: LH Brake Disc, RH Brake Disc.', 2, 1)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (4, N'Rear Wipers', 25, 0.05, 23.75, N'active', 0x, N'Excellent OEM quality wipers. Five years of warranty.', 2, 8)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (5, N'1.9 TDI PD Pistons', 300, 0, 300, N'active', 0x, N'OEM Forged pistons 1.9 TDI PD engines (74kW-100kW).', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (6, N'220 CDI Head Gasket', 45, 0, 45, N'active', 0x, N'OEM Head Gasket for 220 CDI (and 200 CDI) Mercedes engines. 3 years of warranty.', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (7, N'Rear Muffler', 125, 0.15, 106.25, N'active', 0x, N'Special offer - 15% discount!
High quality rear muffler for Nissan Altima (2001-2006). 5 years of warranty.', 2, 4)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (8, N'Intercooler', 96.99, 0, 96.99, N'active', 0x, N'Stock OEM intercooler for 4th generation Toyota Supra.', 2, 10)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (9, N'Michelin Pilot Sport 3
', 310, 0, 310, N'active', 0x, N'255/35ZR19/XL 96Y AUD
Price - per unit.', 2, 7)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (10, N'Cabin Air Filter', 20, 0, 20, N'active', 0x, N'Custom air filter with natural smell for comfort.', 2, 9)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (11, N'Bilstein B4 Struts', 70, 0.05, 66.5, N'active', 0x, N'Front struts for B5/B6 Audi/VW models with four-link fully independent front suspension.', 2, 3)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (12, N'Custom ECU', 550, 0, 550, N'active', 0x, N'Custom ECU for Honda NSX first gen. Recommended for stage 2 tune.', 2, 6)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (13, N'Torsen Rear Differential', 360, 0, 360, N'active', 0x, N'Torsen rear differential for Audi and VW models with Quattro Evo 1 and Quattro Evo 2 four wheel drive. Based on Audi V8 (Typ 4C) rear differential. Certified for up to 800Nm of torque.', 2, 5)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (14, N'Timing Belt', 49.99, 0.03, 48.490300000000005, N'active', 0x, N'Engine timing belt for BMW models with M51 2.5 turbo diesel engine.', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (15, N'2.0 TDI DPF', 170, 0, 170, N'active', 0x, N'Diesel Particulate Filter for 2.0 TDI VAG engines. Compatible with 81kW and 103kW versions.', 2, 4)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (16, N'Oil Filter', 35, 0, 35, N'active', 0x, N'OEM Toyota Oil filter. 7 years of warranty.', 2, 9)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (17, N'Engine Crankshaft', 420, 0.05, 399, N'active', 0x, N'High quality crankshaft for BMW M4 F82. Certified for stage 3 tune.', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (18, N'Front Wipers', 22.99, 0, 22.99, N'active', 0x, N'Front wipers for Toyota Prius. Improved rigidity for winter conditions.', 2, 8)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (19, N'Android Infotainment', 225, 0, 225, N'active', 0x, N'Android infotainment system upgrade for 2nd gen Ford Focus (pre-facelift and post-facelift).', 2, 6)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (20, N'Turbo Upgrade Kit', 950, 0.05, 902.5, N'active', 0x, N'Turbo upgrade kit for Toyota Supra Mk4. Includes: Turbo, exhaust leads, intercooler, wastegate.', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (21, N'CIS to EFI Upgrade', 280, 0, 280, N'active', 0x, N'Electronic fuel injection upgrade kit for 10v CIS based 5-cylinder engines from Audi and Volkswagen (2.0L-2.3L). Tuneable for NA and Turbo application. 3 years of warranty.', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (22, N'EGR Valve', 85, 0.05, 80.75, N'active', 0x, N'EGR valve for 1.9 TDI PD engines. OEM quality with 5 years of warranty.', 2, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (23, N'Bosch S6 AGM Battery', 300, 0.1, 270, N'active', 0x, N'100% maintenance free (under normal operating conditions). Reliable starting power even in extreme hot and cold climates.', 7, 6)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (24, N'Front Wipers', 25, 0, 25, N'active', 0x, N'Front wipers for Polo Mk5', 7, 8)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (25, N'Oil Filter', 45, 0, 45, N'active', 0x, N'High quality oil filter for your sport oriented Nissan.', 7, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (26, N'Spark Plug', 20, 0, 20, N'active', 0x, N'Spark plug for Ford Fiesta 3rd gen.', 7, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (27, N'Fuel Pump', 85, 0, 85, N'active', 0x, N'OM606 diesel fuel pump.', 7, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (28, N'Alternator', 55, 0, 55, N'active', 0x, N'High quality alternator', 7, 2)
INSERT [dbo].[StoreItems] ([Id], [Name], [Price], [Discount], [DiscountedPrice], [State], [ImageData], [Details], [CarPartsShopId], [StoreItemCategoryId]) VALUES (29, N'Radiator', 47, 0, 47, N'active', 0x, N'High quality radiator for you Hyundai.', 7, 10)
SET IDENTITY_INSERT [dbo].[StoreItems] OFF
GO
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (1, N'John', N'Doe', N'admin@fixmycar.com', N'+387 63 555 444', N'admin', CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), N'Male', N'Bulevar 1', N'88000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 1, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (2, N'Jim', N'Johnson', N'carpartsshop@fixmycar.com', N'+387 63 666 444', N'carpartsshop', CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), N'Male', N'Bulevar 2', N'88000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', 0x, 4, 1, 1, N'1,2,3,4,5', CAST(N'08:00:00' AS Time), CAST(N'16:00:00' AS Time), CAST(N'08:00:00' AS Time), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (3, N'Nicole', N'Perkins', N'carrepairshop@fixmycar.com', N'+387 63 777 444', N'carrepairshop', CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), N'Female', N'Bulevar 3', N'88000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', 0x, 3, 1, 1, NULL, NULL, NULL, NULL, N'1,2,3,4,5', CAST(N'08:00:00' AS Time), CAST(N'16:00:00' AS Time), CAST(N'08:00:00' AS Time), 2)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (4, N'Nancy', N'Cole', N'nancycole@fixmycar.com', N'+387 63 888 444', N'client', CAST(N'2024-11-01T00:00:00.0000000' AS DateTime2), N'Female', N'Bulevar 4', N'88000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 2, 1, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (5, N'Adrian', N'Parker', N'adrian@mail.com', N'+387 65 223 6665', N'client2', CAST(N'2024-11-03T00:00:00.0000000' AS DateTime2), N'Male', N'Kulina Bana bb', N'71000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 2, 2, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (6, N'Freddie', N'Raymond', N'freddie@gmail.com', N'+387 63 554 568', N'client3', CAST(N'2024-11-03T00:00:00.0000000' AS DateTime2), N'Male', N'Kraljice Katarine 32', N'80101', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 2, 5, 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (7, N'Danielle', N'Banks', N'carpartsshop2@fixmycar.com', N'+387 65 554 458', N'carpartsshop2', CAST(N'2024-11-03T00:00:00.0000000' AS DateTime2), N'Female', N'Zagrebačka ulica 22', N'71000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 4, 2, 1, N'1,2,3,4,6,5', CAST(N'09:00:00' AS Time), CAST(N'17:00:00' AS Time), CAST(N'08:00:00' AS Time), NULL, NULL, NULL, NULL, NULL)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (8, N'Josh', N'Martinez', N'carrepairshop2@fixmycar.com', N'+387 63 443 4652', N'carrepairshop2', CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), N'Male', N'Bulevar 14', N'78000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 3, 3, 1, NULL, NULL, NULL, NULL, N'1,2,3,4,5', CAST(N'08:00:00' AS Time), CAST(N'16:00:00' AS Time), CAST(N'08:00:00' AS Time), 2)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (9, N'Silvia', N'Booker', N'carrepairshop3@fixmycar.com', N'+387 63 554 5432', N'carrepairshop3', CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), N'Female', N'Avenija 12', N'88000', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 3, 1, 0, NULL, NULL, NULL, NULL, N'1,2,5,3,4', CAST(N'08:00:00' AS Time), CAST(N'16:00:00' AS Time), CAST(N'08:00:00' AS Time), 3)
INSERT [dbo].[Users] ([Id], [Name], [Surname], [Email], [Phone], [Username], [Created], [Gender], [Address], [PostalCode], [PasswordHash], [PasswordSalt], [Image], [RoleId], [CityId], [Active], [CarPartsShop_WorkDaysAsString], [CarPartsShop_OpeningTime], [CarPartsShop_ClosingTime], [CarPartsShop_WorkingHours], [WorkDaysAsString], [OpeningTime], [ClosingTime], [WorkingHours], [Employees]) VALUES (10, N'Darron', N'Dawson', N'carpartsshop3@fixmycar.com', N'+387 67 588 9948', N'carpartsshop3', CAST(N'2024-11-04T00:00:00.0000000' AS DateTime2), N'Male', N'Avenija 2', N'80101', N'DfE7H5oCnqmC6SvI07mAqrIImxo=', N'7ovYR75ZgQN7BTgS9DDWeg==', NULL, 4, 5, 0, N'1,2,3,4,5', CAST(N'08:00:00' AS Time), CAST(N'16:00:00' AS Time), CAST(N'08:00:00' AS Time), NULL, NULL, NULL, NULL, NULL)
SET IDENTITY_INSERT [dbo].[Users] OFF
GO
/****** Object:  Index [IX_AuthTokens_UserId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_AuthTokens_UserId] ON [dbo].[AuthTokens]
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarModels_CarManufacturerId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarModels_CarManufacturerId] ON [dbo].[CarModels]
(
	[CarManufacturerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarPartsShopClientDiscounts_CarPartsShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarPartsShopClientDiscounts_CarPartsShopId] ON [dbo].[CarPartsShopClientDiscounts]
(
	[CarPartsShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarPartsShopClientDiscounts_CarRepairShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarPartsShopClientDiscounts_CarRepairShopId] ON [dbo].[CarPartsShopClientDiscounts]
(
	[CarRepairShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarPartsShopClientDiscounts_ClientId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarPartsShopClientDiscounts_ClientId] ON [dbo].[CarPartsShopClientDiscounts]
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarRepairShopDiscounts_CarRepairShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarRepairShopDiscounts_CarRepairShopId] ON [dbo].[CarRepairShopDiscounts]
(
	[CarRepairShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarRepairShopDiscounts_ClientId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarRepairShopDiscounts_ClientId] ON [dbo].[CarRepairShopDiscounts]
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarRepairShopServices_CarRepairShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarRepairShopServices_CarRepairShopId] ON [dbo].[CarRepairShopServices]
(
	[CarRepairShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_CarRepairShopServices_ServiceTypeId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_CarRepairShopServices_ServiceTypeId] ON [dbo].[CarRepairShopServices]
(
	[ServiceTypeId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderDetails_OrderId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_OrderDetails_OrderId] ON [dbo].[OrderDetails]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_OrderDetails_StoreItemId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_OrderDetails_StoreItemId] ON [dbo].[OrderDetails]
(
	[StoreItemId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_CarPartsShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Orders_CarPartsShopId] ON [dbo].[Orders]
(
	[CarPartsShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_CarRepairShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Orders_CarRepairShopId] ON [dbo].[Orders]
(
	[CarRepairShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_CityId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Orders_CityId] ON [dbo].[Orders]
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_ClientDiscountId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Orders_ClientDiscountId] ON [dbo].[Orders]
(
	[ClientDiscountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Orders_ClientId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Orders_ClientId] ON [dbo].[Orders]
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReservationDetails_CarRepairShopServiceId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_ReservationDetails_CarRepairShopServiceId] ON [dbo].[ReservationDetails]
(
	[CarRepairShopServiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_ReservationDetails_ReservationId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_ReservationDetails_ReservationId] ON [dbo].[ReservationDetails]
(
	[ReservationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reservations_CarModelId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Reservations_CarModelId] ON [dbo].[Reservations]
(
	[CarModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reservations_CarRepairShopDiscountId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Reservations_CarRepairShopDiscountId] ON [dbo].[Reservations]
(
	[CarRepairShopDiscountId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reservations_CarRepairShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Reservations_CarRepairShopId] ON [dbo].[Reservations]
(
	[CarRepairShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reservations_ClientId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Reservations_ClientId] ON [dbo].[Reservations]
(
	[ClientId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reservations_OrderId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Reservations_OrderId] ON [dbo].[Reservations]
(
	[OrderId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_StoreItemCarModels_CarModelId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_StoreItemCarModels_CarModelId] ON [dbo].[StoreItemCarModels]
(
	[CarModelId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_StoreItems_CarPartsShopId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_StoreItems_CarPartsShopId] ON [dbo].[StoreItems]
(
	[CarPartsShopId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_StoreItems_StoreItemCategoryId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_StoreItems_StoreItemCategoryId] ON [dbo].[StoreItems]
(
	[StoreItemCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Users_CityId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Users_CityId] ON [dbo].[Users]
(
	[CityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
/****** Object:  Index [IX_Users_RoleId]    Script Date: 05/11/2024 02:04:22 ******/
CREATE NONCLUSTERED INDEX [IX_Users_RoleId] ON [dbo].[Users]
(
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
GO
ALTER TABLE [dbo].[AuthTokens]  WITH CHECK ADD  CONSTRAINT [FK_AuthTokens_Users_UserId] FOREIGN KEY([UserId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[AuthTokens] CHECK CONSTRAINT [FK_AuthTokens_Users_UserId]
GO
ALTER TABLE [dbo].[CarModels]  WITH CHECK ADD  CONSTRAINT [FK_CarModels_CarManufacturers_CarManufacturerId] FOREIGN KEY([CarManufacturerId])
REFERENCES [dbo].[CarManufacturers] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CarModels] CHECK CONSTRAINT [FK_CarModels_CarManufacturers_CarManufacturerId]
GO
ALTER TABLE [dbo].[CarPartsShopClientDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CarPartsShopClientDiscounts_Users_CarPartsShopId] FOREIGN KEY([CarPartsShopId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CarPartsShopClientDiscounts] CHECK CONSTRAINT [FK_CarPartsShopClientDiscounts_Users_CarPartsShopId]
GO
ALTER TABLE [dbo].[CarPartsShopClientDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CarPartsShopClientDiscounts_Users_CarRepairShopId] FOREIGN KEY([CarRepairShopId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CarPartsShopClientDiscounts] CHECK CONSTRAINT [FK_CarPartsShopClientDiscounts_Users_CarRepairShopId]
GO
ALTER TABLE [dbo].[CarPartsShopClientDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CarPartsShopClientDiscounts_Users_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CarPartsShopClientDiscounts] CHECK CONSTRAINT [FK_CarPartsShopClientDiscounts_Users_ClientId]
GO
ALTER TABLE [dbo].[CarRepairShopDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CarRepairShopDiscounts_Users_CarRepairShopId] FOREIGN KEY([CarRepairShopId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CarRepairShopDiscounts] CHECK CONSTRAINT [FK_CarRepairShopDiscounts_Users_CarRepairShopId]
GO
ALTER TABLE [dbo].[CarRepairShopDiscounts]  WITH CHECK ADD  CONSTRAINT [FK_CarRepairShopDiscounts_Users_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[CarRepairShopDiscounts] CHECK CONSTRAINT [FK_CarRepairShopDiscounts_Users_ClientId]
GO
ALTER TABLE [dbo].[CarRepairShopServices]  WITH CHECK ADD  CONSTRAINT [FK_CarRepairShopServices_ServiceTypes_ServiceTypeId] FOREIGN KEY([ServiceTypeId])
REFERENCES [dbo].[ServiceTypes] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CarRepairShopServices] CHECK CONSTRAINT [FK_CarRepairShopServices_ServiceTypes_ServiceTypeId]
GO
ALTER TABLE [dbo].[CarRepairShopServices]  WITH CHECK ADD  CONSTRAINT [FK_CarRepairShopServices_Users_CarRepairShopId] FOREIGN KEY([CarRepairShopId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CarRepairShopServices] CHECK CONSTRAINT [FK_CarRepairShopServices_Users_CarRepairShopId]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_Orders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_Orders_OrderId]
GO
ALTER TABLE [dbo].[OrderDetails]  WITH CHECK ADD  CONSTRAINT [FK_OrderDetails_StoreItems_StoreItemId] FOREIGN KEY([StoreItemId])
REFERENCES [dbo].[StoreItems] ([Id])
GO
ALTER TABLE [dbo].[OrderDetails] CHECK CONSTRAINT [FK_OrderDetails_StoreItems_StoreItemId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_CarPartsShopClientDiscounts_ClientDiscountId] FOREIGN KEY([ClientDiscountId])
REFERENCES [dbo].[CarPartsShopClientDiscounts] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_CarPartsShopClientDiscounts_ClientDiscountId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Cities_CityId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users_CarPartsShopId] FOREIGN KEY([CarPartsShopId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users_CarPartsShopId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users_CarRepairShopId] FOREIGN KEY([CarRepairShopId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users_CarRepairShopId]
GO
ALTER TABLE [dbo].[Orders]  WITH CHECK ADD  CONSTRAINT [FK_Orders_Users_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Orders] CHECK CONSTRAINT [FK_Orders_Users_ClientId]
GO
ALTER TABLE [dbo].[ReservationDetails]  WITH CHECK ADD  CONSTRAINT [FK_ReservationDetails_CarRepairShopServices_CarRepairShopServiceId] FOREIGN KEY([CarRepairShopServiceId])
REFERENCES [dbo].[CarRepairShopServices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ReservationDetails] CHECK CONSTRAINT [FK_ReservationDetails_CarRepairShopServices_CarRepairShopServiceId]
GO
ALTER TABLE [dbo].[ReservationDetails]  WITH CHECK ADD  CONSTRAINT [FK_ReservationDetails_Reservations_ReservationId] FOREIGN KEY([ReservationId])
REFERENCES [dbo].[Reservations] ([Id])
GO
ALTER TABLE [dbo].[ReservationDetails] CHECK CONSTRAINT [FK_ReservationDetails_Reservations_ReservationId]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_CarModels_CarModelId] FOREIGN KEY([CarModelId])
REFERENCES [dbo].[CarModels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_CarModels_CarModelId]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_CarRepairShopDiscounts_CarRepairShopDiscountId] FOREIGN KEY([CarRepairShopDiscountId])
REFERENCES [dbo].[CarRepairShopDiscounts] ([Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_CarRepairShopDiscounts_CarRepairShopDiscountId]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Orders_OrderId] FOREIGN KEY([OrderId])
REFERENCES [dbo].[Orders] ([Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Orders_OrderId]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Users_CarRepairShopId] FOREIGN KEY([CarRepairShopId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Users_CarRepairShopId]
GO
ALTER TABLE [dbo].[Reservations]  WITH CHECK ADD  CONSTRAINT [FK_Reservations_Users_ClientId] FOREIGN KEY([ClientId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Reservations] CHECK CONSTRAINT [FK_Reservations_Users_ClientId]
GO
ALTER TABLE [dbo].[StoreItemCarModels]  WITH CHECK ADD  CONSTRAINT [FK_StoreItemCarModels_CarModels_CarModelId] FOREIGN KEY([CarModelId])
REFERENCES [dbo].[CarModels] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StoreItemCarModels] CHECK CONSTRAINT [FK_StoreItemCarModels_CarModels_CarModelId]
GO
ALTER TABLE [dbo].[StoreItemCarModels]  WITH CHECK ADD  CONSTRAINT [FK_StoreItemCarModels_StoreItems_StoreItemId] FOREIGN KEY([StoreItemId])
REFERENCES [dbo].[StoreItems] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StoreItemCarModels] CHECK CONSTRAINT [FK_StoreItemCarModels_StoreItems_StoreItemId]
GO
ALTER TABLE [dbo].[StoreItems]  WITH CHECK ADD  CONSTRAINT [FK_StoreItems_StoreItemCategory_StoreItemCategoryId] FOREIGN KEY([StoreItemCategoryId])
REFERENCES [dbo].[StoreItemCategory] ([Id])
GO
ALTER TABLE [dbo].[StoreItems] CHECK CONSTRAINT [FK_StoreItems_StoreItemCategory_StoreItemCategoryId]
GO
ALTER TABLE [dbo].[StoreItems]  WITH CHECK ADD  CONSTRAINT [FK_StoreItems_Users_CarPartsShopId] FOREIGN KEY([CarPartsShopId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[StoreItems] CHECK CONSTRAINT [FK_StoreItems_Users_CarPartsShopId]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Cities_CityId] FOREIGN KEY([CityId])
REFERENCES [dbo].[Cities] ([Id])
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Cities_CityId]
GO
ALTER TABLE [dbo].[Users]  WITH CHECK ADD  CONSTRAINT [FK_Users_Roles_RoleId] FOREIGN KEY([RoleId])
REFERENCES [dbo].[Roles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Users] CHECK CONSTRAINT [FK_Users_Roles_RoleId]
GO
USE [master]
GO
ALTER DATABASE [FixMyCar] SET  READ_WRITE 
GO
