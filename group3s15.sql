CREATE DATABASE IF NOT EXISTS `group3s15`;
USE `group3s15`;

-- Drop Tables if they Exist
DROP TABLE IF EXISTS `job_applications`;
DROP TABLE IF EXISTS `job_postings`;
DROP TABLE IF EXISTS `user_accounts`;
DROP TABLE IF EXISTS `jobs`;
DROP TABLE IF EXISTS `branches`;
DROP TABLE IF EXISTS `companies`;
DROP TABLE IF EXISTS `REF_job_position`;
-- companies table
CREATE TABLE `companies` (
  `company_ID` DECIMAL(10,0) NOT NULL,
  `company_name` VARCHAR(100) NOT NULL,
  `contact_no` TEXT DEFAULT NULL,
  `company_manager` DECIMAL(10,0) NOT NULL,
  `main_location` VARCHAR(100) NOT NULL,
  `company_password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`company_ID`),
  UNIQUE KEY `company_name_UK` (`company_name`)
);

-- branches table
CREATE TABLE `branches` (
  `branch_ID` DECIMAL(10,0) NOT NULL,
  `location` VARCHAR(100) NOT NULL,
  `contact_no` TEXT DEFAULT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  PRIMARY KEY (`branch_ID`),
  KEY `branch_company_IX` (`company_ID`),
  CONSTRAINT `fk_branch_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `companies` (`company_ID`) ON DELETE SET NULL
);

-- job position reference table
CREATE TABLE `REF_job_position` (
  `position_ID` DECIMAL(10,0) NOT NULL,
  `position_name` VARCHAR(100) NOT NULL UNIQUE,
  PRIMARY KEY (`position_ID`)
);

-- jobs table
CREATE TABLE `jobs` (
  `job_ID` DECIMAL(10,0) NOT NULL,
  `position_ID` DECIMAL(10,0) NOT NULL,
  `education` ENUM ('None', 'High School', 'Bachelors', 'Masters','PhD') default 'None',
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  `branch_ID` DECIMAL(10,0) DEFAULT NULL,
  PRIMARY KEY (`job_ID`),
  KEY `job_position_IX` (`position_ID`),
  KEY `job_company_IX` (`company_ID`),
  KEY `job_branch_IX` (`branch_ID`),
  CONSTRAINT `fk_job_position_ID` FOREIGN KEY (`position_ID`) REFERENCES `REF_job_position` (`position_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_job_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `companies` (`company_ID`) ON DELETE SET NULL,
  CONSTRAINT `fk_job_branch_ID` FOREIGN KEY (`branch_ID`) REFERENCES `branches` (`branch_ID`) ON DELETE SET NULL
);
CREATE TABLE `user_accounts` (
  `account_ID` DECIMAL(10,0) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `contact_no` TEXT DEFAULT NULL,
  `email` VARCHAR(100) NOT NULL,
  `home_address` TEXT DEFAULT NULL,
  `birthday` DATE DEFAULT NULL,
  `education` TEXT DEFAULT NULL,
  `years_of_experience` DECIMAL(10,0) DEFAULT NULL,
  `primary_language` TEXT NOT NULL,
  `job_ID` DECIMAL(10,0) DEFAULT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  `user_password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`account_ID`),
  UNIQUE KEY `UA_email_UK` (`email`),
  KEY `UA_name_IX` (`last_name`, `first_name`),
  CONSTRAINT `fk_job_ID` FOREIGN KEY (`job_ID`) REFERENCES `jobs` (`job_ID`) ON DELETE SET NULL,
  CONSTRAINT `fk_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `companies` (`company_ID`) ON DELETE SET NULL
);
-- job postings table
CREATE TABLE job_postings (
    posting_ID INT AUTO_INCREMENT PRIMARY KEY,   
    `job_ID` DECIMAL(10,0) NOT NULL,                                 
    poster_user_ID DECIMAL(10,0),                          
    posting_date DATETIME DEFAULT CURRENT_TIMESTAMP,  
    expiry_date DATETIME,                        
    `status` ENUM('Active', 'Expired', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (job_ID) REFERENCES jobs(job_ID),
    FOREIGN KEY (poster_user_ID) REFERENCES `user_accounts`(account_ID)
);

-- job applications table
CREATE TABLE job_applications (
    application_ID INT AUTO_INCREMENT PRIMARY KEY,
    `job_ID` DECIMAL(10,0) NOT NULL,
	`account_ID` DECIMAL(10,0) NOT NULL,                      
    posting_ID INT,                   
    application_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Applied', 'Under Review', 'Accepted', 'Rejected') DEFAULT 'Applied',
    FOREIGN KEY (job_ID) REFERENCES jobs(job_ID),
    FOREIGN KEY (account_ID) REFERENCES user_accounts(account_ID),
    FOREIGN KEY (posting_ID) REFERENCES job_postings(posting_ID)
);




INSERT INTO `companies` (company_ID, company_name, contact_no, company_manager, main_location, company_password) 
VALUES
('0001', 'Hololive Production', 'contact@hololive.tv', '0001', 'Tokyo, Japan', '123456'),
('0002', 'Nijisanji', 'contact@nijisanji.jp', '0002', 'Tokyo, Japan', '123456'),
('0003', 'Vshojo', 'contact@vshojo.com', '0003', 'Los Angeles, USA', '123456'),
('0004', 'PhaseALIAS', 'contact@phase-alia.com', '0004', 'Taipei, Taiwan', '123456'),
('0005', '774 inc.', 'contact@774inc.jp', '0005', 'Tokyo, Japan', '123456');

INSERT INTO `branches` (branch_ID, location, contact_no, company_ID)
VALUES
('0001', 'Tokyo Branch', 'contact@hololive.tv', '0001'),
('0002', 'Osaka Branch', 'contact@nijisanji.jp', '0002'),
('0003', 'Los Angeles Branch', 'contact@vshojo.com', '0003'),
('0004', 'Taipei Branch', 'contact@phase-alia.com', '0004'),
('0005', 'Kyoto Branch', 'contact@774inc.jp', '0005'),
('0006', 'Nagoya Branch', 'contact@hololive.tv', '0001'),
('0007', 'New York Branch', 'contact@nijisanji.jp', '0002');

INSERT INTO `REF_job_position` (position_ID, position_name)
VALUES
('0001', 'Virtual YouTuber'),
('0002', 'Artist'),
('0003', 'Marketing Manager'),
('0004', 'Environmental Analyst'),
('0005', 'Performing Arts Lead'),
('0006', 'Culinary Specialist'),
('0007', 'Apprentice'),
('0008', 'Brand Strategist'),
('0009', 'Agriculture Consultant'),
('0010', 'Manager');


INSERT INTO `jobs` (job_ID, position_ID, education, company_ID, branch_ID)
VALUES
('0001', '0001','Bachelors','0001', '0001'),
('0002', '0002','Bachelors', '0001', '0002'),
('0003', '0003','Bachelors', '0004', '0004'),
('0004', '0004','Bachelors', '0004', '0005'),
('0005', '0005','Bachelors', '0001', '0001'),
('0006', '0006','Bachelors', '0005', '0005'),
('0007', '0007','Bachelors', '0003', '0003'),
('0008', '0008','Bachelors', '0004', '0004'),
('0009', '0009','Bachelors', '0001', '0002'),
('0010', '0010','Bachelors', '0001', '0001');


INSERT INTO `user_accounts` 
(account_ID, first_name, last_name, contact_no, email, home_address, birthday, years_of_experience, education, primary_language, job_ID, company_ID, user_password) 
VALUES
('0001', 'Shirakami', 'Fubuki', '123-456-7890', 'fubuki@hololive.tv', 'Tokyo, Japan', '1998-10-05', '5', 'Bachelor in Performing Arts', 'Japanese', '0001', '0001', '123456'),
('0002', 'Aki', 'Rosa', '123-456-7891', 'aki@hololive.tv', 'Tokyo, Japan', '1992-07-01', '3', 'Bachelor in Fine Arts', 'Japanese', '0002', '0001', '123456'),
('0003', 'Sakura', 'Miko', '123-456-7892', 'miko@hololive.tv', 'Osaka, Japan', '1996-04-22', '4', 'Bachelor in Marketing', 'Japanese', '0007', '0001', '123456'),
('0004', 'Oozora', 'Subaru', '123-456-7893', 'subaru@hololive.tv', 'Chiba, Japan', '1996-12-03', '4', 'Bachelor in Marketing', 'Japanese', '0004', '0001', '123456'),
('0005', 'Hoshimachi', 'Suisei', '123-456-7894', 'suisei@hololive.tv', 'Nagoya, Japan', '1996-03-22', '3', 'Bachelor in Performing Arts', 'Japanese', '0005', '0001', '123456'),
('0006', 'Murasaki', 'Shion', '123-456-7895', 'shion@hololive.tv', 'Tokyo, Japan', '2000-05-24', '2', 'Bachelor in Fine Arts', 'Japanese', '0006', '0001', '123456'),
('0007', 'Yozora', 'Mel', '123-456-7896', 'mel@hololive.tv', 'Fukuoka, Japan', '1996-03-02', '3', 'Bachelor in Fine Arts', 'Japanese', '0002', '0001', '123456'),
('0008', 'Amane', 'Kanata', '123-456-7897', 'kanata@hololive.tv', 'Sapporo, Japan', '1999-10-02', '3', 'Bachelor in Performing Arts', 'Japanese', '0003', '0001', '123456'),
('0009', 'Tsunomaki', 'Watame', '123-456-7898', 'watame@hololive.tv', 'Ibaraki, Japan', '1998-08-03', '4', 'Bachelor in Performing Arts', 'Japanese', '0001', '0002', '123456'),
('0010', 'Houshou', 'Marine', '123-456-7899', 'marine@hololive.tv', 'Okinawa, Japan', '1997-08-30', '3', 'Bachelor in Performing Arts', 'Japanese', '0005', '0002', '123456'),
('0011', 'Nijisanji', 'Luca', '123-456-7800', 'luca@nijisanji.jp', 'Osaka, Japan', '1997-07-23', '2', 'Bachelor in Business Administration', 'Japanese', '0010', '0002', '123456'),
('0012', 'Ina', 'Shirin', '123-456-7801', 'ina@hololive.tv', 'Tokyo, Japan', '1996-05-10', '4', 'Bachelor in Marketing', 'Japanese', '0008', '0003', '123456'),
('0013', 'Mori', 'Calliope', '123-456-7802', 'calliope@hololive.tv', 'Chiba, Japan', '1998-03-04', '5', 'Bachelor in Performing Arts', 'Japanese', '0002', '0005', '123456'),
('0014', 'Ryugu', 'Finana', '123-456-7803', 'finana@nijisanji.jp', 'Tokyo, Japan', '1999-02-12', '2', 'Bachelor in Fine Arts', 'Japanese', '0009', '0002', '123456'),
('0015', 'Yume', 'Saitou', '123-456-7804', 'saitou@vshojo.com', 'Kyoto, Japan', '2000-06-07', '1', 'Bachelor in Marketing', 'Japanese', '0001', '0005', '123456');

INSERT INTO `job_applications` (application_ID, job_ID, account_ID, posting_ID, application_date, status) 
VALUES
('0001', '0001', '0001', '0001', '2020-05-27', 'Under Review'),
('0002', '0002', '0013', '0002', '2020-07-24', 'Under Review'),
('0003', '0001', '0009', '0003', '2020-12-28', 'Rejected'),
('0004', '0004', '0004', '0004', '2021-03-12', 'Applied'),
('0005', '0008', '0012', '0005', '2021-06-15', 'Applied'),
('0006', '0007', '0003', '0006', '2022-01-19', 'Accepted'),
('0007', '0003', '0008', '0007', '2022-02-18', 'Accepted'),
('0008', '0002', '0007', '0008', '2022-05-04', 'Under Review'),
('0009', '0005', '0005', '0009', '2022-08-02', 'Accepted'),
('0010', '0005', '0010', '0010', '2022-10-05', 'Rejected'),
('0011', '0006', '0006', '0011', '2022-11-07', 'Accepted'),
('0012', '0010', '0011', '0012', '2023-04-20', 'Under Review'),
('0013', '0001', '0015', '0013', '2023-04-22', 'Rejected'),
('0014', '0009', '0014', '0014', '2023-09-29', 'Under Review'),
('0015', '0002', '0002', '0015', '2023-10-08', 'Applied');
