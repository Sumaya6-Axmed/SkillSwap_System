// src/routes/skill.routes.js
const express = require("express");
const router = express.Router();
const protect = require("../middleware/auth.middleware");
const {
  createSkill,
  getAllSkills,
  getMySkills,
  deleteSkill
} = require("../controllers/skill.controller");

router.get("/", getAllSkills);
router.post("/", protect, createSkill);
router.get("/mine", protect, getMySkills);
router.delete("/:id", protect, deleteSkill);

module.exports = router;
