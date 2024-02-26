ALTER TABLE  production ADD counterbad int default(0)
GO
UPDATE production SET counterbad=0
GO

/****** Object:  StoredProcedure [dbo].[ProductionStop]    Script Date: 28.03.2019 08:57:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
ALTER PROCEDURE [dbo].[ProductionStop]
            @ProductionID uniqueidentifier
            ,@Counter int
            ,@EndTime datetime
            ,@CounterBad int
AS
BEGIN

        BEGIN TRAN

        UPDATE production SET
            counter=@Counter
            ,counterbad = @CounterBad
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