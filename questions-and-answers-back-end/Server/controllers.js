const pool = require("../Database")

const getQuestions = async (req, res) => {
  try {
    let productIdString = req.query.product_id;
    let productIdNum = parseInt(req.query.product_id, 10);
    let count = parseInt(req.query.count, 10) || 5;
    var page = parseInt(req.query.page, 10) - 1 || 1;
    page = page * count;
    const allQuestions = await pool.query(
    `SELECT $1 AS product_id,
    (SELECT json_agg(row_to_json(t)) AS results
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
            FROM answer LEFT JOIN answer_photo ON answer.id = answer_photo.answer_id
            WHERE answer.question_id = question.id GROUP BY answer.id ORDER BY date ASC
          ) t
        ) FROM question
        WHERE question.product_id = $2
        LIMIT $4
        OFFSET $5
      ) t)
    FROM question WHERE question.product_id = $3 GROUP BY question.product_id;`, [productIdString, productIdNum, productIdNum, count, page]);
    res.json(allQuestions.rows);
  } catch (error) {
    console.error(error.message)
  }
}


const getAnswers = async (req, res) => {
  try {
    let questionIdString = req.params.questions_id;
    let questionIdNum = parseInt(req.params.questions_id, 10);
    let count = parseInt(req.query.count, 10) || 5;
    let pageCount = parseInt(req.query.page, 10) || 1;
    let pageOffset = (pageCount - 1)* count;
    const answers = await pool.query(
      `SELECT
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
            ORDER BY date ASC
            LIMIT $5
            OFFSET $6
          ) t
      );`, [questionIdString, pageCount, count, questionIdNum, count, pageOffset])
    res.json(answers.rows);
  } catch (error) {
    console.error(error.message);
  }
}

module.exports = {
  getQuestions,
  getAnswers,
}