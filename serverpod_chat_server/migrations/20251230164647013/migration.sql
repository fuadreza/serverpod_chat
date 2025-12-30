BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "chat_message" (
    "id" bigserial PRIMARY KEY,
    "channelId" bigint NOT NULL,
    "senderId" bigint NOT NULL,
    "message" text NOT NULL,
    "timeSent" timestamp without time zone NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_chat', '20251230164647013', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251230164647013', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();


COMMIT;
