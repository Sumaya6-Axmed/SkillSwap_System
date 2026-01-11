const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());
app.use(express.json());

app.use("/api/auth", require("./routes/userRoutes"));

app.get("/", (req, res) => {
  res.send("API Running");
});

module.exports = app;
