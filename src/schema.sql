.open fittrackpro.sqlite
.mode box

PRAGMA foreign_keys = ON;

CREATE TABLE locations(
    location_id             INTEGER         PRIMARY KEY,
    name                    VARCHAR(255)    NOT NULL,
    address                 VARCHAR(255)    NOT NULL,
    phone_number            VARCHAR(20)     NOT NULL,
    email                   VARCHAR(255)    NOT NULL,
    opening_hours           VARCHAR(30)     NOT NULL
);

CREATE TABLE members(
    member_id               INTEGER         PRIMARY KEY,
    first_name              VARCHAR(255)    NOT NULL,
    last_name               VARCHAR(255)    NOT NULL,
    email                   VARCHAR(255)    NOT NULL,
    phone_number            VARCHAR(20)     NOT NULL,
    date_of_birth           DATE            NOT NULL,
    join_date               DATE            NOT NULL,
    emergency_contact_name  VARCHAR(255)    NOT NULL,
    emergency_contact_phone VARCHAR(20)     NOT NULL
);

CREATE TABLE staff (
    staff_id                INTEGER             PRIMARY KEY,
    first_name              VARCHAR(255)        NOT NULL,
    last_name               VARCHAR(255)        NOT NULL,
    email                   VARCHAR(255)        NOT NULL,
    phone_number            VARCHAR(20)         NOT NULL,
    position                VARCHAR(20)         NOT NULL,
    hire_date               DATE                NOT NULL,
    location_id             INTEGER             NOT NULL,
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE equipment (
    equipment_id            INTEGER             PRIMARY KEY,
    name                    VARCHAR(50)         NOT NULL,
    type                    VARCHAR(20)         NOT NULL,
    purchase_date           DATE                NOT NULL,
    last_maintenance_date   DATE                NOT NULL,
    next_maintenance_date   DATE                NOT NULL,
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
    start_time              VARCHAR(20)         NOT NULL,
    end_time                VARCHAR(20)         NOT NULL,
    FOREIGN KEY(class_id) REFERENCES classes(class_id),
    FOREIGN KEY(staff_id) REFERENCES staff(staff_id)
);

CREATE TABLE memberships (
    membership_id           INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    type                    VARCHAR(20)         NOT NULL,
    start_date              DATE                NOT NULL,
    end_date                DATE                NOT NULL,
    status                  VARCHAR(10)         NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE attendance (
    attendance_id           INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    location_id             INTEGER             NOT NULL,
    check_in_time           VARCHAR(20)         NOT NULL,
    check_out_time          VARCHAR(20)         NOT NULL,
    FOREIGN KEY(member_id)   REFERENCES members(member_id),
    FOREIGN KEY(location_id) REFERENCES locations(location_id)
);

CREATE TABLE class_attendance (
    class_attendance_id     INTEGER             PRIMARY KEY,
    schedule_id             INTEGER             NOT NULL,
    member_id               INTEGER             NOT NULL,
    attendance_status       VARCHAR(20)         NOT NULL,
    FOREIGN KEY(schedule_id) REFERENCES class_schedule(schedule_id),
    FOREIGN KEY(member_id)   REFERENCES members(member_id)
);
 
CREATE TABLE payments (
    payment_id              INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    amount                  DECIMAL             NOT NULL,
    payment_date            VARCHAR(20)         NOT NULL,
    payment_method          VARCHAR(20)         NOT NULL,
    payment_type            VARCHAR(40)         NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE personal_training_sessions (
    session_id              INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    staff_id                INTEGER             NOT NULL,
    session_date            DATE                NOT NULL,
    start_time              VARCHAR(20)         NOT NULL,
    end_time                VARCHAR(20)         NOT NULL,
    notes                   VARCHAR(255)        NOT NULL
    FOREIGN KEY(member_id) REFERENCES members(member_id),
    FOREIGN KEY(staff_id)  REFERENCES staff(staff_id)
);

CREATE TABLE member_health_metrics (
    metric_id               INTEGER             PRIMARY KEY,
    member_id               INTEGER             NOT NULL,
    measurement_date        DATE                NOT NULL
    weight                  DECIMAL             NOT NULL,
    body_fat_percentage     DECIMAL             NOT NULL,
    muscle_mass             DECIMAL             NOT NULL,
    bmi                     DECIMAL             NOT NULL,
    FOREIGN KEY(member_id) REFERENCES members(member_id)
);

CREATE TABLE equipment_maintenance_log (
    log_id                  INTEGER             PRIMARY KEY,
    equipment_id            INTEGER             NOT NULL,
    maintenance_date        DATE                NOT NULL
    description             VARCHAR(255)        NOT NULL
    staff_id                INTEGER             NOT NULL,
    FOREIGN KEY(equipment_id) REFERENCES equipment(equipment_id),
    FOREIGN KEY(staff_id)     REFERENCES staff(staff_id)
);