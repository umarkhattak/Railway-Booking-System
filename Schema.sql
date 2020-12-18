CREATE DATABASE `RailwayBookingSystem`;
USE `RailwayBookingSystem`;

DROP TABLE IF EXISTS `Questions`;
DROP TABLE IF EXISTS `Schedule`;
DROP TABLE IF EXISTS `Reservation`;
DROP TABLE IF EXISTS `Stops`;
DROP TABLE IF EXISTS `Route`;
DROP TABLE IF EXISTS `WorksAt`;
DROP TABLE IF EXISTS `WorksOn`;
DROP TABLE IF EXISTS `Station`;
DROP TABLE IF EXISTS `Train`;
DROP TABLE IF EXISTS `Employee`;
DROP TABLE IF EXISTS `Representative`;
DROP TABLE IF EXISTS `Administrator`;
DROP TABLE IF EXISTS `Customer`;

CREATE TABLE `Customer` (
`firstName` varchar(20) NOT NULL,
`lastName` varchar(20) NOT NULL,
`emailAddress` varchar(50) NOT NULL UNIQUE,
`username` varchar(20) NOT NULL,
`password` varchar(20) NOT NULL,
`age` int NOT NULL DEFAULT 18,
`disabled` boolean NOT NULL DEFAULT FALSE,
PRIMARY KEY (`username`)
);

CREATE TABLE `Administrator` (
`ssn` char(11) UNIQUE,
`firstName` varchar(20) NOT NULL,
`lastName` varchar(20) NOT NULL,
`username` varchar(20) UNIQUE,
`password` varchar(20) NOT NULL,
PRIMARY KEY (`ssn`)
);

CREATE TABLE `Representative` (
`ssn` char(11) NOT NULL UNIQUE,
`firstName` varchar(20) NOT NULL,
`lastName` varchar(20) NOT NULL,
`emailAddress` varchar(50) NOT NULL UNIQUE,
`username` varchar(20) NOT NULL,
`password` varchar(20) NOT NULL,
PRIMARY KEY (`username`)
);

CREATE TABLE `Employee` (
`ssn` char(11) NOT NULL,
`firstName` varchar(20) NOT NULL,
`lastName` varchar(20) NOT NULL,
`username` varchar(20) NOT NULL,
`password` varchar(20) NOT NULL,
PRIMARY KEY (`ssn`)
);

CREATE TABLE `Train` (
`trainID` int NOT NULL,
`information` varchar(50),
PRIMARY KEY (`trainID`)
);

CREATE TABLE `Station` (
`stationID` int NOT NULL,
`name` varchar(30),
`city` varchar(20) NOT NULL,
`state` char(2) NOT NULL,
PRIMARY KEY (`stationID`)
);

CREATE TABLE `WorksOn` (
`ssn` char(11),
`trainID` int,
PRIMARY KEY (`ssn`),
FOREIGN KEY (`ssn`) REFERENCES `Employee`(`ssn`),
FOREIGN KEY (`trainID`) REFERENCES `Train`(`trainID`)
);

CREATE TABLE `WorksAt` (
`ssn` char(11),
`stationID` int,
PRIMARY KEY (`ssn`),
FOREIGN KEY (`ssn`) REFERENCES `Employee`(`ssn`),
FOREIGN KEY (`stationID`) REFERENCES `Station`(`stationID`)
);

CREATE TABLE `Route` (
`route_name` varchar(20) NOT NULL,
`origin` int NOT NULL,
`destination` int NOT NULL,
`stops` int NOT NULL,
`travel_time` int NOT NULL,
`fare` float NOT NULL DEFAULT 5.0,
`clockwise` boolean NOT NULL,
PRIMARY KEY (`route_name`, `origin`, `destination`),
FOREIGN KEY (`origin`) REFERENCES `Station`(`stationID`),
FOREIGN KEY (`destination`) REFERENCES `Station`(`stationID`)
);

CREATE TABLE `Stops` (
`origin` int NOT NULL,
`destination` int NOT NULL,
`travel_time` int NOT NULL,
PRIMARY KEY (`origin`, `destination`),
FOREIGN KEY (`origin`) REFERENCES `Station`(`stationID`),
FOREIGN KEY (`destination`) REFERENCES `Station`(`stationID`)
);

CREATE TABLE `Reservation` (
`reservation_num` int AUTO_INCREMENT,
`passenger` varchar(20) NOT NULL,
`route_name` varchar(20) NOT NULL,
`reservation_datetime` datetime,
`fare` float,
PRIMARY KEY (`reservation_num`),
FOREIGN KEY (`passenger`) REFERENCES `Customer`(`username`),
FOREIGN KEY (`route_name`) REFERENCES `Route`(`route_name`)
);

CREATE TABLE `Schedule` (
`departure_datetime` datetime,
`route_name` varchar(20) NOT NULL,
`train` int NOT NULL,
PRIMARY KEY (`departure_datetime`, `route_name`, `train`),
FOREIGN KEY (`route_name`) REFERENCES `Route`(`route_name`),
FOREIGN KEY (`train`) REFERENCES `Train`(`trainID`)
);

CREATE TABLE `Questions` (
`questionID` int AUTO_INCREMENT,
`question` varchar(280) UNIQUE,
`answer` varchar(280),
`response` boolean NOT NULL DEFAULT FALSE,
PRIMARY KEY (`questionID`)
);

INSERT INTO Administrator (ssn, firstName, lastName, username, password) VALUES
('143-21-2625', 'Master', 'Administrator', 'master_admin', 'masterPassword'),
('144-56-1810', 'Regular', 'Administrator', 'admin', 'password');

INSERT INTO Employee (ssn, firstName, lastName, username, password) VALUES
('148-09-6538', 'Josh', 'Gregory', 'jgregory', 'password'), ('147-98-4698', 'Stella', 'Bush', 'sbush', 'password'),
('142-15-0239', 'Angel', 'Glover', 'aglover', 'password'), ('144-28-7056', 'Levi', 'Hawkins', 'lhawkins', 'password'),
('138-30-6487', 'Terrence', 'Briggs', 'tbriggs', 'password'), ('151-10-8633', 'Winston', 'Romero', 'wromero', 'password'),
('143-01-3739', 'Latoya', 'Jordan', 'ljordan', 'password'), ('141-96-0354', 'Dora', 'Porter', 'dporter', 'password'),
('145-58-8962', 'Horace', 'Stevenson', 'hstevenson', 'password'), ('137-14-9308', 'Alfonso', 'Bell', 'abell', 'password'),
('158-07-1255', 'Greg', 'Stanley', 'gstanley', 'password'), ('157-26-3131', 'Kurt', 'Parks', 'kparks', 'password'),
('136-23-9314', 'Patsy', 'Salazar', 'psalazar', 'password'), ('143-13-2989', 'Dianne', 'Schmidt', 'dschmidt', 'password'),
('150-07-7008', 'Teresa', 'Palmer', 'tpalmer', 'password'), ('142-22-9214', 'Scott', 'Warner', 'swarner', 'password');

INSERT INTO Train (trainID, information) VALUES (1, 'Train A'), (2, "Train B"), (3, "Train C"), (4, "Train D"),
(5, "Train E"), (6, "Train F"), (7, "Train G"), (8, "Train H"), (9, "Train I"), (10, "Train J");

INSERT INTO Station (stationID, name, city, state) VALUES (1, "Station A", "Newark", "NJ"), (2, "Station B", "New Brunswick", "NJ"), 
(3, "Station C", "Atlantic City", "NJ"), (4, "Station D", "Camden", "NJ"), (5, "Station E", "Trenton", "NJ");

INSERT INTO WorksOn (ssn, trainID) VALUES ('148-09-6538', 1), ('147-98-4698', 2), ('142-15-0239', 3), ('144-28-7056', 4),
('138-30-6487', 5), ('151-10-8633', 6), ('143-01-3739', 7), ('141-96-0354', 8), ('145-58-8962', 9), ('137-14-9308', 10);

INSERT INTO WorksAt (ssn, stationID) VALUES ('158-07-1255', 1), ('157-26-3131', 2),
('136-23-9314', 3), ('143-13-2989', 4), ('150-07-7008', 5);

INSERT INTO Route (route_name, origin, destination, stops, travel_time, fare, clockwise) VALUES 
('Transit Aa 1', 1, 2, 1, 28 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Aa 2', 1, 3, 2, 130 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Aa 3', 1, 4, 3, 188 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Aa 4', 1, 5, 4, 244 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Aa 5', 1, 1, 5, 275 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ab 1', 1, 5, 1, 51 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ab 2', 1, 4, 2, 87 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ab 3', 1, 3, 3, 145 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ab 4', 1, 2, 4, 247 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ab 5', 1, 1, 5, 275 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ba 1', 2, 3, 1, 102 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ba 2', 2, 4, 2, 160 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ba 3', 2, 5, 3, 196 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ba 4', 2, 1, 4, 247 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ba 5', 2, 2, 5, 275 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Bb 1', 2, 1, 1, 28 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Bb 2', 2, 5, 2, 79 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Bb 3', 2, 4, 3, 115 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Bb 4', 2, 3, 4, 173 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Bb 5', 2, 2, 5, 275 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ca 1', 3, 4, 1, 58 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ca 2', 3, 5, 2, 94 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ca 3', 3, 1, 3, 145 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ca 4', 3, 2, 4, 173 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ca 5', 3, 3, 5, 275 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Cb 1', 3, 2, 1, 102 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Cb 2', 3, 1, 2, 130 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Cb 3', 3, 5, 3, 181 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Cb 4', 3, 4, 4, 217 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Cb 5', 3, 3, 5, 275 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Da 1', 4, 5, 1, 36 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Da 2', 4, 1, 2, 87 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Da 3', 4, 2, 3, 115 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Da 4', 4, 3, 4, 217 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Da 5', 4, 4, 5, 275 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Db 1', 4, 3, 1, 58 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Db 2', 4, 2, 2, 160 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Db 3', 4, 1, 3, 188 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Db 4', 4, 5, 4, 239 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Db 5', 4, 4, 5, 275 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Ea 1', 5, 1, 1, 51 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ea 2', 5, 2, 2, 79 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ea 3', 5, 3, 3, 181 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ea 4', 5, 4, 4, 239 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Ea 5', 5, 5, 5, 275 + (5 * (stops - 1)), stops * 5.0, TRUE),
('Transit Eb 1', 5, 4, 1, 36 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Eb 2', 5, 3, 2, 94 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Eb 3', 5, 2, 3, 196 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Eb 4', 5, 1, 4, 224 + (5 * (stops - 1)), stops * 5.0, FALSE),
('Transit Eb 5', 5, 5, 5, 275 + (5 * (stops - 1)), stops * 5.0, FALSE);

INSERT INTO Stops (origin, destination, travel_time) VALUES (1, 2, 28), (2, 3, 102), (3, 4, 58), 
(4, 5, 36), (5, 1, 51), (5, 4, 36), (4, 3, 58), (3, 2, 102), (2, 1, 28), (1, 5, 51);