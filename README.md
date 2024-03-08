# 💊 Kimia Farma Sales Dashboard
Kimia Farma, Indonesia's first pharmaceutical company, was founded by the Dutch East Indies government in 1817 as NV Chemicalien Handle Rathkamp & Co. In 1958, the Indonesian government merged several pharmaceutical companies into PNF Bhinneka Kimia Farma as part of nationalization efforts. On August 16, 1971, PNF was transformed into a Limited Liability Company, known as PT Kimia Farma (Persero).<br>

Source: [Kimia Farma](https://www.kimiafarma.co.id/id/sejarah-kimia-farma)

## ⭐ **Introduction**
As a Big Data Analyst Intern at Kimia Farma, facilitated by Rakamin Academy, the primary objective of this project was to analyze and generate a comprehensive sales dashboard for the company utilizing the provided data. Throughout this project, an in-depth understanding of data warehouse, data lake, and datamart, allowing effective analysis.

### Tools
![MySQL](https://img.shields.io/badge/mysql-4479A1.svg?style=for-the-badge&logo=mysql&logoColor=white)![Looker](https://img.shields.io/badge/Looker-4285F4.svg?style=for-the-badge&logo=Looker&logoColor=white)
- Query: MySQL Workbench ➡️ [Script](https://github.com/sergiolhx/kimia-farma-sales-dashboard/blob/main/kimia_farma_scipt.sql) <br>
- Visualization: Looker Studio ➡️ [Dashboard](https://lookerstudio.google.com/u/0/reporting/7b59dd75-23e0-4849-a398-546021eb1b4a/page/EvPsD) <br>
- Dataset: Kimia Farma x Rakamin ➡️ [Link](https://www.rakamin.com/virtual-internship-experience/kimiafarma-big-data-analytics-virtual-internship-program)

### Objectives
- Investigate and analyze Kimia Farma's sales performance over a six-month period
- Identifying trends and potential areas for improvement
- Creating a datamart (base table and aggregate table)
- Create a dashboard for company sales report

### Dataset
- Penjualan <br>
Sample Dataset: <br>

| id_distributor | id_cabang | id_invoice | tanggal    | id_customer | id_barang | jumlah_barang | unit | harga | mata_uang | brand_id | lini     |
| -------------- | --------- | ---------- | ---------- | ----------- | --------- | ------------- | ---- | ----- | --------- | -------- | -------- |
| TD             | CAB01     | IN5997     | 20/01/2022 | CUST55380   | BRG0001   | 1             | DUS  | 1170  | IDR       | BRND001  | OGB & PH |
| TD             | CAB01     | IN6297     | 20/01/2022 | CUST55381   | BRG0002   | 5             | DUS  | 2338  | IDR       | BRND002  | ETIKAL   |
| TA             | CAB02     | IN6155     | 21/01/2022 | CUST55382   | BRG0003   | 9             | DUS  | 10691 | IDR       | BRND003  | MARCKS   |


- Barang <br>
Sample Dataset: <br>

| kode_barang | sektor | nama_barang           | tipe | nama_tipe   | kode_lini | lini     | kemasan |
| ----------- | ------ | --------------------- | ---- | ----------- | --------- | -------- | ------- |
| BRG0001     | P      | ACYCLOVIR DUS         | ZPJ1 | Produk jadi | 206       | OGB & PH | DUS     |
| BRG0002     | P      | ALERGINE TABLET SALUT | ZPJ1 | Produk jadi | 203       | ETIKAL   | DUS     |
| BRG0003     | P      | AMPICILLIN            | ZPJ1 | Produk jadi | 210       | MARCKS   | BOTOL   |

- Pelanggan  <br>
Sample Dataset: <br>

| id_customer | level   | nama         | id_cabang_sales | cabang_sales | id_group | group  |
| ----------- | ------- | ------------ | --------------- | ------------ | -------- | ------ |
| CUST55380   | Company | APOTEK TAPAK | CAB01           | Aceh         | Z32      | Apotek |
| CUST55381   | Company | APOTEK MAJA  | CAB02           | Kuningan     | Z32      | Apotek |
| CUST55382   | Company | KLINIK GM    | CAB03           | Jakarta      | Z31      | Klinik |


### ERD
<details>
  <summary>Click to view ERD</summary>

<p align="center">
  <kbd> <img width="800" alt="erd" src="https://github.com/sergiolhx/kimia-farma-sales-dashboard/assets/149363611/63807f73-ff50-42e5-b279-5a140f6a776d"></kbd> <br>
</p>

</details>

## ⭐ **Create Datamart**
### Base table
Base table is a table that contains raw or original data collected from its source and contains the information needed to answer questions or solve specific problems. The base table in this project is created from a combination of sales, customer, and product tables with the primary key on invoice_id.
<details>
  <summary> Click to view Query </summary>
    <br>
  
```sql
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
```
<br>
</details>

### Aggregate table 
Aggregate table is a table created by collecting and calculating data from base table. This aggregate table contains more concise information and is used to analyze data more quickly and efficiently. The results from this table will be used as a source for creating sales dashboard reports.
<br>
Result: [Click here](https://github.com/sergiolhx/kimia-farma-sales-dashboard/blob/main/aggregate_table_kimia_farma.csv)

<details>
  <summary> Click to view Query </summary>
    <br>
  
```sql
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
```
<br>
</details>

## ⭐ **Visualization**
Export the aggregate table to CSV from the data source in Looker Studio. Then, build a dashboard using the data from the aggregate table in Google Data Studio. <br>
Result: [Click here](https://lookerstudio.google.com/u/0/reporting/7b59dd75-23e0-4849-a398-546021eb1b4a/page/EvPsD) <br>
<p align="center"> <img alt="dashboard" src="https://github.com/sergiolhx/kimia-farma-sales-dashboard/assets/149363611/a88b84df-1d0f-48de-b9e6-8cb69bfeb78f"><br>
</p>
