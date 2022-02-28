const express = require('express');
const app = express();
const port = 80;

app.get('/', (req, res) => {
  res.send(`${process.env.USER} : ${process.env.PASS}`);
});

app.get('/.well-known/live', (req, res) => {
  res.send('ok');
});

app.get('/.well-known/ready', (req, res) => {
  res.send('ok');
});

app.get('/.well-known/boot', (req, res) => {
  res.send('ok');
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
