CREATE MULTISET  TABLE Test_DB.household_power_consumption (
	"Date" VARCHAR(10)
	,"Time" TIME(0)
	,"Global_active_power" VARCHAR(6)
	,"Global_reactive_power" VARCHAR(5)
	,"Voltage" VARCHAR(7)
	,"Global_intensity" VARCHAR(6)
	,"Sub_metering_1" VARCHAR(6)
	,"Sub_metering_2" VARCHAR(6)
	,"Sub_metering_3" VARCHAR(6)
)NO PRIMARY INDEX;

/*Load  Data using Fast Load or TDStudio*/

SELECT COUNT(*) FROM Test_DB.household_power_consumption; --2,075,259

/* Sample of 10K rows for cluster testing
 * Changing ? to NULL
 * Changine to numeric data types
 * */
DELETE TABLE Test_DB.mt_household_power_consumption;
CREATE TABLE Test_DB.mt_household_power_consumption AS (
	SELECT TOP 10000
		CAST(ROW_NUMBER() OVER (ORDER BY Date, Time) AS BIGINT) as RN
		,CAST(CASE WHEN global_active_power = '?' THEN NULL ELSE global_active_power END AS NUMERIC(7,4)) AS global_active_power
		,CAST(CASE WHEN global_reactive_power = '?' THEN NULL ELSE global_reactive_power END AS NUMERIC(7,4)) AS global_reactive_power
		,CAST(CASE WHEN voltage = '?' THEN NULL ELSE voltage END AS NUMERIC(7,4)) AS voltage
		,CAST(CASE WHEN global_intensity = '?' THEN NULL ELSE global_intensity END AS NUMERIC(7,4)) AS global_intensity
		,CAST(CASE WHEN sub_metering_1 = '?' THEN NULL ELSE sub_metering_1 END AS NUMERIC(7,4)) AS sub_metering_1
		,CAST(CASE WHEN sub_metering_2 = '?' THEN NULL ELSE sub_metering_2 END AS NUMERIC(7,4)) AS sub_metering_2
		,CAST(CASE WHEN sub_metering_3 = '?' THEN NULL ELSE sub_metering_3 END AS NUMERIC(7,4)) AS sub_metering_3
	FROM Test_DB.household_power_consumption
) WITH DATA PRIMARY INDEX(RN);
