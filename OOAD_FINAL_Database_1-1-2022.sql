USE [master]
GO
/****** Object:  Database [ManikHospital]    Script Date: 1/1/2022 1:07:12 AM ******/
CREATE DATABASE [ManikHospital]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'vtsMMC', FILENAME = N'D:\New folder\MSSQL12.MSSQLSERVER\MSSQL\DATA\ManikHospital.mdf' , SIZE = 25600KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'vtsMMC_log', FILENAME = N'D:\New folder\MSSQL12.MSSQLSERVER\MSSQL\DATA\ManikHospital_log.ldf' , SIZE = 5095872KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [ManikHospital] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [ManikHospital].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [ManikHospital] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [ManikHospital] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [ManikHospital] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [ManikHospital] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [ManikHospital] SET ARITHABORT OFF 
GO
ALTER DATABASE [ManikHospital] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [ManikHospital] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [ManikHospital] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [ManikHospital] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [ManikHospital] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [ManikHospital] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [ManikHospital] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [ManikHospital] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [ManikHospital] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [ManikHospital] SET  DISABLE_BROKER 
GO
ALTER DATABASE [ManikHospital] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [ManikHospital] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [ManikHospital] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [ManikHospital] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [ManikHospital] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [ManikHospital] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [ManikHospital] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [ManikHospital] SET RECOVERY FULL 
GO
ALTER DATABASE [ManikHospital] SET  MULTI_USER 
GO
ALTER DATABASE [ManikHospital] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [ManikHospital] SET DB_CHAINING OFF 
GO
ALTER DATABASE [ManikHospital] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [ManikHospital] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
ALTER DATABASE [ManikHospital] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'ManikHospital', N'ON'
GO
USE [ManikHospital]
GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GEN_LaparoscopPatientNumber]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[UDF_GEN_LaparoscopPatientNumber]
(
	
)
RETURNS VARCHAR(50)
AS
BEGIN
--    SELECT dbo.UDF_GEN_Rad_Request_Number()    Request_Number
    DECLARE @Request_Number    VARCHAR(20)
           ,@COUNTER        INT
           ,@DISPLAYLENGTH  INT 
           ,@Month int
           ,@Year int
   
    SET @COUNTER = 0
    IF (@Request_Number IS NULL)
        SELECT @Request_Number = right(PatientNumber,5)
         FROM  LaparoscopicData
       
        group by PatientNumber
       
   
    IF (@Request_Number IS NULL)
        SET @COUNTER = 10001
    ELSE
        SET @COUNTER = CAST(@Request_Number AS BIGINT) + 1
        
    if(@Month is null)
		set @Month = (CONVERT(char(2), cast(GETDATE() as datetime), 101)) 
	
	if(@Year IS NULL)
		set @Year = right(Year(GetDate()),2)	
       
    --SET @Request_Number = @COUNTER       
   
    set @Request_Number = 'L-'+ cast(@COUNTER as varchar)
   
    RETURN @Request_Number
END

GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GEN_OutDoorPatientInvestigationTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[UDF_GEN_OutDoorPatientInvestigationTest]
(
	@TestID int = null
)
RETURNS VARCHAR(50)
AS
BEGIN
--    SELECT dbo.UDF_GEN_Rad_Request_Number()    Request_Number


    DECLARE @Request_Number    VARCHAR(20)
           ,@COUNTER        INT
           ,@DISPLAYLENGTH  INT 
           ,@Month varchar(2)
           ,@Year int
           ,@Day int
           ,@TestName char(1)
           ,@TestType varchar(20)
   
   
	Select @TestName = left(TestType,1) from dbo.DiagnosticTest where TestID = @TestID
	Select @TestType = TestType from dbo.DiagnosticTest where TestID = @TestID
   
    SET @COUNTER = 0
    IF (@Request_Number IS NULL)
        SELECT @Request_Number = right(TestNo,5)
        ,@Day = RIGHT('0' + RTRIM(Day(GetDate())), 2)
        ,@Month = RIGHT('0' + RTRIM(MONTH(GetDate())), 2)
        ,@Year = right(Year(GetDate()),2)         
         FROM  OutDoorPatientTest dpt 
         JOIN DiagnosticTest dt on dpt.TestID = dt.TestID
        where dt.TestType = @TestType
        and MONTH(TestDate) = MOnth(GetDate())
        and Year(TestDate) = Year(GetDate())
        and Day(TestDate) = Day(GetDate())
        group by TestDate , TestNo
       
   
    IF (@Request_Number IS NULL)
        SET @COUNTER = 10001
    ELSE
        SET @COUNTER = CAST(@Request_Number AS BIGINT) + 1
    
    if(@Day is null)
		set @Day = Day(GETDATE())
    
    if(@Month is null)
		set @Month = (CONVERT(char(2), cast(GETDATE() as datetime), 101)) 
	
	if(@Year IS NULL)
		set @Year = right(Year(GetDate()),2)	
       
    --SET @Request_Number = @COUNTER       
   
    set @Request_Number = @TestName+'-'+ cast(@Day as varchar)+'-'+cast(@Month as varchar)+'-'+ cast(@Year as varchar)+'-'+cast(@COUNTER as varchar)
   
    RETURN @Request_Number
END


GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GEN_PatientRegNo]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[UDF_GEN_PatientRegNo]
(
	
)
RETURNS VARCHAR(50)
AS
BEGIN
--    SELECT dbo.UDF_GEN_Rad_Request_Number()    Request_Number
    DECLARE @Request_Number    VARCHAR(20)
           ,@COUNTER        INT
           ,@DISPLAYLENGTH  INT 
           ,@Month int
           ,@Year int
   
    SET @COUNTER = 0
    IF (@Request_Number IS NULL)
        SELECT @Request_Number = right(PatientRegNo,6), @Month = MONTH(AdmissionDate), @Year = right(Year(AdmissionDate),2)
         FROM  PatientRegistration
        --where MONTH(AdmissionDate) = MOnth(GetDate())
        where Year(AdmissionDate) = Year(GetDate())
        group by AdmissionDate , PatientRegNo
       
   
    IF (@Request_Number IS NULL)
        SET @COUNTER = 100001
    ELSE
        SET @COUNTER = CAST(@Request_Number AS BIGINT) + 1
        
    if(@Month is null)
		set @Month = (CONVERT(char(2), cast(GETDATE() as datetime), 101)) 
	
	if(@Year IS NULL)
		set @Year = right(Year(GetDate()),2)	
       
    --SET @Request_Number = @COUNTER       
   
    set @Request_Number = 'MR-'+ cast(@Month as varchar)+'-'+ cast(@Year as varchar)+'-'+cast(@COUNTER as varchar)
   
    RETURN @Request_Number
END

GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GEN_PurchaseInvoiceNumber]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_GEN_PurchaseInvoiceNumber]
(
	
)
RETURNS VARCHAR(50)
AS
BEGIN
--    SELECT dbo.UDF_GEN_PurchaseInvoiceNumber()    Request_Number
    DECLARE @Request_Number    VARCHAR(20)
           ,@COUNTER        INT
           ,@DISPLAYLENGTH  INT 
           ,@Month int
           ,@Year int
   
    SET @COUNTER = 0
    IF (@Request_Number IS NULL)
        SELECT @Request_Number = right(InvioceNumber,5), 
		@Month = MONTH(InvoiceDate), 
		@Year = right(Year(InvoiceDate),2)
         FROM  PurchaseMaster
        where 
		MONTH(InvoiceDate) = MOnth(GetDate())
        and 
		Year(InvoiceDate) = Year(GetDate())
        --group by InvoiceDate , InvioceNumber
       
   
    IF (@Request_Number IS NULL)
        SET @COUNTER = 10001
    ELSE
        SET @COUNTER = CAST(@Request_Number AS BIGINT) + 1
        
    if(@Month is null)
		set @Month = (CONVERT(char(2), cast(GETDATE() as datetime), 101)) 
	
	if(@Year IS NULL)
		set @Year = right(Year(GetDate()),2)	
       
    --SET @Request_Number = @COUNTER       
   
    set @Request_Number = 'PO-'+ cast(@Month as varchar)+'-'+ cast(@Year as varchar)+'-'+cast(@COUNTER as varchar)
   
    RETURN @Request_Number
END



GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GEN_SaleInvoiceNumber]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[UDF_GEN_SaleInvoiceNumber]
(
	
)
RETURNS VARCHAR(50)
AS
BEGIN
--    SELECT dbo.UDF_GEN_Rad_Request_Number()    Request_Number
    DECLARE @Request_Number    VARCHAR(20)
           ,@COUNTER        INT
           ,@DISPLAYLENGTH  INT 
           ,@Month varchar(2)
           ,@Year int
   
    SET @COUNTER = 0
    IF (@Request_Number IS NULL)
        SELECT top 1 @Request_Number = right(SaleInvoiceNumber,6),
		@Month = RIGHT('0' + RTRIM(MONTH(SaleDate)), 2),
        @Year = right(Year(SaleDate),2)
        FROM  SalesMaster order by saleid desc
        
       
   
   IF (@Request_Number = '999999')
        SET @COUNTER = 100001
   else
		IF (@Request_Number IS NULL)
			SET @COUNTER = 100001
		ELSE
			SET @COUNTER = CAST(@Request_Number AS BIGINT) + 1
        
    if(@Month is null)
		set @Month = RIGHT('0' + RTRIM(MONTH(GetDate())), 2) --MOnth(GetDate()) 
	
	if(@Year IS NULL)
		set @Year = right(Year(GetDate()),2)	
       
    --SET @Request_Number = @COUNTER       
   
    set @Request_Number = 'INV'+ cast(@Month as varchar)+ cast(@Year as varchar)+cast(@COUNTER as varchar)
   
    RETURN @Request_Number
END



GO
/****** Object:  UserDefinedFunction [dbo].[UDF_GEN_TokenNumber]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date, ,>
-- Description:	<Description, ,>
-- =============================================
CREATE FUNCTION [dbo].[UDF_GEN_TokenNumber]
(
	@DoctorID int
)
RETURNS VARCHAR(50)
AS
BEGIN
--    SELECT dbo.UDF_GEN_Rad_Request_Number()    Request_Number
    DECLARE @Request_Number    VARCHAR(20)
           ,@COUNTER        INT
           ,@DISPLAYLENGTH  INT 
   
    SET @COUNTER = 0
    IF (@Request_Number IS NULL)
        SELECT @Request_Number = COUNT(*)
        FROM  DailyOPD
        where DoctorID = @DoctorID
        and DAY(OPDDate) = DAY(GetDate())
        and MONTH(OPDDate) = MOnth(GetDate())
        and Year(OPDDate) = Year(GetDate())  
        --ORDER BY OPDDate
   
    IF (@Request_Number IS NULL)
        SET @COUNTER = 1
    ELSE
        SET @COUNTER = CAST(@Request_Number AS BIGINT) + 1
       
    SET @Request_Number = @COUNTER       
   
    IF (LEN(CAST(@COUNTER AS VARCHAR(20)))>=3)
        SET @DISPLAYLENGTH = LEN(CAST(@COUNTER AS VARCHAR(50)))
    ELSE
        SET @DISPLAYLENGTH = 3
   
    SET @Request_Number = RIGHT(
            REPLICATE('0' ,@DISPLAYLENGTH)+CONVERT(VARCHAR(10) ,@COUNTER)
           ,@DISPLAYLENGTH
        )
   
    RETURN @Request_Number
END

GO
/****** Object:  Table [dbo].[AssignPages]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AssignPages](
	[AssignPageID] [int] IDENTITY(1,1) NOT NULL,
	[PageID] [int] NULL,
	[LabelName] [varchar](100) NULL,
	[Sequence] [int] NULL,
	[IsActive] [bit] NULL,
	[ParentPageID] [int] NULL,
	[ContactTypeID] [int] NULL,
 CONSTRAINT [PK_AssignPages] PRIMARY KEY CLUSTERED 
(
	[AssignPageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Contact]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Contact](
	[ContactID] [int] IDENTITY(1,1) NOT NULL,
	[ContactTypeID] [int] NULL,
	[DepartmentID] [int] NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[Email] [varchar](50) NULL,
	[Address] [varchar](50) NULL,
	[Address2] [varchar](50) NULL,
	[City] [varchar](50) NULL,
	[Province] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
	[Telephone] [varchar](50) NULL,
	[Mobile] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[Website] [varchar](100) NULL,
	[Qualification] [varchar](500) NULL,
	[Experience] [varchar](100) NULL,
	[JoiningDate] [datetime] NULL,
	[EnteredDate] [datetime] NULL,
	[EnteredBy] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[DeletedBy] [varchar](50) NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_Contact] PRIMARY KEY CLUSTERED 
(
	[ContactID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ContactType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ContactType](
	[ContactTypeID] [int] IDENTITY(1,1) NOT NULL,
	[ContactType] [varchar](50) NULL,
 CONSTRAINT [PK_ContactType] PRIMARY KEY CLUSTERED 
(
	[ContactTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[CurrentStopTable]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CurrentStopTable](
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](156) NULL,
	[StockQuantity] [int] NOT NULL
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DailyOPD]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DailyOPD](
	[OPDID] [int] IDENTITY(1,1) NOT NULL,
	[OPDNumber] [varchar](50) NULL,
	[DoctorID] [int] NULL,
	[PatientName] [varchar](50) NULL,
	[ContactNo] [varchar](50) NULL,
	[Age] [int] NULL,
	[Sex] [varchar](10) NULL,
	[City] [varchar](50) NULL,
	[OPDDate] [datetime] NULL,
	[Discount] [decimal](18, 0) NULL CONSTRAINT [DF_DailyOPD_Discount]  DEFAULT ((0)),
	[Status] [varchar](50) NULL,
 CONSTRAINT [PK_DailyOPD] PRIMARY KEY CLUSTERED 
(
	[OPDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Departments]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Departments](
	[DeptID] [int] IDENTITY(1,1) NOT NULL,
	[DeptName] [varchar](100) NULL,
 CONSTRAINT [PK_Departments] PRIMARY KEY CLUSTERED 
(
	[DeptID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DiagnosticTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DiagnosticTest](
	[TestID] [int] IDENTITY(1,1) NOT NULL,
	[TestName] [varchar](50) NULL,
	[Charges] [decimal](18, 0) NULL,
	[TestType] [varchar](15) NULL,
	[TestGroup] [varchar](50) NULL,
 CONSTRAINT [PK_DiagnosticTest] PRIMARY KEY CLUSTERED 
(
	[TestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[DoctorFee]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DoctorFee](
	[FeeID] [int] IDENTITY(1,1) NOT NULL,
	[FeeTypeID] [int] NULL,
	[DoctorID] [int] NULL,
	[Fees] [decimal](18, 0) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_DoctorFee] PRIMARY KEY CLUSTERED 
(
	[FeeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[DoctorTiming]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DoctorTiming](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[DoctorID] [int] NULL,
	[DoctorTime] [varchar](100) NULL,
	[Days] [varchar](100) NULL,
 CONSTRAINT [PK_DoctorTiming] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[EmployeeWages]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[EmployeeWages](
	[WagesID] [int] IDENTITY(1,1) NOT NULL,
	[ContactID] [int] NULL,
	[PaymentType] [varchar](50) NULL,
	[SalaryAmount] [decimal](18, 0) NULL,
	[LoanAmount] [decimal](18, 0) NULL,
	[SalaryDate] [datetime] NULL,
	[Remarks] [varchar](200) NULL,
	[EnteredBy] [varchar](50) NULL,
	[UpdatedBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[DeletedBy] [varchar](50) NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL CONSTRAINT [DF_EmployeeWages_IsDeleted]  DEFAULT ((0)),
 CONSTRAINT [PK_EmplyeeWages] PRIMARY KEY CLUSTERED 
(
	[WagesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[ErrorLog]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ErrorLog](
	[ErrorID] [int] IDENTITY(1,1) NOT NULL,
	[ErrorDesc] [nvarchar](4000) NULL,
 CONSTRAINT [PK_ErrorLog] PRIMARY KEY CLUSTERED 
(
	[ErrorID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[FeesType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FeesType](
	[FeeTypeID] [int] IDENTITY(1,1) NOT NULL,
	[FeeType] [varchar](50) NULL,
 CONSTRAINT [PK_FeesType] PRIMARY KEY CLUSTERED 
(
	[FeeTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LabAsset]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[LabAsset](
	[AssetID] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeID] [int] NULL,
	[Quantity] [int] NULL,
	[Price] [decimal](18, 2) NULL,
	[CompanyName] [varchar](500) NULL,
	[InvoiceNo] [varchar](50) NULL,
	[InvoiceDate] [datetime] NULL,
	[EnteredDate] [datetime] NULL,
	[EnteredBy] [varchar](50) NULL,
	[DeletedDate] [datetime] NULL,
	[IsDeleted] [bit] NULL,
 CONSTRAINT [PK_LabAsset] PRIMARY KEY CLUSTERED 
(
	[AssetID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[LabAssetInventory]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LabAssetInventory](
	[InventoryID] [int] IDENTITY(1,1) NOT NULL,
	[AssetTypeID] [int] NULL,
	[StockIn] [int] NULL,
	[StockOut] [int] NULL,
	[StockQty] [decimal](18, 2) NULL,
 CONSTRAINT [PK_LabAssetInventory] PRIMARY KEY CLUSTERED 
(
	[InventoryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Organization]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING OFF
GO
CREATE TABLE [dbo].[Organization](
	[OrganizationID] [int] IDENTITY(1,1) NOT NULL,
	[OrgName] [varchar](100) NULL,
	[OrgAddress] [varchar](300) NULL,
	[OrgContactNo] [varchar](50) NULL,
	[OrgEmail] [varchar](50) NULL,
	[ContactPerson] [varchar](100) NULL,
	[IsActive] [bit] NULL,
 CONSTRAINT [PK_Organization] PRIMARY KEY CLUSTERED 
(
	[OrganizationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[OutDoorPatientTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[OutDoorPatientTest](
	[OutDoorTestID] [int] IDENTITY(1,1) NOT NULL,
	[TestNo] [varchar](100) NULL,
	[TestDate] [datetime] NULL,
	[PatientName] [varchar](100) NULL,
	[DoctorID] [int] NULL,
	[DoctorName] [varchar](100) NULL,
	[ContactNo] [varchar](50) NULL,
	[Age] [int] NULL,
	[Sex] [varchar](10) NULL,
	[TestID] [int] NULL,
	[Discount] [decimal](18, 2) NULL,
 CONSTRAINT [PK_OutDoorPatientTest] PRIMARY KEY CLUSTERED 
(
	[OutDoorTestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Pages]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Pages](
	[PageID] [int] IDENTITY(1,1) NOT NULL,
	[PageName] [varchar](200) NULL,
	[PageLink] [varchar](200) NULL,
 CONSTRAINT [PK_Pages] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientDischarge]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientDischarge](
	[PDID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NULL,
	[DischargeDate] [datetime] NULL,
	[Follow] [varchar](500) NULL,
	[Remarks] [varchar](500) NULL,
	[BriefSummary] [varchar](500) NULL,
	[InvestigationDrug] [varchar](500) NULL,
	[Treatment] [varchar](500) NULL,
	[Instructions] [varchar](500) NULL,
	[TakeHomeMedicine] [varchar](500) NULL,
 CONSTRAINT [PK_PatientDischarge] PRIMARY KEY CLUSTERED 
(
	[PDID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientDisgnosticTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientDisgnosticTest](
	[PatientTestID] [int] IDENTITY(1,1) NOT NULL,
	[TestID] [int] NULL,
	[PatientID] [int] NULL,
	[PatientName] [varchar](50) NULL,
	[ContactNo] [varchar](50) NULL,
	[DoctorName] [varchar](50) NULL,
	[Symptoms] [varchar](50) NULL,
	[Discount] [decimal](18, 0) NULL,
	[Remarks] [varchar](200) NULL,
	[Status] [varchar](50) NULL,
	[TestDate] [datetime] NULL,
	[Payment] [varchar](15) NULL,
	[Gender] [varchar](10) NULL,
	[Age] [int] NULL,
	[TestRange] [varchar](50) NULL,
	[Result] [varchar](50) NULL,
	[Pathologist] [varchar](50) NULL,
	[Technologist] [varchar](50) NULL,
	[LabNumber] [varchar](30) NULL,
	[DeliveryDate] [datetime] NULL,
	[EnteredBy] [varchar](50) NULL,
	[UpdatedDate] [datetime] NULL,
	[UpdatedBy] [varchar](50) NULL,
	[IsDeleted] [bit] NULL,
	[DeletedDate] [datetime] NULL,
	[DeletedBy] [varchar](50) NULL,
 CONSTRAINT [PK_PatientDisgnosticTest] PRIMARY KEY CLUSTERED 
(
	[PatientTestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientPanel]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientPanel](
	[PanelID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NULL,
	[OrganizationID] [int] NULL,
	[PanelLevel] [varchar](100) NULL,
	[LimitAmount] [decimal](18, 2) NULL,
	[Services] [varchar](100) NULL,
 CONSTRAINT [PK_PatientPanel] PRIMARY KEY CLUSTERED 
(
	[PanelID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientRegistration]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientRegistration](
	[PatientID] [int] IDENTITY(1,1) NOT NULL,
	[PatientCategory] [varchar](20) NULL,
	[PatientType] [varchar](50) NULL,
	[DoctorID] [int] NULL,
	[RoomID] [int] NULL,
	[PatientRegNo] [varchar](50) NULL,
	[FirstName] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[MiddleName] [varchar](50) NULL,
	[TakeCareName] [varchar](50) NULL,
	[TakeCareRelation] [varchar](50) NULL,
	[PatientCNIC] [varchar](50) NULL,
	[TakeCareCNIC] [varchar](50) NULL,
	[DateOfBirth] [date] NULL,
	[Gender] [varchar](8) NULL,
	[Age] [varchar](50) NULL,
	[MaritalStatus] [varchar](50) NULL,
	[Address] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[State] [varchar](50) NULL,
	[Country] [varchar](50) NULL,
	[Occupation] [varchar](50) NULL,
	[Telephone] [varchar](50) NULL,
	[MobileNo] [varchar](50) NULL,
	[GuardianName] [varchar](50) NULL,
	[GuardianContactNo] [varchar](50) NULL,
	[ReferBy] [varchar](50) NULL,
	[Diagnosis] [varchar](100) NULL,
	[SecondaryDiagnosis] [varchar](100) NULL,
	[AdmissionDate] [datetime] NULL,
	[Remarks] [varchar](500) NULL,
	[LaparoscopID] [int] NULL,
 CONSTRAINT [PK_PatientRegistration] PRIMARY KEY CLUSTERED 
(
	[PatientID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[PatientSurgery]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PatientSurgery](
	[SurgeryID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NULL,
	[SurgeryType] [varchar](50) NULL,
	[SurgeryDate] [datetime] NULL,
	[Anaesthetist] [varchar](50) NULL,
	[AnaesthetistType] [varchar](10) NULL,
	[OTTechnician1] [varchar](50) NULL,
	[OTTechnician2] [varchar](50) NULL,
	[OTTechnician3] [varchar](50) NULL,
	[OTTechnician4] [varchar](50) NULL,
	[OTTechnician5] [varchar](50) NULL,
	[SurgeryProcedure] [varchar](50) NULL,
	[Remarks] [varchar](500) NULL,
 CONSTRAINT [PK_PatientSurgery] PRIMARY KEY CLUSTERED 
(
	[SurgeryID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rack]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rack](
	[RackID] [int] IDENTITY(1,1) NOT NULL,
	[RackNo] [varchar](50) NULL,
 CONSTRAINT [PK_Rack] PRIMARY KEY CLUSTERED 
(
	[RackID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Rooms]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Rooms](
	[RoomID] [int] IDENTITY(1,1) NOT NULL,
	[Room] [varchar](50) NULL,
	[RoomType] [varchar](20) NULL,
	[RoomCharges] [nchar](10) NULL,
 CONSTRAINT [PK_Rooms] PRIMARY KEY CLUSTERED 
(
	[RoomID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[RoomStatus]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[RoomStatus](
	[RoomStatusID] [int] IDENTITY(1,1) NOT NULL,
	[RoomID] [int] NULL,
	[RoomStatus] [varchar](50) NULL,
 CONSTRAINT [PK_RoomStatus] PRIMARY KEY CLUSTERED 
(
	[RoomStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Transactions](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[PatientID] [int] NULL,
	[TransDate] [datetime] NULL,
	[Amount] [decimal](18, 2) NULL,
	[EnteredBy] [varchar](50) NULL,
	[PaymentType] [varchar](10) NULL,
	[CollectedBy] [varchar](50) NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Users]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](50) NULL,
	[Password] [varchar](50) NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  View [dbo].[IndoorPatients]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[IndoorPatients]
AS
SELECT     TOP (100) PERCENT pr.DoctorID, c.FirstName + ' ' + c.LastName AS DoctorName, pr.PatientID, pr.PatientRegNo, r.RoomType, r.Room, pr.FirstName + ' ' + pr.LastName AS PatientName, pr.Gender, 
                      pr.Age, pr.City, pr.Address, pr.AdmissionDate, pr.Diagnosis, pr.SecondaryDiagnosis, pr.MobileNo, pr.Telephone, pr.TakeCareName, pr.TakeCareRelation, pr.TakeCareCNIC, pr.GuardianName, 
                      pr.GuardianContactNo, pr.ReferBy, pr.Remarks AS PatientRegRemarks, ps.SurgeryType, ps.SurgeryDate, ps.AnaesthetistType, ps.Anaesthetist, ps.OTTechnician1, ps.OTTechnician2, 
                      ps.OTTechnician3, ps.OTTechnician4, ps.OTTechnician5, ps.SurgeryProcedure, ps.Remarks AS PatientSurveryRemarks, pd.DischargeDate, pd.Follow, pd.Remarks AS PatientDischargeRemarks, 
                      pd.BriefSummary, pd.InvestigationDrug, pd.Treatment, pd.Instructions, pd.TakeHomeMedicine
FROM         dbo.PatientRegistration AS pr INNER JOIN
                      dbo.Contact AS c ON pr.DoctorID = c.ContactID LEFT OUTER JOIN
                      dbo.Rooms AS r ON pr.RoomID = r.RoomID LEFT OUTER JOIN
                      dbo.PatientDischarge AS pd ON pr.PatientID = pd.PatientID LEFT OUTER JOIN
                      dbo.PatientSurgery AS ps ON pr.PatientID = ps.PatientID
ORDER BY pr.PatientRegNo

GO
/****** Object:  View [dbo].[Products]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE VIEW [dbo].[Products]
AS
	SELECT	p.ProductID, pt.ProductTypeID, s.StrengthID, p.ProductName + '  ' + s.Strength AS ProductName, pt.ProductType, 
			s.Strength, p.ProductCode, p.ProductRegNo, p.Formula, p.UnitPrice, 
			c.CompanyID, c.Company, isnull(p.IsOTProduct, 0) as IsOTProduct
	FROM 
		dbo.Product AS p 
		INNER JOIN dbo.ProductType AS pt ON p.ProductTypeID = pt.ProductTypeID 
		INNER JOIN dbo.Strength AS s ON p.StrengthID = s.StrengthID 
		INNER JOIN dbo.Company AS c ON p.CompanyID = c.CompanyID





GO
SET IDENTITY_INSERT [dbo].[AssignPages] ON 

INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (1, 41, N'Dashboard', 1, 1, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (5, 0, N'Employee Management', 5, 1, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (6, 18, N'Contact Category', 0, 1, 5, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (7, 19, N'Doctor List', 1, 1, 98, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (8, 20, N'Add New Doctor', 2, 1, 98, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (9, 21, N'Staff', 0, 1, 5, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (10, 22, N'Add New Staff', 0, 1, 5, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (11, 0, N'Pharmacy', 0, 1, 0, 0)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (12, 0, N'Pharmacy Management', 6, 0, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (13, 1, N'Pharma Company', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (14, 2, N'Product Type', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (15, 3, N'Product Strength', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (16, 4, N'Product', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (17, 5, N'Opening Stock', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (18, 7, N'Medicine Purchase', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (19, 8, N'Medicine Sale', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (20, 9, N'Medicine Return', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (21, 10, N'Stock Checking', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (22, 11, N'Medicine Barcode', 0, 1, 12, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (24, 0, N'Pharmacy Report', 10, 0, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (26, 13, N'Daily Sale', 0, 1, 24, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (27, 14, N'Monthly Sale Report', 0, 1, 24, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (28, 16, N'Monthly Purchase', 0, 1, 24, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (30, 23, N'OPD Token', 1, 1, 99, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (31, 24, N'Laboratory Token', 2, 1, 99, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (32, 25, N'Department', 6, 1, 98, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (34, 26, N'Doctor Fee Type', 3, 1, 98, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (35, 27, N'Doctor Fee', 4, 1, 98, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (36, 28, N'Doctor Timing', 5, 1, 98, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (44, 0, N'Finance Report', 11, 0, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (46, 34, N'Daily OPD', 0, 1, 44, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (47, 35, N'OPD Summary', 0, 1, 44, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (48, 36, N'Investigation Test Summary', 0, 1, 44, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (49, 47, N'Daily Investigation Test', 0, 1, 44, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (57, 0, N'Pharmacy', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (58, 1, N'Pharma Company', 0, 1, 57, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (59, 2, N'Product Type', 0, 1, 57, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (60, 3, N'Product Strength', 0, 1, 57, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (61, 4, N'Product', 0, 1, 57, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (62, 5, N'Opening Stock', 0, 1, 57, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (63, 7, N'Medicine Purchase', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (64, 8, N'Medicine Sale', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (65, 9, N'Medicine Return', 0, 1, 0, 0)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (66, 9, N'Medicine Return', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (67, 10, N'Stock Checking', 0, 1, 0, 0)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (68, 11, N'Medicine Barcode', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (69, 10, N'Stock Checking', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (70, 0, N'Pharmacy Report', 0, 1, 0, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (72, 13, N'Daily Sale', 0, 1, 70, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (73, 14, N'Monthly Sale Report', 0, 1, 70, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (74, 16, N'Monthly Purchase', 0, 1, 70, 4)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (75, 41, N'Dashboard', 0, 1, 0, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (76, 0, N'Maidah Center', 0, 1, 0, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (77, 23, N'Patient Appointment', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (78, 24, N'Investigation Test', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (79, 25, N'Department', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (80, 6, N'Diagnostic Test', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (81, 26, N'Doctor Fee Type', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (82, 27, N'Doctor Fee', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (83, 28, N'Doctor Timing', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (84, 29, N'Room Setup', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (85, 30, N'Patient Registration', 0, 1, 76, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (86, 0, N'Finance', 0, 1, 0, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (90, 0, N'Finance Report', 0, 1, 0, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (91, 34, N'Daily OPD', 0, 1, 90, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (92, 35, N'OPD Summary', 0, 1, 90, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (93, 47, N'Daily Investigation Test', 0, 1, 90, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (94, 36, N'Investigation Test Summary', 0, 1, 90, 5)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (98, 0, N'Doctor Management', 3, 1, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (99, 0, N'Token Management', 2, 1, 0, 1)
INSERT [dbo].[AssignPages] ([AssignPageID], [PageID], [LabelName], [Sequence], [IsActive], [ParentPageID], [ContactTypeID]) VALUES (100, 41, N'Dashboard', 0, 1, 100, 1)
SET IDENTITY_INSERT [dbo].[AssignPages] OFF
SET IDENTITY_INSERT [dbo].[Contact] ON 

INSERT [dbo].[Contact] ([ContactID], [ContactTypeID], [DepartmentID], [FirstName], [LastName], [Email], [Address], [Address2], [City], [Province], [Country], [UserName], [Password], [Telephone], [Mobile], [Status], [Website], [Qualification], [Experience], [JoiningDate], [EnteredDate], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (1, 1, 0, N'Manik', N'Khuwaja', N'manik@gmail.com', N'Karachi', N'Karachi', N'Karachi', N'Sindh', N'Pakistan', N'admin', N'admin', NULL, N'03352250407', NULL, NULL, NULL, NULL, NULL, CAST(N'2017-04-04 00:00:00.000' AS DateTime), N'admin', N'Muhammad Paryal', CAST(N'2017-05-03 00:00:00.000' AS DateTime), NULL, CAST(N'2017-04-04 00:00:00.000' AS DateTime), 0)
INSERT [dbo].[Contact] ([ContactID], [ContactTypeID], [DepartmentID], [FirstName], [LastName], [Email], [Address], [Address2], [City], [Province], [Country], [UserName], [Password], [Telephone], [Mobile], [Status], [Website], [Qualification], [Experience], [JoiningDate], [EnteredDate], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (55, 3, 1, N'Manik', N'Mehfooz', N'manik_tarani@outlook.com', N'Karachi', NULL, N'Karachi', N'Karachi', N'Pakistan', N'admin', N'admin', N'03352250407', N'03352250407', NULL, NULL, NULL, NULL, CAST(N'2022-01-01 00:45:09.307' AS DateTime), CAST(N'2022-01-01 00:00:00.000' AS DateTime), N'Manik Khuwaja', NULL, CAST(N'2022-01-01 00:00:00.000' AS DateTime), NULL, CAST(N'2022-01-01 00:00:00.000' AS DateTime), 0)
SET IDENTITY_INSERT [dbo].[Contact] OFF
SET IDENTITY_INSERT [dbo].[ContactType] ON 

INSERT [dbo].[ContactType] ([ContactTypeID], [ContactType]) VALUES (1, N'ADMIN')
INSERT [dbo].[ContactType] ([ContactTypeID], [ContactType]) VALUES (2, N'STAFF')
INSERT [dbo].[ContactType] ([ContactTypeID], [ContactType]) VALUES (3, N'Doctor')
INSERT [dbo].[ContactType] ([ContactTypeID], [ContactType]) VALUES (4, N'Store Keeper')
INSERT [dbo].[ContactType] ([ContactTypeID], [ContactType]) VALUES (5, N'Computer Operator')
SET IDENTITY_INSERT [dbo].[ContactType] OFF
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (2, N'Tarivid   Tablet   200 mg', 744)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (3, N'Vermox   Syrup   30 ml', 33)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (4, N'Acefyl   Syrup   120 ml', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (5, N'Cannula  Master   Canulla   18', -455)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (7, N'Vericef   Injection   1 g', -21)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (10, N'Osnate   Tablet   D', 720)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (11, N'DBurn   Tablet   30 mg', -13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (13, N'Toni5   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (14, N'Rabixin   Capsul   20 mg', 3821)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (15, N'Unifyline   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (16, N'Prolexa   Tablet   10 mg', 2307)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (17, N'Reducid   Syrup   120 ml', 203)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (19, N'Lipiget   Tablet   10 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (20, N'cycin   Tablet   500 mg', 290)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (21, N'Eftax   Injection   1000 mg', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (22, N'Lenwin   Injection   1000 mg', -146)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (23, N'Risek   Injection   40 mg', 137)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (24, N'Ronil   Injection   1000 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (25, N'Nexum   Injection   40 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (26, N'Yorker   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (27, N'Cefotax   Injection   1000 mg', -48)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (28, N'Nitaxim   Injection   1000 mg', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (29, N'Gentic   Injection   80', -1143)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (30, N'Velosef   Injection   1000 mg', -58)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (31, N'Cefrinex   Injection   500 mg', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (32, N'NovoTEpH   Injection   40 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (33, N'Safepime   Injection   500 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (34, N'Ringolact PLEN   Injection   1000 ml', -2852)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (61, N'Metoclon   Injection   10 mg', -74)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (64, N'Propofol   Injection   10 mg', -90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (65, N'Tricrium   Injection   2.5', -68)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (66, N'Pyrolate Plain   Injection   1 ml', -129)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (67, N'New Pyrolate   Injection   1 ml', -147)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (68, N'Cremp Bendej   Sergical   6 INCH', -83)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (69, N'Cremp Bendej   Sergical   4 INCH', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (72, N'ETT TubE   Sergical   7', -136)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (73, N'CATHETER   Sergical   10', -20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (76, N'Spinal nedl   Sergical   25', -635)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (77, N'Ketasol   Injection   2 ml', 43)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (78, N'Drip set   Sergical   00', -3923)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (79, N'Urin beg   Sergical   Norml', -513)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (81, N'Synotcinon   Injection   2 ml', -2752)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (82, N'Xylocain 2%   Injection   10 ml', -55)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (83, N'Xylcain. Adernalen   Injection   10 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (84, N'Sprit botal   Sergical   10 ml', -766)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (86, N'Cromic   Sergical   3/0', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (88, N'Chromic   Sergical   2', -721)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (89, N'Prolen   Sergical   4/0', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (90, N'Prolen   Sergical   2/0', -7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (93, N'Dexon   Sergical   2', -16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (95, N'card clamp   Sergical   Norml', -496)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (96, N'deponet page   Sergical   5 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (97, N'synephrine   Injection   10 mg', -30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (99, N'Cotton larg   Sergical   200 mg', -137)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (100, N'Cotton Bandage   Sergical   6 INCH', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (101, N'Toradol   Injection   30 mg', -583)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (103, N'Feeding tube   Sergical   14', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (104, N'Transamin   Injection   500 mg', -66)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (105, N'Tonoflex   Injection   2 ml', -488)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (107, N'Mesh   Sergical   Large', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (108, N'Mesh   Sergical   Smal', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (109, N'Mepore   Sergical   Large', -544)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (110, N'Forane   Sergical   50 ml', -106)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (111, N'Breeky   Tablet   200 mg', -55)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (112, N'Rocephin   Injection   1000 mg', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (114, N'DISPOSABLE  SYRINGE   Sergical   60 ml', -100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (115, N'DISPOSABLE  SYRINGE   Sergical   5 ml', -11965)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (116, N'DISPOSABLE  SYRINGE   Sergical   10 ml', 449)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (117, N'BLADE   Sergical   22', -1302)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (118, N'PROVAS   Injection   100 ml', -231)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (119, N'DISPOSABLE  SYRINGE   Sergical   3 ML', 2254)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (120, N'GAZ PED   Sergical   Smal', -10304)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (123, N'Sergical Tap 1 inch   Sergical   1 iNch', -1724)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (124, N'Roll Toll   Sergical   6 INCH', -18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (126, N'Roll Toll   Sergical   4 INCH', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (128, N'Mouth Wash piyden   Sergical   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (129, N'Gypsona   Sergical   6 INCH', -27)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (130, N'Gypsona   Sergical   4 INCH', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (131, N'Piyoden Gel   Sergical   20 mg', 56)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (132, N'Sofra Tule   Sergical   Norml', -23)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (133, N'Ringollact D   Injection   500 ml', -20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (134, N'Norml silaien   Injection   1000 ml', -1244)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (135, N'Norml silaien    Injection   500 ml', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (136, N'Spunj jel   Sergical   Norml', -8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (137, N'Zitum   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (138, N'Amtraxa   Injection   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (140, N'Cefstar   Injection   250 mg', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (141, N'Traix   Injection   1000 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (142, N'Leflox   Capsul   500 mg', 404)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (143, N'Calwood C   Sachets   00', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (144, N'Trometh   Injection   30 mg', 119)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (145, N'NEXIN   Tablet   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (147, N'VERICEF   Injection   1000 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (148, N'AMINOVEL   Injection   500 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (149, N'AMINOLBEON   Injection   500 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (150, N'LIPRON   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (151, N'Rovec   Tablet   2', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (152, N'E  tone   Tablet   500 mg', -30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (153, N'Bofalgan   Injection   100 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (154, N'Transamin   Injection   250 mg', 0)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (155, N'Bislri   Injection   100 ml', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (156, N'Velosef   Injection   500 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (157, N'Nivador   Injection   1000 mg', -8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (158, N'Nivador   Injection   250 mg', 54)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (159, N'Nivador   Injection   500 mg', -9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (160, N'Maxef   Injection   1000 mg', -13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (161, N'Distel Water   Injection   5 ml', -10076)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (162, N'Kinz   Injection   2 ml', -913)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (165, N'SUPRAVIT M   Tablet   Norml', 1133)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (168, N'Caldree   Tablet   600', 540)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (169, N'Nebrol   Tablet   Forte', 3631)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (170, N'Risek   Capsul   40 mg', 585)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (171, N'Blood Beg   Sergical   5 Units', 8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (172, N'ROCEREX   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (173, N'Zinacef   Injection   750 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (174, N'Fortum   Injection   1000 mg', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (175, N'Fortum   Injection   250 mg', 34)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (176, N'LEARCE   Injection   5 ml', 11)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (177, N'QZON   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (178, N'RYXON   Injection   1000 mg', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (179, N'Neurobion   Injection   1000 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (180, N'biocobal   Injection   500 mg', 59)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (181, N'Methecobal   Injection   500 mg', 21)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (182, N'Augmentin   Injection   1.2 g', -24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (183, N'Augmentin   Tablet   1000 mg', -946)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (184, N'Augmentin   Tablet   625 mg', 879)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (185, N'Augmentin   Tablet   375 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (186, N'Inflametix   Tablet   100 mg', 550)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (187, N'Benziam   Injection   40 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (188, N'Noflox   Tablet   500 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (189, N'Iceca   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (190, N'Polmalt   Tablet   100 mg', 269)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (191, N'Poymalt F   Tablet   100 mg', 240)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (192, N'Pytex   Tablet   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (193, N'Sunvit   Injection   1 ml', 190)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (194, N'Alfacoleen   Injection   250 mg', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (195, N'Leflox   Injection   500 mg', 234)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (196, N'Novidat Ds   Injection   400 mg', 59)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (197, N'Novidat Plen   Injection   200 mg', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (198, N'Cravit   Injection   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (199, N'Neumo   Injection   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (200, N'Quash   Injection   200 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (201, N'Hyzonate   Injection   250 mg', -79)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (202, N'Hyzonate   Injection   100 mg', 182)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (203, N'Oflobid   Injection   200 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (204, N'Avelox   Injection   400 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (205, N'Moxiget   Injection   400 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (206, N'Izilion   Injection   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (207, N'Xefecta   Injection   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (208, N'Artem   Injection   80', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (209, N'Rotem   Injection   80', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (210, N'Mether   Injection   80', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (211, N'Hifer   Injection   5 ml', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (214, N'Neolac mama   Milk   200 mg', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (215, N'Recept   Tablet   2 mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (216, N'Zantac   Tablet   150 mg', 1252)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (217, N'Avil   Injection   2 ml', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (218, N'K KART   Injection   1 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (219, N'CEFIZOX   Injection   1000 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (220, N'VERICEF   Injection   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (221, N'Fortazim   Injection   500 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (222, N'DERMAZIN   Cream   25 gm', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (223, N'Peonor   Tablet   40 mg', 420)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (224, N'CaC PLUS   Tablet   1000', 680)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (225, N'DIGAS   Drops   20 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (226, N'Qamberi   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (227, N'Eskem   Capsul   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (228, N'Mixel   Tablet   200 mg', 25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (229, N'Bonide   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (230, N'Emess   Capsul   40 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (231, N'Dayline   Injection   1000 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (232, N'Dayline   Injection   500 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (233, N'EXEF   Injection   1000 mg', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (234, N'Theragran M   Tablet   Norml', 1801)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (235, N'Neoprox   Tablet   500 mg', 1086)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (236, N'Secure   Capsul   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (237, N'DISTALGESIC   Tablet   325 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (238, N'Calfina PLUS   Tablet   325 mg', 332)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (239, N'G Cal   Injection   Vitamin D3', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (240, N'Nims   Tablet   100 mg', 258)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (241, N'Moxina   Capsul   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (242, N'Ufrim   Tablet   10 mg', 1462)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (243, N'Polymalt F   Tablet   100 mg', 240)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (244, N'NOVDAT   Tablet   500 mg', 720)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (245, N'NOVDAT   Tablet   250 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (246, N'Ciproxin   Tablet   500 mg', 1388)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (247, N'Ciproxin   Tablet   250 mg', 310)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (248, N'Rivotril   Tablet   0.5 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (249, N'Valium   Injection   2 ml', 32)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (250, N'Bejectal   Injection   10 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (251, N'Osfena   Tablet   Norml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (252, N'Sunvit   Injection   Vitamin D3', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (253, N'Grasil   Injection   500 mg', -205)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (254, N'Grasil   Injection   250 mg', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (255, N'Grasil   Injection   100 mg', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (256, N'Amkay   Injection   500 mg', -39)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (257, N'Amkay   Injection   250 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (258, N'Amkay   Injection   100 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (260, N'PMEPLUS   Capsul   40 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (261, N'Tonoflex P   Tablet   Norml', 89)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (262, N'Gravibinan   Injection   2 ml', 74)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (263, N'EURO   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (264, N'EURO   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (265, N'Bakal   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (266, N'AZIROM   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (267, N'MEDIGESIK FORTE   Tablet   Forte', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (268, N'Celebex   Capsul   100 mg', 190)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (269, N'Seleco   Tablet   200 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (270, N'ZULTRCET   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (271, N'Pentoxol M   Tablet   10 mg', 7970)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (272, N'ACETRA   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (273, N'Tramal Plus   Tablet   Norml', 1572)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (274, N'Tramapar   Tablet   Norml', 770)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (275, N'NULCER   Tablet   150 mg', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (276, N'Ossobon D   Tablet   Norml', 1805)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (278, N'SCIFEX   Capsul   400 mg', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (279, N'Sterol D   Capsul   Vitamin D3', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (280, N'CANULLA   Sergical   16', -13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (281, N'CATHETER   Sergical   10. 2 Way', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (282, N'Delka   Injection   40 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (283, N'Pepnor   Tablet   40 mg', 280)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (285, N'Kestine   Tablet   10 mg', 672)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (286, N'GLYVISOL   Syrup   240 ML', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (287, N'Hepa Marz   Syrup   120 ml', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (288, N'Dijirex   Syrup   120 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (289, N'VIOPHOS B   Syrup   240 ML', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (290, N'HAEMPLEX   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (291, N'ADAPLEX   Syrup   120 ml', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (292, N'ENRICH   Syrup   240 ML', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (293, N'ADICOS   Syrup   120 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (294, N'Polmalt   Syrup   120 ml', 124)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (295, N'Orex Plus   Syrup   120 ml', 104)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (297, N'Mensocare   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (298, N'rodexib   Syrup   60 ml', 125)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (299, N'Proasma   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (300, N'Aptizyme   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (301, N'PRILIUM   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (302, N'Recept   Syrup   60 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (303, N'TUSCOLIN   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (304, N'PELTON V   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (305, N'Globocid   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (306, N'Pelton C   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (307, N'LITHIOGON   Syrup   120 ml', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (308, N'Amico m   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (309, N'De flu   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (310, N'Peditral      Liquid   500 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (311, N'Emiset   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (312, N'PROSPAN   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (313, N'Motilium   Syrup   120 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (314, N'Motilium   Tablet   10', 1997)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (315, N'Unifylin   Syrup   60 ml', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (316, N'Apizyt   Syrup   120 ml', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (317, N'Bakal   Syrup   120 ml', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (318, N'FIORE   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (319, N'Benziam   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (320, N'Hilixa   Syrup   120 ml', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (321, N'ARINAC   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (322, N'ARINAC   Tablet   Norml', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (323, N'ARINAC   Tablet   Forte', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (324, N'VIVASE   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (325, N'Cosome   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (326, N'tres orix   Syrup   120 ml', 26)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (327, N'Cip Val   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (328, N'Leflox   Capsul   750 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (329, N'Leflox   Capsul   250 mg', 330)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (330, N'Getrl    Tablet   2 mg', 487)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (331, N'Getrl    Tablet   4 mg', 58)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (332, N'Getrl    Tablet   3 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (333, N'Montiget   Tablet   10 mg', 318)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (334, N'Gonadil f   Capsul   Forte', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (335, N'Mex Flow   Capsul   0.4 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (336, N'ADVANT   Capsul   8 MG', 83)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (337, N'Cipesta   Tablet   500 mg', 1445)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (338, N'Cipesta   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (339, N'Fexet    Tablet   60 mg', 174)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (340, N'Zafon fast   Tablet   8 MG', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (341, N'Acabel   Tablet   8 MG', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (342, N'Vpride   Tablet   1 gm', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (343, N'Vpride   Tablet   2 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (344, N'Cifiget   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (345, N'Avelox   Capsul   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (346, N'Zerefax   Tablet   550 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (347, N'Moxiget   Tablet   400 mg', 275)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (348, N'Fexet D   Tablet   60+120 mg', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (349, N'Fexet    Tablet   120 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (350, N'Rovista   Tablet   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (351, N'Orlifit   Capsul   120 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (352, N'ADVANT   Tablet   16', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (353, N'Advant   Tablet   16 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (354, N'Progyluton   Tablet   Norml', 42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (355, N'Gravibinan   Injection   1 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (356, N'Lexotanil   Tablet   3 mg', 720)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (357, N'Premolet N   Tablet   5 mg', 360)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (360, N'Cefspan   Capsul   400 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (361, N'Fucidin   Tablet   250 mg', 61)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (362, N'Fusiderm   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (363, N'Rivotril   Tablet   2 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (364, N'Librex   Tablet   Norml', 600)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (365, N'Valium   Tablet   5 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (366, N'Dormicum   Tablet   7.5', 20)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (367, N'Capoten   Tablet   25 gm', 77)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (368, N'Rivotril   Drops   2.5', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (370, N'Zopent   Tablet   40 mg', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (371, N'Xikarapid   Tablet   8 MG', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (372, N'Citanew   Tablet   5 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (373, N'Citanew   Tablet   10 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (374, N'Transamin   Capsul   500 mg', 320)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (375, N'Transamin   Capsul   250 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (376, N'Oflobid   Tablet   200 mg', 310)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (377, N'Ferosoft   Tablet   Forte', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (378, N'Dulan   Tablet   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (379, N'Dulan   Tablet   30 mg', 58)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (380, N'Neogab   Capsul   100 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (381, N'Neogab   Capsul   300 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (382, N'Xobix   Tablet   7.5', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (383, N'Xefecta   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (384, N'Cefim   Capsul   400 mg', -12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (385, N'Zeegap   Capsul   25 gm', 42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (386, N'Zeegap   Capsul   100 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (387, N'Neproxin   Tablet   500 mg', 506)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (388, N'Itaglip Plus   Tablet   50+500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (389, N'Neo Sedil   Tablet   5 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (390, N'Mosigar   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (391, N'Azitma   Tablet   250 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (392, N'Sante   Capsul   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (393, N'Himuty   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (395, N'VIVASE   Tablet   Forte', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (396, N'Anzo   Capsul   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (397, N'CITOLIN   Injection   2 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (398, N'VIOSPAN   Capsul   400 mg', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (399, N'URIXIN   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (400, N'Sparxin   Tablet   100 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (401, N'NOVIDAT   Tablet   500 mg', 388)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (402, N'Enoxabid   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (403, N'Ceclor   Capsul   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (404, N'Ceclor   Capsul   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (405, N'Duphaston   Tablet   10 mg', 620)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (406, N'Ad Folic   Tablet   600', 1200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (407, N'Ad Folic   Tablet   300 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (408, N'D 4 u   Injection   Vitamin D3', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (409, N'Mexfol   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (410, N'Locyst   Tablet   Norml', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (411, N'Myfol   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (412, N'Cedrox   Tablet   1000 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (413, N'Cedrox   Capsul   500 mg', 156)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (414, N'Polymalt   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (415, N'Tormax   Tablet   550 mg', 1080)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (416, N'Anafortan Plus   Tablet   Norml', 840)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (417, N'Spasle Neo   Tablet   Norml', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (418, N'Orpadol   Tablet   Norml', -10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (419, N'ALGOSIN   Tablet   500 mg', 242)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (420, N'Maxron   Capsul   0.4 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (421, N'SOLIF   Tablet   5 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (422, N'Brexin   Tablet   20 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (423, N'Novidat   Tablet   250 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (424, N'Linez   Tablet   600', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (429, N'Panadol   Tablet   Norml', 3478)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (432, N'Amaryl   Tablet   4 mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (434, N'Neomo   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (435, N'Azomax   Tablet   500 mg', 192)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (436, N'Doxium   Capsul   500 mg', 280)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (437, N'DEFAL   Tablet   80.480 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (438, N'Neuromet 500 mg   Tablet   500 mg', 1300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (439, N'Neromet   Injection   500 mg', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (440, N'Lian   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (441, N'Cranze   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (442, N'Win Pro   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (443, N'Myfolic   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (444, N'Abocran   Sachets   Norml', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (445, N'FIBO   Powder   JAR', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (446, N'Ulcerex   Injection   2 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (447, N'NULCER   Injection   2 ml', -244)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (448, N'Bestrix   Injection   1000 mg', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (449, N'BREEZON   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (450, N'Qufen SR   Tablet   100 mg', 210)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (451, N'ESTEZEN   Tablet   1 gm', 900)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (453, N'POLYSLING   Sergical   Large', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (455, N'Salbo   Inhaler   100 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (456, N'Norml silaien   Injection   100 ml', -35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (457, N'Postersian   Cream   10 mg', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (458, N'PIRE 4   Tablet   Norml', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (459, N'PIRE 3   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (460, N'Canestin   Tablet   0.5 mg', 105)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (461, N'Canestin   Cream   0.5 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (462, N'Pamper   Baby Atum   Smal', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (463, N'FEEDER   Baby Atum   Smal', 107)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (464, N'REMETHAN   Injection   75 MG', 89)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (465, N'Myrin P   Tablet   Forte', 297)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (467, N'Dexa   Injection   1 ml', -39)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (468, N'Chamber   Sergical   100 ml', -25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (469, N'Grat   Tablet   325 mg', 175)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (470, N'CollaFlex   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (471, N'Proteen   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (472, N'CALCIUM GLUCONET   Injection   10 %', -12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (473, N'AMINOFILIN   Injection   250 mg', -21)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (474, N'Ciprox   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (475, N'RISP   Tablet   1 gm', 54)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (476, N'RISP   Tablet   2 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (477, N'RISP   Tablet   3 mg', 18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (478, N'Epuram   Tablet   Norml', 0)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (479, N'Daktarin   Cream   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (480, N'STABLON   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (481, N'AGNAR   Tablet   Vitamin D3', 750)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (482, N'Mosegar   Syrup   60 ml', 97)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (483, N'Mosigar V   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (486, N'Fibo   Syrup   120 ml', 66)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (487, N'ZYRTEC   Syrup   60 ml', 57)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (488, N'T Day   Syrup   60 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (489, N'Ulsanic   Syrup   60 ml', 51)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (490, N'Dapakan   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (491, N'KROFF   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (492, N'NT TOX   Syrup   60 ml', 109)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (493, N'TONI 5   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (494, N'Multibionta   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (495, N'FORO     Syrup   120 ml', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (496, N'Eeat M   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (497, N'GENEM DS   Syrup   30 ml', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (498, N'GEN M   Syrup   30 ml', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (499, N'LEDERPLEX   Syrup   120 ml', 18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (500, N'Piriton   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (501, N'Neon   Injection   1 g', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (503, N'Abocain   Injection   2 ml', -838)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (504, N'Gaviscon   Syrup   120 ml', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (505, N'Panadol   Syrup   120 ml', 31)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (506, N'BRUFEN   Syrup   120 ml', 122)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (507, N'Augmentin DS   Syrup   5 ml', 23)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (511, N'Navitas   Syrup   120 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (512, N'CALPOL   Syrup   100 ml', 107)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (513, N'CALPOL 6 PLUS   Syrup   90 ML', 37)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (514, N'BRUFEN DS   Syrup   90 ML', 57)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (515, N'Gravinate   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (516, N'Cremaffin   Syrup   120 ml', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (517, N'Hydryllin   Syrup   120 ml', 84)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (518, N'Dijex MP   Syrup   120 ml', 19)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (519, N'Febrol DS   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (520, N'Panadol   Drops   20 ml', 193)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (521, N'Panadol Fort   Syrup   90 ML', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (522, N'Tixylix   Syrup   120 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (523, N'Entamizole   Syrup   90 ML', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (524, N'Secure DS   Syrup   30 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (525, N'Phenergan   Syrup   120 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (526, N'Caricef   Syrup   30 ml', 68)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (527, N'Caricef DS   Syrup   30 ml', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (528, N'Secure   Syrup   30 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (529, N'LACASIL   Syrup   120 ml', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (530, N'Febrol   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (531, N'Amoxil Plen   Syrup   90 ML', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (532, N'Zinat OD   Syrup   60 ml', 21)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (533, N'Rigix   Syrup   60 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (534, N'Spasler P   Syrup   60 ml', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (536, N'Laxoberon   Syrup   120 ml', 25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (537, N'Laxoberon   Tablet   Norml', 988)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (539, N'Bisleri   Syrup   60 ml', 84)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (540, N'Neo Sedil   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (541, N'Lilac   Syrup   120 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (542, N'Hydrllin DM   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (543, N'RIFAPIN H   Syrup   50 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (544, N'Hydrllin Sugar fre   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (545, N'Kolac   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (546, N'Linctus   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (547, N'Novidat   Syrup   250 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (548, N'Novidat Ds   Injection   100 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (549, N'Novidat   Injection   100 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (550, N'Novidat   Syrup   125 mg', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (551, N'Slate   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (552, N'VIDAYLIN M   Syrup   120 ml', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (553, N'VIDAYLIN    Syrup   120 ml', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (554, N'SURBEX   Syrup   120 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (555, N'VIDAYLIN  L   Syrup   120 ml', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (556, N'Iberet   Syrup   500 mg', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (557, N'Silliver   Syrup   120 ml', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (560, N'SLIX   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (561, N'Ponstan Fort   Tablet   500 mg', -2162)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (562, N'Omeplus   Capsul   40 mg', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (563, N'MAXRON   Tablet   0.4 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (566, N'Dol P   Tablet   325 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (567, N'NO SPA   Tablet   Forte', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (568, N'VITAMIN D   Injection   Vitamin D3', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (569, N'PT Strip   Female use   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (570, N'Gyala   Capsul   400 mg', 33)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (571, N'mep   Injection   40 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (572, N'Samerol N    Tablet   Forte', -35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (573, N'LOPRIN   Tablet   75 MG', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (574, N'Lincocin   Syrup   60 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (575, N'Tariflox   Tablet   200 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (576, N'Presage   Injection   5000 IU', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (577, N'ZENTEL   Syrup   Norml', 26)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (578, N'ZENTEL   Tablet   Norml', 46)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (579, N'Norvasc   Tablet   5 mg', 299)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (580, N'Norvasc   Tablet   10 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (582, N'NYSA   Tablet   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (583, N'QUPRON   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (584, N'QUPRON   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (585, N'ACENAC   Tablet   100 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (586, N'PREGY   Capsul   75 MG', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (587, N'Spiromide   Tablet   20 mg', 160)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (588, N'Spiromide   Tablet   40 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (589, N'Pulmitac   Tablet   10 mg', 134)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (590, N'NORML SILAIN   Injection   1000 ml', -22)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (592, N'glaves   Sergical   7.5', -3781)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (593, N'Cefrenex   Injection   1000 mg', -357)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (594, N'CranEze   Sachets   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (595, N'Concor   Tablet   5 mg', 175)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (596, N'Voren   Injection   3 ML', -265)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (597, N'Imatet   Injection   1 ml', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (598, N'AMCLAV   Tablet   1 g', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (600, N'Prothiaden   Tablet   25 gm', 3392)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (602, N'Bisleri   Tablet   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (603, N'Multibionta   Injection   Multivitamin', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (607, N'Drep Sheet   Sergical   Norml', -17)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (608, N'Gaown   Sergical   Norml', -129)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (609, N'Baby Sheet   Sergical   Norml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (610, N'HYDROGEN    Sergical   60 ml', -45)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (611, N'Xynosine   Drops   20 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (612, N'Cathetar   Sergical   No 24 3 Way', -18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (613, N'Cebac   Injection   1 g', -27)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (614, N'STOMACH TUBE   Sergical   16 NUMBR', -24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (615, N'ROPICAN   Injection   10 ml', 91)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (616, N'URO BAG   Sergical   Norml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (617, N'Gentic   Injection   20', -29)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (618, N'Cefcom   Injection   1000 mg', -27)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (619, N'S Choline   Injection   2 ml', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (622, N'Gulocophage   Tablet   1 g', 250)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (623, N'Zinacef1   Injection   1.5 mg', -54)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (624, N'Ciproxin   Injection   0.2 g', -13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (625, N'Airway   Sergical   Norml', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (626, N'Cefamezin   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (627, N'Dipam   Injection   2 ml', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (628, N'Urgesin   Tablet   5mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (629, N'EvoFix   Tablet   400 mg', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (630, N'Abnil   Capsul   120 mg', 54)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (631, N'Morcet   Tablet   10 mg', 11)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (632, N'Lyssa   Tablet   300 mg', 490)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (633, N'Inferno   Tablet   500 mg', -10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (634, N'Gencox   Tablet   60 ml', 5136)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (635, N'blush   Syrup   60 ml', 125)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (636, N'Apranax   Tablet   550 mg', 1457)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (637, N'S/Choline   Injection   5 ml', -115)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (638, N'Gwon   Sergical   xl', -24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (639, N'Dreep Sheet   Sergical   xl', -140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (640, N'Belimil   Milk   400 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (641, N'perper   Sachets   00', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (642, N'Razodex   Capsul   60 mg', 236)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (643, N'Razodex   Capsul   30 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (644, N'Dextop   Capsul   60 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (645, N'Maksfin   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (646, N'NewFol   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (647, N'Citograin   Tablet   500 mg', 170)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (648, N'Neevo   Tablet   Multivitamin', 220)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (649, N'LANZIT   Capsul   30 mg', 125)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (650, N'Polyfer   Tablet   Multivitamin', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (651, N'Safepram   Tablet   10', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (652, N'Seloxx   Capsul   100 mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (653, N'Cystone   Tablet   60 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (654, N'Liv.52   Tablet   set', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (655, N'seloxx   Capsul   200 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (656, N'Cefon   Injection   1 g', -32)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (657, N'Orno   Injection   8 MG', -94)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (658, N'Acabel   Injection   8 MG', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (659, N't   Tablet   120 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (660, N'Swab   Sergical   Norml', -400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (661, N'Atropin   Injection   5 ml', -60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (662, N'Bandage   OT   6 INCH', -1488)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (663, N'Trispan   Capsul   400 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (664, N'caricef    Tablet   400 mg', 68)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (665, N'Hilixophin   Injection   1000 mg', -147)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (666, N'Tramal   Injection   100 ml', -48)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (667, N'Spinal Needle   Cream   5 ml', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (668, N'Plabolyt M   Injection   1000 mg', -155)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (669, N'viryl   Sergical   1', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (671, N'Calamox   Injection   1.2 g', -708)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (673, N'Blucef   Injection   1 g', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (674, N'Ceflactam   Injection   1 g', -117)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (675, N'Ceflactam   Injection   0.2 g', -16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (676, N'Britanyl   Syrup   60 ml', 169)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (677, N'Crantop   Sachets   250 mg', 59)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (678, N'Barizolid   Tablet   600', 137)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (679, N'Caldree   Ds  600+400   Tablet   600', 119)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (680, N'Vida /z   Tablet   100 ml', 270)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (681, N'0.18 D/s   Injection   500 ml', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (683, N'0.45 D/s   Injection   500 ml', -51)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (685, N'Vidaylin   Drops   10 ml', 68)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (686, N'ringolat   Injection   500 ml', -96)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (687, N'vicryl puls  70cm   Sergical   1', -113)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (688, N'24 G   Canulla   5 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (690, N'Nutral   Syrup   120 mg', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (691, N'Gentic   Injection   20 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (692, N'Gentic   Injection   40 mg', -39)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (693, N'Amkay   Injection   25 gm', 75)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (694, N'Decadron   Injection   1 ml', -46)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (697, N'Inocef    Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (698, N'Zantec   Injection   2 ml', 645)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (699, N'Transamine   Injection   1000 mg', -97)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (700, N'Tycef   Syrup   30 ml', 27)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (701, N'Tycef  DS   Syrup   30 ml', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (702, N'Master canula   Canulla   24', -61)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (703, N'Cefxone    Injection   1000 mg', -8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (704, N'Suppositores   Sergical   2', -1208)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (705, N'Oxoferin   Drops   50 ml', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (706, N'Rigix   Syrup   120 mg', 6)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (709, N'Amoxil fort   Syrup   250 mg', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (710, N'Ventolin   Drops   20 ml', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (711, N'Dignity sheet   Sergical   90 ML', -536)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (712, N'Mite   Tablet   200 mg', -986)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (713, N'Ceclor   Syrup   125 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (714, N'Ceclor   Syrup   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (716, N'kleen Enema   Sergical   Norml', -12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (717, N'Fortazim   Injection   1000 mg', -48)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (718, N'Wintax   Injection   1000 mg', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (719, N'Nootropil   Injection   1000 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (720, N'Nootropil   Syrup   120 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (721, N'Nootropil   Tablet   800mg', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (722, N'Cipesta   Injection   200 mg', 95)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (723, N'Cipsta   Injection   400 mg', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (724, N'Cipsta   Syrup   125 mg', 45)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (725, N'Cipsta   Syrup   250 mg', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (726, N'Cystone   Syrup   100 ml', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (728, N'T/day   Syrup   90 ML', 107)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (729, N'T/day   Syrup   60 ml', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (730, N'Droncef   Injection   1000 mg', 55)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (733, N'Nimixa   Tablet   550 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (735, N'Fefolvit   Capsul   150 mg', 2576)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (736, N'Avor   Tablet   1mg', 293)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (737, N'Avor   Tablet   2mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (738, N'Testofin/m   Capsul   125 mg', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (739, N'Prexa   Tablet   10 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (740, N'Kempro   Tablet   5mg', 3200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (741, N'Metni   Gel Vaginal   75g Vaginal gel', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (742, N'Rize   Capsul   20 mg', 1273)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (744, N'Olanzia   Tablet   5mg', 740)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (745, N'Inocef    Injection   2mg', -20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (746, N'Deltacortril  Ec   Tablet   5mg', 1000)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (747, N'Lysovit   Syrup   120 ml', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (748, N'GEN/M DS   Syrup   30 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (749, N'GEN/M Pleen   Syrup   30 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (750, N'GEN/M 80/480   Tablet   80.480 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (751, N'ACURON   Injection   3ml', -12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (752, N'Oxidil   Injection   2mg', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (753, N'Oxidil   Injection   1000 mg', 52)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (754, N'Labetalol   Injection   10 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (755, N'Hydralazine   Injection   20 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (756, N'Acireg   Capsul   20 mg', 266)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (757, N'Vicryl Rapid   Sergical   75cm', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (758, N'Ventolin poff   Poff   100mcg', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (759, N'Ruiling   Sachets   40 mg', 210)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (760, N'Mixel   Capsul   400 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (761, N'Freehale   Sachets   4 mg', 458)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (762, N'Jarden/D   Tablet   5mg', 170)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (763, N'Oslia   Soft Gel Vit D3   200000 iu', 35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (764, N'Brocifen   Injection   1000 mg', 78)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (765, N'Bromep   Injection   40 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (766, N'Primolut N   Tablet   5 mg', 633)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (767, N'ADMax   Drops   10 ml', 198)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (769, N'Paracet   Injection   100 ml', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (771, N'caricef    Tablet   200 mg', 114)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (772, N'Monteika   Sachets   4mg', 257)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (773, N'Trimetabol   Syrup   120 ml', 74)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (774, N'iNOqUIN   Tablet   500 mg', 1460)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (775, N'DYNAqUIN   Tablet   500 mg', 361)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (777, N'ENDTRON   Injection   8mg', 56)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (778, N'Acireg   Injection   40 mg', 11)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (779, N'Febrol FAST   Tablet   5 mg', 1259)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (780, N'DEXXOO   Capsul   30 mg', 1430)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (781, N'Xylocaine Jelly   2%   15 g', 154)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (782, N'Folic Acid   Tablet   5mg', 3200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (783, N'Magnesium   Injection   10 ml', 46)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (784, N'Bupican   Injection   2ml', 1015)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (785, N'HCq   Tablet   200 mg', 360)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (786, N'Pyodine   Solution   450ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (787, N'Pyodine   Solution   60 ml', -1033)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (788, N'Pyodine   Scrub   60 ml', -8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (790, N'Motilium V   Tablet   10 mg', 1100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (791, N'Chymoral   Tablet   Forte', 580)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (792, N'LACTOGEN 1   Milk   200 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (793, N'Cipton   Tablet   500 mg', 450)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (794, N'Wintogeno   Bam   50gm', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (795, N'Neurobion   Tablet   Vitamin B6', 900)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (796, N'Sangobion   Syrup   120 ml', 103)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (797, N'Polybion Fort   Syrup   120 ml', -389)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (799, N'Era/max   Tablet   Vitamin B6', 170)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (800, N'Maxpan   Capsul   400 mg', 164)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (801, N'FOCIN   Sachets   3 mg', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (802, N'FOCIN   Focin  Sachet   3gm', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (804, N'Fibo   Sachets   3gm', 190)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (805, N'Abdominal belt   Ortho   Large', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (806, N'VOLTRAL   100 larag   SUPPOSITORIES', -41)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (807, N'VOLTRAL   25 Smal   SUPPOSITORIES', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (809, N'Pletaal   Tablet   100 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (810, N'Alphacoline   Injection   250 mg', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (811, N'MB/Forte   Syrup   120 ml', 35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (812, N'CARODEX   Sachets   5gm', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (813, N'Spasler/p   Syrup   60 ml', 19)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (814, N'Pamper   Dyper   Smal', 409)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (815, N'AZOMAX   Syrup   200mg/5ml  ', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (816, N'AZOMAX   Capsul   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (817, N'RBC   Injection   5 ml', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (818, N'Whincid   Syrup   120 ml', 25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (819, N'Hilgas   Syrup   120 ml', 153)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (820, N'Flagyl   Tablet   400 mg', 400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (821, N'Metodine DF   Syrup   90 ML', 81)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (823, N'ACICON   Syrup   60 ml', 92)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (824, N'Cipocaine   Drops   5 ml', 8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (825, N'Utrofin   Syrup   120 ml', 27)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (826, N'Rejuva   Sachets   500 mg', 1358)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (828, N'Lcyn   Tablet   500 mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (829, N'Ruling   Capsul   40 mg', 869)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (830, N'Ruling   Capsul   20 mg', 266)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (831, N'Ruling   Injection   40 mg', 17)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (832, N'Freehale   Tablet   10 mg', 112)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (834, N'Freehale   Tablet   5mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (835, N'Panadol Extra   Tablet   Norml', 1761)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (836, N'Qalsan D3   Tablet   Norml', 900)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (837, N'Vomipreg   Tablet   10 mg', 540)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (838, N'Hepa/Merz   Injection   10 ml', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (840, N'Vermox   Tablet   100 mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (841, N'Venofer    Injection   5 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (842, N'SOlifen   Tablet   5 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (843, N'DAKTARIN   ORAL gel   20 g', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (844, N'MELFAX   Tablet   7.5', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (846, N'NOVAFOL   Tablet   400 mg', 270)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (847, N'CEFSPAN   Syrup   30 ml', 18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (848, N'CEFSPAN  DS   Syrup   30 ml', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (849, N'RINgolat    Injection   1000 mg', 630)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (850, N'OTSUZOL   Injection   100 ml', 425)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (851, N'ARTEM  PULS 30ml   Syrup   15/90 ', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (852, N'Fibo   JArs   175 GM', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (853, N'CRAN/MAX   Sachets   250 mg', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (854, N'LOWPLAT   Tablet   75 MG', 160)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (855, N'LOWPLAT  Plus   Tablet   75 MG', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (856, N'NIse   Tablet   100 mg', 620)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (857, N'Maxna   Capsul   500 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (858, N'CLARITEK   Syrup   125 mg', 17)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (859, N'EFIX   Syrup   100 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (860, N'EFIX DS   Syrup   200mg/5ml  ', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (862, N'BARRESTEN Vaginal    Tablet   500 mg', 18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (863, N'Ospamox   Tablet   1000 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (864, N'DAYPIME   Injection   500 mg', 75)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (865, N'Augmentin   Syrup   457mg/5ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (866, N'Posterisan Fort   Cream   10 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (867, N'MEVULAK   Sachets   135mg+3.5g', 259)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (868, N'CAZID   Tablet   400 mg', 264)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (870, N'CAZID   Tablet   600mg', 156)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (871, N'RIfagut   Tablet   550 mg', 190)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (872, N'REvolt   Tablet   20mg', 3820)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (874, N'Serlin   Tablet   50mg', 1801)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (876, N'REGAB   Capsul   75 MG', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (877, N'Ramipace   Tablet   2.5mg', 112)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (878, N'ZOPENT   Tablet   20mg', 84)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (879, N'Tixilix   Syrup   120 ml', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (880, N'Epival   Syrup   120 ml', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (881, N'NO/spa fort   Tablet   80mg', 1460)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (882, N'Amaryl   Tablet   2mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (883, N'Amaryl   Tablet   1mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (884, N'Amaryl   Tablet   3mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (885, N'NO SPA   Tablet   40 mg', 640)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (886, N'Avil    Tablet   7mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (887, N'Claforan   Injection   500 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (888, N'Claforan   Injection   250 mg', 45)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (889, N'Aventriax   Injection   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (890, N'Flagyl   Syrup   90 ML', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (892, N'EXLANT   Capsul   60 mg', 1036)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (893, N'NT/ tox   Tablet   500 mg', 174)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (894, N'Gvia/m   Tablet   50mg/500mg', 996)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (895, N'Larith   Syrup   125mg/5ml', 63)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (896, N'DOCTILE   Sachets   3gm', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (897, N'RITHMO   Tablet   500 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (898, N'Monteika   Tablet   10 mg', 529)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (899, N'XALEVE   Injection   400mg/4ml', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (900, N'Flagyl   Injection   100 ml', -1395)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (901, N'Dicloran   Injection   75mg', -49)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (902, N'Tryptanol   Tablet   25mg', 2093)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (903, N'Aldomet   Tablet   250 mg', 361)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (904, N'Xaltide   Inhaler   100 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (905, N'Lian   Syrup   120 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (906, N'Ostibon   Sachets   Vitamin D3', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (907, N'Ferosoft   Drops   30 ml', 39)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (908, N'Mhucaine   Capsul   120 ml', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (909, N'Ginkmist   Syrup   240 ML', 31)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (910, N'Fucidin     Cream   15 g', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (911, N'Trispane   Capsul   400 mg', 596)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (912, N'AVSAR PLUS   Tablet   160/10/12.5mg', 420)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (914, N'AVSAR PLUS   Tablet   160/10/25mg', 420)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (915, N'Combinol/E   Syrup   120 ml', 66)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (916, N'SMECTA   Sachets   Norml', 144)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (917, N'Ascard   Tablet   75 MG', 2430)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (918, N'Lets   Tablet   2.5mg', 205)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (919, N'Risek   Sachets   40 mg', 38)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (920, N'Risek   Sachets   20 mg', 119)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (921, N'Tamsolin plus   Capsul   0.4 mg', 220)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (922, N'NEBCIN   Injection   80mg', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (923, N'Praz   Tablet   0.5 mg', 891)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (924, N'GLUCOPHAGE   Tablet   500 mg', 850)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (925, N'Teril   Tablet   200 mg', 1400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (928, N'Famobex   Syrup   120 ml', 36)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (929, N'Ganaton   Tablet   50mg', 240)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (930, N'Ganaton OD   Tablet   150 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (931, N'Protium   Tablet   40 mg', 84)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (932, N'Faverin   Tablet   50mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (933, N'SERC   Tablet   8 MG', 88)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (934, N'SERC   Tablet   16 mg', 90)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (936, N'Dormicum   Injection   5mg', 115)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (937, N'Unicid   Syrup   240 ML', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (938, N'Masacol   Tablet   400 mg', 609)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (941, N'Risek   Capsul   20 mg', 1117)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (942, N'OLCUF   Syrup   120 ml', 25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (943, N'Augmentin Pleen 156.25 MG   Syrup   90 ML', 39)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (944, N'Ibandro   Tablet   150 mg', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (945, N'AVSAR    Tablet   80/5', 252)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (946, N'AVSAR    Tablet   160/5', 56)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (947, N'Byvas   Tablet   10 mg', 154)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (948, N'Opt/D   Tablet   200000 iu', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (949, N'Byvas   Tablet   5mg', 602)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (950, N'AVSAR    Tablet   160/10mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (951, N'Byvas   Tablet   2.5mg', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (952, N'INDERAL   Tablet   40 mg', 2300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (953, N'TENORMIN   Tablet   50mg', 70)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (956, N'RBC   Syrup   120 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (957, N'THyroxin   Tablet   Norml', 700)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (958, N'Polyfax Skain Ointment   Cream   20 mg', -30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (959, N'Betnovate/N  Ointment   Cream   20 g', 11)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (960, N'Betnovate /N    Cream   20 g', 8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (961, N'Dermovte Ointment   Cream   20 g', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (962, N'Myrin   Tablet   300 mg', 160)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (963, N'Myrin/P Forte   Tablet   400 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (964, N'RhoGAm   Injection   300 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (965, N'Seizunil    Tablet   200 mg', 650)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (966, N'Domel   Syrup   60 ml', 32)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (967, N'Votadol   Capsul   50mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (968, N'IROMOSE/F   Syrup   120 ml', 36)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (969, N'Lasix   Injection   2ml', -35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (970, N'Avil    Injection   2ml', -31)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (971, N'Dexa   Injection   1ml', -137)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (972, N'DEXXOO   Capsul   60 mg', 235)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (973, N'Mirazym Ds   Tablet   10 mg', 240)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (974, N'TONOFLEX/p Forte   Tablet   75 MG', 130)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (975, N'SKILAX   Drops   15ml', 22)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (976, N'POSTERISAN   Cream   10g', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (977, N'FERFIX/FA   Tablet   100 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (978, N'ESKEM    Capsul   40 mg', 126)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (979, N'ROXVITA   Tablet   Multivitamin', 240)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (980, N'Suction tube   Tube   Smal', -11)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (981, N'Cytotrexate   Tablet   2.5mg', 210)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (982, N'PELTON/V   Syrup   120 ml', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (983, N'Sangobion   Capsul   Norml', 1590)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (984, N' RAPIDASE   Tablet   20 mg', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (985, N'BeCeFol   Tablet   Multivitamin', 500)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (986, N'Starcef   Injection   1000 mg', -8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (987, N'2 Sum   Injection   1000 mg', -108)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (988, N'Citralka   Syrup   120 ml', 18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (989, N'Naprosyn   Tablet   500 mg', 1454)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (990, N'NO/spa    Injection   2ml', 175)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (991, N'Serenace   Tablet   5mg', 4580)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (992, N'Tramal   Capsul   50mg', 18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (993, N'OMC/D   Tablet   830mg', 510)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (994, N'RBC/F   Tablet   100mg/0.35mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (995, N'AD FOLIC   Tablet   600 mcg', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (996, N'FerFer   Sachets   80mg', 330)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (997, N'Femiroz   Tablet   Norml', 220)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (998, N'EFecip   Syrup   60 ml', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (999, N'D/2000   Tablet   Vitamin D3', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1000, N'X/ FIX   Syrup   30 ml', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1001, N'Vetamin k   Injection   10 mg', -16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1002, N'Nausidox   Tablet   10 mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1003, N'PANTRA PLUS   Tablet   325 mg', 110)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1004, N'Starcox   Tablet   60 mg', 410)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1005, N'Celbex   Capsul   200 mg', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1006, N'Xorbact   Injection   2G', -37)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1007, N'Prenate   Tablet   Vitamin B6', 330)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1008, N'Angised   Tablet   0.5 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1009, N'EseGrow   Tablet   Vitamin B6', 226)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1010, N'Praz   Tablet   0.25', 179)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1011, N'Oxidil   Injection   250 mg', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1012, N'Maxfol   Tablet   400 mg', 420)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1013, N'Viophos/B   Syrup   240 ML', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1014, N'EseGrow   Syrup   60 ml', 131)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1015, N'Dermazine   Cream   50gm', 11)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1016, N'Rimactal   Syrup   2%', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1017, N'ZAtofen   Syrup   60 ml', 29)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1018, N'Evopride   Tablet   2/500mg', 930)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1019, N'Galvecta Plus   Tablet   50/850mg', 42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1020, N'Oridone   Tablet   2mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1021, N'KLARICID   Tablet   250 mg', 160)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1022, N'KLARICID   Syrup   60 ml', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1024, N'GLucovance   Tablet   500mg/5mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1025, N'GLUCOPHAGE   Tablet   250 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1026, N'Cefzimed   Injection   1 gm', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1027, N'Hylixia   Syrup   120 ml', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1028, N'Haemaccel   Injection   500 ml', -56)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1029, N'Ruling   Sachets   40 mg', 110)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1031, N'ESTAR   Tablet   5mg', 566)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1032, N'Berica   Tablet   60 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1033, N'Thiolax   Capsul   4mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1034, N'Brotin   Tablet   2.5mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1036, N'N/SLINE   Injection   1000 mg', 1601)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1037, N'R/LACTAte   Injection   1000 mg', 400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1038, N'R/LACTAte/D   Injection   1000 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1039, N'Water   Injection   10%', 66)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1040, N'FOLEYs       CATHETER   Sergical   16 NUMBR', -198)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1041, N'Glycern   Suppositories   2%', 899)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1042, N'25% D/W Ample   Injection   10 ml', -36)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1043, N'KCL   Injection   10 ml', -18)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1044, N'Ca/Sandos   Injection   10 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1045, N'D/Gloves   Sergical   D', -45)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1046, N'VOLTRAL EMULGEL   Gel   2%', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1047, N'Froben   Gel   50gm', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1048, N'Feroben   Gel   50gm', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1049, N'FASTAID   Gel   20 g', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1050, N'LERACE   Injection   500 mg', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1052, N'Ansel Gloves   Sergical   7.5', -383)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1053, N'Manitol   Injection   500 ml', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1054, N'5% D/Water    Injection   1000 ml', -28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1055, N'Dythermy lead   Sergical   00', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1056, N'Prolen 4/0   Sergical   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1057, N'Artem Ds Plus   Tablet   80/480', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1058, N'Viglip/m   Tablet   50mg/500mg', 98)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1059, N'DIAMICRON .MR   Tablet   60 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1060, N'Myonal   Tablet   50mg', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1061, N'Methycobal   Tablet   500 mg', 1172)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1062, N'Ferosoft   Syrup   120 ml', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1063, N'Nilstat Oral Drop   Drops   30 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1065, N'Fortum   Injection   500 mg', -2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1066, N'Chromic   Sergical   2/0', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1067, N'Chromic   Sergical   0/ 40mm', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1068, N'Hifen   Tablet   400 mg', -55)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1069, N'O.T KIT   Sergical   500 ml', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1070, N'Liometacin   Injection   2 ml', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1071, N'Brixin    Tablet   20 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1072, N'Ascof   Syrup   120 ml', 88)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1073, N'Fotiflox   Tablet   400 mg', 260)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1074, N'Cefcom   Injection   250 mg', -6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1075, N'Zegrid   Injection   40 mg', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1076, N'G/Cal Soft Gel Large   Capsul   Vitamin D3', 133)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1077, N'ONITA   Sachets   2G', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1078, N'BTno   Tablet   10 mg', 220)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1079, N'ROSCA   Tablet   10 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1080, N'ERASER   Drops   30 ml', 170)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1081, N'Finlac 1   Milk   200g', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1082, N'BENZIRIN RINS   ORAL   240 ML', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1083, N'VITA/6   Tablet   50mg', 96)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1084, N'Renitec   Tablet   5mg', 380)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1085, N'Zetro    Syrup   200 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1086, N'Ceclor   Drops   50mg', 35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1087, N'Nuberol Fort   Tablet   Norml', 117)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1088, N'Nesfspan   Syrup   100 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1089, N'Nesfspan DS   Syrup   200 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1090, N'Nefspan   Syrup   30 ml', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1091, N'Nefspan DS   Syrup   200 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1092, N'Essen/D3   Tablet   100000', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1093, N'GASTRON   Syrup   120 ml', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1094, N'Fertisure   Capsul   Norml', 380)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1095, N'Onato   Tablet   10 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1096, N'Onato   Tablet   5mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1097, N'D/syring   D/Syring   10 ml', 1159)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1098, N'HYDROGEN   Sergical   Norml', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1099, N'safra/Tulle   Sergical   10', 99)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1100, N'CLeniL FOR AerosoL   Nebulisation   2ml', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1101, N'CEFOTAX   Injection   250 mg', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1102, N'Silk   Sergical   00', 1042)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1103, N'PAPAR Tap   Sergical   1 iNch', 239)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1104, N'viryl   Sergical   2/0', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1106, N'PROLINE    Sergical   2/0', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1107, N'Chromic 0   Sergical   75cm', -42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1108, N'DayFort    Injection   1000 mg', -12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1109, N'PROLINE 0   Sergical   75cm', -54)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1110, N'vicryl puls  70cm    Sergical   00', -491)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1111, N'Vicryl Rapid   Injection   3/0', -7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1112, N'Redon Drain   Sergical   14', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1114, N'VITAMIN/K   Injection   5 ml', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1115, N'Chromic   Sergical   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1116, N'Plaste Plaster   Sergical   1 iNch', 65)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1117, N'N/SLINE   Injection   100 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1118, N'N/SLINE /9%   Injection   500 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1119, N'Uring Bag   Sergical   500 ml', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1120, N'Dipset   Sergical   O"', 720)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1121, N'SODABICARBONATE   Injection   50 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1122, N'Redon Drain   Sergical   400ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1123, N'Co/Eziday   Tablet   50mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1124, N'Mucaine   Syrup   120 ml', 25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1125, N'Cravit   Tablet   500 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1126, N'Fuciden   Tablet   250 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1127, N'MAXFLOW   Capsul   0.4 mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1128, N'NOCLOT   Tablet   75 MG', 260)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1129, N'NOCLOT/EA   Tablet   75 MG', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1130, N'Sibelium   Capsul   5 mg', 73)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1131, N'Stugeron FORT   Capsul   75 MG', 36)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1132, N'VELOSEF   Syrup   250 mg', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1133, N'VELOSEF   Syrup   125 mg', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1134, N'Serenace Ampoule   Injection   5mg', 25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1135, N'Spot Free   Spot Free   7', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1136, N'SPasmogon   Drops   30 ml', 79)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1137, N'Catafen   Tablet   100 mg', 540)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1138, N'Catafen   Tablet   50mg', 530)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1140, N'HiDRASEC   Capsul   100 mg', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1141, N'Iberet    Tablet   500 mg', 570)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1142, N'Streptomycin   Injection   1 g', -24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1143, N'vicryl   Sergical   2/0', -87)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1144, N'Rize   Syrup   60 ml', 46)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1145, N'Canesten Creem   Cream   1%', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1146, N'Tegral   Tablet   200', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1147, N'Ceporex    Syrup   125 mg', 2)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1148, N'Ceporex    Syrup   250 mg', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1149, N'Calamox   Tablet   1000 mg', 212)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1150, N'movex   Tablet   2mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1151, N'RITHMO   Drops   5 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1152, N'KAsob   Tablet   Vitamin D3', 74)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1154, N'D4u   Tablet   200000 iu', 21)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1155, N'Larith   Tablet   500 mg', 170)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1156, N'Daytaxime   Injection   1000 mg', 26)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1157, N'Mecroz   ORAL gel   2%', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1158, N'Artem Ds Plus   Syrup   30/180', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1159, N'ZeeGAP   Capsul   75 MG', 56)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1160, N'Azitma   Syrup   30 ml', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1161, N'NEXUM   Capsul   20 mg', 146)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1162, N'INDERAL   Tablet   10 mg', 1600)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1163, N'AlcuFlax   Tablet   550 mg', 818)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1164, N'inig D   Syrup   60 ml', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1165, N'Gvia/m   Tablet   50mg/850mg', 210)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1166, N'RELOCURIM   Injection   5ml', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1167, N'Brexon   Tablet   20 mg', 920)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1168, N'DILAIR   Tablet   10 mg', 550)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1169, N'DAZEN DS   Tablet   10 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1170, N'DAZEN    Tablet   5mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1171, N'Nese   Tablet   100 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1172, N'HAEMIC   Capsul   500 mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1173, N'ESTAR   Tablet   10 mg', 154)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1174, N'FOLEY  CATHETER SILiCON  2/WAy 16   Sergical   20 ml', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1175, N'LUMBO SACRAL  M   Sergical   Norml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1176, N'TRAMPOL   Tablet   Norml', 470)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1177, N'Tazbac   Injection   4.5', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1178, N'Tazbac   Injection   2.25G', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1179, N'Chromic  1   Sergical   75cm', -53)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1180, N'Chrom 2/0   Sergical   75cm', -119)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1181, N'Chromic 3/0   Sergical   75cm', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1182, N'Lacura   Injection   1000 mg', -9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1183, N'ACURON   Injection   3 ML', -113)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1184, N'MOTIYAL   Tablet   0.5 mg', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1185, N'CLARITEK   Tablet   500 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1186, N'Oxoferin   Solution   50 ml', 17)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1187, N'SCABION   Lotion   60 ml', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1188, N'CONAZ   Lotion   60 ml', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1189, N'OSMOLAR  ORS  (BANANA)          Sachets   Norml', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1190, N'Dextop   Capsul   30 mg', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1191, N'Evopride   Tablet   1/500', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1192, N'Xilica   Tablet   50mg', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1193, N'Phylin   Syrup   100mg/5ml', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1194, N'Neurobion   Injection   3ml', 48)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1195, N'Multibionta   M   Capsul   Multivitamin', 160)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1196, N'EVION    Capsul   400 mg', 700)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1197, N'MUSCORIL   Capsul   4mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1198, N'Fortazim   Injection   250 mg', 48)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1199, N'Tapento   Tablet   75 MG', 810)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1200, N'voltral SR   Tablet   100 mg', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1201, N'COMFY   Syrup   120 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1202, N'Urilef   Tablet   100 mg', 180)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1203, N'myteka    Tablet   10 mg', 70)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1204, N'LERACE   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1205, N'LERACE   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1206, N'Sciprid     Tablet   25mg', 151)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1207, N'Sciprid     Tablet   50mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1208, N'LOCHOL   Tablet   10 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1209, N'Cipness   Tablet   500 mg', 324)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1210, N'Pyodine  Gei   Gel   20 mg', 98)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1211, N'Nefotax   Injection   1000 mg', -25)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1212, N'Topento   Tablet   75mg', 63)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1213, N'ENZICLOR M/W   Mouthwash   200 ML', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1214, N'Apton   Syrup   120 ml', 99)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1215, N'Nefspan   Capsul   400 mg', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1216, N'Ome/EC   Injection   40 mg', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1217, N'Digestine   Capsul   40 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1218, N'Hitazid   Injection   1000 mg', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1219, N'Zinacef   Tablet   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1220, N'Zinacef   Tablet   125 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1223, N'Crepe   Sergical   6 INCH', 35)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1224, N'Crepe   Sergical   4 INCH', 36)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1225, N'Omixim   Capsul   400 mg', 352)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1226, N'Lovanzo   Capsul   40 mg', 238)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1227, N'Vitrum   Tablet   Multivitamin', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1228, N'Gasil   Injection   25mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1229, N'Grasil   Injection   25mg', 96)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1230, N'Grasil   Injection   50mg', 38)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1231, N'X/Plended   Tablet   20 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1232, N'Calamox   Syrup   90 ML', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1233, N'Cefrinex   Injection   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1234, N'ETONe   Tablet   500 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1235, N'Lagita   Syrup   120 ml', 13)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1237, N'Amprexa /F 6mg   Capsul   25mg', 849)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1238, N'P Easy   Capsul   0.4 mg', -30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1239, N'Urimac   Syrup   120 ml', 8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1240, N'jarden   Tablet   10 mg', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1241, N'LEFORA   Tablet   20 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1242, N'GLUCOPHAGE   Tablet   1000 mg', 489)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1243, N'CINOXIN   Capsul   500 mg', 400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1244, N'HiDRASEC   Sachets   30 mg', 64)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1245, N'HiDRASEC   Sachets   10 mg', 96)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1246, N'Bexpro   Tablet   500 mg', -10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1247, N'FLAZOL   Injection   100 mg', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1248, N'Ome/EC   Capsul   20 mg', 140)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1249, N'PLADEX 10/%   Injection   1000 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1250, N'RINgolat  D   Injection   1000 mg', 115)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1251, N'FOLEY  CATHETER   Sergical   24 3WAY', -1)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1252, N'Epival   Tablet   250 mg', 1700)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1253, N'Epival   Tablet   500 mg', 400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1254, N'Synflex   Tablet   550 mg', 660)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1255, N'Frisium   Tablet   10 mg', 1100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1256, N'STEMETAL new   Tablet   Norml', 2400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1257, N'MORTAM   Injection   1 g', -16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1258, N'Paedi Care   ORAL   500 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1259, N'Allerwood    Syrup   30 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1260, N'Corvin dry powder   ORAL   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1261, N'Corvin dry powder   ORAL   125 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1262, N'ONSET   Tablet   8 MG', 90)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1263, N'ONSET   Injection   8 MG', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1264, N'Azitma   Suppositories   15ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1265, N'Azitma   Tablet   500 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1266, N'iNTIG D   Syrup   250 mg', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1267, N'Oxidil   Injection   500 mg', 32)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1268, N'DANZEN  DS   Tablet   10 mg', 324)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1269, N'DANZEN    Tablet   5mg', 190)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1270, N'DANZEN  Fort   Tablet   20mg', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1271, N'Co/Renitec   Tablet   10/25', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1272, N'Renitec   Tablet   10 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1273, N'FORTEXONE   Injection   1 g', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1274, N'Azitron   Tablet   500 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1275, N'Netoplex   Syrup   120 ml', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1276, N'VELOSEF   Capsul   500 mg', 108)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1277, N'ZERFIN   Injection   10 mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1278, N'LAME   Tablet   10 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1279, N'LAME   Tablet   5 mg', 164)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1280, N'Clomfranil   Tablet   25mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1281, N'Clomfranil   Tablet   10 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1282, N'Ranax   Injection   50mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1283, N'Otsumol   Injection   100 ml', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1284, N'AMAK   Injection   500 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1285, N'SINAXAMOL    Tablet   650mg/50mg', 137)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1286, N'Diccloran Disperlet   Tablet   Norml', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1287, N'MAXIT   Tablet   75 MG', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1288, N'Day Line   Injection   250 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1289, N'Anafortan   Injection   4ml', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1290, N'ENTOX P   Tablet   630mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1292, N'vicryl puls     Sergical   90cm', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1293, N'depgo   Tablet   10 mg', 126)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1294, N'Cedrox   Tablet   1 g', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1295, N'Preglan E2   Tablet   Norml', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1297, N'Ossobon D   Syrup   120 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1298, N'Edwin   Capsul   vitamin D3 200,000', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1299, N'ABOCAL   Tablet   Vitamin D3', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1300, N'Faverin   Tablet   100 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1301, N'Flagyl tab   Tablet   400 mg', 1000)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1302, N'NO-spa    Injection   40 mg', 475)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1303, N'ECASIL   Tablet   600mg', 84)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1304, N'Nixaf   Tablet   550 mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1305, N'CONCOR   Tablet   10 mg', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1306, N'CONCOR   Tablet   2.5mg', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1307, N'Voren   Tablet   50mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1308, N'ENTAMIZOL DS   Tablet   500m/400mg', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1309, N'Surbex Z   Tablet   Vitamin E,C', 600)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1310, N'MIXEL   Syrup   100mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1311, N'MIXEL DS   Syrup   30 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1312, N'VOLTRAL   Suppositories   100 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1313, N'Votrral    Suppositories   100 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1314, N'Deltacortril   Tablet   5 mg', 3000)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1315, N'VELOSEF   Capsul   250 mg', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1316, N'PROLINE  Mesh   Sergical   6/11 Cm', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1317, N'KAlsob   Tablet   Vitamin D3', 270)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1318, N'D/syring   Sergical   1 ml', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1320, N'Betnela   Tablet   0.5 mg', 500)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1321, N'Tri HEMIC   Tablet   600mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1322, N'CARVVEDA    Tablet   6.25', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1323, N'FRECID   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1324, N'Menidazole   Syrup   200mg/5ml  ', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1325, N'X/ Plended   Tablet   10 mg', 150)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1326, N'X/ Plended   Tablet   5 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1327, N'BRUFEN   Tablet   400 mg', 500)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1328, N'NO spa fort   Tablet   80mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1329, N'Rigix   Tablet   10 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1331, N'EZIDAY   Tablet   50mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1332, N'ZURIG   Tablet   80mg', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1333, N'Neo /mercazol   Tablet   5mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1334, N'Jontilet   Sachets   250 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1335, N'SCIMOX   Tablet   400 mg', 70)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1336, N'Serenace   Tablet   10 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1337, N'Loxe   Capsul   20 mg', 210)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1338, N'Loxe   Capsul   30 mg', 111)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1339, N'Fucidin  H   Cream   15 g', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1340, N'Amoxil   Capsul   250 mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1341, N'Amoxil   Capsul   500 mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1342, N'ATARAX   Tablet   10 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1343, N'Exval-A   Tablet   10mg/160mg', 210)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1344, N'Exval-A   Tablet   5mg/160mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1345, N'Exval-A   Tablet   5mg/80mg', 70)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1346, N'VOLTRAL EMULGEL %1   Gel   20 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1347, N'Spasfon   Injection   4ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1348, N'Neucef   Drops   100 mg', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1349, N'Spedicam   Tablet   8 MG', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1350, N'EVION    Capsul   600mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1351, N'BETNESOL   Tablet   0.5 mg', 520)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1352, N'REVITALE MULTI   Tablet   Multivitamin', 45)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1353, N'Claforan   Injection   0.5 mg', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1354, N'Lasix   Tablet   20 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1355, N'NORSALINE   SPARY   0.9%', 6)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1356, N'DOLOR   Syrup   60 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1357, N'DOLOR DS   Syrup   60 ml', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1358, N'Essen-D   Tablet   Vitamin D3', 44)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1359, N'MYCITRACIN   Cream   40.17GM', 8)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1360, N'ZURIG   Tablet   40 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1361, N'SINAXAMOL  extra   Tablet   250 mg', 56)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1362, N'Safepime   Injection   1000 mg', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1363, N'HUMULIN-R   Injection   10ML-100 IU', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1364, N'PROLINE    Sergical   1'' 40mm', -19)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1365, N'ROTEC   Tablet   DICLOFENAC SODIUM', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1366, N'VAGILACT   Tablet   1%', 108)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1367, N'ARCEVA    Syrup   30 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1368, N'ARCEVA DS   Syrup   30 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1369, N'gravinate   Tablet   50mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1370, N'gravinate   Injection   50 ml', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1371, N'Aldactone   Injection   100 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1372, N'X- FIX ds   Syrup   30 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1373, N'Parapals-T   Tablet   375 mg', 600)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1374, N'Inxime   Capsul   400 mg', 294)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1375, N'Anafortan plus   Tablet   22', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1376, N'CYROCIN   Tablet   500 mg', 160)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1377, N'Polybion Z   Capsul   Multivitamin', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1378, N'CEFON 1GM   Injection   1 g', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1379, N'DURAGESIC   Tablet   450ml', 1000)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1380, N'SOFTEN   Tablet   10 mg', 130)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1381, N'magix   Tablet   7.5', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1382, N'magix   Tablet   15 g', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1383, N'NEUROTOP   Syrup   vitamins and minarls', 15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1384, N'Natalvit   Tablet   healthy mother smart baby', 40)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1385, N'TRODOL   Injection   00', -15)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1386, N'Rocephin   Injection   500 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1387, N'orelox   Tablet   100 mg', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1388, N'Rocephin iv   Injection   500 mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1389, N'HIRAMOX   Tablet   400 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1390, N'AMCLAV DS 312.5MG/5ML   Syrup   60 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1391, N'AMCLAV 1556.25MG/5ML.   Syrup   60 ml', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1392, N'PRULAX   Syrup   120 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1393, N'Linzim   Capsul   400 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1394, N'ZeeGAP   Capsul   50mg', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1395, N'Epti syrup   Syrup   120 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1396, N'Moksi   Tablet   400 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1397, N'CLARITEK   Syrup   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1398, N'CLARITEK   Tablet   250 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1399, N'kestine   Tablet   20 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1400, N'Disprin   Tablet   Norml', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1401, N'Magura   Tablet   0.5 mg', 1900)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1402, N'ENO    Sachets   5mg', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1403, N'Slate    Drops   DROPS', 21)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1404, N'RITHMO   Syrup   125mg/5ml', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1405, N'KLARICID   Injection   500 mg', 4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1406, N'Urin Beg JMS   Sergical   120 ml', -5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1407, N'Seizunil  100mg/5ml   Syrup   120 ml', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1408, N'OLSUNA    Sachets   Norml', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1409, N'Normens   Tablet   Norml', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1410, N'Gixer oral   Syrup   Norml', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1411, N'ASTHIVEN    Tablet   10 mg', 196)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1412, N'ALP   Tablet   0.5 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1413, N'OSNATE D   Syrup   120 ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1414, N'Cefrinex   Injection   1000 mg', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1415, N'DYCLO   Injection   75mg', 100)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1416, N'MAXFLOW -D   Capsul   Norml', 80)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1417, N'Ensure vanilla 400g PWD    Milk   400 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1418, N'LECZUX   Sachets   Vitamin D3', 19)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1419, N'TENORMIN   Tablet   25 gm', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1420, N'ELASTOCREMEM BNDG   Sergical   4 INCH', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1421, N'ELASTOCREMEM BNDG   Sergical   6 INCH', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1422, N'INFEXIN   Injection   1 g', 16)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1423, N'LODOPIN   Tablet   5mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1424, N'PROLINE  Mesh   Sergical   15/15 CM', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1425, N'BARIZOLD   Tablet   400 mg', 36)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1426, N'Calamox DUO   Syrup   35ML', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1427, N'PHYTUS   Syrup   120 ml', 9)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1428, N'OLVER   Injection   500 mg', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1429, N'DEXIVA   Capsul   30 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1430, N'DEXIVA   Capsul   60 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1431, N'Tycef   Tablet   400 mg', 50)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1432, N'REMETHAN   Tablet   100 mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1433, N'LYTA   Capsul   40 mg', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1434, N'DUPHSAC    Syrup   120 ml', 12)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1435, N'DAPAKAN   Tablet   250 mg', 400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1436, N'DAPAKAN   Tablet   500 mg', 300)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1437, N'TRIJECT    Injection   1 g', 17)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1438, N'DOSIK    Tablet   5mg', 400)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1439, N'Nuberol -P   Injection   1 g', 20)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1440, N'Loxe   Capsul   60 mg', 42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1441, N'Rejuva   Tablet   Multivitamin', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1442, N'FEXET D   Tablet   60 mg', 240)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1443, N'STEROL D 40IU   Drops   20 ml', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1444, N'cicatrin   Powder   20mg', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1445, N'LOTRIX   Cream   30 mg', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1446, N'IMODIUM   Capsul   2mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1447, N'ENFLOR    Sachets   Multivitamin', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1448, N'DAONAL   Tablet   5mg', 120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1449, N'HUMULIN 70/30 MIX-INJ   Injection   10ML-100 IU', 1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1450, N'Blucef   Injection   500 mg', -1)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1451, N'Blucef   Injection   250 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1452, N'Augmentin   Drops   20 ml', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1453, N'CAZID   Syrup   60 ml', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1454, N'BARIZOLD   Syrup   100mg/5ml', 3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1455, N'ATIZOR   Tablet   500 mg', 30)
GO
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1456, N'KLARICID   Tablet   500 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1457, N'perant   Tablet   40 mg', 1120)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1458, N'calpol   Tablet   200 mg', 200)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1459, N'LALAP   Tablet   50mg', 42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1460, N'Cipesta XR   Tablet   500 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1462, N'Viglip-m   Tablet   50mg/850mg', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1463, N'BETAGENIC   Cream   15 g', 2)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1464, N'ORSLIN   Capsul   120 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1465, N'GUTSET   Tablet   50mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1466, N'ALDALYSINE    Syrup   120 ml', 24)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1467, N'BYSCARD   Tablet   5mg', 28)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1468, N'Nervon   Tablet   500 mg', 60)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1469, N'Xorbact   Injection   1 g', -3)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1470, N'Gixer    Tablet   10 mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1471, N'myteka    Sachets   4mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1472, N'DEPO-MEDEROL   Injection   80mg', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1473, N'ELFERB   Syrup   120 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1474, N'IZATO   Syrup   120 ml', 6)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1475, N'CIDPRO   Injection   40 mg', 5)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1476, N'Froben   Tablet   50mg', 30)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1477, N'ASTHIVEN    Sachets   4mg', 42)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1478, N'AMPLUS   Injection   500 mg', 10)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1479, N'GABICA   Tablet   75 MG', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1480, N'GABICA   Tablet   50mg', 14)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1481, N'Tamsolin   Tablet   0.4 mg', 0)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1482, N'E/TON   Tablet   500 mg', 600)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1483, N'NIFIM   Tablet   400 mg', 250)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1484, N'LACTEUS   Milk   Multivitamin', 7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1485, N'ECOCEF   Injection   1 g', -7)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1486, N'ADRENALINE   Injection   1ml', -4)
INSERT [dbo].[CurrentStopTable] ([ProductID], [ProductName], [StockQuantity]) VALUES (1487, N'NAZAL TUB   OT   00', 0)
SET IDENTITY_INSERT [dbo].[DailyOPD] ON 

INSERT [dbo].[DailyOPD] ([OPDID], [OPDNumber], [DoctorID], [PatientName], [ContactNo], [Age], [Sex], [City], [OPDDate], [Discount], [Status]) VALUES (1, N'001', 54, N'Waqar Ahmed', N'03013818199', 30, N'Male', N'karachi', CAST(N'2020-09-14 19:32:18.690' AS DateTime), CAST(0 AS Decimal(18, 0)), N'Checked')
INSERT [dbo].[DailyOPD] ([OPDID], [OPDNumber], [DoctorID], [PatientName], [ContactNo], [Age], [Sex], [City], [OPDDate], [Discount], [Status]) VALUES (2, N'001', 55, N'Test', NULL, 20, N'Male', N'Karachi', CAST(N'2022-01-01 00:47:39.253' AS DateTime), CAST(0 AS Decimal(18, 0)), N'Checked')
SET IDENTITY_INSERT [dbo].[DailyOPD] OFF
SET IDENTITY_INSERT [dbo].[Departments] ON 

INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (1, N'Management')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (2, N'Peads')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (3, N'Cardiology')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (4, N'Neuro')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (5, N'General Physician')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (6, N'Chief Surgeon')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (7, N'Consultant Physician')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (8, N'Orthopaedic')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (9, N'Gyne')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (10, N'physio theropy')
INSERT [dbo].[Departments] ([DeptID], [DeptName]) VALUES (11, N'Staff')
SET IDENTITY_INSERT [dbo].[Departments] OFF
SET IDENTITY_INSERT [dbo].[DiagnosticTest] ON 

INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (1, N'X-Ray Chest PA View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (2, N'Blood HB', CAST(50 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (3, N'BSR', CAST(50 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (4, N'Skull AP lettral View', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (5, N'KUB Full Film', CAST(500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (6, N'Chest Full Film', CAST(500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (7, N'KUB', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (8, N'CS APT', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (9, N'Left Shoulder Joint APT', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (10, N'TS APLET', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (11, N'LS Lumber APLET', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (12, N'Pelvis', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (13, N'Left Hip Joint APlet', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (14, N'Femur APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (15, N'Knee Joint APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (16, N'Left Tibia and Fibula', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (17, N'Ankle Joint APlet ', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (19, N'Left Famur APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (20, N'Right Famur APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (21, N'Right Shoulder APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (22, N'Right Tibia and Fibula', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (23, N'Right Hip Joint APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (24, N'Mandible APlet', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (25, N'Nose Both Let view', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (26, N'Left Humerus APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (27, N'Right Humerus APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (28, N'Left Elbow Joint APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (29, N'Right Elbow Joint APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (30, N'Left Radius and Ulna', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (31, N'Right Radius and Ulna', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (32, N'Right Wrist Joint APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (33, N'Left Wrist Joint APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (34, N'Right Hand APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (35, N'Left Hand APlet', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (36, N'Both Mastoid Let', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (37, N'IVP / IVU', CAST(3500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (38, N'Right Clavicle AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (39, N'Left Clavicle AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (40, N'X-Ray PNS Open Mouth View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (41, N'X-Ray Chest AP View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (42, N'R - Bit  APlet', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (43, N'Hepatitis  BC', CAST(400 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (44, N'Hepatitis  B', CAST(150 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (45, N'Hepatitis  C', CAST(200 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (47, N'Cross Match Blood', CAST(100 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (48, N'Malaria MP', CAST(50 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (49, N'Vidal', CAST(150 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (50, N'Malaria ICT', CAST(250 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (51, N'Typhidot', CAST(250 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (52, N'RASHID TAGAR', CAST(50 AS Decimal(18, 0)), N'Lab', N'B.S.R')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (53, N'Ultra Sound', CAST(400 AS Decimal(18, 0)), N'Ultra Sound', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (54, N'HB HC HBV BSR X', CAST(500 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (55, N'X', CAST(50 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (56, N'MP Vidal', CAST(200 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (57, N'T / F', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (58, N'Right Shoulder Joint Apt', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (59, N'Mp Hbc Bsr', CAST(400 AS Decimal(18, 0)), N'Lab', N'Mp Hbc Bsr')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (60, N'Hbc Bsr', CAST(400 AS Decimal(18, 0)), N'Lab', N'HBc Bsr')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (61, N'Hb Bsr Hbc', CAST(400 AS Decimal(18, 0)), N'Lab', N'Hb Bsr Hbc')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (62, N'ARM', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Arm')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (63, N'R/Clavical AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'R/Clavical AP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (64, N'Hbc Cross mach', CAST(400 AS Decimal(18, 0)), N'Lab', N'Hbc Cross Mach')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (65, N'X Bsr Hbc', CAST(400 AS Decimal(18, 0)), N'Lab', N'X Bsr Hbc')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (67, N'kub.CxR', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Kub. CxR')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (68, N'Hb.X', CAST(100 AS Decimal(18, 0)), N'Lab', N'Hb. X')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (69, N'Hcv Hbv Mp', CAST(350 AS Decimal(18, 0)), N'Lab', N'HCV HBV MP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (70, N'X grop', CAST(50 AS Decimal(18, 0)), N'Lab', N'X')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (71, N'Abdom Ecrt Spin', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Abdom Ecrt spin')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (72, N'HBC. MP', CAST(350 AS Decimal(18, 0)), N'Lab', N'HBC. MP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (73, N'Shuldar Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Shuldar Ap')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (74, N'XXXX', CAST(200 AS Decimal(18, 0)), N'Lab', N'XXXX')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (75, N'X.Ahdom', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'X. Ahdom')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (76, N'Cxr Apvlt', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Cxr vApvT')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (77, N'Femar AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'FemarAP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (78, N'B T C', CAST(50 AS Decimal(18, 0)), N'Lab', N'B T C')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (79, N'CXR P/A  Erect Spine', CAST(1200 AS Decimal(18, 0)), N'X-Ray', N'CXR P/A Erect Spine')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (80, N'Hand Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Hand Ap')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (81, N'Clivcal AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clivical AP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (82, N'ELBO AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'ELBO AP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (83, N'Mp RBS', CAST(100 AS Decimal(18, 0)), N'Lab', N'MP RBS')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (84, N'BSR XGrop', CAST(100 AS Decimal(18, 0)), N'Lab', N'BSR X')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (85, N'Lambo Secral AP', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Lambo Secral AP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (86, N'Sacrum Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Sacrum AP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (87, N'Full Pelvis', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Full Pelvis')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (88, N'Lumbo Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Lumbo Ap')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (89, N'X X', CAST(100 AS Decimal(18, 0)), N'Lab', N'X X')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (90, N'HCV HBV CM X Group', CAST(500 AS Decimal(18, 0)), N'Lab', N'HCV HBV CM XGROUP')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (91, N'Both Legs', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Both Legs')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (92, N'Hcv HBv X Grop', CAST(350 AS Decimal(18, 0)), N'Lab', N'Hcv Hbv XGrop')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (93, N'Hb%-BSR', CAST(100 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (95, N'Cervical Spine Ap lat', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (96, N'BSR (2)', CAST(100 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (97, N'Mp BSR HB', CAST(150 AS Decimal(18, 0)), N'Lab', N'MP BSR HB')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (98, N'T/S Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (99, N'Skull Ap view', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (100, N'Neck Ap Lat', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (101, N'Erect', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (102, N'CXR lat view', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (103, N'leg ap lat', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
GO
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (104, N'Nosal Bone  Apvew', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Nosal Bone   Apvw')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (105, N'Pelves Hip Ap Lt', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Pelves Hip Aplt')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (106, N'Full Back ', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Full Back')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (107, N'abdom Erest Supine', CAST(1200 AS Decimal(18, 0)), N'X-Ray', N'Abdom Erest Supine ')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (108, N'Neck Soft Tissue', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (109, N'Nosal bone Ap Lat view', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (110, N'Sacraim Ap Let', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Sacraim Ap Let')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (112, N'Face Ap Lt ', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Face Ap Lt ')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (113, N'Thorasic Spine Ap Let', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Thoroasic Spine Ap Let')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (114, N'Neak Ap w', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Neak Ap w')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (115, N'Wrist Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (116, N'Both Knee Ap lat', CAST(1200 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (117, N'Hbs Hcv Rbs Hb X Hiv', CAST(600 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (118, N'Hbs Hcv RBS Hiv', CAST(550 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (119, N'Hbs Hcv RBS Hiv Mp Widal', CAST(650 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (120, N'Hbs Hcv Hiv', CAST(500 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (121, N'VDRL', CAST(100 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (122, N'Hiv', CAST(100 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (123, N'BTCT', CAST(100 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (124, N'Lumbo Later View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (125, N'Theigh Ap Lat', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (126, N'Both Hip Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (127, N'Hip Lat View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (128, N'Lumbo Ap Full Film', CAST(500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (129, N'Cxr Lat View Full film', CAST(500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (130, N'Thirocical Spine Lat', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (131, N'Cervico thorowse Lat View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (132, N'Typhoidot ', CAST(250 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (133, N'Knee Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (134, N'Neck Leteral View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (135, N'Mudible Ap Lat ', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (136, N'CXR Ap Lat View', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (137, N'Shoulder Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (138, N'D/C Spine Ap Lat ', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (139, N'Cervical Ap View Full film', CAST(500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (140, N'Pelvis Full Film', CAST(500 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (141, N'Thirocical Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (142, N'Erect Spine ', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (143, N'Sacrum Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (144, N'Inventogrametion Ap Lat', CAST(800 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (145, N'Dangue', CAST(400 AS Decimal(18, 0)), N'Lab', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (146, N'L/ Knee Joint Ap Lat', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (147, N'R/ Hand Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (148, N'L/ Hand Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (149, N'L/ Elbo Joint Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (150, N'R/ Elbo Joint Ap', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (151, N'Right Leg PA View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (152, N'R/ Arm Ap Lat ', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (153, N'Mastroid Lateral View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (154, N'Blood Group', CAST(50 AS Decimal(18, 0)), N'Lab', N'Blood Group')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (155, N'Hiv Hcv BSR Hbs', CAST(450 AS Decimal(18, 0)), N'Lab', N'Hiv Hcv BSR Hbs')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (156, N'HIV HCV BSR HBV', CAST(450 AS Decimal(18, 0)), N'Lab', N'Hiv Hcv BSR Hbv')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (157, N'Hb ', CAST(50 AS Decimal(18, 0)), N'Lab', N'Hb')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (158, N'HBS HCV HIV VDRL CM X', CAST(650 AS Decimal(18, 0)), N'Lab', N'HBS HCV HIV VDRL CM X')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (159, N'L/ Foot Ap Lat', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (160, N'R/ Foot Ap Lat', CAST(600 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (161, N'Mondible open mouth', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (162, N'Foot Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (163, N'Hip Joint Ap View', CAST(400 AS Decimal(18, 0)), N'X-Ray', N'Clinical')
INSERT [dbo].[DiagnosticTest] ([TestID], [TestName], [Charges], [TestType], [TestGroup]) VALUES (164, N'ECHO', CAST(2000 AS Decimal(18, 0)), N'ECHO', N'Clinical')
SET IDENTITY_INSERT [dbo].[DiagnosticTest] OFF
SET IDENTITY_INSERT [dbo].[DoctorFee] ON 

INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (1, 2, 8, CAST(300 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (2, 2, 9, CAST(400 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (3, 2, 10, CAST(400 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (4, 2, 11, CAST(500 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (5, 2, 12, CAST(400 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (6, 2, 13, CAST(500 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (7, 2, 14, CAST(300 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (8, 5, 12, CAST(16000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (9, 1, 12, CAST(30000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (10, 5, 8, CAST(15000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (11, 1, 8, CAST(25000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (12, 6, 8, CAST(5000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (13, 7, 8, CAST(23000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (14, 2, 33, CAST(400 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (15, 2, 30, CAST(400 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (16, 2, 9, CAST(400 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (17, 2, 5, CAST(300 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (18, 1, 11, CAST(40000 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (19, 2, 46, CAST(500 AS Decimal(18, 0)), 0)
INSERT [dbo].[DoctorFee] ([FeeID], [FeeTypeID], [DoctorID], [Fees], [IsActive]) VALUES (20, 2, 29, CAST(300 AS Decimal(18, 0)), 0)
SET IDENTITY_INSERT [dbo].[DoctorFee] OFF
SET IDENTITY_INSERT [dbo].[EmployeeWages] ON 

INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (1, 17, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'April Month salary', NULL, NULL, NULL, N'Muhammad Paryal', CAST(N'2019-03-24 13:58:46.423' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (2, 2, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(14500 AS Decimal(18, 0)), CAST(N'2019-02-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:17.310' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (3, 17, N'Cash', CAST(12000 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), CAST(N'2019-03-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:19.780' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (4, 16, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-02-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:22.750' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (5, 24, N'Cash', CAST(13000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-03-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:25.250' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (6, 19, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-01-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:27.780' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (7, 25, N'Cash', CAST(8000 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), CAST(N'2019-03-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:30.530' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (8, 35, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(4000 AS Decimal(18, 0)), CAST(N'2019-03-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:33.983' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (9, 36, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(7000 AS Decimal(18, 0)), CAST(N'2019-01-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:36.557' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (10, 37, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(7000 AS Decimal(18, 0)), CAST(N'2019-01-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:40.017' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (11, 38, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(7000 AS Decimal(18, 0)), CAST(N'2019-01-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-04 10:16:42.953' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (12, 2, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(14500 AS Decimal(18, 0)), CAST(N'2019-04-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (13, 17, N'Cash', CAST(12000 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (14, 16, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (15, 35, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(4000 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (16, 24, NULL, CAST(13000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (17, 19, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (18, 25, N'Cash', CAST(8000 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (19, 36, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(7000 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (20, 37, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(7000 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (21, 38, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(7000 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (22, 6, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-04-04 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (23, 39, NULL, CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-04-07 10:13:37.823' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (24, 26, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-05 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (25, 39, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), NULL, NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (26, 27, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (27, 21, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (28, 18, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-04-05 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (29, 41, N'Cash', CAST(13000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (30, 40, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (31, 42, N'Cash', CAST(9000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (32, 43, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (33, 44, N'Cash', CAST(21900 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (34, 22, N'Cash', CAST(29700 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (35, 23, N'Cash', CAST(48200 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (36, 2, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(10000 AS Decimal(18, 0)), CAST(N'2019-05-05 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (37, 17, N'Cash', CAST(12000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-05-05 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (38, 24, N'Cash', CAST(13000 AS Decimal(18, 0)), CAST(1000 AS Decimal(18, 0)), CAST(N'2019-05-06 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (39, 6, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(2500 AS Decimal(18, 0)), CAST(N'2019-05-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (40, 19, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(5000 AS Decimal(18, 0)), CAST(N'2019-05-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (41, 16, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (42, 18, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-05-05 00:00:00.000' AS DateTime), N'Monthly salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (43, 27, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-06 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (44, 41, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-05 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (45, 26, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(5000 AS Decimal(18, 0)), CAST(N'2019-05-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (46, 40, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (47, 42, N'Cash', CAST(9000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-06 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (48, 22, N'Cash', CAST(14500 AS Decimal(18, 0)), CAST(10000 AS Decimal(18, 0)), CAST(N'2019-05-09 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (49, 36, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-07 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (50, 38, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-06 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (51, 37, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (52, 21, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (53, 39, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (54, 43, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-07 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (55, 25, N'Cash', CAST(8000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (56, 2, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (57, 32, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-05 00:00:00.000' AS DateTime), N'Smooth Recovery', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (58, 24, N'Cash', CAST(13000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (59, 21, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (60, 17, N'Cash', CAST(12000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-05 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (61, 16, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (62, 40, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (63, 18, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (64, 39, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (65, 42, N'Cash', CAST(9000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (66, 41, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-04 00:00:00.000' AS DateTime), N'Maonthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (67, 27, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-05 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (68, 26, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (69, 35, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (70, 25, N'Cash', CAST(8000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (71, 37, NULL, CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (72, 38, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (73, 36, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (74, 45, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-04-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (75, 23, N'Cash', CAST(28000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (76, 15, N'Cash', CAST(16100 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (77, 22, N'Cash', CAST(14500 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Noor Ahmed Tagar', CAST(N'2019-06-14 14:48:31.753' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (78, 23, N'Cash', CAST(48900 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (79, 15, N'Cash', CAST(20200 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-04 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (80, 22, N'Cash', CAST(31000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (81, 45, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (82, 19, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-06-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (83, 45, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-05-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (84, 23, N'Cash', CAST(54000 AS Decimal(18, 0)), CAST(34000 AS Decimal(18, 0)), CAST(N'2019-07-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (85, 15, N'Cash', CAST(27500 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (86, 22, N'Cash', CAST(25600 AS Decimal(18, 0)), CAST(20000 AS Decimal(18, 0)), CAST(N'2019-07-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (87, 2, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-03 00:00:00.000' AS DateTime), N'Smooth Recovery', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (88, 6, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (89, 24, N'Cash', CAST(13000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (90, 21, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (91, 17, N'Cash', CAST(12000 AS Decimal(18, 0)), CAST(2000 AS Decimal(18, 0)), CAST(N'2019-07-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (92, 16, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (93, 18, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (94, 40, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (95, 39, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (96, 42, N'Cash', CAST(9000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-03 00:00:00.000' AS DateTime), N'Monthy Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (97, 19, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (98, 26, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (99, 41, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-03 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
GO
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (100, 27, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (101, 36, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (102, 38, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-02 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (103, 37, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2019-07-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (104, 2, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthli Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (105, 6, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (106, 24, N'Cash', CAST(14000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (107, 16, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (108, 19, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, N'Muharam ( Sher Ali) Tagar', CAST(N'2020-05-01 15:26:08.120' AS DateTime), 1)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (109, 18, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (110, 40, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (111, 35, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (112, 45, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (113, 21, N'Cash', CAST(15000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (114, 39, N'Cash', CAST(20000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (115, 47, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (116, 48, NULL, CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (117, 17, N'Cash', CAST(12000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (118, 26, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (119, 41, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (120, 27, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (121, 43, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (122, 36, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (123, 37, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (124, 50, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (125, 38, N'Cash', CAST(7000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (126, 51, N'Cash', CAST(10000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
INSERT [dbo].[EmployeeWages] ([WagesID], [ContactID], [PaymentType], [SalaryAmount], [LoanAmount], [SalaryDate], [Remarks], [EnteredBy], [UpdatedBy], [UpdatedDate], [DeletedBy], [DeletedDate], [IsDeleted]) VALUES (127, 19, N'Cash', CAST(11000 AS Decimal(18, 0)), CAST(0 AS Decimal(18, 0)), CAST(N'2020-04-01 00:00:00.000' AS DateTime), N'Monthly Salary', NULL, NULL, NULL, NULL, NULL, 0)
SET IDENTITY_INSERT [dbo].[EmployeeWages] OFF
SET IDENTITY_INSERT [dbo].[FeesType] ON 

INSERT [dbo].[FeesType] ([FeeTypeID], [FeeType]) VALUES (1, N'Major Surgery')
INSERT [dbo].[FeesType] ([FeeTypeID], [FeeType]) VALUES (2, N'OPD')
INSERT [dbo].[FeesType] ([FeeTypeID], [FeeType]) VALUES (3, N'Visit')
INSERT [dbo].[FeesType] ([FeeTypeID], [FeeType]) VALUES (5, N'Minor Surgery')
INSERT [dbo].[FeesType] ([FeeTypeID], [FeeType]) VALUES (6, N'Local')
INSERT [dbo].[FeesType] ([FeeTypeID], [FeeType]) VALUES (7, N'High Risk/ Critical')
SET IDENTITY_INSERT [dbo].[FeesType] OFF
SET IDENTITY_INSERT [dbo].[LabAsset] ON 

INSERT [dbo].[LabAsset] ([AssetID], [AssetTypeID], [Quantity], [Price], [CompanyName], [InvoiceNo], [InvoiceDate], [EnteredDate], [EnteredBy], [DeletedDate], [IsDeleted]) VALUES (1, 1, 10, CAST(4500.00 AS Decimal(18, 2)), N'Exposoft Solution', N'123423', CAST(N'2020-09-12 00:00:00.000' AS DateTime), CAST(N'2020-09-13 18:56:36.260' AS DateTime), N'Muhammad Paryal', NULL, 0)
SET IDENTITY_INSERT [dbo].[LabAsset] OFF
SET IDENTITY_INSERT [dbo].[LabAssetInventory] ON 

INSERT [dbo].[LabAssetInventory] ([InventoryID], [AssetTypeID], [StockIn], [StockOut], [StockQty]) VALUES (1, 1, 10, 0, CAST(10.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[LabAssetInventory] OFF
SET IDENTITY_INSERT [dbo].[Organization] ON 

INSERT [dbo].[Organization] ([OrganizationID], [OrgName], [OrgAddress], [OrgContactNo], [OrgEmail], [ContactPerson], [IsActive]) VALUES (2, N'UBL', NULL, N'123456789', NULL, NULL, 1)
SET IDENTITY_INSERT [dbo].[Organization] OFF
SET IDENTITY_INSERT [dbo].[OutDoorPatientTest] ON 

INSERT [dbo].[OutDoorPatientTest] ([OutDoorTestID], [TestNo], [TestDate], [PatientName], [DoctorID], [DoctorName], [ContactNo], [Age], [Sex], [TestID], [Discount]) VALUES (1, N'X-14-09-20-10001', CAST(N'2020-09-14 19:33:00.000' AS DateTime), N'Naveed Ahmed', 0, NULL, N'03013818199', 0, N'Male', 1, CAST(0.00 AS Decimal(18, 2)))
INSERT [dbo].[OutDoorPatientTest] ([OutDoorTestID], [TestNo], [TestDate], [PatientName], [DoctorID], [DoctorName], [ContactNo], [Age], [Sex], [TestID], [Discount]) VALUES (2, N'L-1-01-22-10001', CAST(N'2022-01-01 01:04:00.000' AS DateTime), N'Test', 55, NULL, NULL, 20, N'Male', 3, CAST(0.00 AS Decimal(18, 2)))
SET IDENTITY_INSERT [dbo].[OutDoorPatientTest] OFF
SET IDENTITY_INSERT [dbo].[Pages] ON 

INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (1, N'Company', N'../Company/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (2, N'Product Type', N'../ProductType/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (3, N'Strength', N'../Strength/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (4, N'Product', N'../Product/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (5, N'Opening Stock', N'../OpeningStock/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (6, N'Diagnostic Test', N'../DiagnosticTest/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (7, N'Purchase Medicine', N'../Purchase/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (8, N'Sale Medicine', N'../Sales/AddNew')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (9, N'Medicine Return', N'../ProductReturn/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (10, N'Medicine Stock', N'../Stock/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (11, N'Bar Code', N'../BarCodeImage/DisplayBarCode')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (12, N'Profit Report', N'../rptProfit/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (13, N'Daily Sale Report', N'../rptDailySale/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (14, N'Monthly Sale Report', N'../rptMonthlySale/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (15, N'Patient Bill Report', N'../AdmitPatientSummary/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (16, N'Monthly Purchase Report', N'../MonthlyPurchase/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (17, N'Expenses Report', N'../rptExpenseReport/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (18, N'Contact Type', N'../ContactType/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (19, N'View Doctor List', N'../Contact/Doctors')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (20, N'Add Doctor', N'../Contact/AddNew')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (21, N'View Staff List', N'../Contact/Staff')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (22, N'Add Staff', N'../Contact/AddNew')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (23, N'OPD Token', N'../DailyOPDToken/GenerateToken')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (24, N'Investigation Test', N'../OutDoorPatientTest/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (25, N'Department', N'../Department/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (26, N'Doctor Fees Category', N'../FeeType/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (27, N'Doctor Fees', N'../DoctorFee/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (28, N'Doctor Timing', N'../DoctorTiming/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (29, N'Room Setup', N'../Room/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (30, N'Patient Registration', N'../PatientReg/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (31, N'Staff Salary', N'../EmplyeeSalary/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (32, N'Expense Category', N'../ExpensesType/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (33, N'Add Expenses', N'../Expenses/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (34, N'Daily OPD Report', N'../rptDailyOPD/PrintReport')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (35, N'Daily OPD Summary Report', N'../rptDailyOPDSummary/PrintReport')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (36, N'Out Door Patient Test Summary Report', N'../rptOutDoorPatientTestSummary/PrintReport')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (37, N'Indoor Patient Summary Report', N'../IndoorPatientSummary/PrintReport')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (38, N'Lab Asset Category', N'../LabAssetType/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (39, N'Lab Asset Purchase', N'..//LabAsset/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (40, N'Lab Asset Inventory', N'../LabAsset/AssetInventory')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (41, N'DashBoard', N'../Users/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (42, N'User Management', N'../UserManagement/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (43, N'User Management', N'../UserManagement/AssignPages')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (44, N'Center Information', N'../StoreInformation/Index')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (45, N'Emplyee Salary Report', N'../EmplyeeSalary/EmployeeSalaryReport')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (46, N'Monthly Expenses Report', N'../rptExpenseReport/Print')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (47, N'Daily Investigation Test', N'../OPDDailyTestReport/PrintReport')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (48, N'Product Barcode', N'../ProductBarcode/AddProductBarcode')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (49, N'Supplier Ledger', N'../Payments/PaymentList')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (50, N'Supplier Payment', N'../Payments/PurchasePayment')
INSERT [dbo].[Pages] ([PageID], [PageName], [PageLink]) VALUES (51, N'Ledger Report', N'../LedgerReport/Index')
SET IDENTITY_INSERT [dbo].[Pages] OFF
SET IDENTITY_INSERT [dbo].[PatientRegistration] ON 

INSERT [dbo].[PatientRegistration] ([PatientID], [PatientCategory], [PatientType], [DoctorID], [RoomID], [PatientRegNo], [FirstName], [LastName], [MiddleName], [TakeCareName], [TakeCareRelation], [PatientCNIC], [TakeCareCNIC], [DateOfBirth], [Gender], [Age], [MaritalStatus], [Address], [City], [State], [Country], [Occupation], [Telephone], [MobileNo], [GuardianName], [GuardianContactNo], [ReferBy], [Diagnosis], [SecondaryDiagnosis], [AdmissionDate], [Remarks], [LaparoscopID]) VALUES (1, N'Private', N'Admit', 54, 0, N'MR-9-20-100001', N'Mudasir', N'Abbasi', NULL, N'Wajid', N'Brother', NULL, NULL, CAST(N'1900-01-01' AS Date), N'male', N'33', N'Married', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, N'Chest Pain', NULL, CAST(N'2020-09-14 00:00:00.000' AS DateTime), NULL, NULL)
SET IDENTITY_INSERT [dbo].[PatientRegistration] OFF
SET IDENTITY_INSERT [dbo].[Rooms] ON 

INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (56, N'004', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (57, N'102', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (58, N'101', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (59, N'103', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (60, N'104', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (61, N'105', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (62, N'106', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (63, N'107', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (64, N'108', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (65, N'109', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (66, N'110', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (67, N'111', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (68, N'112', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (69, N'113', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (70, N'002', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (71, N'003', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (72, N'006', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (73, N'008', N'Normal', N'1200      ')
INSERT [dbo].[Rooms] ([RoomID], [Room], [RoomType], [RoomCharges]) VALUES (74, N'007', N'Normal', N'1200      ')
SET IDENTITY_INSERT [dbo].[Rooms] OFF
SET IDENTITY_INSERT [dbo].[RoomStatus] ON 

INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (34, 34, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (35, 35, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (36, 36, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (37, 37, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (38, 38, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (39, 39, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (40, 40, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (41, 41, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (42, 42, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (43, 43, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (44, 44, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (45, 45, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (46, 46, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (47, 47, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (48, 48, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (49, 49, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (50, 50, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (51, 51, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (52, 52, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (53, 53, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (54, 54, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (55, 55, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (56, 56, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (57, 57, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (58, 58, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (59, 59, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (60, 60, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (61, 61, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (62, 62, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (63, 63, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (64, 64, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (65, 65, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (66, 66, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (67, 67, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (68, 68, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (69, 69, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (70, 70, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (71, 71, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (72, 72, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (73, 73, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (74, 74, N'Alloted')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (75, 75, N'Available')
INSERT [dbo].[RoomStatus] ([RoomStatusID], [RoomID], [RoomStatus]) VALUES (76, 76, N'Available')
SET IDENTITY_INSERT [dbo].[RoomStatus] OFF
/****** Object:  StoredProcedure [dbo].[sp_AdmitPatientSaleReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_AdmitPatientSaleReport] 
	@SaleID int = null
AS
BEGIN
	IF(@SaleID > 0)
		BEGIN
			SELECT sm.SaleID, sm.SaleInvoiceNumber, Convert(varchar,sm.SaleDate,(101)) as SaleDate, 
			sm.SaleType, pr.PatientRegNo,
			case when IsNull(sm.PatientName,'') = '' then (pr.FirstName+' '+pr.LastName) else  sm.PatientName end as PatientName,
			case when IsNull(sm.ContactNo,'') = '' then pr.MobileNo else sm.ContactNo end as ContactNo ,
			case when IsNull(sm.GuardianName,'') = '' then pr.GuardianName else sm.GuardianName end as GuardianName, 
			case when ISNULL(sm.GuardianContactNo,'') = '' then pr.GuardianContactNo else sm.GuardianContactNo end as GuardianContactNo,
			ISNULL(sm.RoomNo,'')RoomNo,
			isNull(sm.Diagnostics,'')Remarks, ISNULL(sm.EnteredBy,'')as EnteredBy,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, sd.DiscountAmount, sd.Total,
			(p.ProductName+' '+ pt.ProductType +' '+ s.Strength)ProductName
			FROM 
				SalesMaster sm
			JOIN 
				SalesDetail sd ON sm.SaleID = sd.SaleID
			Left Outer JOIN
				PatientRegistration pr ON sm.PatientID = pr.PatientID
			JOIN 
				Product p ON p.ProductID = sd.ProductID 
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			WHERE 
				sm.SaleType='AdmitPatient'
			AND 
				sm.SaleID =  @SaleID and sm.IsDeleted = 0
		END
	ELSE
		BEGIN
			SELECT sm.SaleID, sm.SaleInvoiceNumber, Convert(varchar,sm.SaleDate,(101)) as SaleDate, 
			sm.SaleType, pr.PatientRegNo,
			case when IsNull(sm.PatientName,'') = '' then (pr.FirstName+' '+pr.LastName) else  sm.PatientName end as PatientName,
			case when IsNull(sm.ContactNo,'') = '' then pr.MobileNo else sm.ContactNo end as ContactNo ,
			case when IsNull(sm.GuardianName,'') = '' then pr.GuardianName else sm.GuardianName end as GuardianName, 
			case when ISNULL(sm.GuardianContactNo,'') = '' then pr.GuardianContactNo else sm.GuardianContactNo end as GuardianContactNo,
			ISNULL(sm.RoomNo,'')RoomNo,
			isNull(sm.Diagnostics,'')Remarks, ISNULL(sm.EnteredBy,'')as EnteredBy,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, sd.DiscountAmount, sd.Total,
			(p.ProductName+' '+ pt.ProductType +' '+ s.Strength)ProductName
			FROM 
				SalesMaster sm
			JOIN 
				SalesDetail sd ON sm.SaleID = sd.SaleID
			Left Outer JOIN
				PatientRegistration pr ON sm.PatientID = pr.PatientID
			JOIN 
				Product p ON p.ProductID = sd.ProductID 
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			WHERE 
				sm.SaleType='AdmitPatient' and sm.IsDeleted = 0		
		END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_AssignPages]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_AssignPages]
	@AssignPageID int = null,
	@PageID int = null,
	@LabelName varchar(200) = null,
	@Sequence int = null,
	@IsActive bit = null,
	@ParentPageID int = null,
	@ContactTypeID int = null,
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO AssignPages(PageID, LabelName, Sequence, IsActive, ParentPageID, ContactTypeID)
		VALUES (@PageID, @LabelName, @Sequence, @IsActive, @ParentPageID, @ContactTypeID)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE AssignPages SET
		PageID = @PageID,
		LabelName = @LabelName,
		Sequence = @Sequence,
		IsActive = @IsActive,
		ParentPageID = @ParentPageID,
		ContactTypeID = @ContactTypeID 
		WHERE AssignPageID = @AssignPageID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM AssignPages WHERE AssignPageID = @AssignPageID 
	END
	
	IF(@ModeType = 'GET_PAGES')
	BEGIN
		SELECT *, pageid, (PageName+' ('+pageLink+')') as PageWithLink FROM Pages order by PageName
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@AssignPageID > 0)
			select ap.*, p.*, ct.*
			from pages p
			right join assignpages ap on ap.pageid = p.pageid
			join ContactType ct on ct.ContactTypeID = ap.ContactTypeID
			where ap.isactive =1 and ap.assignPageID = @AssignPageID
			order by ap.sequence
		ELSE 
			select ap.*, p.*, ct.*
			from pages p
			right join assignpages ap on ap.pageid = p.pageid
			join ContactType ct on ct.ContactTypeID = ap.ContactTypeID
			where ap.isactive =1 
			order by ap.sequence
			
	END 
END
GO
/****** Object:  StoredProcedure [dbo].[sp_BarCodeGenerate]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_BarCodeGenerate]
	@BarcodeID			int = null,
	@ProductID			int = null,
	@FolderName			varchar(100) = null,
	@BarcodeImageName	varchar(100) = null,
	@GenerateDate		datetime = null,
	@Search				nvarchar(100) = '',
	@ModeType			nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO BarCodeGenerate(ProductID,FolderName,BarcodeImageName, GenerateDate)
		VALUES (@ProductID,@FolderName, @BarcodeImageName, @GenerateDate)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE BarCodeGenerate SET
			ProductID			= @ProductID,
			FolderName			= @FolderName,
			BarcodeImageName	= @BarcodeImageName,
			GenerateDate		= @GenerateDate
		WHERE
			BarcodeID = @BarcodeID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM BarCodeGenerate WHERE BarcodeID = @BarcodeID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@BarcodeID > 0)
			SELECT * FROM BarCodeGenerate WHERE BarcodeID = @BarcodeID
		ELSE
			SELECT b.BarcodeID, p.ProductName, b.FolderName,b.BarcodeImageName, b.GenerateDate 
			FROM BarCodeGenerate b
			JOIN Product p ON p.ProductID = b.ProductID
	END
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM BarCodeGenerate
			WHERE
			BarcodeID LIKE('%'+@Search+'%') OR 
			ProductID LIKE('%'+@Search+'%') OR
			FolderName LIKE('%'+@Search+'%') OR
			BarcodeImageName LIKE('%'+@Search+'%') OR
			GenerateDate LIKE('%'+@Search+'%')
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_BarCodeImage]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_BarCodeImage] 
	@ProductID int = null
AS
BEGIN
	if(@ProductID >0)
		begin
			--Select FolderName,BarcodeImageName, 
			--(FolderName+BarcodeImageName)Barcodeimage
			-- from BarCodeGenerate where ProductID = @ProductID
			
			SELECT p.ProductID, p.CompanyID, c.Company, (pt.ProductType+'   '+p.ProductName+'  '+s.Strength)as ProductName ,
				(bc.BarcodeImageName)as BarcodeImage
			FROM 
				Product p
			JOIN 
				BarCodeGenerate bc ON p.ProductID = bc.ProductID
			JOIN 
				ProductType pt ON p.ProductTypeID = pt.ProductTypeID
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				Company c ON c.CompanyID = p.CompanyID
			where p.ProductID = @ProductID
			
		end
	else
		begin
			SELECT p.ProductID, p.CompanyID, c.Company, (pt.ProductType+'   '+p.ProductName+'  '+s.Strength)as ProductName ,
				(bc.BarcodeImageName)as BarcodeImage
			FROM 
				Product p
			JOIN 
				BarCodeGenerate bc ON p.ProductID = bc.ProductID
			JOIN 
				ProductType pt ON p.ProductTypeID = pt.ProductTypeID
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				Company c ON c.CompanyID = p.CompanyID
			Order By c.Company , p.ProductName
		end
END


GO
/****** Object:  StoredProcedure [dbo].[sp_BarCodeImageReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_BarCodeImageReport] 
	
AS
BEGIN

	SELECT p.ProductID, (p.ProductName+'   '+pt.ProductType+'   '+s.Strength)as ProductName ,
		(bc.BarcodeImageName)as BarcodeImage
	FROM 
		Product p
	JOIN 
		BarCodeGenerate bc ON p.ProductID = bc.ProductID
	JOIN 
		ProductType pt ON p.ProductTypeID = pt.ProductTypeID
	JOIN 
		Strength s ON s.StrengthID = p.StrengthID 
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Company]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Company]
	@CompanyID int = null,
	@Company varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Company(Company) 
		VALUES (@Company)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Company SET 
		Company = @Company
		WHERE CompanyID = @CompanyID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Company 
		WHERE CompanyID = @CompanyID	
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@CompanyID > 0)
			SELECT * FROM Company WHERE CompanyID = @CompanyID
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@CompanyID > 0)
			SELECT * FROM Company 
			WHERE Company = @Company AND NOT(CompanyID = @CompanyID)
		ELSE
			SELECT * FROM Company WHERE Company = @Company
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM Company
		WHERE 
			Company LIKE('%'+@Search+'%')
	END
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Contact]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Contact]
	@ContactID int = null,
	@ContactTypeID int = null,
	@FirstName nvarchar(50) = null,
	@LastName nvarchar(50) = null,
	@Email nvarchar(50) = null,
	@Address nvarchar(50) = null,
	@Address2 nvarchar(50) = null,
	@City nvarchar(50) = null,
	@Province nvarchar(50) = null,
	@Country nvarchar(50) = null,
	@UserName	varchar(50) = null,
	@Password	varchar(50) = null,
	@Telephone nvarchar(50) = null,
	@Mobile nvarchar(50) = null,
	@Website nvarchar(100) = null,
	@Qualification varchar(500) = null,
	@Experience		varchar(100) = null,
	@JoiningDate	datetime = null,
	@EnteredDate datetime = null,
	@EnteredBy varchar(50) = null,
	@UpdatedBy varchar(50) = null,
	@UpdatedDate datetime = null,
	@DeletedBy varchar(50) = null,
	@DeletedDate datetime = null,
	@IsDeleted bit = null,
	@Status varchar(50) = null,
	@DepartmentID int = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(50) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Contact(ContactTypeID, FirstName, LastName, Email, Address, Address2, City, Province,
		Country, UserName,	Password, Telephone, Mobile, Website, Qualification, Experience, JoiningDate,
		EnteredDate, EnteredBy, UpdatedBy, UpdatedDate, DeletedBy,
		DeletedDate, IsDeleted, Status, DepartmentID)
		VALUES (@ContactTypeID, @FirstName, @LastName, @Email, @Address, @Address2, @City, @Province,
		@Country, @UserName, @Password, @Telephone, @Mobile, @Website, @Qualification, @Experience, @JoiningDate,
		Convert(date,CONVERT(date,GETDATE(),106),103), 
		@EnteredBy, @UpdatedBy, Convert(date,CONVERT(date,GETDATE(),106),103), @DeletedBy,
		Convert(date,CONVERT(date,GETDATE(),106),103), @IsDeleted, @Status, @DepartmentID)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Contact SET
		ContactTypeID = @ContactTypeID,
		FirstName = @FirstName,
		LastName = @LastName,
		Email = @Email,
		Address = @Address,
		Address2 = @Address2,
		City = @City,
		Province = @Province,
		Country = @Country,
		UserName = @UserName,
		Password = @Password,
		Telephone = @Telephone,
		Mobile = @Mobile,
		Website = @Website,
		Qualification = @Qualification,
		Experience = @Experience,
		JoiningDate = @JoiningDate,
		UpdatedBy = @UpdatedBy,
		UpdatedDate = Convert(date,CONVERT(date,GETDATE(),106),103),
		Status = @Status,
		DepartmentID = @DepartmentID
		WHERE
			ContactID = @ContactID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		UPDATE Contact SET 
		DeletedBy = @DeletedBy,
		DeletedDate = Convert(date,CONVERT(date,GETDATE(),106),103),
		IsDeleted = '1'
		WHERE ContactID = @ContactID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@ContactID > 0)
			SELECT c.ContactID, c.ContactTypeID, cty.ContactType, c.FirstName, c.LastName, c.Email, c.Address, c.Address2, c.City, c.Province,
			c.Country, UserName, Password, c.Telephone, c.Mobile, c.Website, c.Qualification, c.Experience,  
			isnull(c.JoiningDate, '2010/1/1')as JoiningDate,
			c.EnteredDate, c.EnteredBy, c.UpdatedBy, c.UpdatedDate,
			c.DeletedBy, c.DeletedDate,c.IsDeleted, c.Status, ISNULL(c.DepartmentID,0) as DepartmentID
			FROM Contact c
			JOIN ContactType cty ON cty.ContactTypeID = c.ContactTypeID
			WHERE ContactID = @ContactID AND IsDeleted = '0'
	END
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT c.ContactID, c.ContactTypeID, cty.ContactType, c.FirstName, c.LastName, c.Email, c.Address, c.Address2, c.City, 
		c.Province,c.Country, UserName, Password, c.Telephone, c.Mobile, c.Website, c.Qualification, c.Experience, 
		isnull(c.JoiningDate, '2010/1/1')as JoiningDate,
		c.EnteredDate, 
		c.EnteredBy, c.UpdatedBy, c.UpdatedDate, ISNULL(c.DepartmentID,0) as DepartmentID,
			c.DeletedBy, c.DeletedDate,c.IsDeleted, c.Status  
			FROM Contact c
			JOIN ContactType cty ON cty.ContactTypeID = c.ContactTypeID 
			WHERE
			c.IsDeleted = '0' AND
			(cty.ContactType LIKE('%'+@Search+'%') OR
			c.FirstName LIKE('%'+@Search+'%') OR
			c.LastName LIKE('%'+@Search+'%') OR
			c.Email LIKE('%'+@Search+'%') OR
			c.Address LIKE('%'+@Search+'%') OR
			c.Address2 LIKE('%'+@Search+'%') OR
			c.City LIKE('%'+@Search+'%') OR
			c.Province LIKE('%'+@Search+'%') OR
			c.Country LIKE('%'+@Search+'%') OR
			c.UserName LIKE('%'+@Search+'%') OR
			c.Telephone LIKE('%'+@Search+'%') OR
			c.Mobile LIKE('%'+@Search+'%') OR
			c.Website LIKE('%'+@Search+'%') OR
			c.EnteredDate LIKE('%'+@Search+'%') OR
			c.EnteredBy LIKE('%'+@Search+'%') OR
			c.UpdatedBy LIKE('%'+@Search+'%') OR
			c.UpdatedDate LIKE('%'+@Search+'%') OR
			c.DeletedBy LIKE('%'+@Search+'%') OR
			c.DeletedDate LIKE('%'+@Search+'%') OR
			c.IsDeleted LIKE('%'+@Search+'%') OR
			c.Status LIKE('%'+@Search+'%'))
	END
	
	IF(@ModeType = 'AUTHENTICATION')
	BEGIN
		SELECT *,(FirstName+' '+LastName) as ShowName FROM Contact c
		JOIN ContactType ct on ct.ContactTypeID = c.ContactTypeID
		WHERE 
		UserName = @UserName AND Password = @Password
	END
	
	IF(@ModeType = 'UPDATEPWD')
	BEGIN
		UPDATE Contact 
		SET Password = @Password
		WHERE 
		ContactID = @ContactID 
		--AND Password = @Password
	END
	
	
	IF(@ModeType = 'GetAllEmployeeNotDoctor')
	BEGIN
		SELECT *,(FirstName+' '+LastName) as ShowName FROM Contact c
		JOIN ContactType ct on ct.ContactTypeID = c.ContactTypeID
		WHERE ct.ContactType <>'Doctor'
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ContactType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ContactType] 
	@ContactTypeID int = null,
	@ContactType varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO ContactType(ContactType) 
		VALUES (@ContactType)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE ContactType SET 
		ContactType = @ContactType
		WHERE ContactTypeID = @ContactTypeID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM ContactType 
		WHERE ContactTypeID = @ContactTypeID	
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@ContactTypeID > 0)
			SELECT * FROM ContactType WHERE ContactTypeID = @ContactTypeID
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@ContactTypeID > 0)
			SELECT * FROM ContactType 
			WHERE ContactType = @ContactType AND NOT(ContactTypeID = @ContactTypeID)
		ELSE
			SELECT * FROM ContactType WHERE ContactType = @ContactType
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM ContactType
		WHERE 
			ContactType LIKE('%'+@Search+'%')
	END
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_CurrentStock]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_CurrentStock]
	@ModeType varchar(50)
AS
BEGIN
	
	drop table CurrentStopTable
	
	
			SELECT p.ProductID, (p.ProductName+'   '+pt.ProductType +'   '+ s.Strength)as ProductName,
				isnull(((isnull(os.Quantity,0) + SUM(isnull(pd.Quantity,0)) + SUM(ISNULL(pr.Quantity,0)) - isnull(sd.Quantity,0) - ISNULL(Drugpr.Quantity,0)) ),0)as StockQuantity
				into CurrentStopTable
			
			FROM 
				Product p 
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			LEFT JOIN 
				OpeningStock os ON p.ProductID = os.ProductID
			LEFT JOIN 
				(select SUM(Quantity) as Quantity, ProductID from ProductReturn where ReturnType in('Admit Patient','OPD') group by ProductID) pr ON p.ProductID = pr.ProductID
			LEFT JOIN 
				(select SUM(Quantity) as Quantity, productID from ProductReturn where ReturnType in('Drug Agency') group by productID) Drugpr ON p.ProductID = Drugpr.ProductID
			LEFT JOIN
				(select isnull(sum(Quantity),0)as Quantity, ProductID from  PurchaseDetail pdd JOIN PurchaseMaster pmm ON pmm.PurchaseID = pdd.PurchaseID group by pdd.ProductID) pd ON p.ProductID = pd.ProductID
			LEFT JOIN
				(select isnull(sum(Quantity),0)as Quantity, ProductID from  SalesDetail sdd JOIN SalesMaster smm ON smm.SaleID = sdd.SaleID group by sdd.ProductID) sd ON p.ProductID = sd.ProductID		
			GROUP BY 
				p.ProductID, p.ProductName, s.Strength,sd.Quantity,  pt.ProductType, os.Quantity, Drugpr.Quantity

	if(@ModeType ='DashBoardView')
		Select * from CurrentStopTable where StockQuantity <=10 order by ProductName
		
	if(@ModeType ='ReportView')
		Select * from CurrentStopTable order by ProductName
	
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DailyOPD]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DailyOPD]
	@OPDID int = null,
	@OPDNumber varchar(20) = null,
	@DoctorID int = null,
	@PatientName varchar(50) = null,
	@ContactNo varchar(20) = null,
	@Age int = null,
	@Sex varchar(10) = null,
	@City varchar(50) = null,
	@OPDDate datetime = null,
	@Discount decimal(18,0) = null,
	@Status varchar(20) = null,
	@Search varchar(50) = null,
	@ModeType varchar(50) = null
AS
BEGIN
	if(@ModeType = 'INSERT')
		begin
			INSERT INTO DailyOPD (OPDNumber, DoctorID, PatientName, ContactNo, Age, Sex, City, OPDDate, Discount, Status)
			values(@OPDNumber, @DoctorID, @PatientName, @ContactNo, @Age, @Sex, @City, GETDATE(), @Discount, @Status)
		end
		
	if(@ModeType = 'Update')
		begin
			Update DailyOPD set  
			PatientName = @PatientName,
			ContactNo = @ContactNo,
			Age = @Age,
			Sex = @Sex,
			City = @City,
			Discount = @Discount,
			OPDDate = GETDATE(),
			Status = @Status
			where OPDID = @OPDID			
		end

	if(@ModeType = 'StatusUpdate')
		begin
			Update DailyOPD set  Status = @Status where OPDID = @OPDID			
		end
		
	if(@ModeType = 'GetDailyOPDToken')
		Begin
			--Select * from DailyOPD
			Select opd.OPDID, opd.DoctorID, opd.OPDNumber, opd.PatientName, opd.ContactNo, opd.Age, opd.Sex, opd.City, opd.OPDDate,
			CONVERT(varchar, opd.OPDDate,(101))as TokenDate, 
			CAST(DATEPART(HOUR, opd.OPDDate)AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, opd.OPDDate)AS VARCHAR(2))as TokenTime,
			ISNULL(opd.Discount,0)as Discount, ISNULL(opd.Status,'Checked')as Status, 
			(c.FirstName+' '+c.LastName)as DoctorName
			from DailyOPD opd 
			JOIN Contact c ON opd.DoctorID  = c.ContactID
			where CAST(opd.OPDDate as DATE) = CAST(GetDate()as DATE) 
			--and opd.Status='Checked' 
			Order By opd.DoctorID

			
		End	

	if(@ModeType = 'GetByID')
		Begin
			Select * from DailyOPD where OPDID = @OPDID
		End	
		
	if(@ModeType = 'GenerateNewToken')
		Begin
			Select [dbo].[UDF_GEN_TokenNumber](@DoctorID) as NewToken
		End	

	if(@ModeType = 'SearchOPD')
		Begin			
			Select opd.OPDID, opd.DoctorID, opd.OPDNumber, opd.PatientName, opd.ContactNo, opd.Age, opd.Sex, opd.City, opd.OPDDate,
			CONVERT(varchar, opd.OPDDate,(101))as TokenDate, 
			CAST(DATEPART(HOUR, opd.OPDDate)AS VARCHAR(2)) + ':' + CAST(DATEPART(MINUTE, opd.OPDDate)AS VARCHAR(2))as TokenTime,
			ISNULL(opd.Discount,0)as Discount, ISNULL(opd.Status,'Checked')as Status, 
			(c.FirstName+' '+c.LastName)as DoctorName
			from DailyOPD opd 
			JOIN Contact c ON opd.DoctorID  = c.ContactID
			where 
			opd.OPDNumber LIKE('%'+@Search+'%') OR
			opd.PatientName LIKE('%'+@Search+'%') OR
			opd.ContactNo LIKE('%'+@Search+'%') OR
			opd.Age LIKE('%'+@Search+'%') OR
			opd.Sex LIKE('%'+@Search+'%') OR
			opd.City LIKE('%'+@Search+'%') 			 
			and opd.Status='Checked' 
			Order By opd.DoctorID
		end
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DailyOPDPrintReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_DailyOPDPrintReport]
	-- Add the parameters for the stored procedure here	
	@DoctorID int = null,
	@PrintDate date = null
	
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'select (c.FirstName+'' ''+c.LastName)as DoctorName, do.OPDNumber,  do.PatientName, 
					do.Age, do.Sex, isnull(do.City, '''') as City, IsNull(do.ContactNo,'''')as ContactNo, do.OPDDate, do.Discount, do.Status,
					Cast(df.Fees as Decimal(18,2))as Fees, 
					case when do.Status=''Cancel'' then 0 else (Cast(df.Fees as Decimal(18,2))-do.Discount) end as TotalFees,
					CAST(do.OPDDate as DATE) as OPDTokenDate,  
					CONVERT(varchar(15),CAST(do.OPDDate AS TIME),100)as TokenTime
					from DailyOPD do 
					JOIN Contact c ON do.DoctorID = c.ContactID
					JOIN DoctorFee df ON do.DoctorID = df.DoctorID
					JOIN FeesType ft ON df.FeeTypeID = ft.FeeTypeID
					where ft.FeeType=''OPD''
					and CAST(do.OPDDate as DATE) = @PrintDate '
		
	
	if(@DoctorID is not null) 
		SET @SQLQuery = @SQLQuery + ' and do.DoctorID = @DoctorID '
		
	SET @SQLQuery = @SQLQuery + ' order by OPDNumber '
	
	Set @ParamDefinition =      ' @DoctorID int,
                @PrintDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @PrintDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DailyOPDReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_DailyOPDReport]
	@FromDate date = null,
	@ToDate date = null,
	@OPDID int = null,
	@DoctorID int = null, 
	@ModeType varchar(30) = null
AS
BEGIN
	if(@ModeType = 'PrintOPDToken')
		Begin
			Select do.OPDID, do.OPDNumber, do.PatientName, do.Age, do.Sex, isnull(do.City, '') as City, do.ContactNo, do.OPDDate,
			(c.FirstName+ ' '+c.LastName)as DoctorName, 
			df.Fees as OPDFee, isNull(do.Discount,0)as Discount,
			(df.Fees - Discount) as NetOPDFee, do.Status
			From DailyOPD do 
			JOIN Contact c ON do.DoctorID = c.ContactID
			left outer join DoctorFee df ON do.DoctorID = df.DoctorID
			left outer join FeesType ft on df.FeeTypeID = ft.FeeTypeID
			Where OPDID = (select Max(OPDID)  from DailyOPD)
			and ft.FeeType = 'OPD'

		ENd

		if(@ModeType = 'RePrintOPDToken')
		Begin
			Select do.OPDID, do.OPDNumber, do.PatientName, do.Age, do.Sex, isnull(do.City, '') as City, do.ContactNo, do.OPDDate,
			(c.FirstName+ ' '+c.LastName)as DoctorName, 
			df.Fees as OPDFee, isNull(do.Discount,0)as Discount,
			(df.Fees - Discount) as NetOPDFee, do.Status
			From DailyOPD do 
			JOIN Contact c ON do.DoctorID = c.ContactID
			left outer join DoctorFee df ON do.DoctorID = df.DoctorID
			left outer join FeesType ft on df.FeeTypeID = ft.FeeTypeID
			Where OPDID = @OPDID
			and ft.FeeType = 'OPD'

		ENd
	
	if(@ModeType = 'MonthlyOPD')
		Begin
			Select do.OPDID, do.OPDNumber, do.PatientName, do.Age, do.Sex, isnull(do.City, '') as City, do.ContactNo, do.OPDDate,
			(c.FirstName+ ' '+c.LastName)as DoctorName, 
			df.Fees as OPDFee, isNull(do.Discount,0)as Discount,
			(df.Fees - Discount) as NetOPDFee, do.Status
			From DailyOPD do 
			JOIN Contact c ON do.DoctorID = c.ContactID
			left outer join DoctorFee df ON do.DoctorID = df.DoctorID
			left outer join FeesType ft on df.FeeTypeID = ft.FeeTypeID
			where CAST(do.OPDDate as DATE) BETWEEN @FromDate and @ToDate
			Order By do.DoctorID

		ENd
		
	if(@ModeType = 'MonthlyOPDByDoctor')
		Begin
			Select do.OPDID, do.OPDNumber, do.PatientName, do.Age, do.Sex, isnull(do.City, '') as City, do.ContactNo, do.OPDDate,
			(c.FirstName+ ' '+c.LastName)as DoctorName, 
			df.Fees as OPDFee, isNull(do.Discount,0)as Discount,
			(df.Fees - Discount) as NetOPDFee, do.Status
			From DailyOPD do 
			JOIN Contact c ON do.DoctorID = c.ContactID
			left outer join DoctorFee df ON do.DoctorID = df.DoctorID
			left outer join FeesType ft on df.FeeTypeID = ft.FeeTypeID
			where CAST(do.OPDDate as DATE) BETWEEN @FromDate and @ToDate
			and do.DoctorID = @DoctorID

		ENd
	
	
END



GO
/****** Object:  StoredProcedure [dbo].[sp_DailyOPDSummary]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DailyOPDSummary]
	
AS
BEGIN
	SELECT convert(varchar, do.OPDDate,(107))as OPDDate,
		(c.FirstName+' '+c.LastName) as DoctorName, df.Fees, Count(do.OPDID) OPDCount,
		(Count(do.OPDID) * df.Fees)as TotalAmount, 
		SUM(do.Discount)as Discount, ((Count(do.OPDID) * df.Fees)-SUM(do.Discount))as NetAmount
		from 
			DailyOPD do
		JOIN 
			Contact c ON do.DoctorID = c.ContactID
		JOIN 
			DoctorFee df ON c.ContactID = df.DoctorID
		JOIN 
			FeesType ft ON df.FeeTypeID = ft.FeeTypeID
		where 
			ft.FeeType='OPD' and do.Status='Checked'
		--and CAST(do.OPDDate as DATE) between '2018/1/24' and '2018/1/25'
		group by c.FirstName, c.LastName,df.Fees, convert(varchar, do.OPDDate,(107)), do.DoctorID
		order by convert(varchar, do.OPDDate,(107)), do.DoctorID
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DailyOPDSummaryReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------

CREATE PROCEDURE [dbo].[sp_DailyOPDSummaryReport]
	-- Add the parameters for the stored procedure here	
	@DoctorID int = null,
	@FromDate date = null,
	@ToDate date = null	
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'SELECT convert(varchar, do.OPDDate,(107))as OPDDate,
					(c.FirstName+'' ''+c.LastName) as DoctorName, df.Fees, Count(do.OPDID) OPDCount,
					(Count(do.OPDID) * df.Fees)as TotalAmount, 
					SUM(do.Discount)as Discount, ((Count(do.OPDID) * df.Fees)-SUM(do.Discount))as NetAmount
					FROM DailyOPD do
					JOIN Contact c ON do.DoctorID = c.ContactID
					JOIN DoctorFee df ON c.ContactID = df.DoctorID
					JOIN FeesType ft ON df.FeeTypeID = ft.FeeTypeID
					where ft.FeeType=''OPD'' and do.Status=''Checked'' '
		
	
	if((@DoctorID is not null) and (@FromDate is not null))
		SET @SQLQuery = @SQLQuery + ' and do.DoctorID= @DoctorID  and CAST(do.OPDDate as DATE) between @FromDate and @ToDate '
	
	if((@DoctorID is null) and (@FromDate is not null))
		SET @SQLQuery = @SQLQuery + ' and CAST(do.OPDDate as DATE) between @FromDate and @ToDate '
	
	
	SET @SQLQuery = @SQLQuery + ' group by c.FirstName, c.LastName,df.Fees, convert(varchar, do.OPDDate,(107)), do.DoctorID '
	
	SET @SQLQuery = @SQLQuery + ' order by convert(varchar, do.OPDDate,(107)), do.DoctorID '
	
	
	Set @ParamDefinition =      ' @DoctorID int,
                @FromDate DateTime,
                @ToDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @FromDate, 
                @ToDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DailyProductSale]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DailyProductSale]
	@SaleDate date = null,
	@ModeType varchar(30) = null
AS
BEGIN
	
	if(@ModeType = 'CurrentDateSale')
		Begin
			SELECT 
				(pt.ProductType+'  '+ p.ProductName+'  '+s.Strength)as ProductName, 
				SUM(sd.Quantity) as SaleQuantity, SUM(Total)as SaleAmount
			FROM 
				SalesMaster sm
			INNER JOIN 
				SalesDetail sd on sm.SaleID = sd.SaleID
			INNER JOIN 
				Product p ON sd.ProductID = p.ProductID
			INNER JOIN 
				ProductType pt ON p.ProductTypeID  = pt.ProductTypeID
			INNER JOIN 
				Strength s ON p.StrengthID = s.StrengthID
			WHERE 
				CAST(sm.DateEntered as Date) = CAST(@SaleDate as Date)
			GROUP BY
				p.ProductName, pt.ProductType,s.Strength
		End
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DailySaleReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DailySaleReport]
	@SaleType	varchar(50) =  null,
	@DoctorID	int = null,
	@SaleDate	date = null
AS
BEGIN
	
	IF(@SaleType = 'OPD' and @DoctorID = 0)
		BEGIN
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, Diagnostics,  sm.Remarks, 
			--Convert(varchar,sm.DateEntered,(100)) as DateEntered, 
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, --sd.DiscountAmount, sd.Total,
			Round((((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as DiscountAmount,
			(sd.Quantity * sd.Price) as Total, 
			--(sd.Total-sd.DiscountAmount)NetAmount,
			Round((sd.Quantity * sd.Price) - (((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Product p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate
			AND sm.SaleType ='OPD'
		END

	IF(@SaleType = 'OPD' and @DoctorID > 0)
		BEGIN
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, Diagnostics,  sm.Remarks, 
			--Convert(varchar,sm.DateEntered,(100)) as DateEntered, 
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, --sd.DiscountAmount, sd.Total,
			Round((((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as DiscountAmount,
			(sd.Quantity * sd.Price) as Total, 
			--(sd.Total-sd.DiscountAmount)NetAmount,
			Round((sd.Quantity * sd.Price) - (((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Product p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate 
			and sm.DoctorID = @DoctorID
			AND sm.SaleType ='OPD'
		END
		
	IF(@SaleType = 'AdmitPatient')
		BEGIN
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, Diagnostics, sm.Remarks, 
			--Convert(varchar,sm.DateEntered,(100)) as DateEntered, 
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, --sd.DiscountAmount, sd.Total,
			Round((((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as DiscountAmount,
			(sd.Quantity * sd.Price) as Total, 
			--(sd.Total-sd.DiscountAmount)NetAmount,
			Round((sd.Quantity * sd.Price) - (((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Product p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate
			AND sm.SaleType ='AdmitPatient'
		END
	
	IF(@SaleType = 'ALL' and @DoctorID = 0)
		BEGIN
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, Diagnostics, sm.Remarks, 
			--Convert(varchar,sm.DateEntered,(100)) as DateEntered, 
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, --sd.DiscountAmount, sd.Total,
			Round((((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as DiscountAmount,
			(sd.Quantity * sd.Price) as Total, 
			--(sd.Total-sd.DiscountAmount)NetAmount,
			Round((sd.Quantity * sd.Price) - (((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Product p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate			
		END

	IF(@SaleType = 'ALL' and @DoctorID > 0)
		BEGIN
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, Diagnostics, sm.Remarks, 
			--Convert(varchar,sm.DateEntered,(100)) as DateEntered, 
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, --sd.DiscountAmount, sd.Total,
			Round((((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as DiscountAmount,
			(sd.Quantity * sd.Price) as Total, 
			--(sd.Total-sd.DiscountAmount)NetAmount,
			Round((sd.Quantity * sd.Price) - (((sd.Quantity * sd.Price) * sd.Discount) / 100),0) as NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Product p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate	
			and sm.DoctorID = @DoctorID		
		END
	
	IF(@SaleType = 'AdmitPatientSummary')
		BEGIN
			Select sm.SaleType,
			sum(sd.Quantity) as Quantity, P.UnitPrice as Price, sum(sd.Quantity * sd.Price) as Total, P.ProductName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Products p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			WHERE SaleDate = @SaleDate
			AND sm.SaleType ='AdmitPatient' 
			group by  P.ProductName,P.UnitPrice, sm.SaleType 
			order by P.ProductName
		END

	IF(@SaleType = 'OPDSummary' and @DoctorID = 0)
		BEGIN
			Select sm.SaleType,
			sum(sd.Quantity) as Quantity, P.UnitPrice as Price, sum(sd.Quantity * sd.Price) as Total, P.ProductName,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Products p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate
			AND sm.SaleType ='OPD' 
			group by  P.ProductName, P.UnitPrice, sm.SaleType , con.FirstName, con.LastName
			order by P.ProductName
		END

	IF(@SaleType = 'OPDSummary' and @DoctorID > 0)
		BEGIN
			Select sm.SaleType,
			sum(sd.Quantity) as Quantity, P.UnitPrice as Price, sum(sd.Quantity * sd.Price) as Total, P.ProductName,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Products p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate
			AND sm.SaleType ='OPD' 
			and sm.DoctorID = @DoctorID
			group by  P.ProductName, P.UnitPrice, sm.SaleType, con.FirstName, con.LastName 
			order by P.ProductName
		END

		IF(@SaleType = 'ALLSummary' and @DoctorID = 0)
		BEGIN
			Select sm.SaleType,
			sum(sd.Quantity) as Quantity, P.UnitPrice as Price, sum(sd.Quantity * sd.Price) as Total, P.ProductName,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Products p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate			
			group by  P.ProductName, P.UnitPrice, sm.SaleType , con.FirstName, con.LastName
			order by P.ProductName
		END

	IF(@SaleType = 'ALLSummary' and @DoctorID > 0)
		BEGIN
			Select sm.SaleType,
			sum(sd.Quantity) as Quantity, P.UnitPrice as Price, sum(sd.Quantity * sd.Price) as Total, P.ProductName,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM SalesMaster sm
			JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN Products p ON p.ProductID = sd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID 
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE SaleDate = @SaleDate	
			and sm.DoctorID = @DoctorID		
			group by  P.ProductName, P.UnitPrice, sm.SaleType , con.FirstName, con.LastName
			order by P.ProductName
		END

END



GO
/****** Object:  StoredProcedure [dbo].[sp_DashBoard]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DashBoard]
	@ModeType varchar(40) = null
AS
BEGIN
	if(@ModeType ='LabTest')
		begin
			Select count(pdt.TestID) TodayLabTest
			from 
				PatientDisgnosticTest  pdt
			JOIN 
				DiagnosticTest dt on dt.TestID = pdt.TestID
			where 
				convert(date,TestDate) = CONVERT(Date, GetDate())
			and 
				dt.TestType='Lab'
		End
		
	if(@ModeType = 'XRayTest')
		Begin
			Select count(pdt.TestID) TodayXRay
			FROM 
				PatientDisgnosticTest  pdt
			JOIN 
				DiagnosticTest dt on dt.TestID = pdt.TestID
			WHERE 
				convert(date,TestDate) = CONVERT(Date, GetDate())
			AND 
				dt.TestType='X-Ray'
		End
		
	if(@ModeType = 'GetAllPaymentReceivable')
		begin
			Select pdt.PatientName, pdt.ContactNo, dt.TestName, 
			CONVERT(varchar, pdt.TestDate,(101))TestDate, dt.Charges
			FROM 
				PatientDisgnosticTest  pdt
			JOIN DiagnosticTest dt on dt.TestID = pdt.TestID
			WHERE 
				pdt.Payment='Not Received'

		End
		
	if(@ModeType ='GetAllExpiryDateBeforeOneMonth')
		Begin
			Select pm.InvioceNumber, pm.DrugAgency, pm.AgencyInvoiceNo, 
			CONVERT(varchar, pm.InvoiceDate,(101))InvoiceDate, 
			p.ProductName, pd.BatchNo, CONVERT(varchar, pd.ExpiryDate,(101))ExpiryDate
			FROM 
				PurchaseMaster pm
			JOIN 
				PurchaseDetail pd ON pm.PurchaseID = pd.PurchaseID
			JOIN 
				Product p ON p.ProductID = pd.ProductID 
			WHERE 
				convert(date, pd.ExpiryDate)  >= convert(date, GETDATE())
				and 
					convert(date, pd.ExpiryDate)  <= convert(date, (DateAdd(month,1,GETDATE())))
		End
		
	if(@ModeType ='TodayTotalPurchase')
		Begin
			Select isnull(SUM(pd.Total),0) TotalPurchaseAmount 
			FROM 
				PurchaseMaster pm
			JOIN 
				PurchaseDetail pd on pm.PurchaseID = pd.PurchaseID
			WHERE 
				CONVERT(date, pm.DateEntered) = CONVERT(date, GETDATE())
		End
		
	--if(@ModeType ='TodayTotalSale')
	--	Begin
	--		SELECT isnull(SUM(sd.Total),0) TotalSale 
	--		FROM 
	--			SalesMaster sm
	--		JOIN 
	--			SalesDetail sd on sm.SaleID = sd.SaleID
	--		WHERE 
	--			CONVERT(date, sm.SaleDate) = CONVERT(date, GETDATE())
	--	End

	if(@ModeType ='TodayTotalSale')
		Begin
			SELECT --isnull(SUM(sd.Total),0) TotalSale 
			Round(isnull(SUM(sd.Quantity * sd.Price) - sum(((sd.Quantity * sd.Price) * sd.Discount) / 100), 0), 0) as TotalSale
			FROM 
			SalesMaster sm
			JOIN 
			SalesDetail sd on sm.SaleID = sd.SaleID
			WHERE 
			sm.SaleType = 'OPD' and
			CONVERT(date, sm.SaleDate) = CONVERT(date, GETDATE())
			and isnull(sm.IsDeleted,0) = 0
		End

	if(@ModeType ='TodayOPDSaleInvoice')
		Begin
			Select count(SaleID) as TotalInv from SalesMaster where SaleDate = cast(GetDate() as Date) and isnull(IsDeleted,0) = 0 and SaleType = 'OPD'
		End

END


GO
/****** Object:  StoredProcedure [dbo].[sp_Departments]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


create PROCEDURE [dbo].[sp_Departments]
	@DeptID int = null,
	@DeptName varchar(50) = null,
	@ModeType nvarchar(20) = null
AS
BEGIN
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Departments(DeptName) 
		VALUES (@DeptName)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Departments SET 
		DeptName = @DeptName
		WHERE DeptID = @DeptID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Departments 
		WHERE DeptID = @DeptID
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@DeptID > 0)
			SELECT * FROM Departments WHERE DeptID = @DeptID
		ELSE
			SELECT * FROM Departments
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@DeptID > 0)
			SELECT * FROM Departments 
			WHERE DeptName = @DeptName AND NOT(DeptID = @DeptID)
		ELSE
			SELECT * FROM Departments WHERE DeptName = @DeptName
	END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DiagnosticTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DiagnosticTest]
	@TestID int = null,
	@TestName varchar(50) = null,
	@Charges decimal(18,0) = null,
	@TestType varchar(15) = null,
	@TestGroup varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO DiagnosticTest(TestName,Charges,TestType, TestGroup) 
		VALUES (@TestName,@Charges,@TestType,@TestGroup)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE DiagnosticTest SET 
		TestName = @TestName,
		Charges = @Charges,
		TestType = @TestType,
		TestGroup = @TestGroup
		WHERE TestID = @TestID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM DiagnosticTest 
		WHERE TestID = @TestID	
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@TestID > 0)
			SELECT * FROM DiagnosticTest WHERE TestID = @TestID
	END

	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@TestID > 0)
			SELECT * FROM DiagnosticTest 
			WHERE TestName = @TestName AND NOT(TestID = @TestID)
		ELSE
			SELECT * FROM DiagnosticTest WHERE TestName = @TestName
	END
	
	IF(@ModeType = 'TESTTYPE')
	BEGIN
		SELECT * FROM DiagnosticTest WHERE TestType = @TestType
	END
	
		
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM DiagnosticTest
		WHERE 
			TestID LIKE('%'+@Search+'%') OR
			TestName LIKE('%'+@Search+'%') OR
			Charges LIKE('%'+@Search+'%') OR
			TestType LIKE('%'+@Search+'%')
	END
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DoctorFee]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_DoctorFee] 
	
	@FeeID int = null,
	@FeeTypeID int = null,
	@DoctorID int = null,
	@Fees decimal(18,0) = null,
	@IsActive bit = null,
	@ModeType varchar(50) = null
	
AS
BEGIN
	
	if(@ModeType ='INSERT')
		Begin
			INSERT INTO DoctorFee(FeeTypeID, DoctorID, Fees, IsActive)
			VALUES (@FeeTypeID, @DoctorID, @Fees, @IsActive)
		End
	
	if(@ModeType ='UPDATE')
		Begin
			UPDATE DoctorFee set
			FeeTypeID = @FeeTypeID
			,DoctorID = @DoctorID
			,Fees = @Fees
			,IsActive = @IsActive
			WHERE FeeID = @FeeID
		End
		
	if(@ModeType = 'DELETE')
		Begin
			DELETE FROM DoctorFee WHERE FeeID = @FeeID
		End
	
	if(@ModeType = 'GETDATA')
		if(@FeeID > 0)
			Begin
				SELECT * FROM DoctorFee WHERE FeeID = @FeeID
			end
		else
			Begin
				SELECT df.FeeID, df.Fees, df.IsActive, ft.FeeType, ft.FeeTypeID, df.DoctorID,
				(c.FirstName+' '+c.LastName) as DoctorName
				FROM DoctorFee df 
				JOIN FeesType ft ON df.FeeTypeID = ft.FeeTypeID
				JOIN Contact c ON df.DoctorID = c.ContactID
			End
	
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_DoctorTiming]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_DoctorTiming] 
	@ID int = null,
	@DoctorID int = null,
	@DoctorTime varchar(100) = null,
	@Days varchar(100) = null,
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO DoctorTiming(DoctorID, DoctorTime, Days) 
		VALUES (@DoctorID, @DoctorTime, @Days)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE DoctorTiming SET 
		DoctorID = @DoctorID,
		DoctorTime = @DoctorTime,
		Days = @Days
		WHERE ID = @ID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM DoctorTiming 
		WHERE ID = @ID	
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@ID > 0)
			SELECT dt.*, (c.FirstName+ ' ' +c.LastName) as DoctorName FROM DoctorTiming dt
			JOIN Contact C on c.ContactID = dt.DoctorID
			WHERE dt.ID = @ID
		ELSE
			SELECT dt.*, (c.FirstName+ ' ' +c.LastName) as DoctorName FROM DoctorTiming dt
			JOIN Contact C on c.ContactID = dt.DoctorID
	END
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_EmployeeWages]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_EmployeeWages]
	@WagesID	int = null,
	@ContactID	int = null,
	@PaymentType	varchar(50) = null,
	@SalaryAmount decimal(18,0) = null,
	@LoanAmount		decimal(18,0) = null,
	@SalaryDate datetime = null,
	@Remarks	varchar(200) = null,
	@EnteredBy varchar(50) = null,
	@ModeType	varchar(50) = null
AS
BEGIN
	
	if(@ModeType = 'INSERT')
		Begin
			Insert into EmployeeWages(ContactID, PaymentType, SalaryAmount, LoanAmount, SalaryDate,
						Remarks, EnteredBy)
			Values(@ContactID, @PaymentType, @SalaryAmount, @LoanAmount, @SalaryDate,
						@Remarks, @EnteredBy)
		End
	
	if(@ModeType = 'UPDATE')
		Begin
			UPDATE EmployeeWages SET
			ContactID = @ContactID
			,PaymentType = @PaymentType
			,SalaryAmount = @SalaryAmount
			,LoanAmount = @LoanAmount
			,SalaryDate = @SalaryDate
			,Remarks = @Remarks
			,UpdatedBy = @EnteredBy
			,UpdatedDate = GETDATE()
			where WagesID = @WagesID
			
		END
		
	If(@ModeType = 'DELETE')
		BEGIN
			UPDATE EmployeeWages SET DeletedBy = @EnteredBy, DeletedDate = GETDATE(), IsDeleted = 1 WHERE WagesID = @WagesID
		END
	
	if(@ModeType = 'GETDATABYID')
		Begin		
			SELECT * FROM EMPLOYEEWAGES WHERE WagesID = @WagesID
		End
		
	if(@ModeType = 'GETALLDATA')
		Begin		
			SELECT ew.WagesID, ew.ContactID, ct.ContactType, (c.FirstName+' '+ c.LastName) as EmployeeName,
			ew.PaymentType, ew.SalaryAmount, ew.LoanAmount, convert(varchar,ew.SalaryDate,(101))as SalaryDate,
			ew.Remarks, ew.EnteredBy 
			FROM Contact c
			JOIN EmployeeWages ew ON c.ContactID = ew.ContactID 
			JOIN ContactType ct ON c.ContactTypeID = ct.ContactTypeID
			where ew.IsDeleted = 0
			order by ew.WagesID
		End
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ErrorLog]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ErrorLog]
	@ErrorID int,
	@ErrorDesc nvarchar(4000)
AS
BEGIN
	INSERT INTO ErrorLog(ErrorDesc) values(@ErrorDesc)
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Expenses]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_Expenses]
	@ExpenseID int = null,
	@ExpensesTypeID int = null,
	@ExpenseDate datetime = null,
	@Amount decimal(18,0) = null,
	@GivenBy varchar(50) = null,
	@GivenTo varchar(50) = null,
	@Remarks varchar(500) = null,
	@EnteredBy varchar(50) = null,
	@EnteredDate datetime = null,
	@UpdatedBy varchar(50) = null,
	@UpdatedDate datetime = null,
	@DeletedBy varchar(50) = null,
	@DeletedDate datetime = null,
	@IsDeleted bit = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Expenses(ExpensesTypeID, ExpenseDate, Amount, GivenBy, GivenTo, Remarks, EnteredBy,
		EnteredDate, UpdatedBy, UpdatedDate, DeletedBy, DeletedDate, IsDeleted)
		VALUES (@ExpensesTypeID, @ExpenseDate, @Amount, @GivenBy, @GivenTo, @Remarks, @EnteredBy,
		@EnteredDate, @UpdatedBy, @UpdatedDate, @DeletedBy, @DeletedDate, @IsDeleted)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Expenses SET
		ExpensesTypeID = @ExpensesTypeID,
		ExpenseDate = @ExpenseDate,
		Amount = @Amount,
		GivenBy = @GivenBy,
		GivenTo = @GivenTo,
		Remarks = @Remarks,
		EnteredBy = @EnteredBy,
		EnteredDate = @EnteredDate,
		UpdatedBy = @UpdatedBy,
		UpdatedDate = @UpdatedDate,
		DeletedBy = @DeletedBy,
		DeletedDate = @DeletedDate,
		IsDeleted = @IsDeleted
		WHERE ExpenseID = @ExpenseID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Expenses WHERE ExpenseID = @ExpenseID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@ExpenseID > 0)
			SELECT e.ExpenseID, et.ExpensesTypeID, et.ExpensesType, e.ExpenseDate, e.Amount, e.GivenBy, e.GivenTo,e.Remarks,
			e.EnteredBy, e.EnteredDate,e.UpdatedBy, e.UpdatedDate, e.DeletedBy, e.DeletedDate, e.IsDeleted
			FROM Expenses e 
			JOIN ExpensesType et ON et.ExpensesTypeID = e.ExpensesTypeID
			WHERE ExpenseID = @ExpenseID
	END
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT e.ExpenseID, et.ExpensesTypeID, et.ExpensesType, e.ExpenseDate, e.Amount, e.GivenBy, e.GivenTo,e.Remarks,
		e.EnteredBy, e.EnteredDate,e.UpdatedBy, e.UpdatedDate, e.DeletedBy, e.DeletedDate, e.IsDeleted
		FROM Expenses e 
		JOIN ExpensesType et ON et.ExpensesTypeID = e.ExpensesTypeID
		WHERE
		et.ExpensesType LIKE('%'+@Search+'%') OR
		e.ExpenseDate LIKE('%'+@Search+'%') OR
		e.Amount LIKE('%'+@Search+'%') OR
		e.GivenBy LIKE('%'+@Search+'%') OR
		e.GivenTo LIKE('%'+@Search+'%') OR
		e.Remarks LIKE('%'+@Search+'%') OR
		e.EnteredBy LIKE('%'+@Search+'%') OR
		e.EnteredDate LIKE('%'+@Search+'%') OR
		e.UpdatedBy LIKE('%'+@Search+'%') OR
		e.UpdatedDate LIKE('%'+@Search+'%') OR
		e.DeletedBy LIKE('%'+@Search+'%') OR
		e.DeletedDate LIKE('%'+@Search+'%') OR
		e.IsDeleted LIKE('%'+@Search+'%')
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ExpensesType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ExpensesType]
	@ExpensesTypeID int = null,
	@ExpensesType varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO ExpensesType(ExpensesType) 
		VALUES (@ExpensesType)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE ExpensesType SET 
		ExpensesType = @ExpensesType
		WHERE ExpensesTypeID = @ExpensesTypeID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM ExpensesType 
		WHERE ExpensesTypeID = @ExpensesTypeID	
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@ExpensesTypeID > 0)
			SELECT * FROM ExpensesType WHERE ExpensesTypeID = @ExpensesTypeID
	END
	
	IF(@ModeType = 'GETALL')
	BEGIN		
		SELECT * FROM ExpensesType
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@ExpensesTypeID > 0)
			SELECT * FROM ExpensesType 
			WHERE ExpensesType = @ExpensesType AND NOT(ExpensesTypeID = @ExpensesTypeID)
		ELSE
			SELECT * FROM ExpensesType WHERE ExpensesType = @ExpensesType
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM ExpensesType
		WHERE 
			ExpensesType LIKE('%'+@Search+'%')
	END
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_FeeType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_FeeType]
	
	@FeeTypeID int = null,
	@FeeType varchar(50) = null,
	@ModeType varchar(50) = null
	
AS
BEGIN
	
	if(@ModeType ='INSERT')
		Begin
			INSERT INTO FeesType(FeeType) VALUES (@FeeType)
		End
	
	if(@ModeType ='UPDATE')
		Begin
			UPDATE FeesType set FeeType = @FeeType WHERE FeeTypeID = @FeeTypeID
		End
		
	if(@ModeType = 'DELETE')
		Begin
			DELETE FROM FeesType WHERE FeeTypeID = @FeeTypeID
		End
	
	if(@ModeType = 'GETDATA')
		if(@FeeTypeID > 0)
			Begin
				SELECT * FROM FeesType WHERE FeeTypeID = @FeeTypeID
			end
		else
			Begin
				SELECT * FROM FeesType 
			End
	
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_IndoorPatientInvestigationTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-------------------

CREATE PROCEDURE [dbo].[sp_IndoorPatientInvestigationTest]
	
AS
BEGIN
		Select 
			p.PatientName, p.PatientRegNo, p.DoctorName, p.MobileNo, 
			p.Diagnosis, p.Gender, p.Age,
			dt.TestName, dt.TestType, pdt.TestDate, pdt.DeliveryDate, pdt.Pathologist, pdt.Technologist,
			dt.Charges
		from 
			IndoorPatients p 
		JOIN 
			PatientDisgnosticTest pdt ON p.PatientID = pdt.PatientID
		JOIN 
			DiagnosticTest dt ON pdt.TestID = dt.TestID

		
END



GO
/****** Object:  StoredProcedure [dbo].[sp_IndoorPatientInvestigationTestReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------

CREATE PROCEDURE [dbo].[sp_IndoorPatientInvestigationTestReport]
	-- Add the parameters for the stored procedure here	
	@PatientID int = null
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select 
						p.PatientName, p.PatientRegNo, p.DoctorName, p.MobileNo, 
						p.Diagnosis, p.Gender, p.Age,
						dt.TestName, dt.TestType, pdt.TestDate, pdt.DeliveryDate, 
						pdt.Pathologist, pdt.Technologist,
						dt.Charges
					from 
						IndoorPatients p 
					JOIN 
						PatientDisgnosticTest pdt ON p.PatientID = pdt.PatientID
					JOIN 
						DiagnosticTest dt ON pdt.TestID = dt.TestID '
		
	
	if(@PatientID > 0) 
		SET @SQLQuery = @SQLQuery + ' where p.PatientID = @PatientID '
	
	
	Set @ParamDefinition =      ' @PatientID int'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @PatientID
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END



GO
/****** Object:  StoredProcedure [dbo].[sp_IndoorPatientMedicine]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_IndoorPatientMedicine]
	
AS
BEGIN
		SELECT 
			idp.PatientName, idp.PatientRegNo, idp.DoctorName, idp.MobileNo, idp.Diagnosis, idp.Gender, idp.Age,
			sm.SaleInvoiceNumber, sm.SaleDate,
			p.ProductName, p.ProductType, sd.Quantity, sd.Price, (sd.Quantity*sd.Price)as Total, sd.Discount
		FROM 
			IndoorPatients idp 
		JOIN 
			SalesMaster sm ON idp.PatientID = sm.PatientID
		JOIN 
			SalesDetail sd ON sm.SaleID = sd.SaleID
		JOIN 
			Products p ON sd.ProductID = p.ProductID
		
END



GO
/****** Object:  StoredProcedure [dbo].[sp_IndoorPatientMedicineReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_IndoorPatientMedicineReport]
	-- Add the parameters for the stored procedure here	
	@PatientID int = null
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select idp.PatientName, idp.PatientRegNo, idp.DoctorName, idp.MobileNo, idp.Diagnosis,
					idp.Gender, idp.Age,  
					sm.SaleInvoiceNumber, Convert(varchar,sm.SaleDate,(101))as SaleDate,
					p.ProductName, p.ProductType, sd.Quantity, sd.Price, (sd.Quantity*sd.Price)as Total, sd.Discount
					from IndoorPatients idp 
					JOIN SalesMaster sm ON idp.PatientID = sm.PatientID
					JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
					JOIN Products p ON sd.ProductID = p.ProductID '
		
	
	if(@PatientID > 0) 
		SET @SQLQuery = @SQLQuery + ' where idp.PatientID = @PatientID '
	
	
	Set @ParamDefinition =      ' @PatientID int'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @PatientID
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_IndoorPatientSummary]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_IndoorPatientSummary]
	
AS
BEGIN
	
	Select 
		p.DoctorName, p.PatientName, p.PatientRegNo, 
		convert(varchar, p.AdmissionDate, (101))as AdmissionDate, 
		convert(varchar, p.DischargeDate, (101))as DischargeDate,  
		p.Diagnosis, p.SecondaryDiagnosis,
		bo.PharmacyBill, bo.RoomBill, bo.InvestigationTestBill, bo.SurgeryAmount,
		bo.BillingAmount, bo.Discount, bo.DepositeAmount, bo.BalanceOwing
	from 
		IndoorPatients p
	JOIN 
		BalanceOwing bo ON p.PatientID = bo.PatientID

	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_IndoorPatientSummaryReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_IndoorPatientSummaryReport]
	-- Add the parameters for the stored procedure here	
	@DoctorID int = null,
	@FromDate date = null,
	@ToDate date = null	
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select p.DoctorName, p.PatientName, p.PatientRegNo, 
						convert(varchar, p.AdmissionDate, (101))as AdmissionDate, 
						convert(varchar, p.DischargeDate, (101))as DischargeDate,
						p.Diagnosis, p.SecondaryDiagnosis,
						Round(bo.PharmacyBill,0)as PharmacyBill, bo.RoomBill, bo.InvestigationTestBill, bo.SurgeryAmount,
						bo.BillingAmount, bo.Discount, bo.DepositeAmount, Round(bo.BalanceOwing,0)as BalanceOwing
						from IndoorPatients p
						JOIN BalanceOwing bo ON p.PatientID = bo.PatientID '
		
	
	if((@DoctorID > 0) and (@FromDate is not null))
		SET @SQLQuery = @SQLQuery + ' where p.DoctorID = @DoctorID and CAST(p.AdmissionDate as DATE) between @FromDate and @ToDate '
	
	if((@DoctorID = 0) and (@FromDate is not null))
		SET @SQLQuery = @SQLQuery + ' where CAST(p.AdmissionDate as DATE) between @FromDate and @ToDate '
	

	SET @SQLQuery = @SQLQuery + ' order by p.DischargeDate '
	
	
	Set @ParamDefinition =      ' @DoctorID int,
                @FromDate DateTime,
                @ToDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @FromDate, 
                @ToDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_InvoiceDetail]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[sp_InvoiceDetail]
	@InvoiceDetailID int = null,
	@InvoiceID int = null,
	@TestID int = null,
	@DoctorFeeID int = null,
	@ModeType nvarchar(20) = null
AS
BEGIN
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO InvoiceDetail(InvoiceID, TestID, DoctorFeeID)
		VALUES (@InvoiceID, @TestID, @DoctorFeeID)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN 
		UPDATE InvoiceDetail SET 
		InvoiceID = @InvoiceID,
		TestID = @TestID,
		DoctorFeeID = @DoctorFeeID 
		WHERE
			InvoiceDetailID = @InvoiceDetailID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM InvoiceDetail  
		WHERE InvoiceDetailID = @InvoiceDetailID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@InvoiceID > 0)
			select * from InvoiceDetail invD
			join DiagnosticTest dt on dt.TestID = invD.TestID
			join DoctorFee df on df.FeeID = invD.DoctorFeeID
			join FeesType ft on ft.FeeTypeID = df.FeeTypeID
			where invD.InvoiceDetailID = @InvoiceDetailID
		ELSE
			select * from InvoiceDetail invD
			join DiagnosticTest dt on dt.TestID = invD.TestID
			join DoctorFee df on df.FeeID = invD.DoctorFeeID
			join FeesType ft on ft.FeeTypeID = df.FeeTypeID 
			
	END
		
END



GO
/****** Object:  StoredProcedure [dbo].[sp_InvoiceMaster]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_InvoiceMaster]
	@InvoiceID int = null,
	@PatientID int = null,
	@DoctorID int = null,
	@InvoiceNumber varchar(50) = null,
	@PatientName varchar(50) = null,
	@ContactNo varchar(50) = null,
	@InvoiceType varchar(50) = null,
	@DepositeAmount decimal = null,
	@Discount decimal = null,
	@InvoiceDate datetime = null,
	@InvoiceStatus varchar(50) = null,
	@ModeType nvarchar(20) = null
AS
BEGIN
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO InvoiceMaster(PatientID, DoctorID, InvoiceNumber, PatientName, 
		ContactNo, InvoiceType, DepositeAmount, Discount, InvoiceDate, InvoiceStatus)
		VALUES (@PatientID, @DoctorID, @InvoiceNumber, @PatientName, 
		@ContactNo, @InvoiceType, @DepositeAmount, @Discount, @InvoiceDate, @InvoiceStatus)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN 
		UPDATE InvoiceMaster SET 
		PatientID = @PatientID,
		DoctorID = @DoctorID,
		InvoiceNumber = @InvoiceNumber,
		PatientName = @PatientName,
		ContactNo = @ContactNo,
		InvoiceType = @InvoiceType,
		DepositeAmount = @DepositeAmount,
		Discount = @Discount,
		InvoiceDate = @InvoiceDate,
		InvoiceStatus = @InvoiceStatus 
		WHERE
			InvoiceID = @InvoiceID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM InvoiceMaster  
		WHERE InvoiceID = @InvoiceID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@InvoiceID > 0)
			select * from InvoiceMaster
			where InvoiceID = @InvoiceID
		ELSE
			select * from InvoiceMaster 
			
	END
		
END



GO
/****** Object:  StoredProcedure [dbo].[sp_LabAsset]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_LabAsset]
	@AssetID	int	= null,
	@AssetTypeID	int				= null,
	@Quantity		int				= null,
	@Price			decimal(18,2)	= null,
	@CompanyName	varchar(500)	= null,
	@InvoiceNo		varchar(50)		= null,
	@InvoiceDate	date			= null,
	@EnteredDate	date			= null,
	@EnteredBy		varchar(20)		= null,
	@ModeType		varchar(50)		= null
AS
BEGIN
	if(@ModeType = 'INSERT')
		BEGIN
			INSERT INTO LabAsset(AssetTypeID, Quantity, Price, CompanyName, InvoiceNo, InvoiceDate, EnteredDate, EnteredBy, IsDeleted) 
			VALUES(@AssetTypeID, @Quantity, @Price, @CompanyName, @InvoiceNo, @InvoiceDate, GETDATE(), @EnteredBy, 0)
			
			exec sp_LabAssetInventory @AssetTypeID, @Quantity, 0, @Quantity, 'StockIn'
			
		END
	
	if(@ModeType = 'UPDATE')
	BEGIN
		UPDATE LabAsset SET
		CompanyName = @CompanyName,
		InvoiceNo = @InvoiceNo,
		AssetTypeID = @AssetTypeID,
		Quantity = @Quantity, 
		Price = @Price,
		InvoiceDate = @InvoiceDate		 
		WHERE AssetID = @AssetID
		
	END	
		
		
	if(@ModeType = 'DELETE')
	BEGIN
		UPDATE LabAsset SET
		IsDeleted = 1,
		DeletedDate = GETDATE()
		WHERE AssetID = @AssetID
		
	END	
		
	IF(@ModeType = 'GetByID')
		BEGIN
			IF(@AssetID > 0)
				SELECT * FROM LabAsset  la
				join LabAssetType lat on lat.AssetTypeID = la.AssetTypeID
				WHERE la.AssetID = @AssetID and la.IsDeleted = 0
		END

		if(@ModeType = 'GetAll')
			begin
				SELECT AssetID, la.CompanyName, la.InvoiceNo, CONVERT(varchar, la.InvoiceDate, (101)) as InvoiceDate, 
				la.Price, la.Quantity,
				lat.AssetName, lat.AssetSize, lat.AssetType 
				FROM LabAsset la
				join LabAssetType lat on lat.AssetTypeID = la.AssetTypeID
				WHERE la.IsDeleted = 0
			end

END




GO
/****** Object:  StoredProcedure [dbo].[sp_LabAssetInventory]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_LabAssetInventory]
	@AssetTypeID		int = null,
	@StockIn		int = null,
	@StockOut		int = null,
	@StockQty		int = null,	
	@ModeType		varchar(50) = null
AS
BEGIN
	BEGIN
	declare @Qty int = 0;
	
	Select @Qty = StockQty from LabAssetInventory where AssetTypeID = @AssetTypeID
	IF(@Qty > 0)
	BEGIN
		if(@ModeType = 'StockIn')
			update LabAssetInventory set StockQty = (@Qty + @StockQty) where AssetTypeID = @AssetTypeID
		
		if(@ModeType = 'StockOut')
			update LabAssetInventory set StockQty = (@Qty + @StockQty) where AssetTypeID = @AssetTypeID
	END
	ELSE
		INSERT INTO LabAssetInventory (AssetTypeID, StockIn, StockOut, StockQty) VALUES (@AssetTypeID, @StockIn, @StockOut, @StockQty)
END

END




GO
/****** Object:  StoredProcedure [dbo].[sp_LabAssetType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


 
CREATE PROCEDURE [dbo].[sp_LabAssetType]
	@AssetTypeID int = null,
	@AssetType	varchar(50) = null,
	@AssetName	varchar(50) = null,
	@AssetSize	varchar(50) = null,
	@ModeType	varchar(50) = null
AS
BEGIN
	if(@ModeType = 'INSERT')
		INSERT INTO LabAssetType(AssetType, AssetName,AssetSize) VALUES(@AssetType, @AssetName, @AssetSize)	
		
	IF(@ModeType = 'UPDATE')
		UPDATE LabAssetType SET AssetType = @AssetType, AssetName = @AssetName,
		AssetSize = @AssetSize WHERE AssetTypeID = @AssetTypeID
	
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@AssetTypeID > 0)
			SELECT * FROM LabAssetType 
			WHERE AssetType = @AssetType and AssetName = @AssetName and AssetSize = @AssetSize 
			AND NOT(AssetTypeID = @AssetTypeID)
		ELSE
			SELECT * FROM LabAssetType WHERE AssetType = @AssetType and
			AssetName = @AssetName and AssetSize = @AssetSize			
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		IF(@AssetTypeID > 0)
			DELETE FROM LabAssetType WHERE AssetTypeID = @AssetTypeID
	END
	
	IF(@ModeType = 'GET')
		IF(@AssetTypeID > 0)
			SELECT * FROM LabAssetType WHERE AssetTypeID = @AssetTypeID
		ELSE
			SELECT * FROM LabAssetType
			
END




GO
/****** Object:  StoredProcedure [dbo].[sp_MonthlyExpensesReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
create PROCEDURE [dbo].[sp_MonthlyExpensesReport]
	@FromDate date = null,
	@ToDate date = null
AS
	BEGIN
			SELECT 
				et.ExpensesTypeID, et.ExpensesType,
				e.ExpenseID, CONVERT(varchar, e.ExpenseDate,(101))as ExpenseDate, 
				e.Amount, e.GivenBy, e.GivenTo,
				e.Remarks, isnull(e.EnteredBy,'') as EnteredBy
			FROM 
				Expenses e
			JOIN 
				ExpensesType et ON et.ExpensesTypeID = e.ExpensesTypeID
			WHERE 
				e.ExpenseDate Between @FromDate and @ToDate
		
	
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_MonthlySaleReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_MonthlySaleReport]
	@FromDate	date = null,
	@DoctorID	int = null,
	@ToDate		date = null
AS
	BEGIN

	if(@DoctorID = 0)
		begin
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, sm.Diagnostics, sm.Remarks,		
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, sd.DiscountAmount, sd.Total,
			(sd.Total-sd.DiscountAmount)NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM 
				SalesMaster sm
			JOIN 
				SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN 
				Product p ON p.ProductID = sd.ProductID
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID 
			JOIN 
				ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN 
				Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE 
				SaleDate between  @FromDate and @ToDate
			
		end
		
	if(@DoctorID > 0)
		begin
			Select sm.SaleID, sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101))as SaleDate, 
			sm.SaleType, sm.PatientName, sm.ContactNo, sm.GuardianName, sm.GuardianContactNo, 
			sm.RoomNo, sm.Diagnostics, sm.Remarks,		
			Replace(Replace(LTRIM(RIGHT(CONVERT(VARCHAR(20), sm.DateEntered, 100), 7)),'PM',' PM'),'AM',' AM')as DateEntered,
			sm.EnteredBy ,
			sd.SaleDetailID, sd.Quantity, sd.Price, sd.Discount, sd.DiscountAmount, sd.Total,
			(sd.Total-sd.DiscountAmount)NetAmount,
			P.ProductID, (P.ProductName+' '+s.Strength)ProductName,  pt.ProductType,
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM 
				SalesMaster sm
			JOIN 
				SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN 
				Product p ON p.ProductID = sd.ProductID
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID 
			JOIN 
				ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN 
				Company c ON c.CompanyID = p.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE 
				SaleDate between  @FromDate and @ToDate
			and sm.DoctorID = @DoctorID 
			
		end
	
	END


GO
/****** Object:  StoredProcedure [dbo].[sp_MonthlySaleSummaryReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_MonthlySaleSummaryReport]
	@DoctorID	 int = null,
	@FromDate	date = null,
	@ToDate		date = null
AS
	BEGIN

	if(@DoctorID = 0)
		Begin
			Select P.ProductID, P.ProductName,  p.ProductType,
			sum(sd.Quantity) as Quantity, sd.Price, sum(sd.DiscountAmount) as DiscountAmount, 
			sum(sd.Total) as Total,
			sum(sd.Total-sd.DiscountAmount)NetAmount,		
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM 
				SalesMaster sm
			JOIN 
				SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN 
				Products p ON p.ProductID = sd.ProductID		
			JOIN 
				Company c ON c.CompanyID = sd.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE 
				SaleDate between  @FromDate and @ToDate
			
			group by P.ProductID, P.ProductName,  p.ProductType,sd.Price, c.Company, con.FirstName, con.LastName
			order by c.Company, P.ProductName
		end

	if(@DoctorID > 0)
		Begin
			Select P.ProductID, P.ProductName,  p.ProductType,
			sum(sd.Quantity) as Quantity, sd.Price, sum(sd.DiscountAmount) as DiscountAmount, 
			sum(sd.Total) as Total,
			sum(sd.Total-sd.DiscountAmount)NetAmount,		
			c.Company,
			(con.FirstName +' '+con.LastName) as DoctorName
			FROM 
				SalesMaster sm
			JOIN 
				SalesDetail sd ON sm.SaleID = sd.SaleID
			JOIN 
				Products p ON p.ProductID = sd.ProductID		
			JOIN 
				Company c ON c.CompanyID = sd.CompanyID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE 
				SaleDate between  @FromDate and @ToDate
			and sm.DoctorID = @DoctorID
			group by P.ProductID, P.ProductName,  p.ProductType,sd.Price, c.Company, con.FirstName, con.LastName
			order by c.Company, P.ProductName
		end
	
	END
GO
/****** Object:  StoredProcedure [dbo].[sp_OpeningStock]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_OpeningStock]
 @OpningStockID int = null,
 @ProductID int = null,
 @Quantity int = null,
 @Search nvarchar(100) = '',
 @ModeType nvarchar(20) = null
AS
BEGIN
 IF(@ModeType = 'INSERT')
 BEGIN
  INSERT INTO OpeningStock(ProductID, Quantity)
  VALUES (@ProductID, @Quantity)
 END
 
 IF(@ModeType = 'UPDATE')
 BEGIN
  UPDATE OpeningStock SET
  ProductID = @ProductID,
  Quantity = @Quantity
  WHERE
   OpningStockID = @OpningStockID
 END
 
 IF(@ModeType = 'DELETE')
 BEGIN
  DELETE FROM OpeningStock WHERE OpningStockID = @OpningStockID
 END
 
 IF(@ModeType = 'GET')
 BEGIN
  IF(@OpningStockID > 0)
  SELECT opS.OpningStockID, c.Company, p.ProductName,pt.ProductType,s.Strength, opS.Quantity,
  opS.ProductID
  FROM OpeningStock opS 
  LEFT JOIN Product p ON p.ProductID = opS.ProductID
  LEFT JOIN Company c ON c.CompanyID = p.CompanyID
  LEFT JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
  LEFT JOIN Strength s ON s.StrengthID = p.StrengthID
  WHERE opS.OpningStockID = @OpningStockID
 END
 IF(@ModeType = 'SEARCH')
 BEGIN
  SELECT opS.OpningStockID, c.Company, p.ProductName,pt.ProductType,s.Strength, opS.Quantity,opS.ProductID
  FROM OpeningStock opS 
  LEFT JOIN Product p ON p.ProductID = opS.ProductID
  LEFT JOIN Company c ON c.CompanyID = p.CompanyID
  LEFT JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
  LEFT JOIN Strength s ON s.StrengthID = p.StrengthID
  WHERE
  c.Company LIKE('%'+@Search+'%') OR
  p.ProductName LIKE('%'+@Search+'%') OR
  pt.ProductType LIKE('%'+@Search+'%') OR
  s.Strength LIKE('%'+@Search+'%') OR
  opS.Quantity LIKE('%'+@Search+'%')
 END
  
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Organization]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_Organization]
	@OrganizationID int = null,
	@OrgName varchar(100) = null,
	@OrgAddress varchar(300) = null,
	@OrgContactNo	varchar(30) = null,
	@OrgEmail	varchar(50) = null,
	@ContactPerson	varchar(100) = null,
	@IsActive	bit = null,
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Organization(OrgName,OrgAddress,OrgContactNo,OrgEmail,ContactPerson,IsActive) 
		VALUES (@OrgName,@OrgAddress,@OrgContactNo,@OrgEmail,@ContactPerson,1) 
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Organization SET
		OrgName = @OrgName,
		OrgAddress = @OrgAddress,
		OrgContactNo = @OrgContactNo,
		OrgEmail = @OrgEmail,
		ContactPerson = @OrgEmail
		WHERE OrganizationID = @OrganizationID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		Update Organization set IsActive = '0'
		WHERE OrganizationID = @OrganizationID 
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@OrganizationID > 0)
			SELECT * FROM Organization WHERE OrganizationID = @OrganizationID and IsActive = 1
		ELSE
			SELECT * FROM Organization where IsActive = 1
	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_OutDoorPatientTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_OutDoorPatientTest]
	@OutDoorTestID int = null,
	@TestNo varchar(50) = null,
	@TestDate datetime = null,
	@PatientName varchar(50) = null,
	@DoctorID int = null,
	@DoctorName varchar(50) = null,
	@ContactNo varchar(50) = null,
	@Age int = null,
	@Sex varchar(10) = null,
	@TestID int = null,
	@Discount decimal = null,
	@ModeType nvarchar(100) = null
AS
BEGIN
	IF(@ModeType = 'INSERT')
	BEGIN 
		INSERT INTO OutDoorPatientTest(TestNo, TestDate, PatientName, DoctorID, DoctorName,
		ContactNo, Age, Sex, TestID, Discount)
		VALUES(@TestNo, @TestDate, @PatientName, @DoctorID, @DoctorName, @ContactNo, @Age, @Sex, 
		@TestID, @Discount)  
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE OutDoorPatientTest SET 
		TestNo = @TestNo,
		TestDate = @TestDate,
		PatientName = @PatientName,
		DoctorID = @DoctorID,
		DoctorName = @DoctorName,
		ContactNo = @ContactNo,
		Age = @Age,
		Sex = @Sex,
		TestID = @TestID,
		Discount = @Discount 
		WHERE OutDoorTestID = @OutDoorTestID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM OutDoorPatientTest 
		WHERE OutDoorTestID = @OutDoorTestID 
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@OutDoorTestID > 0)
			SELECT o.OutDoorTestID, o.TestNo, o.TestDate, o.PatientName, o.DoctorID,
			o.ContactNo, o.Age, o.Sex, o.TestID, dt.TestName, o.Discount, dt.Charges, dt.TestType,
			(ISNULL((select top 1 c.FirstName +' '+c.LastName from Contact c where c.ContactID = o.DoctorID),'')+
			isnull(o.DoctorName,'')) as DoctorName
			FROM OutDoorPatientTest o
			join DiagnosticTest dt on dt.TestID = o.TestID
			WHERE OutDoorTestID = @OutDoorTestID 
		ELSE
			SELECT o.OutDoorTestID, o.TestNo, o.TestDate, o.PatientName, o.DoctorID,
			o.ContactNo, o.Age, o.Sex, o.TestID, dt.TestName, o.Discount, dt.Charges, dt.TestType,
			(ISNULL((select top 1 c.FirstName +' '+c.LastName from Contact c where c.ContactID = o.DoctorID),'')+
			isnull(o.DoctorName,'')) as DoctorName
			FROM OutDoorPatientTest o
			join DiagnosticTest dt on dt.TestID = o.TestID
			where CAST(o.TestDate as DATE) = CAST(getdate() as DATE)
			order by o.OutDoorTestID desc
	END
	
	If(@ModeType ='InvestigationTestNumber')
		Begin
			select [dbo].[UDF_GEN_OutDoorPatientInvestigationTest](@TestID) as InvestigationTestNumber
		End
		
	If(@ModeType ='GetMaxID')
		Begin
			Select MAX(OutDoorTestID)as OutDoorTestID from OutDoorPatientTest
		End
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_OutDoorPatientTestToken]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_OutDoorPatientTestToken]
	
AS
BEGIN
	SELECT 
		opt.OutDoorTestID, opt.TestNo, CONVERT(varchar, opt.TestDate,(101))as TestDate,
		convert(Char(5), opt.TestDate, (108))as TestTime,
		case when IsNull(opt.DoctorName,'') = '' then (c.FirstName+' '+c.LastName) else opt.DoctorName end as DoctorName,
		opt.PatientName, ISNULL(opt.ContactNo,'')as ContactNo, ISNULL(opt.Age,'')as PatientAge,
		opt.Sex, 
		dt.TestName, dt.Charges, opt.Discount, (dt.Charges - opt.Discount) as TotalCharges
	FROM 
		OutDoorPatientTest opt 
	JOIN 
		DiagnosticTest dt ON opt.TestID = dt.TestID
	LEFT JOIN 
		Contact c ON opt.DoctorID = c.ContactID
END


GO
/****** Object:  StoredProcedure [dbo].[sp_OutDoorPatientTestTokenReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-----------------------------------------------

CREATE PROCEDURE [dbo].[sp_OutDoorPatientTestTokenReport]
	-- Add the parameters for the stored procedure here		
	@OutDoorTestID int = null,
	@DoctorID int = null,
	@TestID int = null,
	@FromDate date = null,
	@ToDate date = null,
	@TodayTest date = null	
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'SELECT 
		opt.OutDoorTestID, opt.TestNo, CONVERT(varchar, opt.TestDate,(101))as TestDate,
		convert(Char(5), opt.TestDate, (108))as TestTime,
		case when IsNull(opt.DoctorName,'''') = '''' then (c.FirstName+'' ''+c.LastName) else opt.DoctorName end as DoctorName,
		opt.PatientName, ISNULL(opt.ContactNo,'''')as ContactNo, ISNULL(opt.Age,'''')as PatientAge,
		opt.Sex, 
		dt.TestName, dt.Charges, opt.Discount, (dt.Charges - opt.Discount) as TotalCharges
	FROM 
		OutDoorPatientTest opt 
	JOIN 
		DiagnosticTest dt ON opt.TestID = dt.TestID
	LEFT JOIN 
		Contact c ON opt.DoctorID = c.ContactID '
		
	if (@OutDoorTestID IS NOT NULL)
		SET @SQLQuery = @SQLQuery + ' Where opt.OutDoorTestID = @OutDoorTestID '
	
	if((@DoctorID is not null) and (@FromDate is not null))
		SET @SQLQuery = @SQLQuery + ' Where opt.DoctorID and opt.TestDate Between @FromDate and @ToDate '
	
	if((@TodayTest is not null))
		SET @SQLQuery = @SQLQuery + ' Where cast(opt.TestDate as DATE)= Cast(GETDATE() as DATE) '
	
	
	--SET @SQLQuery = @SQLQuery + ' group by  sm.SaleID, sm.SaleInvoiceNumber, sm.SaleDate, c.CityName, ms.StoreName, cc.FirstName,cc.LastName, sd.Discount ' 
	
	SET @SQLQuery = @SQLQuery + ' order by opt.TestNo '
	
	
	Set @ParamDefinition =      ' @OutDoorTestID int,                
                @DoctorID int,
                @TestID int,
                @FromDate DateTime,
                @ToDate DateTime,
                @TodayTest DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @OutDoorTestID,                
                @DoctorID, 
                @TestID,
                @FromDate, 
                @ToDate,
                @TodayTest
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_PatientBilling]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PatientBilling]
	@PatientID int
AS
BEGIN
	Declare @PharmacyBill decimal(18,2)
	Declare @TotalRoomCharges decimal(18,2)
	Declare @InvestigationTestBill decimal(18,2)
	Declare @OtherBill decimal(18,2)
	Declare @DepositeAmount decimal(18,2)
	Declare @RoomCharges decimal(18,2)
	Declare @TotalAdmitDays int
	Declare @DiscountAmount decimal(18,2)
	Declare @SurgeryAmount decimal(18,2)
	Declare @TemporaryAdmit decimal(18,2)
	
	
	Select @PharmacyBill = Round(IsNull(SUM(sd.Total),0),0) from SalesMaster sm JOIN SalesDetail sd ON sm.SaleID = sd.SaleID where sm.PatientID = @PatientID 
		
	Select @TotalAdmitDays = 
		Isnull(case when (pd.DischargeDate IS null OR pd.DischargeDate = '1900-01-01 00:00:00')
		then IsNull(DATEDIFF(Day,AdmissionDate,GetDate()),0)
		else IsnuLL(DATEDIFF(Day,AdmissionDate,pd.DischargeDate),0) end,0)
		from PatientRegistration pr
		Left outer JOIN PatientDischarge pd ON pr.PatientID = pd.PatientID
		where pr.PatientID = @PatientID
		
	Select @RoomCharges = RoomCharges from Rooms where RoomID = (select RoomID from PatientRegistration where PatientID = @PatientID)
	
	if(@RoomCharges is null)
		set @RoomCharges = 0
	
	Set @TotalRoomCharges = (@RoomCharges * @TotalAdmitDays)
		
	select @InvestigationTestBill = ISNULL(Sum(dt.Charges),0) from dbo.PatientDisgnosticTest pd 
	JOIN DiagnosticTest dt ON pd.TestID = dt.TestID
	where PatientID = @PatientID
	
	select @DepositeAmount = ISNULL(Sum(Amount),0) from Transactions Where PatientID = @PatientID and PaymentType='Deposit' 
	
	select @DiscountAmount = ISNULL(Sum(Amount),0) from Transactions Where PatientID = @PatientID and PaymentType='Discount'
	
	--Select @SurgeryAmount = ISNULL(df.Fees,0) from DoctorFee df JOIN FeesType  ft ON df.FeeTypeID = ft.FeeTypeID
	--where DoctorID = (select DoctorID from PatientRegistration pr join PatientSurgery ps on pr.PatientID = ps.PatientID
	--where pr.PatientID = 1 ) and ft.FeeType ='Surgery' 
	
	Select  @SurgeryAmount =  ISNULL(df.Fees,0) from DoctorFee df JOIN FeesType  ft ON df.FeeTypeID = ft.FeeTypeID
	where DoctorID = 
	(select DoctorID from PatientRegistration pr Left outer join PatientSurgery ps on pr.PatientID = ps.PatientID
	where pr.PatientID = @PatientID and ps.SurgeryType = ft.FeeType)
	

	--Temporary admit fee 
	Select @TemporaryAdmit = ISNULL(df.Fees,0) from DoctorFee df JOIN FeesType  ft ON df.FeeTypeID = ft.FeeTypeID
	where ft.FeeType='temporary admit' and DoctorID = (select DoctorID from PatientRegistration where PatientID = @PatientID and PatientType='Temporary')

	Declare @BalanceOwing decimal(18,2)
	Declare @BillingAmount decimal(18,2)
	Declare @BalanceowingAfterDiscount decimal(18,2) 	

	set @BalanceowingAfterDiscount = 0
	
	if(@TotalRoomCharges = 0 and @TemporaryAdmit > 0)
		set @TotalRoomCharges  = @TemporaryAdmit 

	if(@SurgeryAmount is null)
		set @SurgeryAmount = 0
	
	Set @BillingAmount = (@PharmacyBill + @TotalRoomCharges + @InvestigationTestBill + @SurgeryAmount)
	
	if(@DepositeAmount is not null)
		set @BalanceOwing = @BillingAmount - @DepositeAmount
	else
		set @BalanceOwing = @BillingAmount
	
	--select @PharmacyBill, @TotalRoomCharges, @InvestigationTestBill, @BalanceOwing
	
	if(@DiscountAmount > 0)
		Set @BalanceowingAfterDiscount = (@BalanceOwing - @DiscountAmount)
	else
		Set @BalanceowingAfterDiscount = @BalanceOwing
	
	delete from BalanceOwing where PatientID = @PatientID
	

	Declare @PatientType varchar(20)
	select @PatientType = PatientType from PatientRegistration where PatientID = @PatientID 

	if(@PatientType ='Admit')
	Begin
		if (not exists(select patientid from balanceowing where PatientID = @PatientID))
			begin
				insert into BalanceOwing 
				Values(@PatientID, @PharmacyBill, @TotalRoomCharges, @InvestigationTestBill, 
				@BillingAmount, @SurgeryAmount, @DepositeAmount, @DiscountAmount, @BalanceowingAfterDiscount)
			end
		else
			begin
				update BalanceOwing set PharmacyBill = @PharmacyBill, RoomBill = @TotalRoomCharges, 
				InvestigationTestBill = @InvestigationTestBill, BillingAmount = @BillingAmount,
				SurgeryAmount = @SurgeryAmount, DepositeAmount = @DepositeAmount, Discount = @DiscountAmount,
				BalanceOwing = @BalanceowingAfterDiscount where PatientID = @PatientID
			
			end
	end
	else
		begin
			if (not exists(select patientid from balanceowing where PatientID = @PatientID))
			begin
				insert into BalanceOwing Values(@PatientID, @PharmacyBill, @TemporaryAdmit, @InvestigationTestBill, @TemporaryAdmit, 
				@SurgeryAmount, @DepositeAmount, @DiscountAmount, @BalanceowingAfterDiscount)
			end
		end
	
	
END

GO
/****** Object:  StoredProcedure [dbo].[SP_PatientDiagnosticReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- Author:  <Author,,Atif Hussain Bhatti>
-- Create date: <Create Date,,09-03-2017>
-- Description: <Description,,SP for Diagnostic Report PDF>
-- =============================================
CREATE PROCEDURE [dbo].[SP_PatientDiagnosticReport]
 
 @PatientTestID int = null,
 @ModeType nvarchar(20) = null
AS
 
BEGIN
  IF (@ModeType = 'GET')
  BEGIN
		SELECT pd.PatientTestID, pd.LabNumber,
		ISNULL(dt.TestName,'NIL')as TestName, 
		ISNULL(dt.TestGroup,'NIL')as TestGroup,  
		ISNULL(dt.Charges,0) as Charges, 
		ISNULL(dt.TestType,'NIL')AS TestType, 
		ISNULL(pd.DoctorName,'NIL') as DoctorName, 
		ISNULL(pd.PatientName,'NIL')AS PatientName, 
		ISNULL(pd.ContactNo,'NIL')as ContactNo, 
		ISNULL(pd.Symptoms,'NIL') as Symptoms, 
		ISNULL(pd.Discount,0) as Discount, 
		ISNULL(pd.Remarks,'NIL') as Remarks,
		ISNULL(pd.Status,'Delivery')as Status, 
		ISNULL(pd.TestDate,'')as TestDate, 
		ISNULL(pd.DeliveryDate,'')as DeliveryDate, 
		ISNULL(pd.Payment,'NIL') as Payment, 
		ISNULL(pd.Gender,'Male')as Gender, 
		ISNULL(pd.Age,'')as Age, 
		ISNULL(pd.TestRange,'NIL')as TestRange, 
		ISNULL(pd.Result,'NIL')as Result,
		isnull(pd.Pathologist,'NIL')Pathologist, 
		isnull(pd.Technologist, 'NIL') as Technologist
		FROM 
			PatientDisgnosticTest pd
		JOIN 
			DiagnosticTest dt ON dt.TestID = pd.TestID
		WHERE 
			pd.PatientTestID = @PatientTestID
  END
END


GO
/****** Object:  StoredProcedure [dbo].[sp_PatientDischarge]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_PatientDischarge]
	@PDID int = null,
	@PatientID int = null,
	@DischargeDate datetime = null,
	@Follow varchar(500) = null,
	@Remarks varchar(500) = null,
	@BriefSummary varchar(500) = null,
	@InvestigationDrug varchar(500) = null, 
	@Treatment varchar(500) = null, 
	@Instructions varchar(500) = null, 
	@TakeHomeMedicine varchar(500) = null, 
	@ModeType varchar(50) = null
AS
BEGIN
	
	if(@ModeType ='INSERT')
		Begin
			INSERT INTO PatientDischarge(PatientID,DischargeDate,Follow,Remarks,BriefSummary,InvestigationDrug, Treatment,
			Instructions, TakeHomeMedicine)
			 VALUES (@PatientID,@DischargeDate,@Follow,@Remarks,@BriefSummary, @InvestigationDrug, @Treatment, @Instructions,
			 @TakeHomeMedicine)
			 
			 declare @PatientRoomID int;
			 select @PatientRoomID = RoomID from PatientRegistration where PatientID= @PatientID
			 Update RoomStatus Set RoomStatus = 'Available' where RoomID = @PatientRoomID
		End
	
	if(@ModeType ='UPDATE')
		Begin
			UPDATE PatientDischarge set 
			PatientID = @PatientID,
			DischargeDate = @DischargeDate,
			Follow = @Follow,
			Remarks = @Remarks,
			BriefSummary = @BriefSummary,
			InvestigationDrug = @InvestigationDrug,
			Treatment = @Treatment,
			Instructions = @Instructions,
			TakeHomeMedicine = @TakeHomeMedicine
			WHERE PDID = @PDID
		End
		
	if(@ModeType = 'DELETE')
		Begin
			DELETE FROM PatientDischarge WHERE PDID = @PDID
		End
	
	if(@ModeType = 'GET')
		if(@PDID > 0)
			Begin
				SELECT * FROM PatientDischarge WHERE PDID = @PDID
			end
		else
			Begin
				SELECT * FROM PatientDischarge 
			End 
END


GO
/****** Object:  StoredProcedure [dbo].[sp_PatientDisgnosticTest]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_PatientDisgnosticTest] 
	@PatientTestID int = null,
	@TestID int = null,
	@PatientID int = null,
	@PatientName varchar(50) = null,
	@ContactNo varchar(50) = null,
	@DoctorName nvarchar(50) = null,
	@Symptoms varchar(50) = null,
	@Discount decimal(18,0) = null,
	@Remarks varchar(200) = null,
	@Status varchar(50) = null,
	@TestDate datetime = null,
	@Payment varchar(15) = null,
	@Gender varchar(15) = null,
	@Age int = null,
	@TestRange varchar(50) = null,
	@Result varchar(50) = null,
	@Pathologist varchar(50) = null,
	@Technologist varchar(50) = null,
	@LabNumber varchar(50) = null,
	@DeliveryDate datetime = null,
	@EnteredBy varchar(50) = null,
	@UpdatedBy varchar(50) = null,
	@UpdatedDate datetime = null,
	@IsDeleted bit = null,
	@DeletedBy varchar(50) = null,
	@DeletedDate datetime = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO PatientDisgnosticTest(TestID, PatientID, PatientName, ContactNo, DoctorName, Symptoms, Discount, 
		Remarks, Status, TestDate, Payment, Gender, Age, TestRange, Result, Pathologist, Technologist, LabNumber, DeliveryDate, 
		EnteredBy, UpdatedDate, UpdatedBy, IsDeleted, DeletedDate, DeletedBy)
		VALUES (@TestID, @PatientID, @PatientName, @ContactNo, @DoctorName, @Symptoms, ISNULL(@Discount,0), @Remarks, @Status, 
		@TestDate, @Payment, @Gender, ISNULL(@Age,0), @TestRange, @Result, @Pathologist, @Technologist,
		convert(varchar,REPLACE(CONVERT(CHAR(6), GETDATE(), 103), '/', ''),12)+
		LEFT( YEAR( GETDATE() ) % 100 ,2)+ Convert(Varchar,RIGHT('00000'+
		CAST((SELECT ISNULL(MAX(PatientTestID),0)+1 FROM PatientDisgnosticTest) AS VARCHAR),5)), 
		@DeliveryDate, 
		@EnteredBy, CONVERT(varchar,GETDATE(),101), @UpdatedBy, 
		@IsDeleted, CONVERT(varchar,GETDATE(),101), @DeletedBy)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE PatientDisgnosticTest SET
		TestID = @TestID,
		PatientID = @PatientID,
		PatientName = @PatientName,
		ContactNo = @ContactNo,
		DoctorName = @DoctorName,
		Symptoms = @Symptoms,
		Discount = @Discount,
		Remarks = @Remarks,
		Status = @Status,
		TestDate = @TestDate,
		Payment = @Payment,
		Gender = @Gender,
		Age = @Age,
		TestRange = @TestRange,
		Result = @Result,
		Pathologist = @Pathologist,
		Technologist = @Technologist,
		DeliveryDate = @DeliveryDate,
		UpdatedDate = CONVERT(varchar,GETDATE(),101),
		UpdatedBy = @UpdatedBy
		WHERE
			PatientTestID = @PatientTestID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		UPDATE PatientDisgnosticTest SET 
		DeletedBy = @DeletedBy,
		DeletedDate = CONVERT(varchar,GETDATE(),101),
		IsDeleted = '1'
		WHERE PatientTestID = @PatientTestID
	END
	
	IF(@ModeType = 'MAX')
	BEGIN
		SELECT MAX(PatientTestID) FROM PatientDisgnosticTest
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@PatientTestID > 0)
			SELECT pd.PatientTestID, pd.PatientID, pd.TestID, dt.TestType, dt.TestName, dt.Charges, pd.PatientName, pd.ContactNo, 
			pd.DoctorName, pd.Symptoms,pd.Discount, pd.Remarks, pd.Status,pd.TestDate, 
			pd.Payment, pd.Gender, pd.Age, pd.TestRange, pd.Result, pd.Pathologist,pd.Technologist, pd.LabNumber, 
			pd.DeliveryDate, pd.EnteredBy, pd.UpdatedDate, pd.UpdatedBy,
			pd.IsDeleted, pd.DeletedDate, pd.DeletedBy
			FROM PatientDisgnosticTest pd
			JOIN DiagnosticTest dt ON dt.TestID = pd.TestID
			WHERE pd.PatientTestID = @PatientTestID AND IsDeleted = '0'
	END
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT pd.PatientTestID,  pd.PatientID, pd.TestID, dt.TestType, dt.TestName, dt.Charges, pd.PatientName, pd.ContactNo, pd.DoctorName, pd.Symptoms,
			pd.Discount, pd.Remarks, pd.Status, pd.TestDate, pd.Payment, pd.Gender, pd.Age, pd.TestRange, pd.Result, pd.Pathologist,
			pd.Technologist, pd.LabNumber, pd.DeliveryDate, pd.EnteredBy, pd.UpdatedDate, pd.UpdatedBy,
			pd.IsDeleted, pd.DeletedDate, pd.DeletedBy
			FROM PatientDisgnosticTest pd
			JOIN DiagnosticTest dt ON dt.TestID = pd.TestID 
			WHERE
			PD.IsDeleted = '0' AND
			(dt.TestName LIKE('%'+@Search+'%') OR
			pd.PatientName LIKE('%'+@Search+'%') OR
			pd.ContactNo LIKE('%'+@Search+'%') OR
			pd.DoctorName LIKE('%'+@Search+'%') OR
			pd.Symptoms LIKE('%'+@Search+'%') OR
			pd.Discount LIKE('%'+@Search+'%') OR
			pd.Remarks LIKE('%'+@Search+'%') OR
			pd.Status LIKE('%'+@Search+'%') OR
			pd.TestDate LIKE('%'+@Search+'%') OR
			pd.DeliveryDate LIKE('%'+@Search+'%') OR
			pd.EnteredBy LIKE('%'+@Search+'%') OR
			pd.UpdatedDate LIKE('%'+@Search+'%') OR
			pd.UpdatedBy LIKE('%'+@Search+'%') OR
			pd.IsDeleted LIKE('%'+@Search+'%') OR
			pd.DeletedDate LIKE('%'+@Search+'%') OR
			pd.DeletedBy LIKE('%'+@Search+'%'))
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_PatientPanel]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_PatientPanel]
	@PanelID int = null,
	@PatientID int = null,
	@OrganizationID int = null,
	@PanelLevel varchar(100) = null,
	@LimitAmount decimal = null,
	@Services	varchar(30) = null,
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		IF((select COUNT(*) from PatientPanel where PatientID = @PatientID) > 0)
		BEGIN
			UPDATE PatientPanel SET
			PatientID = @PatientID,
			OrganizationID = @OrganizationID,
			PanelLevel = @PanelLevel,
			LimitAmount = @LimitAmount,
			Services = @Services
			WHERE PanelID = @PanelID
		END
		ELSe
		BEGIN
			INSERT INTO PatientPanel(PatientID,OrganizationID,PanelLevel,LimitAmount,Services) 
			VALUES (@PatientID,@OrganizationID,@PanelLevel,@LimitAmount,@Services)
		END 
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE PatientPanel SET
		PatientID = @PatientID,
		OrganizationID = @OrganizationID,
		PanelLevel = @PanelLevel,
		LimitAmount = @LimitAmount,
		Services = @Services
		WHERE PanelID = @PanelID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		Delete from PatientPanel
		WHERE PanelID = @PanelID
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@PanelID > 0)
			SELECT * FROM PatientPanel WHERE panelID = @PanelID
		ELSE
			SELECT * FROM PatientPanel 
	END
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PatientReg]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PatientReg] 
	@PatientID int = null,
	@PatientCategory varchar(20) = null,
	@PatientType varchar(20) = null,
	--@OrganizationID int = null,
	@DoctorID int = null,
	@RoomID int = null,
	@PatientRegNo varchar(50) = null,
	@FirstName varchar(50) = null,
	@LastName varchar(50) = null,
	@MiddleName varchar(50) = null,
	@TakeCareName varchar(50) = null,
	@TakeCareRelation varchar(15) = null,
	@PatientCNIC varchar(16) = null,
	@TakeCareCNIC varchar(16) = null,
	@DateOfBirth date = null,
	@Gender varchar(7) = null,
	@Age varchar(50) = null,
	@MaritalStatus varchar(15) = null,
	@Address varchar(150) = null,
	@City varchar(70) = null,
	@State varchar(70) = null,
	@Country varchar(70) = null,
	@Occupation varchar(80) = null,
	@Telephone varchar(20) = null,
	@MobileNo varchar(15) = null,
	@GuardianName varchar(70) = null,
	@GuardianContactNo varchar(20) = null,
	@ReferBy varchar(70) = null, 
	@Diagnosis varchar(70) = null,
	@SecondaryDiagnosis varchar(100) = null,
	@AdmissionDate datetime = null, 
	@Remarks varchar(200) = null,
	@Search varchar(100) = null,
	@ModeType nvarchar(50) = null
AS
BEGIN
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO PatientRegistration(PatientCategory, PatientType, DoctorID,RoomID,PatientRegNo,FirstName,LastName,MiddleName,TakeCareName,
		TakeCareRelation,PatientCNIC,TakeCareCNIC,DateOfBirth,Gender,Age,MaritalStatus,Address,City,State,Country,Occupation,
		Telephone,MobileNo,GuardianName,GuardianContactNo,ReferBy,Diagnosis, SecondaryDiagnosis, AdmissionDate, Remarks)
		VALUES (@PatientCategory, @PatientType, @DoctorID,0,@PatientRegNo,@FirstName,@LastName,@MiddleName,@TakeCareName,
		@TakeCareRelation,@PatientCNIC,@TakeCareCNIC,@DateOfBirth,@Gender,@Age,@MaritalStatus,@Address,@City,@State,@Country,@Occupation,
		@Telephone,@MobileNo,@GuardianName,@GuardianContactNo,@ReferBy,@Diagnosis, @SecondaryDiagnosis, @AdmissionDate,@Remarks)
		
		Declare @NewPatientID int
		Select @NewPatientID = MAX(PatientID) from PatientRegistration
		exec sp_PatientBilling @NewPatientID		

		
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE PatientRegistration SET
		PatientCategory = @PatientCategory,
		PatientType = @PatientType,
		--OrganizationID = @OrganizationID,
		DoctorID = @DoctorID,
		--RoomID = @RoomID,
		PatientRegNo = @PatientRegNo,
		FirstName = @FirstName,
		LastName = @LastName,
		MiddleName = @MiddleName,
		TakeCareName = @TakeCareName,
		TakeCareRelation = @TakeCareRelation,
		PatientCNIC = @PatientCNIC,
		TakeCareCNIC = @TakeCareCNIC,		
		Gender = @Gender,
		Age = @Age,
		MaritalStatus = @MaritalStatus,
		Address = @Address,
		City = @City,
		State = @State,
		Country = @Country,
		Occupation = @Occupation,
		Telephone = @Telephone,
		MobileNo = @MobileNo,
		GuardianName = @GuardianName,
		GuardianContactNo = @GuardianContactNo,
		ReferBy = @ReferBy, 
		Diagnosis = @Diagnosis,
		SecondaryDiagnosis = @SecondaryDiagnosis,
		AdmissionDate = @AdmissionDate, 		
		Remarks = @Remarks
		WHERE
		PatientID = @PatientID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN		
		Delete from BalanceOwing where PatientID = @PatientID
		Delete from PatientDischarge where PatientID = @PatientID
		Delete from PatientDisgnosticTest where PatientID = @PatientID
		Delete from PatientPanel where PatientID = @PatientID
		Delete from PatientSurgery where PatientID = @PatientID
		DELETE FROM PatientRegistration WHERE PatientID = @PatientID
	END
	
	--IF(@ModeType = 'DISCHARGE')
	--BEGIN
	--	UPDATE PatientRegistration SET
	--	DischargeDate = @DischargeDate,
	--	IsDischarge = 1
	--	WHERE PatientID = @PatientID
	--END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@PatientID > 0)
			select pr.*,(select Room from Rooms where RoomID = pr.roomID) as Room, 
			(c.FirstName + ' '+ c.LastName) as DoctorName, (pr.FirstName + ' '+ pr.LastName) as PatientName,
			(select COUNT(*) from patientDischarge pd where pd.PatientID = pr.PatientID) as IsDischarge
			from PatientRegistration pr
			join Contact c on c.ContactID = pr.DoctorID
			--join Rooms r on r.RoomID = pr.RoomID
			where pr.PatientID = @PatientID
		ELSE
			select pr.*,(select Room from Rooms where RoomID = pr.roomID) as Room, 
			(c.FirstName + ' '+ c.LastName) as DoctorName, (pr.FirstName + ' '+ pr.LastName) as PatientName,
			--1 as IsDischarge
			
			(select COUNT(*) from patientDischarge pd where pd.PatientID = pr.PatientID) as IsDischarge
			
			from PatientRegistration pr
			join Contact c on c.ContactID = pr.DoctorID	
			where pr.PatientID not in(select PatientID from patientDischarge)		
			--order by (select COUNT(*) from patientDischarge pd where pd.PatientID = pr.PatientID) 
			order by pr.PatientID desc
			--join Rooms r on r.RoomID = pr.RoomID
	END
	IF(@ModeType = 'GetPatientNo')
	BEGIN
		Select [dbo].[UDF_GEN_PatientRegNo]() as PatientNumber
	END
	
	IF(@ModeType = 'GetAllAdmitPatientList')
	BEGIN
		select pr.*,(select Room from Rooms where RoomID = pr.roomID) as Room, 
		(c.FirstName + ' '+ c.LastName) as DoctorName, (pr.FirstName + ' '+ pr.LastName) as PatientName,
		(select COUNT(*) from patientDischarge pd where pd.PatientID = pr.PatientID) as IsDischarge
		from PatientRegistration pr
		join Contact c on c.ContactID = pr.DoctorID
		where (select COUNT(*) from patientDischarge pd where pd.PatientID = pr.PatientID) = 0
	END
	
	IF(@ModeType = 'GETPatientSaleID')
	BEGIN
		Select SaleID from SalesMaster where PatientID = @PatientID
	END

	IF(@ModeType = 'GetTotalAdmitedPatients')
	BEGIN
		Select Count(pr.PatientID) as TotalAdmitedPatients
		from PatientRegistration pr
		join Contact c on c.ContactID = pr.DoctorID	
		where pr.PatientID not in(select PatientID from patientDischarge)
	END

	IF(@ModeType = 'SearchCriteria')
	BEGIN
		--Select pr.PatientID, pr.PatientRegNo, pr.FirstName, pr.LastName, bo.+
		--from PatientRegistration pr
		--Left Outer Join BalanceOwing bo on pr.PatientID = bo.PatientID
		Select pr.*,(select Room from Rooms where RoomID = pr.roomID) as Room, 
		(c.FirstName + ' '+ c.LastName) as DoctorName, (pr.FirstName + ' '+ pr.LastName) as PatientName,
		(Select COUNT(*) from patientDischarge pd where pd.PatientID = pr.PatientID) as IsDischarge
		from 
			PatientRegistration pr
			join Contact c on c.ContactID = pr.DoctorID	
		where 
			pr.PatientRegNo LIKE('%'+@Search+'%') OR
			pr.FirstName LIKE('%'+@Search+'%') OR
			pr.LastName LIKE('%'+@Search+'%') OR
			pr.PatientCNIC LIKE('%'+@Search+'%') OR
			pr.Age LIKE('%'+@Search+'%') OR
			pr.City LIKE('%'+@Search+'%') OR
			pr.AdmissionDate LIKE('%'+@Search+'%') OR
			pr.MobileNo LIKE('%'+@Search+'%') 
	END


	IF(@ModeType = 'GetPatientInfoForDiscount')
	BEGIN
		SELECT 
			pr.PatientID, pr.PatientRegNo, pr.FirstName, pr.LastName, 
			bo.BillingAmount, bo.DepositeAmount, bo.Discount
		FROM 
			PatientRegistration pr 
		JOIN 
			BalanceOwing bo on pr.PatientID = bo.PatientID
		WHERE 
			pr.PatientID  = @PatientID
	END

	IF(@ModeType = 'GetPatientOTProducts')
		BEGIN
			Select p.ProductID, p.companyID, p.ProductName, p.UnitPrice, isnull(ss.Quantity,0) as Quantity 
			from products p
			left outer join (select sd.productid, sd.Quantity from SalesMaster sm
							JOIN SalesDetail sd on sm.SaleID = sd.SaleID
							where PatientID = @PatientID) ss on ss.ProductID = p.ProductID
			where isnull(IsOTProduct,0)=1 order by ProductName
		END
	
END



GO
/****** Object:  StoredProcedure [dbo].[sp_PatientRegistrationReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PatientRegistrationReport]
	-- Add the parameters for the stored procedure here
	@PatientID int = null,
	@DoctorID int = null,		
	@StartDate date = null,
	@EndDate date = null
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'SELECT 
		pr.PatientCategory,
		(c.FirstName+'' ''+c.LastName) as DoctorName,
		pr.PatientID, pr.PatientRegNo, (pr.FirstName+'' ''+pr.LastName)as PatientName, pr.TakeCareName, pr.TakeCareRelation,
		ISNULL(pr.PatientCNIC,'''')as PatientCNIC, 
		case when IsNull(pr.DateOfBirth,''1900-01-01'') = '''' then '''' else CONVERT(varchar, pr.DateOfBirth,(101))end as DateOfBirth, 
		pr.Gender, pr.Age, pr.MaritalStatus, 
		ISNULL(pr.Address,'''')as Address, ISNULL(pr.City,'''')as City, ISNULL(pr.Occupation,'''')as Occupation, 
		ISNULL(pr.Telephone,'''')as Telephone, ISNULL(pr.MobileNo,'''')as MobileNo,
		ISNULL(pr.GuardianName,'''')as GuardianName, ISNULL(pr.GuardianContactNo,'''')as GuardianContactNo,
		ISNULL(pr.ReferBy,'''')as ReferBy, ISNULL(pr.Diagnosis,'''')as Diagnosis, 
		ISNULL(pr.SecondaryDiagnosis,'''')as SecondaryDiagnosis, 
		CONVERT(varchar, pr.AdmissionDate,(101))as AdmissionDate, ISNULL(pr.Remarks,'''')as Remarks,
		bo.PharmacyBill, bo.RoomBill, bo.InvestigationTestBill, bo.BillingAmount, bo.DepositeAmount,
		bo.Discount,bo.BalanceOwing,bo.SurgeryAmount,
		CONVERT(varchar, ps.SurgeryDate,(101))as SurgeryDate, ISNULL(ps.Anaesthetist,'''')as Anaesthetist,
		ISNULL(ps.OTTechnician1,'''')as OTTechnician1, ISNULL(ps.OTTechnician2,'''')as OTTechnician2,
		ISNULL(ps.OTTechnician3,'''')as OTTechnician3, ISNULL(ps.OTTechnician4,'''')as OTTechnician4,
		ISNULL(ps.OTTechnician5,'''')as OTTechnician5, ps.SurgeryType, ps.AnaesthetistType, ps.SurgeryProcedure, ps.Remarks as SurgeryRemarks,
		r.Room, r.RoomType, r.RoomCharges,
		case when IsNull(pd.DischargeDate,''1900-01-01'') = '''' then '''' else CONVERT(varchar, pd.DischargeDate,(101))end as DischargeDate, 			
		pd.Follow, pd.Remarks as DischargeRemarks, IsNull(pd.BriefSummary,'''')as BriefSummary,
		IsNull(pd.InvestigationDrug,'''')as InvestigationDrug, ISNULL(pd.Treatment,'''')as Treatment,
		IsNull(pd.Instructions,'''')as Instructions, ISNULL(pd.TakeHomeMedicine,'''')as TakeHomeMedicine
	FROM 
		PatientRegistration pr
	INNER JOIN 
		BalanceOwing bo ON pr.PatientID = bo.PatientID
	INNER JOIN 
		Contact c ON pr.DoctorID = c.ContactID
	LEFT OUTER JOIN 
		Rooms r ON pr.RoomID = r.RoomID
	LEFT OUTER JOIN 
		PatientSurgery ps ON pr.PatientID = ps.PatientID 
	LEFT OUTER JOIN 
		PatientDischarge pd ON pr.PatientID = pd.PatientID '
		
	if @PatientID is not NULL
			SET @SQLQuery = @SQLQuery + ' Where pr.PatientID = @PatientID '	
		
	if((@DoctorID is not null) and (@StartDate is null))
		SET @SQLQuery = @SQLQuery + ' Where pr.DoctorID = @DoctorID '
	
	if((@DoctorID is not null) and (@StartDate is not null))
		SET @SQLQuery = @SQLQuery + ' Where DoctorID= @DoctorID and cast(pr.AdmissionDate as Date) Between @StartDate and @EndDate'
	
	if((@DoctorID is null) and (@StartDate is not null))
		SET @SQLQuery = @SQLQuery + ' Where cast(pr.AdmissionDate as Date) Between @StartDate and @EndDate'
		
	
	Set @ParamDefinition =      ' @PatientID int, 
				@DoctorID int,                               
                @StartDate DateTime,
                @EndDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @PatientID,
                @DoctorID, 
                @StartDate, 
                @EndDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_PatientReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PatientReport]
	
AS
BEGIN
	SELECT 
		pr.PatientCategory, 
		(c.FirstName+' '+c.LastName) as DoctorName,
		pr.PatientID, pr.PatientRegNo, (pr.FirstName+' '+pr.LastName)as PatientName, pr.TakeCareName, pr.TakeCareRelation,
		ISNULL(pr.PatientCNIC,'')as PatientCNIC, 
		case when IsNull(pr.DateOfBirth,'1900-01-01') = '' then '' else CONVERT(varchar, pr.DateOfBirth,(101))end as DateOfBirth, 
		pr.Gender, pr.Age, pr.MaritalStatus, 
		ISNULL(pr.Address,'')as Address, ISNULL(pr.City,'')as City, ISNULL(pr.Occupation,'')as Occupation, 
		ISNULL(pr.Telephone,'')as Telephone, ISNULL(pr.MobileNo,'')as MobileNo,
		ISNULL(pr.GuardianName,'')as GuardianName, ISNULL(pr.GuardianContactNo,'')as GuardianContactNo,
		ISNULL(pr.ReferBy,'')as ReferBy, ISNULL(pr.Diagnosis,'')as Diagnosis, 
		ISNULL(pr.SecondaryDiagnosis,'')as SecondaryDiagnosis, 
		CONVERT(varchar, pr.AdmissionDate,(101))as AdmissionDate, ISNULL(pr.Remarks,'')as Remarks,
		bo.PharmacyBill, bo.RoomBill, bo.InvestigationTestBill, bo.BillingAmount, bo.DepositeAmount,
		bo.Discount,bo.BalanceOwing,bo.SurgeryAmount,
		CONVERT(varchar, ps.SurgeryDate,(101))as SurgeryDate, ISNULL(ps.Anaesthetist,'')as Anaesthetist,
		ISNULL(ps.OTTechnician1,'')as OTTechnician1, ISNULL(ps.OTTechnician2,'')as OTTechnician2,
		ISNULL(ps.OTTechnician3,'')as OTTechnician3, ISNULL(ps.OTTechnician4,'')as OTTechnician4,
		ISNULL(ps.OTTechnician5,'')as OTTechnician5, ps.SurgeryType, ps.AnaesthetistType, ps.SurgeryProcedure, ps.Remarks as SurgeryRemarks,
		r.Room, r.RoomType, r.RoomCharges,
		case when IsNull(pd.DischargeDate,'1900-01-01') = '' then '' else CONVERT(varchar, pd.DischargeDate,(101))end as DischargeDate, 
		pd.Follow, pd.Remarks as DischargeRemarks, IsNull(pd.BriefSummary,'')as BriefSummary,
		IsNull(pd.InvestigationDrug,'')as InvestigationDrug, ISNULL(pd.Treatment,'')as Treatment,
		IsNull(pd.Instructions,'')as Instructions, ISNULL(pd.TakeHomeMedicine,'')as TakeHomeMedicine
	FROM 
		PatientRegistration pr
	INNER JOIN 
		BalanceOwing bo ON pr.PatientID = bo.PatientID
	INNER JOIN 
		Contact c ON pr.DoctorID = c.ContactID
	LEFT OUTER JOIN
		Rooms r ON pr.RoomID = r.RoomID
	LEFT OUTER JOIN 
		PatientSurgery ps ON pr.PatientID = ps.PatientID
	LEFT OUTER JOIN 
		PatientDischarge pd ON pr.PatientID = pd.PatientID
	
END
GO
/****** Object:  StoredProcedure [dbo].[sp_PatientSurgery]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_PatientSurgery]
	@SurgeryID int = null,
	@PatientID int = null,
	@SurgeryType varchar(50) = null,
	@SurgeryDate datetime = null, 
	@Anaesthetist varchar(50) = null,
	@AnaesthetistType varchar(50) = null,
	@OTTechnician1 varchar(50) = null,
	@OTTechnician2 varchar(50) = null,
	@OTTechnician3 varchar(50) = null,
	@OTTechnician4 varchar(50) = null,
	@OTTechnician5 varchar(50) = null, 
	@SurgeryProcedure varchar(500) = null,
	@Remarks varchar(500) = null,
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO PatientSurgery(PatientID, SurgeryType, SurgeryDate, Anaesthetist, AnaesthetistType, OTTechnician1, 
		OTTechnician2, OTTechnician3, OTTechnician4, OTTechnician5, SurgeryProcedure, Remarks)
		VALUES (@PatientID, @SurgeryType, @SurgeryDate, @Anaesthetist, @AnaesthetistType, @OTTechnician1, 
		@OTTechnician2, @OTTechnician3, @OTTechnician4, @OTTechnician5, @SurgeryProcedure, @Remarks)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN 
		UPDATE PatientSurgery SET
		PatientID = @PatientID,
		SurgeryType = @SurgeryType,
		SurgeryDate = @SurgeryDate,
		Anaesthetist = @Anaesthetist,
		AnaesthetistType = @AnaesthetistType,
		OTTechnician1 = @OTTechnician1,
		OTTechnician2 = @OTTechnician2,
		OTTechnician3 = @OTTechnician3,
		OTTechnician4 = @OTTechnician4,
		OTTechnician5 = @OTTechnician5, 
		SurgeryProcedure = @SurgeryProcedure,
		Remarks = @Remarks
		WHERE
			SurgeryID = @SurgeryID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM PatientSurgery  
		WHERE SurgeryID = @SurgeryID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@SurgeryID > 0)
			select ps.*, (c.FirstName+ ' '+c.LastName) as DoctorName, df.Fees as SurgeryAmount from PatientSurgery ps
			join PatientRegistration pr on pr.PatientID = ps.PatientID
			join Contact c on c.ContactID = pr.DoctorID
			join DoctorFee df on df.DoctorID = c.ContactID
			where df.FeeTypeID = 1 and SurgeryID =  @SurgeryID
		ELSE
			select ps.*, (c.FirstName+ ' '+c.LastName) as DoctorName, df.Fees as SurgeryAmount from PatientSurgery ps
			join PatientRegistration pr on pr.PatientID = ps.PatientID
			join Contact c on c.ContactID = pr.DoctorID
			join DoctorFee df on df.DoctorID = c.ContactID
			where df.FeeTypeID = 1
	END
		
END

GO
/****** Object:  StoredProcedure [dbo].[sp_Prodcut]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_Prodcut] 
	@CompanyID  int
AS
BEGIN
	select p.ProductName , c.Company, pt.ProductType, s.Strength,  p.UnitPrice 
		from Product p 
		join Company c On c.CompanyID = p.CompanyID
		join ProductType pt on pt.ProductTypeID = p.ProductTypeID
		join Strength s on s.StrengthID = p.StrengthID
		where p.CompanyID = @CompanyID
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Product]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Product] 
	@ProductID int = null,
	@CompanyID int = null,
	@ProductTypeID int = null,
	@ProductName nvarchar(50) = null,
	@ProductCode nvarchar(50) = null,
	@ProductRegNo nvarchar(50) = null,
	@Formula nvarchar(50) = null,
	@StrengthID int = null,
	@UnitPrice decimal(18,2) = null,
	@PurchasePrice  decimal(18,2) = null,
	@IsOTProduct bit = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(50) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Product(CompanyID, ProductTypeID, ProductName, ProductCode, ProductRegNo, Formula, StrengthID, 
		UnitPrice, PurchasePrice, IsOTProduct)
		VALUES (@CompanyID, @ProductTypeID, @ProductName, @ProductCode, @ProductRegNo, @Formula, @StrengthID, 
		@UnitPrice, @PurchasePrice, @IsOTProduct)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Product SET
		CompanyID = @CompanyID,
		ProductTypeID = @ProductTypeID,
		ProductName = @ProductName,
		ProductCode = @ProductCode,
		ProductRegNo = @ProductRegNo,
		Formula = @Formula,
		StrengthID = @StrengthID,
		UnitPrice = @UnitPrice,
		PurchasePrice = @PurchasePrice,
		IsOTProduct = @IsOTProduct
		WHERE
			ProductID = @ProductID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Product WHERE ProductID = @ProductID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@ProductID > 0)
		BEGIN
			SELECT  p.ProductID, p.CompanyID, c.Company, p.ProductTypeID, pt.ProductType, p.ProductName, p.ProductCode, p.ProductRegNo,
			p.Formula, p.StrengthID, st.Strength, p.UnitPrice, isnull(p.PurchasePrice,0) as PurchasePrice, 
			isnull(p.IsOTProduct, 0) as IsOTProduct
			FROM Product p
			JOIN Company c ON c.CompanyID = p.CompanyID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Strength st ON st.StrengthID = p.StrengthID
			WHERE ProductID = @ProductID
		END
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@ProductID > 0)
			SELECT * FROM Product 
			WHERE 
			ProductTypeID = @ProductTypeID AND
			ProductName = @ProductName AND
			StrengthID = @StrengthID AND 
			NOT(ProductID = @ProductID)
		ELSE
			SELECT * FROM Product 
			WHERE 
			ProductTypeID = @ProductTypeID AND
			ProductName = @ProductName AND
			StrengthID = @StrengthID
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
			SELECT  p.ProductID, p.CompanyID, c.Company, p.ProductTypeID, pt.ProductType, p.ProductName, p.ProductCode, p.ProductRegNo,
			p.Formula, p.StrengthID, st.Strength, p.UnitPrice, isnull(p.PurchasePrice,0)as PurchasePrice, bg.BarCodeImageName,
			isnull(p.IsOTProduct, 0) as IsOTProduct
			FROM Product p
			JOIN Company c ON c.CompanyID = p.CompanyID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Strength st ON st.StrengthID = p.StrengthID
			Left JOIN BarcodeGenerate bg ON p.productid = bg.ProductID
			WHERE
			c.Company LIKE('%'+@Search+'%') OR 
			pt.ProductType LIKE('%'+@Search+'%') OR
			p.ProductName LIKE('%'+@Search+'%') OR
			p.ProductCode LIKE('%'+@Search+'%') OR
			p.ProductRegNo LIKE('%'+@Search+'%') OR
			p.Formula LIKE('%'+@Search+'%') OR
			st.Strength LIKE('%'+@Search+'%') OR
			p.UnitPrice LIKE('%'+@Search+'%')
	END
	
	IF(@ModeType = 'SEARCH_New')
	BEGIN
			SELECT  (p.ProductName+'-'+pt.ProductType+'-'+ st.Strength) as ProductName
			FROM Product p
			JOIN Company c ON c.CompanyID = p.CompanyID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Strength st ON st.StrengthID = p.StrengthID
			Left JOIN BarcodeGenerate bg ON p.productid = bg.ProductID
			WHERE
			c.Company LIKE('%'+@Search+'%') OR 
			pt.ProductType LIKE('%'+@Search+'%') OR
			p.ProductName LIKE('%'+@Search+'%') OR
			p.ProductCode LIKE('%'+@Search+'%') OR
			p.ProductRegNo LIKE('%'+@Search+'%') OR
			p.Formula LIKE('%'+@Search+'%') OR
			st.Strength LIKE('%'+@Search+'%') OR
			p.UnitPrice LIKE('%'+@Search+'%')
	END
	
	IF(@ModeType = 'GetProductsByCompanyID')
	BEGIN
			select p.ProductID, (p.ProductName+' '+pt.ProductType +' '+ s.Strength) as  ProductName, p.UnitPrice, 
			isnull(p.PurchasePrice,0)as PurchasePrice
			from Product p
			INNER JOIN Strength s on s.StrengthID = p.StrengthID		
			INNER JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID	
			where p.CompanyID = @CompanyID
	END
	
	IF(@ModeType = 'GetProductByIDOrName')
		 BEGIN
		   SELECT  p.ProductID, p.CompanyID
		   ,ISNULL(c.Company,'') as Company, p.ProductTypeID
		   ,ISNULL(pt.ProductType,'') as ProductType
		   ,ISNULL(p.ProductName,'') as ProductName
		   ,ISNULL(p.ProductCode,0) as ProductCode
		   ,ISNULL(p.ProductRegNo,0) as ProductRegNo
		   ,ISNULL(p.Formula,'') as Formula
		   ,p.StrengthID ,ISNULL(st.Strength,'') as Strength
		   ,ISNULL(p.UnitPrice,0) as UnitPrice, ISNULL(p.PurchasePrice,0)as PurchasePrice
		   ,isnull(p.IsOTProduct, 0) as IsOTProduct
		   FROM Product p
		   LEFT JOIN Company c ON c.CompanyID = p.CompanyID
		   LEFT JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
		   LEFT JOIN Strength st ON st.StrengthID = p.StrengthID
		   WHERE
		   p.ProductID = @ProductID
		   OR
		   p.ProductName = @ProductName
		   
		 END
		 
		 IF(@ModeType = 'AUTOBIND')
			 BEGIN
			  SELECT p.ProductID, (p.ProductName +' '+ s.Strength) as  ProductName
			  FROM Product p
			  INNER JOIN Strength s on s.StrengthID = p.StrengthID 
			 END
			 
		IF(@ModeType = 'GetMaxID')
			BEGIN
				SELECT  convert(varchar, max(ProductID)) as MaxProductID From Product
			END

		IF(@ModeType = 'GetOTProducts')
			BEGIN
				select * from products where isnull(IsOTProduct,0)=1 order by ProductName
			END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ProductBarcode]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductBarcode]
 @ID int = null,
 @ProductID int = null,
 @Barcode nvarchar(1000) = null,

 @ModeType nvarchar(20) = null
AS
BEGIN
 IF(@ModeType = 'INSERT')
 BEGIN
  INSERT INTO ProductBarcode(ProductID, Barcode)
  VALUES (@ProductID, @Barcode)
 END
 
 
  
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ProductInventory]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProductInventory]
	@ProductID int = null,
	@Quantity int = null,
	@BatchNo varchar(50) = null,
	@ExpiryDate varchar(40) = null,
	@ModeType	varchar(50) = null
	
AS
BEGIN
	declare @Qty int = 0;
	Delete ProductInventory where ProductID = @ProductID and BatchNo = @BatchNo and Quantity=0
	Select @Qty = Quantity from ProductInventory where ProductID = @ProductID and BatchNo = @BatchNo
	IF(@Qty > 0)
	BEGIN
		if(@ModeType = 'NewPurchaseOrReturn')
			update ProductInventory set Quantity = (@Qty + @Quantity) where ProductID = @ProductID and BatchNo = @BatchNo
		
		if(@ModeType = 'SaleProduct')
			update ProductInventory set Quantity = (@Qty - @Quantity) where ProductID = @ProductID and BatchNo = @BatchNo
	END
	ELSE
		INSERT INTO ProductInventory (ProductID, Quantity, BatchNo, ExpiryDate) VALUES (@ProductID, @Quantity, @BatchNo, @ExpiryDate)
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ProductReturn]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name: Atif Hussain Bhatti>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProductReturn] 
	@ReturnID int = null,
	@ProductID int = null,
	@ReturnType varchar(50) = null,
	@SalesInvoiceNumber varchar(50) = null,
	@PurchaseInvoiceNumber varchar(50) = null,
	@Quantity int = null,
	@Price decimal(18,0) = null,
	@Total decimal(18,0) = null,
	@EnteredDate datetime = null,
	@EnteredBy varchar(50) = null,
	@UpdatedDate datetime = null,
	@UpdatedBy varchar(50) = null,
	@DeletedDate datetime = null,
	@DeletedBy varchar(50) = null,
	@IsDeleted bit = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO ProductReturn(ProductID, ReturnType, SalesInvoiceNumber, PurchaseInvoiceNumber, Quantity, Price, Total, EnteredDate,EnteredBy, UpdatedDate, UpdatedBy, 
		DeletedDate, DeletedBy, IsDeleted)
		VALUES (@ProductID, @ReturnType, @SalesInvoiceNumber, @PurchaseInvoiceNumber, 
		@Quantity, @Price, @Total, Convert(varchar,GETDATE(),101), 
		@EnteredBy,  Convert(varchar,GETDATE(),101), @UpdatedBy, 
		 Convert(varchar,GETDATE(),101), @DeletedBy, @IsDeleted)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE ProductReturn SET
		ProductID = @ProductID,
		ReturnType = ReturnType,
		SalesInvoiceNumber = @SalesInvoiceNumber,
		PurchaseInvoiceNumber = @PurchaseInvoiceNumber,
		Quantity = @Quantity,
		Price = @Price,
		Total = @Total,
		UpdatedDate = Convert(varchar,GETDATE(),101),
		UpdatedBy = @UpdatedBy
		WHERE
			ReturnID = @ReturnID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		UPDATE ProductReturn SET 
		DeletedBy = @DeletedBy,
		DeletedDate = Convert(varchar,GETDATE(),101),
		IsDeleted = '1'
		WHERE ReturnID = @ReturnID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@ReturnID > 0)
		SELECT pr.ReturnID, pr.ReturnType, 
		Case when isnull(pr.SalesInvoiceNumber,'') = '' then pr.PurchaseInvoiceNumber else pr.SalesInvoiceNumber end as InvoiceNumber,
		pr.ProductID, p.ProductName, pr.SalesInvoiceNumber, pr.PurchaseInvoiceNumber, 
		pr.Quantity, pr.Price, pr.Total, pr.EnteredDate,
		pr.EnteredBy, pr.UpdatedDate, pr.UpdatedBy, pr.DeletedDate,pr.DeletedBy, pr.IsDeleted
		FROM ProductReturn pr 
		JOIN Product p ON P.ProductID = pr.ProductID
		WHERE pr.ReturnID = @ReturnID AND IsDeleted = '0'
	END
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT pr.ReturnID, pr.ReturnType, 
		Case when isnull(pr.SalesInvoiceNumber,'') = '' then pr.PurchaseInvoiceNumber else pr.SalesInvoiceNumber end as InvoiceNumber,
		pr.ProductID, p.ProductName, pr.SalesInvoiceNumber, pr.PurchaseInvoiceNumber, 
		pr.Quantity, pr.Price, pr.Total, pr.EnteredDate,
		pr.EnteredBy, pr.UpdatedDate, pr.UpdatedBy, pr.DeletedDate,pr.DeletedBy, pr.IsDeleted
		FROM ProductReturn pr 
		JOIN Product p ON P.ProductID = pr.ProductID
		WHERE
		Pr.IsDeleted = '0' AND
		(p.ProductName LIKE('%'+@Search+'%') OR
		pr.ReturnType LIKE('%'+@Search+'%') OR
		pr.SalesInvoiceNumber LIKE('%'+@Search+'%') OR
		pr.Quantity LIKE('%'+@Search+'%') OR
		pr.Price LIKE('%'+@Search+'%') OR
		pr.Total LIKE('%'+@Search+'%') OR
		pr.EnteredDate LIKE('%'+@Search+'%') OR
		pr.EnteredBy LIKE('%'+@Search+'%') OR
		pr.UpdatedDate LIKE('%'+@Search+'%') OR
		pr.UpdatedBy LIKE('%'+@Search+'%') OR
		pr.DeletedDate LIKE('%'+@Search+'%') OR
		pr.DeletedBy LIKE('%'+@Search+'%'))
	END
	
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ProductType]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_ProductType] 
	@ProductTypeID int = null,
	@ProductType nvarchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO ProductType(ProductType)
		VALUES (@ProductType)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE ProductType SET
		ProductType = @ProductType
		WHERE
			ProductTypeID = @ProductTypeID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM ProductType WHERE ProductTypeID = @ProductTypeID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@ProductTypeID > 0)
			SELECT * FROM ProductType WHERE ProductTypeID = @ProductTypeID
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@ProductTypeID > 0)
			SELECT * FROM ProductType 
			WHERE ProductType = @ProductType AND NOT(ProductTypeID = @ProductTypeID)
		ELSE
			SELECT * FROM ProductType WHERE ProductType = @ProductType
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM ProductType 
			WHERE
			ProductType LIKE('%'+@Search+'%')
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_ProfitReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_ProfitReport] 
	@FromDate date = null,
	@ToDate date = null,
	@Year varchar(10) = null,
	@ModeType varchar(50) = null
AS
BEGIN
	IF(@ModeType ='DAILYWISEPROFIT')
		BEGIN
			Select aa.SaleDate, CAST(SUM(aa.PurchaseDiscountAmount) as Decimal(18,2))as PurchaseDiscountAmount , 
			CAST(SUM(aa.SaleDiscountAmount) as Decimal(18,2))as SaleDiscountAmount,
			CAST((SUM(aa.PurchaseDiscountAmount) - (SUM(aa.SaleDiscountAmount))) as Decimal(18,2))as ProfitAmount
			from 
			(
			Select convert(varchar,sm.saledate,(107))as SaleDate,
			(select pd.Discount from PurchaseDetail pd where pd.ProductID = sd.ProductID)as PurchaseDiscount,
			((((sd.Total)* (select top 1 isnull(pd.Discount,0) from PurchaseDetail pd where pd.ProductID = sd.ProductID) ))/100)as PurchaseDiscountAmount,
			sd.Discount,
			SUM(((sd.Total * sd.Discount)/100))SaleDiscountAmount,
			(((((sd.Total)* (select top 1 pd.Discount from PurchaseDetail pd where pd.ProductID = sd.ProductID) ))/100) - 
			(SUM(((sd.Total * sd.Discount)/100)))
			)as ProfitAmount, SUM(sd.Quantity) as SaleQty
			from SalesMaster sm
			join SalesDetail sd ON sm.SaleID = sd.SaleID
			where sm.SaleDate between @FromDate and @ToDate
			group by convert(varchar,sm.saledate,(107)), 
			sm.SaleID, sd.Total, sd.Discount, sd.ProductID) aa 
			group by aa.SaleDate
		END


	IF(@ModeType = 'MONTHLYPROFIT')
		BEGIN
			Select aa.SaleDate, CAST(SUM(aa.PurchaseDiscountAmount) as Decimal(18,2))as PurchaseDiscountAmount , 
			CAST(SUM(aa.SaleDiscountAmount) as Decimal(18,2))as SaleDiscountAmount,
			CAST((SUM(aa.PurchaseDiscountAmount) - (SUM(aa.SaleDiscountAmount))) as Decimal(18,2))as ProfitAmount
			from 
			(
			Select SUBSTRING(convert(varchar,sm.saledate,(105)),4,7)as SaleDate,
			(select pd.Discount from PurchaseDetail pd where pd.ProductID = sd.ProductID)as PurchaseDiscount,
			((((sd.Total)* (select top 1 isnull(pd.Discount,0) from PurchaseDetail pd where pd.ProductID = sd.ProductID) ))/100)as PurchaseDiscountAmount,
			sd.Discount,
			SUM(((sd.Total * sd.Discount)/100))SaleDiscountAmount,
			(((((sd.Total)* (select top 1 pd.Discount from PurchaseDetail pd where pd.ProductID = sd.ProductID) ))/100) - 
			(SUM(((sd.Total * sd.Discount)/100)))
			)as ProfitAmount, SUM(sd.Quantity) as SaleQty
			from SalesMaster sm
			join SalesDetail sd ON sm.SaleID = sd.SaleID
			where sm.SaleDate between @FromDate and @ToDate
			group by SUBSTRING(convert(varchar,sm.saledate,(105)),4,7), 
			sm.SaleID, sd.Total, sd.Discount, sd.ProductID) aa 
			group by aa.SaleDate

		END
		
		IF(@ModeType = 'YEARLYPROFIT')
			BEGIN
				Select aa.SaleDate, CAST(SUM(aa.PurchaseDiscountAmount) as Decimal(18,2))as PurchaseDiscountAmount , 
			CAST(SUM(aa.SaleDiscountAmount) as Decimal(18,2))as SaleDiscountAmount,
			CAST((SUM(aa.PurchaseDiscountAmount) - (SUM(aa.SaleDiscountAmount))) as Decimal(18,2))as ProfitAmount
				from 
				(
				Select Year(sm.saledate)as SaleDate,
				(select pd.Discount from PurchaseDetail pd where pd.ProductID = sd.ProductID)as PurchaseDiscount,
				((((sd.Total)* (select top 1 isnull(pd.Discount,0) from PurchaseDetail pd where pd.ProductID = sd.ProductID) ))/100)as PurchaseDiscountAmount,
				sd.Discount,
				SUM(((sd.Total * sd.Discount)/100))SaleDiscountAmount,
				(((((sd.Total)* (select top 1 pd.Discount from PurchaseDetail pd where pd.ProductID = sd.ProductID) ))/100) - 
				(SUM(((sd.Total * sd.Discount)/100)))
				)as ProfitAmount, SUM(sd.Quantity) as SaleQty
				from SalesMaster sm
				join SalesDetail sd ON sm.SaleID = sd.SaleID
				where Year(sm.SaleDate) = @Year
				group by Year(sm.saledate), 
				sm.SaleID, sd.Total, sd.Discount, sd.ProductID) aa 
				group by aa.SaleDate
			END
END


GO
/****** Object:  StoredProcedure [dbo].[SP_PurchaseDetail]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_PurchaseDetail]

@PurchaseDetailID	int = null,
@PurchaseID			int = null,
@CompanyID			int = null,
@ProductID			int = null,
@BatchNo			varchar(50) = null,
@MfgDate			date	 = null,
@ExpiryDate			date	= null,
@Quantity			int	= null,
@Bonus				int = null,
@Price				decimal(18, 2)	= null,
@Discount			int	= null,
@DiscountAmount		decimal(18, 2)	= null,
@SpecialDiscount	int	= null,
@SpecialDiscAmount	decimal(18, 2)	= null,
@GST				decimal(18, 2)	= null,
@Total				decimal(18, 2)	= null,
@DateEntered		datetime	= null,
@EnteredBy			varchar(50)	= null,
@UpdateDate			datetime	= null,
@UpdatedBy			varchar(50)	= null,
@DeletedDate		datetime	= null,
@DeletedBy			varchar(50)	= null,
@IsDeleted			bit	= null,
@Barcode			varchar(500) = null,
@ModeType			varchar(50) = null,
@Result				varchar(50) = null Output

AS
BEGIN
	IF(@ModeType = 'INSERT')
		begin
		INSERT INTO PurchaseDetail(PurchaseID,CompanyID,ProductID,BatchNo,MfgDate,ExpiryDate,Quantity, Bonus
			,Price,Discount,DiscountAmount,SpecialDiscount,SpecialDiscAmount,GST,Total,DateEntered,EnteredBy, Barcode
			)
		VALUES
			(@PurchaseID,@CompanyID,@ProductID,@BatchNo,@MfgDate,@ExpiryDate,@Quantity, @Bonus
			,@Price,@Discount,@DiscountAmount,@SpecialDiscount,@SpecialDiscAmount,@GST,@Total,@DateEntered,@EnteredBy, @Barcode
			)
			
			Declare @ExpiryDateinMonthYear varchar(5);			
			exec sp_ProductInventory @ProductID, @Quantity, @BatchNo, @ExpiryDate, 'NewPurchaseOrReturn'
			
		end
		
	IF(@ModeType = 'UPDATE')
		begin
		
		UPDATE PurchaseDetail SET
			PurchaseID =			@PurchaseID
			,CompanyID =			@CompanyID
			,ProductID =			@ProductID
			,BatchNo =				@BatchNo
			,MfgDate =				@MfgDate
			,ExpiryDate =			@ExpiryDate
			,Quantity =				@Quantity
			,Bonus =				@Bonus
			,Price =				@Price
			,Discount =				@Discount
			,DiscountAmount =		@DiscountAmount
			,SpecialDiscount =		@SpecialDiscount
			,SpecialDiscAmount =	@SpecialDiscAmount
			,GST				=	@GST
			,Total =				@Total
			,UpdateDate =			@UpdateDate
			,UpdatedBy =			@UpdatedBy
			,Barcode =				@Barcode
		WHERE
			PurchaseDetailID =		@PurchaseDetailID
		end
		
	IF(@ModeType = 'DELETE')
		begin
		--UPDATE PurchaseDetail SET
		--	DeletedDate =	GETDATE()
		--	,DeletedBy =	@DeletedBy
		--	,IsDeleted =	1
		--WHERE
		--	PurchaseDetailID =		@PurchaseDetailID
		
		delete PurchaseDetail where PurchaseDetailID = @PurchaseDetailID
		
		end
		
	IF(@ModeType = 'DELETE_PurchaseIDWise')
		begin
		DELETE
			PurchaseDetail 
		WHERE
			PurchaseID =	@PurchaseID
		end
	
	IF(@ModeType = 'DELETE_PurchaseIDWise_IsDeleted1')
		begin
		UPDATE PurchaseDetail SET
			DeletedDate =	@DeletedDate
			,DeletedBy =	@DeletedBy
			,IsDeleted =	1
		WHERE
			PurchaseID =		@PurchaseID
		end
		
	IF(@ModeType = 'GET_LIST')
		begin
			SELECT
			ISNULL(PurchaseID,0) as PurchaseID,ISNULL(pd.CompanyID,0) as CompanyID
			,ISNULL(ProductID,0) as ProductID,ISNULL(BatchNo,'') as BatchNo
			,ISNULL(MfgDate,'') as MfgDate,ISNULL(ExpiryDate,'') as ExpiryDate
			,ISNULL(Quantity,0) as Quantity, isnull(Bonus,0) as Bonus
			,ISNULL(Price,0) as Price
			,ISNULL(Discount,0) as Discount,ISNULL(DiscountAmount,0) as DiscountAmount
			,ISNULL(SpecialDiscount,0) as SpecialDiscount,ISNULL(SpecialDiscAmount,0) as SpecialDiscAmount
			,ISNULL(GST,0) as GST,ISNULL(Total,0) as Total
			,DateEntered,EnteredBy,UpdateDate,UpdatedBy,DeletedDate,DeletedBy,IsDeleted,
			c.Company
			 FROM 
				PurchaseDetail pd
				join Company c on c.CompanyID = pd.CompanyID
				where isnull(pd.IsDeleted,0) <> 1
		end
	
	IF(@ModeType = 'GetListForView')
		begin
			SELECT
			PurchaseDetailID,
			ISNULL(pd.PurchaseID,0) as PurchaseID,ISNULL(pd.CompanyID,0) as CompanyID
			,ISNULL(p.ProductID,0) as ProductID,ISNULL(BatchNo,'') as BatchNo
			,ISNULL(MfgDate,'') as MfgDate,ISNULL(ExpiryDate,'') as ExpiryDate
			,ISNULL(Quantity,0) as Quantity, isnull(Bonus,0) as Bonus
			,ISNULL(Price,0) as Price
			,ISNULL(Discount,0) as Discount,ISNULL(DiscountAmount,0) as DiscountAmount
			,ISNULL(SpecialDiscount,0) as SpecialDiscount,ISNULL(SpecialDiscAmount,0) as SpecialDiscAmount
			,ISNULL(pd.GST,0) as GST,ISNULL(Total,0) as Total
			,DateEntered,EnteredBy,UpdateDate,UpdatedBy,DeletedDate,DeletedBy,IsDeleted,
			p.ProductCode, (p.ProductName + ' ' +s.Strength)as ProductName,
			c.Company
			 FROM 
				PurchaseDetail pd
			join Product p on p.ProductID = pd.ProductID
			join Strength s on s.StrengthID = p.StrengthID
			join Company c on c.CompanyID = pd.CompanyID
			where 
				PurchaseID = @PurchaseID and isnull(pd.IsDeleted,0) <> 1
		end
		
	IF(@ModeType = 'GET_FOR_EDIT')
		begin
			SELECT
			ISNULL(PurchaseID,0) as PurchaseID,ISNULL(pd.CompanyID,0) as CompanyID
			,ISNULL(ProductID,0) as ProductID,ISNULL(BatchNo,'') as BatchNo
			,ISNULL(MfgDate,'') as MfgDate,ISNULL(ExpiryDate,'') as ExpiryDate
			,ISNULL(Quantity,0) as Quantity, isnull(Bonus,0) as Bonus
			,ISNULL(Price,0) as Price
			,ISNULL(Discount,0) as Discount,ISNULL(DiscountAmount,0) as DiscountAmount
			,ISNULL(SpecialDiscount,0) as SpecialDiscount,ISNULL(SpecialDiscAmount,0) as SpecialDiscAmount
			,ISNULL(GST,0) as GST,ISNULL(Total,0) as Total
			,DateEntered,EnteredBy,UpdateDate,UpdatedBy,DeletedDate,DeletedBy,IsDeleted,
			c.Company
			FROM 
				PurchaseDetail pd
				join Company c on c.CompanyID = pd.CompanyID
			WHERE 
				PurchaseDetailID = @PurchaseDetailID and isnull(pd.IsDeleted,0) <> 1
		end
		
	if(@ModeType = 'GetProductIDByBarcode')
		Begin
			declare @pid int
			set @pid = 0
			Select @pid = ProductID from PurchaseDetail where Barcode = @Barcode

			if(@pid = 0)
				Select ProductID from ProductBarcode where Barcode = @Barcode
			else
				Select ProductID from PurchaseDetail where Barcode = @Barcode
		end
	
END
GO
/****** Object:  StoredProcedure [dbo].[SP_PurchaseMaster]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[SP_PurchaseMaster]

@PurchaseID			int = null,
@InvioceNumber		varchar(50)	= null,
@DrugAgency			varchar(50) = null,
@AgencyInvoiceNo	varchar(50) = null,
@InvoiceDate		datetime	= null,
@Remarks			varchar(200)	= null,
@DateEntered		datetime	= null,
@EnteredBy			varchar(50)	= null,
@UpdateDate			datetime	= null,
@UpdatedBy			varchar(50)	= null,
@DeletedDate		datetime	= null,
@DeletedBy			varchar(50)	= null,
@IsDeleted			bit	= null,
@Day				varchar(50) = null,
@Month				varchar(50) = null,
@Year				varchar(50) = null,
@InvoiceImage		varchar(100) = null,
@ModeType			varchar(50) = null,
@Result				varchar(50) = null Output

AS
BEGIN
	IF(@ModeType = 'INSERT')
		begin
			INSERT INTO PurchaseMaster(InvioceNumber,DrugAgency, AgencyInvoiceNo,InvoiceDate,Remarks,
			DateEntered,EnteredBy, InvoiceImage)
			VALUES
			(@InvioceNumber,@DrugAgency, @AgencyInvoiceNo, @InvoiceDate,@Remarks,GETDATE(),@EnteredBy, @InvoiceImage
			)
		end
		
	IF(@ModeType = 'UPDATE')
		begin
			UPDATE PurchaseMaster SET
			InvioceNumber = @InvioceNumber
			,DrugAgency	= @DrugAgency
			,AgencyInvoiceNo = @AgencyInvoiceNo
			,InvoiceDate = @InvoiceDate
			,Remarks =		@Remarks
			,UpdateDate =	GETDATE()
			,UpdatedBy =	@UpdatedBy
			WHERE PurchaseID = @PurchaseID
			
		end
		
	IF(@ModeType = 'DELETE')
		begin
			UPDATE PurchaseMaster SET
			DeletedDate =	@DeletedDate
			,DeletedBy =	@DeletedBy
			,IsDeleted =	1
			WHERE 
				PurchaseID = @PurchaseID
		end
	
	IF(@ModeType = 'DELETE_Complete')
		begin
			DELETE
				PurchaseMaster 
			WHERE 
				PurchaseID = @PurchaseID
		end
	
	IF(@ModeType = 'GET_LIST')
		begin
			SELECT
			PurchaseID,
			ISNULL(InvioceNumber,'') as InvioceNumber
			,ISNULL(DrugAgency,'')DrugAgency
			,ISNULL(AgencyInvoiceNo,'') as AgencyInvoiceNo
			,ISNULL(InvoiceDate,'') as InvoiceDate
			,ISNULL(Remarks,'') as Remarks
			,DateEntered
			,EnteredBy
			,UpdateDate
			,UpdatedBy
			,DeletedDate
			,DeletedBy
			,IsDeleted
			,(Select isnull(sum(total),0) from PurchaseDetail pd where pd.PurchaseID = PurchaseMaster.PurchaseID and isnull(pd.IsDeleted,0) = 0) as TotalAmount,
			IsNull(InvoiceImage,'blankimage.png') as InvoiceImage
			FROM 
				PurchaseMaster
			WHERE IsDeleted = 0 OR IsDeleted IS Null
			order by PurchaseID desc
		end
		
	IF(@ModeType = 'GET_FOR_EDIT')
		begin
			SELECT
			PurchaseID,
			ISNULL(InvioceNumber,'') as InvioceNumber
			,ISNULL(DrugAgency,'')as DrugAgency
			,ISNULL(AgencyInvoiceNo,'') as AgencyInvoiceNo
			,ISNULL(InvoiceDate,'') as InvoiceDate
			,ISNULL(Remarks,'') as Remarks
			,DateEntered
			,EnteredBy
			,UpdateDate
			,UpdatedBy
			,DeletedDate
			,DeletedBy
			,IsDeleted
			,IsNull(InvoiceImage,'blankimage.png') as InvoiceImage
			FROM 
				PurchaseMaster 
			WHERE 
				PurchaseID = @PurchaseID
		end
		
		IF(@ModeType = 'GetMaxPurchaseID')
		begin
			select MAX(PurchaseID) as MaxPurchaseID from PurchaseMaster
		end
		
		IF(@ModeType = 'GetLastPurchaseINVNo')
		BEGIN
			select Right(Max(InvioceNumber),5) as InvioceNumber from PurchaseMaster
			where DAY(DateEntered) = @Day and MONTH(DateEntered) = @Month and YEAR(DateEntered) = @Year
		END
		IF(@ModeType = 'GetNewPurchaseOrderInvoiceNumber')
		BEGIN
			Select [dbo].[UDF_GEN_PurchaseInvoiceNumber]() as PurchaseInvoiceNumber
		END

		IF(@ModeType = 'GetAllDrugAgencyName')
		BEGIN
			select distinct DrugAgency from PurchaseMaster
		END

END


GO
/****** Object:  StoredProcedure [dbo].[sp_PurchaseReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_PurchaseReport]
	@PurchaseID int = null,
	@CompanyID int = null,
	@FromDate date = null,
	@ToDate date = null,
	@ModeType varchar(50) = null
	
AS
BEGIN
	IF(@PurchaseID > 0)
		Begin
			SELECT pm.PurchaseID, pm.InvioceNumber, pm.DrugAgency, pm.AgencyInvoiceNo, 
			convert(varchar, pm.InvoiceDate ,(101))InvoiceDate, pm.Remarks, pm.DateEntered, pm.EnteredBy,
			pd.PurchaseDetailID, pd.BatchNo, 
			(convert(varchar, Month(pd.MfgDate))+'-'+convert(varchar,YEAR(pd.MfgDate)))as MfgDate, 
			(convert(varchar, Month(pd.ExpiryDate))+'-'+convert(varchar,YEAR(pd.ExpiryDate)))as ExpiryDate,
			pd.Quantity, isnull(pd.Bonus,0)as Bonus, pd.Price,pd.Discount, pd.DiscountAmount, pd.SpecialDiscount, pd.SpecialDiscAmount,
			pd.GST, pd.Total, 
			(p.ProductName +' '+s.Strength+ ' '+ pt.ProductType)ProductName, c.Company
			FROM PurchaseMaster pm
			JOIN PurchaseDetail pd ON pm.PurchaseID = pd.PurchaseID
			JOIN Product p ON p.ProductID = pd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			WHERE pm.PurchaseID = @PurchaseID
			and isnull(pm.IsDeleted,0) = 0 
		End
		
	IF(@CompanyID > 0)
		Begin
			SELECT pm.PurchaseID, pm.InvioceNumber, pm.DrugAgency, pm.AgencyInvoiceNo, 
			convert(varchar, pm.InvoiceDate ,(101))InvoiceDate, pm.Remarks, pm.DateEntered, pm.EnteredBy,
			pd.PurchaseDetailID, pd.BatchNo, 
			(convert(varchar, Month(pd.MfgDate))+'-'+convert(varchar,YEAR(pd.MfgDate)))as MfgDate, 
			(convert(varchar, Month(pd.ExpiryDate))+'-'+convert(varchar,YEAR(pd.ExpiryDate)))as ExpiryDate,
			pd.Quantity, isnull(pd.Bonus,0)as Bonus, pd.Price,pd.Discount, pd.DiscountAmount, pd.SpecialDiscount, pd.SpecialDiscAmount,
			pd.GST, pd.Total,
			(p.ProductName +' '+s.Strength+ ' '+ pt.ProductType)ProductName, c.Company
			FROM PurchaseMaster pm
			JOIN PurchaseDetail pd ON pm.PurchaseID = pd.PurchaseID
			JOIN Product p ON p.ProductID = pd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			WHERE c.CompanyID = @CompanyID
			and CONVERT(date, pm.InvoiceDate) Between @FromDate and @ToDate
			and isnull(pm.IsDeleted,0) = 0 
		End
		
	IF(@ModeType = 'PurchaseByDate')
		Begin
			SELECT pm.PurchaseID, pm.InvioceNumber, pm.DrugAgency, pm.AgencyInvoiceNo, 
			convert(varchar, pm.InvoiceDate ,(101))InvoiceDate, pm.Remarks, pm.DateEntered, pm.EnteredBy,
			pd.PurchaseDetailID, pd.BatchNo, 
			(convert(varchar, Month(pd.MfgDate))+'-'+convert(varchar,YEAR(pd.MfgDate)))as MfgDate, 
			(convert(varchar, Month(pd.ExpiryDate))+'-'+convert(varchar,YEAR(pd.ExpiryDate)))as ExpiryDate,
			pd.Quantity, isnull(pd.Bonus,0)as Bonus, pd.Price,pd.Discount, pd.DiscountAmount, pd.SpecialDiscount, pd.SpecialDiscAmount,
			pd.GST, pd.Total,
			(p.ProductName +' '+s.Strength+ ' '+ pt.ProductType)ProductName, c.Company
			FROM PurchaseMaster pm
			JOIN PurchaseDetail pd ON pm.PurchaseID = pd.PurchaseID
			JOIN Product p ON p.ProductID = pd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			WHERE CONVERT(date, pm.InvoiceDate) Between @FromDate and @ToDate
			and isnull(pm.IsDeleted,0) = 0 
		End

		IF(@ModeType = 'MonthlyPurchaseDetail')
		Begin
			SELECT pm.PurchaseID, pm.InvioceNumber, pm.DrugAgency, pm.AgencyInvoiceNo, 
			convert(varchar, pm.InvoiceDate ,(101))InvoiceDate, pm.Remarks, pm.DateEntered, pm.EnteredBy,
			pd.PurchaseDetailID, pd.BatchNo, 
			(convert(varchar, Month(pd.MfgDate))+'-'+convert(varchar,YEAR(pd.MfgDate)))as MfgDate, 
			(convert(varchar, Month(pd.ExpiryDate))+'-'+convert(varchar,YEAR(pd.ExpiryDate)))as ExpiryDate,
			pd.Quantity, isnull(pd.Bonus,0)as Bonus, pd.Price,pd.Discount, pd.DiscountAmount, pd.SpecialDiscount, pd.SpecialDiscAmount,
			pd.GST, pd.Total,
			(p.ProductName +' '+s.Strength+ ' '+ pt.ProductType)ProductName, c.Company
			FROM PurchaseMaster pm
			JOIN PurchaseDetail pd ON pm.PurchaseID = pd.PurchaseID
			JOIN Product p ON p.ProductID = pd.ProductID
			JOIN Strength s ON s.StrengthID = p.StrengthID
			JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
			JOIN Company c ON c.CompanyID = p.CompanyID
			WHERE CONVERT(date, pm.InvoiceDate) Between @FromDate and @ToDate
			and isnull(pm.IsDeleted,0) = 0 
		End


		
		IF(@ModeType = 'MainReport')
		Begin
			SELECT pm.PurchaseID, pm.InvioceNumber, pm.DrugAgency, pm.AgencyInvoiceNo, 
			convert(varchar, pm.InvoiceDate ,(101))InvoiceDate, pm.Remarks, pm.DateEntered, pm.EnteredBy
			FROM PurchaseMaster pm
			WHERE CONVERT(date, pm.InvoiceDate) Between @FromDate and @ToDate
			and isnull(pm.IsDeleted,0) = 0 
		End
		
END
GO
/****** Object:  StoredProcedure [dbo].[sp_PurchaseSummaryReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_PurchaseSummaryReport]
	-- Add the parameters for the stored procedure here			
	@FromDate date = null,
	@ToDate date = null
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select pm.PurchaseID, pm.InvioceNumber, pm.DrugAgency,
		pm.AgencyInvoiceNo, CONVERT(varchar, pm.InvoiceDate,(101))as InvoiceDate
		--, pm.Remarks, SUM(pd.Quantity*pd.Price) as TotalAmount		
		--, pm.Remarks, (SUM(pd.Quantity*pd.Price) - SUM(pd.DiscountAmount)) as TotalAmount	
		, pm.Remarks, SUM(pd.Total) as TotalAmount	
		FROM 
			PurchaseMaster pm
		INNER JOIN 
			PurchaseDetail pd ON pm.PurchaseID = pd.PurchaseID		
		where 
			isnull(pm.IsDeleted,0) = 0 
		and 
			pm.InvoiceDate between @FromDate and @ToDate '
			
	SET @SQLQuery = @SQLQuery + ' group by pm.DrugAgency, pm.PurchaseID, pm.InvioceNumber, pm.AgencyInvoiceNo , pm.InvoiceDate,  pm.Remarks ' 
	
	SET @SQLQuery = @SQLQuery + ' order by pm.InvioceNumber '
	
	
	Set @ParamDefinition =      ' @FromDate DateTime,
                @ToDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition,                               
                @FromDate, 
                @ToDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Rack]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Rack] 
	@RackID int = null,
	@RackNo varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Rack(RackNo)
		VALUES (@RackNo)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Rack SET
		RackNo = @RackNo
		WHERE
			RackID = @RackID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Rack WHERE RackID = @RackID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@RackID > 0)
			SELECT * FROM Rack WHERE RackID = @RackID
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@RackID > 0)
			SELECT * FROM Rack 
			WHERE RackNo = @RackNo AND NOT(RackID = @RackID)
		ELSE
			SELECT * FROM Rack WHERE RackNo = @RackNo
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM Rack 
			WHERE
			RackNo LIKE('%'+@Search+'%')
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Room]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[sp_Room]
	@RoomID int = null,
	@Room varchar(50) = null,
	@RoomType varchar(50) = null,
	@RoomCharges decimal = null,
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Rooms(Room, RoomType, RoomCharges) 
		VALUES (@Room, @RoomType, @RoomCharges)
		
		INSERT INTO RoomStatus(RoomID, RoomStatus) VALUES((SELECT MAX(ROOMID) from Rooms), 'Available')
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Rooms SET 
		Room = @Room,
		RoomType = @RoomType,
		RoomCharges = @RoomCharges
		WHERE RoomID = @RoomID 
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Rooms 
		WHERE RoomID = @RoomID	
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@RoomID > 0)
			SELECT * FROM Rooms r
			JOIN RoomStatus rs on rs.RoomID = r.RoomID 
			WHERE r.RoomID = @RoomID
		else
			SELECT * FROM Rooms r
			JOIN RoomStatus rs on rs.RoomID = r.RoomID 
	END
	
END



GO
/****** Object:  StoredProcedure [dbo].[sp_rptAdmitPatientSummary]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_rptAdmitPatientSummary]
	@FromDate date = null,
	@ToDate Date = null,
	@ModeType varchar(30) = null
AS
BEGIN
	
	if(@ModeType = 'GetAdmitPatient')
		Begin
			SELECT 
				sm.SaleInvoiceNumber, CONVERT(varchar, sm.SaleDate,(101)) SaleDate,
				sm.PatientName, sm.ContactNo, 
				ISNULL(sm.GuardianName,'')as GuardianName, ISNULL(sm.GuardianContactNo,'')as GuardianContactNo,
				sm.RoomNo, sm.Diagnostics,				
				Cast(Round(((SUM(sd.Total) * sd.Discount) /100),0) as Decimal(18,2)) as DiscountAmount,
				SUM(sd.Total)as Total,
				Convert(varchar, @FromDate,(101)) as FromDate, CONVERT(varchar, @ToDate,(101)) as ToDate
			FROM 
				SalesMaster sm
			INNER JOIN 
				SalesDetail sd on sm.SaleID = sd.SaleID
			WHERE 
				sm.SaleType='AdmitPatient'
			AND 
				sm.SaleDate Between @FromDate and @ToDate
			GROUP BY 
				sm.SaleInvoiceNumber, sm.SaleDate, sm.PatientName, sm.ContactNo,sm.GuardianName, 
				sm.GuardianContactNo, sm.RoomNo, sm.Diagnostics, sd.DiscountAmount, sd.Discount
			ORDER BY 
				sm.SaleDate
		END
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_RptDailyOP_DReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_RptDailyOP_DReport]
	-- Add the parameters for the stored procedure here
	@DoctorID int = null,
	@TodayOPD date = null,	
	@StartDate date = null,
	@EndDate date = null
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'SELECT  
		(c.FirstName+'' ''+c.LastName) as DoctorName,
		opd.OPDNumber, opd.PatientName, opd.ContactNo, opd.Age, 
		Convert(varchar,opd.OPDDate,(101))as OPDDate, convert(char(5), opd.OPDDate, 108) as OPDTime,
		opd.Status
	FROM 
		DailyOPD opd 
	INNER JOIN 
		Contact c ON opd.DoctorID = c.ContactID'
		
	if @TodayOPD is not NULL
			SET @SQLQuery = @SQLQuery + ' where CAST(opd.OPDDate as DATE) = CAST(getdate() as DATE) '
	
		
	if((@DoctorID is not null) and (@StartDate is null))
		SET @SQLQuery = @SQLQuery + ' Where DoctorID= @DoctorID and CAST(opd.OPDDate as DATE) = CAST(getdate() as DATE)'
	
	if((@DoctorID is not null) and (@StartDate is not null))
		SET @SQLQuery = @SQLQuery + ' Where DoctorID= @DoctorID and cast(opd.OPDDate as Date) Between @StartDate and @EndDate'
	
	if((@DoctorID is null) and (@StartDate is not null))
		SET @SQLQuery = @SQLQuery + ' Where cast(opd.OPDDate as Date) Between @StartDate and @EndDate'
		
	
	Set @ParamDefinition =      ' @DoctorID int,
                @TodayOPD DateTime,                
                @StartDate DateTime,
                @EndDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @TodayOPD,
                @StartDate, 
                @EndDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_RptDailyOPD]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RptDailyOPD]
	
AS
BEGIN
	
	SELECT  
		(c.FirstName+' '+c.LastName) as DoctorName,
		opd.OPDNumber, opd.PatientName, opd.ContactNo, opd.Age, 
		Convert(varchar,opd.OPDDate,(101))as OPDDate, convert(char(5), opd.OPDDate, 108) as OPDTime,
		opd.Status
	FROM 
		DailyOPD opd 
	INNER JOIN 
		Contact c ON opd.DoctorID = c.ContactID

END


GO
/****** Object:  StoredProcedure [dbo].[sp_RptDailyOPDInvestigationTestReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_RptDailyOPDInvestigationTestReport]
	-- Add the parameters for the stored procedure here
	@DoctorID int = null,
	@TestType varchar(60) = null,	
	@FromDate date = null
		
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select 
						convert(varchar,opt.TestDate,(107))as TestDate, opt.TestNo, opt.PatientName, dt.TestType, dt.TestName,  
						case when Isnull(opt.DoctorName,'''')= '''' then (select firstName+'' ''+LastName From Contact where ContactID = opt.doctorID) 
						else opt.DoctorName end as DoctorName , dt.Charges, opt.Discount, 
						(dt.Charges - opt.Discount) as NetAmount,
						RIGHT(CONVERT(VARCHAR, opt.TestDate, 100), 7) as TestTime ,opt.ContactNo
						From DiagnosticTest dt
						JOIN OutDoorPatientTest opt ON dt.TestID = opt.TestID
						Where Cast(opt.TestDate as Date) = @FromDate '
		
	
	if (@DoctorID IS NOT NULL and @TestType = 'All')
		SET @SQLQuery = @SQLQuery + ' and opt.DoctorID = @DoctorID  '
	
	if (@DoctorID IS NULL  and @TestType <> 'All')
		SET @SQLQuery = @SQLQuery + ' and dt.TestType = @TestType '
	
	
	if (@DoctorID IS NOT NULL and @TestType <> 'All')
		SET @SQLQuery = @SQLQuery + 'and opt.DoctorID = @DoctorID  and dt.TestType = @TestType '
	  
	
	Set @ParamDefinition =      ' @DoctorID int,
                @TestType varchar(60),               
                @FromDate date'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @TestType,                 
                @FromDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END

GO
/****** Object:  StoredProcedure [dbo].[sp_RptEmployeeSalary]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[sp_RptEmployeeSalary]
	-- Add the parameters for the stored procedure here
	@ContactType	varchar(20) = null,
	@Month			int = null,	
	@Year			int = null,
	@StartDate		date = null,
	@EndDate		date = null
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select ct.ContactType, (c.FirstName+'' ''+c.LastName) as EmployeeName, ew.PaymentType, cast(ew.SalaryAmount as decimal) as SalaryAmount, 
						ew.LoanAmount, convert(varchar, ew.SalaryDate, (107)) as SalaryDate, ew.Remarks, c.Mobile
						From EmployeeWages ew 
						JOIN Contact c on ew.ContactID = c.ContactID
						JOIN ContactType ct on c.ContactTypeID = ct.ContactTypeID
						where ew.IsDeleted = 0 '
		
	if @Month > 0
			SET @SQLQuery = @SQLQuery + ' and Month(ew.SalaryDate) = @Month and Year(ew.SalaryDate) = @Year '
	
		SET @SQLQuery = @SQLQuery + ' Order by (c.FirstName+'' ''+c.LastName) '
		
	
	Set @ParamDefinition =      ' @ContactType varchar(20),
                @Month int, 
				@Year  int,               
                @StartDate DateTime,
                @EndDate DateTime'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @ContactType, 
                @Month,
				@Year,
                @StartDate, 
                @EndDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_RptOutDoorPatientTestSummary]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
create PROCEDURE [dbo].[sp_RptOutDoorPatientTestSummary] 
AS
BEGIN
	select convert(varchar,opt.TestDate,(107))as TestDate, dt.TestName,  
	case when Isnull(opt.DoctorName,'')= '' then (select firstName+' '+LastName from Contact where ContactID = opt.doctorID) 
	else opt.DoctorName end as DoctorName ,
	 dt.TestType, dt.Charges, COUNT(opt.TestID) TotalTest ,
	(dt.Charges * COUNT(opt.TestID)) as TotalAmount, opt.Discount,
	((dt.Charges * COUNT(opt.TestID)) - opt.Discount) as NetAmount
	from DiagnosticTest dt
	JOIN OutDoorPatientTest opt ON dt.TestID = opt.TestID 
	group by convert(varchar,opt.TestDate,(107)), opt.DoctorID, opt.DoctorName, dt.TestName, dt.TestType,
	 dt.Charges, opt.Discount
END

GO
/****** Object:  StoredProcedure [dbo].[sp_RptOutDoorPatientTestSummaryReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 
CREATE PROCEDURE [dbo].[sp_RptOutDoorPatientTestSummaryReport]
	-- Add the parameters for the stored procedure here
	@DoctorID int = null,
	@TestType varchar(60) = null,	
	@FromDate date = null,
	@ToDate Date = null 
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select 
			convert(varchar,opt.TestDate,(107))as TestDate, dt.TestName,  
			case when Isnull(opt.DoctorName,'''')= '''' then (select firstName+'' ''+LastName 
			from Contact where ContactID = opt.doctorID) 
			else opt.DoctorName end as DoctorName ,
			 dt.TestType, dt.Charges, COUNT(opt.TestID) TotalTest ,
			(dt.Charges * COUNT(opt.TestID)) as TotalAmount, sum(opt.Discount)as Discount,
			((dt.Charges * COUNT(opt.TestID)) - sum(opt.Discount)) as NetAmount
		From 
			DiagnosticTest dt
		JOIN 
			OutDoorPatientTest opt ON dt.TestID = opt.TestID
		WHERE '
		
	
	if (@DoctorID IS NOT NULL and @TestType = 'All')
		SET @SQLQuery = @SQLQuery + ' opt.DoctorID = @DoctorID  and CAST(opt.TestDate as DATE) between @FromDate and @ToDate '
	
	if (@DoctorID IS NULL  and @TestType <> 'All')
		SET @SQLQuery = @SQLQuery + ' dt.TestType = @TestType and CAST(opt.TestDate as DATE) between @FromDate and @ToDate '
	
	if (@DoctorID IS NULL and @TestType = 'All')
		SET @SQLQuery = @SQLQuery + ' CAST(opt.TestDate as DATE) between @FromDate and @ToDate '
	
	if (@DoctorID IS NOT NULL and @TestType <> 'All')
		SET @SQLQuery = @SQLQuery + 'opt.DoctorID = @DoctorID  and dt.TestType = @TestType and CAST(opt.TestDate as DATE) between @FromDate and @ToDate '
	  
	
	SET @SQLQuery = @SQLQuery + 'group by convert(varchar,opt.TestDate,(107)), opt.DoctorID, opt.DoctorName, dt.TestName, dt.TestType,
	 dt.Charges, opt.Discount'
	
	Set @ParamDefinition =      ' @DoctorID int,
                @TestType varchar(60),               
                @FromDate date,
                @ToDate date'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @TestType,                 
                @FromDate, 
                @ToDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END




GO
/****** Object:  StoredProcedure [dbo].[sp_RptPatientAppointmentOPD]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RptPatientAppointmentOPD]
	
AS
BEGIN
		Select 
			do.OPDID, do.OPDNumber, do.PatientName, do.Age, do.Sex, do.City, do.ContactNo, 
			CONVERT(VARCHAR(11), do.OPDDate, 106) as TokenDate,
			RIGHT(CONVERT(VARCHAR, do.OPDDate, 100), 7) as TokenTime,
			(c.FirstName+ ' '+c.LastName)as DoctorName, 
			df.Fees as OPDFee, isNull(do.Discount,0)as Discount, 
			(df.Fees - Discount) as NetOPDFee, do.Status, 
			case when do.Status ='Cancel' then 0 else df.Fees end as OPDCharges
		From 
			DailyOPD do 
		JOIN 
			Contact c ON do.DoctorID = c.ContactID
		left outer join 
			DoctorFee df ON do.DoctorID = df.DoctorID
		left outer join 
			FeesType ft on df.FeeTypeID = ft.FeeTypeID
END



GO
/****** Object:  StoredProcedure [dbo].[sp_RptPatientAppointmentOPDReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_RptPatientAppointmentOPDReport]
	-- Add the parameters for the stored procedure here
	@DoctorID int = null,
	@TodayOPD date = null,	
	@StartDate date = null,
	@EndDate date = null
	
AS
BEGIN
	Set NoCount ON
	
	/* Variable Declaration */
    Declare @SQLQuery AS NVarchar(4000)
    Declare @ParamDefinition AS NVarchar(2000) 
	
	Set @SQLQuery = N'Select 
			do.OPDID, do.OPDNumber, do.PatientName, do.Age, do.Sex, do.City, do.ContactNo, 
			CONVERT(VARCHAR(11), do.OPDDate, 106) as TokenDate,
			RIGHT(CONVERT(VARCHAR, do.OPDDate, 100), 7) as TokenTime,
			(c.FirstName+ '' ''+c.LastName)as DoctorName, 
			df.Fees as OPDFee, isNull(do.Discount,0)as Discount, 
			(df.Fees - Discount) as NetOPDFee, do.Status, 
			case when do.Status =''Cancel'' then 0 else df.Fees end as OPDCharges
		From 
			DailyOPD do 
		JOIN 
			Contact c ON do.DoctorID = c.ContactID
		INNER JOIN
			DoctorFee df ON do.DoctorID = df.DoctorID
		INNER JOIN
			FeesType ft on df.FeeTypeID = ft.FeeTypeID
		WHERE 
			ft.FeeType = ''OPD'' '
		
	if @TodayOPD is not NULL
			SET @SQLQuery = @SQLQuery + ' and CAST(do.OPDDate as DATE) = CAST(GETDATE() as DATE) '
	
	if ((@DoctorID IS NOT NULL) and (@StartDate is null))
		SET @SQLQuery = @SQLQuery + ' and do.DoctorID = @DoctorID and CAST(do.OPDDate as DATE) = CAST(GETDATE() as DATE) '
		
	if ((@DoctorID IS NULL) and (@StartDate is not null))
		SET @SQLQuery = @SQLQuery + ' and CAST(do.OPDDate as DATE) between @StartDate and @EndDate '
	
	if ((@DoctorID IS not NULL) and (@StartDate is not null))
		SET @SQLQuery = @SQLQuery + ' and do.DoctorID = @DoctorID and CAST(do.OPDDate as DATE) between @StartDate and @EndDate '
	
	
	
	Set @ParamDefinition =      ' @DoctorID int,
                @TodayOPD date,               
                @StartDate date,
                @EndDate date'
	
	
	
	Execute sp_Executesql     @SQLQuery, 
                @ParamDefinition, 
                @DoctorID, 
                @TodayOPD,                 
                @StartDate, 
                @EndDate
	
	If @@ERROR <> 0 GoTo ErrorHandler
    Set NoCount OFF
    Return(0)
  
ErrorHandler:
    Return(@@ERROR)
	
END



GO
/****** Object:  StoredProcedure [dbo].[SP_SalesDetail]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SalesDetail]

@SaleDetailID		int				= null,
@SaleID				int				= null,
@CompanyID			int				= null,
@ProductID			int				= null,
@Quantity			int				= null,
@Price				decimal(18, 2)	= null,
@Discount			int				= null,
@DiscountAmount		decimal(18, 2)	= null,
@SpecialDiscount	int				= null,
@SpecialDisAmount	decimal(18, 2)	= null,
@Total				decimal(18, 2)	= null,
@ModeType			varchar(50)		= null,
@Result				varchar(50)		= null Output

AS
BEGIN
	IF(@ModeType = 'INSERT')
		begin
		INSERT INTO SalesDetail(SaleID,CompanyID,ProductID,Quantity
			,Price,Discount,DiscountAmount,SpecialDiscount,SpecialDisAmount,Total)
		VALUES
			(@SaleID,@CompanyID,@ProductID,@Quantity,@Price,@Discount,@DiscountAmount,
			@SpecialDiscount,@SpecialDisAmount,@Total)
		end
		
	IF(@ModeType = 'UPDATE')
		begin
		UPDATE SalesDetail SET
			SaleID =			@SaleID
			,CompanyID =			@CompanyID
			,ProductID =			@ProductID			
			,Quantity =				@Quantity
			,Price =				@Price
			,Discount =				@Discount
			,DiscountAmount =		@DiscountAmount
			,SpecialDiscount =		@SpecialDiscount
			,SpecialDisAmount =		@SpecialDisAmount
			,Total =				@Total			
		WHERE
			SaleDetailID =		@SaleDetailID
		end
		
	IF(@ModeType = 'UPDATE_Quantity')
		begin
		UPDATE SalesDetail SET
			SaleID =			@SaleID
			,Quantity =				@Quantity
			,Total =				@Total			
		WHERE
			SaleDetailID =		@SaleDetailID
		end
		
	IF(@ModeType = 'DELETE')
		begin
		Delete SalesDetail WHERE SaleDetailID =	@SaleDetailID
		end
		
	IF(@ModeType = 'DELETE_WithSaleID')
		begin
		Delete SalesDetail WHERE SaleID =	@SaleID
		end
		
	IF(@ModeType = 'GET_LIST')
		begin
			SELECT
			ISNULL(SaleID,0) as SaleID,ISNULL(CompanyID,0) as CompanyID
			,ISNULL(ProductID,0) as ProductID			
			,ISNULL(Quantity,0) as Quantity,ISNULL(Price,0) as Price
			,ISNULL(Discount,0) as Discount,ISNULL(DiscountAmount,0) as DiscountAmount
			,ISNULL(SpecialDiscount,0) as SpecialDiscount,ISNULL(SpecialDisAmount,0) as SpecialDisAmount
			,ISNULL(Total,0) as Total			
			 FROM SalesDetail
		end
		
	IF(@ModeType = 'GET_FOR_EDIT')
		BEGIN
			SELECT
			ISNULL(SaleID,0) as SaleID, ISNULL(CompanyID,0) as CompanyID
			,ISNULL(ProductID,0) as ProductID			
			,ISNULL(Quantity,0) as Quantity,ISNULL(Price,0) as Price
			,ISNULL(Discount,0) as Discount,ISNULL(DiscountAmount,0) as DiscountAmount
			,ISNULL(SpecialDiscount,0) as SpecialDiscount,ISNULL(SpecialDisAmount,0) as SpecialDisAmount
			,ISNULL(Total,0) as Total			
			FROM SalesDetail 
			WHERE SaleDetailID = @SaleDetailID
		END
	
	IF(@ModeType = 'GET_SUB_TOTAL')
		BEGIN
		if(@SaleID > 0)
			SELECT ISNULL(Sum(Total),0) as SubTotal	FROM SalesDetail  WHERE SaleID = @SaleID
		END

	IF(@ModeType = 'GET_Discount')
		BEGIN
		if(@SaleID > 0)
			select top 1 Discount from SalesDetail where SaleID = @SaleID
		END

	IF(@ModeType = 'SaleReturnByDetailID')
		BEGIN
			declare @qty int
			set @qty = (Select Quantity from SalesDetail where SaleDetailID = @SaleDetailID)
			if(@qty = @Quantity)
				delete from SalesDetail where SaleDetailID = @SaleDetailID
			else
				update SalesDetail set Quantity = (Quantity - @Quantity), Discount = @Discount, Total = (Quantity - @Quantity) * Price where SaleDetailID = @SaleDetailID
		END
END

GO
/****** Object:  StoredProcedure [dbo].[SP_SalesMaster]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_SalesMaster]

@SaleID				int			= null,
@SaleInvoiceNumber	varchar(50)	= null,
@PatientID			int = null,
@DoctorID			int = null,
@SaleDate			datetime	= null,
@SaleType			varchar(50)	= null,
@Search				nvarchar(100) = '',
@DateEntered		datetime	= null,
@EnteredBy			varchar(50)	= null,
@UpdateDate			datetime	= null,
@UpdatedBy			varchar(50)	= null,
@DeletedDate		datetime	= null,
@DeletedBy			varchar(50)	= null,
@IsDeleted			bit	= null,
@ModeType			varchar(50) = null,
@Day				varchar(50) = null,
@Month				varchar(50) = null,
@Year				varchar(50) = null,
@Result				nvarchar(50)= null Output

AS
BEGIN
	IF(@ModeType = 'INSERT')
		begin
			INSERT INTO SalesMaster(SaleInvoiceNumber,PatientID, DoctorID, SaleDate,
			SaleType, DateEntered,EnteredBy,IsDeleted)
			VALUES
			(@SaleInvoiceNumber, @PatientID, @DoctorID, @SaleDate, 
			@SaleType,  GETDATE(), @EnteredBy, 0)
		end
		
	IF(@ModeType = 'UPDATE')
		begin
			UPDATE SalesMaster SET
			SaleInvoiceNumber = @SaleInvoiceNumber
			,PatientID = @PatientID
			,DoctorID = @DoctorID
			,SaleDate = @SaleDate
			,SaleType = @SaleType			
			,UpdateDate =	GETDATE()
			,UpdatedBy =	@UpdatedBy
			WHERE SaleID = @SaleID
			
		end

	IF(@ModeType = 'UPDATEDoctor')
		begin
			UPDATE SalesMaster SET			
			DoctorID = @DoctorID				
			,UpdateDate =	GETDATE()
			,UpdatedBy =	@UpdatedBy
			WHERE SaleID = @SaleID
			
		end
		
		
	IF(@ModeType = 'DELETE')
		begin
			UPDATE SalesMaster SET
			DeletedDate =	GETDATE()
			,DeletedBy =	@DeletedBy
			,IsDeleted =	1
			WHERE SaleID = @SaleID
		end	
	
		
	IF(@ModeType = 'GET')
		begin
			SELECT
			ISNULL(SaleInvoiceNumber,'') as InvioceNumber,ISNULL(SaleDate,'') as SaleDate
			,ISNULL(Remarks,'') as Remarks, 
			PatientName, ContactNo, GuardianName, GuardianContactNo, RoomNo, Diagnostics
			,DateEntered,EnteredBy,UpdateDate,UpdatedBy,DeletedDate,DeletedBy,IsDeleted,
			isnull(DoctorID, 8) as DoctorID
			 FROM SalesMaster
			where SaleID = @SaleID
		end
		
	IF(@ModeType = 'GET_LIST')
		begin
			SELECT
			ISNULL(SaleInvoiceNumber,'') as InvioceNumber,ISNULL(SaleDate,'') as SaleDate
			,ISNULL(Remarks,'') as Remarks
			,DateEntered,EnteredBy,UpdateDate,UpdatedBy,DeletedDate,DeletedBy,IsDeleted
			 FROM SalesMaster
		end
		
	IF(@ModeType = 'GET_FOR_EDIT')
		begin
			SELECT
			ISNULL(SaleInvoiceNumber,'') as InvioceNumber, isnull(PatientID,0)as PatientID, 
			ISNULL(SaleDate,'') as SaleDate
			,SaleType, ISNULL(PatientName,'') PatientName, isnull(ContactNo,'')ContactNo
			, isnull(GuardianName,'')GuardianName, isnull(GuardianContactNo,'')GuardianContactNo
			, isnull(RoomNo,'')RoomNo
			, ISNULL(Diagnostics,'') Diagnostics
			,ISNULL(Remarks,'') as Remarks
			,DateEntered,EnteredBy,UpdateDate,UpdatedBy,DeletedDate,DeletedBy,IsDeleted
			FROM SalesMaster 
			WHERE SaleID = @SaleID
		end
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM SalesMaster 
			WHERE
			SaleID LIKE('%'+@Search+'%') OR 
			SaleInvoiceNumber LIKE('%'+@Search+'%') OR
			SaleDate LIKE('%'+@Search+'%') OR
			Remarks LIKE('%'+@Search+'%')
	END
	
	IF(@ModeType = 'GetMaxID')
		BEGIN
			SELECT  convert(varchar, max(SaleID)) as MAXSaleID From SalesMaster
		END
		
	IF(@ModeType = 'GetLastINVNO')
		BEGIN
			select Right(Max(SaleInvoiceNumber),5) as MaxSaleInvNo from SalesMaster
			where DAY(SaleDate) = @Day and MONTH(SaleDate) = @Month and YEAR(SaleDate) = @Year
		END
	
	if(@ModeType = 'GetAdmitPatientList')
		begin
			--Select sm.SaleID, sm.SaleInvoiceNumber, ISNULL(sm.PatientID,0)as PatientID,
			--sm.PatientName, sm.ContactNo, sm.GuardianName, 
			--isnull(sm.GuardianContactNo,'')GuardianContactNo,isnull(sm.RoomNo,'')RoomNo, 
			--ISNULL(Diagnostics,'') as Diagnostics,
			--SUM(sd.Total) as NetAmount
			--FROM 
			--	SalesMaster sm
			--JOIN 
			--	SalesDetail sd ON sm.SaleID = sd.SaleID
			--WHERE 
			--	sm.SaleType='AdmitPatient'
			--GROUP BY 
			--	sm.SaleID, sm.SaleInvoiceNumber,sm.PatientName, sm.ContactNo, sm.GuardianName,
			--	sm.GuardianContactNo,sm.RoomNo, Diagnostics, sm.PatientID
			--order by sm.SaleID desc
			
			Select sm.SaleID, sm.SaleInvoiceNumber, ISNULL(sm.PatientID,0)as PatientID,
			ISNULL(pr.PatientRegNo,'')as PatientRegNo,
			case when IsNull(sm.PatientName,'') = '' then (pr.FirstName+' '+pr.LastName) else sm.PatientName end as PatientName, 
			case when IsNull(sm.ContactNo,'') = '' then pr.MobileNo else sm.ContactNo end as ContactNo, 
			sm.GuardianName, 
			isnull(sm.GuardianContactNo,'')GuardianContactNo,isnull(sm.RoomNo,'')RoomNo, 
			ISNULL(Diagnostics,'') as Diagnostics,
			SUM(sd.Total) as NetAmount
			FROM 
			SalesMaster sm
			JOIN 
			SalesDetail sd ON sm.SaleID = sd.SaleID
			Left Outer JOIN PatientRegistration pr ON sm.PatientID = pr.PatientID
			WHERE 
			sm.SaleType='AdmitPatient'
			GROUP BY 
			sm.SaleID, sm.SaleInvoiceNumber,sm.PatientName, sm.ContactNo, sm.GuardianName,
			sm.GuardianContactNo,sm.RoomNo, Diagnostics, sm.PatientID, pr.FirstName,pr.LastName, PatientRegNo,
			pr.MobileNo
			order by sm.SaleID desc
			
		end


		
	if(@ModeType = 'GetOPDSaleList')
		begin
			Select sm.SaleID, sm.SaleInvoiceNumber, ISNULL(sm.PatientID,0)as PatientID,
			ISNULL(pr.PatientRegNo,'')as PatientRegNo,
			case when IsNull(sm.PatientName,'') = '' then (pr.FirstName+' '+pr.LastName) else sm.PatientName end as PatientName, 
			case when IsNull(sm.ContactNo,'') = '' then pr.MobileNo else sm.ContactNo end as ContactNo, 
			sm.GuardianName, 
			isnull(sm.GuardianContactNo,'')GuardianContactNo,isnull(sm.RoomNo,'')RoomNo, 
			ISNULL(Diagnostics,'') as Diagnostics,
			--SUM(sd.Total) as NetAmount, sm.SaleDate
			SUM(sd.Quantity * sd.Price) - sum(((sd.Quantity * sd.Price) * sd.Discount) / 100) as NetAmount, sm.SaleDate,
			(con.FirstName + ' '+con.LastName) as DoctorName
			FROM 
			SalesMaster sm
			JOIN 
			SalesDetail sd ON sm.SaleID = sd.SaleID 
			Left Outer JOIN PatientRegistration pr ON sm.PatientID = pr.PatientID
			Left Outer JOIN Contact con on sm.DoctorID = con.ContactID
			WHERE 
			sm.SaleType='OPD'
			GROUP BY 
			sm.SaleID, sm.SaleInvoiceNumber,sm.PatientName, sm.ContactNo, sm.GuardianName,
			sm.GuardianContactNo,sm.RoomNo, Diagnostics, sm.PatientID, pr.FirstName,pr.LastName, PatientRegNo,
			pr.MobileNo, sm.SaleDate, con.FirstName, con.LastName
			order by sm.SaleID desc
			
		end

	IF(@ModeType = 'GetNewSaleInvoiceNumber')
		BEGIN
			Select [dbo].[UDF_GEN_SaleInvoiceNumber]() as SaleInvoiceNumber
		END

		IF(@ModeType = 'GetSaleInvoiceByInvoiceNumber')
		BEGIN
			Select sm.SaleID, sd.SaleDetailID, sd.ProductID,
			p.ProductName, sd.Price, sd.Quantity, sd.Total
			from SalesMaster sm
			JOIN SalesDetail sd on sm.SaleID = sd.SaleID
			JOIN Product p on sd.ProductID = p.ProductID
			where SaleInvoiceNumber = @SaleInvoiceNumber
		END

		IF(@ModeType = 'GetInvoiceInfor')
		BEGIN
			Select sm.SaleID, sm.PatientName, sm.ContactNo, 
			--cast(Round(sum(((sd.Price * sd.Quantity) * sd.Discount) / 100),0) as decimal(18,2)) as Amount, 
			cast(Round(sum(sd.Quantity * sd.Price) ,0) as decimal(18,2)) as Amount,
			sd.Discount , 
			Round(sum(((sd.Price * sd.Quantity) * sd.Discount) / 100),0) as DiscountAmount,
			Round(sum(sd.Price * sd.Quantity) - sum(((sd.Price * sd.Quantity) * sd.Discount) / 100),0) as InvoiceAmount
			from SalesMaster sm
			JOIN SalesDetail sd on sm.SaleID = sd.SaleID
			JOIN Product p on sd.ProductID = p.ProductID
			where SaleInvoiceNumber = @SaleInvoiceNumber 
			group by sm.SaleID,sm.PatientName, sm.ContactNo, sd.Discount
		END
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SalesReports]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_SalesReports]
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	select sm.SaleID,sm.SaleInvoiceNumber,sm.SaleDate,sm.Remarks, 
	sd.SaleDetailID,sd.Quantity, sd.Price , sd.Discount, sd.DiscountAmount , sd.SpecialDiscount, sd.SpecialDisAmount,
	sd.Total , (sd.Price * sd.Quantity) as TotalAmount, 
	c.CompanyID, c.Company,
	p.ProductID,p.ProductName, p.ProductCode, 
	pt.ProductTypeID, pt.ProductType,
	s.StrengthID, s.Strength
	from SalesMaster sm
	JOIN SalesDetail sd ON sm.SaleID = sd.SaleID
	Left JOIN Company c ON c.CompanyID = sd.CompanyID
	Left JOIN Product p ON p.ProductID = sd.ProductID 
	Left JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
	Left JOIN Strength s ON s.StrengthID = p.StrengthID 

END


GO
/****** Object:  StoredProcedure [dbo].[SP_SaleViewModel]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SP_SaleViewModel]
	 @ProductType		varchar(50)		= null,
     @ProductID			int				= null,
     @CompanyID			int				= null,
     @Company			varchar(50)		= null,
     @ProductTypeID		int				= null,
     @ProductName		varchar(50)		= null,
     @ProductCode		varchar(50)		= null,
     @ProductRegNo		varchar(50)		= null,
     @Formula			varchar(50)		= null,
     @StrengthID		int				= null,
     @Strength			varchar(50)		= null,
     @UnitPrice			decimal			= null,
     @SaleID			int				= null,
     @SaleInvoiceNumber varchar(100)	= null,
     @PatientID			int				= null,
     @SaleDate			DateTime		= null,
     
     @SaleType			varchar(50)		= null,
     @PatientName		varchar(50)		= null,
     @ContactNo			varchar(50)		= null,
     @GuardianName		varchar(50)		= null,
     @GuardianContactNo	varchar(50)		= null,
     @RoomNo			varchar(20)		= null,
     @Diagnostics		varchar(100)	= null,
     
     @Remarks			varchar(100)	= null,
     @SaleDetailID		int				= null,
     @Quantity			int				= null,
     @Price				decimal			= null,
     @Discoun			int				= null,
     @DiscountAmount	decimal			= null,
     @SpecialDiscount	int				= null,
     @SpecialDisAmount	decimal			= null,
     @Total				decimal			= null,
     @ModeType			varchar(100)	= null
AS
BEGIN
	IF (@ModeType = 'GET_ALL_DATA')
		BEGIN
			--SELECT
			--	* FROM SalesMaster SM
			--	LEFT JOIN SalesDetail SD ON SM.SaleID = SD.SaleID
			--	LEFT JOIN Company C ON C.CompanyID = SD.CompanyID
			--	LEFT JOIN Product P ON P.ProductID = SD.ProductID
			--	LEFT JOIN ProductType PT ON PT.ProductTypeID = P.ProductTypeID
			--	LEFT JOIN Strength S ON S.StrengthID = P.StrengthID
			--WHERE SM.SaleID = @SaleID
			
			SELECT --right(SaleInvoiceNumber, 5) as SaleInvoiceNumber, 
				sm.* ,
				ISNULL(sd.SaleDetailID,0)as SaleDetailID, ISNULL(sd.SaleID,0)as SaleID,
				ISNULL(sd.CompanyID,0)as CompanyID, ISNULL(sd.ProductID,0)as ProductID,
				ISNULL(sd.Quantity,0)as Quantity, ISNULL(sd.Price,0)as Price,
				ISNULL(sd.Discount,0)as Discount, ISNULL(sd.DiscountAmount,0)as DiscountAmount,
				ISNULL(sd.SpecialDiscount,0)as SpecialDiscount, ISNULL(sd.SpecialDisAmount,0)as SpecialDisAmount,
				ISNULL(sd.Total,0)as Total,
				ISNULL(c.CompanyID,0)as CompanyID, ISNULL(c.Company,'')as Company,
				ISNULL(p.ProductName,'')as ProductName, ISNULL(p.Formula,'')as Formula, ISNULL(p.ProductCode,'')as ProductCode,
				ISNULL(p.ProductRegNo,'')as ProductRegNo, ISNULL(p.UnitPrice,0)as UnitPrice,
				ISNULL(pt.ProductTypeID,0)as ProductTypeID, ISNULL(pt.ProductType,'')as ProductType,
				ISNULL(s.StrengthID,0)as StrengthID, ISNULL(s.Strength,'')as Strength				
				FROM SalesMaster SM
				LEFT outer JOIN SalesDetail SD ON SM.SaleID = SD.SaleID
				LEFT outer JOIN Company C ON C.CompanyID = SD.CompanyID
				LEFT outer JOIN Product P ON P.ProductID = SD.ProductID
				LEFT outer JOIN ProductType PT ON PT.ProductTypeID = P.ProductTypeID
				LEFT outer JOIN Strength S ON S.StrengthID = P.StrengthID
				WHERE SM.SaleID = @SaleID
			
	END
	
	IF(@ModeType = 'GetProductByIDOrName')
		 BEGIN
		   SELECT  p.ProductID, p.CompanyID
		   ,ISNULL(c.Company,'') as Company, p.ProductTypeID
		   ,ISNULL(pt.ProductType,'') as ProductType
		   ,ISNULL(p.ProductName,'') as ProductName
		   ,ISNULL(p.ProductCode,0) as ProductCode
		   ,ISNULL(p.ProductRegNo,0) as ProductRegNo
		   ,ISNULL(p.Formula,'') as Formula
		   ,p.StrengthID ,ISNULL(st.Strength,'') as Strength
		   ,ISNULL(p.UnitPrice,0) as UnitPrice
		   FROM Product p
		   LEFT JOIN Company c ON c.CompanyID = p.CompanyID
		   LEFT JOIN ProductType pt ON pt.ProductTypeID = p.ProductTypeID
		   LEFT JOIN Strength st ON st.StrengthID = p.StrengthID
		   WHERE
		   p.ProductID = @ProductID
		   OR
		   (p.ProductName = @ProductName 
		   AND
		   pt.ProductType = @ProductType
		   AND
		   st.Strength = @Strength) 
	END
	
	if(@ModeType = 'GetAllIndoorPatientMedicine')
		begin
			SELECT
				sm.* ,
				ISNULL(sd.SaleDetailID,0)as SaleDetailID, ISNULL(sd.SaleID,0)as SaleID,
				ISNULL(sd.CompanyID,0)as CompanyID, ISNULL(sd.ProductID,0)as ProductID,
				ISNULL(sd.Quantity,0)as Quantity, ISNULL(sd.Price,0)as Price,
				ISNULL(sd.Discount,0)as Discount, ISNULL(sd.DiscountAmount,0)as DiscountAmount,
				ISNULL(sd.SpecialDiscount,0)as SpecialDiscount, ISNULL(sd.SpecialDisAmount,0)as SpecialDisAmount,
				ISNULL(sd.Total,0)as Total,
				ISNULL(c.CompanyID,0)as CompanyID, ISNULL(c.Company,'')as Company,
				ISNULL(p.ProductName,'')as ProductName, ISNULL(p.Formula,'')as Formula, ISNULL(p.ProductCode,'')as ProductCode,
				ISNULL(p.ProductRegNo,'')as ProductRegNo, ISNULL(p.UnitPrice,0)as UnitPrice,
				ISNULL(pt.ProductTypeID,0)as ProductTypeID, ISNULL(pt.ProductType,'')as ProductType,
				ISNULL(s.StrengthID,0)as StrengthID, ISNULL(s.Strength,'')as Strength
				FROM SalesMaster SM
				LEFT outer JOIN SalesDetail SD ON SM.SaleID = SD.SaleID
				LEFT outer JOIN Company C ON C.CompanyID = SD.CompanyID
				LEFT outer JOIN Product P ON P.ProductID = SD.ProductID
				LEFT outer JOIN ProductType PT ON PT.ProductTypeID = P.ProductTypeID
				LEFT outer JOIN Strength S ON S.StrengthID = P.StrengthID
				WHERE sm.PatientID = @PatientID
		
		end
		
	
END


GO
/****** Object:  StoredProcedure [dbo].[sp_StockChecking]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[sp_StockChecking]
	@CompanyID int
AS
BEGIN
	if(@CompanyID > 0 )
			SELECT p.ProductID, (p.ProductName+' '+ s.Strength)as ProductName ,  C.Company,
			ISNULL(os.Quantity,0) OpeningStockQty,
			isnull(SUM(pd.Quantity),0) as PurchaseQuantity, (isnull(sd.Quantity,0) - SUM(ISNULL(pr.Quantity,0))) as SaleQuantity, 
			isnull(((isnull(os.Quantity,0) + SUM(isnull(pd.Quantity,0)) + SUM(ISNULL(pr.Quantity,0)) - isnull(sd.Quantity,0) - ISNULL(Drugpr.Quantity,0)) ),0)as StockQuantity
			FROM 
				Product p 
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				Company c ON c.CompanyID = p.CompanyID
			LEFT JOIN 
				OpeningStock os ON p.ProductID = os.ProductID
			LEFT JOIN 
				(select SUM(Quantity) as Quantity, productID from ProductReturn where ReturnType in('Admit Patient','OPD') group by productID) pr ON p.ProductID = pr.ProductID
			LEFT JOIN 
				(select SUM(Quantity) as Quantity, productID from ProductReturn where ReturnType in('Drug Agency') group by productID) Drugpr ON p.ProductID = Drugpr.ProductID
			LEFT JOIN
				 (select isnull(sum(Quantity),0)as Quantity, ProductID from  PurchaseDetail pdd JOIN PurchaseMaster pmm ON pmm.PurchaseID = pdd.PurchaseID group by pdd.ProductID) pd ON p.ProductID = pd.ProductID
			LEFT JOIN
				 (select isnull(sum(Quantity),0)as Quantity, ProductID from  SalesDetail sdd JOIN SalesMaster smm ON smm.SaleID = sdd.SaleID group by sdd.ProductID) sd ON p.ProductID = sd.ProductID
			WHERE 
				p.CompanyID = @CompanyID
			GROUP BY 
				p.ProductID, p.ProductName, s.Strength,sd.Quantity,  C.Company, os.Quantity, Drugpr.Quantity
	else
			SELECT p.ProductID, (p.ProductName+' '+ s.Strength)as ProductName ,  C.Company,
			ISNULL(os.Quantity,0) OpeningStockQty,
			isnull(SUM(pd.Quantity),0) as PurchaseQuantity, (isnull(sd.Quantity,0) - SUM(ISNULL(pr.Quantity,0))) as SaleQuantity,
			isnull(((isnull(os.Quantity,0) + SUM(isnull(pd.Quantity,0)) + SUM(ISNULL(pr.Quantity,0)) - isnull(sd.Quantity,0) - ISNULL(Drugpr.Quantity,0)) ),0)as StockQuantity
			FROM 
				Product p 
			JOIN 
				Strength s ON s.StrengthID = p.StrengthID
			JOIN 
				Company c ON c.CompanyID = p.CompanyID
			LEFT JOIN 
				OpeningStock os ON p.ProductID = os.ProductID
			LEFT JOIN 
				(select SUM(Quantity) as Quantity, ProductID from ProductReturn where ReturnType in('Admit Patient','OPD') group by ProductID) pr ON p.ProductID = pr.ProductID
			LEFT JOIN 
				(select SUM(Quantity) as Quantity, productID from ProductReturn where ReturnType in('Drug Agency') group by productID) Drugpr ON p.ProductID = Drugpr.ProductID
			LEFT JOIN
				(select isnull(sum(Quantity),0)as Quantity, ProductID from  PurchaseDetail pdd JOIN PurchaseMaster pmm ON pmm.PurchaseID = pdd.PurchaseID group by pdd.ProductID) pd ON p.ProductID = pd.ProductID
			LEFT JOIN
				(select isnull(sum(Quantity),0)as Quantity, ProductID from  SalesDetail sdd JOIN SalesMaster smm ON smm.SaleID = sdd.SaleID group by sdd.ProductID) sd ON p.ProductID = sd.ProductID		
			GROUP BY 
				p.ProductID, p.ProductName, s.Strength,sd.Quantity,  C.Company, os.Quantity, Drugpr.Quantity
END


GO
/****** Object:  StoredProcedure [dbo].[sp_StoreInformation]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create PROCEDURE [dbo].[sp_StoreInformation] 
	@StoreID int = null,
	@StoreName varchar(50) = null,
	@OwnerName varchar(50) = null,
	@Address varchar(50) = null,
	@MobileNo varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO StoreInformation(StoreName, OwnerName, Address, MobileNo)
		VALUES (@StoreName, @OwnerName, @Address, @MobileNo)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE StoreInformation SET
		StoreName = @StoreName,
		OwnerName = @OwnerName,
		Address = @Address,
		MobileNo = @MobileNo
		WHERE
			StoreID = @StoreID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM StoreInformation WHERE StoreID = @StoreID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@StoreID > 0)
			SELECT * FROM StoreInformation WHERE StoreID = @StoreID
	END
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM StoreInformation
			WHERE
			StoreName LIKE('%'+@Search+'%') OR
			OwnerName LIKE('%'+@Search+'%') OR 
			Address  LIKE('%'+@Search+'%') OR 
			MobileNo LIKE('%'+@Search+'%') 
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_Strength]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Strength] 
	@StrengthID int = null,
	@Strength varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Strength(Strength)
		VALUES (@Strength)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Strength SET
		Strength = @Strength
		WHERE
			StrengthID = @StrengthID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Strength WHERE StrengthID = @StrengthID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@StrengthID > 0)
			SELECT * FROM Strength WHERE StrengthID = @StrengthID
	END
	
	IF(@ModeType = 'CHECK')
	BEGIN
		IF(@StrengthID > 0)
			SELECT * FROM Strength 
			WHERE Strength = @Strength AND NOT(StrengthID = @StrengthID)
		ELSE
			SELECT * FROM Strength WHERE Strength = @Strength
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM Strength 
			WHERE
			Strength LIKE('%'+@Search+'%')
	END
		
END


GO
/****** Object:  StoredProcedure [dbo].[sp_SupplierLedger]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[sp_SupplierLedger]
@LedgerID bigint = null,
@PayableID int = null,
@PartyName varchar(100) = null,
@TransactionID int = null,
@AccountID int = null,
@TransactionDetail varchar(500) = null,
@ReceiveableID int = null,
@TransactionDate datetime = null,
@Credit decimal(18,2) = null,
@Debit decimal(18,2) = null,
@TransactionType char(20) = null,
@PaymentType varchar(20) = null,
@ModeType nvarchar(100) = null
AS
BEGIN

--IF(@ModeType = 'INSERT')
--BEGIN
-- INSERT INTO TransactionLedger(PayableID, ReceiveableID, TransactionDate, Credit, Debit, TransactionType)
-- VALUES (@PayableID, @ReceiveableID, @TransactionDate, @Credit, @Debit, @TransactionType)
--END
declare @CurrentBalance decimal(18,2)

set @CurrentBalance = 0;

/*

IF(@ModeType = 'InsertPayments')
BEGIN

Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyID = @PartyID Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyID, TransactionType, AccountID, PaymentType, TransactionDetail, TransactionDate, Credit, Balance)
Values (@PartyID, @TransactionType, @AccountID, @PaymentType, @TransactionDetail, @TransactionDate, @Credit, @CurrentBalance + @Credit)
END

IF(@ModeType = 'InsertOpeningBalancePayment')
BEGIN

Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyID = @PartyID Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyID, TransactionType, AccountID, PaymentType, TransactionDetail, TransactionDate, Debit, Balance)
Values (@PartyID, @TransactionType, @AccountID, @PaymentType, @TransactionDetail, @TransactionDate, @Debit, @CurrentBalance - @Debit)
END

IF(@ModeType = 'Insert_Claim_Credit')
BEGIN

Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyID = @PartyID Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyID, TransactionType, TransactionID, PaymentType, TransactionDetail, TransactionDate, Credit, Balance)
Values (@PartyID, @TransactionType, @TransactionID, @PaymentType, @TransactionDetail, @TransactionDate, @Credit, @CurrentBalance + @Credit)
END


IF(@ModeType = 'InsertPO_Payments')
BEGIN
Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyID = @PartyID Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyID, AccountID, TransactionType, PaymentType, TransactionDetail, TransactionDate, Debit, Balance)
Values (@PartyID, @AccountID, @TransactionType, @PaymentType,  @TransactionDetail, @TransactionDate, @Debit, @CurrentBalance - @Debit)


END


IF(@ModeType = 'TransferStockPayment')
BEGIN

Declare @TransDetailText varchar(100)
Set @TransDetailText = 'Stock transfered on behalf of Invoice # ' + (Select InvoiceNumber From TransferMaster Where TransferID = @TransactionID)

-- Inserting Credit amount for customer who transfer the stock
Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyID = @PartyID Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyID,TransactionID,TransactionType, TransactionDetail, TransactionDate, Credit, Balance)
Values (@PartyID, @TransactionID,@TransactionType, @TransDetailText, @TransactionDate, @Credit, @CurrentBalance + @Credit)

-- Inserting amount in Debit for whom stock was transfered
Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyID = (Select DistributionID From TransferMaster Where TransferID = @TransactionID) Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyID, TransactionID,TransactionType, TransactionDetail, TransactionDate, Debit, Balance)
Values ((Select DistributionID From TransferMaster Where TransferID = @TransactionID), @TransactionID, @TransactionType, @TransDetailText, @TransactionDate, @Credit, @CurrentBalance - @Credit)
END

*/

IF(@ModeType = 'InsertPO_Payments')
BEGIN
Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyName = @PartyName Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyName, AccountID, TransactionType, PaymentType, TransactionDetail, TransactionDate, Debit, Balance)
Values (@PartyName, @AccountID, @TransactionType, @PaymentType,  @TransactionDetail, @TransactionDate, @Debit, @CurrentBalance - @Debit)


END

If(@ModeType = 'InsertDistributionPurchaseEntry')
Begin
Set @CurrentBalance = (Select Top 1 ISNULL(Balance,0) From SupplierLedger Where PartyName = @PartyName Order By LedgerID DESC)

if(@CurrentBalance is null)
set @CurrentBalance = 0;

Insert Into SupplierLedger(PartyName, TransactionID, TransactionDetail, TransactionType, TransactionDate, Credit, Balance)
Values(@PartyName, @TransactionID, @TransactionDetail, @TransactionType, @TransactionDate, @Credit, @CurrentBalance + @Credit)
End

IF(@ModeType = 'UPDATE')
BEGIN
UPDATE SupplierLedger SET
--PayableID = @PayableID,
--ReceiveableID = @ReceiveableID,
TransactionDate = @TransactionDate,
Credit = @Credit,
Debit = @Debit,
TransactionType = @TransactionType
WHERE TransactionID = @TransactionID
END

	if(@ModeType = 'UpdateTransactionLedgerBySupplier')
		begin
			update SupplierLedger 
			set TransactionDate = @TransactionDate
			,Credit = @Credit
			where TransactionID= @TransactionID 
			and PartyName = @PartyName 
			and TransactionType = @TransactionType
		end

		if(@ModeType = 'UpdateTransactionLedgerByDistributor')
		begin
			update SupplierLedger 
			set TransactionDate = @TransactionDate
			,Debit = @Debit
			where TransactionID= @TransactionID 
			and PartyName = @PartyName 
			and TransactionType = @TransactionType
		end



	IF(@ModeType = 'DELETE')
		BEGIN
			DELETE FROM SupplierLedger WHERE LedgerID = @LedgerID
		END

	IF(@ModeType = 'GET')
		BEGIN
			IF(@TransactionID > 0)
				SELECT * FROM SupplierLedger WHERE TransactionID = @TransactionID
			else
				SELECT * FROM SupplierLedger
			END
	
	IF(@ModeType = 'GetAllPayments')
		Select tl.LedgerID,  tl.TransactionDate, tl.TransactionType, ISNULL(tl.PaymentType,'') as PaymentType,  TL.TransactionDetail, 
		isnull(tl.Debit,0)as Debit, isnull(tl.Credit,0)as Credit, 
		
		PM.DrugAgency  as CustomerName,

		case when tl.TransactionType = 'Purchase' then  'PV' 
		when TL.TransactionType = 'Claim' then 'CV' 
		when tl.TransactionType IN('Online Payment','Cheque','Cash') then 'BR'  
		when TL.TransactionType = 'Stock Transfer' then 'TV' 
		else  'SV' end as VoucherType, 

		case when tl.TransactionType = 'Purchase' then   PM.InvioceNumber		
		when tl.TransactionType IN('Online Payment','Cheque','Cash') then tl.PaymentType
		else  PM.InvioceNumber end as VoucherNo, 
		case when isnull(TL.Debit, 0) = 0 then 'CR' else 'DR' end as TransType,

		upper(case when tl.TransactionType like '%Purchase%' then   TL.TransactionDetail		
		when tl.TransactionType IN('Cheque','Online') then tl.PaymentType
		when tl.TransactionType IN('Cash') then tl.TransactionDetail
		else  TL.TransactionDetail end) as Description, 

		''  as CityName
		FROM SupplierLedger tl 
			
		Join 
		PurchaseMaster PM on PM.DrugAgency = TL.PartyName
		
		where tl.TransactionType in('Cash','Cheque','Online','Opening Balance')
			
	END

GO
/****** Object:  StoredProcedure [dbo].[SP_SupplierLedgerReport]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[SP_SupplierLedgerReport]
	@PartyName varchar(100) = null,
	@FromDate varchar(100) = null,
	@Todate varchar(100) = null
AS
BEGIN

Select tl.TransactionDate, tl.TransactionType, ISNULL(tl.PaymentType,'') as PaymentType,  TL.TransactionDetail, 
isnull(tl.Debit,0)as Debit, isnull(tl.Credit,0)as Credit, 

SUM(coalesce(y.debit, 0) - coalesce(y.credit, 0))  AS Balance,

tl.PartyName  as CustomerName, 

case when tl.TransactionType = 'Purchase' then  'PV'
when tl.TransactionType IN('Online','Cheque', 'Cash') then 'BP' 
when TL.TransactionType = 'Opening Balance' then 'BL' 
else  'PV' end as VoucherType,  

case when tl.TransactionType = 'Purchase' then   PM.InvioceNumber
when tl.TransactionType IN('Online','Cheque','Cash') then tl.TransactionType
when tl.TransactionType IN('Opening Balance') then 'Balance'
 else  PM.InvioceNumber end as VoucherNo, 

case when isnull(TL.Debit, 0) = 0 then 'CR' else 'DR' end as TransType,

upper(case when tl.TransactionType like '%Purchase%' then   TL.TransactionDetail
when tl.TransactionType IN('Cheque','Online') then tl.PaymentType
when tl.TransactionType IN('Cash') then tl.TransactionDetail
 else  TL.TransactionDetail end) as Description,  

'' as CityName --Cmp.City   as CityName

FROM SupplierLedger tl 
INNER JOIN SupplierLedger y ON y.TransactionDate <= tl.TransactionDate 
Left Join 
PurchaseMaster PM on PM.PurchaseID = TL.TransactionID

WHERE tl.PartyName = @PartyName and y.PartyName = @PartyName
and CAST(tl.TransactionDate as date) between @FromDate and @Todate
and CAST(y.TransactionDate as date) between @FromDate and @Todate
GROUP BY
tl.TransactionDate, tl.Credit, tl.Debit, tl.TransactionType, tl.PaymentType, 
tl.TransactionType, PM.InvioceNumber, TL.AccountID, TL.TransactionDetail,  TL.TransactionDetail, tl.PartyName

end
GO
/****** Object:  StoredProcedure [dbo].[sp_Transactions]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[sp_Transactions]
	@TransactionID int = null,
	@PatientID int = null,
	@TransDate datetime = null,
	@CollectedBy varchar(50) = null, 
	@Amount decimal = null,
	@EnteredBy varchar(50) = null,
	@PaymentType varchar(10) = null,
	@ModeType nvarchar(20) = null
AS
BEGIN

	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Transactions(PatientID, TransDate, CollectedBy, Amount, EnteredBy, PaymentType) 
		VALUES (@PatientID, @TransDate, @CollectedBy, @Amount, @EnteredBy, @PaymentType)
		
		exec [dbo].[sp_PatientBilling] @PatientID
		
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
			UPDATE Transactions SET 
			PatientID = @PatientID,
			TransDate = @TransDate, 
			CollectedBy = @CollectedBy,
			Amount = @Amount,
			PaymentType = @PaymentType
			WHERE TransactionID  = @TransactionID  
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Transactions 
		WHERE TransactionID  = @TransactionID 
	END

	IF(@ModeType = 'GET')
	BEGIN
		IF(@TransactionID > 0)
			SELECT * FROM Transactions t
			join PatientRegistration pr on pr.PatientID = t.PatientID 
			WHERE t.TransactionID  = @TransactionID
		ELSE
			SELECT * FROM Transactions t
			join PatientRegistration pr on pr.PatientID = t.PatientID 
	END
	IF(@ModeType = 'GETPayments')
	BEGIN
		IF(@PatientID > 0)
			SELECT * FROM Transactions t 
			WHERE t.PatientID = @PatientID
	END

	IF(@ModeType = 'UpdateTransaction')
	BEGIN
		Declare @strPaymentType varchar(50)
		Declare @TransAmount decimal(18,0)
		Declare @TransPatientID int

		Select @TransPatientID = PatientID, @TransAmount = Amount, @strPaymentType = PaymentType 
		from Transactions where TransactionID = @TransactionID

		if(@strPaymentType ='Deposit')
			Update BalanceOwing set DepositeAmount = (DepositeAmount - isnull(@TransAmount,0)) where PatientID = @TransPatientID
		else
			Update BalanceOwing set Discount = (Discount - isnull(@TransAmount,0)) where PatientID = @TransPatientID

		DELETE FROM Transactions WHERE TransactionID  = @TransactionID 

		exec sp_PatientBilling @TransPatientID

	END

	IF(@ModeType = 'AddDiscountToPatient')
	BEGIN
		declare @TransID int
		declare @deposamount decimal

		declare @DiscTransID int
		declare @DiscAmount decimal

		Select top 1 @TransID = TransactionID from Transactions where PatientID = @PatientID and PaymentType = 'Deposit' order by TransactionID desc
		Select top 1 @DiscTransID = TransactionID from Transactions where PatientID = @PatientID and PaymentType = 'Discount' order by TransactionID desc

		update Transactions set Amount = (Amount - @Amount) where TransactionID = @TransID
		update Transactions set Amount = (Amount + @Amount) where TransactionID = @DiscTransID

		exec sp_PatientBilling @PatientID

	END

END
 

GO
/****** Object:  StoredProcedure [dbo].[sp_Users]    Script Date: 1/1/2022 1:07:12 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[sp_Users]
	@UserID int = null,
	@UserName nvarchar(50) = null,
	@Password varchar(50) = null,
	@NewPassword varchar(50) = null,
	@Search nvarchar(100) = '',
	@ModeType nvarchar(20) = null
AS
BEGIN
	
	IF(@ModeType = 'INSERT')
	BEGIN
		INSERT INTO Users(UserName, Password)
		VALUES (@UserName, @Password)
	END
	
	IF(@ModeType = 'UPDATE')
	BEGIN
		UPDATE Users SET
		UserName = @UserName
		WHERE
			UserID = @UserID
	END
	
	IF(@ModeType = 'DELETE')
	BEGIN
		DELETE FROM Users WHERE UserID = @UserID
	END
	
	IF(@ModeType = 'GET')
	BEGIN
		IF(@UserID > 0)
			SELECT * FROM Users WHERE UserID = @UserID
	END
	
	IF(@ModeType = 'AUTHENTICATION')
	BEGIN
		SELECT * FROM Users
		WHERE 
		UserName = @UserName AND Password = @Password
	END
	
	IF(@ModeType = 'UPDATEPWD')
	BEGIN
		UPDATE Users 
		SET Password = @NewPassword
		WHERE 
		UserID = @UserID AND Password = @Password
	END
	
	IF(@ModeType = 'SEARCH')
	BEGIN
		SELECT * FROM Users 
			WHERE
			UserID LIKE('%'+@Search+'%') OR 
			UserName LIKE('%'+@Search+'%') OR
			Password LIKE('%'+@Search+'%')
	END
		
END


GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "pr"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 221
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 259
               Bottom = 126
               Right = 421
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "r"
            Begin Extent = 
               Top = 6
               Left = 459
               Bottom = 126
               Right = 619
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pd"
            Begin Extent = 
               Top = 6
               Left = 657
               Bottom = 126
               Right = 817
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "ps"
            Begin Extent = 
               Top = 6
               Left = 855
               Bottom = 126
               Right = 1031
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IndoorPatients'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'IndoorPatients'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPane1', @value=N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "p"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 126
               Right = 199
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "pt"
            Begin Extent = 
               Top = 6
               Left = 237
               Bottom = 96
               Right = 398
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "s"
            Begin Extent = 
               Top = 6
               Left = 436
               Bottom = 96
               Right = 596
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "c"
            Begin Extent = 
               Top = 6
               Left = 634
               Bottom = 96
               Right = 794
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 11
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Products'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'Products'
GO
USE [master]
GO
ALTER DATABASE [ManikHospital] SET  READ_WRITE 
GO
