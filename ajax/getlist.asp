<%@LANGUAGE="VBSCRIPT" CODEPAGE="65001"%>
<%
    Response.CodePage = 65001
    Response.CharSet = "UTF-8"
%>
<!--#include file="../utils/utils.asp" -->
<!--#include file="../models/models.asp" -->
<%

    Dim ListName : ListName = Request.Form("list")
    Dim UserID : UserID = Request.Form("userid")
    Dim ID : ID = Request.Form("id")
    Dim Lang : Lang = Request.Form("lang")

    Dim oJSON : Set oJSON = New aspJSON
    Dim SQLString
    Dim Rs
    Dim Helper
    Dim Helper1
    Dim List
    Dim List1
    Dim Item
    Dim oItem
    Dim bItem
    Dim iItem
    Dim Param
    Dim Params
    Dim ParamItem

    Dim StandTable

    Dim idx : idx = 0

    Select Case ListName

        Case "downbyprodid"

            Set Helper = New DowntimeHelper
            Set List = Helper.ListByProductionID(ID)

        Case "device_dd"

            Set Helper = New PlantHelper
            Set List = Helper.DeviceListDD(ID, True)

            Set Helper1 = New ModuleHelper
            Set List1 = Helper1.ListByPlantID(ID, True)


        Case "location_spare"

            Set Helper = New Spare
            Helper(ID)
            Set List = Helper.Locations

            Dim HasRecpID : HasRecpID = False
            Dim RecWhID : RecWhID = GetAppSettings("receiptwh")

            Set oItem = New Location
            Set bItem = New Location

            If CInt(Request.Form("warehouseid")) = CInt(RecWhID) Then
                For Each iItem In List.Items
                    If CInt(iItem.WarehouseID) = CInt(RecWhID) Then
                        HasRecpID = True
                    Else
                       Set oItem = iItem
                    End If
                Next
                If List.Count=1 And Not HasRecpID Then
                   Set bItem = oItem
                ElseIf HasRecpID And List.Count = 2 Then
                   Set bItem = oItem
                End If
            End If

            Set Helper1 = New ShoppingCartHelper

            Set List1 = Helper1.CartList(UserID)

        Case "regionsvp"

            Set Item = New RegionItem
            Item.ID = ID
            Set List = Item.SVPList
            Set List1 = Item.RemSVPList

        Case "room_dd"
            Set Helper = New Rooms
            Set List = Helper.ListByRegion(Request.Form("buildingid"),ID)

        Case "building_region_dd"

            Set Helper = New Building
            Set List = Helper.RegionList(ID)
            Set List1 = Helper.RoomList(ID)

        Case "module_dd"
            Set Helper = New ModuleHelper
            Set List = Helper.ListByDeviceID(ID, True)

        Case "supplier_spare"

            Set Item = New Spare
            Item(ID)
            Set List = Item.Suppliers

        Case "orderprop_item"

            Set Item = New OrderPropItem
            Item.ID = ID
            Set List = Item.Suppliers

        Case "orderprop_open"

            Set Param = New OrderPropSearch
            Param.SupplierID = ID

            Set Helper = New OrderPropHelper
            Set List = Helper.List(Param)

        Case "boxdetail"


            Set Item = New Box
            Item.ID = ID

        Case "module_link"
            Set Helper = New ModuleHelper
            Set List = Helper.LinkList(ID)

        Case "module_list"
            Set Helper = New ModuleHelper
            Set List = Helper.ListDD()


        Case "accessitem"

            Set Helper = New RequestHelper
            Set List = Helper.AccessItemList(ID)



        Case "accessitemright"

            Set Helper = New RequestHelper
            Set List = Helper.AccessRightList(ID)

        Case "isid_accessitems"

            Set Helper = New ADUser
            Helper.ID=ID
            Set List = Helper.AccessItemList
            Set List1 = Helper.Delegates

        Case "isid_accessitems_reload"

            Set Helper = New ADUser
            Helper.ID=ID

        Case "accessitem-user"

            Set Helper = New AccessHelper
            Set List = Helper.UserListByItem(ID)

        Case "accessitem-right-access"

            Set Helper = New AccessItem
            Helper.ID = ID
            Set List = Helper.AccessRights

        Case "accessitem-right-task"

            Set Helper = New AccessItem
            Helper.ID = ID
            Set List = Helper.AccessRights

        Case "user-delegate"

            Set Helper = New ADUser
            Helper.ID = ID
            Set List = Helper.Delegates

        Case "request-group-header"

            Dim GroupTable : Set GroupTable = New TableResponse
            GroupTable(Request)

        Case "stand-list"

            Set StandTable = New TableResponse
            StandTable(Request)

        Case "stand-list-ipad"

            Set StandTable = New TableResponse
            StandTable(Request)

        Case "stand-categories"
            Dim CatTable : Set CatTable = New TableResponse
            CatTable(Request)

        Case "task-fill"

            Set Helper = New AccessItem
            Dim hlpAccessTypeID : hlpAccessTypeID = Request.Form("accesstypeid")
            Dim hlpAccessItemID : hlpAccessItemID = Request.Form("accessitemid")
            Dim hlpAccessRightID : hlpAccessRightID = Request.Form("accessrightid")
            Dim hlpTaskID : hlpTaskID = Request.Form("taskid")

        Case "accessright-by-id"

            Set Helper = New AccessItem
            Helper.ID = ID

        Case "queue"

            Set Helper = New WorkFlowGroupHeadItem
            Helper.WithDetails = True
            Helper.ID = ID

        Case "stand-module-dd"

            Set Helper = New PlantHelper
            Set List = Helper.ModuleListStillDD(ID, Request.Form("deviceid"))

    End Select


    Select Case  ListName

        Case "task-fill"
            Set Helper = New AccessItem
            Set oJSON = Helper.ToJSON(ListName, hlpAccessTypeID, hlpAccessItemID, hlpAccessRightID)


        Case "regionsvp"
            With oJSON.Data
                .Add "svp", oJSON.Collection()
                With .Item("svp")
                    idx=0
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "regionid", CStr(Item.RegionID)
                            .Add "userid", Item.UserID
                            .Add "name", ToUTF8(Item.Name)
                            .Add "status", Item.Active
                            .Add "active", Item.Active
                        End With
                        idx=idx+1
                    Next
                End With
                .Add "svplist", oJSON.Collection()
                With .Item("svplist")
                    idx=0
                    For Each Item In List1.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "userid", Item.Value
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "location_spare"
            With oJSON.Data
                .Add "firstloc", oJSON.Collection()
                With .Item("firstloc")
                    .Add "locationid", CLng(bItem.LocationID)
                    .Add "warehouseid", bItem.WarehouseID
                    .Add "warehouse", bItem.Warehouse
                    .Add "shelfid", bItem.ShelfID
                    .Add "compid", bItem.CompID
                    .Add "boxid", bItem.BoxID
                    .Add "name", ToUTF8(bItem.Name)
                    .Add "act", DBFormatNumber(bItem.Act)
                End With
                idx=0
                .Add "location", oJSON.Collection()
                With .Item("location")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "locationid", CLng(Item.LocationID)
                            .Add "warehouseid", Item.WarehouseID
                            .Add "warehouse", Item.Warehouse
                            .Add "shelfid", Item.ShelfID
                            .Add "compid", Item.CompID
                            .Add "boxid", Item.BoxID
                            .Add "name", ToUTF8(Item.Name)
                            .Add "act", DBFormatNumber(Item.Act)
                        End With
                        idx=idx+1
                    Next
                End With
                .Add "cart", oJSON.Collection()
                With .Item("cart")
                    For Each Item In List1.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "shoppingid", Item.ShoppingID
                            .Add "name", Item.Name
                        End With
                        idx=idx+1
                    Next
                End With
            End With
        Case "supplier_spare"
            With oJSON.Data
                idx=0
                .Add "suppliers", oJSON.Collection()
                With .Item("suppliers")
                    For Each iItem In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "supplierid", iItem.SupplierID
                            .Add "isdefault", iItem.IsDefault
                            .Add "nb", iItem.SpareNb
                            .Add "price", DBFormatNumber(iItem.Price)
                            .Add "name", ToUTF8(iItem.Supplier)
                        End With
                        idx=idx+1
                    Next
                End With
            End With
        Case "building_region_dd"
            With oJSON.Data
                idx=0
                .Add "region", oJSON.Collection()
                With .Item("region")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(Item.Value)
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
                idx=0
                .Add "room", oJSON.Collection()
                With .Item("room")
                    For Each Item In List1.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", Item.Value
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With
        Case "device_dd"
            With oJSON.Data
                idx=0
                .Add "device", oJSON.Collection()
                With .Item("device")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(Item.Value)
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
                idx=0
                .Add "module", oJSON.Collection()
                With .Item("module")
                    For Each Item In List1.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", Item.Value
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "accessitem"
            With oJSON.Data
                .Add "id", ID
                idx=0
                .Add "accessitem", oJSON.Collection()
                With .Item("accessitem")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(Item.Value)
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "isid_accessitems_reload"

            Set oJSON = Helper.AccessItemManualToJSON(Request.Form("draw"))


        Case "isid_accessitems"
            With oJSON.Data
                .Add "id", ID
                .Add "firstname", ToUTF8(Helper.Firstname)
                .Add "lastname", ToUTF8(Helper.Lastname)
                .Add "displayname", ToUTF8(Helper.DisplayName)
                .Add "email", ToUTF8(Helper.EMail)
                .Add "location", ToUTF8(Helper.Room)
                .Add "locationid", ToUTF8(Helper.RoomID)   
                .Add "departmentid", Helper.DepartmentID
                .Add "department", ToUTF8(Helper.Department)
                idx=0
                .Add "accessitem", oJSON.Collection()
                With .Item("accessitem")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "isid", Item.ISID
                            .Add "accessitemid", CLng(Item.AccessItemID)
                            .Add "accessrightid", CLng(Item.AccessRightID)
                            .Add "select", 0
                            .Add "accesstype", Item.AccessType
                            .Add "accessitem", Item.AccessItem
                            .Add "accessright", Item.AccessRight
                        End With
                        idx=idx+1
                    Next
                End With
                idx=0
                .Add "delegates", oJSON.Collection()
                With .Item("delegates")
                    For Each Item In List1.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "isid", Item.DelegateISID
                            .Add "lastname", ToUTF8(Item.LastName)
                            .Add "firstname", ToUTF8(Item.FirstName)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "accessitemright"
            With oJSON.Data
                .Add "id", ID
                idx=0
                .Add "accessitemright", oJSON.Collection()
                With .Item("accessitemright")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", CLng(Item.Value)
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With
        Case "orderprop_item"

            With oJSON.Data
                idx=0
                .Add "orderid", CLng(Item.ID)
                .Add "sparepartid", CLng(Item.SparepartID)
                .Add "sparepart", ToUTF8(Item.Sparepart)
                .Add "sparepartnb", ToUTF8(Item.SparepartNb)
                .Add "supplierid", Item.SupplierID
                .Add "supplier", ToUTF8(Item.Supplier)
                .Add "ordernb", ToUTF8(Item.OrderNb)
                .Add "orderqty", DBFormatNumber(Item.OrderQty)
                .Add "stateid", Item.StateID
                .Add "price", DBFormatNumber(Item.Price)
                .Add "act", DBFormatNumber(Item.Act)
                .Add "suppliers", oJSON.Collection()
                With .Item("suppliers")
                    For Each iItem In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "supplierid", iItem.SupplierID
                            .Add "isdefault", iItem.IsDefault
                            .Add "nb", iItem.SpareNb
                            .Add "price", DBFormatNumber(iItem.Price)
                            .Add "name", ToUTF8(iItem.Supplier)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "orderprop_open"

            With oJSON.Data
                idx=0
                .Add "supplierid", ID
                .Add "details", oJSON.Collection()
                With .Item("details")
                    For Each iItem In List.Items
                        If iItem.StateID = 0 Then
                            .Add idx, oJSON.Collection()
                            With .Item(idx)
                                .Add "detailid", CLng(-1)
                                .Add "orderid", CLng(iItem.ID)
                                .Add "sparepartid", CLng(iItem.SparepartID)
                                .Add "suppliernb", ToUTF8(iItem.OrderNb)
                                .Add "sparepartnb", ToUTF8(iItem.SparepartNb)
                                .Add "sparepart", ToUTF8(iItem.Sparepart)
                                .Add "orderqty", DBFormatNumber(iItem.OrderQty)
                            End With
                            idx=idx+1
                        End If
                    Next
                End With
            End With

        Case "module_list"
            idx=0
            With oJSON.Data
                .Add ListName, oJSON.Collection()
                With .Item(ListName)
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", Item.Value
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "stand-module-dd"

             idx=0
            With oJSON.Data
                .Add ListName, oJSON.Collection()
                With .Item(ListName)
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "value", Item.Value
                            .Add "name", ToUTF8(Item.Name)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "module_link"

            With oJSON.Data
                idx=0
                .Add "moduleid", ID
                .Add ListName, oJSON.Collection()
                With .Item(ListName)
                    For Each iItem In List.Items

                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "linkid", CLng(iItem.ID)
                            .Add "moduleid", iItem.ModuleID
                            .Add "plantid", iItem.PlantID
                            .Add "deviceid", iItem.DeviceID
                            .Add "module", ToUTF8(iItem.Module)
                            .Add "plant", ToUTF8(iItem.Plant)
                            .Add "device", ToUTF8(iItem.Device)
                        End With
                        idx=idx+1

                    Next
                End With
            End With

        Case "boxdetail"

            With oJSON.Data
                idx=0
                .Add "boxid", ID
                If IsNull(Item.LocationID) Then
                   .Add "locationid", ""
                Else
                   .Add "locationid", CLng(Item.LocationID)
                End If
                If IsNull(Item.WarehouseID) Then
                   .Add "warehouseid", ""
                Else
                   .Add "warehouseid", Item.WarehouseID
                End If
                If IsNull(Item.ShelfID) Then
                   .Add "shelfid", ""
                Else
                   .Add "shelfid", Item.ShelfID
                End If
                If IsNull(Item.CompID) Then
                   .Add "compid", ""
                Else
                   .Add "compid", Item.CompID
                End If
                .Add "location", ToUTF8(Item.Location)
                .Add "warehouse", ToUTF8(Item.Warehouse)
                .Add "boxname", ToUTF8(Item.Name)
            End With

        Case "accessitem-user"

            With oJSON.Data
                .Add "id", CLng(ID)
                .Add "item", ListName
                .Add "status","OK"
                .Add ListName, oJSON.Collection()

                idx=0
                With .Item(ListName)
                    For Each iItem In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "accessitem", ToUTF8(iItem.Name)
                            .Add "accessright", ToUTF8(iItem.AccessRight)
                            .Add "displayname", ToUTF8(iItem.DisplayName)
                            .Add "isid", iItem.ISID
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "accessitem-right-access"

            Set Params = Server.CreateObject( "Scripting.Dictionary")

            Set ParamItem = New ListItem
            ParamItem.Value = CLng(ID)
            ParamItem.Name = "id"
            Params.Add Params.Count,ParamItem

            Set ParamItem = New ListItem
            ParamItem.Value = ListName
            ParamItem.Name = "item"
            Params.Add Params.Count,ParamItem

            Set ParamItem = New ListItem
            ParamItem.Value = "OK"
            ParamItem.Name = "status"
            Params.Add Params.Count,ParamItem

            Set oJSON = Helper.ToJSONObj(Params, "accessitem")

        Case "accessitem-right-task"

            Set Params = Server.CreateObject( "Scripting.Dictionary")

            Set ParamItem = New ListItem
            ParamItem.Value = CLng(ID)
            ParamItem.Name = "id"
            Params.Add Params.Count,ParamItem

            Set ParamItem = New ListItem
            ParamItem.Value = ListName
            ParamItem.Name = "item"
            Params.Add Params.Count,ParamItem

            Set ParamItem = New ListItem
            ParamItem.Value = "OK"
            ParamItem.Name = "status"
            Params.Add Params.Count,ParamItem

            Set oJSON = Helper.ToJSONObj(Params, "accessrighttask")


        Case  "accessright-by-id"

            Set Params = Server.CreateObject( "Scripting.Dictionary")

            Set ParamItem = New ListItem
            ParamItem.Value = CLng(ID)
            ParamItem.Name = "id"
            Params.Add Params.Count,ParamItem

            Set ParamItem = New ListItem
            ParamItem.Value = ListName
            ParamItem.Name = "item"
            Params.Add Params.Count,ParamItem

            Set ParamItem = New ListItem
            ParamItem.Value = "OK"
            ParamItem.Name = "status"
            Params.Add Params.Count,ParamItem

            Set oJSON = Helper.ToJSONObj(Params, "accessright")

        Case "user-delegate"

            With oJSON.Data
                .Add "id", ID
                .Add "item", ListName
                .Add "status","OK"
                .Add ListName, oJSON.Collection()
                idx=0
                With .Item(ListName)
                    For Each iItem In List.Items
                        .Add idx, oJSON.Collection()
                        With .Item(idx)
                            .Add "isid", ToUTF8(iItem.DelegateISID)
                            .Add "lastname", ToUTF8(iItem.LastName)
                            .Add "firstname", ToUTF8(iItem.FirstName)
                        End With
                        idx=idx+1
                    Next
                End With
            End With

        Case "request-group-header"
            Set oJSON = GroupTable.ToJSON(ListName)

        Case "stand-list"

            Set oJSON = StandTable.ToJSON(ListName)

        Case "stand-list-ipad"

            Set oJSON = StandTable.ToJSON(ListName)

        Case "stand-categories"
            Set oJSON = CatTable.ToJSON(ListName)

        Case "queue"
            Set oJSON = Helper.ToJSON(ListName)

        Case Else

            With oJSON.Data
                ''.Add "list", oJSON.Collection()
                ''With .Item("list")
                    For Each Item In List.Items
                        .Add idx, oJSON.Collection()
                        Select Case ListName
                            Case "downbyprodid"
                                With .Item(idx)
                                    .Add "downtimeid", FormatGUID(Item.DownTimeID)
                                    .Add "plantid", Item.PlantID
                                    .Add "deviceid", Item.DeviceID
                                    .Add "device", Item.Device
                                    .Add "componentid", Item.ComponentID
                                    .Add "component", Item.Component
                                    .Add "failureid", Item.FailureID
                                    .Add "failure", Item.Failure
                                    .Add "start_time", Item.StartTime
                                    .Add "end_time", Item.EndTime
                                    .Add "userid", Item.UserID
                                    .Add "productionid", FormatGUID(Item.ProductionID)
                                    .Add "controlid", Item.ControlID
                                    .Add "minutesdowntime", Item.MinutesDownTime
                                    .Add "status", Item.Status
                                End With

                            Case "room_dd"
                                With .Item(idx)
                                    .Add "value", Item.Value
                                    .Add "name", ToUTF8(Item.Name)
                                End With
                            Case "module_dd"
                                With .Item(idx)
                                    .Add "value", Item.Value
                                    .Add "name", ToUTF8(Item.Name)
                                End With
                        End Select

                        idx=idx+1

                    Next
                ''End With
            End With

    End Select

    Response.Write oJSON.JSONoutput()
    Response.End

%>