<%

Class Tier1Controller

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub People()

        Dim Departments : Set Departments = New Department
        Dim PeopleHlp : Set PeopleHlp = New PeopleHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", PeopleHlp.PeopleList

        %>   <!--#include file="../views/Tier1/People.asp" --> <%

    End Sub

    public Sub Quality()

        Dim Departments : Set Departments = New Department
        Dim QualityHlp : Set QualityHlp = New QualityHelper
        Dim StreamTypes : Set StreamTypes = New StreamType

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", Nothing 'QualityHlp.QualityList
        ViewData.Add "ddstreamtypelist",StreamTypes.DDList

        %>   <!--#include file="../views/Tier1/Quality.asp" --> <%

    End Sub

    public Sub Events()

        Dim Departments : Set Departments = New Department
        Dim EventsHlp : Set EventsHlp = New EventsHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", Nothing 'EventsHlp.EventsList

        %>   <!--#include file="../views/Tier1/Events.asp" --> <%

    End Sub


    public Sub Capa()

        Dim Departments : Set Departments = New Department
        Dim CapaHlp : Set CapaHlp = New CapaHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", CapaHlp.CapaList

        %>   <!--#include file="../views/Tier1/Capa.asp" --> <%

    End Sub

    public Sub CC()

        Dim Departments : Set Departments = New Department
        Dim CCHlp : Set CCHlp = New CCHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", CCHlp.CCList

        %>   <!--#include file="../views/Tier1/CC.asp" --> <%

    End Sub


    Public Sub Complaints()

        Dim CCHlp : Set CCHlp = New CHelper

        ViewData.Add "list", CCHlp.CList

        %>   <!--#include file="../views/Tier1/Complaint.asp" --> <%

    End Sub

    public Sub DeliveryEsca()

        Dim CCHlp : Set CCHlp = New DeliveryEscaHelper

        ViewData.Add "list", CCHlp.EscaList

        %>   <!--#include file="../views/Tier1/DeliveryEsca.asp" --> <%

    End Sub

    public Sub QualityEsca()

        Dim CCHlp : Set CCHlp = New QualityEscaHelper

        ViewData.Add "list", CCHlp.EscaList

        %>   <!--#include file="../views/Tier1/QualityEsca.asp" --> <%

    End Sub


    public Sub Safety()

        Dim Departments : Set Departments = New Department
        Dim SafetyHlp : Set SafetyHlp = New SafetyHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", SafetyHlp.SafetyList

        %>   <!--#include file="../views/Tier1/Safety.asp" --> <%

    End Sub


    public Sub DeliveryBulk()

        Dim PlantHlp : Set PlantHlp = New PlantHelper
        Dim Plants : Set Plants = PlantHlp.DDList("","prod")

        ViewData.Add "ddplantlist", Plants

        %>   <!--#include file="../views/Tier1/DeliveryBulk.asp" --> <%

    End Sub

    public Sub DeliveryPack()

        Dim PlantHlp : Set PlantHlp = New PlantHelper
        Dim Plants : Set Plants = PlantHlp.DDList("","pack")

        ViewData.Add "ddplantlist", Plants

        %>   <!--#include file="../views/Tier1/DeliveryPack.asp" --> <%

    End Sub

    public Sub Other()

        Dim Departments : Set Departments = New Department
        Dim ObjHlp : Set ObjHlp = New OHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "ocadlist", ObjHlp.CatList
        ViewData.Add "list", ObjHlp.OList


        %>   <!--#include file="../views/Tier1/OtherTier.asp" --> <%

    End Sub

    public Sub OtherNote()

        Dim Departments : Set Departments = New Department
        Dim ObjHlp : Set ObjHlp = New ONHelper

        ViewData.Add "dddepartmentlist", Departments.DDList
        ViewData.Add "list", ObjHlp.ONList


        %>   <!--#include file="../views/Tier1/OtherTierNote.asp" --> <%

    End Sub


End Class
%>