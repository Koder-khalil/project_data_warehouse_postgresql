# 👋 Hi, I'm Khalil Badharis

### Data Engineer | Data Analyst | BI Analyst

I’m a data professional passionate about transforming raw data into **clean, reliable, and actionable insights**.

I work across the data lifecycle — from **data extraction and ETL pipelines** to **data modeling, analytics, visualization, and business intelligence**.

---

## 🚀 About Me

* 🔹 Data Engineer & Data Analyst
* 🔹 Strong SQL skills and very good Python skills
* 🔹 Experienced with **ETL / ELT pipelines**
* 🔹 Building **Bronze → Silver → Gold** data architectures
* 🔹 Designing **Data Warehouse and Star Schema** models
* 🔹 Experienced with MySQL and relational databases
* 🔹 Creating analytical dashboards with **Power BI and Tableau**
* 🔹 Strong interest in data quality, automation, and analytics
* 🔹 Currently expanding my knowledge of **Cloud Computing and AWS**

---

## 🛠️ Technical Skills

### Programming & Data

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge\&logo=python\&logoColor=white)
![SQL](https://img.shields.io/badge/SQL-4479A1?style=for-the-badge\&logo=mysql\&logoColor=white)
![Pandas](https://img.shields.io/badge/Pandas-150458?style=for-the-badge\&logo=pandas\&logoColor=white)

### Databases

![MySQL](https://img.shields.io/badge/MySQL-4479A1?style=for-the-badge\&logo=mysql\&logoColor=white)
![SQLAlchemy](https://img.shields.io/badge/SQLAlchemy-D71F00?style=for-the-badge\&logo=sqlalchemy\&logoColor=white)

### Data Engineering

* ETL / ELT
* Data Cleaning
* Data Transformation
* Data Validation
* Incremental Data Loading
* Batch Processing
* Data Warehousing
* Dimensional Modeling
* Star Schema
* Bronze / Silver / Gold Architecture
* Fact & Dimension Tables
* Data Quality

### Business Intelligence

![Power BI](https://img.shields.io/badge/Power_BI-F2C811?style=for-the-badge\&logo=powerbi\&logoColor=black)
![Tableau](https://img.shields.io/badge/Tableau-E97627?style=for-the-badge\&logo=tableau\&logoColor=white)
![Excel](https://img.shields.io/badge/Excel-217346?style=for-the-badge\&logo=microsoftexcel\&logoColor=white)

### Development Tools

![Git](https://img.shields.io/badge/Git-F05032?style=for-the-badge\&logo=git\&logoColor=white)
![GitHub](https://img.shields.io/badge/GitHub-181717?style=for-the-badge\&logo=github\&logoColor=white)
![VS Code](https://img.shields.io/badge/VS_Code-007ACC?style=for-the-badge\&logo=visualstudiocode\&logoColor=white)
![Jupyter](https://img.shields.io/badge/Jupyter-F37626?style=for-the-badge\&logo=jupyter\&logoColor=white)

---

# 📊 Featured Data Projects

## 🏗️ End-to-End Data Warehouse & ETL Pipeline

**Technologies:** Python • Pandas • SQL • MySQL • SQLAlchemy • Power BI

Built an end-to-end data warehouse pipeline following a **Medallion Architecture**:

```text
                    Raw CSV Data
                         │
                         ▼
                 ┌───────────────┐
                 │ Bronze Layer  │
                 │   Raw Data    │
                 └───────┬───────┘
                         │
                         ▼
                 ┌───────────────┐
                 │ Silver Layer  │
                 │ Cleaned Data  │
                 │ Normalized    │
                 └───────┬───────┘
                         │
                         ▼
                 ┌───────────────┐
                 │  Gold Layer   │
                 │ Star Schema   │
                 │ Facts & Dims  │
                 └───────┬───────┘
                         │
                         ▼
                 ┌───────────────┐
                 │   Power BI    │
                 │   Dashboard   │
                 └───────────────┘
```

### Key Features

* Extracted raw CSV data into MySQL
* Implemented Bronze, Silver, and Gold layers
* Cleaned and transformed raw data using Python/Pandas
* Removed duplicate records
* Handled missing values
* Standardized date and text fields
* Created normalized Silver tables
* Built Fact and Dimension tables
* Implemented surrogate keys
* Created a Star Schema for analytics
* Implemented incremental/chunk-based loading
* Connected the Gold layer to BI tools

---

# 📈 Sales Data Warehouse

A sales analytics data warehouse designed to support business reporting and analysis.

### Data Model

**Dimensions**

* `dim_customer`
* `dim_product`
* `dim_employee`
* `dim_payment_method`
* `dim_date`

**Fact**

* `fact_sales`

### Business Questions

* What are total sales?
* Which products generate the highest revenue?
* Which customers contribute the most revenue?
* What are the monthly and yearly sales trends?
* Which employees generate the highest sales?
* Which payment methods are most frequently used?
* How does sales performance change over time?

---

# 🐍 Python Data Engineering

I use Python and Pandas for:

```python
import pandas as pd

df = pd.read_csv("sales.csv")

df["OrderDate"] = pd.to_datetime(
    df["OrderDate"],
    errors="coerce"
)

df = df.drop_duplicates()

df["Email"] = df["Email"].fillna("Unknown")

df["City"] = df["City"].fillna(
    df.groupby("Country")["City"]
      .transform("max")
)
```

For large datasets, I use **chunk-based processing** to reduce memory consumption:

```python
for chunk in pd.read_sql(
    query,
    engine,
    chunksize=50000
):
    # Transform
    # Validate
    # Load
    pass
```

---

# 🗄️ SQL Skills

I work extensively with SQL for data transformation and analysis.

### SQL Topics

* SELECT / WHERE
* JOINs
* GROUP BY
* HAVING
* CTEs
* Subqueries
* Window Functions
* `ROW_NUMBER()`
* `LAG()`
* `LEAD()`
* Aggregations
* Date Functions
* Data Cleaning
* Deduplication
* Incremental Loading
* Foreign Keys
* Constraints
* Stored Procedures

Example:

```sql
WITH ranked_customers AS (
    SELECT
        CustomerID,
        CustomerName,
        Email,
        OrderDate,
        ROW_NUMBER() OVER (
            PARTITION BY CustomerID
            ORDER BY OrderDate
        ) AS rn
    FROM bronzeDB.sales
)

SELECT
    CustomerID,
    CustomerName,
    Email
FROM ranked_customers
WHERE rn = 1;
```

---

# 📊 Business Intelligence

I create dashboards that transform data into useful business information.

### Power BI

* Data modeling
* DAX
* Power Query
* KPIs
* Interactive dashboards
* Drill-through
* Time intelligence
* Data visualization

### Tableau

* Interactive dashboards
* Data exploration
* Calculated fields
* Filters
* Business reporting

### Excel

* Pivot Tables
* Power Query
* Data cleaning
* Formulas
* Charts
* Data analysis

---

# ☁️ Cloud & AWS

Currently developing my knowledge of cloud technologies, including:

* AWS
* Amazon S3
* AWS Lambda
* Amazon EC2
* AWS Cloud9
* Google App Engine
* Cloud storage
* Serverless computing
* PaaS / IaaS concepts

---

# 🎯 Current Learning Goals

```text
SQL
████████████████████  Advanced

Python
█████████████████░░░  Strong

Data Engineering
███████████████░░░░░  Developing

Data Warehousing
████████████████░░░░  Strong

Power BI
████████████████░░░░  Strong

AWS / Cloud
██████████░░░░░░░░░░  Developing
```

I'm continuously improving my skills in:

* Data Engineering
* Cloud Data Platforms
* Advanced SQL
* Python
* Data Warehousing
* Business Intelligence
* Analytics Engineering

---

# 📂 Portfolio

Here you will find projects demonstrating:

📌 Data Cleaning
📌 SQL Analytics
📌 Python ETL
📌 Data Warehousing
📌 Dimensional Modeling
📌 Incremental Data Loading
📌 Power BI Dashboards
📌 Business Intelligence
📌 Cloud Computing

---

# 🤝 Let's Connect

I'm interested in opportunities related to:

**Data Engineering | Data Analytics | BI | SQL | Python | Data Warehousing**

Feel free to explore my repositories and connect with me.

---

⭐ If you find my projects useful, consider giving them a star!

**Thanks for visiting my GitHub profile!** 🚀
