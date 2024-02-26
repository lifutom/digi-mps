<!DOCTYPE html>
<html lang="en">
<head>
    <!-- Required meta tags always come first -->
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta http-equiv="x-ua-compatible" content="ie=edge">
    <title>DigiMPS MSD</title>

    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <!-- Bootstrap core CSS -->
    <link href="<%=CurRootFile%>/css/bootstrap.min.css" rel="stylesheet">

    <!-- Material Design Bootstrap -->
    <link href="<%=CurRootFile%>/css/mdb.css" rel="stylesheet">

    <!-- Material Design Bootstrap -->
    <link href="<%=CurRootFile%>/css/style.css" rel="stylesheet">

    <!-- JQuery -->
    <script type="text/javascript" src="<%=CurRootFile%>/js/jquery-3.3.1.min.js"></script>

    <!-- jQueryValidation -->
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/jquery.validate.min.js"></script>
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/additional-methods.min.js" type="text/javascript"></script>
    <script src="<%=CurRootFile%>/js/modules/jquery-validation/localization/messages_<%=Session("lang")%>.js" type="text/javascript"></script>

    <!-- DataTables Select CSS -->
    <link href="<%=CurRootFile%>/css/addons/datatables.min.css" rel="stylesheet">
    <link href="<%=CurRootFile%>/css/addons/datatables-select.min.css" rel="stylesheet">
    <link href="<%=CurRootFile%>/css/addons/directives.min.css" rel="stylesheet">

    <!-- DataTables Select CSS -->
    <script src="<%=CurRootFile%>/js/addons/datatables.min.js" type="text/javascript"></script>
    <script src="<%=CurRootFile%>/js/addons/datatables-select.min.js" type="text/javascript"></script>
    <script src="<%=CurRootFile%>/js/addons/mdb-editor.min.js" type="text/javascript"></script>

    <!-- Utils -->
    <script src="<%=CurRootFile%>/js/modules/myutil.1.0.js" type="text/javascript"></script>

    <!-- Moments -->
    <script src="<%=CurRootFile%>/js/modules/moment-with-locales.js" type="text/javascript"></script>

</head>

<body class="fixed-sn grey-skin">

    <!-- asp vaiables for javascript -->
    <input id="CurRootFile" name="CurRootFile" type="hidden" value="<%=CurRootFile%>">
    <input id="SysAdm" name="SysAdm" type="hidden" value="<%=SysAdm%>">
    <!-- asp vaiables for javascript -->

    <!-- Central Modal Medium Danger -->
    <div class="modal fade" id="warning" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-notify modal-danger" role="document">
            <!--Content-->
            <div class="modal-content">
                <!--Header-->
                <div class="modal-header">
                    <p class="heading lead">Warnung</p>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="white-text">&times;</span>
                    </button>
                </div>

                <!--Body-->
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-check fa-4x mb-3 animated rotateIn"></i>
                        <p><span class="warningmsg"></span></p>
                    </div>
                </div>

                <!--Footer-->
                <div class="modal-footer justify-content-center">
                    <a type="button" id="warningbtn" class="btn btn-outline-danger waves-effect" data-dismiss="modal">Weiter</a>
                </div>
            </div>
            <!--/.Content-->
        </div>
    </div>
    <!-- Central Modal Medium Danger-->
    <!-- Central Modal Medium Success -->
    <div class="modal fade" id="success" tabindex="-1" role="dialog" aria-labelledby="mySuccessModalLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-notify modal-success" role="document">
            <!--Content-->
            <div class="modal-content">
                <!--Header-->
                <div class="modal-header">
                    <p class="heading lead">Warnung</p>

                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="white-text">&times;</span>
                    </button>
                </div>

                <!--Body-->
                <div class="modal-body">
                    <div class="text-center">
                        <i class="fas fa-check fa-4x mb-3 animated rotateIn"></i>
                        <p><span class="successmsg"></span></p>
                    </div>
                </div>

                <!--Footer-->
                <div class="modal-footer justify-content-center">
                    <a type="button" id="successbtn" class="btn btn-outline-success waves-effect" data-dismiss="modal">Weiter</a>
                </div>
            </div>
            <!--/.Content-->
        </div>
    </div>
    <!-- Central Modal Medium Success -->
    <!--Main Navigation-->
    <header>



        <!-- Sidebar navigation -->
        <div id="slide-out" class="side-nav fixed sn-bg-4">
            <ul class="custom-scrollbar">
                <!-- Logo -->
                <li class="logo-sn waves-effect">
                    <div class=" text-center">
                        <a href="<%=curRootFile%>" class="pl-0">
                            <img src="<%=curRootFile%>/Images/msd.png" width="70" height="70"class="">
                        </a>
                    </div>
                </li>
                <!--/. Logo -->
                <!--Search Form-->
                <!--<li>
                    <form class="search-form" role="search">
                        <div class="form-group md-form mt-0 pt-1 waves-light">
                            <input type="text" class="form-control" placeholder="Search">
                        </div>
                    </form>
                </li>-->
                <!--/.Search Form-->
                <!-- Side navigation links -->
                <li>
                    <ul class="collapsible collapsible-accordion">
                        <li><a class="collapsible-header waves-effect arrow-r"><i class="fas fa-home"></i>
                                Stammdaten<i class="fas fa-angle-down rotate-icon"></i></a>
                            <div class="collapsible-body">
                                <ul>
                                    <li><a href="<%=curRootFile%>/plant/index" class="waves-effect">Anlagen</a>
                                    </li>
                                    <li><a href="<%=curRootFile%>/failure/index" class="waves-effect">Fehlerliste</a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li><a class="collapsible-header waves-effect arrow-r"><i class="fab fa-algolia"></i>
                                &Uuml;bersicht<i class="fas fa-angle-down rotate-icon"></i></a>
                            <div class="collapsible-body">
                                <ul>
                                    <li><a href="<%=curRootFile%>/overview/production" class="waves-effect">Produktionen</a>
                                    </li>
                                    <li><a href="<%=curRootFile%>/overview/downtime" class="waves-effect">Downtimes</a>
                                    </li>
                                    <li><a href="#" class="waves-effect">Reports</a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                        <li><a class="collapsible-header waves-effect arrow-r"><i class="fas fa-users"></i> Userverwaltung<i class="fas fa-angle-down rotate-icon"></i></a>
                            <div class="collapsible-body">
                                <ul>
                                    <li><a href="<%=curRootFile%>/groups/index" class="waves-effect">Gruppen</a>
                                    </li>
                                    <li><a href="<%=curRootFile%>/user/index" class="waves-effect">User (AD)</a>
                                    </li>
                                </ul>
                            </div>
                        </li>
                    </ul>
                </li>
                <!--/. Side navigation links -->
            </ul>
            <div class="sidenav-bg rgba-blue-strong"></div>
        </div>
        <!--/. Sidebar navigation -->
        <!--Navbar-->
        <nav class="navbar navbar-expand-lg navbar-dark fixed-top scrolling-navbar double-nav">

            <!-- SideNav slide-out button -->
            <div class="float-left">
                <a href="#" data-activates="slide-out" class="button-collapse">
                    <i class="fas fa-bars"></i>
                </a>
            </div>

            <!-- Breadcrumb-->
            <div class="breadcrumb-dn mr-auto white-text">
                <p><img src="<%=curRootFile%>/Images/msd.png" alt="logo" title="MSD Austria" width="30" height="30">&nbsp;DigiMPS MSD Wien</p>
            </div>

            <!-- Links -->
            <ul class="nav navbar-nav nav-flex-icons ml-auto">
                <li class="nav-item dropdown">
                    <a class="nav-link dropdown-toggle" href="#" id="navbarDropdownMenuLink" data-toggle="dropdown"
                        aria-haspopup="true" aria-expanded="false">
                        <i class="fas fa-user"></i>
                        <span class="clearfix d-none d-sm-inline-block">Account</span>
                    </a>
                    <div class="dropdown-menu dropdown-menu-right" aria-labelledby="navbarDropdownMenuLink">
                        <a class="dropdown-item" href="<%=curRootFile%>/logout.asp">Logout</a>
                    </div>
                </li>
            </ul>
        </nav>
        <!--/.Navbar-->

    </header>
    <!--Main Navigation-->

    <!--Main layout-->
    <main>
        <div class="container-fluid">
             <%ContentPlaceHolder()%>
        </div>
    </main>
    <!--Main layout-->

     <!--Footer-->
    <footer class="page-footer text-center text-md-left stylish-color-dark pt-0 pl-0">
        <div>
            <div class="container">
                <!--Grid row-->
                <div class="row py-4 d-flex align-items-center">

                    <!--Grid column-->
                    <div class="col-md-6 col-lg-5 text-center text-md-left mb-4 mb-md-0">
                        <h6 class="mb-0 white-text">DigiMPS&nbsp;&copy;2019&nbsp;MSD-Wien</h6>
                    </div>
                    <!--Grid column-->
                </div>
                <!--Grid row-->
            </div>
        </div>
    </footer>
    <!-- Footer -->

</body>


<!-- SCRIPTS -->
<!-- Tooltips -->
<script type="text/javascript" src="<%=curRootFile%>/js/popper.min.js"></script>

<!-- Bootstrap core JavaScript -->
<script type="text/javascript" src="<%=curRootFile%>/js/bootstrap.min.js"></script>

<!-- MDB core JavaScript -->
<script type="text/javascript" src="<%=curRootFile%>/js/mdb.min.js"></script>

</html>
