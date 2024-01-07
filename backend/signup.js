const bcrypt = require('bcrypt');
const mysql = require('mysql');
const fs = require('fs');
const path = require('path');

const connection = mysql.createConnection({
  connectionLimit: 10,
  host: 'localhost',
  user: 'admin_user',
  password: 'mevius11', // 비밀번호가 없으므로 빈 문자열
  database: 'smart_parent' // 사용할 데이터베이스 이름
});

const logError = (error) => {
  const date = new Date();
  const dateString = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
  const logFilePath = path.join(__dirname, 'log', `${dateString}.log`);
  const logMessage = `[${date.toISOString()}]: ${error}\n`;

  fs.appendFileSync(logFilePath, logMessage, 'utf8');
};

const registerUser = (email, password, phoneNumber, callback) => {
  // 이메일 중복 검사
  try {
    connection.query('SELECT * FROM users WHERE email = ?', [email], (err, results) => {
      if (err) return callback(err);
      if (results.length > 0) return callback('Email already registered');

      // 비밀번호 해싱
      bcrypt.hash(password, 10, (err, hash) => {
        if (err) return callback(err);

        // 사용자 데이터베이스에 저장
        const query = 'INSERT INTO users (email, password, phone_number) VALUES (?, ?, ?)';
        connection.query(query, [email, hash, phoneNumber], (err, results) => {
          if (err) return callback(err);
          callback(null, 'User registered successfully');
        });
      });
    });
  } catch (error) {
    logError(error);
    callback(error);
  }
};

module.exports = registerUser;
