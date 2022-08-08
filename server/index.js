const express = require('express');
const mysql = require('mysql2');
const cors = require('cors');


const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use(cors());

const db = mysql.createPool({
    host: 'mysql_db',
    user: 'MYSQL_USER',
    password: 'MYSQL_PASSWORD',
    database: 'meds'
});




app.get('/', (req, res) => {
    res.send('Hello World!');
})


app.get('/get/', (req, res) => {
    const SelectQuery = " SELECT * FROM patients";
    db.query(SelectQuery, (err, results) => {
        res.send(results);
    });
})

app.post('/insert', (req, res) => {
    const patientName = req.body.setPatientName;
    const patientDOB = req.body.setPatientDOB;
    const patientGender = req.body.setPatientGender;
    const patientAddress = req.body.setPatientAddress;
    const patientPhone = req.body.setPatientPhone;
    const patientEmail = req.body.setPatientEmail;

    const InsertQuery = " INSERT INTO patients (patient_name, patient_dob, patient_gender, patient_address, patient_phone, patient_email) VALUES (?, ?, ?, ?, ?, ?)";

    db.query(InsertQuery, [patientName, patientDOB, patientGender, patientAddress, patientPhone, patientEmail], (err, result) => {
        if (err) console.log(err);
    })
});

app.delete("/delete/:patientId", (req, res) => {
    const patientId = req.params.patientId;
    const DeleteQuery = "DELETE FROM patients WHERE patient_id = ?";
    db.query(DeleteQuery, patientId, (err, result) => {
        if (err) console.log(err);
    })
});


app.put("/update/:patientId", (req, res) => {
    const patientUpdate = req.body.patientUpdate;
    const patientId = req.params.patientId;
    console.log("fudge knocka!")
});



app.listen('3001', () => { });