# AI Usage Log

## 1. Prompt: 
"For Postgres, I want to use docker"

- Influenced file: `docker-compose.yml`
- Modified: adjust the value of `volumes` field  

## 2. Prompt: 
"Now we need to load data patchly"

- Influenced file: `main.ts`
- Modified: AI generates `runETL()` function, which is modified to be adapted to the schema models. The most important thing is table insertion order. 
 
## 3. Prompt:
  For the SQL queries part, I write criteria or definitions myself for a certain question. Then I use the criteria or definition as prompt and the AI helps generate the correponding SQL queries. Then I will test that query in the `psql` environment of Postgres database to ensure it can run successfully and give the proper query results.  Frequently I will modify the generated query in case it cannot run.