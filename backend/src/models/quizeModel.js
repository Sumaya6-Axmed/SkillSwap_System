const mongoose = require("mongoose");

const quizSchema = new mongoose.Schema({
  skillId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "Skill", 
    required: true 
},
  createdBy: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "User", 
    required: true 
},
  questions: [
    {
      questionText: { type: String, required: true },
      options: [{ type: String, required: true }],
      correctAnswer: { type: String, required: true }
    }
  ]
}, { timestamps: true });

module.exports = mongoose.model("Quiz", quizSchema);
