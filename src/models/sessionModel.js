const mongoose = require("mongoose");

const sessionSchema = new mongoose.Schema({
  learnerId:{ 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "User", 
    required: true 
},
  expertId: { 
    type: mongoose.Schema.Types.ObjectId, 
    ref: "User", 
    required: true 
},
  skillId: { type: mongoose.Schema.Types.ObjectId, 
    ref: "Skill", 
    required: true 
},
  schedule: {
    type: Date, 
    required: true 
    },
  status: { 
    type: String, 
    enum: ["pending", "confirmed", "completed", "cancelled"], 
    default: "pending" 
},
  feedback: { type: String }
}, { timestamps: true });

module.exports = mongoose.model("Session", sessionSchema);
