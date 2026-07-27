/*
======================================================================
                     CREATE DATABASE AND SCHEMAS
======================================================================

Script Purpose:
---------------
This script creates a new database named 'DataWarehouse'.

- creating the database, the script creates three schemas:
    • bronze
    • silver
    • gold
*/
use master;
GO

--CREATE THE DATABASE

create database databasewarehouse;

--USE THE DATABASE

use databasewarehouse;
GO

--CREATE SCHEMA'S

CREATE SCHEMA Bronze;
GO

create schema Silver;
GO

create schema Gold;
GO
