require('dotenv').config();
const express = require("express");
const cors = require("cors");
const bodyParser = require("body-parser");
const db = require("./db");

const app = express();

app.use(cors());
app.use(bodyParser.json());

// Routes
const authRoutes = require('./routes/userRoutes');
const booksRoutes = require("./routes/books");
const ordersRoutes = require("./routes/orders");
app.use("/books", booksRoutes);
app.use("/orders", ordersRoutes);
app.use("/userRoutes", authRoutes);


// Test route
app.get("/", (req, res) => {
    res.send("🚀 BookFinder Backend is Running");
});

app.listen(3000, () => {
    console.log("🚀 Server running on port 3000");
});