<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
%>
<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%


    Dim oUpload : Set oUpload = New clsUpload

    Dim ItemType : ItemType = oUpload("item").Value
    Dim ID : ID = oUpload("id").Value
    Dim tstID
    Dim Status : Status = "NOTOK"
    Dim ErrMsg : ErrMsg = ""
    Dim Item
    Dim ItemID

    Dim oJSON : Set oJSON = New aspJSON

    Select Case ItemType

        Case "spare"

            Set Item = New Spare
            Item.ID = ID
            Item.SparepartNbOrg = oUpload("sparepartnborg").Value
            Item.SparepartNb = Decode(oUpload("nb").Value)
            Item.Sparepart = Decode(oUpload("name").Value)
            Item.SpareNb = Decode(oUpload("snb").Value)
            Item.MinLevel = oUpload("minlevel").Value
            Item.ActLevel = oUpload("actlevel").Value
            Item.MinOrderLevel = oUpload("minorderlevel").Value
            Item.defsupplierid = oUpload("defsupplierid").Value

            Item.TargetOrder = IIf(oUpload("targetorder").Value <> "", 1, 0)
            Item.Intervall = oUpload("intervall").Value
            Item.IntervallTyp = oUpload("intervalltyp").Value
            Item.StartDate = oUpload("startdate").Value
            Item.OrderLevel = oUpload("orderlevel").Value
            Item.CatID = oUpload("catid").Value
            Item.Active = oUpload("active").Value
            ItemID = "Item.ID"

        Case "task-uaf"

            Set Item = New RequestDetail
            Item.TID = oUpload("taskid").Value
            ItemID = "Item.TID"

        Case "task-notdone"

            Set Item = New RequestDetail
            Item.TID = oUpload("taskid").Value
            ItemID = "Item.TID"

    End Select

    Select Case ItemType
        Case "spare"
            If Item.Save Then
                Status = "OK"
                ID = eval(ItemID)
                Item.SaveImage oUpload("spareimage")
            Else
               ID = eval(ItemID)
               ErrMsg = "Konnte nicht gesichert werden"
            End If
        Case "task-uaf"
            If Item.SaveUAF(oUpload("uaf")) Then
                Status = "OK"
                ID = eval(ItemID)
            End If
            ErrMsg = Item.ErrMsg

        Case "task-notdone"
            If Item.NotDone Then
                Status = "OK"
                ID = eval(ItemID)
            End If
            ErrMsg = Item.ErrMsg 
    End Select


    With oJSON.Data
            Select Case ItemType
               Case "spare"
                    .Add "status", Item.ErrStatus
                    .Add "errmsg", Item.ErrMsg
                    .Add "errnumber", Item.ErrNumber
                    .Add "id", CLng(ID)
               Case Else
                   .Add "status", Status
                   .Add "errmsg", ErrMsg
                   .Add "id", ID
            End Select
    End With

    Dim LogFileName : LogFileName = Application("tempdir") & "\ajaxjson.log"

    Dim Fs : Set Fs = Server.CreateObject("Scripting.FileSystemObject")

    If Not Fs.FileExists(LogFileName) Then
        Fs.CreateTextFile LogFileName
    End If

    Dim LogFile : Set LogFile =  Fs.OpenTextFile(LogFileName, 8)

    LogFile.WriteLine oJSON.JSONoutput()

    LogFile.Close

    Response.Write oJSON.JSONoutput()
    Response.End

%>