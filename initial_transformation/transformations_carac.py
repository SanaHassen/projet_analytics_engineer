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
            df = load_file(file_path, sep, 'caracteristiques', year)
            df = process_data(df, config)
            df = custom_transform_carac(df,year)
            save_processed_file(df,output)

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

def load_file(file_path, sep,type, year):
    print(file_path)
    encoding = 'utf-8'
    if year < 2019 and type == 'caracteristiques':
        encoding = 'latin1'
    df = pd.read_csv(file_path, sep=sep, encoding=encoding)
    return df

def custom_transform_carac(df,year):
    if year < 2019:
        df['hr'] = df['hr'].astype(str).str.zfill(4)
        df['hr'] = df['hr'].str[0:2]
        df.loc[df['gps'] == 'M', 'lattitude'] = df['lattitude'] / 100000
        df.loc[df['gps'] == 'M', 'longitude'] = df['longitude'] / 100000
        df.drop('gps', axis=1, inplace=True)
        df['an'] = 2000 + df['an']
        df['departement'] = df['departement'].apply(lambda x: str(x)[:-1] if x >= 100 and x % 10 == 0 else x)

    else:
        df['hr'] = df['hr'].str.split(':').str[0]
        df['lattitude'] = df['lattitude'].astype(str).str.replace(',', '.')
        df['longitude'] = df['longitude'].astype(str).str.replace(',', '.')

    df['hr'] = df['hr'].astype(int)
    df['longitude'] = df['longitude'].astype(float)
    df['lattitude'] = df['lattitude'].astype(float)

    final_columns = ['Num_Acc', 'jour', 'mois', 'an', 'hr', 'condition_eclairage', 'departement', 'commune', 'condition_agglomeration', 'intersection', 'condition_atmosphere', 'type_collision', 'adresse', 'lattitude', 'longitude']
    df = df[final_columns]
    print(df['an'].unique())
    return df
    
def main():
    carac_base_path = '../Data/donnees_caracteristiques/caracteristiques'
    carac_config = {
        'replace_values': {'adr': '', 'lat':0, 'long':0, 'atm':-1, 'col':-1},
        'data_types': {'an':'int', 'mois':'int', 'jour':'int', 'lum':'int',	'agg':'int', 'inter':'int', 'atm':'int', 'col':'int'},
        'rename_columns': {'lum':'condition_eclairage', 'agg':'condition_agglomeration', 'hrmn':'hr', 'int':'intersection', 'atm':'condition_atmosphere', 'col':'type_collision', 'com':'commune', 'adr':'adresse', 'lat':'lattitude', 'long':'longitude', 'dep':'departement'},
    }

    process_files(carac_base_path, range(2012,2019), carac_config,'../Processed_files/caracteristiques')
    process_files(carac_base_path, range(2019,2023), carac_config, '../Processed_files/caracteristiques', sep = ";")



if __name__ == "__main__":
    main()
