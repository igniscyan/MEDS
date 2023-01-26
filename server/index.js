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
  const SelectQuery = " SELECT *, DATE_FORMAT(dob, \"%Y-%m-%d\") as dob FROM patients";
  db.query(SelectQuery, (err, results) => {
    console.log(results);
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

app.get("/get/patient_name/:patientId", (req, res) => {
  const patientId = req.params.patientId;
  const selectQuery = "SELECT first_name, last_name FROM patients WHERE id = ?";
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
  const SelectQuery = "SELECT * FROM patient_encounters WHERE id = ?"

  db.query(SelectQuery, encounterId, (err, results)=> {
    res.send(results);
    console.log(results);
  })
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

app.put("/update/patient/:patientId/", ({body, params}, res) => {
  const newPatientInfo = Object.values(body).filter(item => item !== "");
  const {patientId} = params;
  const getPatientList = "SELECT * FROM patients";

  console.log("newPatientInfo: ", newPatientInfo);
  console.log("patientId: ", patientId);
    
  const postPatientUpdateQuery = 
    'UPDATE patients SET first_name = ?, last_name = ?, dob = ?, gender = ?, smoker = ? WHERE id = ?';

  db.query(postPatientUpdateQuery, [...newPatientInfo, patientId], (err, result) => {
    if (err) console.log(err);
    else{
      db.query(getPatientList, (err, results) => {
        if(err) console.log(err);
        else res.send(results);
      })
    }
  })
    
  console.log("fudge knocka!");
});

app.post("/insert/patient/", (req, res) => {
  console.log(req.body)
  const valuesArray = Object.values(req.body);
  const insertNewPatientQuery =
    "INSERT INTO patients (first_name, last_name, dob, gender, smoker) VALUES (?, ?, ?, ?, ?)";
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

app.post("/insert/patient_encounter/:patientId/", (req, res) => {
  const insertPatientEncounterQuery =
    "INSERT INTO patient_encounters (patient_id, chief_complaint, gyn, pregnant, last_menstrual_period, height, patient_weight, temp, systolic, diastolic, heart_rate, resp_rate, triage_note, med_note, pharm_note, eye_note, dental_note, goodies_note, location, open) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)";

  const getPatientEncountersQuery = "SELECT * FROM patient_encounters";
  const patientId = req.params.patientId;

  // Array of non-empty values from request:
  const valuesArray = Object.values(req.body).filter(value => value !== ""); 
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

app.put("/update/patient_encounter/:encounterId",  (req, res) => {
  const updatePatientEncounterQuery = "UPDATE patient_encounters SET chief_complaint = ?, gyn = ?, pregnant = ?, last_menstrual_period = ?, height = ?, patient_weight = ?, temp = ?, systolic = ?, diastolic = ?, heart_rate = ?, resp_rate = ?, triage_note = ?, med_note = ?, pharm_note = ?, eye_note = ?, dental_note = ?, goodies_note = ?, location = ?, open = ? WHERE id=?"
  const getPatientEncountersQuery = "SELECT * FROM patient_encounters";
  const encounterId = req.params.encounterId;
  const valuesArray = Object.values(req.body).filter(item => item !== ""); 
  console.log("Filetered Array: ", valuesArray);
  console.log("Unfiltered Array: ", Object.values(req.body));
  db.query(updatePatientEncounterQuery, [...valuesArray, encounterId], (err, results) => {
    if (err) console.log(err);

    else {
      db.query(getPatientEncountersQuery, (err, results) => {
        if (err) console.log(err);
        else res.send(results);
      })
    }
  })
})

console.log("TESTING TESTING");
app.listen("3001", () => {});