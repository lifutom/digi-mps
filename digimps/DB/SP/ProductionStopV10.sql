CREATE PROCEDURE ProductionStop
            @ProductionID uniqueidentifier
            ,@Counter int
            ,@EndTime datetime
AS
BEGIN

        BEGIN TRAN

        UPDATE production SET
            counter=@Counter
            ,End_Time=@EndTime
        WHERE productionid = @ProductionID

        IF @@ERROR <> 0
        BEGIN
                ROLLBACK TRAN
                RETURN -1
        END
        COMMIT
        RETURN 0
END

