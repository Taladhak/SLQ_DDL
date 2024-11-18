-- from the terminal run:
-- psql < craiglist.sql

DROP DATABASE IF EXISTS craiglist;

CREATE DATABASE craiglist;

\c craiglist

-- Regions table to store different Craigslist regions
CREATE TABLE regions (
    region_id SERIAL PRIMARY KEY,
    region_name VARCHAR(100) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Users table with preferred region
CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    preferred_region_id INTEGER REFERENCES regions(region_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Categories table for post classification
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(50) NOT NULL,
    parent_category_id INTEGER REFERENCES categories(category_id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Posts table containing the main posting information
CREATE TABLE posts (
    post_id SERIAL PRIMARY KEY,
    title VARCHAR(200) NOT NULL,
    post_text TEXT NOT NULL,
    user_id INTEGER REFERENCES users(user_id),
    region_id INTEGER REFERENCES regions(region_id),
    location_address TEXT,
    location_lat DECIMAL(9,6),
    location_lng DECIMAL(9,6),
    status VARCHAR(20) DEFAULT 'active',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Junction table for posts and categories (many-to-many relationship)
CREATE TABLE post_categories (
    post_id INTEGER REFERENCES posts(post_id),
    category_id INTEGER REFERENCES categories(category_id),
    PRIMARY KEY (post_id, category_id)
);

-- Indexes for better query performance
CREATE INDEX idx_posts_region ON posts(region_id);
CREATE INDEX idx_posts_user ON posts(user_id);
CREATE INDEX idx_users_preferred_region ON users(preferred_region_id);
