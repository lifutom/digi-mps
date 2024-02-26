/****** Object:  View [dbo].[vwTierPeople]    Script Date: 06.05.2019 22:09:19 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierPeople]
AS
SELECT        dbo.tier_people.dateid, dbo.tier_people.employeecnt, dbo.tier_people.departmentid, dbo.tier_people.userid, dbo.tier_people.sickcnt, dbo.tier_people.lastedit, dbo.department.department, dbo.department.streamtype,
    dbo.department.area, dbo.department.active, dbo.tier_people.peopleid, YEAR(dbo.tier_people.dateid) AS yeardate, DATEPART(week, dbo.tier_people.dateid) AS kw
FROM            dbo.tier_people INNER JOIN
    dbo.department ON dbo.tier_people.departmentid = dbo.department.departmentid
GO

/****** Object:  View [dbo].[vwTier2PeopleDepartmentList]    Script Date: 13.05.2019 13:50:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwTier2PeopleDepartmentList]
AS
SELECT        d.departmentid, d.department, ISNULL(v.peopleid, NEWID()) AS peopleid, ISNULL(v.dateid, CONVERT(date, DATEADD(dd, - 1, GETDATE()))) AS dateid, ISNULL(v.employeecnt, 0) AS employeecnt, ISNULL(v.sickcnt, 0) AS sickcnt,
    d.streamtype, d.area, d.active
FROM            dbo.department AS d LEFT OUTER JOIN
    dbo.vwTierPeople AS v ON d.departmentid = v.departmentid
GO

/****** Object:  Table [dbo].[appsettings]    Script Date: 13.05.2019 14:01:01 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[appsettings](
    [name] [nvarchar](50) NOT NULL,
    [vartyp] [int] NULL,
    [varvalue] [nvarchar](255) NULL,
 CONSTRAINT [PK_appsettings] PRIMARY KEY CLUSTERED
(
    [name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/*** 0:text, 1:integer, 2:double *****/
INSERT INTO appsettings (name, vartyp, varvalue)
VALUES ('sick_factor', 2, '5,3')
GO

/****** Object:  View [dbo].[vwTierSafety]    Script Date: 13.05.2019 20:22:42 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierSafety]
AS
SELECT        dbo.tier_safety.safetyid, dbo.tier_safety.dateid, dbo.tier_safety.departmentid, dbo.tier_safety.accidentcnt, dbo.tier_safety.nearaccidentcnt, dbo.tier_safety.incidentcnt, dbo.tier_safety.userid, dbo.tier_safety.lastedit,
    dbo.department.department, dbo.department.streamtype, dbo.department.area, YEAR(dbo.tier_safety.dateid) AS yeardate, DATEPART(week, dbo.tier_safety.dateid) AS kw
FROM            dbo.tier_safety INNER JOIN
    dbo.department ON dbo.tier_safety.departmentid = dbo.department.departmentid
GO

/****** Object:  View [dbo].[vwTierEvents]    Script Date: 16.05.2019 13:48:24 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierEvents]
AS
SELECT        dbo.tier_events.eventid, dbo.tier_events.eventnb, dbo.tier_events.dateid, dbo.tier_events.departmentid, dbo.tier_events.eventstart, dbo.tier_events.eventclosed, dbo.tier_events.eventdescription, dbo.tier_events.userid,
    dbo.tier_events.lastedit, dbo.department.department, dbo.department.streamtype, dbo.department.area, YEAR(dbo.tier_events.dateid) AS yeardate, DATEPART(week, dbo.tier_events.dateid) AS kw
FROM            dbo.tier_events INNER JOIN
    dbo.department ON dbo.tier_events.departmentid = dbo.department.departmentid
GO


/****** Object:  View [dbo].[vwTierQuality]    Script Date: 18.05.2019 11:42:43 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierQuality]
AS
SELECT        dbo.tier_quality.qualityid, dbo.tier_quality.dateid, dbo.tier_quality.departmentid, dbo.tier_quality.streamtype, dbo.tier_quality.lrotcnt, dbo.tier_quality.userid, dbo.tier_quality.lastedit, dbo.tier_quality.complaintscnt,
    dbo.department.department, YEAR(dbo.tier_quality.dateid) AS yeardate, DATEPART(week, dbo.tier_quality.dateid) AS kw
FROM            dbo.tier_quality INNER JOIN
    dbo.department ON dbo.tier_quality.departmentid = dbo.department.departmentid
GO


CREATE FUNCTION tblKWTierQualityByStream(
    -- Add the parameters for the function here
    @DateID nvarchar(10)
    ,@StreamtypeID nvarchar(15)
)
RETURNS
@QualityList TABLE
(
    yeardate int
    ,kw int
    ,eventsopenedcnt float
    ,eventsclosedcnt float
    ,complaintscnt float
    ,lrotcnt float
)
AS
BEGIN
    WITH q As
    (
    SELECT v.yeardate, v.kw, (SELECT COUNT(*) FROM vwTierEvents WHERE yeardate=v.yeardate AND kw=v.kw) As eventsopened,(SELECT COUNT(*) FROM vwTierEvents WHERE yeardate=v.yeardate AND kw=v.kw) As eventsclosed, 0 As complaintscnt, 0 As lrotcnt
    FROM vwTierEvents v
    WHERE CONVERT(date,v.dateid) between DATEADD(year,-1,CONVERT(date,@DateID)) AND @DateID
    AND v.streamtype = @StreamtypeID
    UNION
    SELECT d.yeardate, d.kw, 0 As eventsopened, 0 As eventsclosed, SUM(ISNULL(complaintscnt,0)) As complaintscnt, SUM(ISNULL(lrotcnt,0)) As lrotcnt
    FROM vwTierQuality d
    WHERE CONVERT(date,d.dateid) between DATEADD(year,-1,CONVERT(date,@DateID)) AND @DateID
    AND d.streamtype = @StreamtypeID
    GROUP by d.yeardate, d.kw
    )
    INSERT INTO @QualityList
    SELECT yeardate, kw, SUM(eventsopened) As eventsopened, SUM(eventsclosed) As eventsclosed, SUM(complaintscnt) As complaintscnt, SUM(lrotcnt) As lrotcnt
    FROM q
    GROUP BY yeardate, kw
    ORDER BY yeardate, kw
    RETURN
END
GO

/****** Object:  View [dbo].[vwTierDeliveryPack]    Script Date: 19.05.2019 13:18:28 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierDeliveryPack]
AS
SELECT        dbo.tier_delivery_pack.deliverypackid, dbo.tier_delivery_pack.dateid, dbo.tier_delivery_pack.plantid, dbo.tier_delivery_pack.oeevalue, dbo.tier_delivery_pack.outputcnt, dbo.tier_delivery_pack.userid,
    dbo.tier_delivery_pack.lastedit, dbo.plant.plant, dbo.plant.streamtype, dbo.plant.area, YEAR(dbo.tier_delivery_pack.dateid) AS yeardate, DATEPART(week, dbo.tier_delivery_pack.dateid) AS kw
FROM            dbo.tier_delivery_pack INNER JOIN
    dbo.plant ON dbo.tier_delivery_pack.plantid = dbo.plant.plantID
GO


/****** Object:  View [dbo].[vwTierDeliveryBulk]    Script Date: 19.05.2019 13:19:06 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwTierDeliveryBulk]
AS
SELECT        dbo.tier_delivery_bulk.deliverybulkid, dbo.tier_delivery_bulk.datekw, dbo.tier_delivery_bulk.plantid, dbo.tier_delivery_bulk.plannedcnt, dbo.tier_delivery_bulk.producedcnt, dbo.tier_delivery_bulk.userid,
    dbo.tier_delivery_bulk.lastedit, dbo.plant.plant, dbo.plant.streamtype, dbo.plant.area, dbo.tier_delivery_bulk.dateid, dbo.tier_delivery_bulk.dateyear, dbo.tier_delivery_bulk.dateyear AS yeardate,
    dbo.tier_delivery_bulk.datekw AS kw
FROM            dbo.tier_delivery_bulk INNER JOIN
    dbo.plant ON dbo.tier_delivery_bulk.plantid = dbo.plant.plantID
GO


















