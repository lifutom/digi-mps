<%

Class StandItem

    Private prvID

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get ID
        ID = prvID
    End Property

    Private prvErrNb
    Private prvErrMsg

    Public Property Get ErrNb
        ErrNb = prvErrNb
    End Property

    Public Property Get ErrMsg
        ErrMsg = prvErrMsg
    End Property

    Private prvLang

    Public Property Get Lang
        Lang = prvLang
    End Property

    Public Property Let Lang (Value)
        prvLang = Value
    End Property

    Public Property Let StandID (Value)
        prvID = Value
    End Property

    Public Property Get StandID
        StandID = prvID
    End Property

    '---------------------'
    ' Public Variable     '
    '---------------------'
    Public DeviceList
    Public ModuleList
    Public CategoryList


    Public PlantID
    Public Plant
    Public DeviceID
    Public Device
    Public ModuleID
    Public Module
    Public CategoryID
    Public Category
    Public StandNb
    Public StartDate
    Public Duration
    Public DurationHour
    Public DurationMin
    Public Description
    Public Created
    Public CreatedBy
    Public LastEdit
    Public LastEditBy
    Public Deleted
    Public DeletedBy
    Public IsDeleted

    '---------------------'
    ' Private Variable    '
    '---------------------'

    Private Sub Class_Initialize()
        prvErrNb = 0
        prvErrMsg = ""
        prvLang = IIf(Session("lang") = "","de",Session("lang"))

        Set DeviceList = Server.CreateObject("Scripting.Dictionary")
        Set ModuleList  = Server.CreateObject("Scripting.Dictionary")   

    End Sub


    Public Sub Init

        Dim SQLStr : SQLStr = "SELECT * FROM vwStandstill WHERE id=" & prvID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Fill Rs
        End If

    End Sub

    Public Sub Fill(ByVal Rs)

        prvID = Rs("id")
        PlantID = Rs("plantid")
        Plant = Rs("line")
        DeviceID = Rs("deviceid")
        Device = Rs("plant")
        ModuleID = Rs("moduleid")
        Module = Rs("module")
        CategoryID = Rs("categoryid")
        Category = Rs("category")
        StandNb = Rs("standnb")
        StartDate = Rs("startdate")
        Duration = Rs("duration")

        Dim DurArr

        If Duration = "" OR Duration=":" Then
            DurationHour = 0
            DurationMin = 0
        Else
            DurArr = Split(Duration,":")
            DurationHour = DurArr(0)
            DurationMin = DurArr(1)
        End If

        Description = Rs("description")
        Created = Rs("created")
        CreatedBy = Rs("createdby")
        LastEdit = Rs("lastedit")
        LastEditBy = Rs("lasteditby")
        Deleted = Rs("deleted")
        DeletedBy = Rs("deletedby")
        IsDeleted = Rs("isdeleted")

        Dim Helper : Set Helper = New PlantHelper

        Set DeviceList = Helper.DeviceListStillDD(PlantID)
        Set ModuleList = Helper.ModuleListStillDD(PlantID, DeviceID)

        Set Helper = New CategoryListDD
        Set CategoryList = Helper.List

    End Sub

    Private Sub FillModules

    End Sub

    Private Sub FillCategories

    End Sub

    Public Function Save

        Dim retVal : retVal = False

        Dim Cmd : Set Cmd = Server.CreateObject("ADODB.Command")

        Cmd.CommandText = "StandItemUpdate"
        Cmd.CommandType = adCmdStoredProc
        Set Cmd.ActiveConnection = DbOpenConnection()


        Set Parameter = Cmd.CreateParameter("@RETURN_VALUE", adInteger, adParamReturnValue)
        Cmd.Parameters.Append Parameter

        Set Parameter = Cmd.CreateParameter("@ID", adBigInt, adParamInputOutput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = prvID

        Set Parameter = Cmd.CreateParameter("@PlantID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = PlantID

        Set Parameter = Cmd.CreateParameter("@DeviceID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DeviceID

        Set Parameter = Cmd.CreateParameter("@ModuleID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = ModuleID

        Set Parameter = Cmd.CreateParameter("@CategoryID", adInteger, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = CategoryID

        Set Parameter = Cmd.CreateParameter("@Description", adVarWChar, adParamInput, 1024)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Description

        Set Parameter = Cmd.CreateParameter("@StartDate", adDate, adParamInput)
        Cmd.Parameters.Append Parameter
        Parameter.Value = Replace(CStr(StartDate),"T"," ")

        Set Parameter = Cmd.CreateParameter("@Duration", adVarWChar, adParamInput, 5)
        Cmd.Parameters.Append Parameter
        Parameter.Value = DurationHour & ":" & DurationMin

        Set Parameter = Cmd.CreateParameter("@UserID", adVarWChar, adParamInput, 50)
        Cmd.Parameters.Append Parameter
        Parameter.Value = LastEditBy

        Cmd.Execute

        If Cmd.Parameters("@RETURN_VALUE").Value = 0 Then
            prvID = Cmd.Parameters("@ID").Value
            RetVal = True
        End If

        Set Cmd = Nothing
        Set Parameter = Nothing

        DbCloseConnection()


        Init


        Save = RetVal


        Save = True

    End Function

    Public Function Delete
        Dim SQLStr : SQLStr = "UPDATE standstill SET isdeleted=1, deleted=GETDATE(), deletedby='" & Session("login") & "' WHERE id=" & prvID
        DbExecute(SQLStr)
        Delete = True
    End Function

    Public Function Serialize

        Dim oJSON : Set oJSON = New aspJSON
        Dim SQLString
        Dim Rs
        Dim Helper
        Dim iItem
        Dim idx

        With oJSON.Data
            .Add "status","OK"
            .Add "item", "stillstand-item"
            .Add "id", CLng(prvID)
            .Add "plantid", PlantID
            .Add "plant", Plant
            .Add "deviceid", DeviceID
            .Add "device", Device
            .Add "moduleid", ModuleID
            .Add "module", Module
            .Add "categoryid", CategoryID
            .Add "category", Category
            .Add "standnb", StandNb
            .Add "startdate", DBFormatDateTime(StartDate)
            .Add "durationmin", DurationMin
            .Add "durationhour", DurationHour
            .Add "description", Description
            If  IsNull(Created) Then
                .Add "created", Created
            Else
                .Add "created", DBFormatDate(Created)
            End If
            .Add "createdby", CreatedBy
            .Add "lastedit", LastEdit
            .Add "lasteditby", LastEditBy

            .Add "device-list", oJSON.Collection()
            idx=0
            With .Item("device-list")
                For Each iItem In DeviceList.Items
                    .Add idx, oJSON.Collection()
                    With .Item(idx)
                        .Add "value", iItem.Value
                        .Add "name", iItem.Name
                    End With
                    idx=idx+1
                Next
            End With

            .Add "module-list", oJSON.Collection()
            idx=0
            With .Item("module-list")
                For Each iItem In ModuleList.Items
                    .Add idx, oJSON.Collection()
                    With .Item(idx)
                        .Add "value", iItem.Value
                        .Add "name", iItem.Name
                    End With
                    idx=idx+1
                Next
            End With

        End With

        Set Serialize = oJSON

    End Function

End Class



Class StandHelper

    Public Function GetListLast5 (ByVal ISID)

        Dim SQLStr : SQLStr = "SELECT TOP 5 * FROM vwStandStill WHERE isdeleted=0 AND createdby='" & curUser & "' ORDER BY id DESC"
        Dim RsList : Set RsList = DbExecute(SQLStr)


        Dim prvResult : Set prvResult = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Do While Not RsList.Eof
            Set Item = New StandItem
            Item.Fill(RsList)

            prvResult.Add prvResult.Count, Item

            RsList.MoveNext
        Loop

        RsList.Close
        Set RsList = Nothing

        Set GetListLast5 = prvResult

    End Function

End Class




Class CategoryItem


End Class


Class CategoryListDD

    Private prvResult

    Public Property Get List
        Set List = prvResult
    End Property

    Private Sub Class_Initialize()

        Set prvResult = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        Dim SQLStr : SQLStr = "SELECT * FROM category ORDER BY name"

        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("categoryid")
            Item.Name = iRs("name")
            prvResult.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
    End Sub

End Class






%>

