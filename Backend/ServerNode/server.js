import express from 'express';
import multer from 'multer';
import { createRequire } from 'module';
const require = createRequire(import.meta.url);
const http = require('node:http');
const { Server } = require('ws');

import routes from './routes/index.js';

const app = express();
const port = 3000;
const ngrokUrl = "https://62ae-2401-4900-6067-76df-1949-8c0c-8547-82e8.ngrok-free.app";

// Middleware for JSON parsing
app.use(express.json({ limit: '50mb' }));

// Multer configuration for file uploads
const upload = multer({
    dest: "uploads/",
    limits: {
        fileSize: 50 * 1024 * 1024 // 50MB limit
    }
});

// Use the routes
app.use('/', routes);

// Start the server
app.listen(port, () => {
    console.log("Server is running on ", ngrokUrl, port);
});
