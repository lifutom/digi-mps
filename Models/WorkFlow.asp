<%
Class WorkFlowItem

    Private prvID

    Public Property Get ID
        ID = prvID
    End Property

    Public Property Let ID (Value)
        prvID = Value
        Init
    End Property

    Public Property Get WorkFlowID
        WorkFlowID = prvID
    End Property

    Public Property Let WorkFlowID (Value)
        prvID = Value
    End Property


    Public WorkFlow
    Public VersionNb
    Public Active
    Public Description


    Public Sub Fill (Rs)

        prvID = Rs("id")
        WorkFlow = Rs("workflow")
        Description = Rs("description")
        Active = Rs("active")

    End Sub


End Class
%>