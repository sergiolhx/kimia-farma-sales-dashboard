-- Create a database schema
CREATE SCHEMA kimia_farma;
USE kimia_farma;

-- Create table 
-- penjualan table
CREATE TABLE `kimia_farma`.`penjualan` (
  `id_distributor` VARCHAR(50) NOT NULL,
  `id_cabang` VARCHAR(50) NULL,
  `id_invoice` VARCHAR(50) NOT NULL,
  `tanggal` DATE NULL,
  `id_customer` VARCHAR(50) NULL,
  `id_barang` VARCHAR(50) NULL,
  `jumlah` INT NULL,
  `unit` VARCHAR(50) NULL,
  `harga` INT NULL,
  `mata_uang` VARCHAR(50) NULL,
  `brand_id` VARCHAR(50) NULL,
  `lini` VARCHAR(50) NULL,
  PRIMARY KEY (`id_invoice`));

-- barang table
CREATE TABLE `kimia_farma`.`barang` (
  `kode_barang` VARCHAR(50) NOT NULL,
  `sektor` VARCHAR(50) NULL,
  `nama_barang` VARCHAR(50) NULL,
  `tipe` VARCHAR(50) NULL,
  `nama_tipe` VARCHAR(50) NULL,
  `kode_lini` VARCHAR(50) NULL,
  `lini` VARCHAR(50) NULL,
  `kemasan` VARCHAR(50) NULL,
  PRIMARY KEY (`kode_barang`));

-- pelanggan table
CREATE TABLE `kimia_farma`.`pelanggan` (
  `id_customer` VARCHAR(50) NOT NULL,
  `level` VARCHAR(50) NULL,
  `nama` VARCHAR(50) NULL,
  `id_cabang` VARCHAR(50) NULL,
  `cabang_sales` VARCHAR(50) NULL,
  `id_group` VARCHAR(50) NULL,
  `group` VARCHAR(50) NULL,
  PRIMARY KEY (`id_customer`));
  

-- Import dataset
-- Create base table
-- Create base table datamart
CREATE TABLE base_table (
SELECT
    j.id_invoice,
    j.tanggal,
    j.id_customer,
    c.nama,
    j.id_distributor,
    j.id_cabang,
    c.cabang_sales,
    c.id_group,
    c.group,
    j.id_barang,
    b.nama_barang,
    j.brand_id,
    b.kode_lini,
    j.lini,
    b.kemasan,
    j.jumlah,
    j.harga,
    j.mata_uang
FROM penjualan j
	LEFT JOIN pelanggan c
		ON c.id_customer = j.id_customer
	LEFT JOIN barang b
		ON b.kode_barang = j.id_barang
ORDER BY j.tanggal
);

-- Add primary key
ALTER TABLE base_table ADD PRIMARY KEY(id_invoice);

-- Create aggregate table datamart 
CREATE TABLE aggregate_table (
SELECT
    tanggal AS date,
    MONTHNAME(tanggal) AS month,
    id_invoice,
    cabang_sales AS branch_location,
    nama AS customer,
    nama_barang AS product,
    lini AS brand,
    jumlah AS total_product_sold,
    harga AS price_per_unit,
    (jumlah * harga) AS total_revenue
FROM base_table
ORDER BY 1, 4, 5, 6, 7, 8, 9, 10
);