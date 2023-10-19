create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');


/*1- write a query to produce below output from icc_world_cup table.
team_name, no_of_matches_played , no_of_wins , no_of_losses */

select * from icc_world_cup;


with team as (
select Team_1 as Team , case when Team_1 = Winner then 1 else 0 end as win_match from icc_world_cup
union all
select Team_2 as Team , case when Team_2 = Winner then 1 else 0 end as win_match from icc_world_cup
) 
select Team, COUNT(*) as Ttl_mths_Plyd, SUM(win_match) as Total_Wins,
COUNT(*) - SUM(win_match) as Total_loss
from team 
group by Team 
order by SUM(win_match) desc;

/*2- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name)
customer_name, first_name,last_name */

select customer_name , trim(SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))) as first_name
, SUBSTRING(customer_name,CHARINDEX(' ',customer_name)+1,len(customer_name)-CHARINDEX(' ',customer_name)+1) as second_name
from Orders


create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');



/*3- write a query to print below output using drivers table. 
Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
id, total_rides , profit_rides
dri_1,5,1
dri_2,2,0 */

select * from drivers 


select id, count(1) as total_rides
,sum(case when end_loc=next_start_location then 1 else 0 end ) as profit_rides
from (
select *
, lead(start_loc,1) over(partition by id order by start_time asc) as next_start_location
from drivers) A
group by id;


/*4- write a query to print customer name and 
no of occurence of character 'n' in the customer name.
customer_name , count_of_occurence_of_n */


select customer_name , len(customer_name)-len(replace(lower(customer_name),'n','')) as count_of_occurence_of_n
from Orders

Andrew Allen
andrew allen
andrew alle
12 - 11
1

 /*5-write a query to print below output from orders data. example output
hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, ,
category, Furniture, ,
category, Office Supplies, ,
sub_category, Art , ,
sub_category, Furnishings, ,
--and so on all the category ,subcategory and ship_mode hierarchies */

select * from Orders


select 'category' as hierarchy_type,category as hierarchy_name,
SUM(case when region= 'West' then sales end) as Total_sales_west,
SUM(case when region='East' then sales end) as Total_sales_East
from Orders 
group by category
union all 
select 'sub_category', sub_category,
SUM(case when region= 'West' then sales end) as Total_sales_west,
SUM(case when region= 'East' then sales end ) as Total_sales_East
from Orders
group by sub_category
union all 
select 'ship_mode', ship_mode,
SUM(case when region ='West' then sales end) as Total_sales_west,
SUM(case when region ='East' then sales end) as Total_sales_East
from Orders
group by ship_mode 

/*6- the first 2 characters of order_id represents the country of order placed . 
write a query to print total no of orders placed in each country 
(an order can have 2 rows in the data
when more than 1 item was purchased in the order but it should be considered as 1 order)*/

select SUBSTRING(order_id, 1,2) as Country_code, COUNT( distinct order_id) as Total_orders
from Orders
group by  SUBSTRING(order_id, 1,2)

