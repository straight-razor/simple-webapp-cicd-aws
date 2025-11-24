const request = require('supertest');
const app = require('../../src/index');

describe('GET /', () => {
    it('should respond with a 200 status and a welcome message', async () => {
        const response = await request(app).get('/');
        expect(response.status).toBe(200);
        expect(response.text).toContain('Welcome to the Simple Web App');
    });
});

describe('POST /data', () => {
    it('should respond with a 201 status and return the created data', async () => {
        const data = { name: 'Test' };
        const response = await request(app).post('/data').send(data);
        expect(response.status).toBe(201);
        expect(response.body).toEqual(expect.objectContaining(data));
    });
});

describe('Error handling', () => {
    it('should respond with a 404 status for unknown routes', async () => {
        const response = await request(app).get('/unknown-route');
        expect(response.status).toBe(404);
    });
});