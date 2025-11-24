const express = require('express');
const app = express();
const routes = require('./routes');

app.use(express.json());
app.use(routes);

const PORT = process.env.PORT || 3000;

// If this file is run directly (node src/index.js) start the server.
// When required by tests, export the `app` without listening so supertest can use it.
if (require.main === module) {
    app.listen(PORT, () => {
        console.log(`Server is running on port ${PORT}`);
    });
}

module.exports = app;