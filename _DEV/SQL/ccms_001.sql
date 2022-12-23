CREATE TABLE [dbo].[users]
(
	[id] [int] IDENTITY(1,1) NOT NULL,
	[login] [varchar](50) NOT NULL,
	[fullname] [varchar](255) NOT NULL,
	[email] [nvarchar](50) NULL, --,
	[active] [bit] NOT NULL,
	CONSTRAINT [PK_users] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)
CREATE TABLE [dbo].[state](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
 	CONSTRAINT [PK_state] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)
CREATE TABLE [dbo].[content](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
 	CONSTRAINT [PK_content] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)
CREATE TABLE [dbo].[layout](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[data] [text] NULL,
 	CONSTRAINT [PK_layout] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)
CREATE TABLE [dbo].[page](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[linktext] [varchar](255) NOT NULL,
	[description] [varchar](255) NULL,
	[keywords] [varchar](255) NULL,
	[created_user] [int] NOT NULL,
	[updated_user] [int] NOT NULL,
	[layout_id] [int] NULL,
	CONSTRAINT [PK_page] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)
CREATE TABLE [dbo].[content_version](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[content_id] [int] NOT NULL,
	[version_id] [int] NOT NULL,
	[state_id] [int] NOT NULL,
	[data] [text] NULL,
	CONSTRAINT [PK_content_version] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)

CREATE TABLE [dbo].[page_content_ref](
	[content_id] [int] NOT NULL,
	[page_id] [int] NOT NULL
)
CREATE TABLE [dbo].[viewtree](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[page_id] [int] NOT NULL,
	[parent_id] [int] NOT NULL,
	[layout_id] [int] NULL,
	CONSTRAINT [PK_viewtree] PRIMARY KEY CLUSTERED 
	(
		[id] ASC
	)
)