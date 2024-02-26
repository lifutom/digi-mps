<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
%>
<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ItemType : ItemType = Request.Form("item")
    Dim ID : ID = Request.Form("id")
    Dim TID : TID = Request.Form("taskid")
    Dim Lang : Lang = IIf(Request.Form("lang") = "", Session("lang"), Request.Form("lang"))
    Dim tstID
    Dim Status : Status = "NOTOK"
    Dim ErrMsg : ErrMsg = ""
    Dim Item
    Dim ItemID

    Dim oJSON : Set oJSON = New aspJSON

    Select Case ItemType

        Case "failurelist"

            Set Item = New FailureItem
            Item.FailureID = ID
            Item.Failure = Decode(Request.Form("failure"))
            Item.Description = Decode(Request.Form("description"))
            Item.Active = Request.Form("active")
            ItemID = "Item.FailureID"


        Case "failureitem_toggle"

            Set Item = New FailureItem
            Item.FailureID = ID
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.FailureID"

        Case "group"

            Set Item = New Group
            Item.GroupID = ID
            Item.Group = Decode(Request.Form("group"))
            Item.Active = Request.Form("active")
            ItemID = "Item.GroupID"

        Case "group_toggle"

            Set Item = New Group
            Item.GroupID = ID
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.GroupID"

        Case "user"

            Set Item = New User
            Item.UserID = ID
            Item.GroupID = Request.Form("groupid[]")
            Item.DepartmentID = Request.Form("departmentid")
            Item.Active = Request.Form("active")
            ItemID = "Item.UserID"

        Case "user_toggle"

            Set Item = New User
            Item.UserID = ID
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.UserID"

        Case "tier1_people"

            Set Item = New People
            Item.PeopleID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.EmployeeCnt = Request.Form("employeecnt")
            Item.SickCnt = Request.Form("sickcnt")
            ItemID = "Item.PeopleID"

        Case "tier1_quality"

            Set Item = New Quality
            Item.QualityID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.StreamTypeID = Request.Form("streamtypeid")
            Item.ComplaintsCnt = Request.Form("complaintscnt")
            Item.LROTCnt = Request.Form("lrotcnt")
            ItemID = "Item.QualityID"

        Case "tier1_events"

            Set Item = New Events
            Item.EventID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.EventNb = Decode(Request.Form("eventnb"))
            Item.EventTxt = Decode(Request.Form("eventdescription"))
            Item.EvStart = Request.Form("eventstartdate")
            Item.EvClosed = Request.Form("eventclosed")
            ItemID = "Item.EventID"

         Case "tier1_capa"

            Set Item = New Capa
            Item.CapaID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.CapaNb = Decode(Request.Form("capanb"))
            Item.CapaTxt = Decode(Request.Form("capadescription"))
            Item.CapaStart = Request.Form("capastart")
            Item.CapaClosed = Request.Form("capaclosed")
            ItemID = "Item.CapaID"

        Case "tier1_cc"

            Set Item = New CC
            Item.CCID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.CCNb = Decode(Request.Form("ccnb"))
            Item.CCTxt = Decode(Request.Form("ccdescription"))
            Item.CCStart = Request.Form("ccstart")
            Item.CCClosed = Request.Form("ccclosed")
            ItemID = "Item.CCID"

        Case "tier1_other"

            Set Item = New OtherTier
            Item.OID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.OCatID = Request.Form("ocatid")
            Item.OTxt = Decode(Request.Form("odescription"))
            Item.OStart = Request.Form("ostart")
            Item.OClosed = Request.Form("oclosed")
            ItemID = "Item.OID"

        

        Case "tier1_othernote"

            Set Item = New OtherTierNote
            Item.OnID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.OnTxt = Decode(Request.Form("ondescription"))
            Item.OnStart = Request.Form("onstart")
            Item.OnClosed = Request.Form("onclosed")
            ItemID = "Item.OnID"

        Case "tier1_complaint"

            Set Item = New Complaint
            Item.CID = ID
            Item.DateID = Request.Form("dateid")
            Item.CNb = Decode(Request.Form("cnb"))
            Item.CNumber = Decode(Request.Form("cnumber"))
            Item.CProduct = Decode(Request.Form("cproduct"))
            Item.CTxt = Decode(Request.Form("cdescription"))
            Item.CCountry = Decode(Request.Form("ccountry"))
            Item.CReason= Decode(Request.Form("creason"))
            ItemID = "Item.CID"

        Case "tier1_delivery_esca"

            Set Item = New DeliveryEsca
            Item.EscaID = ID
            Item.DateID = Request.Form("dateid")
            Item.EscaTxt = Decode(Request.Form("escadescription"))
            Item.EscaTask = Decode(Request.Form("escatask"))
            Item.EscaStart = Request.Form("escastart")
            Item.EscaClosed = Request.Form("escaclosed")
            ItemID = "Item.EscaID"

        Case "tier1_quality_esca"

            Set Item = New QualityEsca
            Item.EscaID = ID
            Item.DateID = Request.Form("dateid")
            Item.EscaTxt = Decode(Request.Form("escadescription"))
            Item.EscaTask = Decode(Request.Form("escatask"))
            Item.EscaStart = Request.Form("escastart")
            Item.EscaClosed = Request.Form("escaclosed")
            ItemID = "Item.EscaID"

        Case "tier_safetyissue"

            Set Item = New SafetyIssue
            Item.ID = ID
            Item.DateID = Request.Form("dateid")
            Item.Description = Decode(Request.Form("description"))
            Item.TierLevel = Decode(Request.Form("tierlevel"))
            Item.Start = Request.Form("start")
            Item.Closed = Request.Form("closed")
            ItemID = "Item.ID"

        Case "tier3_safetyissue"

            Set Item = New SafetyIssue
            Item.ID = ID
            Item.DateID = Request.Form("dateid")
            Item.Description = Decode(Request.Form("description"))
            Item.TierLevel = Decode(Request.Form("tierlevel"))
            Item.Start = Request.Form("start")
            Item.Closed3 = Request.Form("closed3")
            Item.LongDescription = Decode(Request.Form("longdescription"))
            ItemID = "Item.ID"

        Case "tier1_safety"

            Set Item = New Safety
            Item.SafetyID = ID
            Item.DateID = Request.Form("dateid")
            Item.DepartmentID = Request.Form("departmentid")
            Item.AccidentCnt = Request.Form("accidentcnt")
            Item.NearAccidentCnt = Request.Form("nearaccidentcnt")
            Item.IncidentCnt = Request.Form("incidentcnt")
            ItemID = "Item.SafetyID"

        Case "tier1_delivery_bulk"

            Set Item = New DeliveryBulk
            Item.DeliveryBulkID = ID
            Item.DateID = Request.Form("dateid")
            Item.DateYear = Request.Form("dateyear")
            Item.DateKW = Request.Form("datekw")
            Item.PlantID = Request.Form("plantid")
            Item.PlannedCnt = Request.Form("plannedcnt")
            Item.ProducedCnt = Request.Form("producedcnt")
            ItemID = "Item.DeliveryBulkID"

        Case "tier1_delivery_pack"

            Set Item = New DeliveryPack
            Item.DeliveryPackID = ID
            Item.DateID = Request.Form("dateid")
            Item.PlantID = Request.Form("plantid")
            Item.OEEValue = CDbl(Request.Form("oeevalue"))
            
            Item.OutputCnt = Request.Form("outputcnt")
            ItemID = "Item.DeliveryPackID"

        Case "site_toggle"

            Set Item = New Site
            Item(ID)
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.SiteID"

        Case "site"

            Set Item = New Site
            Item.SiteID = ID
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            ItemID = "Item.SiteID"

        Case "warehouse"

            Set Item = New Warehouse
            Item.WarehouseID = ID
            Item.SiteID = Request.Form("siteid")
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            ItemID = "Item.WarehouseID"

        Case "warehouse_toggle"

            Set Item = New Warehouse
            Item(ID)
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.WarehouseID"

        Case "supplier_toggle"

            Set Item = New Supplier
            Item(ID)
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.SupplierID"

        Case "supplier"

            Set Item = New Supplier
            Item.SupplierID = Request.Form("id")
            Item.Name = Decode(Request.Form("name"))
            Item.Country = Decode(Request.Form("country"))
            Item.Zip = Decode(Request.Form("zip"))
            Item.City = Decode(Request.Form("city"))
            Item.Street = Decode(Request.Form("street"))
            Item.Phone = Decode(Request.Form("phone"))
            Item.Mobile = Decode(Request.Form("mobile"))
            Item.MainContact = Decode(Request.Form("maincontact"))
            Item.Email = Decode(Request.Form("email"))
            Item.Active = Request.Form("active")
            ItemID = "Item.SupplierID"

        Case "module_toggle"

            Set Item = New Module
            Item(ID)
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.ModuleID"

        Case "module_toggle_isinstand"

            Set Item = New Module
            Item(ID)
            Item.IsInStand = IIf(Item.IsInStand = 0, 1, 0)
            ItemID = "Item.ModuleID"

        Case "module"

            Set Item = New Module
            Item.ModuleID = ID
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            Item.IsInStand = Request.Form("isinstand")

            ItemID = "Item.ModuleID"

        Case "categorie_toggle"

            Set Item = New Categorie
            Item(ID)
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.ModuleID"

        Case "categorie"

            Set Item = New Categorie
            Item.ModuleID = ID
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            ItemID = "Item.ModuleID"


        Case "spare_toggle"

            Set Item = New Spare
            Item(ID)
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.ID"

        Case "spare"

            Set Item = New Spare
            Item.ID = Request.Form("id")
            Item.SparepartNbOrg = Request.Form("sparepartnborg")
            Item.SparepartNb = Decode(Request.Form("nb"))
            Item.Sparepart = Decode(Request.Form("name"))
            Item.SpareNb = Decode(Request.Form("snb"))
            Item.MinLevel = Request.Form("minlevel")
            Item.ActLevel = Request.Form("actlevel")
            Item.MinOrderLevel = Request.Form("minorderlevel")
            Item.defsupplierid = Request.Form("defsupplierid")
            Item.Active = Request.Form("active")
            ItemID = "Item.ID"

        Case "spare_store"

            Set Item = New Location
            Item.LocationID = Request.Form("locationid")
            ItemID = "Item.LocationID"

        Case "spare_location"

            Set Item = New Location

            If Not Item.LocationExists(Request.Form("warehouseid"),Request.Form("shelfid"),Request.Form("compid"),Request.Form("boxid")) Then
                ''Item.NoInit = False
                Item.LocationID = Request.Form("id")
                Item.WarehouseID = Request.Form("warehouseid")
                Item.ShelfID = Request.Form("shelfid")
                Item.CompID = Request.Form("compid")
                Item.BoxID = Request.Form("boxid")
            End If
            Item.SparepartID = Request.Form("sparepartid")
            Item.Act = Request.Form("act")
            ItemID = "Item.LocationID"

        Case "movespare"

            Set Item = New Location
            ItemID = "Item.LocationID"

        Case "spare_supplier"

            Set Item = New SparepartSupplier
            Item.SupplierID = Request.Form("id")
            Item.SparepartID = Request.Form("sparepartid")
            Item.SpareNb = Decode(Request.Form("sparenb"))
            Item.IsDefault = Request.Form("isdefault")
            Item.Active = Request.Form("active")
            Item.Price = Request.Form("price")
            ItemID = "Item.SupplierID"

        Case "orderspare"

            Set Item = New OrderPropItem
            Item.SparepartID = Request.Form("id")
            Item.SupplierID = Request.Form("supplierid")
            Item.OrderQty = Request.Form("act")
            ItemID = "Item.OrderID"


        Case "ordereditspare"

            Set Item = New OrderPropItem
            Item.OrderID = ID
            Item.SparepartID = Request.Form("sparepartid")
            Item.SupplierID = Request.Form("supplierid")
            Item.OrderQty = Request.Form("act")
            ItemID = "Item.OrderID"


        Case "spare_link"

            Set Item = New SparepartLink
            Item.LinkID = Request.Form("id")
            Item.SparepartID = Request.Form("sparepartid")
            ItemID = "Item.LinkID"

        Case "tier3_events"

            Set Item = New EventsRaised
            Item.EventID = ID
            Item.DateID = Request.Form("dateid")
            Item.RaisedCnt = Request.Form("raisedcnt")
            ItemID = "Item.EventID"

        Case "cartitem"

            Set Item = New ShoppingItem
            Item.ShoppingID = Request.Form("shoppingid")
            Item.LocationID = Request.Form("locationid")
            Item.SparepartID = ID
            Item.Act = Request.Form("act")
            Item.CreatedBy = Request.Form("userid")
            Item.Created = Date
            Item.UserID = Request.Form("userid")
            ItemID = "Item.ShoppingID"


        Case "cartbook"

            Set Item = New CartBooking
            Item.ShoppingID = ID
            Item.UserID = Request.Form("userid")
            ItemID = "Item.ShoppingID"

        Case "room_toggle"

            Set Item = New RoomItem
            Item.ID = ID
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.RoomID"

        Case "room"

            Set Item = New RoomItem
            Item.ID = ID
            Item.Nb = Decode(Request.Form("nb"))
            Item.Name = Decode(Request.Form("name"))
            Item.RegionID = Request.Form("regionid")
            Item.BuildingID = Request.Form("buildingid")
            Item.Active = Request.Form("active")
            ItemID = "Item.RoomID"

        Case "region_toggle"

            Set Item = New RegionItem
            Item.ID = ID
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.RegionID"

        Case "region"

            Set Item = New RegionItem
            Item.ID = ID
            Item.Nb = Decode(Request.Form("nb"))
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            ItemID = "Item.RegionID"

        Case "regionsvp"

            Set Item = New RegionItem
            Item.ID = ID
            ItemID = "Item.RegionID"


        Case "building_toggle"

            Set Item = New BuildingItem
            Item.ID = ID
            Item.Active = IIf(Item.Active = 0, 1, 0)
            ItemID = "Item.BuildingID"

        Case "building"

            Set Item = New BuildingItem
            Item.ID = ID
            Item.Nb = Decode(Request.Form("nb"))
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            ItemID = "Item.BuildingID"

        Case "quote_edit"

            Set Item = New Quote
            Item.ID = ID
            
            Item.Nb = Decode(Request.Form("nb"))
            Item.Name = Decode(Request.Form("name"))
            Item.Active = Request.Form("active")
            ItemID = "Item.BuildingID"

        Case "box"

            Set Item = New Box
            Item.BoxID = ID
            Item.Name = Request.Form("name")
            ItemID = "Item.BoxID"

        Case "boxmove"

            Set Item = New Box
            Item.ID = ID
            Item.WarehouseID = Request.Form("warehouseid")
            Item.ShelfID = Request.Form("shelfid")
            Item.CompID = Request.Form("compid")
            ItemID = "Item.BoxID"

        Case "module_link"

            Set Item = New ModulePlant
            Item.ModuleID = ID
            Item.PlantID = Request.Form("plantid")
            Item.DeviceID = Request.Form("deviceid")
            ItemID = "Item.LinkID"

        Case "request"

            Set Item = New RequestItem

            Item.InitByPostData(Request)
            Item.Description = Decode(Item.Description)
            ItemID = "Item.ID"

        Case "request-approve"
            Set Item = New RequestDetail
            Item.TID = TID
            Item.Comment = Request.Form("comment")
            Item.ElogNb = Request.Form("elognb")
            ItemID = "Item.TID"

        Case "request-reject"
            Set Item = New RequestDetail
            Item.TID = TID
            Item.Comment = Request.Form("comment")
            ItemID = "Item.TID"

        Case "workitem-done"

            Set Item = New RequestDetail
            Item.TID = TID
            Item.Comment = Request.Form("comment")
            Item.AccessItemID = Request.Form("accessitemid")
            Item.AccessRightID = Request.Form("accessrightid")
            ItemID = "Item.TID"
          
        Case "workitem-notdone"

            Set Item = New RequestDetail
            Item.TID = TID
            Item.Comment = Request.Form("comment")
            ItemID = "Item.TID"

        Case "aduser"
            Set Item = New ADUser
            Item.ID = ID
            Item.DepartmentID = Request.Form("departmentid")
            Item.Department = ReturnFromRecord("department","departmentid=" & Item.DepartmentID,"department")
            Item.RoomID = Request.Form("roomid")
            Item.Room = ReturnFromRecord("room","roomid=" & Item.RoomID,"nb")
            ItemID = "Item.ID"

        Case "accessitem"
            Set Item = New AccessItem
            Item.ID = ID
            Item.Name = Request.Form("name")
            Item.Active = Request.Form("active")
            Item.AccessTypeID = Request.Form("accesstypeid")
            Item.IsGMP = Request.Form("isgmp")
            Item.SystemOwner = Request.Form("sysowner") 
            ItemID = "Item.ID"

        Case "accessitem-manual"

            Set Item = New ADUserAccessItem
            Item.ISID = ID
            Item.AccessItemID = Request.Form("accessitemid")
            Item.AccessRightID = Request.Form("accessrightid")
            Item.Manual = Request.Form("manual")
            Item.CreatedBy = Session("login")
            Item.Created = Now

        Case "accessright"
            Set Item = New AccessItemRight
            Item.ID = ID
            Item.AccessItemID  = Request.Form("accessitemid")
            Item.AccessRight = Request.Form("accessright")
            Item.WorkFlowID = Request.Form("workflowid")
            ItemID = "Item.ID"

        Case "accessright-task"

            Set Item = New AccessItemRightTask

            Item ID, Request.Form("pos")
            Item.SendTo = Request.Form("sendto")
            ItemID = "Item.AccessRightID"

        Case "user-delegate-add"

            Set Item = New Delegate
            Item ID, Request.Form("delegate")
            ItemID = "Item.ISID"

        Case "user-delegate-del"

            Set Item = New Delegate
            Item ID, Request.Form("delegate")
            ItemID = "Item.ISID"

        Case "user-profile"

            Set Item = New ADUser
            Item.ID = ID
            ItemID = "Item.ISID"

        Case "queue_toggle"

            Set Item = New WorkFlowGroupHeadItem
            Item.ID = ID
            Item.IsStorno = IIf(Item.IsStorno = 0, 1, 0)
            ItemID = "Item.GroupID"


        Case "stillstand-item"

            Set Item = New StandItem
            Item.ID = ID
            ItemID = "Item.ID"

    End Select

    Select Case  ItemType

        Case "regionsvp"
            If Item.SVPAdd(Request.Form("userid")) Then
                Status = "OK"
                ID = eval(ItemID)
            Else
                ID = eval(ItemID)
                ErrMsg = "Konnte nicht gesichert werden"
            End If

        Case "movespare"


            ID = Item.Move(Request.Form("id"), Request.Form("newid"),Request.Form("act"),Request.Form("sparepartid"),Request.Form("boxid"),Request.Form("warehouseid"),Request.Form("shelfid"),Request.Form("compid"))
            If CLng(ID) > 0 Then
                Status = "OK"
            Else
                ErrMsg = "Artikel Konnte nicht umgelagert werden"
            End If

        Case "boxmove"

            IF Item.Move Then
                Status = "OK"
            Else
                ErrMsg = "Box konnte nicht umgelagert werden"
            End If

        Case "spare_store"

            ID = eval(ItemID)
            If Item.StoreSpare(Request.Form("id"), Request.Form("act")) Then
                Status = "OK"
                ErrMsg = "Ersatzteil(e) wurden eingelagert"
            Else
                ErrMsg = "Ersatzteil konnte nicht eingelagert werden"
            End If

        Case "request"
            If Item.Save Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgRequestCreatedSuccess",Session("lang")))
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgRequestCreatedError", Session("lang")))
            End If
        Case "request-approve"
            If Item.Approve Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgRequestApprovedSuccess",Session("lang")))
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgRequestApprovedError", Session("lang")))
            End If

        Case "request-reject"
            If Item.Reject Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgRequestRejectSuccess",Session("lang")))
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgRequestRejectError", Session("lang")))
            End If
        Case "workitem-done"
            If Item.Done Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgWorkItemDoneSuccess",Session("lang")))
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgWorkItemDoneError", Session("lang")))
            End If

        Case "workitem-notdone"
            If Item.NotDone Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgWorkItemNotDoneSuccess",Session("lang")))
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(GetLabel("msgWorkItemNotDoneError", Session("lang")))
            End If
        Case "accessitem"
            Item.Save
            If Item.ErrNb = 0 Then
               Status = "OK"
            End If
            ErrMsg = Item.ErrMsg

        Case "accessitem-manual"

            Item.Save
            If Item.ErrNb = 0 Then
                Status = "OK"
            End If
            ErrMsg = ToUTF8(Item.ErrMsg)

        Case "accessright-task"
            Item.Save
            If Item.ErrNb = 0 Then
                Status = "OK"
            End If
            ErrMsg = Item.ErrMsg

        Case "user-delegate-add"

            If Item.Save Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(Item.ErrMsg)
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(Item.ErrMsg)
            End If

        Case "user-delegate-del"

            If Item.Delete Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(Item.ErrMsg)
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(Item.ErrMsg)
            End If

        Case "user-profile"

            Item.RoomID = Request.Form("roomid")

            If Item.Save Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = ToUTF8(Item.ErrMsg)
            Else
                ID = eval(ItemID)
                ErrMsg = ToUTF8(Item.ErrMsg)
            End If

        Case "stillstand-item"

            Item.PlantID = Request.Form("plantid")
            Item.DeviceID = Request.Form("deviceid")
            Item.ModuleID = Request.Form("moduleid")
            Item.CategoryID = Request.Form("categoryid")
            Item.Description = Request.Form("description")
            Item.StartDate = Request.Form("startdate")
            Item.DurationMin = Request.Form("durationmin")
            Item.DurationHour = Request.Form("durationhour")   
            Item.LastEditBy = Request.Form("lasteditby")
            Item.LastEdit = Now

            If Item.Save Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = Item.ErrMsg
            Else
                ID = eval(ItemID)
                ErrMsg = Item.ErrMsg
            End If

        Case Else

            If Item.Save Then
               Status = "OK"
               ID = eval(ItemID)
               ErrMsg = ToUTF8(GetLabel("msgDataSaveSuccess",Session("lang")))
            Else
               ID = eval(ItemID)
               ErrMsg = ToUTF8(GetLabel("msgDataSaveError",Session("lang")))
            End If

    End Select


    If ItemType =  "stillstand-item" Then

        Set oJSON = Item.Serialize

    Else

        With oJSON.Data
                Select Case ItemType
                    Case "spare_location"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(ID)
                    Case "spare_toggle"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(ID)
                    Case "spare"
                        .Add "status", Item.ErrStatus
                        .Add "errmsg", Item.ErrMsg
                        .Add "errnumber", Item.ErrNumber
                        .Add "id", CLng(ID)
                    Case "cartitem"
                        .Add "status", Item.ErrStatus
                        .Add "errmsg", Item.ErrMsg
                        .Add "errnumber", Item.ErrNumber
                        .Add "id", CLng(ID)
                    Case "cartbook"
                        .Add "status", Item.ErrStatus
                        .Add "errmsg", Item.ErrMsg
                        .Add "errnumber", Item.ErrNumber
                        .Add "id", CLng(ID)
                    Case "spare_link"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(ID)
                    Case "movespare"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(ID)
                    Case "orderspare"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(ID)
                    Case "ordereditspare"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(ID)
                    Case "module_link"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "id", CLng(Item.LinkID)
                        .Add ItemType,oJSON.Collection()
                        With .Item(ItemType)
                            .Add "linkid", CLng(Item.LinkID)
                            .Add "moduleid", Item.ModuleID
                            .Add "plantid", Item.PlantID
                            .Add "deviceid", Item.DeviceID
                            .Add "module", ToUTF8(Item.Module)
                            .Add "plant", ToUTF8(Item.Plant)
                            .Add "device", ToUTF8(Item.Device)
                        End With
                    Case "aduser"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "lang" , Session("lang")
                        .Add "id", ID
                        .Add "departmentid", Item.DepartmentID
                        .Add "department", ToUTF8(Item.Department)
                        .Add "roomid", Item.RoomID
                        .Add "room", ToUTF8(Item.Room)
                    Case "accessright"
                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "lang" , Session("lang")
                        .Add "id", CLng(ID)
                        .Add "accessrightid", CLng(Item.ID)
                        .Add "accessright", ToUTF8(Item.AccessRight)
                        .Add "accessitemid", CLng(Item.AccessItemID)
                        .Add "accessitem", ToUTF8(Item.AccessItem)
                        .Add "workflowid", CLng(Item.WorkFlowID)
                        .Add "workflow", ToUTF8(Item.Workflow)

                    Case "user-delegate-add"

                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "item",ItemType
                        .Add "id", ID
                        .Add "isid", Item.DelegateISID
                        .Add "lastname", ToUTF8(Item.LastName)
                        .Add "firstname", ToUTF8(Item.FirstName)

                    Case "user-delegate-del"

                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "item",ItemType
                        .Add "id", ID
                        .Add "isid", Item.DelegateISID
                        .Add "lastname", ToUTF8(Item.LastName)
                        .Add "firstname", ToUTF8(Item.FirstName)

                    Case "user-profile"

                        .Add "status", Status
                        .Add "errmsg", ErrMsg
                        .Add "item",ItemType
                        .Add "id", ID

                    Case Else

                       .Add "status", Status
                       .Add "errmsg", ErrMsg
                       .Add "lang" , Session("lang")
                       .Add "id", ConvertValType(ID)

                End Select
        End With
    End If
    Response.Write oJSON.JSONoutput()
    Response.End

%>