<!--#include file="./utils/utils.asp" -->
<!--#include file="./models/models.asp" -->
<!--#include file="./controllers/controllers.asp" -->
<%
    Const defaultController = "Home"
    Const defaultAction = "Index"

    Dim Lang
    Dim CurController
    Dim CurAction

    Dim curRootFile : curRootFile = "/" & Application("root")
    Dim CurRoot : CurRoot = Application("root")

    Dim DevID : DevID = Request.ServerVariables("REMOTE_ADDR")       



    If Session("lang") = "" Then
       Lang = Left(LCase(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")),2)
    Else
       Lang = Session("Lang")
    End If

    If Lang <> "de" Then
       Lang = "en"
    End If


    Session("Lang") = Lang

    partial     = Request.QueryString("partial")

     

    %> <!--#include file="./views/shared/Site.htmltemplate" --> <%


Function ContentPlaceHolder()

    If not Route () then
        result = RouteDebug ()
    End If
End Function


Function Route ()

    Dim controller, action , vars
    controller  = Replace(Trim (CStr(Request.QueryString("controller"))),"default.asp,","")



    action      = actionClean (Trim (CStr(Request.QueryString("action"))))



    set vars    = CollectVariables()

    Route = False

    If IsEmpty(controller) or IsNull(controller) or (controller="") then
        controller = defaultController
    End If


    If IsEmpty(action) or IsNull(action) or (action="") then
        action = defaultAction
    End If

    CurController = controller
    CurAction = action

    Dim controllerName
    controllerName = Trim(controller) + "Controller"

    if Not (Controllers.Exists(LCase(Trim(controllerName)))) Then
        ''Response.Clear
        Response.Status="401 Unauthorized  " & controllerName
        Response.Write(response.Status)
        Response.End
    End if


    Dim controllerInstance
    Set controllerInstance = Eval ( " new " +  controllerName)




    Dim actionCallString




    If LCase(controller) = "home" And LCase(action) = "index" Then
       Set Vars = Nothing
    End If
    If (Instr(1,action,"Post",1)>0) then
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

    Response.Write(controller)
    Response.Write(action)

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