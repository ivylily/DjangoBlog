/* Top ten in overrall sales */
select p.productname, sum(od.quantity * od.unitprice *discount) [Total sales], p.discontinued 
from Products p 
join OrderDetails od on od.productid = p.productid 
--where p.discontinued = 0
group by p.productname
order by 2 desc
limit 10;


/**/
select p.productname, sum(od.quantity) [Total sales] from Products p join OrderDetails od on od.productid = p.productid group by p.productname
order by 2 desc
limit 10;


/* The most selled product by month */
WITH Product_Sales_PerMonth AS (
	select 
	p.productname, 
	STRFTIME('%Y-%m',o.orderdate) AS ordermonth, 
	SUM(od.quantity* od.unitprice) AS total_cost,
	SUM(od.quantity) As total_quantity
	FROM Products p JOIN OrderDetails od on p.productid = od.productid
	JOIN Orders o on o.orderid = od.orderid
	GROUP BY p.productname, 2
),
Max_Product_Sale_PerMonth AS (
	select max(total_cost) max_total_cost,
	ordermonth
	from Product_Sales_PerMonth 
	group by ordermonth 
	order by ordermonth
)
select ps.* from Product_Sales_PerMonth ps join Max_Product_Sale_PerMonth ms on ps.ordermonth = ms.ordermonth and ps.total_cost = ms.max_total_cost 
order by ordermonth desc





/*Units need restock on top selling cities */
with top_selling_cities as (
select 
o.shipcity, 
o.shipcountry, 
SUM(od.quantity * od.Unitprice) total_sale
from orders o join OrderDetails od on o.orderid = od.orderid
group by o.shipcity, o.shipcountry
order by 3 desc
limit 5
)

select distinct p.* from top_selling_cities tsc 
join orders o on tsc.shipcity = o.shipcity and tsc.shipcountry = o.shipcountry
join OrderDetails od on o.orderid = od.orderid
join products p on od.productid = p.productid
where discontinued = 0 and unitsinstock < reorderlevel

