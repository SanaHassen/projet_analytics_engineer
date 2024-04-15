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
-- Structure de la table `VEHICULES`
--

CREATE TABLE `VEHICULES` (
  `ID_VEHICULE` int(11) NOT NULL,
  `NUM_ACC` int(11) NOT NULL,
  `NUM_VEH` varchar(255) DEFAULT NULL,
  `SENC` int(11) DEFAULT NULL,
  `CATV` int(11) DEFAULT NULL,
  `OBS` int(11) DEFAULT NULL,
  `OBSM` int(11) DEFAULT NULL,
  `CHOC` int(11) DEFAULT NULL,
  `MANV` int(11) DEFAULT NULL,
  `MOTOR` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `VEHICULES`
--
ALTER TABLE `VEHICULES`
  ADD PRIMARY KEY (`ID_VEHICULE`),
  ADD KEY `NUM_ACC` (`NUM_ACC`);

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `VEHICULES`
--
ALTER TABLE `VEHICULES`
  ADD CONSTRAINT `VEHICULES_ibfk_1` FOREIGN KEY (`NUM_ACC`) REFERENCES `CARACTERISTIQUES` (`NUM_ACC`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
