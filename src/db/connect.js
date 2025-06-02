const mysql = require('mysql2');
require('dotenv').config();

const pool = mysql.createPool({
    connectionLimit:10,
    // host:'localhost',
    // user:'alunods',
    // password:'senai@604',
    // database:'vio_mateus'
    host:process.env.DB_HOST,
    user:process.env.DB_USER,
    password:process.env.DB_PASSWORD,
    database:process.env.DB_NAME,
})

module.exports = pool;
