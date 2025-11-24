const express = require('express');
const router = express.Router();
const fs = require('fs');
const { exec } = require('child_process');

// Root route (kept for existing tests)
router.get('/', (req, res) => {
    res.send('Welcome to the Simple Web App!');
});

// Vulnerable example: reflected XSS (for demo only)
router.get('/search', (req, res) => {
    const q = req.query.q || '';
    // Intentionally reflect user input without sanitization
    res.send(`<html><body>Search results for: ${q}</body></html>`);
});

// Vulnerable example: path traversal (demo only)
router.get('/file', (req, res) => {
    const p = req.query.path;
    if (!p) return res.status(400).send('missing path');
    // Intentionally vulnerable to path traversal
    fs.readFile(p, 'utf8', (err, data) => {
        if (err) return res.status(500).send(`error: ${err.message}`);
        res.type('text/plain').send(data);
    });
});

// Vulnerable example: command injection (DO NOT enable in production)
router.get('/exec', (req, res) => {
    const cmd = req.query.cmd;
    if (!cmd) return res.status(400).send('missing cmd');
    // Intentionally executing user-provided input (vulnerable)
    exec(cmd, { timeout: 5000 }, (err, stdout, stderr) => {
        if (err) return res.status(500).send(`exec error: ${err.message}`);
        res.type('text/plain').send(stdout || stderr);
    });
});

// Simple data create endpoint used by tests (returns 201 and echoes created data)
router.post('/data', (req, res) => {
    const payload = req.body;
    if (!payload || Object.keys(payload).length === 0) {
        return res.status(400).json({ error: 'missing body' });
    }
    // In a real app we'd persist; for tests just echo with 201 Created
    res.status(201).json(payload);
});

module.exports = router;