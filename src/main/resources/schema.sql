-- products テーブルがなければ作成
CREATE TABLE IF NOT EXISTS products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    hard VARCHAR(50),
    ken VARCHAR(100),
    kinds VARCHAR(100),
    base VARCHAR(100),
    is_recommended BOOLEAN DEFAULT FALSE,
    rank INT
);

-- product_variants テーブルがなければ作成
CREATE TABLE IF NOT EXISTS product_variants (
    id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    size_or_color VARCHAR(100),
    price INT NOT NULL,
    variant_image_url VARCHAR(255),
    stock INT DEFAULT 0,
    litl INT,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);