const fs = require('fs');
const path = require('path');

const logError = (error) => {
  const date = new Date();
  const dateString = `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()}`;
  const logFilePath = path.join(__dirname, 'log', `${dateString}.log`);
  const logMessage = `[${date.toISOString()}]: ${error}\n`;

  fs.appendFileSync(logFilePath, logMessage, 'utf8');
};

module.exports = {
  logError
};
