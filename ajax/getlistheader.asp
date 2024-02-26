<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
%>
<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ListName : ListName = Request.Form("list")
    Dim UserID : UserID = Request.Form("userid")
    Dim ID : ID = Request.Form("id")

    Dim oJSON : Set oJSON = New aspJSON

    Dim Helper
    Dim DataList
    Dim HeaderList

    Dim IsAdmin : IsAdmin = Session("IsAdmin")

    Select Case ListName

        Case "worklist-open-xls"

            Set Helper = New RequestHelper
            Set DataList = Helper.OpenITWorkItems
            Set HeaderList = Helper.HeaderWorkItemsXLS()

        Case "worklist-history-xls"

            Set Helper = New RequestHelper
            Set DataList = Helper.ClosedITWorkItems
            Set HeaderList = Helper.HeaderWorkItemsXLS()

        Case "requestlist-open-xls"

            Set Helper = New RequestHelper
            Set DataList = Helper.OpenRequests("")
            Set HeaderList = Helper.HeaderRequestItemsXLS()

        Case "requestlist-closed-xls"

            Set Helper = New RequestHelper
            Set DataList = Helper.ClosedRequests("")
            Set HeaderList = Helper.HeaderRequestItemsXLS()

        Case "user-xls"

            Set Helper = New ADUserHelper
            Set DataList = Helper.ReviewList
            Set HeaderList = Helper.HeaderUserXLS()

        Case "share-xls"

            Set Helper = New AccessHelper
            Set DataList = Helper.List(cAccessTypeShare)
            Set HeaderList = Helper.HeaderShareItemsXLS()

        Case "app-xls"

            Set Helper = New AccessHelper
            Set DataList = Helper.List(cAccessTypeApp)
            Set HeaderList = Helper.HeaderShareItemsXLS()

        Case "worklist-open-pdf"

            Set Helper = New RequestHelper
            Set DataList = Helper.OpenITWorkItems
            Set HeaderList = Helper.HeaderWorkItemsXLS()

        Case "worklist-closed-pdf"

            Set Helper = New RequestHelper
            Set DataList = Helper.ClosedITWorkItems
            Set HeaderList = Helper.HeaderWorkItemsXLS()

        Case "requestlist-open-pdf"

            Set Helper = New RequestHelper
            Set DataList = Helper.OpenRequests("")
            Set HeaderList = Helper.HeaderRequestItemsXLS()

        Case "requestlist-closed-pdf"

            Set Helper = New RequestHelper
            Set DataList = Helper.ClosedRequests("")
            Set HeaderList = Helper.HeaderRequestItemsXLS()

        Case "user-pdf"

            Set Helper = New ADUserHelper
            Set DataList = Helper.ReviewList
            Set HeaderList = Helper.HeaderUserXLS()

        Case "share-pdf"

            Set Helper = New AccessHelper
            Set DataList = Helper.List(cAccessTypeShare)
            Set HeaderList = Helper.HeaderShareItemsXLS()

        Case "app-pdf"

            Set Helper = New AccessHelper
            Set DataList = Helper.List(cAccessTypeApp)
            Set HeaderList = Helper.HeaderShareItemsXLS()
    End Select

    Select Case  ListName

        Case "worklist-open-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","OpenWorkList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "OpenWorkList",.Item("tabs"), HeaderList, DataList
            End With
        Case "worklist-history-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","ClosedWorkList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "ClosedWorkList",.Item("tabs"), HeaderList, DataList
            End With
        Case "requestlist-open-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","OpenRequestList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "OpenRequestList",.Item("tabs"), HeaderList, DataList
            End With
        Case "requestlist-closed-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","ClosedRequestList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "ClosedRequestList",.Item("tabs"), HeaderList, DataList
            End With
        Case "user-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","UserList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "UserList",.Item("tabs"), HeaderList, DataList
            End With

        Case "share-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","ShareList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "Sharelist",.Item("tabs"), HeaderList, DataList
            End With

        Case "app-xls"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","AppList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "Applist",.Item("tabs"), HeaderList, DataList
            End With

        Case "worklist-open-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","OpenWorkList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "OpenWorkList",.Item("tabs"), HeaderList, DataList
            End With
        Case "worklist-closed-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","ClosedWorkList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "ClosedWorkList",.Item("tabs"), HeaderList, DataList
            End With

        Case "requestlist-open-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","OpenRequestList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "OpenRequestList",.Item("tabs"), HeaderList, DataList
            End With
        Case "requestlist-closed-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","ClosedRequestList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "ClosedRequestList",.Item("tabs"), HeaderList, DataList
            End With
        Case "user-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","UserList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "UserList",.Item("tabs"), HeaderList, DataList
            End With
        Case "share-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","ShareList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "Sharelist",.Item("tabs"), HeaderList, DataList
            End With

        Case "app-pdf"
            With oJSON.Data
                .Add "status","OK"
                .Add "item",ListName
                .Add "isid", Session("login")
                .Add "filename","AppList_" & YEAR(Date) & Right("00" & Month(Date),2) & Right("00" & Day(Date),2)
                .Add "tabs", oJSON.Collection()
                XLSAddTab "Applist",.Item("tabs"), HeaderList, DataList
            End With
    End Select

    Response.Write oJSON.JSONoutput()
    Response.End


    Sub XLSAddTab(ByVal TabName, ByRef TabItem, HeaderList, DataList )

        Dim x : x = TabItem.Count
        Dim idx
        Dim Item
        Dim oItem

        With TabItem
            .Add x, oJSON.Collection()
            With .Item(x)
                .Add "tabname", TabName
                .Add "header", oJSON.Collection()
                With .Item("header")
                    idx=0
                    For Each Item In HeaderList.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "id", Item.ID
                            .Add "description", ToUTF8(Item.Description)
                            .Add "typ", Item.Typ
                            .Add "valuename", Item.ValueName
                            .Add "format", Item.Format
                            .Add "colwidth", Item.ColumnWidth
                        End With
                        idx=idx+1
                    Next
                End With
                .Add "datalist", oJSON.Collection()
                With .Item("datalist")
                    idx=0
                    For Each Item In DataList.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            For Each oItem In HeaderList.Items
                                Select Case oItem.Typ
                                Case cXLSDataTypeInt
                                Case cXLSDataTypeDate
                                    .Add oItem.ValueName, Eval("DBFormatDate(Item." & oItem.ValueName & ")")
                                Case cXLSDataTypeDecimal
                                Case cXLSDataTypeText
                                    .Add oItem.ValueName, ToUTF8(Eval("Item." & oItem.ValueName))
                                Case Else
                                    .Add oItem.ValueName, ToUTF8(Eval("Item." & oItem.ValueName))
                                End Select
                            Next
                        End With
                        idx=idx+1
                    Next
                End With
            End With
        End With
    End Sub

%>