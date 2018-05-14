const express = require('express');
const app = express();
const backends = ['redis'];

// middleware
app.use((req, res, next) => {
    console.log(`Request: ${req.originalUrl}`);
    next();
});

// routes
app.get('/', (req, res, next) => {
    res.send('Welcome to my homepage.');
});

backends.forEach(backend => {
    app.use(`/${backend}`, require(`./backends/${backend}`));
})

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
