// current-user.js
const express = require('express');
const router = express.Router();
const { logError } = require('./utils');

router.get('/', (req, res) => {
  if (req.session.user) {
    // 로그인한 사용자의 정보를 리턴하는 로직
    logError("okay");
    logError(req.session.user);
    res.json(req.session.user);
  } else {
    logError("nono");
    res.status(401).send('사용자가 로그인하지 않았습니다.');
  }
});

module.exports = router;
