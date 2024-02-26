<!--#include virtual="/utils/utils.asp" -->
<!--#include virtual="/models/models.asp" -->
<%

    Dim Lang
    Dim strLocale : strLocale = Left(LCase(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")),2)
    Dim strSubLocale : strSubLocale = Right(Left(LCase(Request.ServerVariables("HTTP_ACCEPT_LANGUAGE")),5),2)

    Dim Referer : Referer = Session("referer")

    If Lang="" Then
       Lang = strLocale
    End If

    Select Case Lang
       Case "de"
       Case "en"
       Case Else
          Lang="en"
    End Select


    Session("Lang") = Lang

    Dim curRootFile : curRootFile = "/" & Application("root")
    Dim CurRoot : CurRoot = Application("root")

    Dim curADConn : Set curADConn = Session("curADConn")

    If IsPostBack Then

        Dim Login : Login = Request.Form("login")
        Dim origLogin : origLogin = Login

        Dim Password : Password = Request.Form("password")


        Dim AD : Set AD = New ADAccess
        ''Dim DigiMPSAD : Set DigiMPSAD = New DigiMPSAccess

        If AD.AuthenticateUser(Login,Password) Then

            Response.Write "origLogin " & origLogin

            Session("login") = origLogin
            Session("IsGuest") = False
            Session("referer") = ""

            Select Case Referer
                Case "request/form"
                    Response.Redirect(curRootFile & "/" & Referer & "/?partial=yes")
            Case Else
                    Response.Redirect(curRootFile)
            End Select
        Else
            Response.Redirect(curRootFile & "/logout.asp")
        End If

    End If
   
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>ICAM</title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <!-- Bootstrap core CSS -->
    <link href="<%=CurRootFile%>/css/bootstrap.min.css" rel="stylesheet">

    <!-- Material Design Bootstrap -->
    <link href="<%=CurRootFile%>/css/mdb.css" rel="stylesheet">

    <!-- JQuery -->
    <script type="text/javascript" src="<%=CurRootFile%>/js/jquery-3.3.1.min.js"></script>

    <!-- jQueryValidation -->
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/jquery.validate.min.js"></script>
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/additional-methods.min.js" type="text/javascript"></script>
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/localization/messages_<%=Session("lang")%>.js" type="text/javascript"></script>

    <!-- Utils -->
    <script src="<%=CurRootFile%>/js/modules/myutil.1.0.js" type="text/javascript"></script>

    <!-- Moments -->
    <script src="<%=CurRootFile%>/js/modules/moment-with-locales.js" type="text/javascript"></script>

</head>
<body class="fixed-sn grey-skin">
    <!--Grid row-->
    <div class="row">
        <div class="col-md-12 col-lg-12 col-xl-12 offset-md-4 offset-xl-3 offset-lg-4">
            <!--Grid column-->
            <div class="col-md-5 col-lg-5 col-xl-4 mb-4">
                <!-- Default form login -->
                <form class="text-center border border-light p-5" method="POST" action="login.asp">
                        <div class="float-left ml-1 mt-1 mb-4"><img src="<%=curRootFile%>/Images/digimps.png" alt="logo" title="MSD Austria" width="50" height="auto"></div>
                        <h4>ICAM</h4>
                        <!-- Email -->
                        <input type="text" name="login" id="defaultLoginFormEmail" class="form-control mb-4" placeholder="ISID" required="required">

                        <!-- Password -->
                        <input type="password" name="password"  id="defaultLoginFormPassword" class="form-control mb-4" placeholder="Passwort" required="required">

                        <!-- Sign in button -->
                        <button class="btn btn-cyan btn-block my-4" type="submit">Login</button>
                </form>
            </div>
        </div>
    </div>
</body>
 <!-- SCRIPTS -->
<!-- Tooltips -->
<script type="text/javascript" src="<%=curRootFile%>/js/popper.min.js"></script>

<!-- Bootstrap core JavaScript -->
<script type="text/javascript" src="<%=curRootFile%>/js/bootstrap.min.js"></script>

<!-- MDB core JavaScript -->
<script type="text/javascript" src="<%=curRootFile%>/js/mdb.min.js"></script>

</html>

