SELECT s.prd_id, COUNT(*)
FROM silver.crm_prd_info AS s
GROUP BY s.prd_id
HAVING s.prd_id > 1 OR s.prd_id IS NULL;


SELECT prd_cost
FROM silver.crm_prd_info AS s
WHERE prd_cost < 0 OR prd_cost IS NULL;

SELECT NULLIF(sls_order_dt,0) AS sls_order_dt
FROM bronze.crm_sales_details AS s
WHERE sls_order_dt = 0 OR LENGTH(sls_order_dt::TEXT) != 8 OR 
   sls_order_dt > 20500101 OR   sls_order_dt < 19000101;

SELECT DISTINCT
    sls_sales AS old_sls_sales, 
	sls_quantity, 
	sls_price AS old_sls_price, 
    CASE
        WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price) 
            THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales, 
    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
            THEN sls_sales / NULLIF(sls_quantity,0)
        ELSE sls_price
    END AS sls_price

FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price OR
    sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL OR
    sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;

SELECT
    old_cid,
    CASE 
        WHEN LENGTH(SUBSTRING(cid, 3,LENGTH(cid))) != 10 
            THEN 'AW' || LPAD(cid, 10 - LENGTH(cid) - 2, '0')
    END AS cid
    -- SUBSTRING(cid, 3,LENGTH(cid)) AS cid
	bdate, 
	gen
FROM bronze.erp_cust_az12;

SELECT *
FROM silver.crm_cust_info 
WHERE cst_key NOT IN (
    
);

SELECT  
    
    -- CASE 
    --     WHEN cid LIKE 'NAS%' 
    --         THEN SUBSTRING(cid, 4,LENGTH(cid)) 
    --     ELSE cid
    -- END AS cid, 
	CASE
        WHEN bdate > CURRENT_DATE  
            THEN NULL
        ELSE bdate
    END AS bdate 
    -- gen

FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > CURRENT_DATE;

SELECT  
    CASE 
        WHEN cid LIKE 'NAS%' 
            THEN SUBSTRING(cid, 4,LENGTH(cid)) 
        ELSE cid
    END AS cid,
    CASE
        WHEN bdate > CURRENT_DATE  
            THEN NULL
        ELSE bdate
    END AS bdate, 
	CASE
        WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
        WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
        ELSE 'n/a'
    END AS gen

FROM bronze.erp_cust_az12;

SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;

WITH cte AS (
SELECT 
    REPLACE(cid, '-', '') AS cid, 
	CASE
		WHEN UPPER(TRIM(cntry)) IN ('US', 'USA', 'UNITED STATES') THEN 'United States'
		WHEN UPPER(TRIM(cntry)) IN ('DE', 'GERMANY') THEN 'Germany'
		WHEN TRIM(cntry) IS NULL OR TRIM(cntry) = '' THEN 'n/a'
 		ELSE TRIM(cntry)
	END AS cntry
FROM bronze.erp_loc_a101
ORDER BY cid ASC) 

SELECT *
FROM cte;

INSERT INTO silver.erp_px_cat_g1v2 (
    id ,
	cat,
	subcat, 
	maintenance)
SELECT 
    id ,
	cat,
	subcat, 
	maintenance
FROM bronze.erp_px_cat_g1v2;

SELECT *
FROM silver.crm_prd_info;
