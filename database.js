const { Pool } = require('pg')
var fs = require('fs')
const pool = new Pool({
  host: process.env.HOST,
  user: process.env.USER_DB,
  password: process.env.PASSWORD_DB,
  database: process.env.DATABASE,
  port: process.env.PORT_DB,
//   ssl  : {
//     ca : fs.readFileSync('./he')
// },
})
module.exports = pool;
