CREATE PROCEDURE StopDownTime
            @DowntimeID uniqueidentifier
            ,@EndTime datetime
AS
BEGIN

        BEGIN TRAN

        UPDATE downtime SET end_time=@EndTime WHERE downtimeid = @DownTimeID

        IF @@ERROR <> 0
        BEGIN
                ROLLBACK TRAN
                RETURN -1
        END
        COMMIT
        RETURN 0
END