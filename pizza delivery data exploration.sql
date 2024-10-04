create database pizzahut;
create table orders(
 order_id int not null primary key,
 order_date date not null,
 order_time time not null
 );
 
create table order_details(
 order_details_id int not null,
 order_id int not null,
 pizza_id text not null,
 quantity int not null,
 primary key(order_details_id)
 );
 
 -- ==============================================================================================================================================================================
 -- ======================================================= data analysis =========================================================================================================
 
 -- retrieve the total no of orders placed 
 
 select count(order_id) as total_orders from orders;
 
 -- calculate the total revenue generated from pizza sales
 
 select round(sum(o.quantity*p.price),2) as total_sales 
 from order_details o join pizzas p on o.pizza_id=p.pizza_id;
 
-- highest priced pizza
select pt.name,p.price
from pizza_types pt join pizzas p on pt.pizza_type_id=p.pizza_type_id
order by p.price desc limit 1;

-- identify the most common pizza size ordered
select quantity,count(order_details_id)
from order_details group by quantity;

-- identify the most common pizza size ordered

select pizzas.size,count(order_details.order_details_id) as order_count
from pizzas join order_details on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size order by order_count desc limit 1;

-- list the top 5 most ordered pizza along with their quantity

select sum(order_details.quantity) as quantity,pizza_types.name
from pizza_types join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
 join order_details on order_details.pizza_id=pizzas.pizza_id
 group by pizza_types.name
 order by quantity desc limit 5;
 
 -- total quantity of each pizza category ordered
 select sum(order_details.quantity) as quantity,pizza_types.category
from pizza_types join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
 join order_details on order_details.pizza_id=pizzas.pizza_id
 group by pizza_types.category
 order by quantity desc limit 5;
 
 -- determine the distribution of orders by hour of the day
 select hour(order_time) as hour,count(order_id) as order_count from orders
 group by hour(order_time);
 
 -- category wise distribution of pizzas
 select category,count(name) from pizza_types
 group by category;
 
 -- group orders by date and calculate the average no of pizzas ordered per day..
 -- subquery
 
select avg(quantity) from
(select orders.order_date,sum(order_details.quantity) as quantity 
 from orders join order_details on orders.order_id=order_details.order_id
 group by orders.order_date) as order_quantity;
 
 -- determine the top 3 most ordered pizza types based on revenue
 select pizza_types.name,
 sum(order_details.quantity*pizzas.price) as revenue
 from pizza_types join pizzas
 on pizzas.pizza_type_id=pizza_types.pizza_type_id
 join order_details on order_details.pizza_id=pizzas.pizza_id
 group by pizza_types.name order by revenue desc limit 3;
 
 
 
 