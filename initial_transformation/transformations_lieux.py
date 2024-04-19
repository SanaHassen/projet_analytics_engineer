# ce fichier contient les transformations liées aux données usagers

import pandas as pd
import os
import logging


logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

def process_files(csv_path, year_range, config, output_path, sep=','):

    for year in year_range:

        file_path = f'{csv_path}_{year}.csv'
        output = f'{output_path}_{year}.csv' 
        

        if os.path.exists(file_path):
            logging.info(f'Start processing file: {file_path}')

            try:
                df = pd.read_csv(file_path, sep=sep, low_memory=False)
                # print(f'------------- Before processing-{year} ------------')
                # print('----NaN----\n', df.isna().sum())
                # print('----cols_types----\n', df.dtypes)
                # print(f'------------- After processing-{year} ------------')
                df = process_data(df, config)
                # print('----NaN----\n', df.isna().sum())
                # print('----cols_types----\n', df.dtypes)
                save_processed_file(df,output)

            except Exception as e:
                logging.error(f'Error reading or processing {file_path}: {e}')
        else:
            logging.warning(f'File does not exist: {file_path}')

def preprocess_data(df, column_name):
    # Replace '#ERREUR' with NaN or another appropriate value before conversion
    df[column_name] = pd.to_numeric(df[column_name], errors='coerce')
    return df
def save_processed_file(df, output_path):
    df.to_csv(output_path, index=False)
    logging.info(f'File saved: {output_path}')

def process_data(df, config):

    columns_to_drop = config.get('columns_to_drop', [])
    df.drop(columns=columns_to_drop, inplace=True, errors='ignore') #make sure the code doesn't crash when not finding a column

    df.drop_duplicates(inplace=True)
    df = preprocess_data(df, 'nbv')
    print(df.columns.tolist())
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
    





   

def main():
    # def process_files(csv_path, year_range, config, sep=',')



    lieux_base_path = '../Data/donnees_lieux/lieux'

    lieux_config = {
        'columns_to_drop': ['voie', 'v1', 'v2', 'pr', 'pr1', 'plan', 'lartpc', 'larrout', 'vma', 'env1'],  
        'replace_values': {'circ': -1, 'vosp': -1, 'prof': -1,  'surf': -1, 'situ': -1, 'infra': -1, 'nbv':0 },
        'data_types': {'circ': 'int', 'vosp':'int', 'prof': 'int' , 'surf': 'int', 'situ': 'int', 'infra': 'int','nbv':'int'},
        'rename_columns': {'catr': 'category_route', 'circ': 'regime_circulation', 'vosp':'voie_reserve', 'prof': 'profil_route' , 'surf': 'etat_surface', 'situ': 'situation', 'infra': 'Infrastructure', 'nbv':'nb_voies'},
        'final_columns': ['Num_Acc',	'category_route', 'regime_circulation', 'voie_reserve', 'profil_route', 'etat_surface', 'Infrastructure', 'situation','nb_voies']

    }

    process_files(lieux_base_path, range(2012,2019), lieux_config,'../Processed_files/lieux')
    process_files(lieux_base_path, range(2019,2023), lieux_config, '../Processed_files/lieux', sep = ";")



if __name__ == "__main__":
    main()
