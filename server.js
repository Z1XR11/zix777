const express = require('express');
const fs = require('fs');
const path = require('path');

const app = express();
app.use(express.json());

// База ключей. Если стоит null — ключ свободен. 
// Если написать ник в кавычках — ключ уже будет занят этим ником.
const keysDB = {
    "ZXC-KEY-1": null,
    "ZXC-KEY-2": null,
    "MY-VIP-KEY": "Z1XR11" // Пример ключа, который уже закреплен за ником Z1XR11
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
