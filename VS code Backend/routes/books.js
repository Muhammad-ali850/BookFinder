const express = require("express");
const router = express.Router();
const db = require("../db");

// JWT Middleware
const verifyToken = require("../authMiddleware");


// =====================
// CREATE BOOK (PROTECTED)
// =====================
router.post("/", verifyToken, (req, res) => {

    const { title, author, price, description, image_url } = req.body;

    const sql = `
        INSERT INTO books (title, author, price, description, image_url)
        VALUES (?, ?, ?, ?, ?)
    `;

    db.query(
        sql,
        [title, author, price, description, image_url],
        (err, result) => {

            if (err) {
                return res.json({ error: err });
            }

            res.json({
                message: "Book added successfully",
                bookId: result.insertId
            });

        }
    );
});


// =====================
// GET ALL BOOKS (PUBLIC)
// =====================
router.get("/", (req, res) => {

    const sql = "SELECT * FROM books";

    db.query(sql, (err, result) => {

        if (err) {
            return res.json({ error: err });
        }

        res.json(result);

    });

});


// =====================
// GET BOOK BY ID (PUBLIC)
// =====================
router.get("/:id", (req, res) => {

    const id = req.params.id;

    const sql = "SELECT * FROM books WHERE id = ?";

    db.query(sql, [id], (err, result) => {

        if (err) {
            return res.json({ error: err });
        }

        res.json(result);

    });

});


// =====================
// UPDATE BOOK (PROTECTED)
// =====================
router.put("/:id", verifyToken, (req, res) => {

    const id = req.params.id;
    const { title, author, price, description, image_url } = req.body;

    const sql = `
        UPDATE books
        SET title = ?, author = ?, price = ?, description = ?, image_url = ?
        WHERE id = ?
    `;

    db.query(
        sql,
        [title, author, price, description, image_url, id],
        (err, result) => {

            if (err) {
                return res.json({ error: err });
            }

            res.json({
                message: "Book updated successfully"
            });

        }
    );

});


// =====================
// DELETE BOOK (PROTECTED)
// =====================
router.delete("/:id", verifyToken, (req, res) => {

    const id = req.params.id;

    const sql = "DELETE FROM books WHERE id = ?";

    db.query(sql, [id], (err, result) => {

        if (err) {
            return res.json({ error: err });
        }

        res.json({
            message: "Book deleted successfully"
        });

    });

});


// EXPORT ROUTER
module.exports = router;