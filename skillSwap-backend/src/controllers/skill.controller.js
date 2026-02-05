// src/controllers/skill.controller.js
const Skill = require("../models/Skill");

exports.createSkill = async (req, res) => {
  try {
    const { title, description, videoLinks } = req.body;

    const skill = await Skill.create({
      title,
      description,
      videoLinks,
      tutor: req.user._id
    });

    res.status(201).json(skill);
  } catch (error) {
    res.status(500).json({ message: "Failed to create skill" });
  }
};

exports.getAllSkills = async (req, res) => {
  try {
    const skills = await Skill.find()
      .populate("tutor", "name email");

    res.json(skills);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch skills" });
  }
};

exports.getMySkills = async (req, res) => {
  try {
    const skills = await Skill.find({
      tutor: req.user._id
    });

    res.json(skills);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch your skills" });
  }
};

exports.deleteSkill = async (req, res) => {
  try {
    const skill = await Skill.findById(req.params.id);

    if (!skill) {
      return res.status(404).json({ message: "Skill not found" });
    }

    if (skill.tutor.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not allowed" });
    }

    await skill.deleteOne();
    res.json({ message: "Skill deleted" });
  } catch (error) {
    res.status(500).json({ message: "Failed to delete skill" });
  }
};
