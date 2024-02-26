<!--#include virtual="/Utils/utils.asp" -->
<!--#include virtual="/models/models.asp" -->
<!--#include file="./Controllers/controllers.asp" -->
<%
    Const defaultController = "Home"
    Const defaultAction = "Index"

    Dim Lang
    Dim CurController
    Dim CurAction
    Dim CurPartial

    Dim Referer : Referer = Trim(CStr(Request.QueryString("controller"))) & IIf(Trim(CStr(Request.QueryString("action")))="", "","/" & Trim(CStr(Request.QueryString("action"))))

    Session("referer") = Referer

    Dim curADConn : Set curADConn = Session("curADConn")

    Dim curUser : curUser = Session("login")

    Dim curRootFile : curRootFile = "/" & Application("root")
    Dim CurRoot : CurRoot = Application("root")
    Dim SysAdm : SysAdm = Application("admin")

    Dim actMenu : Set actMenu = New Menu
    Dim actGroupID : actGroupID = Session("AccessGroup")

    Dim IsAdmin : IsAdmin = IIf(Session("IsAdmin") = "", False, Session("IsAdmin"))
    Dim IsKeyUser : IsKeyUser = IIf(Session("IsKeyUser") = "", False, Session("IsKeyUser"))

    Dim curDefaultAccess : curDefaultAccess = CurRoot & "-default"

    If Session("lang") = "" Then
       Lang = Left(LCase(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")),2)
    Else
       Lang = Session("Lang")
    End If

    If Lang <> "de" Then
       Lang = "en"
    End If

    Session("Lang") = Lang

    Dim defReqHelper : Set defReqHelper = New RequestHelper
    Dim CurRequestOpen :  CurRequestOpen = 0
    Dim CurWorkItemOpen :  CurWorkItemOpen = 0

    Dim controller, action , vars
    controller  = Replace(Trim (CStr(Request.QueryString("controller"))),"default.asp,","")
    action      = actionClean (Trim (CStr(Request.QueryString("action"))))

    If IsEmpty(controller) or IsNull(controller) or (controller="") then
        controller = defaultController
    End If


    If IsEmpty(action) or IsNull(action) or (action="") then
        action = defaultAction
    End If


    CurController = controller
    CurAction = action

    If LCase(curController) = "home" And LCase(curAction) = "index" Then
       partial ="yes"
    Else
        partial     = Request.QueryString("partial")
    End If

    If Session("IsGuest") = "" Then
        Response.Redirect(curRootFile & "/login.asp")
    Else
        actMenu.SetGroupAccess actGroupID,Session("login")
        Dim CurRequestStatisticItem : Set CurRequestStatisticItem = New RequestStatistic
        CurRequestOpen = CurRequestStatisticItem.CntOpen
        CurWorkItemOpen = CurRequestStatisticItem.CntWorkItemOpen
        If partial = "" Then
          %> <!--#include file="./views/shared/Site.htmltemplate" --> <%
        Else
          %> <!--#include file="./views/shared/SingleWindow.htmltemplate" --> <%
        End If
    End If



Function ContentPlaceHolder()

    If not Route () then
        result = RouteDebug ()
    End If
End Function


Function Route ()


    Route = False

    Dim controllerName
    controllerName = Trim(curController) + "Controller"

    if Not (Controllers.Exists(LCase(Trim(controllerName)))) Then
        ''Response.Clear
        Response.Status="401 Unauthorized  " & controllerName
        Response.Write(response.Status)
        Response.End
    End if

    set vars    = CollectVariables()

    Dim controllerInstance
    Set controllerInstance = Eval ( " new " +  controllerName)


    Dim actionCallString


    If LCase(curController) = "home" And LCase(curAction) = "index" Then
       Set Vars = Nothing
    End If
    If (Instr(1,curAction,"Post",1)>0) then
           actionCallString = " controllerInstance." + action + "(Request.Form)"
    ElseIf Not (IsNothing(vars)) then
           actionCallString = " controllerInstance." + action + "(vars)"
    Else
           actionCallString = " controllerInstance." + action + "()"
    End If

    Eval (actionCallString)
    Route = true

End Function


Function RouteDebug ()
    Dim controller, action , vars
    controller  = Request.QueryString("controller")
    action      = Request.QueryString("action")

    dim key, keyValue
    for each key in Request.Querystring
        keyValue = Request.Querystring(key)
        'ignore service keys
        if InStr(1,"controller, action, partial",key,1)=0 Then
            Response.Write( key + " = " + keyValue )
        End If
    next
end function

Function CollectVariables
    dim key, keyValue
    Set results = Server.CreateObject("Scripting.Dictionary")
    for each key in Request.Querystring
        keyValue = Request.Querystring(key)
        'ignore service keys
        if InStr(1,"controller, action, partial",key,1)=0 Then
            results.Add key,keyValue
        End If
    next
    if results.Count=0 Then
        Set CollectVariables = Nothing
    else
        Set CollectVariables = results
    End If
End Function


Function actionClean(strtoclean)
    Dim objRegExp, outputStr
    Set objRegExp = New RegExp
    outputStr = strtoclean
    objRegExp.IgnoreCase = True
    objRegExp.Global = True
    objRegExp.Pattern = "\W"
    outputStr = objRegExp.Replace(outputStr, "")
    actionClean = outputStr
End Function

 %>