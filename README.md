# Target Brazil E-Commerce Analytics

![SQL](https://img.shields.io/badge/SQL-GoogleSQL-blue)
![BigQuery](https://img.shields.io/badge/Google%20BigQuery-Data%20Warehouse-orange)
![Looker Studio](https://img.shields.io/badge/Looker%20Studio-Dashboard-yellow)
![Status](https://img.shields.io/badge/Project-Completed-success)

## 📊 Project Overview

An end-to-end **Customer, Order & Operational Analytics** case study based on the Target Brazil e-commerce business context.

The project combines **Google BigQuery, GoogleSQL and Looker Studio** to transform relational e-commerce data into business-focused insights across data quality, demand, geography, order economics, logistics, payment behaviour, customer experience and customer-level analytics.

The project goes beyond isolated SQL queries by connecting:

**Data Model → Data Quality → Business Analysis → Customer Analytics → Dashboard → Business Insights**

---

## 🚀 Live Dashboard

### [▶ View Interactive Looker Studio Dashboard](YOUR_LOOKER_STUDIO_DASHBOARD_LINK)

The dashboard contains four customer analytics sections:

1. Customer Overview & Behaviour
2. Customer Value & RFM
3. High-Value Customer Pathways
4. Recent High-Value Customer Profile

> Replace `YOUR_LOOKER_STUDIO_DASHBOARD_LINK` with the final published Looker Studio URL.

---

## 🎯 Business Problem

The analysis is designed to answer:

- Is the underlying data complete and structurally reliable?
- How does order demand evolve over time and across time-of-day periods?
- Where is customer demand geographically concentrated?
- How do order value and freight burden vary by customer state?
- How long do orders take to reach customers?
- How accurate are estimated delivery dates?
- Which payment methods and installment patterns are observed?
- What does review behaviour indicate about customer experience?
- Who are the highest-value customer groups?
- How is observed customer value concentrated?
- How do high-value one-time and repeat customers differ?

---

## 🧩 Data Model & Analytical Grain

Instead of relying only on the ER diagram supplied with the dataset, a **new detailed ER diagram** was created with the major tables, columns, primary keys, foreign keys, data types and relationships.

The purpose was to understand the complete schema before writing SQL, identify one-to-many relationships and reduce the risk of double counting.

### Core Tables

| Table | Purpose |
|---|---|
| `customers` | Customer master and geographic information |
| `orders` | Core order-level transaction data |
| `order_items` | Products and seller-level order lines |
| `payments` | Payment method, value and installment information |
| `order_reviews` | Customer review and review-score information |
| `products` | Product master data |
| `sellers` | Seller master data |
| `geolocation` | Geographic reference data |

### Grain Control

The `orders` table represents the core transactional grain.

However:

- One order can contain multiple `order_items`
- One order can contain multiple payment records
- Review data requires careful handling when joined to orders
- Customer-level analysis uses `customer_unique_id` to identify the underlying customer across potentially multiple `customer_id` records

Payments and order items are therefore aggregated to **order level before being used in customer- or order-level metrics**.

This prevents inflated order counts, payment values and customer metrics.

---

## 📁 Dataset

The project uses the Brazilian e-commerce marketplace dataset containing customer, order, product, seller, payment, review and geolocation information.

| Table | Rows |
|---|---:|
| customers | 99,441 |
| geolocation | 1,000,163 |
| order_items | 112,650 |
| order_reviews | 99,224 |
| orders | 99,441 |
| payments | 103,886 |
| products | 32,951 |
| sellers | 3,095 |

**Observation period:** September 2016 – October 2018

**Customer analytics observation date:** 17 October 2018

Raw dataset files are not included in the repository. BigQuery is used as the analytical source.

---

# 📌 Key Business Results

## 👥 Customer Behaviour

| KPI | Result |
|---|---:|
| Active Customers | **93,358** |
| One-Time Customers | **90,557 (97.00%)** |
| Repeat Customers | **2,801 (3.00%)** |
| Observed Customer Value | **R$15.42M** |
| Average Observed Customer Value | **R$165.20** |
| Median Observed Customer Value | **R$107.78** |

### Insight

The customer base is broad but predominantly one-time. **97% of active customers made only one completed purchase**, while higher-frequency customers show substantially higher average observed customer value.

---

## 📈 Customer Value Concentration

**48.85% of customers account for 80% of observed customer value.**

This differs from a simple 80/20 assumption and demonstrates why customer-value concentration should be calculated from the actual customer distribution.

### Key takeaway

Observed customer value is meaningfully concentrated among a smaller share of customers, while the majority of the customer base consists of one-time buyers.

---

## 🧠 RFM Analysis

RFM analysis combines:

- **Recency** – how recently a customer purchased
- **Frequency** – how often a customer purchased
- **Monetary** – observed customer value

### RFM Classification

| Component | Definition |
|---|---|
| R4 | Most recent customers |
| R1 | Least recent customers |
| F4 | Highest purchase frequency |
| F1 | Exactly one completed order |
| M4 | Highest observed customer-value band |

Current project thresholds:

- **M4:** observed customer value > ₹182.40
- **R4:** last purchase within 163 days of 17 October 2018
- **F1:** exactly one completed order

### Insight

**97% of active customers are F1**, while higher-frequency customers show substantially higher average observed customer value.

The analysis deliberately avoids unsupported labels such as *Churned*, *At Risk* or *Champions*. One-time behaviour is not treated as confirmed churn because the dataset has a fixed observation end date.

---

## 💰 High-Value Customer Pathways

The high-value pathway analysis compares one-time and repeat customers within the M4 monetary segment.

| Metric | High-Value One-Time | High-Value Repeat |
|---|---:|---:|
| Customers | **21,586** | **1,771** |
| Avg. Observed Customer Value | R$390.63 | R$415.46 |
| Avg. Orders / Customer | 1.00 | 2.16 |
| Avg. Order Value | R$390.63 | R$194.91 |
| Avg. Items / Order | 1.32 | 1.29 |

### Key Insight

High-value one-time customers generate observed value through a **single high-ticket purchase**.

High-value repeat customers reach a similar observed customer value through approximately **2.16 lower-value purchases**.

Basket size is nearly identical between the groups, indicating that **purchase frequency and order value—not basket depth—differentiate the observed pathways**.

---

## 🎯 Recent High-Value Customer Profile

The recent high-value segment is defined as:

- **M4:** observed customer value > ₹182.40
- **R4:** last purchase within 163 days of 17 October 2018
- **F1:** exactly one completed order

| KPI | Result |
|---|---:|
| Recent High-Value Customers | **5,515** |
| Observed Customer Value | **R$2.20M** |
| Average Order Value | **R$399.30** |
| Average Review Score | **4.19** |
| SP + RJ + MG Share | **61.24%** |
| Single-Item Orders | **80.82%** |
| Average Delivery Time | **10.51 days** |
| Delivered Before Estimated Date | **93.82%** |
| Positive Reviews | **79.87%** |

### Geographic Insight

São Paulo, Rio de Janeiro and Minas Gerais together account for **61.24%** of recent high-value one-time customers.

### Product & Basket Insight

Health Beauty and Watches are among the largest observed product categories for the segment.

The segment is primarily characterized by **higher-ticket, single-item purchases rather than deep baskets**.

---

## 📦 Demand, Growth & Seasonality

Observed order activity increased rapidly during the early observation period:

- October 2016: **324 orders**
- July 2017: **4,026 orders**

The early period contains unusually low volumes, including a missing November 2016 observation and only one order in December 2016. These should be treated as observed data characteristics rather than filled or assumed values.

### Time-of-Day Demand

| Time Bucket | All Orders | Delivered Orders |
|---|---:|---:|
| Afternoon | 38,135 | 36,965 |
| Night | 28,331 | 27,522 |
| Morning | 27,733 | 26,919 |
| Dawn | 5,242 | 5,072 |

**Afternoon (13:00–18:59)** is the largest observed order window.

---

## 🌎 Customer & Geographic Demand

São Paulo represents approximately **41.98%** of customers in the state-level analysis, followed by Rio de Janeiro and Minas Gerais.

Geographic concentration can support deeper investigation of:

- Customer acquisition
- Category mix
- Logistics performance
- Service economics
- Regional customer behaviour

State-level percentages should be interpreted alongside order volume, particularly for smaller states.

---

## 💵 Order Value & Unit Economics

The analysis evaluates:

- Total payment value
- Average Order Value (AOV)
- State-level monetary demand
- Freight burden

### Freight Burden

```text
Freight-to-Order-Value %
=
Total Freight Cost / Total Order Value × 100
```

This is a **burden indicator, not a profitability measure**. A complete profitability analysis would require additional cost information.

---

## 🚚 Logistics & Delivery

### Key Results

- **91.78%** of delivered orders arrived before the estimated date.
- Average delivery variance was **-11.16 days**.
- State-level correlation between average freight per order and average delivery days: **r = 0.80**.

The freight/delivery relationship represents an **association across state averages**, not evidence that freight cost causes delivery delays.

---

## 💳 Payment Behaviour

Credit card is the dominant observed payment method, followed by boleto.

### Installment Classification

| Term | Installments |
|---|---:|
| Single Term | 1 |
| Short Term | 2–3 |
| Medium Term | 4–6 |
| Long Term | 7–12 |
| Very Long Term | 13–24 |
| Zero Installment | 0 |

### Key Insight

**62.94% of orders use 1–3 installments.**

Long-term payments of **7–12 installments represent 15.64% of orders but 31.95% of payment value**, indicating an association between longer installment plans and higher-value transactions.

---

## ⭐ Customer Experience

### Review Distribution

| Review Score | Share |
|---|---:|
| 5 Stars | **57.78%** |
| 4 Stars | **19.29%** |
| Positive Reviews (4–5) | **77.07%** |

### Delivery vs Review Outcomes

- Early deliveries → **62.50% excellent reviews**
- On-time deliveries → **50.78% excellent reviews**
- Late deliveries → **16.60% excellent reviews**
- Late deliveries → **62.47% bad reviews**

The analysis identifies an association between delivery performance and review outcomes. It does not establish causality without controlling for other factors.

---

# 🎯 Executive Business Insights

### 1. Repeat purchase behaviour is a major customer-value differentiation

With **97% of active customers making only one completed purchase**, repeat behaviour represents an important area for further customer-level analysis.

### 2. Customer value is concentrated, but not according to a simple 80/20 rule

**48.85% of customers account for 80% of observed customer value**, demonstrating the importance of measuring actual concentration.

### 3. High-value customers have different observed purchase pathways

One-time high-value customers tend to generate value through **one high-ticket order**, while repeat high-value customers generate similar observed value through **multiple lower-value orders**.

### 4. Recent high-value one-time customers are geographically concentrated

**SP, RJ and MG account for 61.24%** of the segment, providing a clear geographic lens for deeper category, customer and logistics analysis.

### 5. High-value one-time purchases are primarily high-ticket rather than high-basket

**80.82%** of recent high-value one-time customers place single-item orders.

### 6. Delivery performance and review outcomes show a strong observed relationship

Late deliveries have a substantially higher share of bad reviews than early deliveries. This should be treated as an observed association rather than a causal conclusion.

---

# 🧮 SQL Analysis Framework

```text
01 – Data Quality & Integrity
02 – Demand, Growth & Seasonality
03 – Customer & Geographic Demand
04 – Order Value & Unit Economics
05 – Logistics & Delivery
06 – Payment Behaviour
07 – Customer Experience
08 – Customer Analytics & RFM
09 – High-Value Customer Analysis
10 – Executive Insights
```

### Workflow

**Raw Data → BigQuery → GoogleSQL → Analytical Views → Customer Analytics → Looker Studio → Business Insights**

---

# 📂 Repository Structure

```text
target-brazil-ecommerce-analytics/
│
├── README.md
│
├── 01_sql_business_case/
│   ├── 01_data_quality/
│   ├── 02_demand_and_growth/
│   ├── 03_customer_and_geography/
│   ├── 04_order_economics/
│   ├── 05_logistics_and_delivery/
│   ├── 06_payment_analysis/
│   ├── 07_customer_experience/
│   └── 08_executive_recommendations/
│
├── 02_customer_analytics/
│   ├── sql/
│   ├── rfm/
│   ├── customer_value/
│   ├── high_value_analysis/
│   └── dashboard/
│
├── documentation/
│   ├── ER_Diagram.png
│   ├── Target_Brazil_Ecommerce_Detailed_Analysis_Report.pdf
│   └── methodology.md
│
├── sql/
│   ├── PHASE 1 - DATA QUALITY & INTEGRITY.sql
│   ├── PHASE 2 - DEMAND, GROWTH & SEASONALITY.sql
│   ├── PHASE 3 - CUSTOMER & GEOGRAPHIC DEMAND.sql
│   ├── PHASE 4 - ORDER VALUE & UNIT ECONOMICS.sql
│   ├── PHASE 5 - LOGISTICS & DELIVERY.sql
│   ├── PHASE 6 - PAYMENT BEHAVIOUR.sql
│   └── PHASE 7 - CUSTOMER EXPERIENCE.sql
│
└── data/
    └── README.md
```

Raw dataset files are not included in the repository.

---

# 🛠️ Technology Stack

| Tool | Purpose |
|---|---|
| **Google BigQuery** | Data warehouse and analytical layer |
| **GoogleSQL** | Data profiling, transformation and business analysis |
| **Looker Studio** | Interactive customer analytics dashboard |
| **GitHub** | Version control and portfolio presentation |
| **ER Diagram** | Schema understanding and analytical grain control |
| **Business Analysis** | Translating analytical outputs into business insights |

---

# 🧠 Skills Demonstrated

- SQL / GoogleSQL
- Google BigQuery
- Data profiling and validation
- Missing-value analysis
- Relational joins
- CTEs
- Aggregations
- Window functions
- Customer-level analytics
- RFM segmentation
- Customer value analysis
- Pareto / concentration analysis
- Geographic analysis
- Payment analytics
- Logistics analytics
- Customer experience analysis
- Dashboard development
- Business storytelling
- Executive insight generation

---

# ⚠️ Analytical Limitations

1. The dataset ends on **17 October 2018**.
2. Recent customers have a shorter opportunity window for repeat purchase.
3. One-time customer behaviour is **not equivalent to churn**.
4. Observed customer value is historical transaction value, not predicted Customer Lifetime Value and not profit.
5. Payments can contain multiple records per order and must be aggregated before order-level joins.
6. Order items can contain multiple records per order and can multiply metrics if analytical grain is not controlled.
7. Review records require careful order-level handling.
8. Geolocation is a reference dataset and should not replace customer master geography for customer-state analysis.
9. State-level correlations represent association across state aggregates, not individual-level causal relationships.
10. The M4 threshold is a project-specific RFM scoring convention, not a universal definition of a valuable customer.
11. Early-period order volumes contain observed gaps and unusually low counts.
12. Dashboard metrics represent the defined observation period and analytical definitions used in this project.

---

# 📚 Portfolio Deliverables

- SQL scripts organized by analytical phase
- Detailed ER diagram
- BigQuery analytical views
- Customer-level analytical datasets
- Four-page Looker Studio dashboard
- Detailed business analysis report
- Executive insights
- Analytical recommendations
- Documented definitions and limitations

---

# 👤 Author

**Vijay Kumar**

Data Analytics | SQL | BigQuery | Looker Studio | Customer Analytics

---

## ⭐ Project Summary

This portfolio project demonstrates how relational e-commerce data can be transformed into business insights using:

**BigQuery + GoogleSQL + Customer Analytics + Looker Studio + Business Analysis**

The focus is not only on writing SQL, but on demonstrating the complete analytical process—from understanding the schema and controlling data grain to identifying customer behaviour, value concentration, high-value pathways and operational insights.
