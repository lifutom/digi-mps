DELETE FROM label WHERE labelname='mnuMainDashboard'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainDashboard','de','Dashboard', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainDashboard','en','Dashboard', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainRequest'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainRequest','de','Inbox', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainRequest','en','Inbox', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainRequestMaintain'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainRequestMaintain','de','Approvals', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainRequestMaintain','en','Approvals', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainRequestHistory'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainRequestHistory','de','Suchen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainRequestHistory','en','Search', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainWorkList'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainWorkList','de','ToDo-Liste', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainWorkList','en','WorkItems', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainWorkListMaint'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainWorkListMaint','de','Tasks', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainWorkListMaint','en','Tasks', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainWorkListHistory'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainWorkListHistory','de','Suchen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainWorkListHistory','en','Search', GETDATE())
GO



DELETE FROM label WHERE labelname='mnuMainObject'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObject','de','Geräte', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObject','en','Devices', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainObjectComputer'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectComputer','de','Laptop/Desktop', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectComputer','en','Laptop/Desktop', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainObjectServer'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectServer','de','Server', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectServer','en','Server', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainObjectNetwork'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectNetwork','de','Netzwerk', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectNetwork','en','Network', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainObjectPrinter'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectPrinter','de','Drucker', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainObjectPrinter','en','Printer', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainUser'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainUser','de','Benutzer', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainUser','en','User', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainAccessItem'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItem','de','Berechtigungen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItem','en','Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainAccessItemShares'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemShares','de','Shares (AD)', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemShares','en','Shares (AD)', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainAccessItemApps'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemApps','de','Applikationen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemApps','en','Application', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainAccessItemSAP'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemSAP','de','SAP', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemSAP','en','SAP', GETDATE())
GO

DELETE FROM label WHERE labelname='mnuMainAccessItemWorkflow'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemWorkflow','de','Workflow', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainAccessItemWorkflow','en','Workflow', GETDATE())
GO


DELETE FROM label WHERE labelname='mnuMainProfileMyRequest'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainProfileMyRequest','de','Eigene Anträge', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mnuMainProfileMyRequest','en','Own Requests', GETDATE())
GO


/*setting digi-it default menus */
DELETE FROM group_access WHERE groupid='icam-default'
GO
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digituser')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitdashbord')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitrequest')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitrequest_history')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitrequest_maint')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitworklist')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitworklist_maint')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitworklist_history')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitaccessitem')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitaccessitem_app')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitaccessitem_shares')
INSERT INTO group_access (groupid, menuid)
VALUES('icam-default','digitprofile')
GO


------------------------------------------------------------------------------------------
-- Menu Digi-IT
------------------------------------------------------------------------------------------
DELETE FROM menu WHERE app='icam'
GO
-- Dashboard
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitdashbord','mnuMainDashboard','/home','w-fa fas fa-tachometer-alt', 0, 1, 100, 0)

-- Requests
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitrequest','mnuMainRequest','#','fas fa-inbox', 1, 1, 110, 0)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitrequest_maint','mnuMainRequestMaintain','/request','w-fa far fa-check-square', 0, 1, 110, 1)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitrequest_history','mnuMainRequestHistory','/request/history','fas fa-search', 0, 1, 110, 2)
GO

-- Worklist
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitworklist','mnuMainWorkList','#','fas fa-list-alt', 1, 1, 120, 0)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitworklist_maint','mnuMainWorkListMaint','/worklist','fas fa-list-alt', 0, 1, 120, 1)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitworklist_history','mnuMainWorkListHistory','/worklist/history','fas fa-search', 0, 1, 120, 2)


-- Own Requests
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitprofile','mnuMainProfileMyRequest','/profile/ownrequest','fas fa-list-alt', 0, 1, 122, 0)

-- User
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digituser','mnuMainUser','/user','w-fa fas fa-user', 0, 1, 130, 0)

-- Objects
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitaccessitem','mnuMainAccessItem','#','fas fa-universal-access', 1, 1, 140, 0)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitaccessitem_shares','mnuMainAccessItemShares','/accessitem/adshares','fas fa-globe', 0, 1, 140, 1)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitaccessitem_app','mnuMainAccessItemApps','/accessitem/apps','fas fa-database', 0, 1, 140, 2)
--INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
--VALUES ('digi-it','digitaccessitem_sap','mnuMainAccessItemSAP','/accessitem/sap','w-fa far fa-check-square', 0, 1, 140, 3)
INSERT INTO menu (app,menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('icam','digitaccessitem_wf','mnuMainAccessItemWorkflow','/accessitem/workflow','fas fa-bezier-curve', 0, 1, 140, 4)
GO



