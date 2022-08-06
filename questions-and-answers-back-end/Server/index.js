/* ==== External Modules === */
const express = require("express");
const path = require("path");
require("dotenv").config({path: path.resolve(__dirname, '../.env')})
const cors = require("cors");


/* ==== Internal Modules === */
const app = express();
const PORT = process.env.PORT || 3000;

/* ==== Middleware === */
app.use(cors());
app.use(express.json());

/* ==== Route Handlers === */
const qaRouter = require('./routes/qa.js');
app.use('/qa/questions', qaRouter);



/* ==== Server Binding === */
app.listen(PORT, () => {
  console.log(`Server listening at http://localhost:${PORT}`)
})