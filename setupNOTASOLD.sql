CREATE TABLE `allergies` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `allergen` text,
  `created_at` datetime,
  `updated_at` datetime
);

CREATE TABLE `allergies_patients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `allergy_id` INT NOT NULL
);

CREATE TABLE `chief_complaints` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `complaint` text
);

CREATE TABLE `chief_complaints_patient_encounters` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `patient_encounter_id` INT NOT NULL,
  `chief_complaint_id` INT NOT NULL
);

CREATE TABLE `diagnoses` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `diagnosis` text
);

CREATE TABLE `diagnoses_patient_encounters` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `diagnosis_id` INT NOT NULL,
  `patient_encounter_id` INT NOT NULL
);

CREATE TABLE `drug_categories` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `category` text
);

CREATE TABLE `drugs` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `drug_name` text,
  `drug_route` text,
  `drug_dosage` text,
  `drug_category_id` INT NOT NULL,
  `inventory_start` INT,
  `in_stock` boolean
);

CREATE TABLE `fam_hxes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `diagnosis` text
);

CREATE TABLE `fam_hxes_patients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `fam_hx_id` INT NOT NULL
);

CREATE TABLE `patient_encounters` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `gyn` boolean,
  `pregnant` boolean,
  `last_menstrual_period` date,
  `height` decimal,
  `weight` INT,
  `temp` float,
  `decimal` text,
  `systolic` INT,
  `diastolic` INT,
  `heart_rate` INT,
  `resp_rate` INT,
  `triage_note` text,
  `med_note` text,
  `pharm_note` text,
  `eye_note` text,
  `dental_note` text,
  `goodies_note` text,
  `location` text,
  `patient_id` INT,
  `open` boolean
);

CREATE TABLE `patients` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `first_name` text,
  `last_name` text,
  `dob` datetime,
  `gender` text,
  `smoker` boolean
);

CREATE TABLE `patients_pm_hxes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `patient_id` INT NOT NULL,
  `pm_hx_id` INT NOT NULL
);

CREATE TABLE `pm_hxes` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `diagnosis` text
);

CREATE TABLE `prescriptions` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `created_at` datetime,
  `updated_at` datetime,
  `patient_encounter_id` INT,
  `med_instructions` text,
  `pharm_instructions` text,
  `diagnosis_id` INT NOT NULL,
  `med_prescription_id` INT NOT NULL,
  `pharm_prescription_id` INT NOT NULL
);

CREATE TABLE `users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `username` text,
  `password_digest` text,
  `created_at` datetime,
  `updated_at` datetime
);

ALTER TABLE `drugs` ADD CONSTRAINT `fk_rails_prescriptions_drugs` FOREIGN KEY (`id`) REFERENCES `prescriptions` (`med_prescription_id`);

ALTER TABLE `drugs` ADD CONSTRAINT `fk_rails_prescriptions_drugs` FOREIGN KEY (`id`) REFERENCES `prescriptions` (`pharm_prescription_id`);

ALTER TABLE `patients` ADD CONSTRAINT `fk_rails_allergies_patients_patients` FOREIGN KEY (`id`) REFERENCES `allergies_patients` (`patient_id`);

ALTER TABLE `allergies` ADD CONSTRAINT `fk_rails_allergies_patients_allergies` FOREIGN KEY (`id`) REFERENCES `allergies_patients` (`allergy_id`);

ALTER TABLE `patient_encounters` ADD CONSTRAINT `fk_rails_chief_complaints_patient_encounters_patient_encounters` FOREIGN KEY (`id`) REFERENCES `chief_complaints_patient_encounters` (`patient_encounter_id`);

ALTER TABLE `chief_complaints` ADD CONSTRAINT `fk_rails_chief_complaints_patient_encounters_chief_complaints` FOREIGN KEY (`id`) REFERENCES `chief_complaints_patient_encounters` (`chief_complaint_id`);

ALTER TABLE `diagnoses` ADD CONSTRAINT `fk_rails_diagnoses_patient_encounters_diagnoses` FOREIGN KEY (`id`) REFERENCES `diagnoses_patient_encounters` (`diagnosis_id`);

ALTER TABLE `patient_encounters` ADD CONSTRAINT `fk_rails_diagnoses_patient_encounters_patient_encounters` FOREIGN KEY (`id`) REFERENCES `diagnoses_patient_encounters` (`patient_encounter_id`);

ALTER TABLE `drug_categories` ADD CONSTRAINT `fk_rails_drugs_drug_categories` FOREIGN KEY (`id`) REFERENCES `drugs` (`drug_category_id`);

ALTER TABLE `patients` ADD CONSTRAINT `fk_rails_fam_hxes_patients_patients` FOREIGN KEY (`id`) REFERENCES `fam_hxes_patients` (`patient_id`);

ALTER TABLE `fam_hxes` ADD CONSTRAINT `fk_rails_fam_hxes_patients_fam_hxes` FOREIGN KEY (`id`) REFERENCES `fam_hxes_patients` (`fam_hx_id`);

ALTER TABLE `patients` ADD CONSTRAINT `fk_rails_patient_encounters_patients` FOREIGN KEY (`id`) REFERENCES `patient_encounters` (`patient_id`);

ALTER TABLE `patients` ADD CONSTRAINT `fk_rails_patients_pm_hxes_patients` FOREIGN KEY (`id`) REFERENCES `patients_pm_hxes` (`patient_id`);

ALTER TABLE `pm_hxes` ADD CONSTRAINT `fk_rails_patients_pm_hxes_pm_hxes` FOREIGN KEY (`id`) REFERENCES `patients_pm_hxes` (`pm_hx_id`);

ALTER TABLE `patient_encounters` ADD CONSTRAINT `fk_rails_prescriptions_patient_encounters` FOREIGN KEY (`id`) REFERENCES `prescriptions` (`patient_encounter_id`);

ALTER TABLE `diagnoses` ADD CONSTRAINT `fk_rails_prescriptions_diagnoses` FOREIGN KEY (`id`) REFERENCES `prescriptions` (`diagnosis_id`);
ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARASET=latin1;
