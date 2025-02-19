# ce fichier contient les transformations liées aux données lieux

import pandas as pd
import os
import logging

# Configure logging to help in debugging and process monitoring
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def process_files(csv_path,year_range, columns_to_drop, final_columns, output_path, sep=','):
    """
    Process CSV files for a given range of years.
    
    Args:
        year_range (range): A range of years to process files for.
        columns_to_drop (list): List of column names to drop from the DataFrame.
        final_columns (list): List of column names to include in the final DataFrame.
        sep (str): Separator used in the CSV file, defaults to ','.
    """
    for year in year_range:
        file_path = f'{csv_path}_{year}.csv' 
        output = f'{output_path}_{year}.csv'

        if os.path.exists(file_path):
            logging.info(f'Start processing file: {file_path}')
            try:
                # Read the CSV file with specified separator
                df = pd.read_csv(file_path, sep=sep)
                # Process the DataFrame
                process_data(df, columns_to_drop, final_columns, output)
            except Exception as e:
                logging.error(f'Error reading or processing {file_path}: {e}')
        else:
            logging.warning(f'File does not exist: {file_path}')

def process_data(df, columns_to_drop, final_columns, output_path):
    """
    Process the data by cleaning and restructuring the DataFrame.
    
    Args:
        df (DataFrame): DataFrame to process.
        columns_to_drop (list): Columns to drop from the DataFrame.
        final_columns (list): Columns to retain in the final DataFrame.
        output_path (str): Path to save the processed DataFrame.
    """
    # Remove unwanted columns
    df.drop(columns=columns_to_drop, inplace=True)
    # Remove duplicate rows
    df.drop_duplicates(inplace=True)

    # Define replacement values for NaNs in specific columns
    replace_values = {'catv': 0, 'obs': -1, 'obsm': -1, 'choc': -1, 'manv': -1}
    for col in df.columns:
        if df[col].isna().sum() > 0:
            df[col] = df[col].fillna(value=replace_values.get(col, -1))
        if df[col].dtype != 'object' and col != 'Num_Acc':
            df[col] = df[col].astype(int)

    # Rename columns as specified
    df.rename(columns={
        'catv': 'category_veh',
        'obs': 'obstacle',
        'obsm': 'obstacle_m',
        'manv': 'manoeuvre'
    }, inplace=True)

    # Reorder the DataFrame to match the specified final columns
    df = df[final_columns]
    # Save the processed DataFrame to CSV
    df.to_csv(output_path, index=False)
    logging.info(f'File saved: {output_path}')

def main():
    """
    Main function to define file processing parameters and initiate processing.
    """
    # Columns to drop in earlier and later year ranges
    vehicules_base_path = '../Data/donnees_vehicules/vehicules'
    vehicules_output_path = '../Processed_files/vehicules'
    common_cols = ['senc', 'occutc']
    extended_cols = common_cols + ['id_vehicule', 'motor']
    final_cols = ['Num_Acc', 'num_veh', 'category_veh', 'obstacle', 'obstacle_m', 'choc', 'manoeuvre']

    # Process files from 2012 to 2018 
    process_files(vehicules_base_path, range(2012, 2019), common_cols, final_cols, vehicules_output_path)
    # Process files from 2019 to 2022 
    process_files(vehicules_base_path, range(2019, 2023), extended_cols, final_cols, vehicules_output_path, sep=';')

if __name__ == "__main__":
    main()
