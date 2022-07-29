const pool = require("../Database")

const getQuestions = async (req, res) => {
  try {
    console.log(req.params)
    const allQuestions = await pool.query("SELECT * FROM question LIMIT 10");
    res.json(allQuestions.rows);
  } catch (error) {
    console.error(error.message)
  }
}


const getAnswers = async (req, res) => {
  try {
    const answers = await pool.query("SELECT * FROM answer WHERE answer.question_id = $1 LIMIT 10", [req.params.questions_id])
    res.json(answers.rows);
  } catch (error) {
    console.error(error.message);
  }
}

module.exports = {
  getQuestions,
  getAnswers,
}