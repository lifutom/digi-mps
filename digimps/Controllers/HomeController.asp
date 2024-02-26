<%

Class HomeController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

       
        Dim pHelper : Set pHelper = New PlantHelper
        Dim oPlant  : Set oPlant = New Plant
        Dim oControl :  Set oControl = New Control
        Dim hlpCont

        'checkif control is set (Cookie exists)'
        ''Response.Cookies("controlid")=""
        If DevID ="" Then

            ViewData.Add "plantitems", pHelper.SelectAll()

            %><!--#include file="../views/Home/setenv.asp" --> <%
            
        Else
            oControl.ControlID = DevID
            PlantID = oControl.PlantID

            ''Set Environment for Linked Device'
            If CInt(oControl.PlantID) > 0 Then
               Set oPlant = pHelper.SetEnvForLinkedControl(oControl.PlantID)
            End If

            ViewData.Add "plant", oPlant
            ViewData.Add "active_plant", oControl.PlantID
            ViewData.Add "active_downtimeid", ""
            ViewData.Add "control", oControl
            %>   <!--#include file="../views/Home/Index.asp" --> <%
        End if
    End Sub

    public Sub ClearEnv()

        Dim oControl :  Set oControl = New Control

        oControl.ControlID = Request.Cookies("controlid")
        oControl.ClearLink

        Response.Cookies("controlid")=""
        Response.Redirect(CurRootFile)

    End Sub


    public Sub SetDevice(vars)


        Dim pHelper : Set pHelper = New PlantHelper
        Dim oPlant
        Dim ActivePlant
        Dim ActiveDevice

        ActivePlantID =  Request.Cookies("linked_plant")
        ActiveDeviceID = vars("id")
        Response.Cookies("active_device") = ActiveDeviceID

        ''Set Environment for Linked Device'
        If ActivePlantID <> "" Then
           Set oPlant = pHelper.SetEnvForLinkedControl(ActivePlantID)
           If ActiveDeviceID = "" Then
              ActiveDeviceID = 1
           End If
        Else
           ' falls nicht gesetzt'
           ActivePlantID =  1
           ActiveDeviceID = 1
           Response.Cookies("linked_plant") = ActivePlantID
           Response.Cookies("active_device") = ActiveDeviceID
           Set oPlant = pHelper.SetEnvForLinkedControl(1)
        End If

        ''Response.Write  "ActivePlantID: " & ActivePlantID & "<br>"
        ''Response.Write  "ActiveDeviceID: " & ActiveDeviceID & "<br>"

        ViewData.Add "plant", oPlant
        ViewData.Add "active_plant", ActivePlantID
        ViewData.Add "active_device", ActiveDeviceID
        %>   <!--#include file="../views/Home/Index.asp" --> <%
    End Sub

    Public Sub SetEnvPeeeost(args)
        Dim oControl :  Set oControl = New Control
        Dim PlantID : PlantID = 1
        Dim hlpCont : hlpCont=oControl.SetControlID(PlantID)
        Response.Cookies("ControlID") = hlpCont
        Response.Cookies("ControlID").Expires = Date + (365*10)
        oControl.ControlID = hlpCont
        %>   <!--#include file="../views/Home/envset.asp" --> <%

    End Sub



End Class
%>