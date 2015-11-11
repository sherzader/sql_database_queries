DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS question_as_follows;
DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_likes;


CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL
);

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title VARCHAR(255) NOT NULL,
  body TEXT NOT NULL,
  author_id INTEGER,

  FOREIGN KEY (author_id) REFERENCES users(id)
);

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id INTEGER,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id INTEGER,
  parent_reply INTEGER,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply) REFERENCES replies(id)
);

CREATE TABLE question_likes (
  id INTEGER PRIMARY KEY,
  question_id INTEGER,
  user_id INTEGER
);


INSERT INTO
  users (fname, lname)
VALUES
  ('Peter', 'Pan'), ('Sam', 'Scott');
INSERT INTO
  questions (title, body, author_id)
VALUES
  ('HELLO', 'WHAT IS THIS?', 1),
  ('AGE', 'how old are you?', 1),
  ('room', 'why am i here?', 2);

INSERT INTO
  replies (question_id, user_id, parent_reply, body)
VALUES
  (1, 1, NULL, 'You are funny');
