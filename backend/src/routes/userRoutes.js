const express = require("express");
const router = express.Router();

const {
  registerUser,
  loginUser,
  getProfile
} = require("../controllers/userController");

const { protect } = require("../middleware/authMiddleware");

router.post("/register", registerUser);
router.post("/login", loginUser);

/* TEST AUTH ROUTE (PDF requirement) */
router.get("/profile", protect, getProfile);

module.exports = router;
