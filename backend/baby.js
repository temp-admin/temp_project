const mysql = require('mysql');
const jwt = require('jsonwebtoken');
const { logError } = require('./utils');

const connection = mysql.createConnection({
  connectionLimit: 10,
  host: 'localhost',
  user: 'admin_user',
  password: 'mevius11', // 비밀번호 설정 시 해당 비밀번호 사용
  database: 'smart_parent'
});

// 아기 정보를 DB에 삽입하는 함수
const addBabyInfo = (userId, babyInfo, callback) => {
  // 아기 정보 삽입
  const insertBabyQuery = 'INSERT INTO babies (name, gender, birthdate, child_order) VALUES (?, ?, ?, ?)';
  connection.query(
    insertBabyQuery,
    [babyInfo.name, babyInfo.gender, babyInfo.birthdate, babyInfo.child_order],
    (err, results) => {
      if (err) {
        logError(err);
        return callback(err);
      }
      logError(results);
      // 삽입된 아기의 ID 가져오기
      const babyId = results.insertId;

      // 사용자와 아기 관계 설정
      const insertRelationQuery = 'INSERT INTO user_baby_relation (user_id, baby_id) VALUES (?, ?)';
      connection.query(
        insertRelationQuery,
        [userId, babyId],
        (err, results) => {
          if (err) {
            logError(err);
            return callback(err);
          }
          callback(null, { babyId, userId });
        }
      );
    }
  );

};

module.exports = addBabyInfo;
