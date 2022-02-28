const express = require('express')
const app = express()
const port = 80

app.get('/', (req, res) => {
  res.send(`${process.env.USER} : ${process.env.PASS}`);
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
