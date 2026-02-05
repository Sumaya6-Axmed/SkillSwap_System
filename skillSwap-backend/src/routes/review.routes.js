// src/routes/review.routes.js
const express = require("express");
const router = express.Router();
const protect = require("../middleware/auth.middleware");
const {
  createReview,
  getReviewsForTutor
} = require("../controllers/review.controller");

router.post("/", protect, createReview);
router.get("/tutor/:tutorId", getReviewsForTutor);

module.exports = router;
