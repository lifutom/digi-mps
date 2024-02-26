<%

Class SupplierController

    Dim Model
    Dim ViewData

    private sub Class_Initialize()
        Set ViewData = Server.CreateObject("Scripting.Dictionary")
    end sub

    private sub Class_Terminate()
    end sub

    public Sub Index()

        Dim pHelper : Set pHelper = New SupplierHelper
        Dim List : Set List = pHelper.List

        ViewData.Add "list", List

        %>   <!--#include file="../views/supplier/index.asp" --> <%

    End Sub

End Class
%>