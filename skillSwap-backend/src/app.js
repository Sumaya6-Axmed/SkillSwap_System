// src/app.js
const express = require("express");
const app = express();

app.use(express.json());
const cors = require("cors");

app.use(cors({
  origin: true,
  credentials: true
}));


app.use("/api/auth", require("./routes/auth.routes"));
app.use("/api/skills", require("./routes/skill.routes"));
app.use("/api/sessions", require("./routes/session.routes"));
app.use("/api/reviews", require("./routes/review.routes"));



module.exports = app;
