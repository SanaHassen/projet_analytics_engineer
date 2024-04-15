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
-- Structure de la table `USAGERS`
--

CREATE TABLE `USAGERS` (
  `ID_USAGER` int(11) NOT NULL,
  `NUM_ACC` int(11) NOT NULL,
  `ID_VEHICULE` int(11) DEFAULT NULL,
  `NUM_VEH` varchar(255) DEFAULT NULL,
  `PLACE` int(11) NOT NULL,
  `CATU` int(11) NOT NULL,
  `GRAV` int(11) NOT NULL,
  `SEXE` int(11) NOT NULL,
  `AN_NAIS` int(11) NOT NULL,
  `TRAJET` int(11) NOT NULL,
  `SECU1` int(11) NOT NULL,
  `SECU2` int(11) NOT NULL,
  `SECU3` int(11) NOT NULL,
  `LOCP` int(11) NOT NULL,
  `ACTP` int(11) NOT NULL,
  `ETATP` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `USAGERS`
--
ALTER TABLE `USAGERS`
  ADD PRIMARY KEY (`ID_USAGER`),
  ADD KEY `ID_USAGER` (`ID_USAGER`),
  ADD KEY `ID_USAGER_2` (`ID_USAGER`),
  ADD KEY `NUM_ACC` (`NUM_ACC`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `USAGERS`
--
ALTER TABLE `USAGERS`
  ADD CONSTRAINT `USAGERS_ibfk_1` FOREIGN KEY (`NUM_ACC`) REFERENCES `CARACTERISTIQUES` (`NUM_ACC`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
