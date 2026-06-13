const db = require('./db');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

// REGISTER
exports.register = (req, res) => {
    const { name, email, password } = req.body;

    db.query(
        'SELECT * FROM users WHERE email = ?',
        [email],
        (err, result) => {

            if (result.length > 0) {
                return res.status(400).json({ message: "User already exists" });
            }

            bcrypt.hash(password, 10, (err, hashedPassword) => {

                db.query(
                    'INSERT INTO users (name, email, password) VALUES (?, ?, ?)',
                    [name, email, hashedPassword],
                    (err, result) => {

                        res.json({ message: "User registered successfully" });
                    }
                );
            });
        }
    );
};


// LOGIN
exports.login = (req, res) => {

    const { email, password } = req.body;

    db.query(
        'SELECT * FROM users WHERE email = ?',
        [email],
        (err, result) => {

            if (result.length === 0) {
                return res.status(404).json({ message: "User not found" });
            }

            const user = result[0];

            bcrypt.compare(password, user.password, (err, isMatch) => {

                if (!isMatch) {
                    return res.status(401).json({ message: "Invalid credentials" });
                }

                const token = jwt.sign(
                    {
                        id: user.id,
                        email: user.email,
                        role: user.role
                    },
                    process.env.JWT_SECRET,
                    { expiresIn: "1d" }
                );

                res.json({
                    message: "Login successful",
                    token
                });
            });
        }
    );
};