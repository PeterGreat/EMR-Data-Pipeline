# EMR-Data-Pipeline
A new repo for EMR data pipeline

### Submission Checklist
1. ETL code(TypeScript): `./main.ts`
2. Database schema: `./prisma/schema.prisma` and `./schema.sql`
3. SQL queries+sample outputs: `Query.PDF`
4. ai_prompts.md: `./ai_prompts.md`
5. README: `./README.md`
 
### Sculpt the project
I refer to this site 
https://www.prisma.io/docs/getting-started/quickstart-sqlite

and this site
https://www.prisma.io/docs/getting-started/setup-prisma/start-from-scratch/relational-databases-typescript-postgresql

for building up the project.

### Import data files
Copy CSV data files 
`caregiver_data_20250415_sanitized.csv`,
`carelog_data_20250415_sanitized.csv` into `./data` folder.
This step is very important!

### Node version: 
v22.13.0

### Install all packages
```bash
npm install
```

### Run the Postgres Server
```bash
docker-compose up -d
```
This step requires Docker. And Postgres will listen to port 5432 by default.

### Data Migrigation
```bash
npm run migrate
```
This step will migrate prisma schema into database and create Prisma Client.


### Login the Postgres Command Line environment
```bash
psql -h localhost -U user -d EMR_DATA
```
The login password is 'password', which is given in 'docker-compose.yml'.


### Running the ETL pipeline program
```bash
npm start
```
This step will do the ETL pipeline and load the provided CSV data into PostgreSQL database.
It will take several miniutes to load the data.


## Generate schema.sql DDL from Prisma schema
```bash
npm run schema
```

### Schema Design Rationale
According to the CSV data file `caregiver_data_20250415_sanitized.csv` and `carelog_data_20250415_sanitized.csv` and their data structure, I have designed four schema model. They are Carelog, Caregiver, Agency and Location respectively. The schema models are presented in `./prisma/schema.prisma` and `schema.sql`,and the latter can be generated from the former. 

Among four models, Carelog is related to Caregiver by `caregiverId`, while Caregiver is related to Agency by `agencyId` and related to Location by `locationId`. In this setup, agencies and locations are stored in separate tables, reducing storage requirements and improving data normalization.

An additional field, `overtimeMinutes`, has been added to the Carelog model. It calculates the time difference between the actual time a caregiver spent during a specific visit and the originally scheduled duration.

### Assumptions & Edge Cases
Some data are missing in the CSV files, so we allow these fields to be null on the schema level (adding question mark behind the field type).
On the application level, when we import CSV data into the Postgres database, we also check null/undefined values before we actually load that data into the database.

Moreover, all the date/time related fields have been standardized to Date object in typescript before being loaded into the database.
Inconsistent timestamps are handled on SQL query level, which also depends on concrete problems involved.


### Scalability & Performance
In the `main.ts` source file, our ETL pipline loads the CSV data into the database batch by batch.  As the dataset size grows, we can increase the BATCH_SIZE accordingly, with minimal impact on overall performance.
By this approach, we ensure the scalability and performance of the application.