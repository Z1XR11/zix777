const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(express.json());

// База ключей. Если стоит null — ключ свободен. 
// Если написать ник в кавычках — ключ уже будет занят этим ником.
const keysDB = {
    "S5UV‑WX9Y‑ZA2B‑CD3E": "Zahar_76",
    "X7YZ‑JK1L‑MN2O‑PQ3R": "lypit9K360",
    "F4GH‑IJ1K‑LM2N‑OP3Q": "b3tasync"
    "UV3W‑XY4Z‑AB5C‑DE6F": "b3tasync"
    "F4GH‑IJ1K‑LM2N‑OP3Q": "zahar_4786"
};

// Считываем твой чит из файла script.lua
let REAL_SCRIPT = "";
try {
    REAL_SCRIPT = fs.readFileSync(path.join(__dirname, 'script.lua'), 'utf8');
} catch (err) {
    console.error("❌ Ошибка: файл script.lua не найден!");
}

app.post('/validate', (req, res) => {
    // Получаем ключ и ник от роблокса
    const { key, username } = req.body;

    if (!keysDB.hasOwnProperty(key)) {
        return res.json({ success: false, message: "❌ Неверный ключ!" });
    }

    // Если ключ свободен, привязываем его к нику
    if (keysDB[key] === null) {
        keysDB[key] = username;
        console.log(`🔑 Ключ ${key} привязан к нику: ${username}`);
    }

    // Если ник не совпадает с тем, что в базе
    if (keysDB[key] !== username) {
        return res.json({ success: false, message: `❌ Этот ключ принадлежит игроку ${keysDB[key]}!` });
    }

    // Если всё верно, отдаем скрипт!
    console.log(`✅ Игрок ${username} успешно активировал скрипт.`);
    res.json({ success: true, script: REAL_SCRIPT });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
    console.log(`🚀 Сервер запущен на порту ${PORT}`);
});
