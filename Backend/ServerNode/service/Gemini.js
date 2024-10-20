import fs from 'fs';
import { GoogleGenerativeAI } from "@google/generative-ai";

// Initialize Google Generative AI instance
const genAI = new GoogleGenerativeAI("AIzaSyBdM-zkMxxQhCkvept_nv0BIXtUTEwTOZ8");

export async function GeminiAi(params, imagePath) {
    try {
        const generation_config = {
            temperature: 1,
            top_p: 0.95,
            top_k: 16,
            max_output_tokens: 200,
            response_mime_type: "application/json",
        };

        const model = genAI.getGenerativeModel({
            model: "gemini-1.5-flash",
            generation_config,
        });

        const imageBuffer = fs.readFileSync(imagePath);
        const prompt = `${params}\nImage data: ${imageBuffer.toString('base64')}`;

        const result = await model.generateContent(prompt);
        const response = await result.response;

        const gemini_reply = await response.text();
        const jsonString = gemini_reply.replace(/```json|```/g, '').trim();
        const jsonBody = JSON.parse(jsonString);

        var diseaseInfo = {
            name: jsonBody.name || "Not Identified",
            symptoms: jsonBody.symptoms ? jsonBody.symptoms.join(', ') : "Not Listed",
            precautions: jsonBody.precautions ? jsonBody.precautions.join(', ') : "Not Listed",
            treatments: jsonBody.treatments ? jsonBody.treatments.join(', ') : "Not Listed",
            causes: jsonBody.causes ? jsonBody.causes.join(', ') : "Not Defined",
            medicines: jsonBody.medicines ? jsonBody.medicines.join(', ') : "Not defined",
            pesticides: jsonBody.pesticides ? jsonBody.pesticides.join(', ') : "Not identified"
        };

        console.log(response.text());
        return diseaseInfo;
    } catch (error) {
        console.log("Error inside GeminiAI function: ", error);
        throw error;
    }
}

export async function GeminiChatBot(params) {
    try {
        const generation_config = {
            temperature: 1,
            top_p: 0.95,
            top_k: 16,
            max_output_tokens: 200,
            response_mime_type: "application/json",
        };

        const model = genAI.getGenerativeModel({
            model: "gemini-1.5-flash",
            generation_config,
        });

        const result = await model.generateContent(params);
        const response = await result.response;
        const gemini_reply = await response.text();
        return gemini_reply;
    } catch (error) {
        console.log("Error inside GeminiChatBot function: ", error);
    }
}
