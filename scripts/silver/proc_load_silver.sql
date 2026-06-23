use master
use DataWareHouse
exec silver.load_silver
/*
Stored Procedure: Load silver Layer (Source -> silver)

Script Purpose:
This stored procedure loads data into the 'silver' schema from external CSV files.
It performs the following actions:
- Truncates the silver tables before loading data.
- Uses the BULK INSERT command to load data from CSV files to silver tables.

Parameters:
None.

*/

CREATE OR ALTER PROCEDURE silver.load_silver AS

BEGIN

-- Variables to measure load duration
DECLARE @start_time DATETIME,@end_time DATETIME,@batch_start_time DATETIME,@batch_end_time DATETIME;

BEGIN TRY

	SET @batch_start_time = GETDATE();

	PRINT '========================================';
	PRINT 'Loading silver Layer';
	PRINT '========================================';

	PRINT '----------------------------------------';
	PRINT 'Loading CRM Tables';
	PRINT '----------------------------------------';

	----------------------------------------------------------------------------------------
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.crm_cust_info';

	TRUNCATE TABLE silver.crm_cust_info;

	-- silver layer stores raw data.
	-- Using Full Load:
	-- 1. Delete existing records
	-- 2. Load fresh records from CSV

	PRINT '>> Inserting Data Into: silver.crm_cust_info';

	BULK INSERT silver.crm_cust_info FROM "C:\xampp\tmp\cust_info.csv"
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();

	PRINT '>> Load Duration: '
		+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
		+ ' seconds';

	SELECT * FROM silver.crm_cust_info;

	PRINT '>> --------------------';

	----------------------------------------------------------------------------------------
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.crm_prd_info';

	TRUNCATE TABLE silver.crm_prd_info;

	PRINT '>> Inserting Data Into: silver.crm_prd_info';

	BULK INSERT silver.crm_prd_info FROM "C:\xampp\tmp\prd_info.csv"
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();

	PRINT '>> Load Duration: '
		+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
		+ ' seconds';

	SELECT * FROM silver.crm_prd_info;

	PRINT '>> --------------------';

	----------------------------------------------------------------------------------------
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.crm_sales_details';

	TRUNCATE TABLE silver.crm_sales_details;

	PRINT '>> Inserting Data Into: silver.crm_sales_details';

	BULK INSERT silver.crm_sales_details
	FROM "C:\xampp\tmp\sales_details.csv"
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();

	PRINT '>> Load Duration: '
		+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
		+ ' seconds';

	SELECT * FROM silver.crm_sales_details;

	PRINT '>> --------------------';

	PRINT '----------------------------------------';
	PRINT 'Loading ERP Tables';
	PRINT '----------------------------------------';

	----------------------------------------------------------------------------------------
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.erp_loc_a101';

	TRUNCATE TABLE silver.erp_loc_a101;

	PRINT '>> Inserting Data Into: silver.erp_loc_a101';

	BULK INSERT silver.erp_loc_a101 FROM "C:\xampp\tmp\LOC_A101.csv"
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();

	PRINT '>> Load Duration: '
		+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
		+ ' seconds';

	SELECT * FROM silver.erp_loc_a101;

	PRINT '>> --------------------';

	----------------------------------------------------------------------------------------
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.erp_cust_az12';

	TRUNCATE TABLE silver.erp_cust_az12;

	PRINT '>> Inserting Data Into: silver.erp_cust_az12';

	BULK INSERT silver.erp_cust_az12
	FROM "C:\xampp\tmp\CUST_AZ12.csv"
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();

	PRINT '>> Load Duration: '
		+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
		+ ' seconds';

	SELECT * FROM silver.erp_cust_az12;

	PRINT '>> --------------------';

	----------------------------------------------------------------------------------------
	SET @start_time = GETDATE();

	PRINT '>> Truncating Table: silver.erp_px_cat_g1v2';

	TRUNCATE TABLE silver.erp_px_cat_g1v2;

	PRINT '>> Inserting Data Into: silver.erp_px_cat_g1v2';

	BULK INSERT silver.erp_px_cat_g1v2 FROM "C:\xampp\tmp\PX_CAT_G1V2.csv"
	WITH (
		FIRSTROW = 2,
		FIELDTERMINATOR = ',',
		TABLOCK
	);

	SET @end_time = GETDATE();

	PRINT '>> Load Duration: '
		+ CAST(DATEDIFF(SECOND,@start_time,@end_time) AS NVARCHAR)
		+ ' seconds';

	SELECT * FROM silver.erp_px_cat_g1v2;

	PRINT '>> --------------------';

	----------------------------------------------------------------------------------------

	SET @batch_end_time = GETDATE();

	PRINT '========================================';
	PRINT 'Loading silver Layer is Completed';

	PRINT 'Total Load Duration: '
		+ CAST(DATEDIFF(SECOND,@batch_start_time,@batch_end_time) AS NVARCHAR)
		+ ' seconds';

	PRINT '========================================';

END TRY

BEGIN CATCH

	PRINT '========================================';

	PRINT 'ERROR OCCURED DURING LOADING silver LAYER';

	PRINT 'Error Message: '
		+ ERROR_MESSAGE();

	PRINT 'Error Number: '
		+ CAST(ERROR_NUMBER() AS NVARCHAR);

	PRINT 'Error State: '
		+ CAST(ERROR_STATE() AS NVARCHAR);

	PRINT '========================================';

END CATCH

END
