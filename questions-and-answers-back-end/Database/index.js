const Pool = require("pg").Pool;

console.log("In the database")

const pool = new Pool({
  user: "T-Spoon",
  password: "password",
  host: "localhost",
  port: 5432,
  database: "atelierqa"
})

module.exports = pool;