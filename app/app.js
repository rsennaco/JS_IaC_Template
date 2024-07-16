const express = require('express');
const path = require('path');
const app = express();
const PORT = 3000;

// Static files from 'public' dir
app.use(express.static(path.join(_dirname, 'public')));

app.get('/', (req, res) => {
    res.sendFile(path.join(_dirname, 'public', 'index.html'));
});

app.listen(PORT, () => {
    console.log('Server is running on port ${PORT}');
});