DROP DATABASE IF EXISTS atelierQA;
CREATE DATABASE atelierQA;

CREATE TABLE question(
  id INT,
  product_id INT,
  body VARCHAR(1000),
  date_written DATE,
  asker_name VARCHAR(60),
  asker_email VARCHAR(60),
  reported BOOLEAN,
  helpful BOOLEAN
  );

-- COPY Public."question" from '../Atelier Data Set/questions.csv' DELIMITER ',' CSV HEADER;

-- CREATE TABLE answer(
--   id INT,
--   question_id INT,
--   body VARCHAR(1000),
--   date_written DATE,
--   answerer_name VARCHAR(60),
--   answerer_email VARCHAR(60),
--   reported BOOLEAN,
--   helpful BOOLEAN
--   -- Make question_Id a foreign key
--   -- Find the correct data types for DATE and BOOLEAN
--   -- Figure out how to run this sql file in the terminal to import all the files
-- );

-- CREATE TABLE answer_photo(
--   id INT,
--   answer_id INT,
--   url VARCHAR(255)
--   -- Make answer_id a foreign key
-- );