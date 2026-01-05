const mongoose = require("mongoose");

const quizResultSchema = new mongoose.Schema({
  userId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "User", 
    required: true 
},
  quizId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Quiz", 
    required: true 
},
  score: { 
    type: Number, 
    required: true 
},
  answersGiven: [
    {
      questionId: { type: mongoose.Schema.Types.ObjectId, required: true },
      selectedAnswer: { type: String, required: true }
    }
  ]
}, { timestamps: true });

module.exports = mongoose.model("QuizResult", quizResultSchema);
