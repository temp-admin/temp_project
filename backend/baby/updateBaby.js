const mysql = require('mysql');
const { logError } = require('../utils');

const connection = mysql.createConnection({
  connectionLimit: 10,
  host: 'localhost',
  user: 'admin_user',
  password: 'mevius11', // 비밀번호 설정 시 해당 비밀번호 사용
  database: 'smart_parent'
});

// 아기 정보를 DB에 업데이트하는 함수
const updateBabyInfo = (babyId, babyInfo, callback) => {
  // 아기 정보 업데이트
  const updateBabyQuery = `
    UPDATE babies
    SET name = ?,
        gender = ?,
        birthdate = ?,
        child_order = ?,
        height = ?,
        weight = ?,
        image_filename = ?
    WHERE baby_id = ?
  `;
  connection.query(
    updateBabyQuery,
    [babyInfo.name, babyInfo.gender, babyInfo.birthdate, babyInfo.child_order, babyInfo.height, babyInfo.weight, babyInfo.image_filename, babyId],
    
    (err, results) => {
      if (err) {
        logError(err);
        return callback(err);
      }
      logError(results);
      
      callback(null, results);
    }
  );
};

module.exports = updateBabyInfo;
