-- ============================================================
--  Golden Spa Database Schema
--  Author: Bon
--  Description: Full relational schema for spa management system
--               covering employees, clients, appointments,
--               services, departments, and certifications.
-- ============================================================

CREATE DATABASE IF NOT EXISTS golden_spa;
USE golden_spa;

-- ------------------------------------------------------------
-- CERTIFICATES
-- ------------------------------------------------------------
CREATE TABLE Certificates (
    certificate_id        INT          NOT NULL AUTO_INCREMENT,
    certificate_type      VARCHAR(10),
    certificate_expiration DATE,
    PRIMARY KEY (certificate_id)
);

-- ------------------------------------------------------------
-- DEPARTMENTS
-- ------------------------------------------------------------
CREATE TABLE Departments (
    department_id   INT          NOT NULL AUTO_INCREMENT,
    department_type VARCHAR(20)  NOT NULL,
    PRIMARY KEY (department_id)
);

-- ------------------------------------------------------------
-- EMPLOYEES
-- ------------------------------------------------------------
CREATE TABLE Employees (
    employee_id          INT           NOT NULL AUTO_INCREMENT,
    employee_first_name  VARCHAR(10),
    employee_last_name   VARCHAR(10),
    employee_DOB         DATE          NOT NULL,
    employee_SSN         INT(9),
    employee_street1     VARCHAR(20)   NOT NULL,
    employee_street2     VARCHAR(10),
    employee_city        VARCHAR(25)   NOT NULL,
    employee_state       CHAR(2),
    employee_zip         INT(5),
    employee_phone       INT(10),
    employee_email       VARCHAR(25)   NOT NULL,
    employee_hired       DATE          NOT NULL,
    employee_terminated  DATE,
    employee_position    VARCHAR(20)   NOT NULL,
    employee_salary      DECIMAL(6,2),
    employee_hours       TIME,
    department_id        INT,
    certificate_id       INT,
    PRIMARY KEY (employee_id),
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id)
        REFERENCES Departments(department_id),
    CONSTRAINT fk_emp_cert FOREIGN KEY (certificate_id)
        REFERENCES Certificates(certificate_id)
);

-- ------------------------------------------------------------
-- CLIENTS
-- ------------------------------------------------------------
CREATE TABLE Clients (
    client_id          INT          NOT NULL AUTO_INCREMENT,
    client_first_name  VARCHAR(10)  NOT NULL,
    client_last_name   VARCHAR(10)  NOT NULL,
    client_street1     VARCHAR(20)  NOT NULL,
    client_street2     VARCHAR(10),
    client_city        VARCHAR(25)  NOT NULL,
    client_state       CHAR(2),
    client_zip         CHAR(5),
    client_phone       CHAR(10)     NOT NULL,
    client_email       VARCHAR(20)  NOT NULL,
    PRIMARY KEY (client_id)
);

-- ------------------------------------------------------------
-- SERVICES
-- ------------------------------------------------------------
CREATE TABLE Services (
    service_id       INT          NOT NULL AUTO_INCREMENT,
    service_type     VARCHAR(20)  NOT NULL,
    service_cost     DECIMAL(3,2),
    service_duration TIME,
    PRIMARY KEY (service_id)
);

-- ------------------------------------------------------------
-- APPOINTMENTS
-- ------------------------------------------------------------
CREATE TABLE Appointments (
    appointment_id    INT  NOT NULL AUTO_INCREMENT,
    appointment_date  DATE,
    appointment_time  TIME,
    service_id        INT,
    employee_id       INT,
    client_id         INT,
    PRIMARY KEY (appointment_id),
    CONSTRAINT fk_appt_service  FOREIGN KEY (service_id)
        REFERENCES Services(service_id),
    CONSTRAINT fk_appt_employee FOREIGN KEY (employee_id)
        REFERENCES Employees(employee_id),
    CONSTRAINT fk_appt_client   FOREIGN KEY (client_id)
        REFERENCES Clients(client_id)
);

-- ============================================================
-- SAMPLE DATA
-- ============================================================

INSERT INTO Certificates (certificate_type, certificate_expiration) VALUES
    ('Massage',    '2026-06-30'),
    ('Esthetics',  '2025-12-31'),
    ('Nail Tech',  '2027-03-15');

INSERT INTO Departments (department_type) VALUES
    ('Massage Therapy'),
    ('Skincare'),
    ('Nail Design'),
    ('Hair Design'),
    ('Body Therapy');

INSERT INTO Employees (
    employee_first_name, employee_last_name, employee_DOB,
    employee_SSN, employee_street1, employee_city, employee_state,
    employee_zip, employee_phone, employee_email,
    employee_hired, employee_position, employee_salary,
    employee_hours, department_id, certificate_id
) VALUES
    ('Maria',  'Lopez',  '1990-04-12', 123456789, '100 Spa Lane',    'Miami', 'FL', 33101, 3051112222, 'mlopez@goldenspa.com',  '2018-01-15', 'Lead Therapist', 52000.00, '08:00:00', 1, 1),
    ('James',  'Carter', '1985-07-22', 987654321, '200 Coral Way',   'Miami', 'FL', 33102, 3052223333, 'jcarter@goldenspa.com', '2019-03-01', 'Nail Technician',45000.00, '09:00:00', 3, 3),
    ('Sofia',  'Reyes',  '1993-11-05', 456789123, '300 Biscayne Blvd','Miami','FL', 33103, 3053334444, 'sreyes@goldenspa.com',  '2020-06-10', 'Esthetician',    48000.00, '10:00:00', 2, 2);

INSERT INTO Clients (
    client_first_name, client_last_name, client_street1,
    client_city, client_state, client_zip, client_phone, client_email
) VALUES
    ('Anna',    'Smith',   '10 Oak Ave',    'Miami', 'FL', '33110', '3059990001', 'asmith@email.com'),
    ('Carlos',  'Mendez',  '25 Pine St',    'Miami', 'FL', '33111', '3059990002', 'cmendez@email.com'),
    ('Nicole',  'Johnson', '40 Maple Dr',   'Miami', 'FL', '33112', '3059990003', 'njohnson@email.com');

INSERT INTO Services (service_type, service_cost, service_duration) VALUES
    ('Swedish Massage',  120.00, '01:00:00'),
    ('Deep Tissue',      140.00, '01:00:00'),
    ('Manicure',          45.00, '00:45:00'),
    ('Pedicure',          55.00, '01:00:00'),
    ('Facial',            90.00, '01:00:00');

INSERT INTO Appointments (appointment_date, appointment_time, service_id, employee_id, client_id) VALUES
    ('2025-06-01', '10:00:00', 1, 1, 1),
    ('2025-06-02', '11:00:00', 3, 2, 2),
    ('2025-06-03', '14:00:00', 5, 3, 3);

-- ============================================================
-- SAMPLE QUERIES
-- ============================================================

-- 1. Full appointment schedule with employee and client names
SELECT
    a.appointment_id,
    a.appointment_date,
    a.appointment_time,
    CONCAT(e.employee_first_name, ' ', e.employee_last_name) AS employee,
    CONCAT(c.client_first_name,   ' ', c.client_last_name)   AS client,
    s.service_type,
    s.service_cost
FROM Appointments a
JOIN Employees e ON a.employee_id = e.employee_id
JOIN Clients   c ON a.client_id   = c.client_id
JOIN Services  s ON a.service_id  = s.service_id
ORDER BY a.appointment_date, a.appointment_time;

-- 2. All employees with their department and certification
SELECT
    CONCAT(e.employee_first_name, ' ', e.employee_last_name) AS employee,
    e.employee_position,
    d.department_type,
    cert.certificate_type,
    cert.certificate_expiration
FROM Employees e
LEFT JOIN Departments  d    ON e.department_id   = d.department_id
LEFT JOIN Certificates cert ON e.certificate_id  = cert.certificate_id;

-- 3. Revenue by service type
SELECT
    s.service_type,
    COUNT(a.appointment_id) AS total_bookings,
    SUM(s.service_cost)     AS total_revenue
FROM Appointments a
JOIN Services s ON a.service_id = s.service_id
GROUP BY s.service_type
ORDER BY total_revenue DESC;

-- 4. Client appointment history
SELECT
    CONCAT(c.client_first_name, ' ', c.client_last_name) AS client,
    a.appointment_date,
    s.service_type,
    s.service_cost
FROM Appointments a
JOIN Clients  c ON a.client_id  = c.client_id
JOIN Services s ON a.service_id = s.service_id
ORDER BY c.client_last_name, a.appointment_date;
