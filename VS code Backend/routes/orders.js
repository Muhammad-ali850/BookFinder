const express = require("express");
const router = express.Router();
const db = require("../db");

// CREATE ORDER
router.post("/", (req, res) => {

    const {
        book_id,
        customer_name,
        quantity,
        total_price
    } = req.body;

    const sql = `
        INSERT INTO orders
        (book_id, customer_name, quantity, total_price)
        VALUES (?, ?, ?, ?)
    `;

    db.query(
        sql,
        [book_id, customer_name, quantity, total_price],
        (err, result) => {

            if (err) {
                return res.json({ error: err });
            }

            res.json({
                message: "Order placed successfully",
                orderId: result.insertId
            });

        }
    );

});

router.get("/", (req, res) => {

    const sql = `
        SELECT
            orders.*,
            books.title AS book_title
        FROM orders
        INNER JOIN books
        ON orders.book_id = books.id
    `;

    db.query(sql, (err, result) => {

        if (err) {
            return res.json({ error: err });
        }

        res.json(result);

    });

});

router.get("/:id", (req, res) => {

    const id = req.params.id;

    const sql = "SELECT * FROM orders WHERE id = ?";

    db.query(sql, [id], (err, result) => {

        if (err) {
            return res.json({ error: err });
        }

        res.json(result);

    });

});


router.put("/:id", (req, res) => {

    const id = req.params.id;

    const {
        book_id,
        customer_name,
        quantity,
        total_price
    } = req.body;

    const sql = `
        UPDATE orders
        SET
            book_id = ?,
            customer_name = ?,
            quantity = ?,
            total_price = ?
        WHERE id = ?
    `;

    db.query(
        sql,
        [book_id, customer_name, quantity, total_price, id],
        (err, result) => {

            if (err) {
                return res.json({ error: err });
            }

            res.json({
                message: "Order updated successfully"
            });

        }
    );

});


router.delete("/:id", (req, res) => {

    const id = req.params.id;

    const sql = "DELETE FROM orders WHERE id = ?";

    db.query(sql, [id], (err, result) => {

        if (err) {
            return res.json({ error: err });
        }

        res.json({
            message: "Order deleted successfully"
        });

    });

});

// EXPORT ROUTER
module.exports = router;