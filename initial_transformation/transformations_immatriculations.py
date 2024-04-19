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



    immat_base_path = '../Data/donnees_immatriculation/immatriculation'

    immat_config = {
        'columns_to_drop': ['Lettre Conventionnelle Véhicule', 'CNIT'],  
        'replace_values': {'Age véhicule': 999},
        'data_types': {'Age véhicule':'int'},
        'rename_columns': {'Année': 'annee', 'Lieu Admin Actuel - Territoire Nom': 'lieu_admin_actuel', 'Type Accident - Libellé':'type_accident', 'Type Accident - Libellé (old)':'type_accident','Catégorie véhicule': 'categorie_vehicule' , 'Age véhicule': 'age_vehicule'},
        'final_columns': ['Id_accident',	'annee',	'lieu_admin_actuel',	'type_accident',	'categorie_vehicule',	'age_vehicule']

    }


    process_files(immat_base_path, range(2012,2022), immat_config, '../Processed_files/immatriculation', sep = ";")



if __name__ == "__main__":
    main()
