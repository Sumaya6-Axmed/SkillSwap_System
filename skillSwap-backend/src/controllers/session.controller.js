// src/controllers/session.controller.js
const Session = require("../models/Session");
const Skill = require("../models/Skill");

function displayStatus(status) {
  if (status === "accepted") return "Approved";
  if (status === "pending") return "Pending";
  if (status === "completed") return "Completed";
  if (status === "rejected") return "Rejected";
  if (status === "cancelled") return "Cancelled";
  return status;
}

exports.requestSession = async (req, res) => {
  try {
    const { skillId, scheduledAt, message } = req.body;

    if (!skillId) {
      return res.status(400).json({ message: "skillId is required" });
    }

    const skill = await Skill.findById(skillId);
    if (!skill) {
      return res.status(404).json({ message: "Skill not found" });
    }

    if (skill.tutor.toString() === req.user._id.toString()) {
      return res.status(400).json({ message: "You cannot request your own skill" });
    }

    const session = await Session.create({
      skill: skill._id,
      tutor: skill.tutor,
      learner: req.user._id,
      scheduledAt: scheduledAt || null,
      message: message || "",
      status: "pending",
    });

    return res.status(201).json({
      ...session.toObject(),
      displayStatus: displayStatus(session.status),
    });
  } catch (error) {
    console.error("REQUEST SESSION ERROR:", error);
    return res.status(500).json({ message: "Failed to request session", error: error.message });
  }
};

exports.respondToSession = async (req, res) => {
  try {
    const { status } = req.body; // accepted or rejected

    const session = await Session.findById(req.params.id);
    if (!session) {
      return res.status(404).json({ message: "Session not found" });
    }

    if (session.tutor.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not allowed" });
    }

    if (session.status !== "pending") {
      return res.status(400).json({ message: "Session already responded to" });
    }

    if (!["accepted", "rejected"].includes(status)) {
      return res.status(400).json({ message: "Invalid status (use accepted or rejected)" });
    }

    session.status = status;
    await session.save();

    return res.json({
      ...session.toObject(),
      displayStatus: displayStatus(session.status),
    });
  } catch (error) {
    console.error("RESPOND SESSION ERROR:", error);
    return res.status(500).json({ message: "Failed to update session", error: error.message });
  }
};

exports.completeSession = async (req, res) => {
  try {
    const session = await Session.findById(req.params.id);
    if (!session) {
      return res.status(404).json({ message: "Session not found" });
    }

    if (session.tutor.toString() !== req.user._id.toString()) {
      return res.status(403).json({ message: "Not allowed" });
    }

    if (session.status !== "accepted") {
      return res.status(400).json({ message: "Only accepted sessions can be completed" });
    }

    session.status = "completed";
    await session.save();

    return res.json({
      ...session.toObject(),
      displayStatus: displayStatus(session.status),
    });
  } catch (error) {
    console.error("COMPLETE SESSION ERROR:", error);
    return res.status(500).json({ message: "Failed to complete session", error: error.message });
  }
};

exports.cancelSession = async (req, res) => {
  try {
    const session = await Session.findById(req.params.id);
    if (!session) {
      return res.status(404).json({ message: "Session not found" });
    }

    const isTutor = session.tutor.toString() === req.user._id.toString();
    const isLearner = session.learner.toString() === req.user._id.toString();

    if (!isTutor && !isLearner) {
      return res.status(403).json({ message: "Not allowed" });
    }

    if (session.status === "completed") {
      return res.status(400).json({ message: "Completed sessions cannot be cancelled" });
    }

    session.status = "cancelled";
    await session.save();

    return res.json({
      ...session.toObject(),
      displayStatus: displayStatus(session.status),
    });
  } catch (error) {
    console.error("CANCEL SESSION ERROR:", error);
    return res.status(500).json({ message: "Failed to cancel session", error: error.message });
  }
};

exports.getMySessions = async (req, res) => {
  try {
    const sessions = await Session.find({
      $or: [{ tutor: req.user._id }, { learner: req.user._id }],
    })
      .populate("skill", "title category level driveLink")
      .populate("tutor", "name")
      .populate("learner", "name")
      .sort({ createdAt: -1 });

    const mapped = sessions.map((s) => ({
      ...s.toObject(),
      displayStatus: displayStatus(s.status),
    }));

    return res.json(mapped);
  } catch (error) {
    console.error("GET MY SESSIONS ERROR:", error);
    return res.status(500).json({ message: "Failed to fetch sessions", error: error.message });
  }
};