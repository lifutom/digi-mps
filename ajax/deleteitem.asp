<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ItemType : ItemType = Request.Form("item")
    Dim ID : ID = Request.Form("id")
    Dim Status : Status = "NOTOK"
    Dim ErrMsg : ErrMsg = ""
    Dim Item
    Dim ItemID

    Dim oJSON : Set oJSON = New aspJSON

    Select Case ItemType

        Case "tier1_people"

            Set Item = New People
            Item.PeopleID = ID
            ItemID = "Item.PeopleID"

        Case "tier1_quality"

            Set Item = New Quality
            Item.QualityID = ID
            ItemID = "Item.QualityID"

        Case "tier1_events"

            Set Item = New Events
            Item.EventID = ID
            ItemID = "Item.EventID"

        Case "tier1_capa"

            Set Item = New Capa
            Item.CapaID = ID
            ItemID = "Item.CapaID"

        Case "tier1_cc"

            Set Item = New CC
            Item.CCID = ID
            ItemID = "Item.CCID"

        Case "tier1_complaint"

            Set Item = New Complaint
            Item.CID = ID
            ItemID = "Item.CID"

        Case "tier1_delivery_esca"

            Set Item = New DeliveryEsca
            Item.EscaID = ID
            ItemID = "Item.EscaID"

        Case "tier1_quality_esca"

            Set Item = New QualityEsca
            Item.EscaID = ID
            ItemID = "Item.EscaID"

        Case "tier1_other"

            Set Item = New OtherTier
            Item.OID = ID
            ItemID = "Item.OID"

        Case "tier1_othernote"

            Set Item = New OtherTierNote
            Item.OnID = ID
            ItemID = "Item.OnID"

        Case "tier1_safety"

            Set Item = New Safety
            Item.SafetyID = ID
            ItemID = "Item.SafetyID"

        Case "tier_safetyissue"

            Set Item = New SafetyIssue
            Item.ID = ID
            ItemID = "Item.ID"

        Case "tier1_delivery_bulk"

            Set Item = New DeliveryBulk
            Item.DeliveryBulkID = ID
            ItemID = "Item.DeliveryBulkID"


        Case "tier1_delivery_pack"

            Set Item = New DeliveryPack
            Item.DeliveryPackID = ID
            ItemID = "Item.DeliveryPackID"


        Case "spare_location"

            Set Item = New Location
            Item.LocationID = ID
            Item.SparepartID = Request.Form("sparepartid")
            ItemID = "Item.LocationID"

        Case "spare_supplier"

            Set Item = New SparepartSupplier
            Item.SupplierID = ID
            Item.SparepartID = Request.Form("sparepartid")
            ItemID = "Item.SupplierID"

        Case "spare_link"

            Set Item = New SparepartLink
            Item.SparepartID = Request.Form("sparepartid") 
            Item.LinkID = ID
            ItemID = "Item.LinkID"

        Case "cart"

            Set Item = New ShoppingCart
            Item.ShoppingID = ID
            ItemID = "Item.ShoppingID"

        Case "cartitem"

            Set Item = New ShoppingItem
            Item.ShoppingID = ID
            Item.LocationID = Request.Form("locationid")
            Item.SparepartID = Request.Form("sparepartid")
            ItemID = "Item.ShoppingID"

        Case "near"

            Set Item = New NearMiss
            Item.NearID = ID
            ItemID = "Item.NearID"

        Case "task"

            Set Item = New NearMissTask
            Item.TaskID = ID
            ItemID = "Item.TaskID"

        Case "delimg_nm"

            Set Item = New NearMiss

            Item.InitByCartID(ID)

        Case "regionsvp"

            Set Item = New RegionItem
            Item.RegionID = ID
            ItemID = "Item.RegionID"

        Case "delimg_spare"

            Set Item = New Spare
            Item.Init(ID)

        Case "downtime"

            Set Item = New MyDownTime
            Item.DownTimeID = ID
            ItemID = "Item.DownTimeID"

        Case "near-file"

            Set Item = New NearMiss
            Item.NearID = ID
            ItemID = "Item.NearID"

        Case "near-image"

            Set Item = New NearMiss
            Item.NearID = ID
            ItemID = "Item.NearID"

        Case "orderprop"

            Set Item = New OrderPropItem
            Item.ID = ID
            ItemID = "Item.OrderID"

        Case "module_link"

            Set Item = New ModulePlant
            Item.ID = ID
            ItemID = "Item.LinkID"

        Case "accessitem-manual"

            Set Item = New ADUserAccessItem
            Item.Init ID, Request.Form("accessitemid"), Request.Form("accessrightid")

        Case "stand-item"

            Set Item = New StandItem
            Item.ID = ID
            ItemID = "Item.StandID"

    End Select
    Select Case ItemType
        Case "delimg_nm"
            Item.RemoveCacheImage(Request.Form("filetyp"))
            Status = "OK"

        Case "delimg_spare"
            If Item.PhysicalImagePath <> "" Then
                Item.RemovePath(Item.PhysicalImagePath)
            End If
            Status = "OK"

        Case "regionsvp"
            If Item.SVPDelete(Request.Form("userid"))  Then
                Status = "OK"
                ID = eval(ItemID)
            Else
                ErrMsg = "Konnte nicht gel&ouml;scht werden"
            End If

        Case "downtime"
            If Item.DBDelete  Then
                Status = "OK"
                ID = eval(ItemID)
            Else
                ErrMsg = "Konnte nicht gel&ouml;scht werden"
            End If

        Case "near-file"

            Item.DeleteUpload Request.Form("name"), Request.Form("typ")
            Status = "OK"
            ID = eval(ItemID)

        Case "near-image"

            Item.RemoveNearImage Request.Form("filetyp")
            Status = "OK"
            ID = eval(ItemID)

        Case Else
            If Item.Delete  Then
                Status = "OK"
                ID = eval(ItemID)
                ErrMsg = Item.ErrMsg
            Else
                ErrMsg = "Konnte nicht gel&ouml;scht werden"
            End If
    End Select
    With oJSON.Data
            .Add "status", Status
            .Add "errmsg", ErrMsg
            .Add "id", ConvertValType(ID)
    End With

    Response.Write oJSON.JSONoutput()
    Response.End

%>