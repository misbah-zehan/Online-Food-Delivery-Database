
create table restaurant (
id serial primary key,
name varchar(50),
location varchar(50) 
);
 
create table menus(
id seri primary key ,
restaurant_id int,
item_name varchar(50),
price decimal(10,2),
foreign key (restaurant_id) references restaurant(id) 
);

create table customers(
id int primary key auto_increment,
name varchar(50),
address varchar(50)
);

create table delivery_agents(
id int primary key auto_increment,
name varchar(50),
status enum('available','busy')
);

create table orders(
id int primary key auto_increment,
customer_id int,
restaurant_id int,
total decimal(10,2),
agent_id int,
status enum('delivered','cancelled'),
foreign key(customer_id) references customers(id),
foreign key(restaurant_id) references restaurant(id),
foreign key(agent_id) references delivery_agents(id)
);

create table order_items(
id int primary key auto_increment,
order_id int,
menu_id int,
quantity int default 1,
foreign key (order_id) references orders(id),
foreign key (menu_id) references menus(id)
);

-- Now insert data 
use restaurant_db;

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

-- use restaurant_db;
insert into order_items(order_id,menu_id,quantity) values
(1,1,1),
(1,2,1),
(2,4,1),
(2,7,1),
(3,8,1),
(4,5,1) ;

-- top 3 items by sales
select m.item_name, sum(oi.quantity * m.price) as total_sales 
from order_items oi 
join orders o on o.id = oi.order_id
join menus m on oi.menu_id=m.id
where o.status='delivered'
group by m.id, m.item_name
order by total_sales desc
limit 3;

-- count deliverd orders
select status,count(*) as count
from orders group by status;

-- List restaurants with most order 
select r.name , count(o.id) as total_orders
from orders o 
join restaurant r on o.restaurant_id=r.id
group by r.name
order by total_orders desc;

-- assign delivery agents   
select o.id as order_id,r.name as restaurant,d.name as agent
from orders o join restaurant r on o.restaurant_id=r.id
join delivery_agents d on o.agent_id=d.id ;

-- revenue per restaurant
select r.name , sum(o.total) as revenue 
from orders o
join restaurant r on o.restaurant_id=r.id
where status='delivered'
group by r.name ;

select * from menus;
select * from customers;
select * from restaurant;
select * from delivery_agents;
select * from order_items;