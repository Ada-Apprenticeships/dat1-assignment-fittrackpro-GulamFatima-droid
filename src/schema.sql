.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS locations;
DROP TABLE IF EXISTS members;
DROP TABLE IF EXISTS staff;
DROP TABLE IF EXISTS equipment;
DROP TABLE IF EXISTS classes;
DROP TABLE IF EXISTS class_schedule;
DROP TABLE IF EXISTS memberships;
DROP TABLE IF EXISTS attendance;
DROP TABLE IF EXISTS class_attendance;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS personal_training_sessions;
DROP TABLE IF EXISTS member_health_metrics;
DROP TABLE IF EXISTS equipment_maintenance_log;


CREATE TABLE locations(
    location_id             INTEGER         PRIMARY KEY,
    name                    VARCHAR(255)    NOT NULL,
    address                 VARCHAR(255)    NOT NULL,
    phone_number            VARCHAR(20)     NOT NULL,
    email                   VARCHAR(255)    CHECK (email LIKE '%@%.%')  NOT NULL,
    opening_hours           VARCHAR(30)     NOT NULL
);

CREATE TABLE members(
    member_id               INTEGER         PRIMARY KEY,
    first_name              VARCHAR(255)    NOT NULL,
    last_name               VARCHAR(255)    NOT NULL,
    email                   VARCHAR(255)    CHECK (email LIKE '%@%.%')  NOT NULL,
    phone_number            VARCHAR(20)     NOT NULL,
    date_of_birth           DATE            NOT NULL,
    join_date               DATE            CHECK (join_date > date_of_birth)  NOT NULL,
    emergency_contact_name  VARCHAR(255)    NOT NULL,
    emergency_contact_phone VARCHAR(20)     NOT NULL
);

CREATE TABLE staff (
    staff_id                INTEGER             PRIMARY KEY,
    first_name              VARCHAR(255)        NOT NULL,
    last_name               VARCHAR(255)        NOT NULL,
    email                   VARCHAR(255)        CHECK (email LIKE '%@%.%')  NOT NULL,
    phone_number            VARCHAR(20)         NOT NULL,
    position                VARCHAR(20)         CHECK (position IN ('Trainer', 'Manager', 'Receptionist', 'Maintenance'))  NOT NULL,
    hire_date               DATE                NOT NULL,
    location_id             INTEGER             NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id            INTEGER             PRIMARY KEY,
    name                    VARCHAR(50)         NOT NULL,
    type                    VARCHAR(20)         CHECK (type IN ('Cardio', 'Strength'))  NOT NULL,
    purchase_date           DATE                NOT NULL,
    last_maintenance_date   DATE                CHECK (last_maintenance_date > purchase_date)  NOT NULL,
    next_maintenance_date   DATE                CHECK (next_maintenance_date > last_maintenance_date)  NOT NULL,
    location_id             INTEGER             NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE classes (
    class_id                INTEGER             PRIMARY KEY,
    name                    VARCHAR(255)        NOT NULL,
    description             VARCHAR(255)        NOT NULL,
    capacity                INTEGER             NOT NULL,
    duration                INTEGER             NOT NULL,
    location_id             INTEGER             NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_schedule (
    schedule_id             INTEGER             PRIMARY KEY,
    class_id                INTEGER             NOT NULL,
    staff_id                INTEGER             NOT NULL,
    start_time              DATETIME            NOT NULL,
    end_time                DATETIME            CHECK (end_time > start_time)  NOT NULL,
    FOREIGN KEY(class_id) REFERENCES classes(class_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id           INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    type                    VARCHAR(20)         CHECK (type IN ('Premium', 'Basic'))  NOT NULL,
    start_date              DATE                NOT NULL,
    end_date                DATE                CHECK (end_date > start_date)  NOT NULL,
    status                  VARCHAR(10)         CHECK (status IN ('Active', 'Inactive'))  NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id           INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    location_id             INTEGER             NOT NULL,
    check_in_time           DATETIME            NOT NULL,
    check_out_time          DATETIME            CHECK (check_out_time > check_in_time)  NOT NULL,
    FOREIGN KEY(member_id)   REFERENCES members(member_id),
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id     INTEGER             PRIMARY KEY,
    schedule_id             INTEGER             NOT NULL,
    member_id               INTEGER             NOT NULL,
    attendance_status       VARCHAR(20)         CHECK (attendance_status IN ('Registered', 'Attended', 'Unattended'))  NOT NULL,
    FOREIGN KEY(schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY(member_id)   REFERENCES members(member_id)
);
 
CREATE TABLE payments (
    payment_id              INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    amount                  REAL                CHECK (amount = ROUND(amount, 2))  NOT NULL,
    payment_date            DATETIME            NOT NULL,
    payment_method          VARCHAR(20)         CHECK (payment_method IN ('Credit Card', 'Bank Transfer', 'PayPal', 'Cash'))  NOT NULL,
    payment_type            VARCHAR(40)         CHECK (payment_type IN ('Monthly membership fee', 'Day pass'))  NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id              INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    staff_id                INTEGER             NOT NULL,
    session_date            DATE                NOT NULL,
    start_time              VARCHAR(20)         NOT NULL,
    end_time                VARCHAR(20)         CHECK (end_time > start_time)  NOT NULL,
    notes                   VARCHAR(255)        NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id),
    FOREIGN KEY(staff_id)  REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id               INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    measurement_date        DATE                NOT NULL,
    weight                  REAL                CHECK (weight = ROUND(weight, 1))  NOT NULL,
    body_fat_percentage     REAL                CHECK (body_fat_percentage = ROUND(body_fat_percentage, 1))  NOT NULL,
    muscle_mass             REAL                CHECK (muscle_mass = ROUND(muscle_mass, 1))  NOT NULL,
    bmi                     REAL                CHECK (bmi = ROUND(bmi, 1))  NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id                  INTEGER             PRIMARY KEY,
    equipment_id            INTEGER             NOT NULL,
    maintenance_date        DATE                NOT NULL,
    description             VARCHAR(255)        NOT NULL,
    staff_id                INTEGER             NOT NULL,
    FOREIGN KEY(equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY(staff_id)     REFERENCES staff(staff_id)
);