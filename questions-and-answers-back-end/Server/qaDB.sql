DROP TABLE IF EXISTS answer_photo;
DROP TABLE IF EXISTS answer;
DROP TABLE IF EXISTS question;

CREATE TABLE question(
  id SERIAL PRIMARY KEY,
  product_id INT,
  body VARCHAR(1000),
  date_written TEXT,
  asker_name VARCHAR(60),
  asker_email VARCHAR(60),
  reported INT,
  helpful INT
  -- reported is an int with a boolean 0 or 1 binary
  -- Helpful is a count of number of likes
  -- Need to figure out how to transform the date_written
  );

COPY "question" from '/Users/T-Spoon/SDC - Project Naboo/questions-and-answers-back-end/Atelier Data Set/questions.csv' DELIMITER ',' CSV HEADER;

CREATE TABLE answer(
  id SERIAL PRIMARY KEY,
  question_id INT,
  body VARCHAR(1000),
  date_written TEXT,
  answerer_name VARCHAR(60),
  answerer_email VARCHAR(60),
  reported INT,
  helpful INT,
  CONSTRAINT fk_question
    FOREIGN KEY (question_id)
      REFERENCES "question"(id)
  -- Make question_Id a foreign key
  -- Find the correct data types for DATE and BOOLEAN
  -- Figure out how to run this sql file in the terminal to import all the files
);

COPY "answer" from '/Users/T-Spoon/SDC - Project Naboo/questions-and-answers-back-end/Atelier Data Set/answers.csv' DELIMITER ',' CSV HEADER;


CREATE TABLE answer_photo(
  id SERIAL PRIMARY KEY,
  answer_id INT,
  url VARCHAR(255),
  CONSTRAINT fk_answer
    FOREIGN KEY (answer_id)
      REFERENCES "answer"(id)
  -- Make answer_id a foreign key
);

COPY "answer_photo" from '/Users/T-Spoon/SDC - Project Naboo/questions-and-answers-back-end/Atelier Data Set/answers_photos.csv' DELIMITER ',' CSV HEADER;