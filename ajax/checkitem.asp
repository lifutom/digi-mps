<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ItemType : ItemType = Request.Form("item")
    Dim ItemKey : ItemKey = Request.Form("key")
    Dim ID : ID = Request.Form("id")
    Dim Status : Status = "NOTOK"
    Dim ErrMsg : ErrMsg = ""
    Dim HlpStatus
    Dim Item
    Dim SQLStr
    Dim Rs

    Dim oJSON : Set oJSON = New aspJSON

    Select Case ItemType

        Case "failureitem"

            Set Item = New FailureItem

        Case "group"

            Set Item = New Group

        Case "user"

            Set Item = New User

        Case "site"

            Set Item = New Site

        Case "warehouse"

            Set Item = New Warehouse

        Case "supplier"

            Set Item = New Supplier

        Case "module"

            Set Item = New Module

        Case "categorie"

            Set Item = New Categorie

        Case "spare"

            Set Item = New Spare

        Case "near_close"

            Set Item = New NearMiss
            Item.Init(ID)

        Case "room"

            Set Item = New RoomItem

        Case "region"

            Set Item = New RegionItem

        Case "building"

            Set Item = New BuildingItem

        Case "spare_link"

            Set Item = New SparepartLink

        Case "spareloc"

            Set Item = New Location

        Case "spareloc_act"

            Set Item = New Location

        Case "box"
            Set Item = New Box

        Case "module_link"
            Set Item = New ModulePlant


    End Select

    Select Case ItemType

    Case "near_close"

        If Not Item.CanClose Then
           Status = "NOTOK"
           ErrMsg = Html.Encode("Es sind offene Tasks vorhanden. Sie können diesen Vorgang nicht abschließen.")
        Else
            Status = "OK"
            If Item.State < 3 Then
                ErrMsg = Html.Encode("Wollen sie diesen Vorgang wirklich abschließen?")
            Else
                ErrMsg = Html.Encode("Wollen sie diesen Vorgang wirklich wieder öffnen?")
            End If
        End If

    Case "spare_link"

        If Item.Exists(Request.Form("sparepartid"), Request.Form("plantid"), Request.Form("deviceid"), Request.Form("moduleid")) Then
           Status = "OK"
           ErrMsg = "Eintrag bereits vorhanden"
        End If

    Case "spareloc"

        If Item.Exists(Request.Form("id"), Request.Form("sparepartid")) And  Request.Form("movid") = "" Then
            Status = "NOTOK"
            ErrMsg = "Eintrag bereits vorhanden"
            HlpStatus = "nodata"
        ElseIf Item.BoxExists(Request.Form("id")) Then
            If CLng(Item.LocationID) = CLng(Request.Form("movid")) Then
                Status = "NOTOK"
                ErrMsg = "Eintrag bereits vorhanden"
                HlpStatus = "nodata"
            Else
                Status = "OK"
                ErrMsg = " "
                HlpStatus = "data"
            End If
        Else
            Status = "OK"
            ErrMsg = " "
            HlpStatus = "nodata"
        End If

    Case "spareloc_act"

        Item.InitBySparepartID Request.Form("id"), Request.Form("sparepartid")
        If CDbl(Item.Act)  < CDbl(Request.Form("act")) Then
            Status = "NOTOK"
            ErrMsg = "Es sind nur " & DBFormatNumber(Item.Act) & " vorhanden"
            HlpStatus = "nodata"
        Else
            Status = "OK"
            ErrMsg = " "
            HlpStatus = "data"
        End If

    Case "module_link"

        If Item.Exists(ID, Request.Form("plantid"), Request.Form("deviceid")) Then
            Status = "OK"
            ErrMsg = ToUTF8("Zuordnung " & Item.Plant &  " " & Item.Device & "  bereits vorhanden")
        End If

    Case Else
        If Item.Exists(ID) Then
           Status = "OK"
           ErrMsg = "Eintrag " & ID & " bereits vorhanden"
        End If
    End Select

    With oJSON.Data
            .Add "status", Status
            .Add "errmsg", ErrMsg
            .Add "id", ID
            Select Case ItemType
            Case "spareloc"
                .Add "data", IIf(HlpStatus = "data",1,0)
                .Add "mov2locationid", CLng(Item.LocationID)
                .Add "location", oJSON.Collection()
                With .Item("location")
                   .Add "locationid", CLng(Item.LocationID)
                   .Add "warehouseid", Item.WarehouseID
                   .Add "shelfid", Item.ShelfID
                   .Add "compid", Item.CompID
                   .Add "boxid", Item.BoxID
                End With
            Case Else
                .Add "data", 0
            End Select
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>