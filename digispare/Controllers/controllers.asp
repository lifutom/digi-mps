      <!--#include file="../Controllers/HomeController.asp" -->
      <!--#include file="../Controllers/SpareController.asp" -->
      <%
      Public Controllers
      Set Controllers = Server.CreateObject("Scripting.Dictionary")
      Controllers.Add "homecontroller", ""
      Controllers.Add "sparecontroller", "" 
      %>