Set IQCashHandler = Server.CreateObject("MSXML2.ServerXMLHTTP")


IQCashHandler.Open "POST", "people.asp"
IQCashHandler.setRequestHeader "Accept", "application/x-www-form-urlencoded"
IQCashHandler.Send Data

Response.Write IQCashHandler.ResponseText


<form name="form" id="form" action="people_old.asp" method="POST">

    <input type="text" name="fu" id="fu" value="list"><br>
    <input type="submit" value="Senden">

</form>
