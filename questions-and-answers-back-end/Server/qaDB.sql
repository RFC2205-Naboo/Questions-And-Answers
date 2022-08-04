DROP TABLE IF EXISTS answer_photo;
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS question;

CREATE TABLE question(
  id SERIAL PRIMARY KEY,
  product_id INT,
  body VARCHAR(1000),
  date_written BIGINT,
  asker_name VARCHAR(60),
  asker_email VARCHAR(60),
  reported SMALLINT,
  helpful INT
  );

COPY "question" from '/Users/T-Spoon/SDC - Project Naboo/questions-and-answers-back-end/Atelier Data Set/questions.csv' DELIMITER ',' CSV HEADER;

-- Adding the new column
ALTER TABLE question ADD date_written_placeholder TEXT;

-- Updating the question
UPDATE question
SET date_written_placeholder = TO_CHAR(to_timestamp(date_written / 1000), 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');

-- Dropping the table
ALTER TABLE question RENAME COLUMN date_written TO date_written_placeholder_2;
ALTER TABLE question RENAME COLUMN date_written_placeholder TO date_written;
ALTER TABLE question DROP COLUMN date_written_placeholder_2;
-- ALTER TABLE question ALTER date_written TYPE TIMESTAMP USING date_written::timestamp;

-- recasting the reported
ALTER TABLE question ALTER COLUMN reported DROP DEFAULT;
ALTER TABLE question ALTER reported TYPE bool USING CASE WHEN reported = 0 THEN FALSE ELSE TRUE END;
ALTER TABLE question ALTER COLUMN reported SET DEFAULT FALSE;



CREATE TABLE answer(
  id SERIAL PRIMARY KEY,
  question_id INT,
  body VARCHAR(1000),
  date_written BIGINT,
  answerer_name VARCHAR(60),
  answerer_email VARCHAR(60),
  reported SMALLINT,
  helpful INT,
  CONSTRAINT fk_question
    FOREIGN KEY (question_id)
      REFERENCES "question"(id)
);

COPY "answer" from '/Users/T-Spoon/SDC - Project Naboo/questions-and-answers-back-end/Atelier Data Set/answers.csv' DELIMITER ',' CSV HEADER;

-- Adding the new column
ALTER TABLE answer ADD date_written_placeholder TEXT;

-- Updating the answer
UPDATE answer
SET date_written_placeholder = TO_CHAR(to_timestamp(date_written / 1000), 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');

-- Dropping the table
ALTER TABLE answer RENAME COLUMN date_written TO date_written_placeholder_2;
ALTER TABLE answer RENAME COLUMN date_written_placeholder TO date_written;
ALTER TABLE answer DROP COLUMN date_written_placeholder_2;
-- ALTER TABLE answer ALTER date_written TYPE TIMESTAMP USING date_written::timestamp;

-- recasting the reported
ALTER TABLE answer ALTER COLUMN reported DROP DEFAULT;
ALTER TABLE answer ALTER reported TYPE bool USING CASE WHEN reported = 0 THEN FALSE ELSE TRUE END;
ALTER TABLE answer ALTER COLUMN reported SET DEFAULT FALSE;


CREATE TABLE answer_photo(
  id SERIAL PRIMARY KEY,
  answer_id INT,
  url VARCHAR(255),
  CONSTRAINT fk_answer
    FOREIGN KEY (answer_id)
      REFERENCES "answer"(id)
);

COPY "answer_photo" from '/Users/T-Spoon/SDC - Project Naboo/questions-and-answers-back-end/Atelier Data Set/answers_photos.csv' DELIMITER ',' CSV HEADER;
