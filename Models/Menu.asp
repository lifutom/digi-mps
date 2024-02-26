<%

Const cEditButtonIcon = "far fa-edit"
Const cSaveButtonIcon = "far fa-save"
Const cViewButtonIcon = "fas fa-eye"
Const cDashboardIcon = "fas fa-tachometer-alt"
Const cLogoutIcon = "fas fa-sign-out-alt"
Const cItemBannedIcon = "fas fa-ban"
Const cPrintButtonIcon = "fa fa-print"
Const cExcelButtonIcon = "far fa-file-excel"
Const cRefreshButtonIcon = "fas fa-sync"
Const cAddButtonIcon = "fas fa-plus"

Const cRequestSearchIcon = "fas fa-search"

Const cRequestInboxIcon = "fas fa-inbox"
Const cRequestInboxApproveIcon ="w-fa far fa-check-square"

Const cRequestToDoIcon = "fas fa-list-alt"
Const cRequestToDoTaskIcon = "fas fa-list-alt"

Const cUserIcon = "w-fa fas fa-user"
Const cRequestUserIcon = "w-fa fas fa-user"

Const cRequestAccessIcon ="fas fa-universal-access"
Const cRequestAccessShareIcon ="fas fa-globe"
Const cRequestAccessAppIcon ="fas fa-database"
Const cRequestAccessDeviceIcon ="fas fa-hammer"       
Const cRequestAccessWorkFlowIcon ="fas fa-bezier-curve"

'Const cRequestAccessWorkFlowIcon = "fas fa-sitemap"

Const cAccessRight = "fas fa-wrench"


Class MenuItem

    Public App
    Public MenuID
    Public MenuName
    Public MenuLink
    Public SubMenuItems
    Public HasSubMenus
    Public IconClass
    Public Active

    Private Sub Class_Initialize()
        Set SubMenuItems = Server.CreateObject("Scripting.Dictionary")
        Active = False
    End Sub

End Class

Class Menu


   '---- Private Variables
   '----------------------
   Private mLang
   Private mMenuHtml
   Private mActMenu

   Private mList


   Public  Property Get Lang()
        Lang = mLang
   End Property

   Public  Property Let Lang(Val)
        mLang = Val
   End Property

   Public  Property Get ActMenu()
        ActMenu = mActMenu
   End Property

   Public  Property Let ActMenu(Val)
        mActMenu = Val
   End Property


   Public  Property Get MenuHtml()
        MenuHtml = mMenuHtml
   End Property

   Public Property Get MenuList()
        Set MenuList = mList
   End Property

   Public HasAccess

   Private Sub Class_Initialize()
        ' Init MenuStruktur
        Dim Item
        Dim SubItem

        Set mList = Server.CreateObject("Scripting.Dictionary")

        Dim SQLStr : SQLStr = "SELECT * FROM menu WHERE active=1 ORDER BY mainsort, subsort"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim MainItem

        HasAccess = False

        Do While Not Rs.Eof
           Set Item = New MenuItem
           Item.App = Rs("app")
           Item.MenuID = Rs("menuid")
           ''Item.Active = Rs("active")
           If Item.App = "icam" Then
                Item.MenuName = GetLabel(Rs("menuname"),Session("lang"))
           Else
                Item.MenuName = Rs("menuname")
           End If

           Item.MenuLink = curRootFile & Rs("menulink")
           Item.IconClass = Rs("iconclass")
           If Rs("hassubmenus") = 1 Then
              Item.HasSubMenus = True
           Else
              Item.HasSubMenus = False
           End If
           If Item.HasSubMenus Then
                Rs.MoveNext
                If Not Rs.Eof Then
                    MainItem = Rs("menuid")
                End If
                Do While Not Rs.Eof And  Item.MenuID = Left(MainItem, Len(Item.MenuID))
                    Set SubItem = New MenuItem
                    SubItem.App = Rs("app")
                    SubItem.MenuID = Rs("menuid")
                    If SubItem.App = "icam" Then
                        SubItem.MenuName = GetLabel(Rs("menuname"),Session("lang"))
                    Else
                        SubItem.MenuName = Rs("menuname")
                    End If
                    SubItem.MenuLink = curRootFile & Rs("menulink")
                    SubItem.IconClass = Rs("iconclass")
                    ''SubItem.Active = Rs("active")
                    SubItem.HasSubMenus = False
                    Item.SubMenuItems.Add SubItem.MenuID, SubItem
                    Rs.MoveNext
                    If Not Rs.Eof Then
                       MainItem = Rs("menuid")
                    End If
                Loop
                mList.Add Item.MenuID, Item
           Else
                mList.Add Item.MenuID, Item
                Rs.MoveNext
           End If
        Loop

        Rs.Close
        Set Rs = Nothing

   End Sub

   Private Sub Class_Terminate()
   End Sub


   Public Function SetMenuHtml (ByVal App)

        ''mLang = Lang
        ''mActMenu = IIf(aMenu = "", "home", aMenu)
        SetMenuHtml = CreateMenu(App)

   End Function


   Private Function CreateMenu(ByVal App)

        Dim HtmlString
        Dim SubItem
        Dim hlpHtml

        HtmlString = ""
        For Each Item In mList.Items
            If Item.App = App Then
                If Not Item.HasSubMenus Then
                    If mActMenu = Item.MenuID Then
                       HtmlString = HtmlString & "<li class=""active"">"
                    Else
                       HtmlString = HtmlString & "<li>"
                    End If

                    HtmlString = HtmlString &  "<a href=""" & Item.MenuLink & """>"
                    hlpHtml =   "<i class=""" & Item.IconClass & """></i><span>" & Item.MenuName & "$$badge$$</span></a></li></li>"

                    If Item.MenuID = "digitrequest" And CurRequestOpen > 0 Then
                        hlpHtml = Replace(hlpHtml,"$$badge$$","<span class=""badge red"">" & CurRequestOpen & "</span>")
                    ElseIf Item.MenuID = "digitrequest_maint" And CurRequestOpen > 0 Then
                        hlpHtml = Replace(hlpHtml,"$$badge$$","<span class=""badge red"">" & CurRequestOpen & "</span>")
                    Else
                        hlpHtml = Replace(hlpHtml,"$$badge$$","")
                    End If
                    HtmlString = HtmlString & hlpHtml
                Else
                    If Item.Active Then

                        hlpHtml = "<i class=""" & Item.IconClass & """></i>" & Item.MenuName
                        If (Item.MenuID = "digitrequest" And CurRequestOpen > 0) Or (Item.MenuID = "digitworklist" And CurWorkItemOpen > 0) Then
                            hlpHtml = hlpHtml & "&nbsp;<span class=""badge red"">" & IIf(Item.MenuID = "digitrequest", CurRequestOpen, CurWorkItemOpen) & "</span>"
                        End If
                        HtmlString = HtmlString & "<li><a class=""collapsible-header waves-effect arrow-r"">" & hlpHtml & _
                                     "<i class=""fas fa-angle-down rotate-icon""></i></a>" & _
                                    "<div class=""collapsible-body"">" & _
                                    "<ul>"
                        For Each SubItem In Item.SubMenuItems.Items
                            If SubItem.Active Then
                                hlpHtml = "<i class=""" & SubItem.IconClass & """></i> " & SubItem.MenuName
                                If (SubItem.MenuID = "digitrequest_maint" And CurRequestOpen > 0) Or (SubItem.MenuID = "digitworklist_maint" And CurWorkItemOpen > 0) Then
                                    hlpHtml = hlpHtml & "&nbsp;<span class=""badge red"">" & IIf(SubItem.MenuID = "digitrequest_maint", CurRequestOpen, CurWorkItemOpen) & "</span>"
                                End If
                                HtmlString = HtmlString & "<li><a href=""" & SubItem.MenuLink & """ class=""waves-effect"">" & hlpHtml & "</a></li>"
                            End If
                        Next
                        HtmlString = HtmlString & "</ul>"
                    End If
                End If
            End If
        Next

        mMenuHtml = HtmlString

        ''Response.Write mMenuHtml
        ''Response.End

        CreateMenu = HtmlString

    End Function


    Public Sub SetGroupAccess(ByVal id, ByVal UserID)

        Dim gSQLStr : gSQLStr = "SELECT * FROM vwUserlistGroup WHERE userid='" & UserID & "' AND groupid='admin'"
        Dim gRs : Set gRs = DbExecute(gSQLStr)



        If Not gRs.Eof Then

           For Each Item In mList.Items

                Item.Active=True

                HasActiveSubItems = False
                For Each SubItem In Item.SubMenuItems.Items

                    SubItem.Active = True
                    HasActiveSubItems = True

                Next
                If HasActiveSubItems Then
                   Item.Active=True
                End If
            Next

            gRs.Close
            Set gRs = Nothing

            HasAccess = True
            Exit Sub
        End If

        gRs.Close


        Dim SQLStr
        Dim Rs
        Dim MenuID
        Dim Item
        Dim SubItem
        Dim Arr

        gSQLStr = "SELECT * FROM group_access WHERE groupid='" & curDefaultAccess & "'"
        Set Rs = DbExecute(gSQLStr)
        Do While Not Rs.Eof
            MenuID = Rs("menuid")
            For Each Item In mList.Items
                If MenuID = Item.MenuID Then
                  Item.Active=True
                  HasAccess = True
                End If
                For Each SubItem In Item.SubMenuItems.Items
                    If MenuID = SubItem.MenuID Then
                       SubItem.Active = True
                       HasAccess = True
                    End If
                Next
            Next
            Rs.MoveNext
        Loop
        Rs.Close


        gSQLStr = "SELECT * FROM vwUserlistGroup WHERE userid='" & UserID & "' ORDER BY groupname"
        Set gRs = DbExecute(gSQLStr)

        Do While Not gRs.Eof
            SQLStr = "SELECT * FROM group_access WHERE groupid='" & gRs("groupid") & "'"
            Set Rs = DbExecute(SQLStr)
            Do While Not Rs.Eof
                MenuID = Rs("menuid")
                For Each Item In mList.Items
                    If MenuID = Item.MenuID Then
                      Item.Active=True
                      HasAccess = True
                    End If
                    For Each SubItem In Item.SubMenuItems.Items
                        If MenuID = SubItem.MenuID Then
                           SubItem.Active = True
                           HasAccess = True
                        End If
                    Next
                Next
                Rs.MoveNext
            Loop
            Rs.Close
            Set Rs = Nothing
            gRs.MoveNext
        Loop
        gRs.Close
        Set gRs = Nothing

    End Sub

    Public Function GroupAccess(ByVal id)

        Dim SQLStr : SQLStr = "SELECT * FROM group_access WHERE groupid='" & id & "'"
        Dim Rs : Set Rs = DbExecute(SQLStr)
        Dim MenuID
        Dim Item
        Dim SubItem
        Dim Arr
        Dim HasActiveSubItems


        Do While Not Rs.Eof
            MenuID = Rs("menuid")
            For Each Item In mList.Items

                If MenuID = Item.MenuID Then
                  Item.Active=True
                End If
                HasActiveSubItems = False
                For Each SubItem In Item.SubMenuItems.Items
                    If MenuID = SubItem.MenuID Then
                       SubItem.Active = True
                       HasActiveSubItems = True
                    End If
                Next
                If HasActiveSubItems Then
                   Item.Active=True
                End If
            Next
            Rs.MoveNext
        Loop
        Rs.Close
        Set Rs = Nothing
        Set GroupAccess = mList

    End Function


End Class
%>