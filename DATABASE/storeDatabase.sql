CREATE DATABASE  IF NOT EXISTS `RafalStoreDb` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `RafalStoreDb`;
-- MySQL dump 10.13  Distrib 5.7.20, for Linux (x86_64)
--
-- Host: localhost    Database: RafalStoreDb
-- ------------------------------------------------------
-- Server version	5.7.20-0ubuntu0.16.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `basket_table`
--

DROP TABLE IF EXISTS `basket_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `basket_table` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) DEFAULT NULL,
  `qty` int(11) DEFAULT NULL,
  `user_name` varchar(45) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9170 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `basket_table`
--

LOCK TABLES `basket_table` WRITE;
/*!40000 ALTER TABLE `basket_table` DISABLE KEYS */;
INSERT INTO `basket_table` VALUES (9002,4,1,'admin2'),(9003,5,3,'admin2'),(9055,1,1,'rafal');
/*!40000 ALTER TABLE `basket_table` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RafalStoreDb`.`basket_table_AFTER_UPDATE` AFTER UPDATE ON `basket_table` FOR EACH ROW
BEGIN

	SET SQL_SAFE_UPDATES=0;	 
	update products 
    join basket_table
	on products.prod_id = basket_table.product_id
	set products.prod_stock = products.prod_stock - 1
	where products.prod_id = basket_table.product_id
    and
	basket_table.user_name = (select user_name from basket_table where basket_table.id = LAST_INSERT_ID());
	SET SQL_SAFE_UPDATES=1;	 

END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `order_item`
--

DROP TABLE IF EXISTS `order_item`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_item` (
  `order_item_id` int(11) NOT NULL AUTO_INCREMENT,
  `product_id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `product_price` decimal(8,2) DEFAULT NULL,
  `quantity` int(11) DEFAULT NULL,
  PRIMARY KEY (`order_item_id`,`product_id`,`order_id`),
  KEY `fk_order_item_order_id_idx` (`order_id`),
  KEY `fk_order_item_product_id_idx` (`product_id`),
  CONSTRAINT `fk_order_item_order_id` FOREIGN KEY (`order_id`) REFERENCES `order_table` (`order_id`) ON DELETE CASCADE ON UPDATE NO ACTION,
  CONSTRAINT `fk_order_item_product_id` FOREIGN KEY (`product_id`) REFERENCES `products` (`prod_id`) ON DELETE CASCADE ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_item`
--

LOCK TABLES `order_item` WRITE;
/*!40000 ALTER TABLE `order_item` DISABLE KEYS */;
INSERT INTO `order_item` VALUES (1,6,500566,548.25,1),(2,7,500567,10100.00,1),(3,2,500568,1500.00,1),(4,2,500566,1500.00,10),(5,3,500566,1450.00,2),(6,4,500566,400.00,2),(7,5,500566,13000.00,2),(8,7,500566,10100.00,2),(9,4,500567,400.00,2),(10,5,500567,13000.00,2),(11,6,500567,548.25,2),(12,1,500566,10000.00,3),(13,1,500567,10000.00,3),(14,2,500567,1500.00,3),(15,3,500567,1450.00,3),(16,5,500569,13000.00,4);
/*!40000 ALTER TABLE `order_item` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RafalStoreDb`.`order_item_AFTER_INSERT` AFTER INSERT ON `order_item` FOR EACH ROW
BEGIN
SET SQL_SAFE_UPDATES=0; 

update `stock_table`, `order_item`
set `total_ordered` = `total_ordered`+`quantity`
where `stock_product_id` = `product_id`
and `order_item`.`order_id` = (select max(order_id)from order_table);

SET SQL_SAFE_UPDATES=1;


END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `order_table`
--

DROP TABLE IF EXISTS `order_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `order_table` (
  `order_id` int(11) NOT NULL AUTO_INCREMENT,
  `order_user_id` int(11) DEFAULT NULL,
  `order_date_created` datetime DEFAULT NULL,
  PRIMARY KEY (`order_id`)
) ENGINE=InnoDB AUTO_INCREMENT=500570 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `order_table`
--

LOCK TABLES `order_table` WRITE;
/*!40000 ALTER TABLE `order_table` DISABLE KEYS */;
INSERT INTO `order_table` VALUES (500566,1004,'2018-01-05 01:06:06'),(500567,1004,'2018-01-05 01:11:29'),(500568,1004,'2018-01-05 01:13:45'),(500569,1004,'2018-01-05 02:29:51');
/*!40000 ALTER TABLE `order_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `products`
--

DROP TABLE IF EXISTS `products`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `products` (
  `prod_id` int(11) NOT NULL AUTO_INCREMENT,
  `prod_name` text,
  `prod_price` decimal(8,2) DEFAULT NULL,
  `prod_stock` int(11) DEFAULT NULL,
  `prod_image_ref` varchar(255) DEFAULT 'images/products/product_1.jpg',
  `prod_description` text,
  PRIMARY KEY (`prod_id`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `products`
--

LOCK TABLES `products` WRITE;
/*!40000 ALTER TABLE `products` DISABLE KEYS */;
INSERT INTO `products` VALUES (1,'Atomic Rocket Motor',10000.00,1,'images/products/prod_1.png','Despite the big scary trefoil painted onto the side of this engine, its radioactive exhaust, and tendency to overheat, the LV-N Atomic Rocket Motor is harmless. Mostly. Note that the LV-N is the only LV series engine to run solely on Liquid Fuel - the future is glowing bright!  The LV-N \"Nerv\" Atomic Rocket Motor is a low-thrust, high-efficiency rocket engine. It is modeled after the real-world theoretical nuclear thermal rocket, which uses a fission reactor to heat its propellant and force it out of the rocket nozzle to generate thrust (as opposed to a normal rocket, which ignites the propellant and uses the energy released by the resulting chemical reaction for that purpose).'),(2,'MonoPropelant Engine',1500.00,5,'images/products/prod_2.png','When The O-10 Engine was first unveiled, it was regarded as one of those ideas that someone should have thought of a long time ago. This made most employees at Reaction Systems Ltd feel quite awkward, as they were particularly proud of having delivered this project on schedule for once. This Engine responds to main throttle controls, but it consumes MonoPropellant instead of a Fuel+Oxidizer mix.'),(3,'Vernor Engine',1450.00,3,'images/products/prod_3.png','The VR-N1ER Veer-Governor, or \"Vernor\" Engine is an attitude control thruster. These motors are linked to RCS controls, but are powered by a Fuel+Oxidizer mix, making them significantly more powerful than MonoPropellant-powered RCS thrusters. They are fairly more bulky in comparison though, and feature only one nozzle facing outwards, although most agree that is an acceptable trade-off for the additional punch they pack.'),(4,'Twitch Radaial Engine',400.00,3,'images/products/prod_4.png','Tiny engine! But very useful, good for craft where larger radial engines won\'t fit. Although, you may need more of them to lift larger payloads.'),(5,'Main Sail Liquid Fuel',13000.00,0,'images/products/prod_5.png','A monster of an engine for heavy lifting purposes, the Mainsail\'s power rivals that of entire small nations.  The Rockomax \"Mainsail\" Liquid Engine is one of the heaviest and most powerful large-diameter engines among the stock parts. It is usually used to provide thrust for larger rockets and lower stages. It is typically fueled by large diameter liquid fuel tanks like the Rockomax X200-32 Fuel Tank. Prior to version 0.23.5 it was the largest engine, as well as the one with the highest thrust. Those titles, however, are now held by the S3 KS-25x4 Engine Cluster.\n\n'),(6,'Ant Liquid Fuel Engine',548.25,3,'images/products/prod_6.png','The LV-1 \"Ant\" Liquid Fuel Engine is used to provide thrust to a rocket and is currently the weakest liquid fueled engine available. As of 1.0, it has extremely poor specific impulse in atmosphere, but decent specific impulse in vacuum; in combination with its low mass and tiny size, this makes it a good choice for small satellites. There is a radial derivative of this engine called LV-1R Liquid Fuel Engine featuring a similar design and vacuum thrust but very different Isp profile at a slightly higher cost.'),(7,'Swivel Liquid Fuel Engine',10100.00,2,'images/products/prod_7.png','The LV-T45 engine was considered a breakthrough in the LV-T series due to its Thrust Vectoring feature. The LV-T45 can deflect its thrust to aid in craft control. All these added mechanics however, make for a slightly smaller and heavier engine in comparison with other LV-T models. The LV-T45 is similar to the LV-T30 Liquid Fuel Engine, but with a slightly smaller thrust chamber, higher expansion ratio, and thrust vector control. Its slightly reduced thrust and considerably increased mass reduces its specific thrust, making it less suitable for first stages. It is best suited in second stages and the core stage of parallel lift-off configurations, where longer operating times and higher altitudes bring out this engine\'s advantage in specific impulse.');
/*!40000 ALTER TABLE `products` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `RafalStoreDb`.`products_AFTER_UPDATE` AFTER UPDATE ON `products` FOR EACH ROW
BEGIN

SET SQL_SAFE_UPDATES=0; 

update `stock_table`, `products`
set `stock_qty` = `products`.`prod_stock`
where `stock_product_id` = `products`.`prod_id`;

SET SQL_SAFE_UPDATES=1;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `stock_table`
--

DROP TABLE IF EXISTS `stock_table`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `stock_table` (
  `stock_product_id` int(11) NOT NULL,
  `stock_qty` int(11) NOT NULL,
  `total_ordered` int(11) NOT NULL,
  PRIMARY KEY (`stock_product_id`),
  CONSTRAINT `fk_stock_table_prord_id` FOREIGN KEY (`stock_product_id`) REFERENCES `products` (`prod_id`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `stock_table`
--

LOCK TABLES `stock_table` WRITE;
/*!40000 ALTER TABLE `stock_table` DISABLE KEYS */;
INSERT INTO `stock_table` VALUES (1,1,0),(2,5,1),(3,3,0),(4,3,0),(5,0,4),(6,3,0),(7,2,0);
/*!40000 ALTER TABLE `stock_table` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `users` (
  `iduser` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) DEFAULT NULL,
  `username` varchar(45) DEFAULT NULL,
  `email` varchar(145) DEFAULT NULL,
  `password` text,
  `time_joined` time DEFAULT NULL,
  `date_joined` date DEFAULT NULL,
  PRIMARY KEY (`iduser`)
) ENGINE=InnoDB AUTO_INCREMENT=1008 DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1004,'HelloWorld','helloworld','helloworld@server.com','$5$rounds=535000$pfKs/44pOmaDISME$PS/kRTTgcMPLEyu42TWZPOohmfQI7Wxq6Oc6tO5AIND','04:35:10','2017-11-20'),(1005,'Rafal Admin','admin','admin@admin.com','$5$rounds=535000$9mvf73SkteiatZsY$z6yFSSCy/bx4YAjowI9dQL0ds1WVcY9dBtbgOtM0rI6','16:17:06','2017-11-20'),(1006,'adam','admin2','adam@lol.com','$5$rounds=535000$mIsTm094pvwRobWw$Vd4luan6LRtY2957LM57vac1riNKDzCf0MAYKMjp0E9','00:47:24','2017-11-21'),(1007,'Rafal','rafal','rafal@server.com','$5$rounds=535000$qTudjV5VD04wXfwh$.rcOS1.8LYFaH8PxQJzR7/qjbsoDWhfxxkXoqK3ALu2','01:52:17','2017-11-27');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Dumping events for database 'RafalStoreDb'
--

--
-- Dumping routines for database 'RafalStoreDb'
--
/*!50003 DROP FUNCTION IF EXISTS `sfn_get_user_id` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` FUNCTION `sfn_get_user_id`(
 _user_name varchar(120)
) RETURNS int(11)
BEGIN

RETURN (select distinct `users`.`iduser` from `RafalStoreDb`.`users` where `users`.`username` = _user_name);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_addNewProduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_addNewProduct`(
	_prod_id int(11), 
    _prod_name text,
    _prod_price decimal(8,2),
    _prod_stock int(11),
    _prod_image_ref varchar(255),
    _prod_description varchar(510)
    )
BEGIN

INSERT INTO `RafalStoreDb`.`products` (`prod_name`, `prod_price`, `prod_stock`, `prod_image_ref`, `prod_description`) 
	VALUES (_prod_id, _prod_name ,_prod_price,_prod_stock,_prod_image_ref ,_prod_description);

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_basketAddProduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_basketAddProduct`(
	IN _id INT(11),
    IN _user VARCHAR(120))
BEGIN
	
	DECLARE x int(11);
	DECLARE y int(11);
    DECLARE z int(11);

	set x = (select count(id) from basket_table WHERE user_name = _user and product_id = _id);
	set y = 0;
	
	IF (x = 1) THEN    
		set y = (select qty from basket_table WHERE user_name = _user and product_id = _id);
	END IF;	
	
    set z = (select `prod_stock` from products where `products`.`prod_id` = _id);

	if (x = 1 and y < 10) THEN  
		SET SQL_SAFE_UPDATES=0;	        
		UPDATE RafalStoreDb.basket_table SET qty=qty+1  WHERE product_id= _id and user_name = _user ;            
		SET SQL_SAFE_UPDATES=1;
        call sp_update_product_stock(_id, -1);
	else if (x = 0)then
		INSERT INTO RafalStoreDb.basket_table (product_id, qty, user_name)  VALUES (_id, 1, _user);
	else
		select 'Maximum order size reached!!!';
	END IF;
	END IF;
	commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_basketCheckForContent` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_basketCheckForContent`(IN p_name VARCHAR(120))
BEGIN

	SELECT 
	  count(user_name)
	from 
		basket_table    
	where
		basket_table.user_name =p_name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_basketDecrease` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_basketDecrease`(
	IN _id INT(11),
    IN _user VARCHAR(120))
BEGIN
	
	if ( select exists (select user_name ,product_id from basket_table where user_name = _user and product_id = _id and qty > 1) ) THEN

		SET SQL_SAFE_UPDATES=0;

		UPDATE RafalStoreDb.basket_table SET qty=qty-1  WHERE product_id= _id and user_name = _user ;

		SET SQL_SAFE_UPDATES=1;  
		 call sp_update_product_stock(_id, 1);
	else  

		select 'User: '+ _user + '- Does not Exists OR product ID: ' + _id + '- Does not Exists!!! ';

	END IF;
    commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_basketDeleteProduct` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_basketDeleteProduct`(
	IN _id INT(11),
    IN _user VARCHAR(120))
BEGIN
	
	DECLARE _value_local INT ;

	set _value_local = (select `basket_table`.`qty` from `RafalStoreDb`.`basket_table` where `basket_table`.`user_name` = _user and `basket_table`.`product_id` = _id);
    
    call sp_update_product_stock(_id, _value_local);  
    SET SQL_SAFE_UPDATES=0;	 
    DELETE FROM `RafalStoreDb`.`basket_table`  WHERE `basket_table`.`user_name` = _user and `basket_table`.`product_id` = _id;   
	
	COMMIT;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_basketEmpty` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_basketEmpty`(
	 IN _user VARCHAR(120))
BEGIN
	
	if ( select exists (select distinct user_name from basket_table where user_name = _user ) ) THEN

		call sp_restock_all_from_user(_user);
        SET SQL_SAFE_UPDATES=0;      
        
        DELETE FROM RafalStoreDb.basket_table WHERE user_name = _user;

		SET SQL_SAFE_UPDATES=1;  

	else  

		select 'Username does not Exists !!';

	END IF;
    commit;
    
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_basketGetProducts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_basketGetProducts`(IN p_name VARCHAR(120))
BEGIN

SELECT 
    prod_id, 
    prod_name,    
    qty,
    prod_price
    
FROM
    products
INNER JOIN
    basket_table ON products.prod_id = basket_table.product_id

where
	basket_table.user_name =p_name;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_createOrder` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createOrder`(
IN _user VARCHAR(120)
)
BEGIN
	DECLARE user_id_local INT ;
	DECLARE order_id_local INT ;

	set user_id_local = sfn_get_user_id(_user);

	INSERT INTO `RafalStoreDb`.`order_table` (`order_id`,`order_user_id`, `order_date_created`) VALUES (null,user_id_local, NOW());
	commit;
    set order_id_local = (select distinct LAST_INSERT_ID() from `RafalStoreDb`.`order_table`);

	INSERT INTO `RafalStoreDb`.`order_item` (product_id,order_id,product_price,quantity)
	SELECT DISTINCT 
			prod_id, 
			order_id_local, 
			prod_price,
            basket_table.qty
	FROM
		products
	INNER JOIN
		basket_table ON products.prod_id = basket_table.product_id

	where
			basket_table.user_name =_user 
        and
			`basket_table`.`product_id` = `products`.`prod_id`;
	commit;
	SET SQL_SAFE_UPDATES=0;    
    DELETE FROM RafalStoreDb.basket_table WHERE user_name = _user;  
    SET SQL_SAFE_UPDATES=1;
    commit;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_createUser` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_createUser`(
    IN p_name VARCHAR(120),
    IN p_username VARCHAR(120),
    IN p_email VARCHAR(120),
    IN p_password VARCHAR(255)
)
BEGIN
    if ( select exists (select 1 from users where username = p_username) ) THEN
     
        select 'Username Exists !!';
     
    ELSE
     
        insert into users
        (
            name,
            username,
            email,
            password,
            time_joined,
            date_joined
            
        )
        values
        (
            p_name,
            p_username,
            p_email,
            p_password,
            NOW(),
			NOW()
        );
     
    END IF;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_getAllProducts` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getAllProducts`(
   
)
BEGIN   
     
       SELECT * FROM RafalStoreDb.products;
     
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_restock_all_from_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_restock_all_from_user`(
in _user varchar(120)
)
BEGIN
SET SQL_SAFE_UPDATES=0;
UPDATE products, basket_table
set `products`.`prod_stock` = `products`.`prod_stock` + `basket_table`.`qty`
where
 `products`.`prod_id` = `basket_table`.`product_id`
and
`basket_table`.`user_name` = _user;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_update_product_stock` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_AUTO_CREATE_USER,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_update_product_stock`(
IN _prod_ID INT,
in _value INT
)
BEGIN
	SET SQL_SAFE_UPDATES=0;	 
		update products 		
		set products.prod_stock = products.prod_stock + _value
		where products.prod_id = _prod_ID;		
	SET SQL_SAFE_UPDATES=1;	 

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2018-01-05  2:33:09
