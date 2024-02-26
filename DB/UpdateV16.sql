/****** Object:  Table [dbo].[tier_other_cat]    Script Date: 06.12.2019 12:42:46 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_other_cat](
    [ocatid] [int] NOT NULL,
    [ocatname] [nvarchar](25) NOT NULL,
    [active] [int] NOT NULL,
 CONSTRAINT [PK_tier_other_cat] PRIMARY KEY CLUSTERED
(
    [ocatid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO  tier_other_cat (ocatid, ocatname, active )
VALUES (1, 'Downtimes', 1)
GO
INSERT INTO  tier_other_cat (ocatid, ocatname, active )
VALUES (2, 'Trainings', 1)
GO
INSERT INTO  tier_other_cat (ocatid, ocatname, active )
VALUES (3, 'Audits', 1)
GO
INSERT INTO  tier_other_cat (ocatid, ocatname, active )
VALUES (4, 'Visitors', 1)
GO
INSERT INTO  tier_other_cat (ocatid, ocatname, active )
VALUES (5, 'Recognitions', 1)
GO



/****** Object:  Table [dbo].[tier_events]    Script Date: 28.11.2019 13:20:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_other](
    [oid] [uniqueidentifier] NOT NULL,
    [dateid] [nchar](10) NULL,
    [departmentid] [int] NULL,
    [ocatid] [int] NULL,
    [ostart] [datetime] NULL,
    [oclosed] [datetime] NULL,
    [odescription] [nvarchar](512) NULL,
    [userid] [nvarchar](50) NULL,
    [lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_other] PRIMARY KEY CLUSTERED
(
    [oid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  StoredProcedure [dbo].[TierOtherUpdate]    Script Date: 06.12.2019 13:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TierOtherUpdate]
    @OID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DepartmentID int
    ,@CatOID int
    ,@ODescription nvarchar(255)
    ,@OStart datetime
    ,@OClosed datetime
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_other WHERE oid=@OID)
        BEGIN
            UPDATE tier_other SET
                dateid = @DateID
                ,departmentid = @DepartmentID
                ,ocatid = @CatOID
                ,odescription = @ODescription
                ,ostart = @OStart
                ,oclosed = @OClosed
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE oid=@OID
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
            INSERT INTO tier_other (oid, dateid, departmentid, ocatid, odescription, ostart, oclosed, userid, lastedit)
            VALUES (@NewID, @DateID, @DepartmentID, @CatOID, @ODescription, @OStart, @OClosed, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @OID=@NewID
        END
    COMMIT
    RETURN 0


/****** Object:  View [dbo].[vwTierOther]    Script Date: 06.12.2019 13:09:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierOther]
AS
SELECT        dbo.tier_other.oid, dbo.tier_other.dateid, dbo.tier_other.departmentid, dbo.department.department, dbo.tier_other.ocatid, dbo.tier_other_cat.ocatname, dbo.tier_other.ostart, dbo.tier_other.oclosed, dbo.tier_other.odescription,
                         dbo.tier_other.userid, dbo.tier_other.lastedit, YEAR(dbo.tier_other.dateid) AS yeardate, DATEPART(week, dbo.tier_other.dateid) AS kw
FROM            dbo.tier_other INNER JOIN
                         dbo.department ON dbo.tier_other.departmentid = dbo.department.departmentid INNER JOIN
                         dbo.tier_other_cat ON dbo.tier_other.ocatid = dbo.tier_other_cat.ocatid
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
         Begin Table = "tier_other"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 136
               Right = 205
            End
            DisplayFlags = 280
            TopColumn = 5
         End
         Begin Table = "department"
            Begin Extent =
               Top = 190
               Left = 358
               Bottom = 320
               Right = 525
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tier_other_cat"
            Begin Extent =
               Top = 6
               Left = 448
               Bottom = 119
               Right = 615
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierOther'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierOther'
GO


-------------------------------------------------------------------------------------------------------
- New       8.12.2019
-------------------------------------------------------------------------------------------------------

/****** Object:  Table [dbo].[tier_othernote]    Script Date: 08.12.2019 13:20:03 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[tier_othernote](
    [onid] [uniqueidentifier] NOT NULL,
    [dateid] [nchar](10) NULL,
    [departmentid] [int] NULL,
    [onstart] [datetime] NULL,
    [onclosed] [datetime] NULL,
    [ondescription] [nvarchar](512) NULL,
    [userid] [nvarchar](50) NULL,
    [lastedit] [datetime] NULL,
 CONSTRAINT [PK_tier_othernote] PRIMARY KEY CLUSTERED
(
    [onid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO


/****** Object:  StoredProcedure [dbo].[TierOtherUpdate]    Script Date: 06.12.2019 13:10:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TierOtherNoteUpdate]
    @OnID uniqueidentifier OUTPUT
    ,@DateID nvarchar(10)
    ,@DepartmentID int
    ,@OnDescription nvarchar(255)
    ,@OnStart datetime
    ,@OnClosed datetime
    ,@UserID nvarchar(50)
AS
    BEGIN TRAN

    IF EXISTS (SELECT * FROM tier_othernote WHERE onid=@OnID)
        BEGIN
            UPDATE tier_othernote SET
                dateid = @DateID
                ,departmentid = @DepartmentID
                ,ondescription = @OnDescription
                ,onstart = @OnStart
                ,onclosed = @OnClosed
                ,userid = @UserID
                ,lastedit = GETDATE()
            WHERE onid=@OnID
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
            INSERT INTO tier_othernote (onid, dateid, departmentid, ondescription, onstart, onclosed, userid, lastedit)
            VALUES (@NewID, @DateID, @DepartmentID, @OnDescription, @OnStart, @OnClosed, @UserID, GETDATE())

            IF @@ERROR <> 0
            BEGIN
                ROLLBACK TRAN
                RETURN -1
            END
            SELECT @OnID=@NewID
        END
    COMMIT
    RETURN 0


/****** Object:  View [dbo].[vwTierOtherNote]    Script Date: 08.12.2019 09:44:44 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTierOtherNote]
AS
SELECT        dbo.tier_othernote.onid, dbo.tier_othernote.dateid, dbo.tier_othernote.departmentid, dbo.department.department, dbo.tier_othernote.onstart, dbo.tier_othernote.ondescription, dbo.tier_othernote.onclosed,
                         dbo.tier_othernote.userid, dbo.tier_othernote.lastedit, dbo.department.streamtype, dbo.department.area, YEAR(dbo.tier_othernote.dateid) AS yeardate, DATEPART(week, dbo.tier_othernote.dateid) AS kw
FROM            dbo.tier_othernote INNER JOIN
                         dbo.department ON dbo.tier_othernote.departmentid = dbo.department.departmentid
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
         Begin Table = "tier_othernote"
            Begin Extent =
               Top = 6
               Left = 38
               Bottom = 333
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
      Begin ColumnWidths = 9
         Width = 284
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
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
' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierOtherNote'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_DiagramPaneCount', @value=1 , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'VIEW',@level1name=N'vwTierOtherNote'
GO

/****** Object:  Table [dbo].[analyzegroup]    Script Date: 08.12.2019 10:42:27 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[analyzegroup](
	[agid] [int] NOT NULL,
	[agname] [nvarchar](50) NULL,
	[active] [int] NULL,
 CONSTRAINT [PK_analyzegroup] PRIMARY KEY CLUSTERED
(
	[agid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

INSERT INTO analyzegroup (agid, agname, active)
VALUES (1,'IPT Chews',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (2,'IPT Solids',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (3,'PTS',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (4,'SCM',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (5,'IT',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (6,'QAO',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (7,'QC',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (8,'SC/Distribution',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (9,'ES/PMO',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (10,'EHS',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (11,'Einkauf',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (12,'HR/Payroll',1)
GO
INSERT INTO analyzegroup (agid, agname, active)
VALUES (13,'Logistics',1)
GO


/***************  Updatedepartment *******************************/
ALTER TABLE department ADD agid int
GO


/****** Object:  View [dbo].[vwTier2PeopleDepartmentList]    Script Date: 08.12.2019 12:09:16 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTier2PeopleDepartmentList]
AS
SELECT        d.departmentid, d.department, ISNULL(v.peopleid, NEWID()) AS peopleid, ISNULL(v.dateid, CONVERT(date, DATEADD(dd, - 1, GETDATE()))) AS dateid, ISNULL(v.employeecnt, 0) AS employeecnt, ISNULL(v.sickcnt, 0) AS sickcnt,
                         d.streamtype, d.area, d.active, d.agid, dbo.analyzegroup.agname
FROM            dbo.department AS d LEFT OUTER JOIN
                         dbo.analyzegroup ON d.agid = dbo.analyzegroup.agid LEFT OUTER JOIN
                         dbo.vwTierPeople AS v ON d.departmentid = v.departmentid
GO

/****** Object:  View [dbo].[vwTierEvents]    Script Date: 08.12.2019 16:38:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierEvents]
AS
SELECT        dbo.tier_events.eventid, dbo.tier_events.eventnb, dbo.tier_events.dateid, dbo.tier_events.departmentid, dbo.tier_events.eventstart, dbo.tier_events.eventclosed, dbo.tier_events.eventdescription, dbo.tier_events.userid,
                         dbo.tier_events.lastedit, dbo.department.department, dbo.department.streamtype, dbo.department.area, YEAR(dbo.tier_events.dateid) AS yeardate, DATEPART(week, dbo.tier_events.dateid) AS kw, dbo.department.agid,
                         dbo.analyzegroup.agname
FROM            dbo.tier_events INNER JOIN
                         dbo.department ON dbo.tier_events.departmentid = dbo.department.departmentid LEFT OUTER JOIN
                         dbo.analyzegroup ON dbo.department.agid = dbo.analyzegroup.agid
GO


/****** Object:  View [dbo].[vwTierCapa]    Script Date: 08.12.2019 16:39:04 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierCapa]
AS
SELECT        dbo.tier_capa.capaid, dbo.tier_capa.dateid, dbo.tier_capa.departmentid, dbo.tier_capa.capanb, dbo.tier_capa.capastart, dbo.tier_capa.capaclosed, dbo.tier_capa.capadescription, dbo.tier_capa.userid, dbo.tier_capa.lastedit,
                         dbo.department.department, dbo.department.area, dbo.department.streamtype, dbo.department.active, dbo.department.agid, dbo.analyzegroup.agname
FROM            dbo.tier_capa INNER JOIN
                         dbo.department ON dbo.tier_capa.departmentid = dbo.department.departmentid LEFT OUTER JOIN
                         dbo.analyzegroup ON dbo.department.agid = dbo.analyzegroup.agid
GO


/****** Object:  View [dbo].[vwTierCC]    Script Date: 08.12.2019 16:39:22 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierCC]
AS
SELECT        dbo.tier_cc.ccid, dbo.tier_cc.dateid, dbo.tier_cc.departmentid, dbo.tier_cc.ccnb, dbo.tier_cc.ccstart, dbo.tier_cc.ccclosed, dbo.tier_cc.ccdescription, dbo.tier_cc.userid, dbo.tier_cc.lastedit, dbo.department.department,
                         dbo.department.streamtype, dbo.department.area, dbo.department.active, dbo.department.agid, dbo.analyzegroup.agname
FROM            dbo.tier_cc INNER JOIN
                         dbo.department ON dbo.tier_cc.departmentid = dbo.department.departmentid LEFT OUTER JOIN
                         dbo.analyzegroup ON dbo.department.agid = dbo.analyzegroup.agid
GO


/****** Object:  View [dbo].[vwTierQuality]    Script Date: 08.12.2019 16:40:13 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierQuality]
AS
SELECT        dbo.tier_quality.qualityid, dbo.tier_quality.dateid, dbo.tier_quality.departmentid, dbo.tier_quality.streamtype, dbo.tier_quality.lrotcnt, dbo.tier_quality.userid, dbo.tier_quality.lastedit, dbo.tier_quality.complaintscnt,
                         dbo.department.department, YEAR(dbo.tier_quality.dateid) AS yeardate, DATEPART(week, dbo.tier_quality.dateid) AS kw, dbo.department.agid, dbo.analyzegroup.agname
FROM            dbo.tier_quality INNER JOIN
                         dbo.department ON dbo.tier_quality.departmentid = dbo.department.departmentid LEFT OUTER JOIN
                         dbo.analyzegroup ON dbo.department.agid = dbo.analyzegroup.agid
GO


/****** Object:  View [dbo].[vwTierSafety]    Script Date: 08.12.2019 16:41:02 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierSafety]
AS
SELECT        dbo.tier_safety.safetyid, dbo.tier_safety.dateid, dbo.tier_safety.departmentid, dbo.tier_safety.accidentcnt, dbo.tier_safety.nearaccidentcnt, dbo.tier_safety.incidentcnt, dbo.tier_safety.userid, dbo.tier_safety.lastedit,
                         dbo.department.department, dbo.department.streamtype, dbo.department.area, YEAR(dbo.tier_safety.dateid) AS yeardate, DATEPART(week, dbo.tier_safety.dateid) AS kw, dbo.department.agid, dbo.analyzegroup.agname
FROM            dbo.tier_safety INNER JOIN
                         dbo.department ON dbo.tier_safety.departmentid = dbo.department.departmentid LEFT OUTER JOIN
                         dbo.analyzegroup ON dbo.department.agid = dbo.analyzegroup.agid
GO


















