/*
  Warnings:

  - You are about to drop the `Post` table. If the table is not empty, all the data it contains will be lost.
  - You are about to drop the `User` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropForeignKey
ALTER TABLE "public"."Post" DROP CONSTRAINT "Post_authorId_fkey";

-- DropTable
DROP TABLE "public"."Post";

-- DropTable
DROP TABLE "public"."User";

-- CreateTable
CREATE TABLE "public"."caregivers" (
    "caregiverId" TEXT NOT NULL,
    "franchisorId" TEXT NOT NULL,
    "agencyId" TEXT NOT NULL,
    "subdomain" TEXT NOT NULL,
    "profileId" TEXT NOT NULL,
    "externalId" TEXT,
    "firstName" TEXT NOT NULL,
    "lastName" TEXT NOT NULL,
    "gender" TEXT,
    "email" TEXT NOT NULL,
    "phoneNumber" TEXT NOT NULL,
    "applicant" BOOLEAN NOT NULL,
    "birthdayDate" TIMESTAMP(3),
    "onboardingDate" TIMESTAMP(3),
    "locationName" TEXT NOT NULL,
    "locationsId" INTEGER NOT NULL,
    "applicantStatus" TEXT NOT NULL,
    "status" BOOLEAN NOT NULL,

    CONSTRAINT "caregivers_pkey" PRIMARY KEY ("caregiverId")
);

-- CreateTable
CREATE TABLE "public"."carelogs" (
    "carelogId" TEXT NOT NULL,
    "franchisorId" TEXT NOT NULL,
    "agencyId" TEXT NOT NULL,
    "parentId" TEXT,
    "startDatetime" TIMESTAMP(3) NOT NULL,
    "endDatetime" TIMESTAMP(3) NOT NULL,
    "clockInActualDatetime" TIMESTAMP(3) NOT NULL,
    "clockOutActualDatetime" TIMESTAMP(3) NOT NULL,
    "clockInMethod" INTEGER NOT NULL,
    "clockOutMethod" INTEGER NOT NULL,
    "status" INTEGER NOT NULL,
    "split" BOOLEAN NOT NULL,
    "documentation" TEXT,
    "generalCommentCharCount" INTEGER NOT NULL,
    "caregiverId" TEXT NOT NULL,

    CONSTRAINT "carelogs_pkey" PRIMARY KEY ("carelogId")
);

-- CreateIndex
CREATE UNIQUE INDEX "caregivers_caregiverId_key" ON "public"."caregivers"("caregiverId");

-- CreateIndex
CREATE UNIQUE INDEX "carelogs_carelogId_key" ON "public"."carelogs"("carelogId");

-- AddForeignKey
ALTER TABLE "public"."carelogs" ADD CONSTRAINT "carelogs_caregiverId_fkey" FOREIGN KEY ("caregiverId") REFERENCES "public"."caregivers"("caregiverId") ON DELETE RESTRICT ON UPDATE CASCADE;
