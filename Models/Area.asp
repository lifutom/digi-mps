<%

Class Area

    Public Property Get DDList
        Set DDList = prvDDList
    End Property

    Private prvDDList
    Private Item

    Private Sub Class_Initialize()

        Set prvDDList = Server.CreateObject("Scripting.Dictionary")
        Set Item = New ListItem
        Item.Value = "pack"
        Item.Name = "Packaging"
        prvDDList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = "prod"
        Item.Name = "Production"
        prvDDList.Add Item.Value, Item

    End Sub

    Public Function Name(key)
        Name = prvDDList(key).Name
    End Function


End Class
%>