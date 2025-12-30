BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "channels" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_chat', '20251230154549705', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251230154549705', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
