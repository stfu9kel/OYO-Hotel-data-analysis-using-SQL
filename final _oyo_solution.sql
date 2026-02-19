create database oyoDB;
use oyo;

alter table oyo_sales rename column ï»¿booking_id to booking_id;
alter table oyo_city rename column ï»¿hotel_id to hotel_id;

# 2. No of  hotels in different cities.

select count(hotel_id) , city
from oyo_city
group by city;

# 3. Average room rates of different cities 

select C.CITY AS CITY,
AVG( S.AMOUNT) AS AVG_ROOM_RATES  
FROM OYO_CITY C JOIN OYO_SALES S 
ON C.HOTEL_ID = S.HOTEL_ID 
GROUP BY CITY 
order by AVG_ROOM_RATES 
desc;


# 1.  total records , No of Hotels & Total Cities etc.

select count(*) AS TOTATL_RECORD , 
count(HOTEL_ID) AS NO_OF_HOTEL , 
COUNT(distinct CITY) AS 
TOTAL_CITY from OYO_CITY;

# 4. Cancellation rates of different cities



select sum(s.status='Cancelled') /count(*)*100 as cancellation_rate ,c.city from  OYO_CITY C JOIN OYO_SALES S 
ON C.HOTEL_ID = S.HOTEL_ID 
GROUP BY CITY order by cancellation_rate desc;
 #method 2
select 
 sum(case
when status = "cancelled" then 1
else 0
end )/count(*)* 100 as "cancellation_rate",oyo_city.city
from oyo_sales inner join oyo_city on 
oyo_sales.hotel_id = oyo_city.hotel_id
group by oyo_city.city
order by cancellation_rate desc;


#Find total revenue from confirmed bookings.
select sum(case 
			when status='stayed' then amount
            else 0
            end) as total_ravenue from oyo_sales;
            
#method 2
select sum(amount) as total_ravenue from oyo_sales where status='stayed';

# 5.	- No of bookings of different cities in Jan Feb Mar Months.

#first i update the date value text to date formart by using update
update oyo_sales 
set check_out
= date_format( STR_TO_DATE(check_out,'%d-%m-%Y'),'%y-%m-%d');

select distinct month(date_of_booking) as months from oyo_sales;


select c.city, month(s.date_of_booking) as months ,count(*) as no_of_booking
from oyo_city c join oyo_sales s on s.hotel_id=c.hotel_id 
where month(date_of_booking) in (1,2,3) group by c.city ,months ;



DESC OYO_SALES;



# 6. What is the total number of bookings and the average number of rooms per booking?

select count(*) as no_of_bookings ,round(avg(no_of_rooms),2)as avg_rooms from oyo_sales ;

# 7. What are the top 5 cities with the highest number of bookings?
select c.city as top_city , count(s.booking_id) as no_of_booking from oyo_city c join oyo_sales s on
c.hotel_id = s.hotel_id group by top_city  order by no_of_booking desc limit 5 ;


# 8. How do bookings distribute across different statuses (e.g., confirmed, canceled, pending)?

select 
status 
,count(booking_id)as total_booking 
from oyo_sales group by status;


select 
case
when status= 'cancelled' then 'cancell'
when status = 'stayed' then 'confirm'
else 'pending' end as booking_status
,count(booking_id)as total_booking 
from oyo_sales group by status;


# 9. What is the total revenue generated and the total discount given ?

select sum(amount) as ravanue,sum(discount) as Total_discount from oyo_sales;


# 10.	What is the average booking amount per city in the month of frebuary march?
select round(avg(s.amount),2) as avg_amount ,c.city from oyo_city c join oyo_sales s on c.hotel_id = s.hotel_id 
where month(date_of_booking) in (2,3)
group by c.city order by avg_amount desc;


# 11. How many bookings were for single rooms vs. multiple rooms?

select case 
when no_of_rooms=1 then 'single room'
else 'multipule room' end as room_type
,count(*) as no_of_booking from oyo_sales group by room_type;



# 12.	What is the city wise average length of stay (in days) for bookings ?


SELECT C.city,round(AVG(DATEDIFF(S.check_out, S.check_in)),2) AS avg_stay_days
FROM OYO_CITY C JOIN OYO_SALES S
ON C.hotel_id = S.hotel_id
WHERE S.status = 'Stayed' GROUP BY C.city;




select count(*) as check_null  from oyo_sales where check_in is null;

# 13. Which customers have made the most bookings (top 10 by booking count)?
select customer_id , count(*) as most_booking from oyo_sales 
group by customer_id order by most_booking desc limit 10;


# 14.	What is the average discount percentage applied to bookings?

select count(*) as booking,avg(discount/amount)*100 as discount  
from oyo_sales ;

select *  from oyo_city;
select *  from oyo_sales;