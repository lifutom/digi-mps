<%

'
' This files defines the Status model
'
Class Plant

    Private mPlantID
    Public Plant
    Public Description
    Public RoomNb
    Public Image
    Public DeviceList


    Public Property Get PlantID
        PlantID = mPlantID
    End Property

    Public Property Let PlantID (Value)
        mPlantID = Value
        If mPlantID > 0 Then
           InitObject
        End If
    End Property

    Private Sub Class_Initialize()
          mPlantID = -1
          Plant =""
          Descripition = ""
          RoomNb = ""
          Image = ""
          Set DeviceList = Server.CreateObject("Scripting.Dictionary")
    End Sub

    Private Sub Class_Terminate()
    End Sub

    Private Sub InitObject

        '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM plant WHERE plantid=" & mPlantID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Plant = Rs("plant")
            Description = Rs("description")
            Image = Rs("image_file")
            RoomNb = Rs("roomnb")
            '2.Fill Device List'
            SQLStr = "SELECT DeviceID FROM plant_device WHERE active=1 AND plantid=" & mPlantID
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
        DbCloseConnection

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

    Private Sub InitObject
        '1.Fill Plant Fields'
        Dim SQLStr : SQLStr = "SELECT * FROM plant_device WHERE deviceid=" & mDeviceID
        Dim Rs : Set Rs = DbExecute(SQLStr)

        If Not Rs.Eof Then
            Device = Rs("device")
            Description = Rs("description")
            Image = Rs("image_file")
            Aktiv = False
            '2.Fill Device List'
            SQLStr = "SELECT componentid FROM device_component WHERE active=1 AND deviceid=" & mDeviceID
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

Class ListItem

    Public ID
    Public Name
    Public Enabled

End Class




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

    Public Function SelectAll()
          Dim records
          set objCommand=Server.CreateObject("ADODB.command")
          objCommand.ActiveConnection=DbOpenConnection()
          objCommand.NamedParameters = False
          objCommand.CommandText = selectSQL
          objCommand.CommandType = adCmdText
          set records = objCommand.Execute
          if records.eof then
          Set SelectAll = Nothing
          else
          Dim results, obj, record
          Set results = Server.CreateObject("Scripting.Dictionary")
          while not records.eof
          set obj = PopulateObjectFromRecord(records)
          results.Add obj.ID, obj
          records.movenext
          wend
          set SelectAll = results
          records.Close
          End If
          set records = nothing
    End Function

    Private Function PopulateObjectFromRecord(record)

        Dim obj
        If record.eof Then
            Set PopulateObjectFromRecord = Nothing
        Else

            Set obj = new ListItem
            obj.ID = record("plantid")
            obj.Name = record("Plant")
            obj.Enabled = True
            Set PopulateObjectFromRecord = obj
        End If
    End function

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


    Public Function ControlList(ByVal PlantID)
        '1.Fill Plant Fields'
        Set ControlList = Server.CreateObject("Scripting.Dictionary")
        Dim SQLStr : SQLStr = "SELECT * FROM plant_control WHERE plantid=" & PlantID & " ORDER BY controlid"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim Item

        If Not Rs.Eof Then
            Do While Not Rs.Eof
                Set Item = New ListItem
                Item.ID = Rs("controlid")
                Item.Name = Rs("controlid") & " " & IIf(IsNull(Rs("linked_date")), "", DBFormatISODate(Rs("linked_date")))
                Item.Enabled = IIf(IsNull(Rs("linked_date")), 1, 0)
                ControlList.Add Item.ID, Item
                Rs.MoveNext
            Loop
        End If
        DbCloseConnection
    End Function



End class 'PlantHelper
%>