SET FOREIGN_KEY_CHECKS=0;

CREATE TABLE users (
	id INTEGER NOT NULL AUTO_INCREMENT, 
	username VARCHAR(100), 
	email VARCHAR(255), 
	password_hash VARCHAR(255) NOT NULL, 
	`role` ENUM('student','teacher') NOT NULL, 
	last_active_at DATETIME, 
	created_at DATETIME NOT NULL, 
	PRIMARY KEY (id), 
	UNIQUE (username), 
	UNIQUE (email)
);

CREATE TABLE classes (
	id INTEGER NOT NULL AUTO_INCREMENT, 
	teacher_id INTEGER NOT NULL, 
	name VARCHAR(150) NOT NULL, 
	invite_code VARCHAR(6) NOT NULL, 
	created_at DATETIME, 
	PRIMARY KEY (id), 
	FOREIGN KEY(teacher_id) REFERENCES users (id), 
	UNIQUE (invite_code)
);

CREATE TABLE class_members (
	class_id INTEGER NOT NULL, 
	student_id INTEGER NOT NULL, 
	joined_at DATETIME, 
	PRIMARY KEY (class_id, student_id), 
	FOREIGN KEY(class_id) REFERENCES classes (id), 
	FOREIGN KEY(student_id) REFERENCES users (id)
);

CREATE TABLE decks (
	id INTEGER NOT NULL AUTO_INCREMENT, 
	owner_id INTEGER NOT NULL, 
	title VARCHAR(255) NOT NULL, 
	description TEXT, 
	visibility ENUM('private','class'), 
	question_type ENUM('flashcard','fill_gap','mcq') NOT NULL, 
	class_id INTEGER, 
	created_at DATETIME, 
	PRIMARY KEY (id), 
	FOREIGN KEY(owner_id) REFERENCES users (id), 
	FOREIGN KEY(class_id) REFERENCES classes (id)
);

CREATE TABLE cards (
	id INTEGER NOT NULL AUTO_INCREMENT, 
	deck_id INTEGER NOT NULL, 
	card_type ENUM('flashcard','fill_gap','mcq') NOT NULL, 
	created_at DATETIME, 
	PRIMARY KEY (id), 
	FOREIGN KEY(deck_id) REFERENCES decks (id)
);

CREATE TABLE study_results (
	id INTEGER NOT NULL AUTO_INCREMENT, 
	user_id INTEGER NOT NULL, 
	deck_id INTEGER NOT NULL, 
	score INTEGER, 
	max_score INTEGER, 
	question_type VARCHAR(50) NOT NULL, 
	completed_at DATETIME, 
	PRIMARY KEY (id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	FOREIGN KEY(deck_id) REFERENCES decks (id)
);

CREATE TABLE card_fill_gap (
	card_id INTEGER NOT NULL, 
	question_text TEXT NOT NULL, 
	answers_json JSON NOT NULL, 
	PRIMARY KEY (card_id), 
	FOREIGN KEY(card_id) REFERENCES cards (id)
);

CREATE TABLE card_flashcard (
	card_id INTEGER NOT NULL, 
	front_text TEXT, 
	back_text TEXT, 
	cloze_template TEXT, 
	answers_json JSON, 
	PRIMARY KEY (card_id), 
	FOREIGN KEY(card_id) REFERENCES cards (id)
);

CREATE TABLE card_mcq (
	card_id INTEGER NOT NULL, 
	question_text TEXT NOT NULL, 
	options_json JSON NOT NULL, 
	correct_index INTEGER NOT NULL, 
	explanation_text TEXT, 
	PRIMARY KEY (card_id), 
	FOREIGN KEY(card_id) REFERENCES cards (id)
);

CREATE TABLE card_progress (
	user_id INTEGER NOT NULL, 
	card_id INTEGER NOT NULL, 
	next_review_date DATE, 
	ease_factor NUMERIC(4, 2), 
	interval_days INTEGER, 
	repetitions INTEGER, 
	PRIMARY KEY (user_id, card_id), 
	FOREIGN KEY(user_id) REFERENCES users (id), 
	FOREIGN KEY(card_id) REFERENCES cards (id)
);

INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role`, `last_active_at`, `created_at`) VALUES (1, 'Mr. Teacher', 'teacher@gmail.com', 'scrypt:32768:8:1$SWs9UUGrolnbLTdk$ea59e4033cdab5324904051d4103bf1da019a313a8ff0ef3797cdd51128b62150eff22497d621049018279275f86d2d99ad866dd5a52b9b38d5dbd62d3ac89d6', 'teacher', NULL, '2026-02-03 07:04:46.494148');
INSERT INTO `users` (`id`, `username`, `email`, `password_hash`, `role`, `last_active_at`, `created_at`) VALUES (2, 'tomuk001134', 'tomuk001134@gmail.com', 'scrypt:32768:8:1$0uIVcherhj8ubgLE$2cd2e0cb8d9b57a94ebd36a2c336c4baae9e1c0f54ee8f2e46a101733084335a6f7fc3fd12e728cc037c481a37461e6cfbd7d3333c118801ae603ef687970723', 'student', NULL, '2026-02-03 07:04:46.887000');

INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (1, 1, 'AP World History', 'HIST01', '2026-02-03 07:04:47.019257');
INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (2, 1, 'Intro to Biology', 'BIO101', '2026-02-03 07:04:47.019261');
INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (3, 1, 'Calc BC - Section 4', 'CALC04', '2026-02-03 07:04:47.019263');
INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (4, 1, 'Spanish III Honors', 'SPAN03', '2026-02-03 07:04:47.019265');
INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (5, 1, 'Class 01', '1TO4DF', '2026-02-03 07:30:34.087666');
INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (6, 1, 'economic', '5W4J0F', '2026-02-09 07:42:51.300777');
INSERT INTO `classes` (`id`, `teacher_id`, `name`, `invite_code`, `created_at`) VALUES (7, 1, 'class 36', 'TC69UD', '2026-03-24 03:43:06.106757');

INSERT INTO `class_members` (`class_id`, `student_id`, `joined_at`) VALUES (1, 2, '2026-03-24 03:46:14.468044');

INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (3, 1, 'Deck 01', 'Test deck 01', 'private', 'flashcard', NULL, '2026-02-03 07:05:13.883330');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (4, 1, 'Deck 01', 'Test deck 01', 'private', 'flashcard', NULL, '2026-02-03 07:06:54.971929');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (6, 1, 'Class 01 - deck 01', 'Description Class 01 - deck 01', 'class', 'flashcard', 5, '2026-02-03 07:32:33.682845');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (7, 1, 'class 01 - deck 02', 'decs class 01 - deck 02', 'class', 'flashcard', 5, '2026-02-03 07:38:44.178554');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (8, 1, 'Cell Structure', 'Learn about cell structure.', 'class', 'flashcard', 2, '2026-02-03 08:12:50.574401');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (9, 1, 'Genetics Basics', 'Learn about genetics basics.', 'class', 'flashcard', 2, '2026-02-03 08:12:50.596426');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (10, 1, 'Evolutionary Biology', 'Learn about evolutionary biology.', 'class', 'flashcard', 2, '2026-02-03 08:12:50.610666');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (15, 1, 'flashcard', NULL, 'class', 'flashcard', 5, '2026-02-06 04:35:00.294805');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (16, 1, 'Test MCQ', NULL, 'class', 'mcq', 5, '2026-02-06 06:40:27.358936');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (17, 1, 'inflation ', NULL, 'class', 'mcq', 6, '2026-02-09 07:43:02.394506');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (18, 2, 'flash', NULL, 'private', 'flashcard', NULL, '2026-03-24 00:03:22.420279');
INSERT INTO `decks` (`id`, `owner_id`, `title`, `description`, `visibility`, `question_type`, `class_id`, `created_at`) VALUES (19, 2, 'fill', NULL, 'private', 'fill_gap', NULL, '2026-03-24 01:06:33.378558');

INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (41, 8, 'flashcard', '2026-02-03 08:13:25.305456');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (42, 8, 'fill_gap', '2026-02-03 08:13:25.314784');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (43, 8, 'mcq', '2026-02-03 08:13:25.323859');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (50, 15, 'flashcard', '2026-02-06 04:35:11.471730');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (51, 16, 'mcq', '2026-02-06 08:43:45.163881');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (52, 16, 'mcq', '2026-02-06 08:43:45.171551');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (53, 16, 'mcq', '2026-02-06 08:43:45.175285');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (54, 16, 'mcq', '2026-02-06 08:43:45.176171');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (55, 16, 'mcq', '2026-02-06 08:43:45.176987');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (56, 17, 'mcq', '2026-02-09 07:43:27.255846');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (57, 17, 'mcq', '2026-02-09 07:43:27.267454');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (58, 17, 'mcq', '2026-02-09 07:43:27.268475');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (59, 17, 'mcq', '2026-02-09 07:43:27.268475');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (60, 17, 'mcq', '2026-02-09 07:43:27.269500');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (61, 17, 'mcq', '2026-02-09 07:43:27.269500');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (62, 17, 'mcq', '2026-02-09 07:43:27.270503');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (63, 17, 'mcq', '2026-02-09 07:43:27.270503');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (64, 17, 'mcq', '2026-02-09 07:43:27.271521');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (65, 17, 'mcq', '2026-02-09 07:43:27.271521');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (66, 18, 'flashcard', '2026-03-24 00:03:27.925724');
INSERT INTO `cards` (`id`, `deck_id`, `card_type`, `created_at`) VALUES (67, 19, 'fill_gap', '2026-03-24 01:06:57.951888');

INSERT INTO `card_fill_gap` (`card_id`, `question_text`, `answers_json`) VALUES (42, 'The _____ stores the cell''s DNA.', '["Nucleus"]');
INSERT INTO `card_fill_gap` (`card_id`, `question_text`, `answers_json`) VALUES (67, '1+1=?', '["2"]');

INSERT INTO `card_flashcard` (`card_id`, `front_text`, `back_text`, `cloze_template`, `answers_json`) VALUES (41, 'What is the function of the Mitochondria?', 'It produces energy for the cell (Powerhouse).', NULL, NULL);
INSERT INTO `card_flashcard` (`card_id`, `front_text`, `back_text`, `cloze_template`, `answers_json`) VALUES (50, 'ád', 'ádd', NULL, NULL);
INSERT INTO `card_flashcard` (`card_id`, `front_text`, `back_text`, `cloze_template`, `answers_json`) VALUES (66, 'ád', 'ádd', NULL, NULL);

INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (43, 'Which of the following is NOT a type of cell division?', '["Mitosis", "Meiosis", "Photosynthesis", "Binary Fission"]', 2, 'Photosynthesis is a process used by plants to make food, not cell division.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (51, 'Which characteristic is used by Python to define blocks of code, distinguishing it from languages like C++ and Java?', '["Semicolons at the end of each line", "Significant indentation", "Curly braces ({})", "XML tags"]', 1, 'The content explicitly states that Python uses significant indentation to define code blocks, unlike C++ or Java which use curly braces.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (52, 'Who is credited with creating the Python programming language and when was it first released?', '["James Gosling, 1995", "Bjarne Stroustrup, 1983", "Guido van Rossum, 1991", "Linus Torvalds, 1991"]', 2, 'Python was created by Guido van Rossum and was first released in 1991, according to the provided text.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (53, 'Python is described as a ''batteries included'' language primarily because of which feature?', '["Its ability to support multiple programming paradigms", "Its emphasis on code readability", "Its comprehensive standard library", "Its use in artificial intelligence"]', 2, 'The text explains that Python is often described as a ''batteries included'' language because of its comprehensive standard library.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (54, 'Which of the following describes the key technical typing and memory management features of Python mentioned in the text?', '["Statically typed and manually managed memory", "Compiled and uses reference counting", "Dynamically typed and garbage-collected", "Low-level and uses fixed-size variables"]', 2, 'The content states that Python is dynamically typed and garbage-collected.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (55, 'In which broad fields is Python widely utilized, as listed in the provided content?', '["Embedded systems, operating system kernel development, and mainframe computing", "Game engine creation, blockchain technology, and mobile app development", "Web development (Django/Flask), data science, and artificial intelligence", "Database administration, network configuration, and legacy system migration"]', 2, 'The content specifically lists web development (using frameworks like Django and Flask), data science, artificial intelligence, and scientific computing as fields where Python is widely used.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (56, 'Which term describes the economic phenomenon where the general demand for goods and services exceeds the economy''s capacity to produce them?', '["Cost-Push Inflation", "Built-In Inflation", "Demand-Pull Inflation", "Hyperinflation"]', 2, 'Demand-Pull Inflation occurs specifically when aggregated demand is greater than the total supply or production capacity of the economy. The text describes this using the phrase ''Too much money chasing too few goods''.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (57, 'The primary consequence of a rising general price level (inflation) is:', '["An increase in the purchasing power of money.", "A stabilization of production costs across all sectors.", "A reduction in the purchasing power of money.", "The elimination of the need for central bank intervention."]', 2, 'According to the definition provided, when the general price level rises, each unit of currency buys fewer goods and services than before, which reflects a reduction in the purchasing power of money.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (58, 'If businesses are forced to raise retail prices specifically because of higher production costs, such as increased raw material prices or mandatory wage hikes, this is an example of which type of inflation?', '["Demand-Pull Inflation", "Cost-Push Inflation", "Built-In Inflation", "Creeping Inflation"]', 1, 'Cost-Push Inflation arises directly when input costs (like wages or raw materials) increase, compelling businesses to raise their selling prices to maintain profit margins.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (59, 'What is the key driver that creates the ''wage-price spiral'' associated with Built-In Inflation?', '["Unexpected government deregulation.", "A sudden, massive increase in the money supply.", "Workers'' and businesses'' expectations that prices will rise in the future.", "A drop in consumer confidence leading to reduced spending."]', 2, 'Built-In Inflation is driven by expectations. When people expect prices to rise, workers demand higher wages and businesses set higher prices, creating a reinforcing cycle (the wage-price spiral).');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (60, 'What level of inflation do most central banks currently aim to maintain, as stated in the content, due to its beneficial effects?', '["A deflationary environment (0% or below).", "A high rate (over 10%) to promote government revenue.", "A hyperinflationary environment.", "A low and stable rate, typically around 2%."]', 3, 'The text explicitly states that central banks aim to maintain a low and stable inflation rate, typically around 2%, as high inflation is destabilizing.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (61, 'One positive outcome of maintaining a mild, stable inflation rate is that it encourages:', '["The hoarding of cash assets.", "Consumption and investment.", "Deflationary spirals.", "Government budget surpluses."]', 1, 'The text states that a mild level of inflation is beneficial because it encourages consumption and investment, contrasting with cash hoarding, which happens when people expect prices to fall (deflation).');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (62, 'When inflation is high or hyperinflationary, its major negative economic impact is:', '["A proportional increase in the value of all fixed assets.", "A strengthening of the national currency''s exchange rate.", "Economic destabilization due to the erosion of the value of savings.", "A sudden, beneficial drop in unemployment rates."]', 2, 'High inflation or hyperinflation destabilizes an economy primarily by eroding the real value of savings held by individuals and institutions.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (63, 'Which statement accurately defines the general concept of inflation in economics?', '["A decrease in the cost of raw materials over time.", "The general increase in the prices of goods and services over a period of time.", "A short-term fluctuation in the stock market index.", "The balance achieved when supply equals demand."]', 1, 'Inflation is fundamentally defined as the general increase in the prices of goods and services in an economy over a period of time.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (64, 'The concept of Built-In Inflation is most closely related to:', '["Supply shocks related to international trade wars.", "Monetary policy errors causing rapid currency devaluation.", "The self-fulfilling nature of economic expectations.", "Excessive government borrowing."]', 2, 'Built-In Inflation is rooted in expectations: if workers and businesses expect prices to rise, they act preemptively (demanding higher wages/setting higher prices), thereby causing the very inflation they anticipated.');
INSERT INTO `card_mcq` (`card_id`, `question_text`, `options_json`, `correct_index`, `explanation_text`) VALUES (65, 'If the government introduces a massive stimulus package causing consumers to have significantly more disposable income than the economy can handle in terms of output, which type of inflation is most likely to result?', '["Cost-Push Inflation", "Demand-Pull Inflation", "Structural Inflation", "Deflation"]', 1, '');

SET FOREIGN_KEY_CHECKS=1;
