<%

Class StreamType

    Public Property Get DDList
        Set DDList = prvDDList
    End Property

    Private Item
    Private prvDDList

    Private Sub Class_Initialize()

        Set prvDDList = Server.CreateObject("Scripting.Dictionary")
        Set Item = New ListItem
        Item.Value = "solida"
        Item.Name = "Solida"
        prvDDList.Add Item.Value, Item

        Set Item = New ListItem
        Item.Value = "chew"
        Item.Name = "Chews"
        prvDDList.Add Item.Value, Item

    End Sub

    Public Function Name(key)
        Dim mItem
        Name = ""
        For Each mItem In prvDDList.Items
            If mItem.Value = key Then
               Name = mItem.Name
            End If
        Next
    End Function

End Class
%>