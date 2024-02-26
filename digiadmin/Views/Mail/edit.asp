<%
    Dim vwMail : Set vwMail = ViewData("mail")
    Dim vwItem : Set vwItem = ViewData("item")
    Dim vwHeader

    Select Case vwMail.Typ
    Case "quote"
        vwHeader = "Anfrage-Email " & vwItem.QuoteNb
    End Select


%>
<!--Section: Table OrderProp-->
<section class="mb-5">
    <!--Card-->
    <div class="card card-cascade narrower">
        <!--Card header-->
        <div class="view view-cascade py-3 gradient-card-header grey mx-4 d-flex justify-content-between align-items-center">
            <div>
                <a href="" class="white-text text-center mx-3"><i class="far fa-envelope"></i>&nbsp;<%=vwHeader%></a>
            </div>
        </div>
        <!--/Card header-->
        <!--Card content-->
        <div class="card-body col-12">
            <!-- E-Mail Form-->
            <form id="form" name="form" class="border border-light p-5">
                <input type="hidden" name="id" id="id" value="<%=vwItem.ID%>"/>

                <p class="h4 mb-4"><%=vwHeader%></p>

                <!-- Recipient-->
                <label>Empf‰nger</label>
                <!-- Email -->
                <input type="text" id="toname" name="toname" class="form-control mb-4" value="<%=vwMail.ToName%>" placeholder="Kontak">
                <input type="email" id="email" name="email" class="form-control mb-4" placeholder="E-Mail" value="<%=vwMail.Recipient%>">

                <label>Betreff</label>
                <input type="text" id="subject" name="subject" class="form-control mb-4" value="<%=vwMail.Subject%>" placeholder="Betreff">

                <!-- Message -->
                <label>Nachricht</label>
                <!-- Message -->
                <div class="form-group">
                    <textarea style="height: 300px" class="form-control rounded-0" id="body" name="body" rows="5" placeholder="Nachricht"><%=vwMail.Body%></textarea>
                </div>

                <!-- Copy -->
                <div class="custom-control custom-checkbox mb-4">
                    <input type="checkbox" class="custom-control-input" id="sendcopy" name="sendcopy" checked>
                    <label class="custom-control-label" for="sendcopy">eine Kopie an mich Senden</label>
                    <input type="hidden" id="ccemail" name="ccemail" value="<%=vwMail.CCRecipient%>">
                </div>
                <input type="submit" style="display:none;"/>

                <!-- Send button -->
                <button class="btn btn-info btn-block" id="send" type="button">Senden</button>
                <!-- Cancel button -->
                <button id="close" class="btn btn-danger btn-block mt-2" type="button" onclick="window.close();">Schlieﬂen</button>

            </form>
            <!--E-Mail Form -->
        </div>
        <!--/.Card content-->
    </div>
    <!--/.Card-->
</section>
<!--Section: Table OrderProp-->

<!-- javascript -->
<script src="<%=curRootFile%>/js/pages/mail/edit.js?v1.0"></script>