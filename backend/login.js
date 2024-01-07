const bcrypt = require('bcrypt');
const mysql = require('mysql');
const jwt = require('jsonwebtoken');

const connection = mysql.createConnection({
  connectionLimit: 10,
  host: 'localhost',
  user: 'admin_user',
  password: 'mevius11',
  database: 'smart_parent'
});
const { logError } = require('./utils');
const login = (email, password, req, callback) => {
  const query = 'SELECT * FROM users WHERE email = ?';
  logError("email : " + email);
  connection.query(query, [email], (err, results) => {
    if (err) {
      logError("email이 없습니다" + results.length);
      return callback(err);
    }

    if (results.length > 0) {
      logError("email이 있습니다" + results.length);
      bcrypt.compare(password, results[0].password, (err, isMatch) => {
        if (err) return callback(err);
        if (isMatch) {
          const user = {
            id: results[0].id,
            email: results[0].email,
            children: results[0].number_of_children,
            // 다른 필요한 사용자 정보
          };
          const token = jwt.sign(
            { userId: user.id, email: user.email },
            'abEx0+VObvLSTY3IAT7aYaKNDyaT1yWUy8u7q44Etfs=',
            { expiresIn: '24h' }
          );
          req.session.user = user;
          return callback(null, { user, token });
        } else {
          logError("login.js 로그인 실패");
          return callback(null, false);
        }
      });
    } else {
      logError("result길이가 0입니다" + results.length);
      return callback(null, false);
    }
  });
};

module.exports = login;
