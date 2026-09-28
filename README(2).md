# Target Brazil E-Commerce Analytics

**Customer, Order & Operational Analytics using SQL, BigQuery & Looker
Studio**

An end-to-end analytics portfolio project built around the Target Brazil
e-commerce case. The project combines data quality validation, demand
analysis, customer and geographic analysis, order economics, logistics,
payment behaviour, customer experience and customer-level RFM analytics.

> **Workflow:** Understand the data model → validate the data → control
> analytical grain → answer business questions with SQL → build
> customer-level analytics → visualize findings → translate evidence
> into business priorities.

## Executive Summary

**Observation period:** September 2016 -- October 2018\
**Customer-analysis observation date:** 17 October 2018

  -----------------------------------------------------------------------
  Area                                Key Finding
  ----------------------------------- -----------------------------------
  Customer base                       93,358 active customers had at
                                      least one delivered order.

  Purchase frequency                  97.00% were one-time customers;
                                      3.00% were repeat customers.

  Observed customer value             R\$15.42M from completed purchases.

  Value concentration                 48.85% of customers account for 80%
                                      of observed customer value.

  RFM                                 97% of active customers are F1;
                                      higher-frequency groups show
                                      substantially higher average
                                      observed value.

  High-value pathways                 High-value one-time customers
                                      average R\$390.63/order; high-value
                                      repeat customers average 2.16
                                      orders/customer at R\$194.91/order.

  Recent high-value segment           5,515 recent high-value one-time
                                      customers represent R\$2.20M
                                      observed value.

  Geography                           SP, RJ and MG account for 61.24% of
                                      the recent high-value one-time
                                      segment.

  Basket structure                    80.82% of recent high-value
                                      one-time customers place
                                      single-item orders.

  Customer experience                 Recent high-value customers average
                                      4.19 review score; 93.82% of
                                      observed deliveries were before the
                                      estimated date.
  -----------------------------------------------------------------------

## Business Questions

1.  Is the underlying data complete and structurally reliable enough for
    analysis?
2.  How does order demand evolve over time and across time-of-day
    periods?
3.  Where is customer demand geographically concentrated?
4.  How do order value and freight burden vary by customer state?
5.  How long do orders take to reach customers, and how accurate are
    estimated delivery dates?
6.  Which payment methods and installment patterns are observed?
7.  What does customer review behaviour indicate about customer
    experience?
8.  Who are the highest-value customer groups, how frequently do they
    purchase, and how is observed value concentrated?
9.  How do high-value one-time and repeat customers differ in their
    purchase pathways?

## Data Model & Analytical Grain

Instead of relying only on the ER diagram supplied with the dataset, a
**new detailed ER diagram** was created containing the major tables,
columns, primary keys, foreign keys, data types and relationships.

The purpose was to understand the complete schema before writing SQL,
identify one-to-many relationships and reduce the risk of double
counting.

Core tables:

-   `customers`
-   `orders`
-   `order_items`
-   `payments`
-   `order_reviews`
-   `products`
-   `sellers`
-   `geolocation`

The `orders` table represents the core transactional grain.
`order_items`, `payments` and `order_reviews` can contain multiple
records associated with one order. Customer-level analysis uses
`customer_unique_id` to identify the underlying customer across
potentially multiple `customer_id` records.

Payments and order items are aggregated to order level before customer-
or order-level metrics are calculated.

![ER Diagram](assets/ER_Diagram.png)

## Data Quality & Integrity

  Table                  Rows
  --------------- -----------
  customers            99,441
  geolocation       1,000,163
  order_items         112,650
  order_reviews        99,224
  orders               99,441
  payments            103,886
  products             32,951
  sellers               3,095

The orders table contains lifecycle timestamp missingness including 160
null `order_approved_at`, 1,783 null `order_delivered_carrier_date` and
2,965 null `order_delivered_customer_date`.

These values are interpreted in the context of order status rather than
automatically treated as data errors. Delivery-duration metrics are
calculated only where valid delivered-customer and estimated-delivery
timestamps are available.

## Demand, Growth & Seasonality

Observed order activity increased rapidly during the early period,
rising from **324 orders in October 2016 to 4,026 orders by July 2017**.

The early period contains unusually low volumes, including a missing
November 2016 observation and only one order in December 2016, so early
month-to-month comparisons require caution.

The **Afternoon (13:00--18:59)** period has the largest observed order
volume:

  Time Bucket     All Orders   Delivered Orders
  ------------- ------------ ------------------
  Afternoon           38,135             36,965
  Night               28,331             27,522
  Morning             27,733             26,919
  Dawn                 5,242              5,072

## Customer & Geographic Demand

São Paulo represents approximately **41.98%** of customers in the
state-level analysis, followed by Rio de Janeiro and Minas Gerais.

Geographic concentration can guide deeper investigation of customer
acquisition, category mix, logistics and service economics. State-level
rates should be read alongside order volume because smaller states can
produce volatile percentages.

## Order Value & Unit Economics

The analysis combines payments, orders and customers to calculate total
payment value and Average Order Value (AOV) by state.

Freight burden is calculated as:

``` text
Freight-to-Order-Value % = Total Freight Cost / Total Order Value × 100
```

This is a burden indicator, **not a profitability measure**. Complete
margin analysis would require additional cost information.

## Logistics & Delivery

Key findings:

-   **91.78%** of delivered orders arrived before the estimated delivery
    date.
-   Average delivery variance was **-11.16 days**.
-   The state-level correlation between average freight per order and
    average delivery days was **r = 0.80**.

The freight/delivery relationship is interpreted as an association
across state averages, not evidence that freight cost causes delivery
delays.

## Payment Behaviour

Credit card is the dominant observed payment method, followed by boleto.

### Installment classification

  Term                 Installments
  ------------------ --------------
  Single term                     1
  Short term                   2--3
  Medium term                  4--6
  Long term                   7--12
  Very long term             13--24
  Zero installment                0

**62.94% of orders use 1--3 installments**, while 7--12 installment
payments represent **15.64% of orders but 31.95% of payment value**.
Longer installment plans are therefore associated with higher-value
transactions in the observed data.

## Customer Experience

-   5-star reviews: **57.78%**
-   4-star reviews: **19.29%**
-   Positive reviews (4--5): **77.07%**
-   Excellent reviews among early deliveries: **62.50%**
-   Excellent reviews among late deliveries: **16.60%**
-   Bad reviews among late deliveries: **62.47%**

The delivery/review relationship is an association and should not be
interpreted as causal without controlling for other factors such as
product quality, seller performance and category.

## Customer Analytics & RFM

### Customer behaviour

-   Active customers: **93,358**
-   One-time customers: **90,557 (97.00%)**
-   Repeat customers: **2,801 (3.00%)**
-   Observed customer value: **R\$15.42M**
-   Average observed customer value: **R\$165.20**
-   Median observed customer value: **R\$107.78**

### Customer value concentration

**48.85% of customers account for 80% of observed customer value.**

This is materially different from assuming a standard 80/20 relationship
and demonstrates why concentration should be calculated from the actual
customer distribution.

### RFM definitions

  Component   Interpretation
  ----------- --------------------------------------
  R4          Most recent
  R1          Least recent
  F4          Highest frequency
  F1          Exactly one completed order
  M4          Highest observed customer-value band

Current project thresholds:

-   **M4:** observed customer value \> ₹182.40
-   **R4:** last purchase within 163 days of 17 October 2018

**97% of active customers are F1**, while higher-frequency customers
show substantially higher average observed customer value.

The project deliberately avoids unsupported labels such as *Churned*,
*At Risk* or *Champions*. A one-time customer is not automatically
considered churned because the dataset has a fixed observation end date.

## High-Value Customer Pathways

  Metric                           High-Value One-Time   High-Value Repeat
  ------------------------------ --------------------- -------------------
  Customers                                     21,586               1,771
  Avg. observed customer value               R\$390.63           R\$415.46
  Avg. orders/customer                            1.00                2.16
  Avg. order value                           R\$390.63           R\$194.91
  Avg. items/order                                1.32                1.29

High-value one-time customers generate observed value through a single
high-ticket purchase. High-value repeat customers reach a similar
observed value through approximately 2.16 lower-value purchases.

Basket size is nearly identical, indicating that **purchase frequency
and order value---not basket depth---differentiate the observed
pathways**.

## Recent High-Value Customer Profile

Definition:

-   **M4:** observed customer value \> ₹182.40
-   **R4:** last purchase within 163 days of 17 October 2018
-   **F1:** exactly one completed order

Segment metrics:

-   Customers: **5,515**
-   Observed value: **R\$2.20M**
-   Average order value: **R\$399.30**
-   Average review score: **4.19**
-   SP + RJ + MG: **61.24%**
-   Single-item orders: **80.82%**
-   Average delivery time: **10.51 days**
-   Delivered before estimated date: **93.82%**
-   Positive reviews: **79.87%**

The segment is geographically concentrated and primarily characterized
by **higher-ticket, single-item purchases rather than deep baskets**.
Health Beauty and Watches are among the largest observed product
categories.

## Dashboard

The customer analytics dashboard contains four pages:

### 1. Customer Overview & Behaviour

![Customer Overview](assets/01_customer_overview.png)

### 2. Customer Value & RFM

![Customer Value & RFM](assets/02_customer_value_rfm.png)

### 3. Recent High-Value Customer Pathways

![High-Value Customer Pathways](assets/03_high_value_pathways.png)

### 4. Recent High-Value Customer Profile

![Recent High-Value Customer Profile](assets/04_high_value_profile.png)

> Replace the image paths above with the final filenames used in the
> repository.

## Executive Business Insights

1.  **Repeat purchase behaviour is the clearest customer-value
    differentiation.** 97% of active customers make only one completed
    purchase.
2.  **Customer value is concentrated, but not according to a simple
    80/20 rule.** 48.85% of customers account for 80% of observed value.
3.  **High-value customers follow different purchase pathways.**
    One-time customers tend toward one high-ticket order, while repeat
    customers reach similar observed value through multiple lower-value
    orders.
4.  **Recent high-value one-time customers form a clearly identifiable
    segment.** The segment contains 5,515 customers and R\$2.20M
    observed value, concentrated in SP, RJ and MG.
5.  **Delivery performance is strongly associated with review
    outcomes.** Late deliveries have a much higher share of bad reviews
    than early deliveries.
6.  **Longer installment plans are associated with higher-value
    transactions.** 7--12 installment transactions represent 15.64% of
    orders but 31.95% of payment value.

## Analytical Recommendations

-   Investigate repeat-purchase pathways because most active customers
    are one-time buyers.
-   Use RFM and observed customer value to structure customer-level
    analysis.
-   Investigate recent high-value one-time customers as a potential
    repeat-purchase analysis segment.
-   Examine SP, RJ and MG for deeper category, customer and logistics
    analysis.
-   Study high-ticket purchase pathways and the transition from one-time
    to repeat purchasing.
-   Use logistics and review metrics as supporting diagnostics rather
    than assuming poor service explains non-repeat behaviour.
-   Use payment and installment behaviour to understand transaction
    mechanics without treating payment method alone as a driver of
    customer value.
-   Preserve order-level analytical grain when joining payments, order
    items, reviews and customer data.

## Data Limitations & Analytical Caveats

-   The dataset ends on **17 October 2018**.
-   Recent customers have a shorter opportunity window for repeat
    purchase.
-   One-time customer behaviour is **not equivalent to churn**.
-   Observed customer value is historical transaction value, not
    predicted Customer Lifetime Value and not profit.
-   Payments can contain multiple records per order and must be
    aggregated before order-level joins.
-   Order items can contain multiple records per order and can multiply
    metrics if grain is not controlled.
-   Review records require careful order-level handling.
-   Geolocation is a reference dataset and should not replace customer
    master geography for customer-state analysis.
-   State-level correlations represent association across state
    aggregates, not individual-level causal relationships.
-   The M4 threshold is a project-specific RFM scoring convention, not a
    universal definition of a valuable customer.

## Technology Stack

  -----------------------------------------------------------------------
  Tool                                Purpose
  ----------------------------------- -----------------------------------
  SQL / GoogleSQL                     Data profiling, transformation and
                                      business analysis

  Google BigQuery                     Analytical database and derived
                                      views

  Looker Studio                       Interactive customer analytics
                                      dashboard

  GitHub                              Version control and portfolio
                                      presentation

  ER Diagram                          Data-model understanding and grain
                                      control

  Business Analysis                   Translating SQL outputs into
                                      business insights
  -----------------------------------------------------------------------

## Repository Structure

``` text
target-brazil-ecommerce-analytics/
│
├── README.md
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
├── assets/
│   ├── ER_Diagram.png
│   ├── 01_customer_overview.png
│   ├── 02_customer_value_rfm.png
│   ├── 03_high_value_pathways.png
│   └── 04_high_value_profile.png
│
└── data/
    └── README.md
```

Raw dataset files are not included in the repository; BigQuery is
treated as the analytical source.

## Portfolio Deliverables

-   SQL scripts organized by analytical phase
-   BigQuery analytical views and customer-level derived datasets
-   Detailed ER diagram
-   Four-page Looker Studio customer analytics dashboard
-   Detailed business analysis report
-   Executive insights and recommendations
-   Documented analytical definitions and limitations

## Analytical Question Map

  -----------------------------------------------------------------------
  Phase                               Coverage
  ----------------------------------- -----------------------------------
  Phase 1 -- Data Quality & Integrity Q1--Q2: table profiling, null audit
                                      and missing-value investigation

  Phase 2 -- Demand, Growth &         Q3--Q5: monthly order trend,
  Seasonality                         seasonality and time-of-day demand

  Phase 3 -- Customer & Geographic    Q6--Q7: state/city concentration
  Demand                              and state-level fulfilment

  Phase 4 -- Order Value & Unit       Q8--Q10: payment value, AOV and
  Economics                           freight burden

  Phase 5 -- Logistics & Delivery     Q11--Q14: delivery duration, ETA
                                      accuracy, state logistics and
                                      freight/delivery association

  Phase 6 -- Payment Behaviour        Q15--Q16: payment methods, payment
                                      trends and installment behaviour

  Phase 7 -- Customer Experience      Q17--Q18: review distribution and
                                      delivery performance vs review
                                      score

  Customer Analytics Extension        Customer value, RFM, concentration,
                                      high-value pathways and recent
                                      high-value profile
  -----------------------------------------------------------------------

## Conclusion

This project demonstrates an end-to-end analytics workflow:

**SQL is the analytical engine → BigQuery is the scalable data layer →
Looker Studio is the communication layer → Business interpretation is
the final deliverable.**

The project moves from relational data modelling and data-quality
validation to customer behaviour, RFM segmentation, customer-value
concentration, high-value pathways and evidence-based business
priorities.

The analysis deliberately separates **observed behaviour from
assumptions about future behaviour**. In particular, one-time customers
are not labelled as churned because the dataset has a fixed observation
end date.

## Author

**Vijay Kumar**

Data Analytics \| SQL \| BigQuery \| Looker Studio \| Customer Analytics
