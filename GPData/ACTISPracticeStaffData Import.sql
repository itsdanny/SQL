USE [GPData]
GO

/****** Object:  Table [dbo].[ACTISPracticeStaffData]    Script Date: 13/10/2015 10:37:30 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[ACTISPracticeStaffData](
	[LocationId] [nvarchar](255) NULL,
	[PracticeCode] [float] NULL,
	[LocationName] [nvarchar](255) NULL,
	[GeogCode] [nvarchar](255) NULL,
	[GeogDescription] [nvarchar](255) NULL,
	[Address1] [nvarchar](255) NULL,
	[Address2] [nvarchar](255) NULL,
	[Address3] [nvarchar](255) NULL,
	[Town] [nvarchar](255) NULL,
	[County] [nvarchar](255) NULL,
	[Telephone] [nvarchar](255) NULL,
	[PostCode] [nvarchar](255) NULL,
	[CustomerId] [nvarchar](255) NULL,
	[Forename] [nvarchar](255) NULL,
	[Surname] [nvarchar](255) NULL,
	[JobTitle] [nvarchar](255) NULL,
	[Title] [nvarchar](255) NULL,
	[CustomerType] [nvarchar](255) NULL,
	[Grade] [nvarchar](255) NULL,
	[Brick] [varchar](4) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO


