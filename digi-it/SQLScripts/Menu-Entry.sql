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
/*ALTER TABLE menu ADD app nvarchar(50)
GO
UPDATE menu SET app='digiadmin'
GO */

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
VALUES ('icam','digitprofile','mnuMainProfileMyRequest','/profile/myrequest','fas fa-list-alt', 0, 1, 122, 0)

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
