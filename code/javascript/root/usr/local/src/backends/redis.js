const express = require('express');
const router = express.Router();
const redis = require('redis');

router.get('/', (req, res, next) => {
    console.log(redis);
    res.send('Redis GET');
});

router.post('/', (req, res, next) => {
  res.send('Redis Got a POST request');
});

router.put('/user', (req, res, next) => {
  res.send('Redis Got a PUT request at /user');
});

router.delete('/user', (req, res, next) => {
  res.send('Redis Got a DELETE request at /user');
});

module.exports = router;
