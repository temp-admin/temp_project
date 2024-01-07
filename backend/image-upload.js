const multer = require('multer');
const path = require('path');
const { logError } = require('./utils');
const mysql = require('mysql');
const jwt = require('jsonwebtoken');

const connection = mysql.createConnection({
  connectionLimit: 10,
  host: 'localhost',
  user: 'admin_user',
  password: 'mevius11', // 비밀번호 설정 시 해당 비밀번호 사용
  database: 'smart_parent'
});
// 이미지 저장을 위한 multer 설정
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, 'uploads/'); // 업로드된 파일 저장 경로
  },
  filename: function (req, file, cb) {
    // 파일명 설정
    cb(null, Date.now() + path.extname(file.originalname));
    logError(path)
  }
});

const upload = multer({ storage: storage });

const imageUpload = (req, res) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];

  if (token) {
    jwt.verify(token, 'abEx0+VObvLSTY3IAT7aYaKNDyaT1yWUy8u7q44Etfs=', (err, decoded) => {
      if (err) {
        logError("토큰검증 실패");
        return res.status(401).send('인증 실패');
      }
      var filename;
      // 토큰에서 사용자 ID 추출
      req.userId = decoded.userId;

      // filename 설정
      storage.getFilename = function (req, file, cb) {
        filename = `${req.userId}_baby${path.extname(file.originalname)}`;
        cb(null, filename);
      };

      // 실제 이미지 업로드 처리
      upload.single('image')(req, res, function (uploadErr) {
        if (uploadErr) {
          logError('이미지 업로드 오류');
          return res.status(500).send('이미지 업로드 오류');
        }
        const query = 'UPDATE babies SET image_filename = ? WHERE baby_id = ?';
        connection.query(query, [filename, req.userId], (err, results) => {
          if (err) {
            logError(err);
            return callback(err, null);
          }
          logError(query);
          res.status(200).send({ message: '이미지가 성공적으로 업로드되었습니다.', results });
        });
        // 데이터베이스 업데이트 로직
        // ...
      });
    });
  } else {
    logError("토큰이 없습니다");
    res.status(401).send('사용자가 로그인하지 않았습니다.');
  }
};

module.exports = imageUpload;
