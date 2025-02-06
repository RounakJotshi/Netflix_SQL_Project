create table net_1
(show_id varchar(10),	tpe varchar(20),	title varchar(150),	director varchar(208),	casts varchar(1000), country varchar(150),	date_added varchar(50),	release_year int, rating varchar(15),	duration varchar(15),	listed_in varchar(100),	description varchar(250)
);
select *from net_1;

select count(show_id) as total_content from net_1;

select distinct tpe from net_1; 

-- counting of number of tv shows and movies
select tpe,count(*)as total_contents from net_1 group by tpe;

--each rating
select tpe,rating,count(*),
rank() over(partition by tpe order by count(*) desc)as ranking from net_1 
group by tpe,rating order by 1,3 desc;

--ranking
select tpe,rating from
(select tpe,rating,count(*),
rank() over(partition by tpe order by count(*)desc)as ranking from net_1 
group by tpe,rating )as t1 where ranking=1;

--movies release in 2022
select *from net_1 where tpe='Movie' and release_year=2020;

--top 5 countries with most content on netflix
select unnest(string_to_array(country,','))as new_country,
count(show_id) as total_content from net_1 group by 1 order by 2 desc limit 5;

--longest movie 
select *from net_1 where tpe='Movie' and duration=(select max(duration) from net_1); 

--find the content which was added last 5 years
select *from net_1 where to_date(date_added,'Month,DD,YYYY')>=current_date-interval'5 years';

--tv shows and movies made by rajiv chilaka'
select *from net_1 where director ilike'%Rajiv Chilaka%';

--tv shows more then 5 seasons
select * from net_1 where tpe='TV Show' and split_part (duration,' ',1)::numeric>5 ;

--count geners
select unnest(string_to_array(listed_in,',')) as gener,
count(show_id) as total from net_1 group by 1;

--total number from india
select extract(year from to_date(date_added,'Month,DD,YYYY'))as years,
count(*),round(count(*)::numeric/(select count(*) from net_1 where country='India')*100,2) as avg_movies from net_1 
where country='India' group by 1;

--counting documentires
select count(show_id) as num_of_doc from net_1 where listed_in ilike '%Documentaries%';

--all directors are null
select * from net_1 where director is NULL;

--salman khan movies 
select * from net_1 where casts ilike '%Salman Khan%'and release_year>extract(year from current_date)-10;

--top 10 actors which appear in highigest number of movies 
select unnest(string_to_array(casts,',')) as actors,count(show_id) from net_1 
where country ilike '%india%' group by actors order by 2 desc limit 10 ;

--categorize the content on the bases of the keyword "kill" or "violence" in the 
--description feild. label these content as "bad" and all other "good".count the content in each one
with new_table as(
select *,
 case
   when
   description ilike'%kill%' or 
   description ilike'%violence%' then 'bad_content' 
   else 'good_content'
 end category 
   from net_1 )
   select category ,count(*) as total_content from new_table group by 1 ;