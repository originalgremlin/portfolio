const express = require('express');
const app = express();

// middleware
app.use((req, res, next) => {
    console.log(`Request: ${req.originalUrl}`);
    next();
});

// routes
app.use('/', require('./backends/default'));
app.use('/redis', require('./backends/redis'));

// error handling
app.use((err, req, res, next) => {
  console.error(err.stack)
  res.status(500).send('Something broke!');
});

app.use((req, res, next) => {
  res.status(404).send("Sorry can't find that!");
});

// start server
app.listen(3000, () => {
    console.log('Server started on port 3000!');
});
