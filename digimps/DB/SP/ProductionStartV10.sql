CREATE PROCEDURE ProductionStart
            @ProductionID uniqueidentifier OUTPUT
            ,@PlantID int
            ,@StartTime datetime
            ,@ControlID nvarchar(50)
            ,@UinNb nvarchar(50)
            ,@BatchNb nvarchar(50)
AS
BEGIN


        BEGIN TRAN

        SET  @ProductionID = NEWID()

        INSERT INTO production (
                productionid
                ,plantid
                ,start_time
                ,controlid
                ,uin_number
                ,batch_number
        )
        VALUES (
                @ProductionID
                ,@PlantID
                ,@StartTime
                ,@ControlID
                ,@UinNb
                ,@BatchNb
        )
        IF @@ERROR <> 0
        BEGIN
                ROLLBACK TRAN
                RETURN -1
        END

        COMMIT

        RETURN 0


END