// Creation of Collections (Users, Admins, Categories, Items, and Orders)
db.createCollection("users");

db.createCollection("admins");

db.createCollection("categories");

db.createCollection("items");

db.createCollection("orders");

// Insert into users collection
db.users.insertMany([
    {
        _id: 1,
        username: "KolaqAlagbo",
        first_name: "Kolaq",
        middle_name: "Junior",
        last_name: "Alagbo",
        email_address: "Kolaq_junior@gmail.com",
        mobile_number: "234900050000",
        status: "active",
        user_type: "User"
    },
    {
        _id: 2,
        username: "Alaguntan",
        first_name: "Alaguntan",
        middle_name: "Hope",
        last_name: "Deborah",
        email_address: "Hope.Deborah@ymail.com",
        mobile_number: "234800070000",
        status: "active",
        user_type: "admin"
    }
]);

// Insert into admins collection

db.admins.insertOne({
    _id: 1,
    user_id: 2,  // Referring to the user_id of the admin from the 'users' collection
    created_on: new Date(),
    last_modified_on: new Date()
});

// Insert into categories collection

db.categories.insertMany([
    {
        _id: 1,
        name: "Clothing",
        description: "Apparel including shirts, trousers, and dresses",
        created_by: 1,  // Referring to the admin_id from the 'admins' collection
        last_modified_by: 1
    },
    {
        _id: 2,
        name: "Furniture",
        description: "Office and home furniture like chairs and tables",
        created_by: 2,  // Referring to the admin_id from the 'admins' collection
        last_modified_by: 2
    },
    {
        _id: 3,
        name: "Footwear",
        description: "Shoes, sandals, and other footwear",
        created_by: 1,
        last_modified_by: 1
    }
]);

// Insert into items collection

db.items.insertMany([
    {
        _id: 1,
        name: "T-shirt",
        price: 2500.00,
        size: "Small",
        category_id: 1,  // Referring to the category_id from the 'categories' collection
        created_by: 1,   // Referring to the admin_id of the admin inserted above
        last_modified_by: 1
    },
    {
        _id: 2,
        name: "Jeans",
        price: 7000.00,
        size: "Medium",
        category_id: 1,
        created_by: 1,
        last_modified_by: 1
    },
    {
        _id: 3,
        name: "Office Chair",
        price: 100000.00,
        size: "Large",
        category_id: 2,
        created_by: 2,
        last_modified_by: 2
    }
]);

// Insert into orders collection

db.orders.insertMany([
    {
        _id: 1,
        user_id: 1,  // Referring to the user_id of the user from 'users' collection
        item_id: 1,  // Referring to the item_id from 'items' collection
        status: "Pending",
        quantity: 2,
        treated_by: null,
        treated_on: null
    },
    {
        _id: 2,
        user_id: 1,
        item_id: 3,
        status: "Approved",
        quantity: 1,
        treated_by: 1,  // Referring to the admin_id from the 'admins' collection
        treated_on: new Date()
    }
]);


// Find a specific item by _id

db.items.find({ _id: 1 });

// Find a specific category by _id

db.categories.findOne({ _id: 2 });


// Update an order status and treated_by admin

db.orders.updateOne(
    { _id: 1 },
    {
        $set: {
            status: "Approved",
            treated_by: 1,  // Referring to admin_id of admin from 'admins' collection
            treated_on: new Date()
        }
    }
);

// Update a category name and last_modified_by

db.categories.updateOne(
    { _id: 1 },
    {
        $set: {
            name: "Food",
            last_modified_by: 2  // Referring to admin_id from 'admins' collection
        }
    }
);


// Delete an order by _id

db.orders.deleteOne({ _id: 1 });

// Delete a user by _id

db.users.deleteOne({ _id: 1 });


// Get Items and their Category information using $lookup
db.items.aggregate([
    {
        $lookup: {
            from: "categories",      // Collection to join with
            localField: "category_id",  // Field from 'items' collection
            foreignField: "_id",     // Field from 'categories' collection
            as: "category_info"      // Name of the output array
        }
    }
]);

// Get Orders, User, Item, and Admin details using $lookup
db.orders.aggregate([
    {
        $lookup: {
            from: "users",               // Join with 'users' collection
            localField: "user_id",        // Field from 'orders' collection
            foreignField: "_id",          // Field from 'users' collection
            as: "ordered_by"              // Output field
        }
    },
    {
        $lookup: {
            from: "items",               // Join with 'items' collection
            localField: "item_id",        // Field from 'orders' collection
            foreignField: "_id",          // Field from 'items' collection
            as: "item_details"            // Output field
        }
    },
    {
        $lookup: {
            from: "admins",              // Join with 'admins' collection
            localField: "treated_by",     // Field from 'orders' collection
            foreignField: "_id",          // Field from 'admins' collection
            as: "admin_details"           // Output field
        }
    }
]);
