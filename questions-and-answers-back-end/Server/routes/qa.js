const express = require("express");
const router = express.Router();
const controllers = require('../controllers.js')

//get all questions
// need to make the questions specific to a product ID
router.get("/", controllers.getQuestions)

//get an answer
router.get("/:questions_id/answers", controllers.getAnswers)

module.exports = router;