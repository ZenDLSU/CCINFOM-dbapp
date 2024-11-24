DROP TABLE IF EXISTS `user_job_applications`;
DROP TABLE IF EXISTS `active_jobs`;
DROP TABLE IF EXISTS `company_employees`;
DROP TABLE IF EXISTS `company_branches`;
DROP TABLE IF EXISTS `company_accounts`;
DROP TABLE IF EXISTS `user_accounts`;
DROP TABLE IF EXISTS `REF_job_titles`; 

CREATE TABLE `REF_job_titles` (
    job_id INT PRIMARY KEY AUTO_INCREMENT,
    job_title VARCHAR(255) NOT NULL,
    job_description TEXT
);

CREATE TABLE `user_accounts` (
  `account_ID` BIGINT NOT NULL,
  `first_name` VARCHAR(45) NOT NULL,
  `last_name` VARCHAR(45) NOT NULL,
  `age` INT NOT NULL,
  `contact_num` BIGINT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `home_address` VARCHAR(45) DEFAULT NULL,
  `birthday` DATE DEFAULT NULL,
  `primary_language` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `years_of_experience` INT DEFAULT 0 NOT NULL,
  `highest_education` ENUM('High School', 'Associate', 'Bachelor', 'Master', 'Doctorate', 'Other') NOT NULL,
  `date_created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`account_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `company_accounts` (
  `company_ID` INT NOT NULL,
  `company_name` VARCHAR(45) NOT NULL,
  `contact_number` BIGINT NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `main_address` VARCHAR(45) NOT NULL,
  `password` VARCHAR(45) NOT NULL,
  `date_created` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`company_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `company_branches` (
  `branch_ID` INT NOT NULL AUTO_INCREMENT,
  `address` VARCHAR(45) NOT NULL,
  `company_ID` INT NOT NULL,
  PRIMARY KEY (`branch_ID`),
  FOREIGN KEY (`company_ID`) REFERENCES `company_accounts`(`company_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `active_jobs` (
    job_opening_id INT PRIMARY KEY AUTO_INCREMENT,
    job_id INT NOT NULL, 
    company_id INT,
    location VARCHAR(255),
    salary DECIMAL(10, 2),
    is_filled BOOLEAN DEFAULT FALSE,
    posting_date DATE,
    closing_date DATE,
    FOREIGN KEY (job_id) REFERENCES REF_job_titles(job_id)
);

CREATE TABLE `user_job_applications` (
  `application_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `account_ID` BIGINT NOT NULL,
  `job_id` INT NOT NULL,
  `company_ID` INT NOT NULL,
  `application_date` DATE NOT NULL,
  `application_status` ENUM('Pending', 'Accepted', 'Rejected') NOT NULL,
  FOREIGN KEY (`account_ID`) REFERENCES `user_accounts`(`account_ID`),
  FOREIGN KEY (`job_id`) REFERENCES `REF_job_titles`(`job_id`),
  FOREIGN KEY (`company_ID`) REFERENCES `company_accounts`(`company_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

CREATE TABLE `company_employees` (
  `employee_id` BIGINT AUTO_INCREMENT PRIMARY KEY,
  `account_ID` BIGINT NOT NULL,
  `company_ID` INT NOT NULL,
  `date_hired` TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (`account_ID`) REFERENCES `user_accounts`(`account_ID`),
  FOREIGN KEY (`company_ID`) REFERENCES `company_accounts`(`company_ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

INSERT INTO `REF_job_titles` (job_title, job_description) VALUES
('Software Engineer', 'Develop and maintain software applications.'),
('Data Scientist', 'Analyze and interpret complex data to aid decision-making.'),
('Digital Marketer', 'Plan and execute online marketing strategies.'),
('Project Manager', 'Oversee projects and ensure timely completion.'),
('Graphic Designer', 'Create visual content for digital and print media.'),
('Accountant', 'Prepare and manage financial records and reports.'),
('HR Specialist', 'Handle recruitment, training, and employee relations.'),
('Web Developer', 'Design and maintain websites.'),
('UX Designer', 'Enhance user experiences through design and research.'),
('Mobile Developer', 'Develop mobile applications for iOS and Android.'),
('Network Engineer', 'Manage and maintain network infrastructure.'),
('Technical Writer', 'Create technical documentation and manuals.'),
('AI Specialist', 'Develop and integrate AI technologies.'),
('Content Writer', 'Produce engaging written content for various media.'),
('Sales Executive', 'Manage sales and build client relationships.'),
('Customer Support', 'Assist customers with inquiries and issues.'),
('Operations Manager', 'Streamline and oversee business operations.'),
('Cybersecurity Analyst', 'Protect systems from cyber threats.'),
('Financial Analyst', 'Evaluate financial data to advise decisions.'),
('Supply Chain Manager', 'Oversee supply chain and logistics operations.');

INSERT INTO `user_accounts` 
(account_ID, first_name, last_name, age, contact_num, email, home_address, birthday, primary_language, password, years_of_experience, highest_education, date_created) 
VALUES
(1, 'John', 'Doe', 29, 9876543210, 'johndoe@gmail.com', '123 Elm St.', '1995-06-15', 'English', 'password123', 5, 'Bachelor', '2024-01-01'),
(2, 'Jane', 'Smith', 35, 9123456789, 'janesmith@hotmail.com', '456 Maple Ave.', '1989-04-10', 'English', 'securepass', 10, 'Master', '2024-01-02'),
(3, 'Robert', 'Brown', 42, 9871122334, 'robert.brown@yahoo.com', '789 Pine Rd.', '1982-12-01', 'English', 'mypassword', 18, 'Bachelor', '2024-01-03'),
(4, 'Emily', 'Johnson', 27, 9823456712, 'emilyj@gmail.com', '321 Oak Blvd.', '1997-11-21', 'English', 'emily123', 4, 'Bachelor', '2024-01-04'),
(5, 'Michael', 'Lee', 31, 9812345678, 'mike.lee@outlook.com', '654 Spruce St.', '1993-05-25', 'English', 'mikepassword', 7, 'Master', '2024-01-05'),
(6, 'Sarah', 'Williams', 38, 9809876543, 'sarahw@yahoo.com', '987 Walnut Rd.', '1986-03-19', 'English', 'sarahsecure', 14, 'Bachelor', '2024-01-06'),
(7, 'David', 'Taylor', 45, 9797654321, 'david.taylor@live.com', '159 Cherry Ln.', '1979-08-11', 'English', 'davidpw', 20, 'Master', '2024-01-07'),
(8, 'Sophia', 'Martinez', 24, 9781234567, 'sophiamartinez@gmail.com', '753 Birch Way', '2000-10-03', 'English', 'sophiapw', 2, 'Bachelor', '2024-01-08'),
(9, 'James', 'Garcia', 37, 9776543210, 'james.garcia@hotmail.com', '951 Cedar Ct.', '1987-07-15', 'English', 'james123', 12, 'Bachelor', '2024-01-09'),
(10, 'Linda', 'Hernandez', 33, 9763456789, 'linda.hernandez@aol.com', '852 Fir Rd.', '1991-09-25', 'English', 'lindapass', 8, 'Master', '2024-01-10'),
(11, 'Andrew', 'Lopez', 30, 9751234567, 'andrew.lopez@gmail.com', '963 Redwood Blvd.', '1994-01-14', 'English', 'andrewpw', 6, 'Bachelor', '2024-01-11'),
(12, 'Elizabeth', 'Clark', 26, 9749876543, 'elizabeth.clark@yahoo.com', '741 Aspen Ave.', '1998-05-06', 'English', 'elizabethsecure', 3, 'Bachelor', '2024-01-12'),
(13, 'Christopher', 'Rodriguez', 39, 9736543210, 'chris.rodriguez@hotmail.com', '632 Maple Dr.', '1985-04-20', 'English', 'chrispw', 15, 'Bachelor', '2024-01-13'),
(14, 'Emma', 'King', 28, 9723456789, 'emma.king@outlook.com', '521 Willow Ct.', '1996-02-12', 'English', 'emmapass', 5, 'Master', '2024-01-14'),
(15, 'Ryan', 'Walker', 41, 9711234567, 'ryan.walker@gmail.com', '412 Poplar Rd.', '1983-06-07', 'English', 'ryansecure', 16, 'Master', '2024-01-15'),
(16, 'Mia', 'Perez', 23, 9709876543, 'mia.perez@hotmail.com', '357 Palm St.', '2001-08-19', 'English', 'miapassword', 1, 'Bachelor', '2024-01-16'),
(17, 'Ethan', 'Scott', 36, 9697654321, 'ethan.scott@yahoo.com', '159 Sycamore Ln.', '1988-11-30', 'English', 'ethanpw', 11, 'Bachelor', '2024-01-17'),
(18, 'Olivia', 'Hill', 29, 9681234567, 'olivia.hill@live.com', '753 Cypress Ave.', '1995-09-10', 'English', 'oliviapass', 6, 'Bachelor', '2024-01-18'),
(19, 'Lucas', 'Adams', 32, 9676543210, 'lucas.adams@gmail.com', '951 Mahogany Ct.', '1992-04-22', 'English', 'lucaspw', 9, 'Bachelor', '2024-01-19'),
(20, 'Chloe', 'Baker', 27, 9663456789, 'chloe.baker@outlook.com', '852 Chestnut Rd.', '1997-10-15', 'English', 'chloepass', 4, 'Master', '2024-01-20');

INSERT INTO `company_accounts` (company_ID, company_name, contact_number, email, main_address, password, date_created) VALUES
(1, 'Tech Innovations', 9876543211, 'contact@techinnovations.com', '123 Silicon Blvd.', 'compassword1', '2024-01-01'),
(2, 'Creative Designs Co.', 9123345678, 'info@creativedesigns.com', '456 Art Lane', 'securecomp', '2024-01-02'),
(3, 'Global Solutions', 9876654432, 'hello@globalsolutions.net', '789 Industry Ave.', 'glopass', '2024-01-03'),
(4, 'Future Builders', 9823456778, 'info@futurebuilders.com', '321 Modern Rd.', 'builderpass', '2024-01-04'),
(5, 'AI Pioneers', 9812341234, 'contact@aipioneers.ai', '654 Digital Blvd.', 'aipass', '2024-01-05'),
(6, 'HealthFirst Solutions', 9123345699, 'info@healthfirst.com', '123 Wellness Blvd.', 'healthpass', '2024-01-06'),
(7, 'EcoGreen Industries', 9876654321, 'contact@ecogreen.com', '789 Sustainability Ave.', 'ecogreenpass', '2024-01-07'),
(8, 'NextGen Robotics', 9823456790, 'support@nextgenrobotics.ai', '456 Automation Way', 'nextgenpass', '2024-01-08'),
(9, 'Bright Minds Academy', 9812341299, 'hello@brightminds.edu', '321 Education Rd.', 'brightminds123', '2024-01-09'),
(10, 'Urban Developers Ltd.', 9809876542, 'contact@urbandevelopers.com', '654 City Center Blvd.', 'urbanpassword', '2024-01-10'),
(11, 'Quantum Analytics', 9871122390, 'info@quantumanalytics.com', '159 Data Science Lane', 'quantum123', '2024-01-11'),
(12, 'Foodie Delight Co.', 9797654332, 'support@foodiedelight.com', '753 Gourmet St.', 'foodiepass', '2024-01-12'),
(13, 'Visionary Tech', 9781234598, 'contact@visionarytech.com', '951 Innovation Blvd.', 'visiontechpass', '2024-01-13'),
(14, 'Prime Logistics', 9776543299, 'info@primelogistics.com', '852 Logistics Dr.', 'primelogpass', '2024-01-14'),
(15, 'Horizon Entertainment', 9763456790, 'contact@horizonentertainment.com', '741 Broadway Ave.', 'horizonpass', '2024-01-15'),
(16, 'Stellar Finance Inc.', 9751234598, 'info@stellarfinance.com', '632 Wealthy Lane', 'stellarfins', '2024-01-16'),
(17, 'CloudWorks', 9749876500, 'hello@cloudworks.com', '321 Cloud Blvd.', 'cloudsecure', '2024-01-17'),
(18, 'FutureMed', 9736543200, 'support@futuremed.com', '521 Healthcare Rd.', 'futuremedpass', '2024-01-18'),
(19, 'NextStep Mobility', 9723456791, 'contact@nextstepmobility.com', '412 Transport Ave.', 'nextstep123', '2024-01-19'),
(20, 'InnovateEdu', 9711234599, 'info@innovateedu.com', '357 Learning St.', 'innovate123', '2024-01-20');

INSERT INTO `company_branches` (address, company_ID) VALUES
('Suite 101, 123 Silicon Blvd.', 1),
('456 Art Lane, Floor 3', 2),
('789 Industry Ave., Building A', 3),
('321 Modern Rd., Tower 2', 4),
('654 Digital Blvd., Block B', 5),
('100 Future Ave., Wing C', 1),
('800 Tech Park, Building D', 2),
('450 Global Rd., HQ', 3),
('910 Builder Blvd., Annex', 4),
('640 AI Plaza, Sector 1', 5),
('78 Innovation Lane, Wing A', 1),
('99 Design District, Suite 8', 2),
('400 Solutions St., Floor 5', 3),
('701 Vision Rd., Block D', 4),
('300 Neural Drive, Suite 4', 5),
('321 Future City, Tower B', 1),
('120 Creative Park, Wing C', 2),
('500 Corporate Ave., HQ', 3),
('830 Builder Park, Annex 2', 4),
('945 AI Center, Innovation Wing', 5);

INSERT INTO `active_jobs` (job_id, company_id, location, salary, is_filled, posting_date, closing_date) VALUES
(1, 1, '123 Silicon Blvd., City A', 85000.00, FALSE, '2023-12-01', '2024-01-15'),
(2, 2, '456 Art Lane, City B', 65000.00, FALSE, '2023-12-05', '2024-01-20'),
(3, 3, '789 Industry Ave., City C', 75000.00, FALSE, '2023-12-10', '2024-01-25'),
(4, 4, '321 Modern Rd., City D', 90000.00, FALSE, '2023-12-15', '2024-01-30'),
(5, 5, '654 Digital Blvd., City E', 120000.00, FALSE, '2023-12-20', '2024-02-05'),
(6, 1, '100 Future Ave., City F', 70000.00, TRUE, '2023-11-01', '2023-12-10'),
(7, 2, '800 Tech Park, City G', 60000.00, FALSE, '2023-12-01', '2024-01-05'),
(8, 3, '450 Global Rd., City H', 80000.00, FALSE, '2023-12-10', '2024-01-15'),
(9, 4, '910 Builder Blvd., City I', 95000.00, TRUE, '2023-10-20', '2023-12-01'),
(10, 5, '640 AI Plaza, City J', 115000.00, FALSE, '2023-12-18', '2024-01-30'),
(11, 1, '78 Innovation Lane, City K', 85000.00, FALSE, '2023-12-22', '2024-02-01'),
(12, 2, '99 Design District, City L', 70000.00, FALSE, '2023-12-25', '2024-02-10'),
(13, 3, '400 Solutions St., City M', 75000.00, TRUE, '2023-11-10', '2023-12-15'),
(14, 4, '701 Vision Rd., City N', 95000.00, FALSE, '2023-12-12', '2024-01-25'),
(15, 5, '300 Neural Drive, City O', 125000.00, FALSE, '2023-12-30', '2024-02-20'),
(16, 1, '321 Future City, City P', 70000.00, TRUE, '2023-11-15', '2023-12-30'),
(17, 2, '120 Creative Park, City Q', 65000.00, FALSE, '2023-12-05', '2024-01-20'),
(18, 3, '500 Corporate Ave., City R', 78000.00, TRUE, '2023-10-20', '2023-12-10'),
(19, 4, '830 Builder Park, City S', 98000.00, FALSE, '2023-12-12', '2024-01-15'),
(20, 5, '945 AI Center, City T', 130000.00, FALSE, '2023-12-30', '2024-02-28');

INSERT INTO `user_job_applications` (account_ID, job_id, company_ID, application_date, application_status) VALUES
(1, 1, 1, '2024-01-12', 'Pending'),
(2, 2, 2, '2024-01-18', 'Accepted'),
(3, 3, 3, '2024-01-25', 'Rejected'),
(4, 4, 4, '2024-01-30', 'Pending'),
(5, 5, 5, '2024-02-05', 'Accepted'),
(6, 6, 1, '2024-01-10', 'Rejected'),
(7, 7, 2, '2024-01-15', 'Pending'),
(8, 8, 3, '2024-01-20', 'Accepted'),
(9, 9, 4, '2024-01-25', 'Pending'),
(10, 10, 5, '2024-01-30', 'Rejected'),
(11, 11, 1, '2024-02-05', 'Accepted'),
(12, 12, 2, '2024-01-10', 'Pending'),
(13, 13, 3, '2024-01-15', 'Rejected'),
(14, 14, 4, '2024-01-20', 'Accepted'),
(15, 15, 5, '2024-01-25', 'Pending'),
(16, 16, 1, '2024-01-30', 'Accepted'),
(17, 17, 2, '2024-02-05', 'Rejected'),
(18, 18, 3, '2024-01-10', 'Pending'),
(19, 19, 4, '2024-01-15', 'Accepted'),
(20, 20, 5, '2024-01-20', 'Rejected');

INSERT INTO `company_employees` (account_ID, company_ID, date_hired) VALUES
(1, 1, '2024-02-01'),
(2, 2, '2024-02-05'),
(3, 3, '2024-02-10'),
(4, 4, '2024-02-15'),
(5, 5, '2024-02-20'),
(6, 1, '2024-02-25'),
(7, 2, '2024-03-01'),
(8, 3, '2024-03-05'),
(9, 4, '2024-03-10'),
(10, 5, '2024-03-15'),
(11, 1, '2024-03-20'),
(12, 2, '2024-03-25'),
(13, 3, '2024-03-30'),
(14, 4, '2024-04-05'),
(15, 5, '2024-04-10'),
(16, 1, '2024-04-15'),
(17, 2, '2024-04-20'),
(18, 3, '2024-04-25'),
(19, 4, '2024-04-30'),
(20, 5, '2024-05-05');

SELECT * FROM user_accounts;
SELECT * FROM company_accounts;
SELECT * FROM active_jobs;
SELECT * FROM REF_job_titles; 
SELECT * FROM user_job_applications;
SELECT * FROM company_branches; 
SELECT * FROM company_employees; 