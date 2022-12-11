-- phpMyAdmin SQL Dump
-- version 5.1.1
-- https://www.phpmyadmin.net/
--
-- Hôte : 127.0.0.1:3306
-- Généré le : sam. 10 déc. 2022 à 01:55
-- Version du serveur : 5.7.36
-- Version de PHP : 7.4.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Base de données : `freepacal_db`
--

-- --------------------------------------------------------

--
-- Structure de la table `utilisateurs`
--

DROP TABLE IF EXISTS `utilisateurs`;
CREATE TABLE IF NOT EXISTS `utilisateurs` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nom` varchar(40) NOT NULL,
  `prenom` varchar(40) NOT NULL,
  `email` varchar(160) NOT NULL,
  `tel` varchar(15) NOT NULL,
  `mot_de_passe` varchar(225) NOT NULL,
  `role` varchar(20) NOT NULL,
  `profile` varchar(225) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8;

--
-- Déchargement des données de la table `utilisateurs`
--

INSERT INTO `utilisateurs` (`id`, `nom`, `prenom`, `email`, `tel`, `mot_de_passe`, `role`, `profile`) VALUES
(4, 'shit', 'happens', 'email@gomba.com', '078115112235', 'slamat', 'director', 'www.slimit.com'),
(12, 'user1', 'user2', 'user@frrepascal.fr', '0784075061', 'd41d8cd98f00b204e9800998ecf8427e', 'admin', 'www.imag.fr'),
(14, 'user1', 'user2', 'user@frrepascal.fr', '0784075061', 'd41d8cd98f00b204e9800998ecf8427e', 'admin', 'www.imag.fr'),
(15, 'user1', 'user2', 'user@frrepascal.fr', '0784075061', 'd41d8cd98f00b204e9800998ecf8427e', 'admin', 'www.imag.fr'),
(16, 'user1', 'user2', 'user@frrepascal.fr', '0784075061', 'd41d8cd98f00b204e9800998ecf8427e', 'admin', 'www.imag.fr'),
(17, 'user1', 'user2', 'user@frrepascal.fr', '0784075061', 'd41d8cd98f00b204e9800998ecf8427e', 'admin', 'www.imag.fr');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
