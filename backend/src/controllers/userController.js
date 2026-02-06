const User = require("../models/userModel");
const bcrypt = require("bcryptjs");
const { generateToken } = require("../utils/generateTokens");


/* REGISTER */
exports.registerUser = async (req, res) => {
  try {
    const { name, email, password, role} = req.body;

    if (!name || !email || !password || !role) {
      return res.status(400).json({ message: "All fields required" });
    }

    const exists = await User.findOne({ email });
    if (exists) {
      return res.status(400).json({ message: "User already exists" });
    }

    const hashed = await bcrypt.hash(password, 10);

    const user = await User.create({
      name,
      email,
      password: hashed,
      role
    });

    res.status(201).json({
      message: "Registered successfully",
      userId: user._id
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

/* LOGIN */
exports.loginUser = async (req, res) => {
  try {
    const { email, password } = req.body;

    const user = await User.findOne({ email });
    if (!user)
      return res.status(401).json({ message: "Invalid credentials" });

    const match = await bcrypt.compare(password, user.password);
    if (!match)
      return res.status(401).json({ message: "Invalid credentials" });

    res.json({
      token: generateToken(user._id),
      userId: user._id
    });
  } catch (err) {
    res.status(500).json({ message: err.message });
  }
};

/* TEST PROFILE */
exports.getProfile = async (req, res) => {
  res.json(req.user);
};
