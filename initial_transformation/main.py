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

    "immat_config" : {
        'columns_to_drop': ['Lettre Conventionnelle Véhicule', 'CNIT'],  
        'replace_values': {'Age véhicule': 999},
        'data_types': {'Age véhicule':'int'},
        'rename_columns': {'Année': 'annee', 'Lieu Admin Actuel - Territoire Nom': 'lieu_admin_actuel', 'Type Accident - Libellé':'type_accident', 'Type Accident - Libellé (old)':'type_accident','Catégorie véhicule': 'categorie_vehicule' , 'Age véhicule': 'age_vehicule'},
        'final_columns': ['Id_accident',	'annee',	'lieu_admin_actuel',	'type_accident',	'categorie_vehicule',	'age_vehicule']
    },

    "usagers_config" : {
        'columns_to_drop': ['place', 'id_usager', 'id_vehicule'],  
        'replace_values': {'trajet': -1, 'secu1': -1, 'secu2': -1, 'secu3': -1, 'secu': -1, 'locp':-1, 'actp':-1, 'etatp':-1, 'an_nais':-1},
        'data_types': {'trajet':'int', 'secu':'int', 'locp':'int', 'etatp':'int', 'an_nais':'int'},
        'rename_columns': {'catu':'category_usager', 'grav': 'gravite', 'trajet':'motif_deplacement', 'locp':'localisation_pieton', 'etatp':'pieton_seul_ou_non', 'actp':'action_pieton','an_nais':'annee_naissance'},
        # 'final_columns': ['Num_Acc', 'num_veh', 'category_usager',	'gravite', 'sexe', 'motif_deplacement',	'secu', 'secu1', 'secu2','secu3', 'localisation_pieton', 'pieton_seul_ou_non', 'annee_naissance']

    },

}


def get_separator(year, type):
    if type == 'immatriculation':
        return ';'
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
    print(file_path)
    df = pd.read_csv(os.path.abspath(file_path), sep=get_separator(year, type))
    return df

def save_file(df, output_path):
    df.to_csv(output_path, index=False)
    logging.info(f'File saved: {output_path}')

def custom_transform_vehicules(df, year=None):
    print('custom transformation on vehicules done!')
    return df

def custom_transform_lieux(df,year=None):
    print('custom transformation on lieux done!')
    return df

def custom_transform_carac(df, year=None):
    print('custom transformation on carac done!')
    return df

def transform_secu_column(row):
    # Extract the first and second digit from the 'secu' column
    secu_value = str(row['secu'])
    if len(secu_value) == 2 and secu_value != '-1':
        first_digit, second_digit = secu_value
        # Check if the equipment was used based on the second digit
        if second_digit == '1':
            return int(first_digit), -1, -1
    return -1, -1, -1

def custom_transform_usagers(df, year=None):
    """
    Transforms the 'secu' column in usagers dataset for years before 2019 to match the format of newer datasets (2019+).
    The original 'secu' column includes two-digit codes where the first digit indicates the type of safety equipment used,
    and the second digit indicates whether it was used. In datasets from 2019 onward, there are three separate columns
    for safety equipment. This function maps the old format to the new format, setting 'secu1' based on the first digit
    if the second digit is '1', and setting 'secu2' and 'secu3' to -1, indicating undetermined status.

    Parameters:
        df (pd.DataFrame): The DataFrame containing usagers data.
        year (int, optional): The year of the dataset, used to determine whether the transformation should be applied.
                              The transformation is applied if the year is before 2019.

    Returns:
        pd.DataFrame: The DataFrame with the transformed data.
    """
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
        df.drop(['secu1_digit', 'secu', 'secu2_digit'], axis=1, inplace=True)

    final_columns = ['Num_Acc', 'num_veh', 'category_usager', 'gravite', 'sexe', 'motif_deplacement', 'secu1', 'secu2','secu3', 'localisation_pieton', 'action_pieton','pieton_seul_ou_non', 'annee_naissance']
    df = df[final_columns]

    df['action_pieton'] = df['action_pieton'].replace('A', -1)
    df['action_pieton'] = df['action_pieton'].replace('B', -1)
    df['action_pieton'] = df['action_pieton'].astype(int)
    return df

def custom_transform_immatriculation(df, year=None):
    print('custom transformation on immatriculations done!')
    return df

def custom_transform(df, type, year): 
    custom_transformations = {
        "vehicules": custom_transform_vehicules,
        "lieux": custom_transform_lieux,
        "usagers": custom_transform_usagers
    }

    fn = custom_transformations.get(type)
    if fn:
        return fn(df, year)
    return df

def preprocess_data(df, type):
    if type == "lieux":
        df['nbv'] = pd.to_numeric(df['nbv'], errors='coerce')
    return df

def transform():
    pattern = os.path.join(data_path, '**', '*.csv')
    files = glob.glob(pattern, recursive=True)[-1:]

    for file in files:
        logging.info(f'Start processing file: {file}')
        # try:
        name = file.replace(".csv", "").split("\\")[-1]
        year = int(name.split("_")[1])
        type = name.split("_")[0]
        config = configs.get(type)

        df = load_file(file,type, year)

        df = preprocess_data(df,type)

        df = process_data(df, config)
     
        df = custom_transform(df, type, year)

        output_path = f'../Processed_files/{name}.csv'
        save_file(df, output_path)
        break
        # except Exception as e:
        #         logging.error(f'Error reading or processing {file}: {e}')
       
transform()