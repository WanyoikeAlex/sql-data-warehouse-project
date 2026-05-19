CREATE OR REPLACE PROCEDURE bronze.load_bronze()
LANGUAGE plpgsql
AS $$
DECLARE 
    start_time TIMESTAMP;
    end_time TIMESTAMP;
    batch_start_time TIMESTAMP;
    batch_end_time TIMESTAMP;
    duration_seconds NUMERIC;
    batch_duration_seconds NUMERIC;
BEGIN
    batch_start_time := clock_timestamp();
    
    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading Bronze Layer';
    RAISE NOTICE '================================================';

    RAISE NOTICE 'Loading CRM Layer';
    RAISE NOTICE '================================================';
    RAISE NOTICE '>> Truncate Table: bronze.crm_cust_info';

    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_cust_info;
    RAISE NOTICE '>> Insert Data Into Table: bronze.crm_cust_info';
    COPY bronze.crm_cust_info(cst_id,cst_key,cst_firstname,cst_lastname,cst_marital_status,cst_gndr,cst_create_date)
    FROM 'C:\temp\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
    DELIMITER ','
    CSV HEADER;
    end_time := clock_timestamp();
    duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;

    -- SELECT * FROM bronze.crm_cust_info;

    -- CRM PROD INFO
    RAISE NOTICE '================================================';
    RAISE NOTICE '>> Truncate Table: crm_prd_info';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_prd_info;
    COPY bronze.crm_prd_info(prd_id,prd_key,prd_nm,prd_cost,prd_line,prd_start_dt,prd_end_dt)
    FROM 'C:\temp\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
    DELIMITER ','
    CSV HEADER;
    end_time := clock_timestamp();
    duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    -- SELECT * FROM bronze.crm_prd_info;

    -- ERP SALES----------------------------------------------------------------
    RAISE NOTICE '================================================';
    RAISE NOTICE '>> Truncate Table: bronze.crm_sales_details';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.crm_sales_details;
    COPY bronze.crm_sales_details(sls_ord_num,sls_prd_key,sls_cust_id,sls_order_dt,sls_ship_dt,sls_due_dt,sls_sales,sls_quantity,sls_price
    )
    FROM 'C:\temp\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
    DELIMITER ','
    CSV HEADER;
    end_time := clock_timestamp();
    duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    -- SELECT * FROM bronze.crm_sales_details;

    RAISE NOTICE '================================================';
    RAISE NOTICE 'Loading ERP Layer';
    RAISE NOTICE '================================================';

    -- ERP LOC----------------------------------------------------------------
    RAISE NOTICE '================================================';
    RAISE NOTICE '>> Truncate Table: bronze.erp_loc_a101';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_loc_a101;
    RAISE WARNING '>> Insert Data Into Table: bronze.erp_loc_a101';
    COPY bronze.erp_loc_a101(CID,CNTRY)
    FROM'C:\temp\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
    DELIMITER ','
    CSV HEADER;
    end_time := clock_timestamp();
    duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    -- SELECT * FROM bronze.erp_loc_a101;

    -- ERP CUST-----------------------------------------------------------------------------
    RAISE NOTICE '================================================';
    RAISE NOTICE '>> Truncate Table: bronze.erp_cust_az12';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_cust_az12;
    COPY bronze.erp_cust_az12(CID,BDATE,GEN)
    FROM'C:\temp\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
    DELIMITER ','
    CSV HEADER;
    end_time := clock_timestamp();
    duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;
    -- SELECT * FROM bronze.erp_cust_az12;

    -- ERP PX CAT------------------------------------------------------------------------------
    RAISE NOTICE '================================================';
    RAISE NOTICE '>> Truncate Table: bronze.erp_px_cat_g1v2';
    start_time := clock_timestamp();
    TRUNCATE TABLE bronze.erp_px_cat_g1v2;
    COPY bronze.erp_px_cat_g1v2(ID,CAT,SUBCAT,MAINTENANCE)
    FROM'C:\temp\dbc9660c89a3480fa5eb9bae464d6c07\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
    DELIMITER ','
    CSV HEADER;
    end_time := clock_timestamp();
    duration_seconds := EXTRACT(EPOCH FROM (end_time - start_time));
    RAISE NOTICE '>> Load Duration: % seconds', duration_seconds;

        -- SELECT * FROM bronze.erp_px_cat_g1v2;

    RAISE NOTICE '================================================';
    batch_end_time := clock_timestamp();
    batch_duration_seconds = EXTRACT(EPOCH FROM (batch_end_time - batch_start_time ));
    RAISE NOTICE '>> BACTH DURATION Duration: % seconds', batch_duration_seconds;
    EXCEPTION
        WHEN OTHERS THEN
            RAISE NOTICE 'ERROR WHEN LOADING bronze data';
END;
$$;
