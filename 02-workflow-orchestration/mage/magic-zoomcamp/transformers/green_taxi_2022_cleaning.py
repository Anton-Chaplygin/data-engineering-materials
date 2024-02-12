if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):
    
    column_names = list(data.columns.values)
    count_values = 0
    for item in column_names:
        if any(char.isupper() or char.isspace() for char in item):
            count_values += 1
    print(f"{count_values} columns need to be renamed to snake case")

    data.columns = data.columns.str.replace(" ", "_").str.lower()
                   

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
