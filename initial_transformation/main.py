# ce fichier contient les transformations liées aux données immatriculation
import glob
import os
import pandas as pd
import logging

logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

data_path = "..\Data"
types = ["vehicules", "lieux"]
configs = {
    "vehicules" :{
        'columns_to_drop': ['senc', 'occutc', 'id_vehicule', 'motor'],  
        'replace_values': {'catv': 0, 'obs': -1, 'obsm': -1, 'choc': -1, 'manv': -1},
        'data_types': {'catv': 'int', 'obs': 'int', 'obsm': 'int', 'choc': 'int', 'manv': 'int'},
        'rename_columns': {'catv': 'category_veh', 'obs': 'obstacle', 'obsm': 'obstacle_m', 'manv': 'manoeuvre'},
        'final_columns': ['Num_Acc', 'num_veh', 'category_veh', 'obstacle', 'obstacle_m', 'choc', 'manoeuvre']
    },

    "lieux" : {
        'columns_to_drop': ['voie', 'v1', 'v2', 'pr', 'pr1', 'plan', 'lartpc', 'larrout', 'vma', 'env1'],  
        'replace_values': {'circ': -1, 'vosp': -1, 'prof': -1,  'surf': -1, 'situ': -1, 'infra': -1, 'nbv':0 },
        'data_types': {'circ': 'int', 'vosp':'int', 'prof': 'int' , 'surf': 'int', 'situ': 'int', 'infra': 'int','nbv':'int'},
        'rename_columns': {'catr': 'category_route', 'circ': 'regime_circulation', 'vosp':'voie_reserve', 'prof': 'profil_route' , 'surf': 'etat_surface', 'situ': 'situation', 'infra': 'Infrastructure', 'nbv':'nb_voies'},
        'final_columns': ['Num_Acc',	'category_route', 'regime_circulation', 'voie_reserve', 'profil_route', 'etat_surface', 'Infrastructure', 'situation','nb_voies']
    },

    

}


def get_separator(year, type):
    if type == "im":
        return ";"
    if year < 2019:
        return ','
    return ';'

def process_data(df, config):

    columns_to_drop = config.get('columns_to_drop', [])
    df.drop(columns=columns_to_drop, inplace=True, errors='ignore') #make sure the code doesn't crash when not finding a column
    print( "Drop unused columns done!")

    df.drop_duplicates(inplace=True)
    print( "Drop duplicated columns done!")

    cols_replace_values = config.get('replace_values', {})
    for col, value in cols_replace_values.items():
        if col in df.columns and df[col].isna().sum() > 0:
            df[col] = df[col].fillna(value)
    print( "Fill na done!")

    cols_data_types= config.get('data_types', {})
    for col, dtype in cols_data_types.items():
        if col in df.columns:
            df[col] = df[col].astype(dtype)
    print( "Change Data Types done!")

    rename_columns = config.get('rename_columns', {})
    df.rename(columns = rename_columns, inplace=True)
    print( "Rename columns done!")

    final_columns = config.get('final_columns', df.columns.tolist())
    df = df[final_columns]
    print( "Reorder columns done!")
    return df

def load_file(file_path, type, year):
    df = pd.read_csv(os.path.abspath(file_path), sep=get_separator(year, type))
    return df

def save_file(df, output_path):
    df.to_csv(output_path, index=False)
    logging.info(f'File saved: {output_path}')

def custom_transform_vehicules(df):
    print('custom transformation on vehicules done!')
    return df

def custom_transform_lieux(df):
    print('custom transformation on lieux done!')
    return df

def custom_transform_carac(df):
    print('custom transformation on carac done!')
    return df

def custom_transform_usagers(df):
    print('custom transformation on usagers done!')
    return df

def custom_transform_immatriculation(df):
    print('custom transformation on immatriculations done!')
    return df

def custom_transform(df, type): 
    custom_transformations = {
        "vehicules": custom_transform_vehicules,
        "lieux": custom_transform_lieux,

    }

    fn = custom_transformations.get(type)
    if fn:
        return fn(df)

def preprocess_data(df, type):
    if type == "lieux":
        df['nbv'] = pd.to_numeric(df['nbv'], errors='coerce')

def transform():
    pattern = os.path.join(data_path, '**', '*.csv')
    files = glob.glob(pattern, recursive=True)[-1:]

    for file in files:
        logging.info(f'Start processing file: {file}')
        try:
            name = file.replace(".csv", "").split("\\")[-1]
            year = int(name.split("_")[1])
            type = name.split("_")[0]
            config = configs.get(type)
            df = load_file(file, year,type)
            print(f'------------- Before processing-{year} ------------')
            print('----NaN----\n', df.isna().sum())
            print('----cols_types----\n', df.dtypes)

            df = preprocess_data(df,type)
            
            df = process_data(df, config)
            print(f'------------- After processing-{year} ------------')
            print('----NaN----\n', df.isna().sum())
            print('----cols_types----\n', df.dtypes)

            df = custom_transform(df, type)

            output_path = f'../Processed_files/{name}.csv'
            save_file(df, output_path)
            break
        except Exception as e:
                logging.error(f'Error reading or processing {file}: {e}')
       
transform()