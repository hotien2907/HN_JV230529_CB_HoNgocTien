CREATE DATABASE IF NOT EXISTS QUANLYBANHANG;
USE QUANLYBANHANG;


-- Bảng CUSTOMERS
CREATE TABLE CUSTOMERS
(
    customer_id VARCHAR(4) PRIMARY KEY NOT NULL,
    name        VARCHAR(100)           NOT NULL,
    email       VARCHAR(100)           NOT NULL,
    phone       VARCHAR(25)            NOT NULL,
    address     VARCHAR(255)           NOT NULL
);

-- Bảng ORDERS
CREATE TABLE ORDERS
(
    order_id     VARCHAR(4) PRIMARY KEY NOT NULL,
    customer_id  VARCHAR(4)             NOT NULL,
    order_date   DATE                   NOT NULL,
    total_amount DOUBLE                 NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES CUSTOMERS (customer_id)
);


-- Bảng PRODUCTS
CREATE TABLE PRODUCTS
(
    product_id  VARCHAR(4) PRIMARY KEY NOT NULL,
    name        VARCHAR(255)           NOT NULL,
    description TEXT,
    price       DOUBLE                 NOT NULL,
    status      BIT(1)                 NOT NULL
);

-- Bảng ORDERS_DETAILS
CREATE TABLE ORDERS_DETAILS
(
    order_id   VARCHAR(4) NOT NULL,
    product_id VARCHAR(4) NOT NULL,
    quantity   INT(11)    NOT NULL,
    price      DOUBLE     NOT NULL,
    PRIMARY KEY (order_id, product_id),
    FOREIGN KEY (order_id) REFERENCES ORDERS (order_id),
    FOREIGN KEY (product_id) REFERENCES PRODUCTS (product_id)
);
-- Thêm dữ liệu bảng CUSTOMERS
INSERT INTO CUSTOMERS (customer_id, name, email, phone, address)
VALUES ('C001', 'Nguyễn Trung Mạnh', 'manhnt@gmail.com', '984756322', 'Cầu Giấy, Hà Nội'),
       ('C002', 'Hồ Hải Nam', 'namhh@gmail.com', '984875926', 'Ba Vì, Hà Nội'),
       ('C003', 'Tô Ngọc Vũ', 'vutn@gmail.com', '904725784', 'Mộc Châu, Sơn La'),
       ('C004', 'Phạm Ngọc Anh', 'anhpn@gmail.com', '984635365', 'Vinh, Nghệ An'),
       ('C005', 'Trương Minh Cường', 'cuongtm@gmail.com', '989735624', 'Hai Bà Trưng, Hà Nội');

-- Thêm dữ liệu bảng PRODUCTS
INSERT INTO PRODUCTS (product_id, name, description, price, status)
VALUES ('P001', 'Iphone 13 ProMax', 'Bản 512 GB, xanh lá', 22999999, 1),
       ('P002', 'Dell Vostro V3510', 'Core i5, RAM 8GB', 14999999, 1),
       ('P003', 'Macbook Pro M2', '8CPU 10 GPU 8 GB 256 GB', 28999999, 1),
       ('P004', 'Apple Watch Ultra', 'Titanium Alpine Loop Small', 18999999, 1),
       ('P005', 'Airpods', 'Spatial Audion', 409000, 1);
-- Thêm dữ liệu bảng ORDERS
INSERT INTO ORDERS (order_id, customer_id, total_amount, order_date)
VALUES ('H001', 'C001', 52999997, '2023-02-22'),
       ('H002', 'C001', 80999997, '2023-03-11'),
       ('H003', 'C002', 54359998, '2023-01-22'),
       ('H004', 'C003', 102999995, '2023-03-14'),
       ('H005', 'C003', 80999997, '2022-03-12'),
       ('H006', 'C003', 110449994, '2023-02-01'),
       ('H007', 'C004', 79999996, '2023-03-29'),
       ('H008', 'C004', 29999998, '2023-02-14'),
       ('H009', 'C005', 29999999, '2023-01-10'),
       ('H010', 'C005', 149999994, '2023-04-01');

-- Thêm dữ liệu bảng ORDERS_DETAILS
INSERT INTO ORDERS_DETAILS (order_id, product_id, price, quantity)
VALUES ('H001', 'P002', 14999999, 1),
       ('H001', 'P004', 18999999, 2),
       ('H002', 'P001', 22999999, 1),
       ('H002', 'P003', 28999999, 2),
       ('H003', 'P004', 18999999, 2),
       ('H003', 'P005', 409000, 4),
       ('H004', 'P002', 14999999, 3),
       ('H004', 'P003', 28999999, 2),
       ('H005', 'P001', 22999999, 1),
       ('H005', 'P003', 28999999, 2),
       ('H006', 'P005', 409000, 5),
       ('H006', 'P002', 14999999, 6),
       ('H007', 'P004', 18999999, 3),
       ('H007', 'P001', 22999999, 1),
       ('H008', 'P002', 14999999, 2),
       ('H009', 'P003', 28999999, 1),
       ('H010', 'P003', 28999999, 2),
       ('H010', 'P001', 22999999, 4);

# Bài 3 Truy Vấn dữ liệu
# 1. lấy thông tin
SELECT name, email, phone, address
FROM CUSTOMERS;
# 2.thông kê khách hàng mua hàng trong tháng 3
SELECT c.name, c.phone, c.address
FROM CUSTOMERS c
         INNER JOIN ORDERS o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
  AND MONTH(o.order_date) = 3;

# 3 thông kê doanh thu theo tháng
SELECT MONTH(order_date) AS thang, SUM(total_amount) AS tongDoanhThu
FROM ORDERS
WHERE YEAR(order_date) = 2023
GROUP BY thang;
#4 Thông kê người dùng ko mua hàng trong tháng 2/2023
SELECT name, address, email, phone
FROM CUSTOMERS
WHERE customer_id NOT IN (SELECT DISTINCT c.customer_id
                          FROM CUSTOMERS c
                                   INNER JOIN ORDERS o ON c.customer_id = o.customer_id
                          WHERE YEAR(o.order_date) = 2023
                            AND MONTH(o.order_date) = 2);
#5 thông kê số lượng từng sp đc bán ra trong thang 3/2023
SELECT p.product_id, p.name, SUM(od.quantity) AS soLuongBanRa
FROM PRODUCTS p
         LEFT JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
         LEFT JOIN ORDERS o ON od.order_id = o.order_id
WHERE YEAR(o.order_date) = 2023
  AND MONTH(o.order_date) = 3
GROUP BY p.product_id;
#6 Thông kê tổng chi tiêu của từng khách hàng
SELECT c.customer_id, c.name, SUM(o.total_amount) AS mucChiTieu
FROM CUSTOMERS c
         LEFT JOIN ORDERS o ON c.customer_id = o.customer_id
WHERE YEAR(o.order_date) = 2023
GROUP BY c.customer_id
ORDER BY mucChiTieu DESC;
#7 đơn hàng có số lương sp>5
SELECT c.name, o.total_amount, o.order_date, SUM(od.quantity) AS tongSoLuongSanPham
FROM CUSTOMERS c
         INNER JOIN ORDERS o ON c.customer_id = o.customer_id
         INNER JOIN ORDERS_DETAILS od ON o.order_id = od.order_id
GROUP BY o.order_id
HAVING tongSoLuongSanPham >= 5;

# Bài 4: Tạo View, Procedure :
# 4.1 thông tin đơn hàng
CREATE VIEW order_info AS
SELECT c.name         AS tenKhachHang,
       c.phone        AS soDienThoai,
       c.address      AS diaChi,
       o.total_amount AS tongTien,
       o.order_date   AS ngayTaoDonHang
FROM CUSTOMERS c
         INNER JOIN ORDERS o ON c.customer_id = o.customer_id;
SELECT *
FROM order_info;
#4.2 thông tin khách hàng
CREATE VIEW customer_info AS
SELECT c.name AS tenKhacHang, c.address AS diaChi, c.phone AS soDienThoai, COUNT(o.order_id) AS tongSoDonDatHang
FROM CUSTOMERS c
         LEFT JOIN ORDERS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;
SELECT *
FROM customer_info;
#4.3 thong tin san phẩm
CREATE VIEW product_info AS
SELECT p.name AS tenSanPham, p.description AS moTa, p.price AS gia, SUM(od.quantity) AS tongSoLuongDaBan
FROM PRODUCTS p
         LEFT JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
GROUP BY p.product_id;
SELECT *
FROM product_info;
#4.4 Đánh Index cho trường phone và email
CREATE INDEX idx_phone ON CUSTOMERS (phone);
CREATE INDEX idx_email ON CUSTOMERS (email);
-- 4.5 Tạo PROCEDURE lấy thông tin khách hàng dựa vào id
DELIMITER //
CREATE PROCEDURE GET_CUSTOMER_INFO(IN customerId VARCHAR(4))
BEGIN
    SELECT *
    FROM CUSTOMERS
    WHERE customer_id = customerId;
END;
//
DELIMITER ;
CALL GET_CUSTOMER_INFO('C001');
-- 4.6 Tạo PROCEDURE lấy ra thông tin của tất cả sản phẩm
DELIMITER //
CREATE PROCEDURE GET_ALL_PRODUCTS()
BEGIN
    SELECT *
    FROM PRODUCTS;
END;
//
DELIMITER ;
CALL GET_ALL_PRODUCTS();
# 4.7	Tạo PROCEDURE hiển thị danh sách hoá đơn dựa trên mã người dùng.
DELIMITER //
CREATE PROCEDURE GET_ORDER_BY_CUSTOMERID(IN customerId VARCHAR(4))
BEGIN
    SELECT *
    FROM ORDERS
    WHERE customer_id = customerId;
END;
//
DELIMITER ;
CALL GET_ORDER_BY_CUSTOMERID('C001');
# 8.Tạo PROCEDURE tạo mới một đơn hàng với các tham số là mã khách hàng,
# tổng tiền và ngày tạo hoá đơn, và hiển thị ra mã hoá đơn vừa tạo
DELIMITER //
CREATE PROCEDURE CREATE_ORDER(IN customerID VARCHAR(4), IN totalAmount DOUBLE, IN orderDate DATE,
                              OUT newOrderID VARCHAR(4))
BEGIN
    DECLARE lastOrderID INT;

    SET lastOrderID = (SELECT CAST(SUBSTRING(MAX(order_id), 2) AS SIGNED) + 1
                       FROM ORDERS);

    INSERT INTO ORDERS (order_id, customer_id, total_amount, order_date)
    VALUES (CONCAT('H', LPAD(lastOrderID, 3, '0')), customerID, totalAmount, orderDate);

    -- Gán giá trị mới cho biến OUT
    SET newOrderID = CONCAT('H', LPAD(lastOrderID, 3, '0'));
END;
//
DELIMITER ;
CALL CREATE_ORDER('C002', 23, '2023-09-11', @newOrderID);


SELECT @newOrderID AS 'New Order ID';



# 9.Tạo PROCEDURE thống kê số lượng bán ra của mỗi sản phẩm trong khoảng thời
# gian cụ thể với 2 tham số là ngày bắt đầu và ngày kết thúc
DELIMITER //
CREATE PROCEDURE GET_PRODUCT_SALES(IN startDate DATE, IN endDate DATE)
BEGIN
    SELECT p.product_id, p.name, SUM(od.quantity) AS soLuongBanRa
    FROM PRODUCTS p
             LEFT JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
             LEFT JOIN ORDERS o ON od.order_id = o.order_id
    WHERE o.order_date BETWEEN startDate AND endDate
    GROUP BY p.product_id;
END;
//
DELIMITER ;
CALL GET_PRODUCT_SALES('2023-02-22', '2023-03-11');

# 10.Tạo PROCEDURE thống kê số lượng của mỗi sản phẩm được bán
# ra theo thứ tự giảm dần của tháng đó với tham số vào là tháng và năm cần thống kê
DELIMITER //
CREATE PROCEDURE GET_PRODUCT_SALES_BY_MONTH(IN monthParam INT, IN YearParam INT)
BEGIN
    SELECT p.product_id, p.name, SUM(od.quantity) AS soLuongBanRa
    FROM PRODUCTS p
             LEFT JOIN ORDERS_DETAILS od ON p.product_id = od.product_id
             LEFT JOIN ORDERS o ON od.order_id = o.order_id
    WHERE MONTH(o.order_date) = monthParam
      AND YEAR(o.order_date) = YearParam
    GROUP BY p.product_id
    ORDER BY soLuongBanRa DESC;
END;
//
DELIMITER ;
CALL GET_PRODUCT_SALES_BY_MONTH('3', '2023');