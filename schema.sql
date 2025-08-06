-- CreateSchema
CREATE SCHEMA IF NOT EXISTS "public";

-- CreateTable
CREATE TABLE "public"."carelogs" (
    "carelogId" TEXT NOT NULL,
    "parentId" TEXT,
    "startDatetime" TIMESTAMP(3),
    "endDatetime" TIMESTAMP(3),
    "clockInActualDatetime" TIMESTAMP(3),
    "clockOutActualDatetime" TIMESTAMP(3),
    "overtimeMinutes" INTEGER,
    "clockInMethod" INTEGER,
    "clockOutMethod" INTEGER,
    "status" INTEGER NOT NULL,
    "split" BOOLEAN NOT NULL,
    "documentation" TEXT,
    "generalCommentCharCount" INTEGER NOT NULL,
    "caregiverId" TEXT NOT NULL,

    CONSTRAINT "carelogs_pkey" PRIMARY KEY ("carelogId")
);

-- CreateTable
CREATE TABLE "public"."caregivers" (
    "caregiverId" TEXT NOT NULL,
    "profileId" TEXT NOT NULL,
    "externalId" TEXT,
    "agencyId" TEXT NOT NULL,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "gender" TEXT,
    "email" TEXT,
    "phoneNumber" TEXT,
    "applicant" BOOLEAN NOT NULL,
    "birthdayDate" TIMESTAMP(3),
    "onboardingDate" TIMESTAMP(3),
    "locationId" INTEGER NOT NULL,
    "applicantStatus" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL,

    CONSTRAINT "caregivers_pkey" PRIMARY KEY ("caregiverId")
);

-- CreateTable
CREATE TABLE "public"."agencies" (
    "agencyId" TEXT NOT NULL,
    "franchisorId" TEXT NOT NULL,
    "subdomain" TEXT NOT NULL,

    CONSTRAINT "agencies_pkey" PRIMARY KEY ("agencyId")
);

-- CreateTable
CREATE TABLE "public"."locations" (
    "locationId" INTEGER NOT NULL,
    "locationName" TEXT NOT NULL,

    CONSTRAINT "locations_pkey" PRIMARY KEY ("locationId")
);

-- AddForeignKey
ALTER TABLE "public"."carelogs" ADD CONSTRAINT "carelogs_caregiverId_fkey" FOREIGN KEY ("caregiverId") REFERENCES "public"."caregivers"("caregiverId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."caregivers" ADD CONSTRAINT "caregivers_agencyId_fkey" FOREIGN KEY ("agencyId") REFERENCES "public"."agencies"("agencyId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."caregivers" ADD CONSTRAINT "caregivers_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("locationId") ON DELETE RESTRICT ON UPDATE CASCADE;

