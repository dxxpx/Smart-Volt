import express from 'express';
import multer from 'multer';
import { GeminiAi, GeminiChatBot } from '../service/Gemini.js';

const router = express.Router();

// Multer configuration for file uploads
const upload = multer({
    dest: "uploads/",
    limits: {
        fileSize: 50 * 1024 * 1024 // 50MB limit
    }
});

// Home route
router.get('/', (req, res) => {
    res.status(200).send("Hey, You are in my backend!!!");
});

// Route for processing image and text data
router.post('/api/data', upload.single('image'), async (req, res) => {
    try {
        console.log("Request from app: ", req.body);
        const user_prompt = req.body.prompt;
        const image = req.file;

        if (!user_prompt) {
            throw new Error("No prompt provided");
        }

        if (image) {
            console.log("Image uploaded: ", image.path);
        } else {
            res.status(400).json({
                success: false,
                message: "No image uploaded. Please provide the image."
            });
            return;
        }

        const reply_from_gemini = await GeminiAi(user_prompt, image.path);

        res.status(200).json({
            success: true,
            status_code: 200,
            name: reply_from_gemini.name,
            symptoms: reply_from_gemini.symptoms,
            precautions: reply_from_gemini.precautions,
            treatments: reply_from_gemini.treatments,
            causes: reply_from_gemini.causes,
            medicines: reply_from_gemini.medicines,
            pesticides: reply_from_gemini.pesticides,
            user_prompt: req.body,
        });
    } catch (error) {
        console.log("Error in Post: ", error);
        res.status(500).json({
            success: false,
            message: "Error processing request",
        });
    }
});

router.post('/chatbot', async (req, res) => {
    try {
        console.log("Request from app: ", req.body);
        const user_prompt = req.body.prompt;

        if (!user_prompt) {
            throw new Error("No prompt provided");
        }

        const gemini_response = await GeminiChatBot(user_prompt);

        res.status(200).json({
            success: true,
            status_code: 200,
            message: gemini_response,
            user_prompt: req.body,
        });
    } catch (error) {
        console.log("Error in Post: ", error);
        res.status(500).json({
            success: false,
            message: "Error processing request",
        });
    }
});

export default router;
