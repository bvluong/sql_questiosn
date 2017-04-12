DROP TABLE IF EXISTS users;

CREATE TABLE users (
  id INTEGER PRIMARY KEY,
  fname TEXT NOT NULL,
  lname TEXT NOT NULL

);

DROP TABLE IF EXISTS questions;

CREATE TABLE questions (
  id INTEGER PRIMARY KEY,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  user_id INTEGER,

  FOREIGN KEY (user_id) REFERENCES users(id)
);

DROP TABLE IF EXISTS questions_follows;

CREATE TABLE questions_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER  NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);


DROP TABLE IF EXISTS replies;

CREATE TABLE replies (
  id INTEGER PRIMARY KEY,
  question_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  parent_reply INTEGER,
  body TEXT NOT NULL,

  FOREIGN KEY (question_id) REFERENCES questions(id),
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (parent_reply) REFERENCES replies(id)
);

DROP TABLE IF EXISTS questions_likes;

CREATE TABLE questions_likes (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,


  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);



INSERT INTO
  users(fname, lname)
VALUES
  ('Farid', 'Rahmani'),
  ('John', 'Ra'),
  ('Brad', 'Can'),
  ('Art', 'Fram'),
  ('Tad', 'Cet'),
  ('Bryant','Al');



INSERT INTO
  questions(title, body, user_id)
VALUES
  ('Why is the sky blue?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Bryant')),
  ('Why is the sky red?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Bryant')),
  ('Why is the sky yellow?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Tad')),
  ('Why is the sky orange?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Bryant')),
  ('Why is the sky brown?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Tad')),
  ('Why is the sky clear?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Farid')),
  ('Why is the sky black?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Art')),
  ('Why is the sky purple?', 'Is it because of the color of the ocean?', (SELECT id FROM users WHERE fname = 'Farid')),
  ('Why is my pc slow?', 'Is it because I installed antivirus software ?', (SELECT id FROM users WHERE fname = 'Farid'));


INSERT INTO
  replies(question_id, user_id, body)
VALUES
  (1,(SELECT id FROM users WHERE fname = 'Tad'), 'Sky is red because of the reflection of light on the ocean'),
  (4,(SELECT id FROM users WHERE fname = 'Art'), 'Sky is blue because of the reflection of light on the ocean'),
  (3,(SELECT id FROM users WHERE fname = 'Farid'), 'Sky is orange because of the reflection of light on the ocean'),
  (5,(SELECT id FROM users WHERE fname = 'Farid'), 'Sky is black because of the reflection of light on the ocean'),
  (6,(SELECT id FROM users WHERE fname = 'Brad'), 'Sky is green because of the reflection of light on the ocean'),
  (2,(SELECT id FROM users WHERE fname = 'Bryant'), 'No, it''s you''re ram is old'),
  (3,(SELECT id FROM users WHERE fname = 'John'), 'No, it''s you''re hardrive is old'),
  (4,(SELECT id FROM users WHERE fname = 'Brad'), 'No, it''s you''re graphics is old'),
  (5,(SELECT id FROM users WHERE fname = 'Bryant'), 'No, it''s you''re processor is old');

INSERT INTO
  questions_follows(user_id, question_id)
VALUES
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky blue?'), (SELECT id FROM questions WHERE title = 'Why is the sky blue?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky red?'), (SELECT id FROM questions WHERE title = 'Why is the sky red?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky yellow?'), (SELECT id FROM questions WHERE title = 'Why is the sky yellow?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky orange?'), (SELECT id FROM questions WHERE title = 'Why is the sky orange?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky brown?'), (SELECT id FROM questions WHERE title = 'Why is the sky brown?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky clear?'), (SELECT id FROM questions WHERE title = 'Why is the sky clear?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky black?'), (SELECT id FROM questions WHERE title = 'Why is the sky black?')),
  ((SELECT user_id FROM questions WHERE title = 'Why is the sky purple?'), (SELECT id FROM questions WHERE title = 'Why is the sky purple?')),
  ((SELECT user_id FROM replies WHERE body = 'Sky is red because of the reflection of light on the ocean'), (SELECT question_id FROM replies WHERE body = 'Sky is red because of the reflection of light on the ocean')),
  ((SELECT user_id FROM replies WHERE body = 'Sky is blue because of the reflection of light on the ocean'), (SELECT question_id FROM replies WHERE body = 'Sky is blue because of the reflection of light on the ocean')),
  ((SELECT user_id FROM replies WHERE body = 'Sky is orange because of the reflection of light on the ocean'), (SELECT question_id FROM replies WHERE body = 'Sky is orange because of the reflection of light on the ocean')),
  ((SELECT user_id FROM replies WHERE body = 'Sky is black because of the reflection of light on the ocean'), (SELECT question_id FROM replies WHERE body = 'Sky is black because of the reflection of light on the ocean')),
  ((SELECT user_id FROM replies WHERE body = 'No, it''s you''re ram is old'), (SELECT question_id FROM replies WHERE body = 'No, it''s you''re ram is old')),
  ((SELECT user_id FROM replies WHERE body = 'No, it''s you''re hardrive is old'), (SELECT question_id FROM replies WHERE body = 'No, it''s you''re hardrive is old')),
  ((SELECT user_id FROM replies WHERE body = 'No, it''s you''re graphics is old'), (SELECT question_id FROM replies WHERE body = 'No, it''s you''re graphics is old')),
  ((SELECT user_id FROM replies WHERE body = 'No, it''s you''re processor is old'), (SELECT question_id FROM replies WHERE body = 'No, it''s you''re processor is old')),
  ((SELECT user_id FROM questions WHERE title = 'Why is my pc slow?'), (SELECT id FROM questions WHERE title = 'Why is my pc slow?'));

  INSERT INTO
    questions_likes(user_id, question_id)
  VALUES
    (1,2),
    (1,3),
    (1,4),
    (3,2),
    (3,3),
    (4,5),
    (6,2),
    (4,3),
    (2,2),
    (3,4);
