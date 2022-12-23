if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[content]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[content]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[content_types]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[content_types]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[content_version]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[content_version]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[layout]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[layout]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[page]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[page_content_ref]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[page_content_ref]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[state]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[state]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[users]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[users]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[viewtree]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[viewtree]
GO

CREATE TABLE [dbo].[content] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[created_user] [int] NULL ,
	[created_date] [datetime] NOT NULL ,
	[updated_user] [int] NULL ,
	[updated_date] [datetime] NULL ,
	[auth_group] [int] NULL ,
	[content_type] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[content_types] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[content_version] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[content_id] [int] NOT NULL ,
	[version_id] [int] NOT NULL ,
	[state_id] [int] NOT NULL ,
	[data] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[edit_user] [int] NOT NULL ,
	[updated_date] [datetime] NOT NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

CREATE TABLE [dbo].[layout] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[layout_url] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[page] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[state] [int] NOT NULL ,
	[name] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[linktext] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[title] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[keywords] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[created_date] [datetime] NULL ,
	[created_user] [int] NOT NULL ,
	[updated_date] [datetime] NULL ,
	[updated_user] [int] NULL ,
	[layout_id] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[page_content_ref] (
	[content_id] [int] NOT NULL ,
	[page_id] [int] NOT NULL ,
	[slot_num] [int] NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[state] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[name] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[description] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[users] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[login] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[password] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[fullname] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL ,
	[email] [nvarchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL ,
	[active] [bit] NOT NULL ,
	[permissions] [int] NOT NULL 
) ON [PRIMARY]
GO

CREATE TABLE [dbo].[viewtree] (
	[id] [int] IDENTITY (1, 1) NOT NULL ,
	[page_id] [int] NOT NULL ,
	[parent_id] [int] NOT NULL ,
	[layout_id] [int] NULL 
) ON [PRIMARY]
GO

