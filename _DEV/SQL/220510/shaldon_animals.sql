/****** Object:  Table [dbo].[shaldon_animals]    Script Date: 10/09/2011 18:00:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[shaldon_animals](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[section] [int] NOT NULL,
	[common_name] [varchar](max) NULL,
	[specific_name] [varchar](max) NULL,
	[family] [varchar](max) NULL,
	[behaviour] [varchar](max) NULL,
	[diet] [varchar](max) NULL,
	[habitat] [varchar](max) NULL,
	[status] [varchar](max) NULL,
	[location] [varchar](max) NULL
) ON [PRIMARY]

GO

SET ANSI_PADDING OFF
GO