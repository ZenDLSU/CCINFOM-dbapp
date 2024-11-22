CREATE DATABASE IF NOT EXISTS `group3s15`;
USE `group3s15`;

-- Drop Tables if they Exist
DROP TABLE IF EXISTS `user_accounts`;
DROP TABLE IF EXISTS `jobs`;
DROP TABLE IF EXISTS `branches`;
DROP TABLE IF EXISTS `companies`;
DROP TABLE IF EXISTS `job_position_REF`;

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
  CONSTRAINT `fk_branch_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `Company_Record_Management` (`company_ID`) ON DELETE SET NULL
);

-- job position reference table
CREATE TABLE `jobs_position_REF` (
  `position_ID` DECIMAL(10,0) NOT NULL,
  `position_name` VARCHAR(100) NOT NULL UNIQUE,
  `education` TEXT DEFAULT NULL,
  PRIMARY KEY (`position_ID`)
);

-- jobs table
CREATE TABLE `jobs` (
  `job_ID` DECIMAL(10,0) NOT NULL,
  `position_ID` DECIMAL(10,0) NOT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  `branch_ID` DECIMAL(10,0) DEFAULT NULL,
  PRIMARY KEY (`job_ID`),
  KEY `job_position_IX` (`position_ID`),
  KEY `job_company_IX` (`company_ID`),
  KEY `job_branch_IX` (`branch_ID`),
  CONSTRAINT `fk_job_position_ID` FOREIGN KEY (`position_ID`) REFERENCES `Job_Position_Reference` (`position_ID`) ON DELETE CASCADE,
  CONSTRAINT `fk_job_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `Company_Record_Management` (`company_ID`) ON DELETE SET NULL,
  CONSTRAINT `fk_job_branch_ID` FOREIGN KEY (`branch_ID`) REFERENCES `Branch_Record_Management` (`branch_ID`) ON DELETE SET NULL
);

-- job postings table
CREATE TABLE job_postings (
    posting_ID INT AUTO_INCREMENT PRIMARY KEY,   
    job_ID INT, table                                        
    poster_user_ID INT,                          
    posting_date DATETIME DEFAULT CURRENT_TIMESTAMP,  
    expiry_date DATETIME,                        
    status ENUM('Active', 'Expired', 'Closed') DEFAULT 'Active',
    FOREIGN KEY (job_ID) REFERENCES job_record_management(job_ID),
    FOREIGN KEY (poster_user_ID) REFERENCES user_account(user_ID)
);

-- job applications table
CREATE TABLE job_applications (
    application_ID INT AUTO_INCREMENT PRIMARY KEY,
    job_ID INT,
    user_ID INT,                       
    posting_ID INT,                   
    application_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Applied', 'Under Review', 'Accepted', 'Rejected') DEFAULT 'Applied',
    FOREIGN KEY (job_ID) REFERENCES jobs(job_ID),
    FOREIGN KEY (user_ID) REFERENCES user_account(user_ID),
    FOREIGN KEY (posting_ID) REFERENCES job_postings(posting_ID)
);


-- user accounts table
CREATE TABLE `user_accounts` (
  `account_ID` DECIMAL(10,0) NOT NULL,
  `first_name` VARCHAR(50) NOT NULL,
  `last_name` VARCHAR(50) NOT NULL,
  `contact_no` TEXT DEFAULT NULL,
  `email` VARCHAR(100) NOT NULL,
  `home_address` TEXT DEFAULT NULL,
  `birthday` DATE DEFAULT NULL,
  `education` TEXT DEFAULT NULL,
  `years_of_experience` TEXT DEFAULT NULL,
  `primary_language` TEXT NOT NULL,
  `secondary_language` TEXT DEFAULT NULL,
  `job_ID` DECIMAL(10,0) DEFAULT NULL,
  `company_ID` DECIMAL(10,0) DEFAULT NULL,
  `user_password` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`account_ID`),
  UNIQUE KEY `UA_email_UK` (`email`),
  KEY `UA_name_IX` (`last_name`, `first_name`),
  CONSTRAINT `fk_job_ID` FOREIGN KEY (`job_ID`) REFERENCES `Job_Record_Management` (`job_ID`) ON DELETE SET NULL,
  CONSTRAINT `fk_company_ID` FOREIGN KEY (`company_ID`) REFERENCES `Company_Record_Management` (`company_ID`) ON DELETE SET NULL
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

INSERT INTO `job_positions_REF` (position_ID, position_name, education)
VALUES
('0001', 'Virtual YouTuber', 'Bachelor in Performing Arts'),
('0002', 'Artist', 'Bachelor in Fine Arts'),
('0003', 'Marketing Manager', 'Master in Marketing'),
('0004', 'Environmental Analyst', 'Bachelor in Environmental Science'),
('0005', 'Performing Arts Lead', 'Bachelor in Performing Arts'),
('0006', 'Culinary Specialist', 'Bachelor in Culinary Arts'),
('0007', 'Apprentice', 'High School Diploma'),
('0008', 'Brand Strategist', 'Bachelor in Marketing'),
('0009', 'Agriculture Consultant', 'Bachelor in Agriculture'),
('0010', 'Manager', 'Master in Business Administration');


INSERT INTO `jobs` (job_ID, position_ID, company_ID, branch_ID)
VALUES
('0001', '0001', '0001', '0001'),
('0002', '0002', '0001', '0002'),
('0003', '0003', '0004', '0004'),
('0004', '0004', '0004', '0005'),
('0005', '0005', '0001', '0001'),
('0006', '0006', '0005', '0005'),
('0007', '0007', '0003', '0003'),
('0008', '0008', '0004', '0004'),
('0009', '0009', '0001', '0002'),
('0010', '0010', '0001', '0001');


INSERT INTO `user_accounts` 
(account_ID, first_name, last_name, contact_no, email, home_address, birthday, years_of_experience, education, primary_language, secondary_language, job_ID, company_ID, user_password) 
VALUES
('0001', 'Shirakami', 'Fubuki', '123-456-7890', 'fubuki@hololive.tv', 'Tokyo, Japan', '1998-10-05', '5 years', 'Bachelor in Performing Arts', 'Japanese', 'English', '0001', '0001', '123456'),
('0002', 'Aki', 'Rosa', '123-456-7891', 'aki@hololive.tv', 'Tokyo, Japan', '1992-07-01', '3 years', 'Bachelor in Fine Arts', 'Japanese', 'English', '0002', '0001', '123456'),
('0003', 'Sakura', 'Miko', '123-456-7892', 'miko@hololive.tv', 'Osaka, Japan', '1996-04-22', '4 years', 'Bachelor in Marketing', 'Japanese', 'English', '0007', '0001', '123456'),
('0004', 'Oozora', 'Subaru', '123-456-7893', 'subaru@hololive.tv', 'Chiba, Japan', '1996-12-03', '4 years', 'Bachelor in Marketing', 'Japanese', 'English', '0004', '0001', '123456'),
('0005', 'Hoshimachi', 'Suisei', '123-456-7894', 'suisei@hololive.tv', 'Nagoya, Japan', '1996-03-22', '3 years', 'Bachelor in Performing Arts', 'Japanese', 'English', '0005', '0001', '123456'),
('0006', 'Murasaki', 'Shion', '123-456-7895', 'shion@hololive.tv', 'Tokyo, Japan', '2000-05-24', '2 years', 'Bachelor in Fine Arts', 'Japanese', 'English', '0006', '0001', '123456'),
('0007', 'Yozora', 'Mel', '123-456-7896', 'mel@hololive.tv', 'Fukuoka, Japan', '1996-03-02', '3 years', 'Bachelor in Fine Arts', 'Japanese', 'English', '0002', '0001', '123456'),
('0008', 'Amane', 'Kanata', '123-456-7897', 'kanata@hololive.tv', 'Sapporo, Japan', '1999-10-02', '3 years', 'Bachelor in Performing Arts', 'Japanese', 'English', '0003', '0001', '123456'),
('0009', 'Tsunomaki', 'Watame', '123-456-7898', 'watame@hololive.tv', 'Ibaraki, Japan', '1998-08-03', '4 years', 'Bachelor in Performing Arts', 'Japanese', 'English', '0001', '0002', '123456'),
('0010', 'Houshou', 'Marine', '123-456-7899', 'marine@hololive.tv', 'Okinawa, Japan', '1997-08-30', '3 years', 'Bachelor in Performing Arts', 'Japanese', 'English', '0005', '0002', '123456'),
('0011', 'Nijisanji', 'Luca', '123-456-7800', 'luca@nijisanji.jp', 'Osaka, Japan', '1997-07-23', '2 years', 'Bachelor in Business Administration', 'Japanese', 'English', '0010', '0002', '123456'),
('0012', 'Ina', 'Shirin', '123-456-7801', 'ina@hololive.tv', 'Tokyo, Japan', '1996-05-10', '4 years', 'Master in Marketing', 'Japanese', 'English', '0008', '0003', '123456'),
('0013', 'Mori', 'Calliope', '123-456-7802', 'calliope@hololive.tv', 'Chiba, Japan', '1998-03-04', '5 years', 'Bachelor in Performing Arts', 'Japanese', 'English', '0002', '0005', '123456'),
('0014', 'Ryugu', 'Finana', '123-456-7803', 'finana@nijisanji.jp', 'Tokyo, Japan', '1999-02-12', '2 years', 'Bachelor in Fine Arts', 'Japanese', 'English', '0009', '0002', '123456'),
('0015', 'Yume', 'Saitou', '123-456-7804', 'saitou@vshojo.com', 'Kyoto, Japan', '2000-06-07', '1 year', 'Bachelor in Marketing', 'Japanese', 'English', '0001', '0005', '123456');
