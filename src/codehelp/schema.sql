-- SPDX-FileCopyrightText: 2023 Mark Liffiton <liffiton@gmail.com>
--
-- SPDX-License-Identifier: AGPL-3.0-only

PRAGMA foreign_keys = ON;

DROP TABLE IF EXISTS queries;
CREATE TABLE queries (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    query_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    language TEXT NOT NULL,
    code TEXT,
    error TEXT,
    issue TEXT NOT NULL,
    response_json TEXT,
    response_text TEXT,
    topics_json TEXT,
    helpful BOOLEAN CHECK (helpful in (0, 1)),
    helpful_emoji TEXT GENERATED ALWAYS AS (CASE helpful WHEN 1 THEN '✅' WHEN 0 THEN '❌' ELSE '' END) VIRTUAL,
    user_id INTEGER NOT NULL,
    role_id INTEGER,
    assignment_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(role_id) REFERENCES roles(id),
    FOREIGN KEY(assignment_id) REFERENCES assignments(id)
);

DROP TABLE IF EXISTS tutor_chats;
CREATE TABLE tutor_chats (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    topic TEXT NOT NULL,
    context TEXT,
    chat_json TEXT NOT NULL,
    user_id INTEGER NOT NULL,
    role_id INTEGER,
    FOREIGN KEY(user_id) REFERENCES users(id),
    FOREIGN KEY(role_id) REFERENCES roles(id)
);
