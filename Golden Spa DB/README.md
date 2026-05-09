# Golden Spa — Database Design Project

> A relational database design for a full-service day spa, covering employee management, client records, appointment scheduling, service catalog, and department/certification tracking.

---

## Project Overview

Golden Spa is a spa management system designed to support:

- **Employee records** — personal info, hire dates, salaries, department assignments, and professional certifications
- **Client management** — contact info with new vs. returning client detection
- **Appointment scheduling** — linked to employees, clients, and services
- **Service catalog** — types, costs, and durations
- **Department & certification tracking** — structured roles and credential expiration monitoring

---

## Entity-Relationship Diagram

![ER Diagram](docs/er_diagram.png)

> Open `docs/er_diagram.html` in a browser for an interactive version.

---

## Database Schema

Six entities with defined primary and foreign key relationships:

| Table          | Primary Key      | Foreign Keys                              |
|----------------|------------------|-------------------------------------------|
| `Employees`    | `employee_id`    | `department_id`, `certificate_id`         |
| `Certificates` | `certificate_id` | —                                         |
| `Departments`  | `department_id`  | —                                         |
| `Clients`      | `client_id`      | —                                         |
| `Appointments` | `appointment_id` | `service_id`, `employee_id`, `client_id`  |
| `Services`     | `service_id`     | —                                         |

---

## Key Relationships

- One **Department** → Many **Employees** (1:M)
- One **Certificate** → Many **Employees** (1:M)
- One **Employee** → Many **Appointments** (1:M)
- One **Service** → Many **Appointments** (1:M)
- One **Client** → One **Appointment** per booking (1:1 per record)

---

## Files

```
golden-spa-db/
├── sql/
│   └── golden_spa_schema.sql   # Full DDL + sample data + queries
├── docs/
│   └── er_diagram.html         # Interactive ER diagram (open in browser)
└── README.md
```

---

## How to Run

1. Open MySQL Workbench (or any MySQL client)
2. Run `sql/golden_spa_schema.sql`
3. The script will:
   - Create the `golden_spa` database
   - Build all 6 tables with constraints
   - Insert sample data
   - Run 4 sample queries demonstrating key joins

---

## Sample Queries Included

1. **Full appointment schedule** — joins employees, clients, and services
2. **Employee roster** — with department and certification details
3. **Revenue by service type** — aggregated booking totals
4. **Client appointment history** — sorted by client and date

---

## Access Control Design

| Role       | Permissions |
|------------|-------------|
| DBA        | Full access to all tables |
| Employees  | Read/write client info; read appointments |
| Clients    | Self-service: set, cancel, reschedule own appointments via web |

---

## Tools & Technologies

- **Database:** MySQL
- **Design:** Entity-Relationship Modeling
- **Diagram:** Custom HTML/SVG (interactive)

---

*Academic project — Golden Spa fictitious business scenario.*
