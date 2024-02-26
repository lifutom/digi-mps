CREATE PROCEDURE DowntimeAdd
      @DowntimeID uniqueidentifier OUTPUT
      ,@ProductionID  uniqueidentifier
      ,@PlantID int
      ,@StartTime datetime
      ,@ControlID nvarchar(50)
AS
BEGIN

    BEGIN TRAN

    SET  @DowntimeID = NEWID()

    INSERT INTO downtime (
        downtimeid
        ,productionid
        ,plantid
        ,start_time
        ,controlid
    )
    VALUES (
        @DowntimeID
        ,@ProductionID
        ,@PlantID
        ,@StartTime
        ,@ControlID
    )
    IF @@ERROR <> 0
    BEGIN
        ROLLBACK TRAN
        RETURN -1
    END

    COMMIT

    RETURN 0


END