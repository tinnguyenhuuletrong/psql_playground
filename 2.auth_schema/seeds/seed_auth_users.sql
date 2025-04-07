-- Insert admin user (password: admin123)
INSERT INTO "auth".users (name, password, role)
VALUES (
    'admin',
    '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9', -- SHA256 of 'admin123'
    'admin'
);

-- Insert regular user (password: user123)
INSERT INTO "auth".users (name, password, role)
VALUES (
    'user',
    'ec4e3fec09d4559f80a4a80f043659a3c8e8b9541d8f6853757691dbe099d326', -- SHA256 of 'user123'
    'user'
);
