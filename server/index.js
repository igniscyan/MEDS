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

app.get("/get/", (req, res) => {
  const SelectQuery = " SELECT * FROM patients";
  db.query(SelectQuery, (err, results) => {
    res.send(
      results.map((result) => ({
        ...result,
        dob: result.dob.toString().split(" ").slice(1, 4).join(" "),
      }))
    );
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

// app.post("/insert", (req, res) => {
//   const patientName = req.body.setPatientName;
//   const patientDOB = req.body.setPatientDOB;
//   const patientGender = req.body.setPatientGender;
//   const patientAddress = req.body.setPatientAddress;
//   const patientPhone = req.body.setPatientPhone;
//   const patientEmail = req.body.setPatientEmail;

//   const InsertQuery =
//     " INSERT INTO patients (patient_name, patient_dob, patient_gender, patient_address, patient_phone, patient_email) VALUES (?, ?, ?, ?, ?, ?)";

//   db.query(
//     InsertQuery,
//     [
//       patientName,
//       patientDOB,
//       patientGender,
//       patientAddress,
//       patientPhone,
//       patientEmail,
//     ],
//     (err, result) => {
//       if (err) console.log(err);
//     }
//   );
// });

app.delete("/delete/:patientId", (req, res) => {
  const patientId = req.params.patientId;
  const DeleteQuery = "DELETE FROM patients WHERE id = ?";
  db.query(DeleteQuery, patientId, (err, result) => {
    if (err) console.log(err);
  });
});

app.put("/update/:patientId/:", (req, res) => {
  const patientUpdate = req.body.patientUpdate;
  const patientId = req.params.patientId;
  console.log("fudge knocka!");
});

app.post("/insert/patient/", (req, res) => {
  const valuesArray = Object.values(req.body);
  const insertNewPatientQuery =
    "INSERT INTO patients (last_name, first_name, dob, gender, smoker) VALUES (?, ?, ?, ?, ?)";
  const getPatientList = "SELECT * FROM patients";

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

app.post("/insert/patient_encounter/:patientId", (req, res) => {
  const insertPatientEncounterQuery =
    "INSERT INTO patient_encounters (patient_id, gyn, pregnant, last_menstrual_period, height, patient_weight, temp, systolic, diastolic, heart_rate, resp_rate, triage_note, med_note, pharm_note, eye_note, dental_note, goodies_note, location, open) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

  const getPatientEncountersQuery = "SELECT * FROM patient_encounters";
  const patientId = req.params.patientId;
  const valuesArray = Object.values(req.body); //array of values from request
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

console.log("TESTING TESTING");
app.listen("3001", () => {});
