// index.js
const express = require('express');
const app = express();
const login = require('./login');
const registerUser = require('./signup');
const path = require('path');
const fs = require('fs');
const session = require('express-session');
const currentUserRouter = require('./current-user');
const multer = require('multer');
const upload = multer({ dest: 'uploads/' });
const mysql = require('mysql');
const { logError } = require('./utils');
const addBabyInfo = require('./baby');
const imageUpload = require('./image-upload');
const jwt = require('jsonwebtoken');

app.use(express.json());

app.use(session({
  secret: "a23102f6c102de7243b6b083a651b725d65fccebd97556aa8e4c6adf55080a7c50fb08de51b50b630e354b194ea22993b693b2f56c09408ea19d07ee14e19c81",
  resave: false,
  saveUninitialized: true,
  cookie: {
    httpOnly: true,
    secure: false, // 로컬 개발 환경에서는 false, HTTPS 사용 시 true
    maxAge: 1000 * 60 * 60 * 24
  }
}));

const connection = mysql.createConnection({
  connectionLimit: 10,
  host: 'localhost',
  user: 'admin_user',
  password: 'mevius11',
  database: 'smart_parent'
});

app.post('/login', (req, res) => {
  const { email, password } = req.body;
  login(email, password, req, (err, user) => {
    if (err) {
      logError("login error")
      res.status(500).send('Server error');
    } else {
      if (user) {
        logError("로그인 성공")
        res.status(200).json(user);
      } else {
        logError(`Response status: ${res.statusCode}, Headers: ${JSON.stringify(res.getHeaders())}`);
        logError("로그인 실패")
        res.status(401).send('Login failed');
      }
      logError(req.session.user)
    }
  });
});

app.post('/register', (req, res) => {
  const { email, password, phoneNumber } = req.body;

  registerUser(email, password, phoneNumber, (err, result) => {
    if (err) {
      logError(err);
      res.status(500).send(err);
    } else {
      logError(err);
      res.status(200).send(result);
    }
  });
});

// app.get('/current-user', (req, res) => {
//   const token = req.headers.authorization && req.headers.authorization.split(' ')[1]; // JWT 토큰 추출
//   if (token) {
//     jwt.verify(token, 'abEx0+VObvLSTY3IAT7aYaKNDyaT1yWUy8u7q44Etfs=', (err, decoded) => {
//       if (err) {
//         logError("토큰검증 실패");
//         return res.status(401).send('인증 실패');
//       }
//       const user = {
//         id: decoded.userId,
//         email: decoded.email,
//         // 다른 필요한 사용자 정보
//       };
//       logError(user.email);
//       // 사용자 정보 반환
//       res.json(user);
//     });
//   } else {
//     // 토큰이 없는 경우
//     logError("토큰이 없습니다");
//     res.status(401).send('사용자가 로그인하지 않았습니다.');
//   }
// });

app.get('/current-user', (req, res) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];

  if (token) {
    jwt.verify(token, 'abEx0+VObvLSTY3IAT7aYaKNDyaT1yWUy8u7q44Etfs=', (err, decoded) => {
      if (err) {
        logError("토큰 검증 실패");
        return res.status(401).send('인증 실패');
      }

      const userId = decoded.userId;
      const userQuery = 'SELECT * FROM users WHERE id = ?';
      const babyQuery = 'SELECT b.* FROM babies b INNER JOIN user_baby_relation ubr ON b.baby_id = ubr.baby_id WHERE ubr.user_id = ?';

      connection.query(userQuery, [userId], (err, userResults) => {
        if (err) {
          logError(err);
          return res.status(500).send('DB 오류 발생');
        }

        if (userResults.length > 0) {
          const user = userResults[0];
          connection.query(babyQuery, [userId], (err, babyResults) => {
            if (err) {
              logError(err);
              return res.status(500).send('DB 오류 발생');
            }
            res.json({ user: user, babies: babyResults });
          });
        } else {
          res.status(404).send('사용자가 존재하지 않습니다.');
        }
      });
    });
  } else {
    logError("토큰이 없습니다");
    res.status(401).send('사용자가 로그인하지 않았습니다.');
  }
});


app.post('/addbabyinfo', (req, res) => {
  const token = req.headers.authorization && req.headers.authorization.split(' ')[1];

  if (token) {
    jwt.verify(token, 'abEx0+VObvLSTY3IAT7aYaKNDyaT1yWUy8u7q44Etfs=', (err, decoded) => {
      if (err) {
        return res.status(401).send('인증 실패');
      }

      const userId = decoded.userId;
      const babyInfo = req.body;

      addBabyInfo(userId, babyInfo, (err, result) => {
        if (err) {
          res.status(500).send('서버 오류 발생');
        } else {
          res.status(200).send({ message: '아기 정보가 성공적으로 등록되었습니다.', result });
        }
      });
    });
  } else {
    res.status(401).send('사용자가 로그인하지 않았습니다.');
  }
});

app.post('/api/upload/image', imageUpload);

const port = 3000;
app.listen(port, () => {
  console.log(`Server running on port ${port}`);
});


