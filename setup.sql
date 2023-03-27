CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_digest` varchar(50) NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `dob` date,
  `age` int,
  `gender` varchar(255) NOT NULL,
  `smoker` boolean NOT NULL,
  `queue` int NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `queues` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) NOT NULL,
  PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `patient_encounters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `chief_complaint` int,
  `alt_chief_complaint` text,
  `pregnant` varchar(255),
  `height` float,
  `history_notes` text,
  `past_medical_history` text,
  `patient_weight` int,
  `allergies` text,
  `urine_test` text,
  `glucose` float,
  `temp` float,
  `systolic` int,
  `diastolic` int,
  `heart_rate` int,
  `resp_rate` int,
  `diagnoses` text,
  `disbursement_1` int,
  `disbursement_2` int,
  `disbursement_3` int,
  `disbursement_4` int,
  `disbursement_5` int,
  `disbursement_6` int,
  `disbursement_7` int,
  `disbursement_8` int,
  `disbursement_9` int,
  `disbursement_10` int,
  `goodies_disbursement` tinyint(1),
  `antiparasitic_disbursement` tinyint(1),
  `fluoride_disbursement` tinyint(1),
  `survey_1` text,
  `survey_2` text,
  `survey_3` text,
  `survey_4` text,
  `survey_5` text,
  FOREIGN KEY (`patient_id`) REFERENCES patients(`id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `drug_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `category` varchar(255) NOT NULL,
  PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `drugs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `drug_name` varchar(255) NOT NULL,
  `drug_route` varchar(255) NOT NULL,
  `drug_dosage` varchar(255),
  `drug_category_id` int NOT NULL,
  `inventory_qty` int,
  FOREIGN KEY(`drug_category_id`) REFERENCES drug_categories(`id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `prescriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `patient_encounter_id` int NOT NULL,
  `med_instructions` text,
  `pharm_instructions` text,
  `diagnosis_id` int NOT NULL,
  `med_prescription_id` bigint NOT NULL,
  `pharm_prescription_id` bigint NOT NULL,
  FOREIGN KEY (`patient_encounter_id`) REFERENCES patient_encounters(`id`),
  PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `chief_complaints`(
  `id` int NOT NULL AUTO_INCREMENT,
  `complaint` text NOT NULL,
  PRIMARY KEY(`id`)
);

CREATE TABLE IF NOT EXISTS `allergies` (
  `id` int NOT NULL AUTO_INCREMENT,
  `allergen` text NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `allergies_patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `allergy_id` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES patients(`id`),
  FOREIGN KEY (`allergy_id`) REFERENCES allergies(`id`)
);

CREATE TABLE IF NOT EXISTS `diagnoses` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `diagnosis` text NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `pm_hxes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `diagnosis` text NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `fam_hxes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `diagnosis` text NOT NULL,
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `fam_hxes_patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `fam_hxe_id` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES patients(`id`),
  FOREIGN KEY (`fam_hxe_id`) REFERENCES fam_hxes(`id`)
);

CREATE TABLE IF NOT EXISTS `patient_pm_hexes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL,
  `pm_hx_id` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`patient_id`) REFERENCES patients(`id`),
  FOREIGN KEY (`pm_hx_id`) REFERENCES pm_hxes(`id`)
);

CREATE TABLE IF NOT EXISTS `drug_assignment_insert` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `updated_at` DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `drug_id` int NOT NULL,
  `patient_id` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`id`),
  FOREIGN KEY (`drug_id`) REFERENCES drugs(`id`),
  FOREIGN KEY (`patient_id`) REFERENCES patients(`id`)
);

INSERT INTO drug_categories
(
    category
)
VALUES 
('ALLERGY'),  
('ANTIBIOTICS (ORAL)'),
('ANTIBIOTICS (TOPICAL)'),
('ANTIEMETICS'),
('ANTIFUNGALS (ORAL)'),
('ANTIFUNGALS (TOPICAL)'),
('ANTIPARASITIC'),
('ANTISCABIES'),
('ANTIVIRALS'),
('ASTHMA/COPD'),
('CARDIOVASCULAR'),
('COUGH/COLD'),
('ENDOCRINE'),
('EYE'),
('GI'),
('PAIN'),  
('STEROID'),
('TOPICAL'),
('VITAMINS'),
('EMERGENCY'); 

INSERT INTO drugs
(
    drug_category_id,
    drug_name,
    drug_route,
    drug_dosage,
    inventory_qty
)
VALUES
(1, 'CETIRIZINE HCL', '', '10MG', 6000),
(1, 'CEFTIRIZINE HCL: 120ML BOTTLE', '', '10MG',50),
(1, 'LORATADINE', '', '10MG', 3600),
(1, 'LORATADINE: 120 ML BOTTLE', '', '5MG/5ML', 50),
(1, 'FLUTICASONE PROPIONATE NASAL SPRAY', '', '50MCG/16G', 30),
(2, 'AMOXCILLIN', '', '500MG', 1000),
(2, 'AMOXCILLIN', '', '875MG', 200),
(2, 'AMOXICILLIN: 50 ML BOTTLE', '', '400MG/5ML', 14),
(2, 'AMOXICILLIN: 100ML BOTTLE', '', '250MG/5ML', 70),
(2, 'AZITHROMYCIN', '', '250MG', 216),
(2, 'AZITHROMYCIN: 15 ML BOTTLE', '', '200MG/5ML', 14),
(2, 'CEPHALEXIN', '', '500MG', 1000),
(2, 'CEPHALEXIN: 100 ML BOTTLE', '', '250MG/5ML', 20),
(2, 'CIPROFLOXACIN', '', '500MG', 1000),
(2, 'CLARITHROMYCIN ', '', '500MG', 120),
(2, 'DOXYCYCLINE', '', '100MG', 1000),
(2, 'METRONIDAZOLE', '', '250MG', 500),
(2, 'METRONIDAZOLE', '', '500MG', 1000),
(2, 'NITROFURANTOIN', '', '100MG', 1000),
(2, 'SMZ/TMP DS', '', '800MG/160MG', 1000),
(3, 'BACTROBAN 22 G TUBE', '', '2%', 50),
(3, 'GENTAMICIN EYE DROPS: 5 ML BOTTLE', '', '0.30%', 30),
(3, 'OFLOXACIN EYE DROPS: 5ML BOTTLE', '', '0.30%', 30),
(4, 'ONDANSETRON', '', '4MG', 210),
(5, 'FLUCONAZOLE', '', '150MG', 200),
(5, 'FLUCONAZOLE', '', '100MG', 300),
(5, 'TERBINAFINE', '', '250MG', 300),
(6, 'CLOTRIMAZOLE TOPICAL: 20 G TUBE', '', '1%', 48),
(6, 'CLOTRIMAZOLE VAGINAL: 45 G INSERT', '', '45G', 30),
(7, 'ALBENDAZOLE', '', '400MG', 1500),
(7, 'IVERMECTIN', '', '6MG', 500),
(8, 'PERMETHRIN CREAM: 60 TUBE', '', '5%', 10),
(9, 'ACYCLOVIR', '', '200MG', 500),
(10, 'SALBUTAMOL INHALER', '', '0.1MG;200 DOSES', 400), 
(11, 'AMLODIPINE', '', '5MG', 2000),
(11, 'AMLODIPINE', '', '10MG', 3000),
(11, 'ASPIRIN', '', '81MG', 2000),
(11, 'ATENOLOL', '', '50MG', 2000),
(11, 'ENALAPRIL', '', '10MG', 400),
(11, 'FUROSEMIDE', '', '40MG', 2000),
(11, 'FUROSEMIDE', '', '20MG', 2000),
(11, 'HYDROCHLOROTHIAZIDE', '', '25MG', 2000),
(11, 'HYDROCHLOROTHIAZIDE', '', '12.5MG', 2000),
(11, 'LISINOPRIL', '', '20MG', 2000),
(11, 'LISINOPRIL', '', '10MG', 2000),
(11, 'METOPROLOL SUCCINATE', '', '25MG', 2000),
(11, 'METOPROLOL SUCCINATE', '', '50MG', 2000),
(12, 'GUAIFENESIN 118ML BOTTLE', '', '100MG', 250),
(13, 'GLIPIZIDE', '', '5MG', 1000),
(13, 'METFORMIN', '', '1000MG', 1000),
(13, 'METFORMIN', '', '500MG', 8000),
(14, 'ARTIFICIAL TEARS*: 15 ML BOTLLE', '', '', 60),
(15, 'BISMUTH', '', '262MG', 210),
(15, 'CALCIUM CARBONATE', '', '500MG', 3000),
(15, 'DOCUSATE', '', '100MG', 500),
(15, 'FAMOTIDINE', '', '20MG', 2000),
(15, 'LOPERAMIDE', '', '2MG', 500),
(15, 'OMEPRAZOLE', '', '20MG', 3000),
(15, 'PHENYLEPHRINE', '', '', 36),
(15, 'SENNA', '', '8.6MG', 200),
(15, 'SIMETHICONE ', '', '125MG', 300),
(16, 'ACETAMINOPHEN', '', '325MG', 8000),
(16, 'ACETAMINOPHEN', '', '500MG', 5000),
(16, 'ACETOMINOPHEN ELIXIR: 118ML BOTTLE', '', '160MG/5ML',76),
(16, 'IBUPROFEN', '', '200MG', 7000),
(16, 'IBUPROFEN', '', '600MG', 2000),
(16, 'IBUPROFEN: 118 ML BOTTLE', '', '100MG/5ML', 40),
(16, 'MELOXICAM ', '', '7.5MG', 200),
(16, 'NAPROXEN', '', '500MG', 1500),
(16, 'CYCLOBENZAPRINE', '', '10MG', 200),
(17, 'PREDNISONE', '', '5MG', 200),
(17, 'PREDNISONE', '', '10MG', 200),
(17, 'PREDNISONE', '', '20MG', 500),
(17, 'DEXAMETHASONE', '', '4MG', 2000),
(18, 'HYDROCORTISONE CREAM: 1 OZ TUBE', '', '1%', 50),
(18, 'TRIAMCINOLONE CREAM: 30 G TUBE', '', '0.10%', 45),
(18, 'SODIUM FLUORIDE VARNISH', '', '5%', 2000),
(19, 'ADULT''S MVI W/O IRON', '', '', 70000),
(19, 'CALCIUM W/ VIT D', '', '600MG/5MCG', 120),
(19, 'CHILDREN''S MVI W/O IRON', '', '', 21000),
(19, 'PRENATALS', '', '', 1000),
(19, 'ADULT''S VITAMIN C', '', '500MG', 200),
(20, 'EPINEPHRINE INJECTABLE', '', '1:10000 VIALS', 3), 
(20, 'CEFTRIAXONE SODIUM', '', '250MG/ML', 6), 
(20, 'CEFTRIAXONE SODIUM', '', '500MG/ML', 4), 
(20, 'SOLUMEDROL', '', '40MG/ML', 2),
(20, 'SOLUMEDROL', '', '125MG/ML', 2),
(20, 'NITROSTAT', '', '0.4MG/ML',2),
(20, '0.9 NS', '', '1000ML',3),
(20, 'PROMETHAZINE', '', '50MG/ML',4),
(20, 'CLONIDINE', '', '0.1MG/ML',100),
(20, 'BENADRYL', '', '12.5MG/ML',8),
(20, 'BENADRYL', '', '50MG',100);