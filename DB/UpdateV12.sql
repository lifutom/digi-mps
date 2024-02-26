/****** Object:  Table [dbo].[group_access]    Script Date: 14.04.2019 18:55:51 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[group_access](
    [groupid] [nvarchar](10) NOT NULL,
    [menuid] [nvarchar](25) NOT NULL,
 CONSTRAINT [PK_group_access] PRIMARY KEY CLUSTERED
(
    [groupid] ASC,
    [menuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  Table [dbo].[menu]    Script Date: 15.04.2019 19:29:50 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[menu](
    [menuid] [nvarchar](25) NOT NULL,
    [menuname] [nvarchar](50) NULL,
    [menulink] [nvarchar](255) NULL,
    [iconclass] [nvarchar](255) NULL,
    [hassubmenus] [tinyint] NULL,
    [mainsort] [int] NULL,
    [subsort] [int] NULL,
    [active] [int] NULL,
 CONSTRAINT [PK_menu] PRIMARY KEY CLUSTERED
(
    [menuid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


-- Stammdaten
DELETE FROM menu
GO
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master','Stammdaten','#','fas fa-home', 1, 1, 1, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master_plant','Anlagen','/plant','fas fa-home', 0, 1, 1, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master_failure','Fehlerliste','/failure','fas fa-home', 0, 1, 1, 2)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master_analyze','Auswerte-Gruppen','/analyze','fas fa-home', 0, 0, 1, 3)
GO
-- Overview
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('overview','Übersicht','#','fab fa-algolia', 1, 1, 2, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('overview_prod','Produktionen','/overview/production','fab fa-algolia', 0, 1, 2, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('overview_down','Downtimes','/overview/downtime','fab fa-algolia', 0, 1, 2, 2)
GO

-- User
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('user','Userverwaltung','#','fas fa-users', 1, 1, 40, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('user_groups','Gruppen','/groups','fas fa-users', 0, 1, 40, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('user_user','User (AD)','/user','fas fa-users', 0, 1, 40, 2)
GO

-- Coaches Data
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1','Tier1 Daten','#','fab fa-algolia', 1, 1, 3, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_safety','Safety','/tier1/safety','fab fa-algolia', 0, 1, 3, 2)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_people','People','/tier1/people','fab fa-algolia', 0, 1, 3, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_quality','Quality','/tier1/quality','fab fa-algolia', 0, 1, 3, 3)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_events','Events','/tier1/events','fab fa-algolia', 0, 1, 3, 4)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_delivery_pack','Delivery Packaging','/tier1/deliverypack','fab fa-algolia', 0, 1, 3, 5)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_delivery_prod','Delivery Bulk','/tier1/deliverybulk','fab fa-algolia', 0, 1, 3, 6)
--INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
--VALUES ('tier1_cost','Cost/Waste','/tier1/costwaste','fab fa-algolia', 0, 1, 3, 7)
GO

ALTER TABLE plant ADD streamtype nvarchar(15), area nvarchar(15)
GO
ALTER TABLE userlist ADD departmentid int default(0)
GO

/****** Object:  View [dbo].[vwUserlist]    Script Date: 15.04.2019 19:58:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


/****** Object:  View [dbo].[vwUserlist]    Script Date: 25.04.2019 07:45:15 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwUserlist]
AS
SELECT        dbo.userlist.userid, dbo.userlist.groupid, dbo.userlist.active, dbo.[group].groupname, dbo.userlist.departmentid, dbo.department.department, dbo.department.streamtype, dbo.department.area
FROM            dbo.userlist INNER JOIN
    dbo.[group] ON dbo.userlist.groupid = dbo.[group].groupid INNER JOIN
    dbo.department ON dbo.userlist.departmentid = dbo.department.departmentid
GO



/****** Object:  StoredProcedure [dbo].[AddUser]    Script Date: 15.04.2019 19:58:55 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[AddUser]
    @UserID nvarchar(50)
    ,@GroupID nvarchar(10)
    ,@DepartmentID int
    ,@Active int
AS
BEGIN
    BEGIN TRAN
    INSERT INTO userlist (
        userid
        ,groupid
        ,departmentid
        ,active
    )
    VALUES (
       @UserID
       ,@GroupID
       ,@DepartmentID
       ,@Active
    )
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN -1
    END

    COMMIT
    RETURN 0
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateUser]    Script Date: 15.04.2019 20:00:40 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

ALTER PROCEDURE [dbo].[UpdateUser]
    @UserID nvarchar(50)
    ,@GroupID nvarchar(10)
    ,@DepartmentID int
    ,@Active int
AS
BEGIN
    BEGIN TRAN
    UPDATE userlist SET
        groupid = @GroupID
        ,departmentid = @DepartmentID
        ,active = @Active
    WHERE userid=@UserID
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN -1
    END
    COMMIT
    RETURN 0
END
GO

/****** Object:  Table [dbo].[department]    Script Date: 23.04.2019 18:58:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[department](
    [departmentid] [int] NOT NULL,
    [department] [nvarchar](50) NULL,
    [streamtype] [nvarchar](15) NULL,
    [area] [nvarchar](15) NULL,
    [active] [int] NULL,
 CONSTRAINT [PK_department] PRIMARY KEY CLUSTERED
(
    [departmentid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (1,'Implants Packaging','solida','pack',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (2,'Implants Tablet Filling','solida','pack',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (3,'Implants Production','solida','prod',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (4,'Solida Production','solida','prod',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (5,'Solida Packaging','solida','pack',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (6,'Packaging Bravecto L12','bravecto','pack',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (7,'Packaging Bravecto L15','bravecto','pack',1)
GO
INSERT INTO department (departmentid, department, streamtype, area, active)
VALUES (8,'Bulk Production Chews','bravecto','prod',1)
GO


/****** Object:  Table [dbo].[tier_people]    Script Date: 29.04.2019 07:18:55 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_people](
    [peopleid] [uniqueidentifier] NOT NULL,
    [dateid] [nchar](10) NOT NULL,
    [departmentid] [int] NOT NULL,
    [employeecnt] [int] NULL,
    [sickcnt] [int] NULL,
    [userid] [nvarchar](50) NULL,
    [lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_people] PRIMARY KEY CLUSTERED
(
    [peopleid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  StoredProcedure [dbo].[PeopleUpdate]    Script Date: 29.04.2019 08:23:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PeopleUpdate]
    @PeopleID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DepartmentID int
    ,@EmployeeCnt int
    ,@SickCnt int
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_people WHERE peopleid=@PeopleID)
        BEGIN
            UPDATE tier_people SET
                dateid = @DateID
                ,departmentid = @DepartmentID
                ,employeecnt = @EmployeeCnt
                ,sickcnt = @SickCnt
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE peopleid=@PeopleID
            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
        END
    ELSE
        BEGIN
            DECLARE @NewID uniqueidentifier
            SET  @NewID = NEWID()
            INSERT INTO tier_people (peopleid, dateid, departmentid, employeecnt, sickcnt, userid, lastedit)
            VALUES (@NewID, @DateID, @DepartmentID, @EmployeeCnt, @SickCnt, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @PeopleID=@NewID

        END
    COMMIT
    RETURN 0
GO

/****** Object:  Table [dbo].[tier_quality]    Script Date: 29.04.2019 15:48:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_quality](
    [qualityid] [uniqueidentifier] NOT NULL,
    [dateid] [nchar](10) NULL,
    [departmentid] [int] NULL,
    [streamtype] [nvarchar](15) NULL,
    [complaintscnt] [int] NULL,
    [lrotcnt] [int] NULL,
    [userid] [nvarchar](50) NULL,
    [lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_quality] PRIMARY KEY CLUSTERED
(
    [qualityid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  StoredProcedure [dbo].[PeopleUpdate]    Script Date: 29.04.2019 08:23:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[QualityUpdate]
    @QualityID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DepartmentID int
    ,@StreamTypeID nvarchar(15)
    ,@ComplaintsCnt int
    ,@LrotCnt int
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_quality WHERE qualityid=@QualityID)
        BEGIN
            UPDATE tier_quality SET
                dateid = @DateID
                ,departmentid = @DepartmentID
                ,streamtype =  @StreamTypeID
                ,complaintscnt = @ComplaintsCnt
                ,lrotcnt = @LrotCnt
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE qualityid=@QualityID
            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
        END
    ELSE
        BEGIN
            DECLARE @NewID uniqueidentifier
            SET  @NewID = NEWID()
            INSERT INTO tier_quality (qualityid, dateid, departmentid, streamtype, complaintscnt, lrotcnt, userid, lastedit)
            VALUES (@NewID, @DateID, @DepartmentID, @StreamTypeID, @ComplaintsCnt, @LrotCnt, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @QualityID=@NewID
        END
    COMMIT
    RETURN 0
GO


/****** Object:  View [dbo].[vwTierPeople]    Script Date: 30.04.2019 12:45:20 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierPeople]
AS
SELECT        dbo.tier_people.dateid, dbo.tier_people.employeecnt, dbo.tier_people.departmentid, dbo.tier_people.userid, dbo.tier_people.sickcnt, dbo.tier_people.lastedit, dbo.department.department, dbo.department.streamtype,
                         dbo.department.area, dbo.department.active, dbo.tier_people.peopleid
FROM            dbo.tier_people INNER JOIN
                         dbo.department ON dbo.tier_people.departmentid = dbo.department.departmentid
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
         Begin Table = "tier_people"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 210
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "department"
            Begin Extent =
               Top = 6
               Left = 243
               Bottom = 136
               Right = 410
            End
            DisplayFlags = 280
            TopColumn = 1
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierPeople'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierPeople'
GO




/****** Object:  Table [dbo].[tier_quality]    Script Date: 29.04.2019 15:48:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_events](
    [eventid] [uniqueidentifier] NOT NULL,
    [dateid] [nchar](10) NULL,
    [departmentid] [int] NULL,
    [eventnb] [nvarchar](15),
    [eventstart] [datetime] NULL,
    [eventclosed] [datetime] NULL,
    [eventdescription] [nvarchar](255),
    [userid] [nvarchar](50) NULL,
    [lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_events] PRIMARY KEY CLUSTERED
(
    [eventid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  StoredProcedure [dbo].[PeopleUpdate]    Script Date: 29.04.2019 08:23:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[EventsUpdate]
    @EventID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DepartmentID int
    ,@EventNb nvarchar(15)
    ,@EventDescription nvarchar(255)
    ,@EventStart datetime
    ,@EventClosed datetime
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_events WHERE eventid=@EventID)
        BEGIN
            UPDATE tier_events SET
                dateid = @DateID
                ,departmentid = @DepartmentID
                ,eventnb =  @EventNb
                ,eventdescription = @EventDescription
                ,eventstart = @EventStart
                ,eventclosed = @EventClosed
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE eventid=@EventID
            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
        END
    ELSE
        BEGIN
            DECLARE @NewID uniqueidentifier
            SET  @NewID = NEWID()
            INSERT INTO tier_events (eventid, dateid, departmentid, eventnb, eventdescription, eventstart, eventclosed, userid, lastedit)
            VALUES (@NewID, @DateID, @DepartmentID, @EventNb, @EventDescription, @EventStart, @EventClosed, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @EventID=@NewID
        END
    COMMIT
    RETURN 0
GO

/****** Object:  View [dbo].[vwTierQuality]    Script Date: 30.04.2019 12:43:59 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierQuality]
AS
SELECT        dbo.tier_quality.qualityid, dbo.tier_quality.dateid, dbo.tier_quality.departmentid, dbo.tier_quality.streamtype, dbo.tier_quality.lrotcnt, dbo.tier_quality.userid, dbo.tier_quality.lastedit, dbo.tier_quality.complaintscnt,
                         dbo.department.department
FROM            dbo.tier_quality INNER JOIN
                         dbo.department ON dbo.tier_quality.departmentid = dbo.department.departmentid
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
         Begin Table = "tier_quality"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 221
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "department"
            Begin Extent =
               Top = 6
               Left = 243
               Bottom = 136
               Right = 410
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierQuality'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierQuality'
GO

/****** Object:  View [dbo].[vwTierEvents]    Script Date: 02.05.2019 11:35:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierEvents]
AS
SELECT        dbo.tier_events.eventid, dbo.tier_events.eventnb, dbo.tier_events.dateid, dbo.tier_events.departmentid, dbo.tier_events.eventstart, dbo.tier_events.eventclosed, dbo.tier_events.eventdescription, dbo.tier_events.userid,
                         dbo.tier_events.lastedit, dbo.department.department, dbo.department.streamtype, dbo.department.area
FROM            dbo.tier_events INNER JOIN
                         dbo.department ON dbo.tier_events.departmentid = dbo.department.departmentid
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
         Begin Table = "tier_events"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 265
               Right = 215
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "department"
            Begin Extent =
               Top = 6
               Left = 253
               Bottom = 136
               Right = 420
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierEvents'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierEvents'
GO

/****** Object:  Table [dbo].[tier_safety]    Script Date: 29.04.2019 15:48:36 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_safety](
    [safetyid] [uniqueidentifier] NOT NULL,
    [dateid] [nchar](10) NULL,
    [departmentid] [int] NULL,
    [accidentcnt] [int] NULL,
    [nearaccidentcnt] [int] NULL,
    [incidentcnt] [int] NULL,
    [userid] [nvarchar](50) NULL,
    [lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_safety] PRIMARY KEY CLUSTERED
(
    [safetyid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO




/****** Object:  StoredProcedure [dbo].[SafetyUpdate]    Script Date: 29.04.2019 08:23:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[SafetyUpdate]
    @SafetyID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DepartmentID int
    ,@AccidentCnt int
    ,@NearAccidentCnt int
    ,@IncidentCnt int
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_safety WHERE safetyid=@SafetyID)
        BEGIN
            UPDATE tier_safety SET
                dateid = @DateID
                ,departmentid = @DepartmentID
                ,accidentcnt =  @AccidentCnt
                ,nearaccidentcnt = @NearAccidentCnt
                ,incidentCnt = @IncidentCnt
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE safetyid=@SafetyID
            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
        END
    ELSE
        BEGIN
            DECLARE @NewID uniqueidentifier
            SET  @NewID = NEWID()
            INSERT INTO tier_safety (safetyid, dateid, departmentid, accidentcnt, nearaccidentcnt, incidentcnt, userid, lastedit)
            VALUES (@NewID, @DateID, @DepartmentID, @AccidentCnt, @NearAccidentCnt, @IncidentCnt, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @SafetyID=@NewID
        END
    COMMIT
    RETURN 0
GO

/****** Object:  View [dbo].[vwTierSafety]    Script Date: 02.05.2019 11:48:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierSafety]
AS
SELECT        dbo.tier_safety.safetyid, dbo.tier_safety.dateid, dbo.tier_safety.departmentid, dbo.tier_safety.accidentcnt, dbo.tier_safety.nearaccidentcnt, dbo.tier_safety.incidentcnt, dbo.tier_safety.userid, dbo.tier_safety.lastedit,
                         dbo.department.department, dbo.department.streamtype, dbo.department.area
FROM            dbo.tier_safety INNER JOIN
                         dbo.department ON dbo.tier_safety.departmentid = dbo.department.departmentid
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
         Begin Table = "tier_safety"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 136
               Right = 212
            End
            DisplayFlags = 280
            TopColumn = 4
         End
         Begin Table = "department"
            Begin Extent =
               Top = 6
               Left = 250
               Bottom = 136
               Right = 417
            End
            DisplayFlags = 280
            TopColumn = 1
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierSafety'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierSafety'
GO

-----
--tier_delivery_bulk
----
/****** Object:  Table [dbo].[tier_delivery_bulk]    Script Date: 02.05.2019 19:35:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_delivery_bulk](
	[deliverybulkid] [uniqueidentifier] NOT NULL,
	[dateid] [nvarchar](10) NULL,
	[dateyear] [nvarchar](4) NULL,
	[datekw] [nvarchar](2) NULL,
	[plantid] [int] NULL,
	[plannedcnt] [int] NULL,
	[producedcnt] [int] NULL,
	[userid] [nvarchar](50) NULL,
	[lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_delivery] PRIMARY KEY CLUSTERED
(
	[deliverybulkid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  View [dbo].[vwTierDeliveryBulk]    Script Date: 02.05.2019 19:36:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierDeliveryBulk]
AS
SELECT        dbo.tier_delivery_bulk.deliverybulkid, dbo.tier_delivery_bulk.datekw, dbo.tier_delivery_bulk.plantid, dbo.tier_delivery_bulk.plannedcnt, dbo.tier_delivery_bulk.producedcnt, dbo.tier_delivery_bulk.userid,
                         dbo.tier_delivery_bulk.lastedit, dbo.plant.plant, dbo.plant.streamtype, dbo.plant.area, dbo.tier_delivery_bulk.dateid, dbo.tier_delivery_bulk.dateyear
FROM            dbo.tier_delivery_bulk INNER JOIN
                         dbo.plant ON dbo.tier_delivery_bulk.plantid = dbo.plant.plantID
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
         Begin Table = "tier_delivery_bulk"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 202
               Right = 211
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "plant"
            Begin Extent =
               Top = 6
               Left = 243
               Bottom = 230
               Right = 410
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierDeliveryBulk'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierDeliveryBulk'
GO


SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeliveryBulkUpdate]
    @DeliveryBulkID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DateYear nvarchar(4)
    ,@DateKW nvarchar(10)
    ,@PlantID int
    ,@PlannedCnt int
    ,@ProducedCnt int
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_delivery_bulk WHERE deliverybulkid=@DeliveryBulkID)
        BEGIN
            UPDATE tier_delivery_bulk SET
                dateid = @DateID
                ,dateyear = @DateYear
                ,datekw = @DateKW
                ,plantid = @PlantID
                ,plannedcnt =  @PlannedCnt
                ,producedcnt = @ProducedCnt
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE deliverybulkid=@DeliveryBulkID
            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
        END
    ELSE
        BEGIN
            DECLARE @NewID uniqueidentifier
            SET  @NewID = NEWID()
            INSERT INTO tier_delivery_bulk (deliverybulkid, dateid, dateyear, datekw, plantid, plannedcnt, producedcnt, userid, lastedit)
            VALUES (@NewID, @DateID, @DateYear, @DateKW, @PlantID, @PlannedCnt, @ProducedCnt, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @DeliveryBulkID=@NewID
        END
    COMMIT
    RETURN 0
GO

ALTER TABLE plant ADD active int default(1)
GO
UPDATE plant SET active=1
GO


-----
--tier_delivery_pack
----
/****** Object:  Table [dbo].[tier_delivery_pack]    Script Date: 02.05.2019 19:35:52 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_delivery_pack](
	[deliverypackid] [uniqueidentifier] NOT NULL,
	[dateid] [nvarchar](10) NULL,
	[plantid] [int] NULL,
	[oeevalue] [float] NULL,
	[outputcnt] [int] NULL,
	[userid] [nvarchar](50) NULL,
	[lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_delivery_pack] PRIMARY KEY CLUSTERED
(
	[deliverypackid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

/****** Object:  View [dbo].[vwTierDeliveryPack]    Script Date: 03.05.2019 09:59:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierDeliveryPack]
AS
SELECT        dbo.tier_delivery_pack.deliverypackid, dbo.tier_delivery_pack.dateid, dbo.tier_delivery_pack.plantid, dbo.tier_delivery_pack.oeevalue, dbo.tier_delivery_pack.outputcnt, dbo.tier_delivery_pack.userid,
                         dbo.tier_delivery_pack.lastedit, dbo.plant.plant, dbo.plant.streamtype, dbo.plant.area
FROM            dbo.tier_delivery_pack INNER JOIN
                         dbo.plant ON dbo.tier_delivery_pack.plantid = dbo.plant.plantID
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
         Begin Table = "tier_delivery_pack"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 136
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 3
         End
         Begin Table = "plant"
            Begin Extent =
               Top = 6
               Left = 243
               Bottom = 136
               Right = 410
            End
            DisplayFlags = 280
            TopColumn = 4
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierDeliveryPack'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierDeliveryPack'
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[DeliveryPackUpdate]
    @DeliveryPackID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@PlantID int
    ,@OEEValue float
    ,@OutputCnt int
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_delivery_pack WHERE deliverypackid=@DeliveryPackID)
        BEGIN
            UPDATE tier_delivery_pack SET
                dateid = @DateID
                ,plantid = @PlantID
                ,oeevalue =  @OEEValue
                ,outputcnt = @OutputCnt
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE deliverypackid=@DeliveryPackID
            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
        END
    ELSE
        BEGIN
            DECLARE @NewID uniqueidentifier
            SET  @NewID = NEWID()
            INSERT INTO tier_delivery_pack (deliverypackid, dateid, plantid, oeevalue, outputcnt, userid, lastedit)
            VALUES (@NewID, @DateID, @PlantID, @OEEValue, @OutputCnt, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @DeliveryPackID=@NewID
        END
    COMMIT
    RETURN 0
GO


















