import pyarrow as pa
import pyarrow.parquet as pq
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


os.environ["GOOGLE_APPLICATION_CREDENTIALS"] = "/home/src/my-rides-zoomcamp-7d000bdf1e21.json"

bucket_name = 'mage-de-zoomcamp-green-taxi'
project_id = 'my-rides-zoomcamp'

table_name = 'green_taxi_2022'
root_path = f"{bucket_name}/{table_name}"

@data_exporter
def export_data(data, *args, **kwargs):
    table = pa.Table.from_pandas(data)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path,
        partition_cols = ['source_file'],
        filesystem = gcs,
        coerce_timestamps="us"
    )
