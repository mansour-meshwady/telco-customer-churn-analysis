-------------------------------------------------
-------------------------------------------------
--Customer Churn Analysis-SQL 
--Database : TelcoCustomerDB
--Table: Customers
--Author: Mansour Meshwady
-------------------------------------------------
-------------------------------------------------

--------------------------
--Data Cleaning
--------------------------
---Check for Null Values
Select * 
from Customers 
where Churn is Null;

---Check Duplicates
select
customerID,
count(*) as Duplicates_Count
from Customers
group by customerID
having Count(*) > 1;

---Check Distinct Values
select 
distinct "Contract"
from Customers;

select 
distinct PaymentMethod
from Customers;

select 
distinct InternetService
from Customers;

select 
distinct Churn
from Customers;

select 
distinct gender
from Customers;

---Check Data Types
exec sp_help Customers;

------------------------------------
--Exploratory Data Analysis (EDA)
------------------------------------
---Total Customers
select count(*) as TotalCustomers
from Customers;

---Total Churned Customers
select count(*) as TotalChurnCustomers
from Customers
where Churn='Yes';

---Churn Rate
select 
Churn as ChurnStatus,
count(*) as CustomerCount,
round(count(*) *100/ sum(count(*)) over(),2) as "Percentage"
from Customers
group by Churn;

--OR (For Churn Only)
select
round(sum(case when Churn='Yes' then 1 else 0 end) * 100 /count(*),2) as ChurnRate
from Customers;

---------------------------------------
---Customer Demographics Analysis
---------------------------------------
---Churn Rate by Gender
select gender,
count(*) as #Customers ,
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by gender;

---Senior Citizens Analysis
select
    case
	   when SeniorCitizen=1 then 'Yes' else 'No' end as seniorstatus,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by
    case
	   when SeniorCitizen=1 then 'Yes' else 'No'end;

---Partner vs Churn
select
partner,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by Partner;


---Dependents vs Churn
select
Dependents,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by Dependents;

------------------------------
--Service Usage Analysis
------------------------------
---Internet Service Analysis
select 
InternetService,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by InternetService;

---Tech Support Analysis
select
TechSupport,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by TechSupport;

---Streaming Services Analysis
select
StreamingTV,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by StreamingTV;

select
StreamingMovies,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by StreamingMovies;

---------------------------------
--Contract & Payment Analysis
---------------------------------
---Contract Type Analysis
select
contract,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by contract;

---Payment Method Analysis
select
PaymentMethod,
count(*) as "Count",
sum(case when Churn='Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn='Yes' then 1 else 0 end) * 100.0 /count(*),2) as ChurnRate
from Customers
group by PaymentMethod;

-------------------------------------------
--Revenue Analysis
-------------------------------------------
---Average Monthly Charges
select
Churn,
avg(MonthlyCharges) as AvgMonthlyCharges
from Customers
group by Churn;

---Revenue Lost from Churn
--Total Lost
select
Churn,
sum(TotalCharges) as TotalLost
from Customers
where churn='Yes'
group by Churn;

--Monthly
select
Churn,
sum(MonthlyCharges) as MonthlyRevenueLost
from Customers
where churn='Yes'
group by Churn;




--Tenure Analysis
---Create Tenure Groups

select 
    case 
	   when tenure <= 12 then '0-1 Year'
	   when tenure <= 24 then '1-2 Years'
	   when tenure <= 48 then '2-4 Years'
	   else '4+ Years'
	end as TenureGroup,
count(*) as "count",
sum(case when Churn = 'yes' then 1 else 0 end) as #Churns,
round(sum(case when Churn = 'yes' then 1 else 0 end) *100.0/Count(*) ,2) as ChurnRate
from  Customers
group by 
    case 
	   when tenure <= 12 then '0-1 Year'
	   when tenure <= 24 then '1-2 Years'
	   when tenure <= 48 then '2-4 Years'
	   else '4+ Years'
	end ;

--Customers with Highest Charges
select 
top 10 customerID,
MonthlyCharges,
TotalCharges,
churn
from Customers
order by MonthlyCharges desc;

--Customers Most Likely to Churn
select
customerID,
contract,
PaymentMethod,
tenure,
MonthlyCharges,
InternetService
from Customers
where contract ='Month-to-month' and InternetService ='Fiber optic'
and tenure <= 12 and MonthlyCharges > 70;

--Churn Percentage by Contract Type
select
contract,
count(*) as "Count",
sum(case when Churn = 'Yes' then 1 else 0 end) as #Churn,
round(sum(case when Churn = 'Yes' then 1 else 0 end)*100.0/count(*),2) as ChurnRate
from customers
group by Contract;


--Rank Customers by Spending
select 
customerID,
Totalcharges,

rank() over(order by TotalCharges desc) as SpendingRank
from customers;


--Average Charges by Contract
select 
customerID,
contract,
MonthlyCharges,
avg(MonthlyCharges) over(partition by contract) as AvgContractCharge
from Customers;



------------------------------------------------------------------------
--Key Insights
------------------------------------------------------------------------
--1.Month-to-Month Contracts Have Highest Churn.
--2.New Customers Are More Likely to Churn.
--3.High Monthly Charges Increase Churn.
--4.Fiber Optic Users Show Higher Churn.
--5.Customers Without Tech Support Churn More.
--6.Electronic Check Users Churn More.

