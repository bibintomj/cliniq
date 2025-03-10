CREATE DATABASE IF NOT EXISTS cliniq;

USE cliniq;

CREATE TABLE Admin (
    admin_id SERIAL PRIMARY KEY,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO Admin (email, password_hash) VALUES
('admin@mail.com', '123456');


CREATE TABLE Clinic (
    clinic_id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    phone VARCHAR(15) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO Clinic (name, address, phone, email) VALUES
('KW Clinic', '123 Main St, Fairway, Kitchener, ON', '416-123-4567', 'kwclinic@mail.com', "******"),
('Waterloo Clinic', '456 Elm St, Waterloo, ON', '604-987-6543', 'waterlooclinic@mail.com', "*******");


CREATE TABLE Patient (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(50) NOT NULL, -- Male, Female, Non-binary, Prefer not to say
    address TEXT NOT NULL,
    phone_number VARCHAR(15) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    health_card_number VARCHAR(50), -- OHIP number or equivalent
    is_international_student BOOLEAN DEFAULT FALSE,
    student_id VARCHAR(50), -- Student ID for international students
    emergency_contact_name VARCHAR(255),
    emergency_contact_relationship VARCHAR(255),
    emergency_contact_number VARCHAR(15),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO Patient (
    first_name, last_name, date_of_birth, gender, address, phone_number, email, password_hash,
    health_card_number, is_international_student, student_id, emergency_contact_name,
    emergency_contact_relationship, emergency_contact_number
) VALUES
('John', 'Doe', '1990-05-15', 'Male', '123 Main St, Toronto, ON', '416-111-2222', 'john.doe@example.com', '******',
 '1234-567-890', FALSE, NULL, 'Jane Doe', 'Spouse', '416-999-8888'),

('Jane', 'Smith', '1985-10-20', 'Female', '456 Elm St, Vancouver, BC', '604-333-4444', 'jane.smith@example.com', '********',
 '9876-543-210', TRUE, 'S1234567', 'John Smith', 'Parent', '604-777-6666');


CREATE TABLE Visit (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES Patient(patient_id) ON DELETE CASCADE,
    clinic_id INT REFERENCES Clinic(clinic_id) ON DELETE CASCADE,
    visit_date TIMESTAMP NOT NULL,
    visit_reason TEXT NOT NULL, -- New column for visit reason
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


CREATE TABLE VisitNotes (
    note_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES Visit(visit_id) ON DELETE CASCADE,
    note TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


INSERT INTO Visit (patient_id, clinic_id, visit_date, visit_reason, status) VALUES
(1, 1, '2023-10-01 10:00:00', 'Routine checkup', 'Pending'),
(2, 2, '2023-10-02 11:00:00', 'Follow-up appointment', 'Pending');

INSERT INTO VisitNotes (visit_id, note) VALUES
(1, 'Patient reported mild headaches.'),
(1, 'Blood pressure checked and recorded.'),
(2, 'Patient requested a refill for prescription.'),
(2, 'Follow-up scheduled in 2 weeks.');


CREATE TABLE Queue (
    queue_id SERIAL PRIMARY KEY,
    clinic_id INT REFERENCES Clinic(clinic_id) ON DELETE CASCADE,
    patient_id INT REFERENCES Patient(patient_id) ON DELETE CASCADE,
    token_number INT NOT NULL,
    status VARCHAR(50) DEFAULT 'Waiting',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO Queue (clinic_id, patient_id, token_number) VALUES
(1, 1, 1),
(2, 2, 2);


-- Realtime Database
CREATE TABLE ClinicQueueStatus (
    clinic_id INT PRIMARY KEY REFERENCES Clinic(clinic_id) ON DELETE CASCADE,
    current_token INT, -- The token currently being served
    up_next_token INT, -- The token that will be served next
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO ClinicQueueStatus (clinic_id, current_token, up_next_token) VALUES
(1, 1, 2), -- Clinic 1 is serving token 1, and token 2 is up next
(2, 3, 4); -- Clinic 2 is serving token 3, and token 4 is up next

CREATE TABLE Prescription (
    prescription_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES Visit(visit_id) ON DELETE CASCADE,
    medicine_name VARCHAR(255) NOT NULL,
    dosage VARCHAR(255) NOT NULL,
    instructions TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO Prescription (visit_id, medicine_name, dosage, instructions) VALUES
(1, 'Medicine A', '500mg', 'Take once daily'),
(2, 'Medicine B', '250mg', 'Take twice daily');

CREATE TABLE Invoice (
    invoice_id SERIAL PRIMARY KEY,
    visit_id INT REFERENCES Visit(visit_id) ON DELETE CASCADE,
    amount DECIMAL(10, 2) NOT NULL,
    status VARCHAR(50) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Sample Data
INSERT INTO Invoice (visit_id, amount) VALUES
(1, 100.00),
(2, 150.00);