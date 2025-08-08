from awsglue.utils import getResolvedOptions
import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import year
from pyspark.sql import functions as F

# Contexto Glue
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)

args = getResolvedOptions(sys.argv, ['RAW_BUCKET_PATH', 'TRUSTED_BUCKET_PATH', 'TRUSTED_SUBFOLDER'])
raw_bucket_filefullpath = args['RAW_BUCKET_PATH']

trusted_bucket = args['TRUSTED_BUCKET_PATH']
trusted_folder = args['TRUSTED_SUBFOLDER']
truested_fullpath = trusted_bucket + "/" + trusted_folder + "/"

#raw_bucket_filefullpath = "s3://bucket-galdinoigor-firstgluejob-dev-raw-data/international_matches.csv"
#trusted_bucket = "s3://bucket-galdinoigor-firstgluejob-dev-trusted-data/brazil-wins/"

df_int_matches = spark.read \
    .option("header", "true") \
    .option("sep", ",") \
    .csv(raw_bucket_filefullpath)

df_brazil_matches = df_int_matches.filter((F.col("home_team") == "Brazil") | (F.col("away_team") == "Brazil"))

df_brazil_matches = df_brazil_matches.select("date", "home_team", "away_team", "home_team_result")

df_brazil_matches = df_brazil_matches.withColumn("year", year(df_brazil_matches["date"]))

df_brazil_grouped_wins = df_brazil_matches.groupBy("year").agg(
    F.sum(F.when(
        ((F.col("home_team") == "Brazil") & (F.col("home_team_result") == "Win")) |
        ((F.col("away_team") == "Brazil") & (F.col("home_team_result") == "Lose")),
        1
    ).otherwise(0)).alias("count_win")
)

df_brazil_grouped_wins.write \
    .mode("overwrite") \
    .option("header", True) \
    .csv(truested_fullpath)

job.commit()
