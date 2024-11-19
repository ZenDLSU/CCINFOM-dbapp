-- Create Database
CREATE DATABASE IF NOT EXISTS `group3s15`;
USE `group3s15`;

-- User Account Record Management Table
DROP TABLE IF EXISTS `UserAccount_Record_Management`;
CREATE TABLE `UserAccount_Record_Management` (
  `account_ID` DECIMAL(10,0) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `contact_no` TEXT DEFAULT NULL,
  `email` VARCHAR(100) NOT NULL,
  `home_address` TEXT DEFAULT NULL,
  `birthday` DATE DEFAULT NULL,
  `years_of_experience` TEXT DEFAULT NULL,
  `education` TEXT DEFAULT NULL,
  `primary_language` TEXT NOT NULL,
  `secondary_language` TEXT DEFAULT NULL,
  `job_ID` DECIMAL(10,0) DEFAULT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  PRIMARY KEY (`account_ID`),
  UNIQUE KEY `UA_email_UK` (`email`),
  KEY `UA_name_IX` (`last_name`, `first_name`),
  CONSTRAINT `fk_job_ID` FOREIGN KEY (`job_ID`) REFERENCES `Job_Record_Management` (`job_ID`) ON DELETE SET NULL,
  CONSTRAINT `fk_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `Company_Record_Management` (`company_ID`) ON DELETE SET NULL
);

-- Company Record Management Table
DROP TABLE IF EXISTS `Company_Record_Management`;
CREATE TABLE `Company_Record_Management` (
  `company_ID` DECIMAL(10,0) NOT NULL,
  `company_name` VARCHAR(100) NOT NULL,
  `contact_info` TEXT DEFAULT NULL,
  `company_manager` DECIMAL(10,0) NOT NULL,
  `main_location` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`company_ID`),
  UNIQUE KEY `company_name_UK` (`company_name`)
);

-- Branch Record Management Table
DROP TABLE IF EXISTS `Branch_Record_Management`;
CREATE TABLE `Branch_Record_Management` (
  `branch_ID` DECIMAL(10,0) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `contact_info` TEXT DEFAULT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  PRIMARY KEY (`branch_ID`),
  KEY `branch_company_IX` (`company_ID`),
  CONSTRAINT `fk_branch_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `Company_Record_Management` (`company_ID`) ON DELETE SET NULL
);

-- Job Record Management Table
DROP TABLE IF EXISTS `Job_Record_Management`;
CREATE TABLE `Job_Record_Management` (
  `job_ID` DECIMAL(10,0) NOT NULL,
  `position_name` VARCHAR(100) NOT NULL,
  `skills` TEXT DEFAULT NULL,
  `education` TEXT DEFAULT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  `branch_ID` DECIMAL(10,0) DEFAULT NULL,
  PRIMARY KEY (`job_ID`),
  KEY `job_company_IX` (`company_ID`),
  KEY `job_branch_IX` (`branch_ID`),
  CONSTRAINT `fk_job_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `Company_Record_Management` (`company_ID`) ON DELETE SET NULL,
  CONSTRAINT `fk_job_branch_ID` FOREIGN KEY (`branch_ID`) REFERENCES `Branch_Record_Management` (`branch_ID`) ON DELETE SET NULL
);
