<!--#include file="./utils/utils.asp" -->
<!--#include file="./models/models.asp" -->
<%
   Dim curRootFile : curRootFile = "/" & Application("root")
   Dim CurRoot : CurRoot = Application("root")
   
   Dim curADConn : Set curADConn = Session("curADConn")

   Dim Msg : Msg = ""
   Dim MsgTyp : MsgTyp = Request("msg")

   If IsPostBack Then

        Dim Login : Login = Request.Form("login")
        Dim Password : Password = Request.Form("password")

        Dim AD : Set AD = New ADAccess



        If AD.AuthenticateUser(Login,Password) Then
            If Session("IsGuest") = False  Then
                Response.Redirect(curRootFile)
            Else
                Response.Redirect(curRootFile & "/logout.asp?msg=credwrong")
            End If
        Else
            MsgTyp = "credwrong"
        End If
       
   End If

   If MsgTyp <> "" Then
      Select Case MsgTyp

        Case "noaccess"

            Msg = "Sie haben keinen Zugriff auf das System"

        Case "credwrong"

            Msg = "Username/Passwort falsch"

      End Select

   End If

%>

<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags always come first -->
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>DigiMPS MSD</title>

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
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/localization/messages_de.js" type="text/javascript"></script>

    <!-- Utils -->
    <script src="<%=CurRootFile%>/js/modules/myutil.1.0.js" type="text/javascript"></script>

    <!-- Moments -->
    <script src="<%=CurRootFile%>/js/modules/moment-with-locales.js" type="text/javascript"></script>

</head>
<body class="fixed-sn grey-skin">
    <!--Grid row-->
    <div class="col-12">
    <div class="row">
        <div class="col-md-6 col-sm-8 col-lg-3 offset-sm-3">
            <!--Grid column-->
            <div class="col-12 mb-4">
                <!-- Default form login -->
                <form class="text-center border border-light p-5" method="POST" action="login.asp">
                        <div class="float-left ml-1 mt-1 mb-4"><img src="<%=curRootFile%>/Images/digimps.png" alt="logo" title="MSD Austria" width="50" height="auto"></div>

                        <!-- Email -->
                        <input type="text" name="login" id="defaultLoginFormEmail" class="form-control mb-4" placeholder="ISID" required="required">

                        <!-- Password -->
                        <input type="password" name="password"  id="defaultLoginFormPassword" class="form-control mb-4" placeholder="Passwort" required="required">

                        <!-- Sign in button -->
                        <button class="btn btn-cyan btn-block my-4" type="submit">Login</button>
                        <% If Msg <> "" Then %>
                           <div class="text-danger">
                               <%=Msg%>
                           </div>
                        <% End If %>
                </form>
            </div>
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

