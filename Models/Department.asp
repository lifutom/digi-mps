<%

Class Department

    Public Property Get DDList
        Set DDList = prvDDList
    End Property

    Public Property Get DDAGList
        Set DDAGList = prvDDAGList
    End Property

    Private prvDDList
    Private prvDDAGList
    Private Item

    Private Sub Class_Initialize()

        Set prvDDList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM department WHERE active=1 ORDER BY department"
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("departmentid")
            Item.Name = Rs("department")
            prvDDList.Add Item.Value, Item
            Rs.MoveNext
        Loop
        Rs.Close

        Set prvDDAGList = Server.CreateObject("Scripting.Dictionary")

        SQLStr = "SELECT * FROM analyzegroup WHERE active=1 ORDER BY agname"
        Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("agid")
            Item.Name = Rs("agname")
            prvDDAGList.Add Item.Value, Item
            Rs.MoveNext
        Loop
        Rs.Close

        Set Rs = Nothing

    End Sub

    Public Function Name(key)
        Name = prvDDList(key).Name
    End Function

    Public Function ListByStreamType(ByVal StreamType)

        Dim DDList : Set DDList = Server.CreateObject("Scripting.Dictionary")


        Dim SQLStr

        If StreamType <> "all"  Then
            SQLStr = "SELECT * FROM department WHERE active=1 AND streamtype='" & StreamType & "' ORDER BY department"
        Else
            ''SQLStr = "SELECT * FROM department WHERE active=1"
            SQLStr = "SELECT agid As departmentid, agname As department FROM analyzegroup WHERE active=1 ORDER BY agname"
        End If

        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("departmentid")
            Item.Name = Rs("department")
            DDList.Add Item.Value, Item
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing
        Set ListByStreamType = DDList

    End Function

    Public Function ListAll()

        Dim DDList : Set DDList = Server.CreateObject("Scripting.Dictionary")


        Dim SQLStr


        SQLStr = "SELECT * FROM department WHERE active=1"
       
        Dim Rs : Set Rs = DbExecute(SQLStr)

        Do While Not Rs.Eof
            Set Item = New ListItem
            Item.Value = Rs("departmentid")
            Item.Name = Rs("department")
            DDList.Add Item.Value, Item
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing
        Set ListAll = DDList

    End Function


End Class
%>