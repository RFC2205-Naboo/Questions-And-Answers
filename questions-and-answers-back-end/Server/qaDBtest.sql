-- third nested object photos
SELECT json_agg(row_to_json(t))
FROM (
	SELECT answer_photo.id AS id,
	answer_photo.url AS url
	FROM answer_photo
	WHERE answer_photo.answer_id = 5
) t;

-- second nested object results
SELECT row_to_json(t)
FROM (
	SELECT
	answer.id AS answer_id,
	answer.body AS body,
	answer.date_written AS date,
	answer.answerer_name AS answerer_name,
	answer.helpful AS helpfulness,
	(
		SELECT json_agg(row_to_json(t)) AS photos
			FROM (
			SELECT answer_photo.id AS id,
			answer_photo.url AS url
			FROM answer_photo
			WHERE answer_photo.answer_id = answer.id
			) t
	)
	FROM answer
	LEFT JOIN answer_photo ON answer.id = answer_photo.answer_id
	WHERE answer.question_id = 1
	GROUP BY answer.id
	ORDER BY date DESC
) t;

-- first nested object with the rest for the answer GET
SELECT row_to_json(t)
FROM (
	SELECT
  -- need variables here for the question, page and count
	'1' AS question,
	0 AS page,
	5 AS count,
	(
    SELECT json_agg(row_to_json(t)) AS results
      FROM (
        SELECT
        answer.id AS answer_id,
        answer.body AS body,
        answer.date_written AS date,
        answer.answerer_name AS answerer_name,
        answer.helpful AS helpfulness,
        (
          SELECT json_agg(row_to_json(t)) AS photos
            FROM (
              SELECT answer_photo.id AS id,
              answer_photo.url AS url
              FROM answer_photo
              WHERE answer_photo.answer_id = answer.id
            ) t
        )
        FROM answer
        LEFT JOIN answer_photo ON answer.id = answer_photo.answer_id
        -- need the same variable as before here to match this WHERE to the above question variable
        WHERE answer.question_id = 1
        GROUP BY answer.id
        ORDER BY date DESC
      ) t
  )
) t;

-- second nested object for questions
SELECT row_to_json(t)
FROM (
	SELECT
	question.id AS question_id,
	question.body AS question_body,
	question.date_written AS question_date,
	question.asker_name AS asker_name,
	question.reported AS reported,
	(
    SELECT json_object_agg(id, row_to_json(t)) AS answers
      FROM (
          SELECT
          answer.id AS id,
          answer.body AS body,
          answer.date_written AS date,
          answer.answerer_name AS answerer_name,
          answer.helpful AS helpfulness,
          (
            SELECT json_agg(row_to_json(t)) AS photos
            FROM (
              SELECT answer_photo.id AS id,
              answer_photo.url AS url
              FROM answer_photo
              WHERE answer_photo.answer_id = answer.id
            ) t
          )
          FROM answer
          LEFT JOIN answer_photo ON answer.id = answer_photo.answer_id
          -- need the same variable as before here to match this WHERE to the above question variable
          WHERE answer.question_id = question.id
          GROUP BY answer.id
          ORDER BY date DESC
      ) t
  )
	FROM question
-- 	change this to a dynamic product_id after testing
	WHERE question.product_id = 1
) t;



-- Final nested object for question GET query
SELECT row_to_json(t)
FROM (
-- 	Product_id needs to be pulled
	SELECT question.product_id AS product_id,
	(
	SELECT json_agg(row_to_json(t)) AS results
		FROM (
			SELECT
			question.id AS question_id,
			question.body AS question_body,
			question.date_written AS question_date,
			question.asker_name AS asker_name,
			question.reported AS reported,
			(
			SELECT json_object_agg(id, row_to_json(t)) AS answers
			  FROM (
				  SELECT
				  answer.id AS id,
				  answer.body AS body,
				  answer.date_written AS date,
				  answer.answerer_name AS answerer_name,
				  answer.helpful AS helpfulness,
				  (
					SELECT json_agg(row_to_json(t)) AS photos
					FROM (
					  SELECT answer_photo.id AS id,
					  answer_photo.url AS url
					  FROM answer_photo
					  WHERE answer_photo.answer_id = answer.id
					) t
				  )
				  FROM answer
				  LEFT JOIN answer_photo ON answer.id = answer_photo.answer_id
				  -- need the same variable as before here to match this WHERE to the above question variable
				  WHERE answer.question_id = question.id
				  GROUP BY answer.id
				  ORDER BY date DESC
			  ) t
		  )
			FROM question
		-- 	change this to a dynamic product_id after testing
			WHERE question.product_id = 1
		) t
	)
	FROM question
-- 	Can be removed
	WHERE question.product_id = 1
	GROUP BY question.product_id
) t;

-- Altering the table
ALTER TABLE question ALTER COLUMN date_written TYPE BIGINT USING date_written::BIGINT;

-- Updating the question
UPDATE question
SET date_written = TO_CHAR(to_timestamp(date_written / 1000), 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');

-- example of select with the big int side by side
SELECT question.date_written, TO_CHAR(to_timestamp(question.date_written / 1000), 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"')
from question where question.id = 1;

-- just the date
SELECT TO_CHAR(to_timestamp(date_written / 1000), 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');

-- updating the answer
UPDATE answer
SET date_written = TO_CHAR(to_timestamp(date_written / 1000), 'YYYY-MM-DD"T"HH24:MI:SS.MS"Z"');


-- Written for the controller query for answers GET
SELECT
	$1 AS question,
	$2 AS page,
	$3 AS count,
	(
    SELECT json_agg(row_to_json(t)) AS results
      FROM (
        SELECT
        answer.id AS answer_id,
        answer.body AS body,
        answer.date_written AS date,
        answer.answerer_name AS answerer_name,
        answer.helpful AS helpfulness,
        (
          SELECT json_agg(row_to_json(t)) AS photos
            FROM (
              SELECT answer_photo.id AS id,
              answer_photo.url AS url
              FROM answer_photo
              WHERE answer_photo.answer_id = answer.id
            ) t
        )
        FROM answer
        LEFT JOIN answer_photo ON answer.id = answer_photo.answer_id
        WHERE answer.question_id = $4
        GROUP BY answer.id
        ORDER BY date DESC
      ) t
  );