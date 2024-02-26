<%
Class ListItem

    Public Value
    Public Name
    Public Selected
    Public Active
    Public IconClass
    Public Disabled
    Public Tag

    private sub Class_Initialize()
        Selected = False
        Active = 1
        Disabled = False
    end sub

End Class
%>