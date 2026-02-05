// src/routes/session.routes.js
const express = require("express");
const router = express.Router();
const protect = require("../middleware/auth.middleware");
const {
  requestSession,
  respondToSession,
  completeSession,
  cancelSession,
  getMySessions
} = require("../controllers/session.controller");

router.post("/", protect, requestSession);
router.get("/mine", protect, getMySessions);
router.patch("/:id/respond", protect, respondToSession);
router.patch("/:id/complete", protect, completeSession);
router.patch("/:id/cancel", protect, cancelSession);

module.exports = router;
