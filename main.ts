import { PrismaClient } from './generated/prisma/index.js'
import fs from 'fs';
import csv from 'csv-parser';
import { parse } from 'path';

const BATCH_SIZE = 50000;
const prisma = new PrismaClient();
const data_path :string = './data'

async function runETL_agency() {
  const batch: any[] = [];
  const batch2: any[] = [];

  let count: number=0;

  const stream = fs.createReadStream(`${data_path}/caregiver_data_20250415_sanitized.csv`)
                   .pipe(csv());
  for await (const row of stream){
      const transformed ={
         agencyId: row.agency_id,
         franchisorId: row.franchisor_id,
         subdomain: row.subdomain,
      }
      const transformed2 ={
         locationId: parseInt(row.locations_id),
         locationName: row.location_name,
      }
      batch.push(transformed);
      batch2.push(transformed2);

      if (batch.length === BATCH_SIZE) {
        await prisma.agency.createMany({ data: batch, skipDuplicates: true });
        await prisma.location.createMany({ data: batch2, skipDuplicates: true });
        count += batch.length;
        console.log(`✅ ${count} rows inserted`);
        batch.length = 0;
      }
  }
  if (batch.length >0) {
        await prisma.agency.createMany({ data: batch, skipDuplicates: true });
        await prisma.location.createMany({ data: batch2, skipDuplicates: true });
        count += batch.length;
        console.log(`✅ ${count} rows inserted`);
        console.log("✅ All agencies and locations inserted row-by-row.");
  }
}

async function runETL_giver() {
  const batch: any[] = [];

  let count: number=0;

  const stream = fs.createReadStream(`${data_path}/caregiver_data_20250415_sanitized.csv`)
                   .pipe(csv());
  for await (const row of stream){
      const transformed = {
         caregiverId:  row.caregiver_id,
         profileId: row.profile_id, 
         externalId: row.external_id || null,
         firstName:  row.first_name,
         lastName: row.last_name,
         gender: row.gender || null,
         email: row.email || null,
         phoneNumber: row.phone_number || null,
         applicant:  row.applicant === 'TRUE' ? true : false,
         birthdayDate: row.birthday_date ? new Date(row.birthday_date) : null,
         onboardingDate: row.onboarding_date ? new Date(row.onboarding_date) : null,  
         applicantStatus: row.applicant_status,
         status: row.status === 'active' ? true : false,
         agencyId: row.agency_id,
         locationId: parseInt(row.locations_id),
      };
      batch.push(transformed);

      if (batch.length === BATCH_SIZE) {
        await prisma.caregiver.createMany({ data: batch, skipDuplicates: true });
        count += batch.length;
        console.log(`✅ ${count} rows inserted`);
        batch.length = 0;
      }
  }
  if (batch.length >0) {
        await prisma.caregiver.createMany({ data: batch, skipDuplicates: true });
        count += batch.length;
        console.log(`✅ ${count} rows inserted`);
        console.log("✅ All caregivers inserted row-by-row.");
  }
}
async function runETL_log() {
  const batch: any[] = [];

  let count: number=0;

  const stream = fs.createReadStream(`${data_path}/carelog_data_20250415_sanitized.csv`)
                   .pipe(csv());
  for await (const row of stream){
      const start = row.start_datetime ? new Date(row.start_datetime) : null;
      const end = row.end_datetime ? new Date(row.end_datetime) : null;
      const clockIn = row.clock_in_actual_datetime ? new Date(row.clock_in_actual_datetime):null;
      const clockOut = row.clock_out_actual_datetime ? new Date(row.clock_out_actual_datetime):null;

      const transformed = {
        carelogId: row.carelog_id,  
        parentId: row.parent_id || null, 
        caregiverId:  row.caregiver_id,
        startDatetime: start,
        endDatetime:   end,      
        clockInActualDatetime: clockIn,     
        clockOutActualDatetime: clockOut,
        clockInMethod: parseInt(row.clock_in_method) || null,
        clockOutMethod: parseInt(row.clock_out_method) || null,
        overtimeMinutes: calculateOvertimeMinutes(start,end,clockIn,clockOut),
        status: parseInt(row.status),
        split:  row.split === 'TRUE' ? true : false,
        documentation: row.documentation || null,
        generalCommentCharCount: parseInt(row.general_comment_char_count),
      };
      batch.push(transformed);

      if (batch.length === BATCH_SIZE) {
        await prisma.carelog.createMany({ data: batch, skipDuplicates: true });
        count += batch.length;
        console.log(`✅ ${count} rows inserted`);
        batch.length = 0;
      }
  }
  if (batch.length >0) {
        await prisma.carelog.createMany({ data: batch, skipDuplicates: true });
        count += batch.length;
        console.log(`✅ ${count} rows inserted`);
        console.log("✅ All carelogs inserted row-by-row.");
  }
}

//Tracking overtime
function calculateOvertimeMinutes(
  startDatetime?: Date | null,
  endDatetime?: Date | null,
  clockInActualDatetime?: Date | null,
  clockOutActualDatetime?: Date | null
): number | null 
{

  // Validate inputs
  if (!startDatetime || !endDatetime || !clockInActualDatetime || !clockOutActualDatetime) {
    return null // Cannot calculate if any timestamp is missing
  }

  const scheduledMinutes =
    (endDatetime.getTime() - startDatetime.getTime()) / 1000 / 60

  const actualMinutes =
    (clockOutActualDatetime.getTime() - clockInActualDatetime.getTime()) / 1000 / 60

  const overtime = actualMinutes - scheduledMinutes
  return overtime > 0 ? Math.round(overtime) : 0
}


runETL_agency()
.then(async () => {
    runETL_giver()
    .then(async () => {
        runETL_log()
        .then(async () => {
           await prisma.$disconnect()
        })
        .catch(async (err) => {
           await prisma.$disconnect()
           console.error(err)
           process.exit(1)
        })
    })
    .catch(async (err) => {
        await prisma.$disconnect()
        console.error(err)
        process.exit(1)
    })
})
.catch(async (err) => {
    await prisma.$disconnect()
    console.error(err)
    process.exit(1)
})






