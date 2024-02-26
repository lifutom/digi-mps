<%

'
' This files defines the Status model
'
Class Plant

    Public PlantID
    Public Plant
    Public Description
    Public RoomNb
    Public Image
    Public DeviceList

    Private Sub Class_Initialize()
          PlantID = -1
          Plant =""
          Descripition = ""
          RoomNb = ""
          Image = ""
          Set DeviceList = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Sub InitObject(ByVal mPlantID)

        '1.Fill Plant Fields'
        PlantID = mPlantID
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE plantid=" & mPlantID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            PlantID = mPlantID
            Plant = iRs("plant")
            Description = iRs("description")
            Image = iRs("image_file")
            RoomNb = iRs("roomnb")
            '2.Fill Device List'
            SQLStr = "SELECT DeviceID FROM plant_device WHERE plantid=" & mPlantID
            Dim Rs1 : Set Rs1 = DbExecute(SQLStr)
            Dim Item
            Do While Not Rs1.Eof
               Set Item = New Device
               Item.PlantID = mPlantID
               Item.DeviceID = Rs1("DeviceID")
               DeviceList.Add Item.DeviceID, Item
               Rs1.MoveNext
            Loop
        End If
        ''DbCloseConnection

    End Sub


End Class 'Status

Class Device

    Private mDeviceID
    Public PlantID
    Public Device
    Public Description
    Public Image
    Public Aktiv

    Public ComponentList

    Public Property Get DeviceID
        DeviceID = mDeviceID
    End Property

    Public Property Let DeviceID (Value)
        mDeviceID = Value
        If mDeviceID > 0 Then
           InitObject
        End If
    End Property

    Private Sub Class_Initialize()
          DeviceID = -1
          PlantID = -1
          Device =""
          Descripition = ""
          Image = ""
          Aktiv = False
          Set ComponentList = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Public Sub InitObject
        '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM plant_device WHERE deviceid=" & mDeviceID
        Dim iRs : Set iRs = DbExecute(SQLStr)

        If Not iRs.Eof Then
            Device = iRs("device")
            Description = iRs("description")
            Image = iRs("image_file")
            Aktiv = False
            '2.Fill Device List'
            SQLStr = "SELECT componentid FROM device_component WHERE deviceid=" & mDeviceID
            Dim Rs1 : Set Rs1 = DbExecute(SQLStr)
            Dim Item
            Do While Not Rs1.Eof
               Set Item = New Component
               Item.PlantID = PlantID
               Item.DeviceID = mDeviceID
               Item.ComponentID = Rs1("componentid")
               ComponentList.Add Item.ComponentID, Item
               Rs1.MoveNext
            Loop
        End If
        iRs.Close

    End Sub

End Class 'Status


Class Component

    Private mComponentID
    Public PlantID
    Public DeviceID
    Public Component
    Public Description

    Public Property Get ComponentID
        ComponentID = mComponentID
    End Property

    Public Property Let ComponentID (Value)
        mComponentID = Value
        If mComponentID > 0 Then
           InitObject
        End If
    End Property

    Private Sub Class_Initialize()
          ComponentID = -1
          DeviceID = -1
          PlantID = -1
          Component =""
          Descripition = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Private Sub InitObject
        '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM device_component WHERE componentid=" & mComponentID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Component = Rs("component")
            Description = Rs("description")
        End If
    End Sub



End Class 'Status



Class Failure

    Public FailureID
    Public PlantID
    Public DeviceID
    Public ComponentID
    Public Failure
    Public Description

    Private Sub Class_Initialize()
          FailureID   = -1
          ComponentID = -1
          DeviceID = -1
          PlantID = -1
          Failure =""
          Descripition = ""
    End Sub

    Private Sub Class_Terminate()
    End Sub


End Class 'Status




'======================
Class PlantHelper

    Dim selectSQL

    Private Sub Class_Initialize()
      selectSQL = "SELECT DISTINCT * FROM plant ORDER by plant"
    End Sub

    Private Sub Class_Terminate()
    End Sub


    Public Function SetEnvForLinkedControl(ByVal PlantID)

        Dim oPlant : Set oPlant = New Plant

        If PlantID <> "" Then
           oPlant.PlantID = PlantID
        End If

        Set SetEnvForLinkedControl = oPlant

    End Function


    Public Function PlantList

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant ORDER BY plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Plant
            Item.InitObject(Rs("plantid"))
            List.Add Item.PlantID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  PlantList =  List

    End Function

    Public Function PlantListMin

        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE sparemaint=1 ORDER BY plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        Do While Not Rs.Eof
            Set Item = New Plant
            Item.PlantID = Rs("plantid")
            Item.Plant = Rs("plant")
            List.Add Item.PlantID, Item
            Rs.MoveNext
        Loop
        DbCloseConnection
        Set  PlantListMin =  List

    End Function


    Public Function GetObjByID ( PlantID )
        Dim obj
        Dim records

        Set objCommand=Server.CreateObject("ADODB.command")
        objCommand.ActiveConnection=DbOpenConnection()
        objCommand.NamedParameters = False
        objCommand.CommandText = "SELECT * FROM plant WHERE plantid=" & PlantID
        objCommand.CommandType = adCmdText
        Set records = objCommand.Execute
        If records.eof Then
            Set GetLandObjByID = Nothing
        Else
            Set obj = PopulateObjectFromRecord(records)
            Set GetObjByID = obj
        End If
        records.Close
        Set records = Nothing
    End Function


    Public Function GetFailureListByID(ByVal ComponentID)

        Dim FailureList : Set FailureList = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM vComponentenFailureList WHERE componentid=" & ComponentID
       
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New Failure
                Item.FailureID = Rs("failureid")
                Item.DeviceID = Rs("deviceid")
                Item.PlantID = Rs("plantid")
                Item.ComponentID = Rs("componentid")
                Item.Failure = Rs("failure")
                Item.Description = Rs("description")
                FailureList.Add Item.FailureID, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
        Set  GetFailureListByID =  FailureList


    End Function

    Public Function GetFailureListExt()
        '1.Fill Plant Fields'
        Dim FailureList : Set FailureList = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM failurelist ORDER BY failure"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New Failure
                Item.FailureID = Rs("failureid")
                Item.Failure = Rs("failure")
                Item.Description = Rs("description")
                FailureList.Add Item.FailureID, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
        Set  GetFailureListExt =  FailureList
    End Function

    Public Function DDList (ByVal StreamType, ByVal Area)

        '1.Fill Plant Fields'
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE active=1" & IIf(StreamType="",""," AND streamtype='" & StreamType & "'") & IIf(Area = "", "", " AND area='" & Area & "'") & " ORDER BY plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.Value = Rs("plantid")
                Item.Name = Rs("plant")
                List.Add Item.Value, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
        Set  DDList =  List


    End Function


     Public Function DDSpareList ()

        '1.Fill Plant Fields'
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE active=1 AND sparemaint=1 ORDER BY plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.Value = Rs("plantid")
                Item.Name = Rs("plant")
                List.Add Item.Value, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
        Set  DDSpareList =  List


    End Function

    Public Function DeviceListDD (ByVal PlantID, ByVal WithEmpty)

        '1.Fill Plant Fields'
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant_device WHERE sparemaint=1 AND plantid=" & PlantID & " ORDER BY device"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If WithEmpty Then

        End If

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.Value = Rs("deviceid")
                Item.Name = Rs("device")
                List.Add Item.Value, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
        Set  DeviceListDD =  List


    End Function

    Public Function DeviceListMin (ByVal PlantID, ByVal WithEmpty)

        '1.Fill Plant Fields'
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant_device WHERE plantid=" & PlantID & " AND sparemaint=1 ORDER BY sort"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If WithEmpty Then

        End If

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.Value = Rs("deviceid")
                Item.Name = Rs("device")
                List.Add Item.Value, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
        Set  DeviceListMin =  List


    End Function


    Public Function DeviceListStillDD (ByVal PlantID)

        '1.Fill Plant Fields'
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant_device WHERE sparemaint=1 AND plantid=" & PlantID & " ORDER BY device"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.Value = Rs("deviceid")
                Item.Name = Rs("device")
                List.Add Item.Value, Item
                Rs.MoveNext
            Loop
        End If
        Rs.Close
        Set  DeviceListStillDD =  List


    End Function


    Public Function PlantListStillDD ()

        '1.Fill Plant Fields'
        Dim List : Set List = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE stillstand=1 ORDER BY plant"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.Value = Rs("plantid")
                Item.Name = Rs("plant")
                List.Add Item.Value, Item
                Rs.MoveNext
            Loop
        End If
        Rs.Close
        Set  PlantListStillDD =  List


    End Function

    Public Function ModuleListStillDD(ByVal PlantID, ByVal DeviceID)

        Dim Results : Set Results = Server.CreateObject("Scripting.Dictionary")
        Dim Item

        If DeviceID = "" Then
            DeviceID = -1
        End If


        Dim SQLStr : SQLStr = "SELECT * FROM vwModulePlant WHERE active=1 AND isinstand=1 AND plantid=" & PlantID & " AND deviceid=" & DeviceID

        Dim iRs : Set iRs = DbExecute(SQLStr)

        Do While Not iRs.Eof
            Set Item = New ListItem
            Item.Value = iRs("moduleid")
            Item.Name = iRs("module")
            Results.Add Item.Value, Item
            iRs.MoveNext
        Loop

        iRs.Close
        Set iRs = Nothing
        Set ModuleListStillDD = Results

    End Function





End class 'PlantHelper
%>