# Restaurant Delivery Database (PostgreSQL)

A beginner-friendly SQL project that models a food delivery system: restaurants, menus, customers, delivery agents, orders and the items inside each order. It includes sample data and practice queries for common business questions such as top-selling items and revenue per restaurant.

Originally built in MySQL and then ported to PostgreSQL.

## Tech Stack

- PostgreSQL 18
- pgAdmin 4 (Query Tool / PSQL Tool)

## Database Schema

| Table | Purpose | Key columns |
|---|---|---|
| `restaurant` | Restaurants on the platform | `id`, `name`, `location` |
| `menus` | Items sold by each restaurant | `id`, `restaurant_id` (FK), `item_name`, `price` |
| `customers` | People who place orders | `id`, `name`, `address` |
| `delivery_agents` | Delivery staff | `id`, `name`, `status` (`available` / `busy`) |
| `orders` | One row per order | `id`, `customer_id` (FK), `restaurant_id` (FK), `agent_id` (FK), `total`, `status` (`delivered` / `cancelled`) |
| `order_items` | Which menu items are in each order | `id`, `order_id` (FK), `menu_id` (FK), `quantity` |

### Relationships

```
restaurant 1 ──< menus
restaurant 1 ──< orders
customers  1 ──< orders
delivery_agents 1 ──< orders
orders     1 ──< order_items >── 1 menus
```

`order_items` is a junction table. Without it, item-level sales cannot be calculated, because `orders` only stores the order total and not which items were bought.


## Table Definitions

```sql
create table restaurant (
  id serial primary key,
  name varchar(50),
  location varchar(50)
);

create table menus (
  id serial primary key,
  restaurant_id int,
  item_name varchar(50),
  price decimal(10,2),
  foreign key (restaurant_id) references restaurant(id)
);

create table customers (
  id serial primary key,
  name varchar(50),
  address varchar(50)
);

create table delivery_agents (
  id serial primary key,
  name varchar(50),
  status varchar(20) check (status in ('available','busy'))
);

create table orders (
  id serial primary key,
  customer_id int,
  restaurant_id int,
  total decimal(10,2),
  agent_id int,
  status varchar(20) check (status in ('delivered','cancelled')),
  foreign key (customer_id) references customers(id),
  foreign key (restaurant_id) references restaurant(id),
  foreign key (agent_id) references delivery_agents(id)
);

create table order_items (
  id serial primary key,
  order_id int,
  menu_id int,
  quantity int default 1,
  foreign key (order_id) references orders(id),
  foreign key (menu_id) references menus(id)
);
```

## Sample Data

Insert in this order, because later tables depend on earlier ones:

```sql
insert into restaurant(name,location) values
('Burger point','Down town'),
('Pizza point','Salt lake'),
('Sushi world','City centre');

insert into menus(restaurant_id,item_name,price) values
(1,'Cheese burger',5.99),
(1,'Veggie Burger',4.99),
(1,'French fries',2.99),
(2,'Margherita pizza',9.99),
(2,'Pepporoni pizza',9.99),
(2,'Cheese corn pizza',11.49),
(2,'Coca-cola',3.99),
(3,'Salmon sushi',15.00),
(3,'Avocado sushi',8.99),
(3,'Veg California roll',8.99);

insert into customers(name,address) values
('Misbah','Oak street'),
('Zehan','Lake side'),
('Eren','Lougue town');

insert into delivery_agents(name,status) values
('John','available'),
('Mike','available'),
('sara','busy');

insert into orders(customer_id,restaurant_id,total,agent_id,status) values
(1,1,10.98,1,'delivered'),
(2,2,13.98,1,'cancelled'),
(3,3,15.00,2,'delivered'),
(1,2,9.99,2,'delivered');

insert into order_items(order_id,menu_id,quantity) values
(1,1,1),
(1,2,1),
(2,4,1),
(2,7,1),
(3,8,1),
(4,5,1);
```

Expected row counts: `restaurant` 3, `menus` 10, `customers` 3, `delivery_agents` 3, `orders` 4, `order_items` 6.

## Practice Queries

### 1. Top 3 items by sales (delivered orders only)


| item_name | total_sales |
|---|---|
| Salmon sushi | 15.00 |
| Pepporoni pizza | 9.99 |
| Cheese burger | 5.99 |

### 2. Count of orders by status


Result: `delivered` = 3, `cancelled` = 1.

### 3. Restaurants with the most orders


Result: Pizza point = 2, Burger point = 1, Sushi world = 1.

### 5. Revenue per restaurant (delivered orders only)


Result: Sushi world = 15.00, Burger point = 10.98, Pizza point = 9.99.

## Concepts Practiced

- Primary keys with `serial`, foreign keys, `check` constraints
- Junction tables for many-to-many relationships
- `join`, `left join`, `group by`, `order by`, `limit`
- Aggregate functions: `count`, `sum`
