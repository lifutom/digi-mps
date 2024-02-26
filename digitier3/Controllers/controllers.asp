      <!--#include file="../Controllers/HomeController.asp" -->
      <!--#include file="../Controllers/Tier3Controller.asp" -->
      <%
      Public Controllers
      Set Controllers = Server.CreateObject("Scripting.Dictionary")
      Controllers.Add "homecontroller", ""
      Controllers.Add "tier3controller", ""
      %>