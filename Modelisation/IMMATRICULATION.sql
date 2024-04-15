-- phpMyAdmin SQL Dump
-- version 5.1.0
-- https://www.phpmyadmin.net/
--
-- Hôte : db.3wa.io
-- Généré le : lun. 15 avr. 2024 à 13:04
-- Version du serveur :  5.7.33-0ubuntu0.18.04.1-log
-- Version de PHP : 8.0.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `ericlefranc_accidents`
--

-- --------------------------------------------------------

--
-- Structure de la table `IMMATRICULATION`
--

CREATE TABLE `IMMATRICULATION` (
  `ID_ACCIDENT` int(11) NOT NULL,
  `CATEGORIE_VEHICULE` varchar(255) DEFAULT NULL,
  `TYPE_ACCIDENT` varchar(255) DEFAULT NULL,
  `TERRITOIRE` varchar(255) DEFAULT NULL,
  `ANNE` date DEFAULT NULL,
  `AGE_VEHICULE` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `IMMATRICULATION`
--
ALTER TABLE `IMMATRICULATION`
  ADD PRIMARY KEY (`ID_ACCIDENT`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `IMMATRICULATION`
--
ALTER TABLE `IMMATRICULATION`
  MODIFY `ID_ACCIDENT` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
