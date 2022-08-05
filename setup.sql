CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password_digest` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  
  PRIMARY KEY (`id`)
); 


CREATE TABLE IF NOT EXISTS `patients` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL, 
  `last_name` varchar(255) NOT NULL,
  `first_name` varchar(255) NOT NULL,
  `dob` date NOT NULL, 
  `gender` varchar(255) NOT NULL, 
  `smoker` boolean NOT NULL,
  
  PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS `patient_encounters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_id` int NOT NULL, 
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `gyn` boolean, 
  `pregnant` boolean, 
  `last_menstrual_period` date,
  `height` decimal(2,1),
  `patient_weight` int,
  `temp` float, 
  `systolic` int,
  `diastolic` int, 
  `heart_rate` int, 
  `resp_rate` int,
  `triage_note` text,
  `med_note` text, 
  `pharm_note` text,
  `eye_note` text, 
  `dental_note` text, 
  `goodies_note` text,
  `location` text,
  `open` boolean,

  FOREIGN KEY (`patient_id`) REFERENCES patients(`id`),
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `drug_categories` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL, 
  `updated_at` datetime NOT NULL,
  `category` varchar(255) NOT NULL,
  PRIMARY KEY(`id`)
);


CREATE TABLE IF NOT EXISTS `drugs` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `drug_name` varchar(255) NOT NULL, 
  `drug_route` varchar(255) NOT NULL, 
  `drug_dosage` varchar(255) NOT NULL, 
  `drug_category_id` int NOT NULL,
  `inventory_start` int NOT NULL,
  
  FOREIGN KEY(`drug_category_id`) REFERENCES drug_categories(`id`),
  PRIMARY KEY (`id`)
);


CREATE TABLE IF NOT EXISTS `prescriptions` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
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

CREATE TABLE IF NOT EXISTS `chief_complaints_patient_encounters` (
  `id` int NOT NULL AUTO_INCREMENT,
  `patient_encounter_id` int NOT NULL,
  `chief_complaint_id` int NOT NULL, 
  PRIMARY KEY (`id`),
  
  FOREIGN KEY (`patient_encounter_id`) REFERENCES patient_encounters(`id`),
  FOREIGN KEY (`chief_complaint_id`) REFERENCES chief_complaints(`id`)
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
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL, 
  `diagnosis` text NOT NULL,
  
  PRIMARY KEY (`id`) 
);

CREATE TABLE IF NOT EXISTS `pm_hxes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL, 
  `diagnosis` text NOT NULL,
  
  PRIMARY KEY (`id`)
);

CREATE TABLE IF NOT EXISTS `fam_hxes` ( 
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL, 
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


