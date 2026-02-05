const mongoose = require("mongoose");

const userSchema = new mongoose.Schema({
  name:{
    type: String,
    required: true
 },
  email:{
    type: String, 
    required: true, 
    unique: true
 },
  password:{ 
    type: String, 
    required: true 
},
  role:{
     type: String, 
     enum: ["expert", "learner"], 
     required: true 
    },
  bio:{ 
    type: String 
},
  profileImage: { 
    type: String 
},
  skillsOffered: [{ type: mongoose.Schema.Types.ObjectId, ref: "Skill" }],
  skillsWanted: [{ type: mongoose.Schema.Types.ObjectId, ref: "Skill" }],
  
}, { timestamps: true });

module.exports = mongoose.model("User", userSchema);
