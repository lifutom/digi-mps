CREATE PROCEDURE DownTimeSave
            @DowntimeID uniqueidentifier
            ,@DeviceID int
            ,@ComponentID int
            ,@FailureID int
            ,@Description nvarchar(MAX)
            ,@StartTime datetime
            ,@EndTime datetime

AS
BEGIN

        BEGIN TRAN

        UPDATE downtime SET
            DeviceID=@DeviceID
            ,ComponentID=@ComponentID
            ,FailureID=@FailureID
            ,Description=@Description
            ,Start_Time=@StartTime
            ,End_Time=@EndTime
        WHERE downtimeid = @DownTimeID

        IF @@ERROR <> 0
        BEGIN
                ROLLBACK TRAN
                RETURN -1
        END
        COMMIT
        RETURN 0
END

