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
-- Structure de la table `LIEUX`
--

CREATE TABLE `LIEUX` (
  `NUM_ACC` int(11) NOT NULL,
  `CATR` int(11) DEFAULT NULL,
  `CIRC` int(11) DEFAULT NULL,
  `NBV` int(11) DEFAULT NULL,
  `VOSP` int(11) DEFAULT NULL,
  `PROF` int(11) DEFAULT NULL,
  `PLAN` int(11) DEFAULT NULL,
  `SURF` int(11) DEFAULT NULL,
  `INFRA` int(11) DEFAULT NULL,
  `SITU` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Index pour les tables déchargées
--

--
-- Index pour la table `LIEUX`
--
ALTER TABLE `LIEUX`
  ADD PRIMARY KEY (`NUM_ACC`);

--
-- AUTO_INCREMENT pour les tables déchargées
--

--
-- AUTO_INCREMENT pour la table `LIEUX`
--
ALTER TABLE `LIEUX`
  MODIFY `NUM_ACC` int(11) NOT NULL AUTO_INCREMENT;

--
-- Contraintes pour les tables déchargées
--

--
-- Contraintes pour la table `LIEUX`
--
ALTER TABLE `LIEUX`
  ADD CONSTRAINT `LIEUX_ibfk_1` FOREIGN KEY (`NUM_ACC`) REFERENCES `CARACTERISTIQUES` (`NUM_ACC`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
