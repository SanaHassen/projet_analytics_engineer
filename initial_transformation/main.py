# ce fichier contient les transformations liées aux données immatriculation
import glob
import os
import pandas as pd
import logging
import time

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
        'final_columns': ['Num_Acc', 'category_route', 'regime_circulation', 'voie_reserve', 'profil_route', 'etat_surface', 'Infrastructure', 'situation','nb_voies']
    },

    "immatriculation" : {
        'columns_to_drop': ['Lettre Conventionnelle Véhicule', 'CNIT'],  
        'replace_values': {'Age véhicule': 999},
        'data_types': {'Age véhicule':'int'},
        'rename_columns': {'Année': 'annee', 'Lieu Admin Actuel - Territoire Nom': 'lieu_admin_actuel', 'Type Accident - Libellé':'type_accident', 'Type Accident - Libellé (old)':'type_accident','Catégorie véhicule': 'categorie_vehicule' , 'Age véhicule': 'age_vehicule'},
        'final_columns': ['Id_accident', 'annee', 'lieu_admin_actuel',	'type_accident', 'categorie_vehicule', 'age_vehicule']
    },

    "usagers" : {
        'columns_to_drop': ['place', 'id_usager', 'id_vehicule'],  
        'replace_values': {'trajet': -1, 'secu1': -1, 'secu2': -1, 'secu3': -1, 'secu': -1, 'locp':-1, 'actp':-1, 'etatp':-1, 'an_nais':-1},
        'data_types': {'trajet':'int', 'secu':'int', 'locp':'int', 'etatp':'int', 'an_nais':'int'},
        'rename_columns': {'catu':'category_usager', 'grav': 'gravite', 'trajet':'motif_deplacement', 'locp':'localisation_pieton', 'etatp':'pieton_seul_ou_non', 'actp':'action_pieton','an_nais':'annee_naissance'},

    },

     "caracteristiques" : {
        'replace_values': {'adr': '', 'lat':0, 'long':0, 'atm':-1, 'col':-1},
        'data_types': {'an':'int', 'mois':'int', 'jour':'int', 'lum':'int',	'agg':'int', 'inter':'int', 'atm':'int', 'col':'int'},
        'rename_columns': {'lum':'condition_eclairage', 'agg':'condition_agglomeration', 'int':'intersection', 'atm':'condition_atmosphere', 'col':'type_collision', 'com':'commune',	'adr':'adresse', 'hrmn':'hr', 'lat':'lattitude',	'long':'longitude', 'dep':'departement'},
    }

}


def get_separator(year, type):
    if type == 'immatriculation':
        return ';'
    if year < 2019:
        return ','
    return ';'

def preprocess_data(df, type):
    if type == "lieux":
        df['nbv'] = pd.to_numeric(df['nbv'], errors='coerce')
    return df

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
    encoding = 'utf-8'
    if year < 2019 and type == 'caracteristiques':
        encoding = 'latin1'
    df = pd.read_csv(os.path.abspath(file_path), sep=get_separator(year, type), encoding=encoding)
    return df

def save_file(df, output_path):
    df.to_csv(output_path, index=False)
    logging.info(f'File saved: {output_path}')

def custom_transform_vehicules(df, year=None):
    print('No specific transformations on type vehicules !')
    return df

def custom_transform_lieux(df,year=None):
    print('No specific transformations on type lieux !')
    return df

def custom_transform_carac(df, year=None):
    """
    Transforms the 'caracteristiques' DataFrame with custom adjustments for data consistency.

    For years before 2019:
    - Pads 'hr' column values with zeros to ensure a 4-digit format and extracts the first two characters representing the hour.
    - Divides 'lattitude' and 'longitude' values by 100000 to normalize coordinates when 'gps' column is marked 'M'.
    - Drops the 'gps' column as it's no longer needed after transformation.
    - Adjusts 'departement' codes by removing the trailing zero for codes ending in zero and greater than or equal to 100.

    For years 2019 and later:
    - Splits 'hr' column values at the colon and takes the first part representing the hour.
    - Replaces commas with dots in 'lattitude' and 'longitude' values to correct the decimal format.

    Applies to all years:
    - Converts 'hr' to an integer, 'lattitude', and 'longitude' to float for numerical consistency.
    - Selects and orders the final set of columns to match the desired DataFrame structure.

    Parameters:
    - df (pd.DataFrame): The input DataFrame containing 'caracteristiques' data.
    - year (int, optional): The year of the data which dictates the specific transformations to be applied.

    Returns:
    - pd.DataFrame: The transformed DataFrame with consistent and standardized data columns.
    """
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
    return df

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

    df['action_pieton'] = df['action_pieton'].replace('A', 10) #vu que tous les autres sont des int, j'ai ajoute celle la aussi
    df['action_pieton'] = df['action_pieton'].replace('B', -1) #here B stands for inconnue so je l'ai mis avec la categorie -1
    df['action_pieton'] = df['action_pieton'].astype(int)
    return df

def custom_transform_immatriculation(df, year=None):
    print('No specific transformations on type immatriculations !')
    return df

def custom_transform(df, type, year): 
    custom_transformations = {
        "vehicules": custom_transform_vehicules,
        "lieux": custom_transform_lieux,
        "usagers": custom_transform_usagers,
        "caracteristiques": custom_transform_carac,
        "immatriculation": custom_transform_immatriculation
    }

    fn = custom_transformations.get(type)
    if fn:
        return fn(df, year)
    return df


def transform():
    pattern = os.path.join(data_path, '**', '*.csv')
    files = glob.glob(pattern, recursive=True)

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

        output_path = f'../test/{name}.csv'
        save_file(df, output_path)
        
        # except Exception as e:
        #         logging.error(f'Error reading or processing {file}: {e}')

start_time = time.time()    
transform()
end_time = time.time()  # Enregistre le temps de fin
print(f"Le temps d'exécution du programme est de {end_time - start_time} secondes.")