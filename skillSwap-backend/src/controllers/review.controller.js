// src/controllers/review.controller.js
const Review = require("../models/Review");
const Session = require("../models/Session");
const User = require("../models/User");
const { evaluateBadges } = require("../utils/points");


exports.createReview = async (req, res) => {
  try {
    const { sessionId, rating, comment } = req.body;

    const session = await Session.findById(sessionId);
    if (!session) {
      return res.status(404).json({ message: "Session not found" });
    }

    // Only learner can review
    if (session.learner.toString() !== req.user._id.toString()) {
      return res.status(403).json({
        message: "Only the learner can leave a review"
      });
    }

    // Session must be completed
    if (session.status !== "completed") {
      return res.status(400).json({
        message: "Session not completed"
      });
    }

    // Only one review per session
    const existingReview = await Review.findOne({
      session: sessionId
    });

    if (existingReview) {
      return res.status(400).json({
        message: "Review already exists for this session"
      });
    }

    const review = await Review.create({
      session: session._id,
      tutor: session.tutor,
      learner: session.learner,
      rating,
      comment
    });

    // Simple points logic
    await User.findByIdAndUpdate(session.tutor, {
      $inc: { points: 10 }
    });

    await User.findByIdAndUpdate(session.learner, {
      $inc: { points: 5 }
    });

    res.status(201).json(review);
  } catch (error) {
    res.status(500).json({ message: "Failed to create review" });
  }

  const tutor = await User.findById(session.tutor);

  const newBadges = evaluateBadges(tutor);

if (newBadges.length > 0) {
  tutor.badges.push(...newBadges);
  await tutor.save();
}
};

exports.getReviewsForTutor = async (req, res) => {
  try {
    const reviews = await Review.find({
      tutor: req.params.tutorId
    })
      .populate("learner", "name")
      .populate("session", "skill");

    res.json(reviews);
  } catch (error) {
    res.status(500).json({ message: "Failed to fetch reviews" });
  }
};
