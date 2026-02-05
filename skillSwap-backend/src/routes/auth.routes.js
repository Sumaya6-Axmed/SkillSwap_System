// src/routes/auth.routes.js
const express = require("express");
const router = express.Router();
const {
  register,
  login
} = require("../controllers/auth.controller");

router.post("/register", register);
router.post("/login", login);

module.exports = router;


// // src/routes/user.routes.js
// const express = require("express");
// const router = express.Router();
// const protect = require("../middleware/auth.middleware");

// router.get("/me", protect, (req, res) => {
//   res.json(req.user);
// });

// module.exports = router;
