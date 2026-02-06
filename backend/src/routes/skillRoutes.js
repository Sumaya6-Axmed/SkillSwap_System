const router = require("express").Router();
const { protect } = require("../middleware/authMiddleware");
const controller = require("../controllers/skillController");

// Public
router.get("/", controller.getAllSkills);
router.get("/:id", controller.getSkillById);

// Auth required
router.get("/my", protect, controller.getMySkills);
router.post("/", protect, controller.createSkill);
router.put("/:id", protect, controller.updateSkill);
router.delete("/:id", protect, controller.deleteSkill);

module.exports = router;
