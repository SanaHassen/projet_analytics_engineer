# Projet : Accidents routiers en France

## Contexte et Objectifs du Projet

Chaque année, les forces de l'ordre en France recueillent des informations détaillées sur les accidents survenus sur les voies ouvertes à la circulation publique, impliquant au moins un véhicule et entraînant au moins une victime nécessitant des soins. Ces données sont archivées annuellement dans des fiches BAAC (Bulletin d'Analyse des Accidents Corporels).

Les données extraites des fiches BAAC, couvrant les années de 2005 à 2022, sont disponibles dans des bases de données annuelles. Ces bases contiennent des informations brutes structurées en quatre rubriques principales : CARACTÉRISTIQUES, LIEUX, VÉHICULES et USAGERS.

### Rubriques :
- **CARACTÉRISTIQUES :** Détails tels que l'heure de l'accident, l'éclairage, les conditions météorologiques, etc.
- **LIEUX :** Spécificités du site de l'accident.
- **VÉHICULES :** Informations sur les véhicules impliqués, telles que le type de véhicule et le sens de circulation.
- **USAGERS :** Description des individus impliqués dans les accidents.

L'objectif de notre projet est d'exploiter les données des dix dernières années sur les accidents routiers pour développer un outil permettant d'analyser les accidents de la route à l'échelle nationale, dans le but de réduire le nombre global de décès et d'accidents.

## Phases du Projet

### Exploration des Données
- Identification du périmètre du projet.
- Analyse approfondie des données pour identifier les informations pertinentes.
- Mise en œuvre de méthodes de nettoyage et de validation pour garantir la qualité des données.
- Application de premières transformations et nettoyages des données.

### Modélisation des Données
- Définition des indicateurs clés de performance (KPIs).
- Création de scénarios utilisateurs pour ces KPIs.
- Sélection d'un schéma de données adapté.
- Implémentation des bases de données.

### Construction du Pipeline ETL/ELT
- Transfert des données depuis les bases transitoires vers le data warehouse, ici Snowflake.
- Mise en place du pipeline de transformation des données (filtrage, agrégation, renommage des colonnes) dans Snowflake.

### Création du Tableau de Bord Analytique
- Utilisation de Power BI pour se connecter à Snowflake et générer des rapports analytiques.
