-- 1. Get all customers and their addresses.

SELECT * 
FROM customers
JOIN addresses
	ON customers.id=addresses.customer_id;

1	Lisa	Bonet	555 Some Pl	Chicago	IL	60611	business
1	Lisa	Bonet	1 Main St	Detroit	MI	31111	home
2	Charles	Darwin	8900 Linova Ave	Minneapolis	MN	55444	home
3	George	Foreman	PO Box 999	Minneapolis	MN	55334	business
4	Lucy	Liu	934 Superstar Ave	Portland	OR	99999	business
4	Lucy	Liu	3 Charles Dr	Los Angeles	CA	00000	home
      
-- 2. Get all orders and their line items (orders, quantity and product).

SELECT o.order_date, li.quantity, p.description, p.unit_price, (li.quantity * p.unit_price) AS order_total_price
FROM line_items li
JOIN orders o ON (o.id = li.order_id)
JOIN products p ON (p.id = li.product_id);

-- result:

2010-03-05	16	toothbrush	3	48
2010-03-05	4	nail polish - blue	4.25	17
2010-03-05	2	can of beans	2.5	5
2012-02-08	3	lysol	6	18
2012-02-08	1	cheetos	0.99	0.99
2016-02-07	6	diet pepsi	1.2	7.2
2011-03-04	4	wet ones baby wipes	8.99	35.96
2011-03-04	7	toothbrush	3	21
2011-03-04	2	nail polish - blue	4.25	8.5
2011-03-04	4	can of beans	2.5	10
2011-03-04	10	lysol	6	60
2011-03-04	3	cheetos	0.99	2.97
2012-09-22	5	diet pepsi	1.2	6
2012-09-22	4	wet ones baby wipes	8.99	35.96
2012-09-22	9	toothbrush	3	27
2012-09-22	3	nail polish - blue	4.25	12.75
2012-09-22	6	can of beans	2.5	15
2012-09-23	3	lysol	6	18
2012-09-23	7	cheetos	0.99	6.93
2012-09-23	1	diet pepsi	1.2	1.2
2012-09-23	2	wet ones baby wipes	8.99	17.98
2012-09-23	4	toothbrush	3	12
2012-09-23	7	nail polish - blue	4.25	29.75
2012-09-23	8	can of beans	2.5	20
2012-09-23	6	lysol	6	36
2012-09-23	9	cheetos	0.99	8.91
        
-- 3. Which warehouses have cheetos?

SELECT warehouse.warehouse
FROM warehouse
JOIN warehouse_product
	ON warehouse.id = warehouse_product.warehouse_id
JOIN products
	ON warehouse_product.product_id = products.id
WHERE products.description = 'cheetos';

Result --

delta

-- 4. Which warehouses have diet pepsi? 

SELECT warehouse.warehouse
FROM warehouse
JOIN warehouse_product
	ON warehouse.id = warehouse_product.warehouse_id
JOIN products
	ON warehouse_product.product_id = products.id
WHERE products.description = 'diet pepsi';

Result --

alpha
delta
gamma

-- 5. Get the number of orders for each customer. NOTE: It is OK if those without orders are not included in results.

SELECT
	customers.id as customerId,
	customers.first_name,
	customers.last_name, 
	count(orders.id) as numOfOrders
FROM orders
JOIN addresses
	ON orders.address_id = addresses.id
JOIN customers
	ON addresses.customer_id = customers.id
GROUP BY customers.id;

Result --

4	Lucy	Liu	3
2	Charles	Darwin	1
1	Lisa	Bonet	5

-- 6. How many customers do we have?

SELECT COUNT(id) AS customers FROM customers;

Result -- 4

-- 7. How many products do we carry?

SELECT COUNT(id) AS products FROM products;

result: -- 7

-- 8. What is the total available on-hand quantity of diet pepsi?

SELECT SUM(wp.on_hand) AS total_on_hand_diet_pepsi
FROM products p
JOIN warehouse_product wp ON (p.id = wp.product_id)
JOIN warehouse w ON (w.id = wp.warehouse_id)
WHERE p.description = 'diet pepsi';

Result -- 92

-- Stretch
-- 9. How much was the total cost for each order?

SELECT 
	orders.id,
	sum(products.unit_price * line_items.quantity) as totalCost
FROM orders
JOIN line_items
	ON orders.id = line_items.order_id
JOIN products
	ON line_items.product_id = products.id
GROUP BY orders.id
ORDER BY orders.id;

Result -- 

1	70
2	18.99
3	7.2
4	138.43
5	96.71
6	85.86
7	64.91

-- 10. How much has each customer spent in total?

SELECT 
	addresses.customer_id,
	sum(products.unit_price * line_items.quantity) as totalCost
FROM addresses
JOIN orders
	ON addresses.id = orders.address_id
JOIN line_items
	ON orders.id = line_items.order_id
JOIN products
	ON line_items.product_id = products.id
GROUP BY addresses.customer_id;

Result --

4	182.57
2	138.43
1	161.1


-- 11. How much has each customer spent in total? Customers who have spent $0 should still show up in the table. It should say 0, not NULL (research coalesce).
