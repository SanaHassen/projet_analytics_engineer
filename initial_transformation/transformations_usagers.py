# ce fichier contient les transformations liées aux données usagers

import pandas as pd
import os
import logging
import numpy as np


logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def process_files(csv_path, year_range, config, output_path, sep=','):

    for year in year_range:

        file_path = f'{csv_path}_{year}.csv'
        output = f'{output_path}_{year}.csv' 
        

        if os.path.exists(file_path):
            logging.info(f'Start processing file: {file_path}')

            # try:
            df = pd.read_csv(file_path, sep=sep, low_memory=False)

            df = process_data(df, config)

            df  = custom_transform_usagers(df,year)
        
            save_processed_file(df,output)

        #     except Exception as e:
        #         logging.error(f'Error reading or processing {file_path}: {e}')
        # else:
        #     logging.warning(f'File does not exist: {file_path}')

def save_processed_file(df, output_path):
    df.to_csv(output_path, index=False)
    logging.info(f'File saved: {output_path}')

def process_data(df, config):

    columns_to_drop = config.get('columns_to_drop', [])
    df.drop(columns=columns_to_drop, inplace=True, errors='ignore') #make sure the code doesn't crash when not finding a column

    df.drop_duplicates(inplace=True)



    cols_replace_values = config.get('replace_values', {})
    for col, value in cols_replace_values.items():
        if col in df.columns and df[col].isna().sum() > 0:
            df[col] = df[col].fillna(value)

    cols_data_types= config.get('data_types', {})
    for col, dtype in cols_data_types.items():
        
        if col in df.columns:
            df[col] = df[col].astype(dtype)
    

    rename_columns = config.get('rename_columns', {})
    df.rename(columns = rename_columns, inplace=True)

    final_columns = config.get('final_columns', df.columns.tolist())
    df = df[final_columns]  
    return df

  
def custom_transform_usagers(df,year):
    if year < 2019:
            df['secu'] = df['secu'].astype(str)
            df['secu1_digit'] = df['secu'].str[0]
            df['secu2_digit'] = df['secu'].str[1].fillna('1')
            mapping = {
                        '1': '1', '2': '2', '3': '3', '4': '4', '9': '9'
            }
            df['secu1'] = df['secu1_digit'].map(mapping).fillna('-1')
            df.loc[df['secu2_digit'] != '1', 'secu1'] = '-1'
            df['secu2'] = '-1'
            df['secu3'] = '-1'
            for col in ['secu1', 'secu2', 'secu3']:
                df[col] = df[col].astype(int)
            df.drop(['secu1_digit','secu2_digit'], axis=1, inplace=True)

    final_columns = ['secu','secu1', 'secu2','secu3']
    df = df[final_columns]


    return df
    










    

def main():
    usagers_base_path = '../Data/donnees_usagers/usagers'
    usagers_config = {
        'columns_to_drop': ['place', 'id_usager', 'id_vehicule'],  
        'replace_values': {'trajet': -1, 'secu1': -1, 'secu2': -1, 'secu3': -1, 'secu': -1, 'locp':-1, 'actp':-1, 'etatp':-1, 'an_nais':-1},
        'data_types': {'trajet':'int', 'secu':'int', 'locp':'int', 'etatp':'int', 'an_nais':'int'},
        'rename_columns': {'catu':'category_usager', 'grav': 'gravite', 'trajet':'motif_deplacement', 'locp':'localisation_pieton', 'etatp':'pieton_seul_ou_non', 'actp':'action_pieton','an_nais':'annee_naissance'},
    }

    process_files(usagers_base_path, range(2012,2019), usagers_config,'../Processed_files/usagers')
    # process_files(usagers_base_path, range(2019,2023), usagers_config, '../Processed_files/usagers', sep = ";")



if __name__ == "__main__":
    main()
