const express = require("express");
const mysql = require("mysql2");
const cors = require("cors");

const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cors());

const db = mysql.createPool({
  host: "mysql_db",
  user: "MYSQL_USER",
  password: "MYSQL_PASSWORD",
  database: "meds",
});

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.get("/get", (req, res) => {
  console.log("GET /get");
  const SelectQuery =
    ' SELECT *, DATE_FORMAT(dob, "%Y-%m-%d") as dob FROM patients';
  db.query(SelectQuery, (err, results) => {
    console.log(results);
    res.send(results);
  });
});
app.get("/get/drugs", async (req, res) => {
  const selectQuery = "SELECT * FROM drugs";
  db.query(selectQuery, (err, results) => {
    res.send(results);
  });
});

app.get("/get/:patientId", (req, res) => {
  const patientId = req.params.patientId;
  const SelectQuery = " SELECT * FROM patients WHERE id = ?";
  db.query(SelectQuery, patientId, (err, results) => {
    res.send(results);
    console.log(results);
  });
});


app.get("/get/patient_crit/:patientId", (req, res) => {
  const patientId = req.params.patientId;
  const selectQuery = "SELECT first_name, last_name, gender FROM patients WHERE id = ?";
  db.query(selectQuery, patientId, (err, results) => {
    res.send(results);
    console.log(results);
  });
});

app.get("/get/patient_encounters/:patientId", (req, res) => {
  const patientId = req.params.patientId;
  const SelectQuery = "SELECT * FROM patient_encounters where patient_id = ?";
  db.query(SelectQuery, patientId, (err, results) => {
    res.send(results);
  });
});

app.get("/get/patient_encounter/:encounterId", (req, res) => {
  const encounterId = req.params.encounterId;
  const SelectQuery = "SELECT * FROM patient_encounters WHERE id = ?";

  db.query(SelectQuery, encounterId, (err, results) => {
    res.send(results);
    console.log(results);
  });
});

app.get("/test/queues", (req, res) => {
  console.log("GET /get/queues");
  db.query("SELECT * FROM queues", (err, results) => {
    if (err) {
      console.error(err);
      res.status(500).send("Internal server error");
      return;
    }

    console.log(results);
    res.send(results);
  });
});

app.delete("/delete/:patientId", (req, res) => {
  const patientId = req.params.patientId;
  const DeleteQuery = "DELETE FROM patients WHERE id = ?";
  db.query(DeleteQuery, patientId, (err, result) => {
    if (err) console.log(err);
  });
});

app.put("/update/patient/:patientId/", ({ body, params }, res) => {
  const newPatientInfo = Object.values(body).filter((item) => item !== "");
  if (newPatientInfo.dob === "") {
    newPatientInfo.dob = null;
  }
  if (newPatientInfo.age === 0) {
    newPatientInfo.age = null;
  }
  const { patientId } = params;
  const getPatientList = "SELECT * FROM patients";

  console.log("newPatientInfo: ", newPatientInfo);
  console.log("patientId: ", patientId);

  // FIXME: This doesn't seem to be saving age...
  // Might just need to reload the server, but idk
  // Not sure if Hot Module Reload works on backend changes
  const putPatientUpdateQuery =
    "UPDATE patients SET first_name = ?, last_name = ?, age = ?, dob = ?, gender = ?, smoker = ? WHERE id = ?";

  db.query(
    putPatientUpdateQuery,
    [...newPatientInfo, patientId],
    (err, result) => {
      if (err) console.log(err);
      else {
        db.query(getPatientList, (err, results) => {
          if (err) console.log(err);
          else res.send(results);
        });
      }
    }
  );
});

//TODO: implement and test
app.put("/update/patient_queue/:patientId/", ({ body, params }, res) => {
  //get patient id and new queue status from params
  const { patientId } = params;
  const { queueStatus } = body;

  const getPatientList = "SELECT * FROM patients";
  const updatePatientQueueQuery = "UPDATE patients SET queue = ? WHERE id = ?";
  db.query(updatePatientQueueQuery, [queueStatus, patientId], (err, result) => {
    if (err) console.log(err);
    else {
      db.query(getPatientList, (err, results) => {
        if (err) console.log(err);
        else res.send(results);
      });
    }
  });
});

app.post("/insert/patient/", (req, res) => {
  console.log("This is a test of the logging in index.js");
  if (req.body.age === 0) {
    req.body.age = null;
  }
  if (req.body.dob === "") {
    req.body.dob = null;
  }

  const insertNewPatientQuery = `INSERT INTO patients (first_name, last_name, age, dob, gender, smoker) VALUES (?, ?, ?, ?, ?, ?)`;
  const getPatientList = "SELECT * FROM patients";

  // Array of non-empty values from request:
  const valuesArray = Object.values(req.body).filter((value) => value !== "");
  console.log("valuesArray", valuesArray);

  db.query(insertNewPatientQuery, valuesArray, (err, result) => {
    if (err) console.log(err);
    else {
      db.query(getPatientList, (err, results) => {
        if (err) console.log(err);
        else {
          res.send(results);
        }
      });
    }
  });
});

app.post("/insert/patient_encounter/:patientId/", (req, res) => {
  const insertPatientEncounterQuery =
    "INSERT INTO patient_encounters (patient_id, chief_complaint, alt_chief_complaint, pregnant, urine_test, glucose, past_medical_history, allergies, history_notes, diagnoses, height, patient_weight, temp, systolic, diastolic, heart_rate, resp_rate, disbursement_1, disbursement_2, disbursement_3, disbursement_4, disbursement_5, disbursement_6, disbursement_7, disbursement_8, disbursement_9, disbursement_10, disbursement_1_quantity, disbursement_2_quantity, disbursement_3_quantity, disbursement_4_quantity, disbursement_5_quantity, disbursement_6_quantity, disbursement_7_quantity, disbursement_8_quantity, disbursement_9_quantity, disbursement_10_quantity, goodies_disbursement, antiparasitic_disbursement, fluoride_disbursement, survey_1, survey_2, survey_3, survey_4, survey_5) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

  const getPatientEncountersQuery = "SELECT * FROM patient_encounters";
  const patientId = req.params.patientId;

  // Array of non-empty values from request:
  const valuesArray = Object.values(req.body).filter((value) => value !== "");
  valuesArray.unshift(patientId);

  db.query(insertPatientEncounterQuery, valuesArray, (err, result) => {
    if (err) console.log(err);
    else {
      db.query(getPatientEncountersQuery, (err, results) => {
        if (err) console.log(err);
        else res.send(results);
      });
    }
  });
});

app.put("/update/patient_encounter/:encounterId", (req, res) => {
  const updatePatientEncounterQuery =
    "UPDATE patient_encounters SET chief_complaint = ?, alt_chief_complaint = ?, pregnant = ?, urine_test = ?, glucose = ?, past_medical_history = ?, allergies = ?, history_notes = ?, diagnoses = ?,  height = ?, patient_weight = ?, temp = ?, systolic = ?, diastolic = ?, heart_rate = ?, resp_rate = ?, disbursement_1 = ?, disbursement_2 = ?, disbursement_3 = ?, disbursement_4 = ?, disbursement_5 = ?, disbursement_6 = ?, disbursement_7 = ?, disbursement_8 = ?, disbursement_9 = ?, disbursement_10 = ?, disbursement_1_quantity = ?, disbursement_2_quantity = ?, disbursement_3_quantity = ?, disbursement_4_quantity = ?, disbursement_5_quantity = ?, disbursement_6_quantity = ?, disbursement_7_quantity = ?, disbursement_8_quantity = ?, disbursement_9_quantity = ?, disbursement_10_quantity = ?, goodies_disbursement = ?, antiparasitic_disbursement = ?, fluoride_disbursement = ?, survey_1 = ?, survey_2 = ?, survey_3 = ?, survey_4 = ?, survey_5 = ? WHERE id=?";
  const getPatientEncountersQuery = "SELECT * FROM patient_encounters";
  const encounterId = req.params.encounterId;
  const valuesArray = Object.values(req.body).filter((item) => item !== "");
  console.log("Filetered Array: ", valuesArray);
  console.log("Unfiltered Array: ", Object.values(req.body));
  db.query(
    updatePatientEncounterQuery,
    [...valuesArray, encounterId],
    (err, results) => {
      if (err) console.log(err);
      else {
        db.query(getPatientEncountersQuery, (err, results) => {
          if (err) console.log(err);
          else res.send(results);
        });
      }
    }
  );
});

console.log("TESTING TESTING");
app.listen("3001", () => { });