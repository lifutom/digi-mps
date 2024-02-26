-- 1 Update table failurelist with field active: 1=active 0=inactive: default = 1
ALTER TABLE failurelist ADD active integer default(1)
GO
UPDATE failurelist SET active=1
GO

CREATE PROCEDURE AddFailureItem
    @FailureID int OUTPUT
    ,@Failure nvarchar(255)
    ,@Description nvarchar(max)
    ,@Active int
AS
BEGIN
    BEGIN TRAN
    INSERT INTO failurelist (
        failure
        ,description
        ,active
    )
    VALUES (
       @Failure
       ,@Description
       ,@Active
    )
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN -1
    END
    SELECT @FailureID=@@IDENTITY
    COMMIT
    RETURN 0
END
GO

CREATE PROCEDURE UpdateFailureItem
    @FailureID int
    ,@Failure nvarchar(255)
    ,@Description nvarchar(max)
    ,@Active int
AS
BEGIN
    BEGIN TRAN

    UPDATE failurelist SET
        failure = @Failure
        ,description = @Description
        ,active = @Active
    WHERE failureid=@FailureID
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN -1
    END
    COMMIT
    RETURN 0
END
GO


-- 2 Update table group with field active: 1=active 0=inactive: default = 1
ALTER TABLE [group] ADD active integer default(1)
GO
UPDATE [group] SET active=1
GO


CREATE PROCEDURE AddGroup
    @GroupID nvarchar(10)
    ,@Group nvarchar(255)
    ,@Active int
AS
BEGIN
    BEGIN TRAN
    INSERT INTO [group] (
        groupid
        ,groupname
        ,active
    )
    VALUES (
       @GroupID
       ,@Group
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

CREATE PROCEDURE UpdateGroup
    @GroupID nvarchar(10)
    ,@Group nvarchar(255)
    ,@Active int
AS
BEGIN
    BEGIN TRAN

    UPDATE [group] SET
        groupname = @Group
        ,active = @Active
    WHERE groupid=@GroupID
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN -1
    END
    COMMIT

    RETURN 0
END
GO


-- 3 Update table userlist with field active: 1=active 0=inactive: default = 1
ALTER TABLE userlist ADD active integer default(1)
GO
UPDATE userlist SET active=1
GO

/****** Object:  View [dbo].[vwUserlist]    Script Date: 14.03.2019 19:37:40 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[vwUserlist]
AS
SELECT        dbo.userlist.userid, dbo.userlist.groupid, dbo.userlist.active, dbo.[group].groupname
FROM            dbo.userlist INNER JOIN
                         dbo.[group] ON dbo.userlist.groupid = dbo.[group].groupid
GO

CREATE PROCEDURE AddUser
    @UserID nvarchar(50)
    ,@GroupID nvarchar(10)
    ,@Active int
AS
BEGIN
    BEGIN TRAN
    INSERT INTO userlist (
        userid
        ,groupid
        ,active
    )
    VALUES (
       @UserID
       ,@GroupID
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

CREATE PROCEDURE UpdateUser
    @UserID nvarchar(50)
    ,@GroupID nvarchar(10)
    ,@Active int
AS
BEGIN
    BEGIN TRAN
    UPDATE userlist SET
        groupid = @GroupID
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


create view vwPlantData
As
select d.plantid, count(d.failureid) as dtcnt, sum(DATEDIFF(N, d.start_time, d.end_time)) As dtmin,(SELECT COUNT(*) FROM production WHERE end_time is not null AND plantid=d.plantid) As ProdCnt
from downtime d
where d.end_time IS NOT NULL
group by d.plantid
GO

create view vwDeviceData
as
select d.plantid, d.deviceid, count(d.failureid) as dtcnt, sum(DATEDIFF(N, d.start_time, d.end_time)) As dtmin,(SELECT COUNT(*) FROM production WHERE end_time is not null AND plantid=d.plantid) As ProdCnt
from downtime d
where d.end_time IS NOT NULL
group by d.plantid, d.deviceid
go

create view vwComponentData
as
select d.plantid, d.deviceid, d.componentid, count(d.failureid) as dtcnt, sum(DATEDIFF(N, d.start_time, d.end_time)) As dtmin,(SELECT COUNT(*) FROM production WHERE end_time is not null AND plantid=d.plantid) As ProdCnt
from downtime d
where d.end_time IS NOT NULL
group by d.plantid, d.deviceid, d.componentid
go

create view vwProdDeviceData
as
select d.productionid, d.deviceid, count(d.failureid) as dtcnt, sum(DATEDIFF(N, d.start_time, d.end_time)) As dtmin
from downtime d
where d.end_time IS NOT NULL
group by d.productionid, d.deviceid
go

create view vwProdComponentData
as
select d.productionid, d.deviceid, d.componentid, count(d.failureid) as dtcnt, sum(DATEDIFF(N, d.start_time, d.end_time)) As dtmin
from downtime d
where d.end_time IS NOT NULL
group by d.productionid, d.deviceid, d.componentid
go

/****** Object:  View [dbo].[vwDowntime]    Script Date: 15.03.2019 10:53:29 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwDowntime]
AS
SELECT        dbo.downtime.downtimeid, dbo.downtime.productionid, dbo.downtime.plantid, dbo.downtime.deviceid, dbo.downtime.failureid, dbo.downtime.componentid, dbo.downtime.start_time, dbo.downtime.end_time,
    dbo.downtime.description AS dtdescription, dbo.downtime.userid, dbo.downtime.controlid, dbo.plant.plant, dbo.plant_device.device, dbo.plant_device.description AS devdescription, dbo.device_component.component,
    dbo.device_component.description AS compdescription, dbo.failurelist.failure, dbo.failurelist.description AS failuredescription
FROM            dbo.downtime LEFT OUTER JOIN
    dbo.failurelist ON dbo.downtime.failureid = dbo.failurelist.failureid LEFT OUTER JOIN
    dbo.device_component ON dbo.downtime.plantid = dbo.device_component.plantid AND dbo.downtime.componentid = dbo.device_component.componentid LEFT OUTER JOIN
    dbo.plant_device ON dbo.downtime.deviceid = dbo.plant_device.deviceid AND dbo.downtime.plantid = dbo.plant_device.plantid LEFT OUTER JOIN
    dbo.plant ON dbo.downtime.plantid = dbo.plant.plantID
GO


/****** Object:  View [dbo].[vwUserlist]    Script Date: 15.03.2019 10:55:47 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER VIEW [dbo].[vwUserlist]
AS
SELECT        dbo.userlist.userid, dbo.userlist.groupid, dbo.userlist.active, dbo.[group].groupname
FROM            dbo.userlist INNER JOIN
    dbo.[group] ON dbo.userlist.groupid = dbo.[group].groupid
GO







