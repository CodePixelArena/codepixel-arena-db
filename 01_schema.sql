-- Drop and recreate schema
DROP SCHEMA IF EXISTS public CASCADE;
CREATE SCHEMA public;

CREATE TABLE admins (
    admin_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE challenges (
    challenge_id SERIAL PRIMARY KEY,
    title VARCHAR(120) NOT NULL,
    slug VARCHAR(140) NOT NULL UNIQUE,
    description TEXT NOT NULL,
    difficulty VARCHAR(10) NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
    reward_pixels INT NOT NULL DEFAULT 1,
    created_by_admin_id INT NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_challenges_admin FOREIGN KEY (created_by_admin_id) REFERENCES admins(admin_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE test_cases (
    test_case_id SERIAL PRIMARY KEY,
    challenge_id INT NOT NULL,
    created_by_admin_id INT NOT NULL,
    input_data TEXT NOT NULL,
    expected_output TEXT NOT NULL,
    is_sample BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_test_cases_challenge FOREIGN KEY (challenge_id) REFERENCES challenges(challenge_id) ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_test_cases_admin FOREIGN KEY (created_by_admin_id) REFERENCES admins(admin_id) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE submissions (
    submission_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL,
    challenge_id INT NOT NULL,
    code TEXT NOT NULL,
    language VARCHAR(20) NOT NULL CHECK (language IN ('python', 'java', 'cpp', 'javascript', 'sql')),
    result VARCHAR(30) NOT NULL CHECK (result IN ('Accepted', 'Wrong Answer', 'Time Limit Exceeded', 'Runtime Error')),
    execution_time_ms DECIMAL(8,2) NOT NULL,
    memory_kb INT NOT NULL,
    submitted_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_submissions_user FOREIGN KEY (user_id) REFERENCES users(user_id) ON UPDA
