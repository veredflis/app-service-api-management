SET DB_CLOSE_DELAY -1;        
;             
CREATE USER IF NOT EXISTS "SA" SALT '7b2b706e36610fd9' HASH '63c547e06b5db43d465ef3a6b17bcef198d3a69eff9f4fe50b9139e25365c3dc' ADMIN;         
CREATE MEMORY TABLE "PUBLIC"."flyway_schema_history"(
    "installed_rank" INT NOT NULL,
    "version" VARCHAR(50),
    "description" VARCHAR(200) NOT NULL,
    "type" VARCHAR(20) NOT NULL,
    "script" VARCHAR(1000) NOT NULL,
    "checksum" INT,
    "installed_by" VARCHAR(100) NOT NULL,
    "installed_on" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    "execution_time" INT NOT NULL,
    "success" BOOLEAN NOT NULL
);             
ALTER TABLE "PUBLIC"."flyway_schema_history" ADD CONSTRAINT "PUBLIC"."flyway_schema_history_pk" PRIMARY KEY("installed_rank");
-- 2 +/- SELECT COUNT(*) FROM PUBLIC.flyway_schema_history;   
INSERT INTO "PUBLIC"."flyway_schema_history" VALUES
(-1, NULL, '<< Flyway Schema History table created >>', 'TABLE', '', NULL, 'SA', TIMESTAMP '2020-04-28 23:11:53.56', 0, TRUE),
(1, '1', 'create tables', 'SQL', 'V1__create_tables.sql', 1574026340, 'SA', TIMESTAMP '2020-04-28 23:11:53.628', 7, TRUE);               
CREATE INDEX "PUBLIC"."flyway_schema_history_s_idx" ON "PUBLIC"."flyway_schema_history"("success");           
CREATE MEMORY TABLE "PUBLIC"."USERS"(
    "ID" VARCHAR(255) NOT NULL,
    "USERNAME" VARCHAR(255),
    "PASSWORD" VARCHAR(255),
    "EMAIL" VARCHAR(255),
    "BIO" TEXT,
    "IMAGE" VARCHAR(511)
);  
ALTER TABLE "PUBLIC"."USERS" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_4" PRIMARY KEY("ID");        
-- 2 +/- SELECT COUNT(*) FROM PUBLIC.USERS;   
INSERT INTO "PUBLIC"."USERS" VALUES
('9c5e5343-d09b-4233-9219-0e8975e910a6', 'jason', 'example', 'jasonfreeberg@gmail.com', '', 'https://static.productionready.io/images/smiley-cyrus.jpg'),
('7c00e5ff-baf7-4040-a948-c408e0d86ce5', 'Melissa', 'example', 'melissa@gmail.com', '', 'https://static.productionready.io/images/smiley-cyrus.jpg');         
CREATE MEMORY TABLE "PUBLIC"."ARTICLES"(
    "ID" VARCHAR(255) NOT NULL,
    "USER_ID" VARCHAR(255),
    "SLUG" VARCHAR(255),
    "TITLE" VARCHAR(255),
    "DESCRIPTION" TEXT,
    "BODY" TEXT,
    "CREATED_AT" TIMESTAMP NOT NULL,
    "UPDATED_AT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);               
ALTER TABLE "PUBLIC"."ARTICLES" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_E" PRIMARY KEY("ID");     
-- 2 +/- SELECT COUNT(*) FROM PUBLIC.ARTICLES;
INSERT INTO "PUBLIC"."ARTICLES" VALUES
('7ebf31ad-c186-454f-a2ec-9b2742f3f73d', '9c5e5343-d09b-4233-9219-0e8975e910a6', 'new-business-hours', 'New business hours', 'Due to recent events, our hours have changed', 'Our hours are now from 10:00am to 4:00pm Monday to Friday. We will be closed on weekends until May 15th.', TIMESTAMP '2020-04-29 06:19:04.665', TIMESTAMP '2020-04-29 06:19:04.665'),
('d8c21670-2c8d-4d5d-bd6a-8edac076a7a4', '7c00e5ff-baf7-4040-a948-c408e0d86ce5', 'no-contact-delivery', 'No contact delivery', 'Contoso has safe and quick delivery options', 'Call ahead to pick up your order at our curbside. ', TIMESTAMP '2020-04-29 06:21:25.175', TIMESTAMP '2020-04-29 06:21:25.175');   
CREATE MEMORY TABLE "PUBLIC"."ARTICLE_FAVORITES"(
    "ARTICLE_ID" VARCHAR(255) NOT NULL,
    "USER_ID" VARCHAR(255) NOT NULL
);           
ALTER TABLE "PUBLIC"."ARTICLE_FAVORITES" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_5" PRIMARY KEY("ARTICLE_ID", "USER_ID");         
-- 1 +/- SELECT COUNT(*) FROM PUBLIC.ARTICLE_FAVORITES;       
INSERT INTO "PUBLIC"."ARTICLE_FAVORITES" VALUES
('7ebf31ad-c186-454f-a2ec-9b2742f3f73d', '7c00e5ff-baf7-4040-a948-c408e0d86ce5');            
CREATE MEMORY TABLE "PUBLIC"."FOLLOWS"(
    "USER_ID" VARCHAR(255) NOT NULL,
    "FOLLOW_ID" VARCHAR(255) NOT NULL
);      
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.FOLLOWS; 
CREATE MEMORY TABLE "PUBLIC"."TAGS"(
    "ID" VARCHAR(255) NOT NULL,
    "NAME" VARCHAR(255)
);            
ALTER TABLE "PUBLIC"."TAGS" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_2" PRIMARY KEY("ID");         
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.TAGS;    
CREATE MEMORY TABLE "PUBLIC"."ARTICLE_TAGS"(
    "ARTICLE_ID" VARCHAR(255) NOT NULL,
    "TAG_ID" VARCHAR(255) NOT NULL
); 
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.ARTICLE_TAGS;            
CREATE MEMORY TABLE "PUBLIC"."COMMENTS"(
    "ID" VARCHAR(255) NOT NULL,
    "BODY" TEXT,
    "ARTICLE_ID" VARCHAR(255),
    "USER_ID" VARCHAR(255),
    "CREATED_AT" TIMESTAMP NOT NULL,
    "UPDATED_AT" TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);             
ALTER TABLE "PUBLIC"."COMMENTS" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_A" PRIMARY KEY("ID");     
-- 0 +/- SELECT COUNT(*) FROM PUBLIC.COMMENTS;
ALTER TABLE "PUBLIC"."USERS" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_4D" UNIQUE("USERNAME");      
ALTER TABLE "PUBLIC"."ARTICLES" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_E5" UNIQUE("SLUG");       
ALTER TABLE "PUBLIC"."USERS" ADD CONSTRAINT "PUBLIC"."CONSTRAINT_4D4" UNIQUE("EMAIL");        
