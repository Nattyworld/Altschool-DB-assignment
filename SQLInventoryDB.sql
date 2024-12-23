-- Creation of Entities (Users, Admins, Categories, Items, and Orders)

CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    username VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(50),
    middle_name VARCHAR(50),
    last_name VARCHAR(50),
    email_address VARCHAR(100) UNIQUE NOT NULL,
    mobile_number VARCHAR(20) UNIQUE NOT NULL,
    status ENUM('active', 'inactive', 'pending') DEFAULT 'pending',
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    user_type ENUM('User', 'Admin') NOT NULL
);

CREATE TABLE Admins (
    admin_id INT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT NOT NULL,
    last_modified_by INT NOT NULL,
    FOREIGN KEY (created_by) REFERENCES Admins(admin_id),
    FOREIGN KEY (last_modified_by) REFERENCES Admins(admin_id)
);

CREATE TABLE Items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    size ENUM('Small', 'Medium', 'Large') NOT NULL,
    category_id INT NOT NULL,
    created_by INT NOT NULL,
    last_modified_by INT NOT NULL,
    created_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_modified_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id),
    FOREIGN KEY (created_by) REFERENCES Admins(admin_id),
    FOREIGN KEY (last_modified_by) REFERENCES Admins(admin_id)
);

CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    status ENUM('Pending', 'Approved', 'Rejected') DEFAULT 'Pending',
    quantity INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    treated_by INT,
    treated_on TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (item_id) REFERENCES Items(item_id),
    FOREIGN KEY (treated_by) REFERENCES Admins(admin_id)
);

-- Insertion into the entities

INSERT INTO Users (username, first_name, middle_name, last_name, email_address, mobile_number, status, user_type)
VALUES 
    ('KolaqAlagbo', 'Kolaq', 'Junior', 'Alagbo', 'Kolaq_junior@gmail.com', '234900050000', 'active', 'User'),
    ('Alaguntan', 'Alaguntan', 'Hope', 'Deborah', 'Hope.Deborah@ymail.com', '234800070000', 'active', 'admin');

INSERT INTO Admins (user_id)
VALUES 
    (2); -- Admin associated with user_id 2

INSERT INTO Categories (name, description, created_by, last_modified_by)
VALUES
    ('Clothing', 'Apparel including shirts, trousers, and dresses', 1, 1),
    ('Furniture', 'Office and home furniture like chairs and tables', 2, 2),
    ('Footwear', 'Shoes, sandals, and other footwear', 1, 1);

INSERT INTO Items (name, price, size, category_id, created_by, last_modified_by)
VALUES
    ('T-shirt', 2500.00, 'Small', 1, 1, 1), -- Clothing
    ('Jeans', 7000.00, 'Medium', 1, 1, 1), -- Clothing
    ('Office Chair', 100000.00, 'Large', 2, 2, 2), -- Furniture
    ('Sneakers', 30000.00, 'Medium', 3, 1, 1), -- Footwear
    ('Sofa', 300000.00, 'Large', 2, 2, 2); -- Furniture

INSERT INTO Orders (user_id, item_id, status, quantity, approved_by, approved_on)
VALUES
    (3, 1, 'Pending', 2, NULL, NULL), -- Order not yet approved
    (4, 3, 'Approved', 1, 1, CURRENT_TIMESTAMP), -- Approved by Admin 1
    (5, 5, 'Rejected', 1, 2, CURRENT_TIMESTAMP), -- Rejected by Admin 2
    (6, 2, 'Pending', 1, NULL, NULL), -- Another pending order
    (7, 4, 'Approved', 3, 1, CURRENT_TIMESTAMP); -- Approved by Admin 1

-- Getting records from 2 or more entities

SELECT item_id, name AS item_name, price, size
FROM Items;

SELECT * from Orders;

-- Updating Records to 2 or More Entities

UPDATE Orders o
SET 
    o.status = 'Approved', 
    o.approved_by = 1, 
    o.approved_on = CURRENT_TIMESTAMP
WHERE 
    o.order_id = 1;

UPDATE Categories
SET 
    name = 'Food', 
    last_modified_by = 2
WHERE 
    category_id = 4;

-- Deleting Records from Two or More Entities

DELETE FROM Orders
WHERE order_id = 1;

DELETE FROM Users
WHERE user_id = 1;

-- Query Records from Multiple Entities Using Joins

SELECT 
    i.item_id, 
    i.name AS item_name, 
    c.name AS category_name, 
    u.username AS created_by
FROM 
    Items i
JOIN 
    Categories c ON i.category_id = c.category_id
JOIN 
    Admins a ON i.created_by = a.admin_id
JOIN 
    Users u ON a.user_id = u.user_id;

SELECT 
    o.order_id, 
    u.username AS ordered_by, 
    i.name AS item_name, 
    o.quantity, 
    o.status, 
    a.user_id AS admin_user_id, 
    admin_users.username AS admin_name
FROM 
    Orders o
JOIN 
    Users u ON o.user_id = u.user_id
JOIN 
    Items i ON o.item_id = i.item_id
LEFT JOIN 
    Admins a ON o.approved_by = a.admin_id
LEFT JOIN 
    Users admin_users ON a.user_id = admin_users.user_id;
