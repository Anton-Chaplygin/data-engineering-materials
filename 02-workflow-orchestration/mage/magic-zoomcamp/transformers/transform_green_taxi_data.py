if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):

    # trip_distance
    mask_non_zero_passangers = data['passenger_count'] > 0
    mask_non_zero_trip_distance = data['trip_distance'] > 0

    number_of_zero_passangers = data['passenger_count'].isin([0]).sum()
    number_of_zero_trip_distance = data['trip_distance'].isin([0]).sum()

    unique_vendors_before = list(data['VendorID'].unique())
    print(f"Before processing - Data contains results of the following vendors_ids: {unique_vendors_before}")

    print(f"Preprocessing: rows with the zero passangers: {number_of_zero_passangers}")
    print(f"Preprocessing: rows with the zero trip distance: {number_of_zero_trip_distance}")

    column_names = list(data.columns.values)
    count_values = 0
    for item in column_names:
        if any(char.isupper() or char.isspace() for char in item):
            count_values += 1

    print(f"{count_values} columns need to be renamed to snake case")



    cleaned_df = data.loc[(mask_non_zero_passangers & mask_non_zero_trip_distance)]
    cleaned_df['lpep_pickup_date'] = cleaned_df['lpep_pickup_datetime'].dt.date
    cleaned_df.columns = (cleaned_df.columns
                            .str.replace(" ", "_")
                            .str.lower()
    )

    unique_vendors = list(cleaned_df['vendorid'].unique())
    print(f"Data contains results of the following vendors_ids: {unique_vendors}")

    return cleaned_df


@test
def test_output(output, *args):
    unique_vendors = list(output['vendorid'].unique())
    assert len(output.loc[~output['vendorid'].isin(unique_vendors)]) == 0, "There are new vendors"

    assert output['passenger_count'].isin([0]).sum() == 0, "There are rides with zero passangers"
    assert output['trip_distance'].isin([0]).sum() == 0, "There are rides with zero trip distance"
