const Skill = require("../models/skillModel");

// ✅ Create Skill (Auth required)
const createSkill = async (req, res) => {
  try {
    const { name, category, description } = req.body;

    if (!name || !category) {
      return res.status(400).json({ message: "Name and category are required" });
    }

    const skill = await Skill.create({
      name,
      category,
      description,
      creator: req.user.id, // ✅ owner
    });

    return res.status(201).json(skill);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// ✅ Get all skills (Public)
const getAllSkills = async (req, res) => {
  try {
    const skills = await Skill.find()
      .populate("creator", "name") // creator info if you have User model with name
      .sort({ createdAt: -1 });

    return res.json(skills);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// ✅ Get single skill by id (Public)
const getSkillById = async (req, res) => {
  try {
    const skill = await Skill.findById(req.params.id)
      .populate("creator", "name")
      .select("-__v");

    if (!skill) return res.status(404).json({ message: "Skill not found" });

    return res.json(skill);
  } catch (err) {
    return res.status(400).json({ message: "Invalid skill id" });
  }
};


// ✅ Get my skills (Auth required)
const getMySkills = async (req, res) => {
  try {
    const skills = await Skill.find({ creator: req.user.id })
      .populate("creator", "name")
      .sort({ createdAt: -1 });

    return res.json(skills);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// ✅ Update skill (Auth required + owner only)
const updateSkill = async (req, res) => {
  try {
    const { id } = req.params;
    const { name, category, description } = req.body;

    const skill = await Skill.findById(id);
    if (!skill) return res.status(404).json({ message: "Skill not found" });

    // ✅ owner check
    if (skill.creator.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorized" });
    }

    // update fields
    if (name !== undefined) skill.name = name;
    if (category !== undefined) skill.category = category;
    if (description !== undefined) skill.description = description;

    await skill.save();
    return res.json(skill);
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// ✅ Delete skill (Auth required + owner only)
const deleteSkill = async (req, res) => {
  try {
    const { id } = req.params;

    const skill = await Skill.findById(id);
    if (!skill) return res.status(404).json({ message: "Skill not found" });

    // ✅ owner check
    if (skill.creator.toString() !== req.user.id) {
      return res.status(403).json({ message: "Not authorized" });
    }

    await skill.deleteOne();
    return res.json({ message: "Skill deleted successfully" });
  } catch (err) {
    return res.status(500).json({ message: err.message });
  }
};

// ✅ IMPORTANT: Export as object (prevents “handler must be a function” issues)
module.exports = {
  createSkill,
  getAllSkills,
  getMySkills,
  updateSkill,
  deleteSkill,
};
