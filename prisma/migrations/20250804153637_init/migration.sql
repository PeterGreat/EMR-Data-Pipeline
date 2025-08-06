/*
  Warnings:

  - You are about to drop the column `franchisorId` on the `caregivers` table. All the data in the column will be lost.
  - You are about to drop the column `locationName` on the `caregivers` table. All the data in the column will be lost.
  - You are about to drop the column `locationsId` on the `caregivers` table. All the data in the column will be lost.
  - You are about to drop the column `subdomain` on the `caregivers` table. All the data in the column will be lost.
  - You are about to drop the column `agencyId` on the `carelogs` table. All the data in the column will be lost.
  - You are about to drop the column `franchisorId` on the `carelogs` table. All the data in the column will be lost.
  - Added the required column `locationId` to the `caregivers` table without a default value. This is not possible if the table is not empty.

*/
-- DropIndex
DROP INDEX "public"."caregivers_caregiverId_key";

-- DropIndex
DROP INDEX "public"."carelogs_carelogId_key";

-- AlterTable
ALTER TABLE "public"."caregivers" DROP COLUMN "franchisorId",
DROP COLUMN "locationName",
DROP COLUMN "locationsId",
DROP COLUMN "subdomain",
ADD COLUMN     "locationId" INTEGER NOT NULL;

-- AlterTable
ALTER TABLE "public"."carelogs" DROP COLUMN "agencyId",
DROP COLUMN "franchisorId",
ADD COLUMN     "overtimeMinutes" INTEGER;

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

-- CreateIndex
CREATE UNIQUE INDEX "agencies_franchisorId_key" ON "public"."agencies"("franchisorId");

-- AddForeignKey
ALTER TABLE "public"."caregivers" ADD CONSTRAINT "caregivers_agencyId_fkey" FOREIGN KEY ("agencyId") REFERENCES "public"."agencies"("agencyId") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "public"."caregivers" ADD CONSTRAINT "caregivers_locationId_fkey" FOREIGN KEY ("locationId") REFERENCES "public"."locations"("locationId") ON DELETE RESTRICT ON UPDATE CASCADE;
