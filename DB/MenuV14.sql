-- Stammdaten
DELETE FROM menu
GO
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master','Stammdaten','#','fas fa-home', 1, 1, 1, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master_plant','Anlagen','/plant','fas fa-home', 0, 1, 1, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master_failure','Fehlerliste','/failure','fas fa-home', 0, 1, 1, 2)
/*INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('master_analyze','Auswerte-Gruppen','/analyze','fas fa-home', 0, 0, 1, 3)
GO*/

-- Overview
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('overview','Übersicht','#','fab fa-algolia', 1, 1, 10, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('overview_prod','Produktionen','/overview/production','fab fa-algolia', 0, 1, 10, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('overview_down','Downtimes','/overview/downtime','fab fa-algolia', 0, 1, 10, 2)
GO

-- Coaches Data
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1','Tier1 Daten','#','fab fa-algolia', 1, 1, 20, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_safety','Safety','/tier1/safety','fab fa-algolia', 0, 1, 20, 2)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_people','People','/tier1/people','fab fa-algolia', 0, 1, 20, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_quality','Quality','/tier1/quality','fab fa-algolia', 0, 1, 20, 3)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_events','Events','/tier1/events','fab fa-algolia', 0, 1, 20, 4)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_capa','Capa','/tier1/capa','fab fa-algolia', 0, 1, 20, 5)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_cc','CC','/tier1/cc','fab fa-algolia', 0, 1, 20, 6)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_complaints','Critical Complaints','/tier1/complaints','fab fa-algolia', 0, 1, 20, 7)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_delivery_esca','Delivery Escalation','/tier1/deliveryesca','fab fa-algolia', 0, 1, 20, 8)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_other','Waste/Cost','/tier1/other','fab fa-algolia', 0, 1, 20, 9)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_delivery_pack','Delivery Packaging','/tier1/deliverypack','fab fa-algolia', 0, 1, 20, 10)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('tier1_delivery_prod','Delivery Bulk','/tier1/deliverybulk','fab fa-algolia', 0, 1, 20, 11)
--INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
--VALUES ('tier1_cost','Cost/Waste','/tier1/costwaste','fab fa-algolia', 0, 1, 20, 7)
GO

/*
-- Warehouse
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('spare','Lager','#','fab fa-algolia', 1, 1, 30, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('spare_site','Sites','/site','fab fa-algolia', 0, 1, 30, 40)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('spare_warehouse','Lager','/warehouse','fab fa-algolia', 0, 1, 30, 39)
GO
*/

-- User
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('user','Userverwaltung','#','fas fa-users', 1, 1, 40, 0)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('user_groups','Gruppen','/groups','fas fa-users', 0, 1, 40, 1)
INSERT INTO menu (menuid, menuname, menulink, iconclass, hassubmenus, active, mainsort, subsort)
VALUES ('user_user','User (AD)','/user','fas fa-users', 0, 1, 40, 2)
GO