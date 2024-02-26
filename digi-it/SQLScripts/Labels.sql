------------------------------------------------------------------
-- Labels
------------------------------------------------------------------
DELETE FROM label WHERE labelname='lblUserlist'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblUserlist','de','Userlist', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblUserlist','en','Userlist', GETDATE())
GO

DELETE FROM label WHERE labelname='lblDisplayname'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDisplayname','de','DisplayName', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDisplayname','en','DisplayName', GETDATE())
GO
DELETE FROM label WHERE labelname='lblLastname'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblLastname','de','Nachname', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblLastname','en','Last Name', GETDATE())
GO
DELETE FROM label WHERE labelname='lblFirstname'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblFirstname','de','Vorname', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblFirstname','en','First Name', GETDATE())
GO
DELETE FROM label WHERE labelname='lblLocation'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblLocation','de','Standort', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblLocation','en','Location', GETDATE())
GO

DELETE FROM label WHERE labelname='lblEmail'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblEmail','de','E-Mail', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblEmail','en','email', GETDATE())
GO

DELETE FROM label WHERE labelname='lblDepartment'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDepartment','de','Abteilung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDepartment','en','Department', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAvailableShares'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAvailableShares','de','verfügbare Shares', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAvailableShares','en','available Shares', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAvailableApps'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAvailableApps','de','verfügbare Applikationen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAvailableApps','en','available applications', GETDATE())
GO

DELETE FROM label WHERE labelname='lblName'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblName','de','Name', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblName','en','Name', GETDATE())
GO

DELETE FROM label WHERE labelname='lblType'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblType','de','Type', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblType','en','Type', GETDATE())
GO

DELETE FROM label WHERE labelname='lblState'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblState','de','Status', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblState','en','Status', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestlist'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestlist','de','Anträge', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestlist','en','Requests', GETDATE())
GO

DELETE FROM label WHERE labelname='lblCreatedBy'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblCreatedBy','de','Erstellt von', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblCreatedBy','en','Created By', GETDATE())
GO
DELETE FROM label WHERE labelname='lblCreated'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblCreated','de','Erstellt am', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblCreated','en','Created', GETDATE())
GO

DELETE FROM label WHERE labelname='lblDescription'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDescription','de','Beschreibung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDescription','en','Description', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestNb'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestNb','de','RequestNr', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestNb','en','RequestNb', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAssignedTo'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAssignedTo','de','Zugeteilt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAssignedTo','en','Assigned', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestForm'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestForm','de','Antrags-Formular', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestForm','en','Request Form', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAccessRights'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessRights','de','Zugriffsrechte', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessRights','en','Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAccessRight'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessRight','de','Zugriffsrecht', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessRight','en','Access Right', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestor'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestor','de','Anforderer', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestor','en','Requestor', GETDATE())
GO

DELETE FROM label WHERE labelname='lblPlaceholderNew'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblPlaceholderNew','de','<Neu>', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblPlaceholderNew','en','<New>', GETDATE())
GO

DELETE FROM label WHERE labelname='lblSelect'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblSelect','de','Auswahl', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblSelect','en','Select', GETDATE())
GO


DELETE FROM label WHERE labelname='lblAccessItemType'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessItemType','de','Typ', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessItemType','en','Type', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAccessItem'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessItem','de','Objekt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessItem','en','Object', GETDATE())
GO

DELETE FROM label WHERE labelname='lblARight'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblARight','de','Zugriffstyp', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblARight','en','Access Type', GETDATE())
GO

DELETE FROM label WHERE labelname='lblDate'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDate','de','Datum', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDate','en','Date', GETDATE())
GO

DELETE FROM label WHERE labelname='lblWarning'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblWarning','de','Warnung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblWarning','en','Warning', GETDATE())
GO

DELETE FROM label WHERE labelname='lblSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblSuccess','de','Information', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblSuccess','en','Information', GETDATE())
GO

DELETE FROM label WHERE labelname='lblQuestion'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblQuestion','de','Frage', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblQuestion','en','Question', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestedFor'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestedFor','de','Erstellt für', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestedFor','en','Requested for', GETDATE())
GO

DELETE FROM label WHERE labelname='lblComment'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblComment','de','Kommentar', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblComment','en','Comment', GETDATE())
GO

DELETE FROM label WHERE labelname='lblOpenRequests'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblOpenRequests','de','offene Anträge', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblOpenRequests','en','open Requests', GETDATE())
GO

DELETE FROM label WHERE labelname='lblOpenWorkItems'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblOpenWorkItems','de','offene Tasks', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblOpenWorkItems','en','open Tasks', GETDATE())
GO


DELETE FROM label WHERE labelname='lblRevokeAccessRights'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRevokeAccessRights','de','Zugriffsrechte entfernen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRevokeAccessRights','en','Revoke Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTabGenerally'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabGenerally','de','Allgemein', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabGenerally','en','Generally', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTabAccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabAccess','de','Berechtigungen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabAccess','en','Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTabAccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabAccess','de','Berechtigungen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabAccess','en','Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTabDelegate'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabDelegate','de','Vertretung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTabDelegate','en','Delegate', GETDATE())
GO

DELETE FROM label WHERE labelname='lblDelegate'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDelegate','de','Vertretung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblDelegate','en','Delegate', GETDATE())
GO

DELETE FROM label WHERE labelname='lblUser'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblUser','de','Benutzer', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblUser','en','User', GETDATE())
GO


DELETE FROM label WHERE labelname='lblTaskNb'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskNb','de','Task-Nr', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskNb','en','Task-Nb', GETDATE())
GO

DELETE FROM label WHERE labelname='lblUserAccessForm'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblUserAccessForm','de','User Formblatt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblUserAccessForm','en','User Access Form', GETDATE())
GO

DELETE FROM label WHERE labelname='lblWorkFlow'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblWorkFlow','de','Workflow', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblWorkFlow','en','Workflow', GETDATE())
GO

DELETE FROM label WHERE labelname='lblQueue'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblQueue','de','Queue', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblQueue','en','Queue', GETDATE())
GO

DELETE FROM label WHERE labelname='lblOwnRequest'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblOwnRequest','de','Eigene Anträge', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblOwnRequest','en','Own Requests', GETDATE())
GO

------------------------------------------------------------------
--Messages
------------------------------------------------------------------

DELETE FROM label WHERE labelname='msgSyncADData'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgSyncADData','de','Active Directory Daten werden aktualisiert. Bitte warten...', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgSyncADData','en','Syncronize Active Directory Data. Please wait..', GETDATE())
GO

DELETE FROM label WHERE labelname='msgSyncADDataSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgSyncADDataSuccess','de','Active Directory Daten wurde erfolgreich aktualisiert.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgSyncADDataSuccess','en','Active Directory Data successfully syncronized', GETDATE())
GO

DELETE FROM label WHERE labelname='msgSyncADDataFailed'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgSyncADDataFailed','de','Active Directory Daten konnten nicht aktualisiert werden.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgSyncADDataFailed','en','Active Directory Data not successfully syncronized', GETDATE())
GO

DELETE FROM label WHERE labelname='msgFillAllFields'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgFillAllFields','de','Alle Felder müssen ausgefüllt werden.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgFillAllFields','en','All fields has to be filled', GETDATE())
GO


DELETE FROM label WHERE labelname='msgRequestCreatedSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestCreatedSuccess','de','Antrag wurde erstellt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestCreatedSuccess','en','Request is created.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgRequestCreatedError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestCreatedError','de','Antrag konnte nicht erstellt werden.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestCreatedError','en','Request cannot be created.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgAccessRightAtLeastOne'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgAccessRightAtLeastOne','de','Zumindest ein Berechtigungsobjekt muss hinzugefügt werden.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgAccessRightAtLeastOne','en','At least one access item must be added.', GETDATE())
GO


DELETE FROM label WHERE labelname='msgRequestApprovedSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestApprovedSuccess','de','Antrag wurde genehemigt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestApprovedSuccess','en','Request is approved.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgRequestApprovedError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestApprovedError','de','Antrag konnte nicht genehemigt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestApprovedError','en','Request was not approved.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgRequestRejectSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestRejectSuccess','de','Antrag wurde abgelehnt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestRejectSuccess','en','Request is rejected.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgRequestRejectError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestRejectError','de','Antrag konnte nicht abgelehnt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgRequestRejectError','en','Request was not rejected.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgWorkItemDoneSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemDoneSuccess','de','Antrag wurde erfolgreich durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemDoneSuccess','en','Request was successfully done.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgWorkItemDoneError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemDoneError','de','Antrag konnte nicht erfolgreich durchgeführt werden', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemDoneError','en','Request was NOT successfully done.', GETDATE())
GO

DELETE FROM label WHERE labelname='msgWorkItemNotDoneSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemNotDoneSuccess','de','Antrag wurde erfolgreich abgebrochen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemNotDoneSuccess','en','Request was successfully canceled', GETDATE())
GO

DELETE FROM label WHERE labelname='msgWorkItemNotDoneError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemNotDoneError','de','Antrag wurde nicht erfolgreich abgebrochen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgWorkItemNotDoneError','en','Request was NOT successfully canceled', GETDATE())
GO

DELETE FROM label WHERE labelname='msgDataSaveSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataSaveSuccess','de','Daten wurden erfolgreich gespeichert', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataSaveSuccess','en','Data successfully saved', GETDATE())
GO
DELETE FROM label WHERE labelname='msgDataSaveError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataSaveError','de','Daten konnten nicht gespeichert werden', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataSaveError','en','Data NOT successfully saved', GETDATE())
GO

DELETE FROM label WHERE labelname='msgDataDeleteSuccess'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataDeleteSuccess','de','Daten wurden erfolgreich gelöscht', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataDeleteSuccess','en','Data successfully deleted', GETDATE())
GO
DELETE FROM label WHERE labelname='msgDataDeleteError'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataDeleteError','de','Daten konnten nicht gelöscht werden', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('msgDataDeleteError','en','Data NOT successfully deleted', GETDATE())
GO


------------------------------------------------------
-- Mails ---------------------------------------------
--------------------------------------------------------
-- Request
--------------------------------------------------------
DELETE FROM label WHERE labelname='mailRequestAccessCreated'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessCreated','de','Antrag $$reqnb$$ wurde erstellt.<br><br>Sie haben für $$accessitem$$ einen Antrag erstellt.<br><br>$$app$$', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessCreated','en','Request $$reqnb$$ was created.<br><br>You have created an request for $$accessitem$$.<br><br>$$app$$', GETDATE())
GO
DELETE FROM label WHERE labelname='subjectRequestAccessCreated'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessCreated','de','Request $$reqnb$$ wurde erstellt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessCreated','en','Request $$reqnb$$ was created.', GETDATE())
GO


DELETE FROM label WHERE labelname='mailRequestAccessOpened'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessOpened','de','Request $$reqnb$$ wurde erstellt.<br><br>Sie sind als Verantwortlicher für $$accessitem$$ hinterlegt. Bitte bestätigen sie den Request oder lehnen sie in ab. Bitte melden sie sich unter dem Link: $$link$$ an<br><br>$$app$$', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessOpened','en','Request $$reqnb$$ was created.<br><br>You are listed as responsible approver for $$accessitem$$. Please approve or reject this request. Please login on to link $$link$$<br><br>$$app$$', GETDATE())
GO
DELETE FROM label WHERE labelname='subjectRequestAccessOpened'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessOpened','de','Request $$reqnb$$ wurde erstellt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessOpened','en','Request $$reqnb$$ was created.', GETDATE())
GO

DELETE FROM label WHERE labelname='mailRequestAccessApproved'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessApproved','de','Request $$reqnb$$ für $$accessitem$$ wurde genehmigt.<br><br>$$app$$', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessApproved','en','Request $$reqnb$$ for $$accessitem$$ is approved.<br><br>$$app$$', GETDATE())
GO
DELETE FROM label WHERE labelname='subjectRequestAccessApproved'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessApproved','de','Request $$reqnb$$ wurde genehmigt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessApproved','en','Request $$reqnb$$ is approved.', GETDATE())
GO

DELETE FROM label WHERE labelname='mailRequestAccessRejected'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessRejected','de','Request $$reqnb$$ für $$accessitem$$ wurde abgelehnt.<br><br>$$app$$', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestAccessRejected','en','Request $$reqnb$$ for $$accessitem$$ is rejected.<br><br>$$app$$', GETDATE())
GO
DELETE FROM label WHERE labelname='subjectRequestAccessRejected'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessRejected','de','Request $$reqnb$$ wurde abgelehnt.', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestAccessRejected','en','Request $$reqnb$$ is rejected.', GETDATE())
GO

DELETE FROM label WHERE labelname='mailRequestMailRequestorDone'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestMailRequestorDone','de','Request $$reqnb$$ für $$accessitem$$ wurde erfolgreich durchgeführt.<br><br>$$app$$', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestMailRequestorDone','en','Request $$reqnb$$ for $$accessitem$$ was successfully executed.<br><br>$$app$$', GETDATE())
GO
DELETE FROM label WHERE labelname='subjectRequestMailRequestorDone'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestMailRequestorDone','de','Request $$reqnb$$ wurde erfolgreich durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestMailRequestorDone','en','Request $$reqnb$$ was successfully executed.', GETDATE())
GO

DELETE FROM label WHERE labelname='mailRequestMailRequestorNotDone'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestMailRequestorNotDone','de','Request $$reqnb$$ für $$accessitem$$ wurde nicht durchgeführt.<br><br>$$app$$', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('mailRequestMailRequestorNotDone','en','Request $$reqnb$$ for $$accessitem$$ was not executed.<br><br>$$app$$', GETDATE())
GO
DELETE FROM label WHERE labelname='subjectRequestMailRequestorNotDone'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestMailRequestorNotDone','de','Request $$reqnb$$ wurde nicht durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('subjectRequestMailRequestorNotDone','en','Request $$reqnb$$ was not executed.', GETDATE())
GO


------------------------------------------------------
--- Buttons
------------------------------------------------------
DELETE FROM label WHERE labelname='btnSubmit'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnSubmit','de','Senden', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnSubmit','en','Submit', GETDATE())
GO

DELETE FROM label WHERE labelname='btnAdd'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnAdd','de','Hinzufügen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnAdd','en','Add', GETDATE())
GO

DELETE FROM label WHERE labelname='btnLogout'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnLogout','de','Logout', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnLogout','en','Logout', GETDATE())
GO

DELETE FROM label WHERE labelname='btnCancel'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnCancel','de','Abbrechen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnCancel','en','Cancel', GETDATE())
GO

DELETE FROM label WHERE labelname='btnApprove'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnApprove','de','Genehmigen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnApprove','en','Approve', GETDATE())
GO

DELETE FROM label WHERE labelname='btnReject'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnReject','de','Ablehnen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnReject','en','Reject', GETDATE())
GO

DELETE FROM label WHERE labelname='btnBack'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnBack','de','Zurück', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnBack','en','Back', GETDATE())
GO

DELETE FROM label WHERE labelname='btnGrant'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnGrant','de','Zugriffsrechte erteilen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnGrant','en','Grant Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='btnRevoke'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnRevoke','de','Zugriffsrechte entfernen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnRevoke','en','Revoke Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='btnDone'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnDone','de','Durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnDone','en','Done', GETDATE())
GO

DELETE FROM label WHERE labelname='btnNotDone'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnNotDone','de','nicht Durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnNotDone','en','not Done', GETDATE())
GO

DELETE FROM label WHERE labelname='btnUpload'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnUpload','de','Upload', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnUpload','en','Upload', GETDATE())
GO

DELETE FROM label WHERE labelname='btnEdit'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnEdit','de','Bearbeiten', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnEdit','en','Edit', GETDATE())
GO

DELETE FROM label WHERE labelname='btnAccessRight'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnAccessRight','de','Berechtigungen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnAccessRight','en','Access Rights', GETDATE())
GO

DELETE FROM label WHERE labelname='btnWorkFlow'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnWorkFlow','de','Workflow', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnWorkFlow','en','Workflow', GETDATE())
GO

DELETE FROM label WHERE labelname='btnSave'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnSave','de','Speichern', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('btnSave','en','Save', GETDATE())
GO

------------------------------------------------------
--- Request Stati
------------------------------------------------------
DELETE FROM label WHERE labelname='lblRequestState'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState','de','Status', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState','en','Status', GETDATE())
GO


DELETE FROM label WHERE labelname='lblRequestState10'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState10','de','Offen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState10','en','Open', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestState20'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState20','de','in Bearbeitung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState20','en','in progress', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestState30'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState30','de','Pending', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState30','en','Pending', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestState40'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState40','de','Geschlossen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState40','en','Closed', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestState50'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState50','de','Abgebrochen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestState50','en','Canceled', GETDATE())
GO


------------------------------------------------------
--- Approve Stati
------------------------------------------------------

DELETE FROM label WHERE labelname='lblApproveState20'
GO
DELETE FROM label WHERE labelname='lblApproveState30'
GO


DELETE FROM label WHERE labelname='lblApproveState'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState','de','Genehmigung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState','en','Approval', GETDATE())
GO


DELETE FROM label WHERE labelname='lblApproveState10'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState10','de','Offen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState10','en','Open', GETDATE())
GO

DELETE FROM label WHERE labelname='lblApproveState40'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState40','de','Genehmigt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState40','en','Approved', GETDATE())
GO

DELETE FROM label WHERE labelname='lblApproveState50'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState50','de','Abgelehnt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblApproveState50','en','Rejected', GETDATE())
GO


------------------------------------------------------
--- RequestType
------------------------------------------------------
DELETE FROM label WHERE labelname='lblRequestType'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestType','de','Typ', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestType','en','Type', GETDATE())
GO


DELETE FROM label WHERE labelname='lblRequestType10'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestType10','de','Zugriff Erteilen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestType10','en','Grant Access', GETDATE())
GO

DELETE FROM label WHERE labelname='lblRequestType20'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestType20','de','Zugriff Entziehen', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblRequestType20','en','Revoke Access', GETDATE())
GO


------------------------------------------------------
--- TaskType
------------------------------------------------------
DELETE FROM label WHERE labelname='lblTaskType'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType','de','TaskTyp', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType','en','TaskType', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTaskType10'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType10','de','Genehmigung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType10','en','Approval', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTaskType20'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType20','de','Durchführung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType20','en','Execution', GETDATE())
GO

DELETE FROM label WHERE labelname='lblTaskType30'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType30','de','Upload', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblTaskType30','en','Upload', GETDATE())
GO


------------------------------------------------------
--- AccessItemState
------------------------------------------------------
DELETE FROM label WHERE labelname='lblState1'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblState1','de','Aktiv', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblState1','en','Enabled', GETDATE())
GO

DELETE FROM label WHERE labelname='lblState0'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblState0','de','Inaktiv', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblState0','en','Disabled', GETDATE())
GO


------------------------------------------------------
--- AccessType
------------------------------------------------------
DELETE FROM label WHERE labelname='lblAccessType1'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessType1','de','Netzwerklaufwerk', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessType1','en','network share', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAccessType2'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessType2','de','Applikation', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessType2','en','application', GETDATE())
GO

DELETE FROM label WHERE labelname='lblAccessType3'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessType3','de','SAP', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblAccessType3','en','SAP', GETDATE())
GO

-------------------------------------------------------------
--- E-Mail Title
-------------------------------------------------------------
DELETE FROM label WHERE labelname='lblMailTitle'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle','de','Mail-Titel', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle','en','Mail-Titel', GETDATE())
GO

DELETE FROM label WHERE labelname='lblMailTitle1'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle1','de','Antrag erstellt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle1','en','Request created', GETDATE())
GO

DELETE FROM label WHERE labelname='lblMailTitle2'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle2','de','Antrag zur Genehmigung', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle2','en','Request for approval', GETDATE())
GO

DELETE FROM label WHERE labelname='lblMailTitle3'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle3','de','Antrag genemigt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle3','en','Request approved', GETDATE())
GO

DELETE FROM label WHERE labelname='lblMailTitle4'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle4','de','Antrag abgelehnt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle4','en','Request rejected', GETDATE())
GO

DELETE FROM label WHERE labelname='lblMailTitle5'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle5','de','Antrag durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle5','en','Request processed', GETDATE())
GO

DELETE FROM label WHERE labelname='lblMailTitle6'
GO
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle6','de','Antrag NICHT durchgeführt', GETDATE())
INSERT INTO label ( labelname, lang, labeltext,labeldate )
VALUES ('lblMailTitle6','en','Request NOT processed', GETDATE())
GO





