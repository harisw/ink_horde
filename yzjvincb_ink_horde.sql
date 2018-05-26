-- phpMyAdmin SQL Dump
-- version 4.0.10.14
-- http://www.phpmyadmin.net
--
-- Inang: localhost:3306
-- Waktu pembuatan: 17 Mei 2016 pada 08.04
-- Versi Server: 5.6.30
-- Versi PHP: 5.4.31

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Basis data: `yzjvincb_ink_horde`
--

DELIMITER $$
--
-- Prosedur
--
DROP PROCEDURE IF EXISTS `sp_act_point`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_act_point`(pid_in int)
BEGIN
	DECLARE poin_aksi_akhir, poin_aksi_awal, velocity, maks, waktu INT;
	DECLARE terakhir_update TIMESTAMP;
	
	SELECT  ap_v INTO velocity from setting WHERE ap_id=1;
	SELECT  ap_dt INTO waktu FROM setting WHERE ap_id=1;
	SELECT  ap_max INTO maks FROM setting WHERE ap_id=1;	
	SELECT p_aksi INTO poin_aksi_awal FROM player WHERE p_id=pid_in;
	SELECT p_time INTO terakhir_update FROM player WHERE p_id=pid_in;
	
	SET poin_aksi_akhir = poin_aksi_awal + FLOOR(velocity * TIMEDIFF( NOW(), terakhir_update) / waktu);
	IF (poin_aksi_akhir > maks) THEN 
		SET poin_aksi_akhir=maks;
	END IF;
		
	UPDATE player SET p_aksi=poin_aksi_akhir WHERE p_id=pid_in;
	UPDATE player SET p_time=NOW() WHERE p_id=pid_in;
    END$$

DROP PROCEDURE IF EXISTS `sp_battle`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_battle`(
    p1id_in INT,
    p2id_in INT
    )
BEGIN
	DECLARE totalpoint, warna1, warna2, warna3, warna4, warna5, pointurn1, pointurn2, pointurn3, pointurn4, pointurn5 INT;
	DECLARE pt1, pt2, pt3, pt4, pt5, stat INT;
	DECLARE c1p1, c2p1, c3p1, c4p1, c5p1, c1p2, c2p2, c3p2, c4p2, c5p2 INT;
	DECLARE poinp1, poinp2 INT;
	SET totalpoint=0;
	
	SELECT cl_id INTO warna1 FROM color ORDER BY RAND() LIMIT 1;
	SELECT p_card1 INTO c1p1 FROM player WHERE p_id=p1id_in;
	SELECT p_card1 INTO c1p2 FROM player WHERE p_id=p2id_in;
	SELECT f_get_winner(warna1, c1p1, c1p2) INTO pointurn1;
	SET totalpoint=totalpoint+pointurn1;
	SET pt1=totalpoint;
	
	SELECT cl_id INTO warna2 FROM color ORDER BY RAND() LIMIT 1;
	SELECT p_card2 INTO c2p1 FROM player WHERE p_id=p1id_in;
	SELECT p_card2 INTO c2p2 FROM player WHERE p_id=p2id_in;
	SELECT f_get_winner(warna2, c2p1, c2p2) INTO pointurn2;
	SET totalpoint=totalpoint+pointurn2;
	SET pt2=totalpoint;
	
	SELECT cl_id INTO warna3 FROM color ORDER BY RAND() LIMIT 1;
	SELECT p_card3 INTO c3p1 FROM player WHERE p_id=p1id_in;
	SELECT p_card3 INTO c3p2 FROM player WHERE p_id=p2id_in;
	SELECT f_get_winner(warna3, c3p1, c3p2) INTO pointurn3;
	SET totalpoint=totalpoint+pointurn3;
	SET pt3=totalpoint;
	
	SELECT cl_id INTO warna4 FROM color ORDER BY RAND() LIMIT 1;
	SELECT p_card4 INTO c4p1 FROM player WHERE p_id=p1id_in;
	SELECT p_card4 INTO c4p2 FROM player WHERE p_id=p2id_in;
	SELECT f_get_winner(warna4, c4p1, c4p2) INTO pointurn4;
	SET totalpoint=totalpoint+pointurn4;
	SET pt4=totalpoint;
	
	SELECT cl_id INTO warna5 FROM color ORDER BY RAND() LIMIT 1;
	SELECT p_card5 INTO c5p1 FROM player WHERE p_id=p1id_in;
	SELECT p_card5 INTO c5p2 FROM player WHERE p_id=p2id_in;
	SELECT f_get_winner(warna5, c5p1, c5p2) INTO pointurn5;
	SET totalpoint=totalpoint+pointurn5;
	SET pt5=totalpoint;
	
	SET poinp1=FLOOR(totalpoint/10);
	SET poinp2=MOD(totalpoint, 10);
	
	IF (poinp1>poinp2) THEN 
		SELECT "MENANG";
		SET stat=1;
		UPDATE player SET p_uang=p_uang+10 WHERE p_id=p1id_in;
	ELSEIF (poinp1<poinp2) THEN 
		SELECT "KALAH";
		SET stat=-1;
	ELSEIF (poinp1>poinp2) THEN 
		SELECT "SERI";
		SET stat=0;
	END IF;
	
	INSERT INTO match_record(p1_id, p2_id, co1, pt1, co2, pt2, co3, pt3, co4, pt4, co5, pt5, stat) 
	VALUES (p1id_in, p2id_in, warna1, pt1, warna2, pt2, warna3, pt3, warna4, pt4, warna5, pt5, stat);
    END$$

DROP PROCEDURE IF EXISTS `sp_build`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_build`(
	user_id_in INT,
	card_out INT,
	c_id_in INT
    )
BEGIN
	IF(card_out=1)
		THEN UPDATE player SET p_card1 = c_id_in WHERE p_id = user_id_in;
	ELSEIF(card_out=2)
		THEN UPDATE player SET p_card2 = c_id_in WHERE p_id = user_id_in;
	ELSEIF(card_out=3)
		THEN UPDATE player SET p_card3 = c_id_in WHERE p_id = user_id_in;
	ELSEIF(card_out=4)
		THEN UPDATE player SET p_card4 = c_id_in WHERE p_id = user_id_in;
	ELSEIF(card_out=5)
		THEN UPDATE player SET p_card5 = c_id_in WHERE p_id = user_id_in;
	END IF;
    END$$

DROP PROCEDURE IF EXISTS `sp_buy_shop`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_buy_shop`(
	user_id_in INT,
	card_id_in INT
    )
BEGIN
	IF(SELECT 1 FROM player WHERE p_id = user_id_in AND p_uang >= (SELECT c_harga FROM card WHERE c_id = card_id_in))
		THEN UPDATE player SET p_uang = p_uang - (SELECT c_harga FROM card WHERE c_id = card_id_in) WHERE p_id = user_id_in;
		     INSERT INTO inventory VALUES (user_id_in, card_id_in);
		     
	ELSE 
		SELECT "Pembelian Gagal";
	END IF;
	
    END$$

DROP PROCEDURE IF EXISTS `sp_findmatch`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_findmatch`(IN `pid_in` INT)
BEGIN
	DECLARE lawan, aksi INT;
	SELECT p_aksi INTO aksi FROM player WHERE p_id=pid_in;
	
	IF (aksi>0) THEN
		UPDATE player SET p_aksi=p_aksi-1 WHERE p_id=pid_in;
		SELECT p_id INTO lawan FROM player WHERE p_id != pid_in ORDER BY RAND() LIMIT 1;
		CALL sp_battle(pid_in, lawan);
        SELECT MAX(match_id) AS hasil FROM match_record;
	ELSEIF (aksi<1) THEN
		SELECT -1 AS hasil;
	END IF;
    END$$

DROP PROCEDURE IF EXISTS `sp_login`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_login`(
    p_email_in VARCHAR(30),
     p_password_in VARCHAR(50)
     )
BEGIN
	IF EXISTS(SELECT 1 FROM player WHERE 
	(p_email = p_email_in) AND (p_password = MD5(p_password_in))) THEN
		SELECT -1, "Berhasil";
	ELSE
		SELECT 0, "Gagal";
	END IF;
    END$$

DROP PROCEDURE IF EXISTS `sp_show_army`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_show_army`(IN `p_id_in` INT)
    NO SQL
BEGIN
	DECLARE c_1, c_2, c_3, c_4, c_5 VARCHAR(50);
	IF EXISTS(SELECT 1 FROM player WHERE p_id = p_id_in)
		THEN SELECT c_nama INTO c_1 FROM card WHERE c_id IN (SELECT p_card1 FROM player WHERE p_id = p_id_in);
		     SELECT c_nama INTO c_2 FROM card WHERE c_id IN (SELECT p_card2 FROM player WHERE p_id = p_id_in);
		     SELECT c_nama INTO c_3 FROM card WHERE c_id IN (SELECT p_card3 FROM player WHERE p_id = p_id_in);
		     SELECT c_nama INTO c_4 FROM card WHERE c_id IN (SELECT p_card4 FROM player WHERE p_id = p_id_in);
		     SELECT c_nama INTO c_5 FROM card WHERE c_id IN (SELECT p_card5 FROM player WHERE p_id = p_id_in);
		     
		     SELECT c_1,c_2,c_3,c_4,c_5;
	ELSE
		SELECT -1 "GAGAL";
	END IF;
    END$$

DROP PROCEDURE IF EXISTS `sp_show_invent`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_show_invent`(IN `p_id_in` INT)
    NO SQL
BEGIN
	IF EXISTS(SELECT 1 FROM player WHERE p_id = p_id_in)
		THEN SELECT c_nama, c_id FROM card WHERE c_id IN(SELECT i_card_id FROM inventory WHERE i_player_id = p_id_in
			AND i_card_id NOT IN(SELECT p_card1 FROM player WHERE p_id = p_id_in)
			AND i_card_id NOT IN(SELECT p_card2 FROM player WHERE p_id = p_id_in) 
			AND i_card_id NOT IN(SELECT p_card3 FROM player WHERE p_id = p_id_in)
			AND i_card_id NOT IN(SELECT p_card4 FROM player WHERE p_id = p_id_in)
			AND i_card_id NOT IN(SELECT p_card5 FROM player WHERE p_id = p_id_in));
	END IF;
    END$$

DROP PROCEDURE IF EXISTS `sp_sign`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_sign`(IN `user_in` VARCHAR(20), IN `password_in` VARCHAR(32), IN `email_in` VARCHAR(20))
BEGIN
	DECLARE kartu1, kartu2,kartu3, kartu4, kartu5 INT;
	IF NOT EXISTS (SELECT 1 FROM player WHERE p_email=email_in) THEN
	INSERT INTO player (p_username, p_password, p_email, p_uang, p_time, p_aksi) VALUES(user_in, MD5(password_in), email_in, 5, NOW(), 10);
	
	/*MASUKKAN KARTU SATU*/	SELECT c_id INTO kartu1 FROM card WHERE c_id<=10 AND c_harga<50 ORDER BY RAND() LIMIT 1;
	INSERT INTO inventory VALUES ( (SELECT p_id FROM player WHERE p_email = email_in),(kartu1));
	
	/*MASUKKAN KARTU DUA*/	SELECT c_id INTO kartu2 FROM card WHERE c_id>10 AND c_id<=20 AND c_harga<50 ORDER BY RAND() LIMIT 1;
	INSERT INTO inventory VALUES ( (SELECT p_id FROM player WHERE p_email = email_in),(kartu2));
	
	/*MASUKKAN KARTU TIGA*/	SELECT c_id INTO kartu3 FROM card WHERE c_id >20 AND c_id<=30 AND c_harga<50 ORDER BY RAND() LIMIT 1;
	INSERT INTO inventory VALUES ( (SELECT p_id FROM player WHERE p_email = email_in),(kartu3));
	
	/*MASUKKAN KARTU EMPAT*/ SELECT c_id INTO kartu4 FROM card WHERE c_id>30 AND c_id<=40 AND c_harga<50 ORDER BY RAND() LIMIT 1;
	INSERT INTO inventory VALUES ( (SELECT p_id FROM player WHERE p_email = email_in),(kartu4));
	
	/*MASUKKAN KARTU LIMA*/ SELECT c_id INTO kartu5 FROM card WHERE c_id<=40 AND c_harga>=50 ORDER BY RAND() LIMIT 1;
	INSERT INTO inventory VALUES ( (SELECT p_id FROM player WHERE p_email = email_in),(kartu5));
	
	INSERT INTO inventory VALUES ( (SELECT p_id FROM player WHERE p_email = email_in),41);

	UPDATE player SET p_card1=kartu1, p_card2=kartu2, p_card3=kartu3, p_card4=kartu4, p_card5=kartu5 WHERE p_email=email_in;
    	SELECT 1 AS hasil;
	ELSE
		SELECT 0 AS hasil;
	END IF;
	END$$

DROP PROCEDURE IF EXISTS `sp_update_profil`$$
CREATE DEFINER=`yzjvincb`@`localhost` PROCEDURE `sp_update_profil`(IN `pid_in` INT, IN `username_in` VARCHAR(30), IN `password_in` VARCHAR(30), IN `email_in` VARCHAR(30))
    NO SQL
BEGIN
	IF EXISTS (SELECT 1 FROM player WHERE p_email=email_in)
	THEN 
		SELECT -1, "UPDATE GAGAL";
	ELSE
		UPDATE player SET p_username = username_in,
		p_password = MD5(password_in), p_email =email_in
		WHERE p_id = pid_in;
	END IF;
    END$$

--
-- Fungsi
--
DROP FUNCTION IF EXISTS `f_get_winner`$$
CREATE DEFINER=`yzjvincb`@`localhost` FUNCTION `f_get_winner`(
    indikator_in INT,
    c1_id_in INT,
    c2_id_in INT
    ) RETURNS int(11)
BEGIN
	DECLARE score, poin1, poin2 INT;
	SET score=0;    
	IF (indikator_in=1) 
		THEN SELECT c_redpoint INTO poin1 FROM card WHERE c_id=c1_id_in;
		SELECT c_redpoint INTO poin2 FROM card WHERE c_id=c2_id_in;
		IF (poin1>poin2) 
			THEN SET score=score+10;
		ELSEIF (poin1<poin2)
			THEN SET score=score+1;
		END IF;
	ELSE IF (indikator_in=2) 
		THEN SELECT c_bluepoint INTO poin1 FROM card WHERE c_id=c1_id_in;
		SELECT c_bluepoint INTO poin2 FROM card WHERE c_id=c2_id_in;
		IF (poin1>poin2) 
			THEN SET score=score+10;
		ELSEIF (poin1<poin2)
			THEN SET score=score+1;
		END IF;	
	ELSEIF (indikator_in=3) 
		THEN SELECT c_greenpoint INTO poin1 FROM card WHERE c_id=c1_id_in;
		SELECT c_greenpoint INTO poin2 FROM card WHERE c_id=c2_id_in;
		IF (poin1>poin2) 
			THEN SET score=score+10;
		ELSEIF (poin1<poin2)
			THEN SET score=score+1;
		END IF;
	ELSEIF (indikator_in=4) 
		THEN SELECT c_yellowpoint INTO poin1 FROM card WHERE c_id=c1_id_in;
		SELECT c_yellowpoint INTO poin2 FROM card WHERE c_id=c2_id_in;
		IF (poin1>poin2) 
			THEN SET score=score+10;
		ELSEIF (poin1<poin2)
			THEN SET score=score+1;
		END IF;
	ELSEIF (indikator_in=5) 
		THEN SELECT c_blackpoint INTO poin1 FROM card WHERE c_id=c1_id_in;
		SELECT c_blackpoint INTO poin2 FROM card WHERE c_id=c2_id_in;
		IF (poin1>poin2) 
			THEN SET score=score+10;
		ELSEIF (poin1<poin2)
			THEN SET score=score+1;
		END IF;
	ELSEIF (indikator_in=6) 
		THEN SELECT c_whitepoint INTO poin1 FROM card WHERE c_id=c1_id_in;
		SELECT c_whitepoint INTO poin2 FROM card WHERE c_id=c2_id_in;
		IF (poin1>poin2) 
			THEN SET score=score+10;
		ELSEIF (poin1<poin2)
			THEN SET score=score+1;
		END IF;
	END IF;
	END IF;
	RETURN score;
    END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `card`
--

DROP TABLE IF EXISTS `card`;
CREATE TABLE IF NOT EXISTS `card` (
  `c_id` int(11) NOT NULL AUTO_INCREMENT,
  `c_nama` varchar(30) DEFAULT NULL,
  `c_harga` int(11) DEFAULT NULL,
  `c_redpoint` int(11) DEFAULT NULL,
  `c_bluepoint` int(11) DEFAULT NULL,
  `c_greenpoint` int(11) DEFAULT NULL,
  `c_yellowpoint` int(11) DEFAULT NULL,
  `c_blackpoint` int(11) DEFAULT NULL,
  `c_whitepoint` int(11) DEFAULT NULL,
  `c_link` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`c_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=42 ;

--
-- Dumping data untuk tabel `card`
--

INSERT INTO `card` (`c_id`, `c_nama`, `c_harga`, `c_redpoint`, `c_bluepoint`, `c_greenpoint`, `c_yellowpoint`, `c_blackpoint`, `c_whitepoint`, `c_link`) VALUES
(1, '1.jpg', 40, 25, 75, 25, 25, 100, 15, 'Abaddon'),
(2, '2.jpg', 60, 50, 80, 55, 90, 50, 45, 'Alchemist'),
(3, '3.jpg', 60, 85, 60, 55, 50, 55, 80, 'Anti_Mage'),
(4, '4.jpg', 60, 55, 90, 50, 45, 80, 60, 'Arc_warden'),
(5, '5.jpg', 40, 95, 20, 30, 35, 65, 15, 'Blood_Seeker'),
(6, '6.jpg', 40, 50, 20, 70, 95, 20, 20, 'Bristleback'),
(7, '7.jpg', 60, 85, 50, 60, 50, 85, 45, 'Chaos_Knight'),
(8, '8.jpg', 40, 25, 65, 60, 70, 10, 90, 'Chen'),
(9, '9.jpg', 40, 50, 20, 15, 70, 70, 25, 'Clinkz'),
(10, '10.jpg', 40, 75, 10, 90, 30, 25, 50, 'Enchantress'),
(11, '11.jpg', 40, 75, 50, 80, 30, 10, 10, 'Huskar'),
(12, '12.jpg', 40, 75, 60, 70, 80, 60, 75, 'Invoker'),
(13, '13.jpg', 40, 30, 15, 5, 80, 65, 20, 'Juggernaut'),
(14, '14.jpg', 40, 35, 80, 30, 35, 10, 75, 'Luna'),
(15, '15.jpg', 40, 50, 25, 75, 80, 10, 10, 'Nature_Prophet'),
(16, '16.jpg', 40, 65, 85, 25, 25, 30, 15, 'Night_Stalker'),
(17, '17.jpg', 40, 80, 60, 30, 20, 20, 10, 'Ogre_Magi'),
(18, '18.jpg', 40, 75, 30, 25, 40, 0, 70, 'Omni_Knight'),
(19, '19.jpg', 60, 40, 90, 90, 40, 60, 50, 'Outworld_Devourer'),
(20, '20.jpg', 60, 50, 90, 50, 55, 80, 40, 'Phantom_Assassin'),
(21, '21.jpg', 40, 20, 65, 30, 70, 25, 30, 'Phantom_Lancer'),
(22, '22.jpg', 40, 30, 15, 70, 30, 25, 65, 'Pudge'),
(23, '23.jpg', 40, 10, 65, 70, 20, 35, 30, 'Rubick'),
(24, '24.jpg', 60, 95, 40, 40, 55, 95, 40, 'Shadow_Fiend'),
(25, '25.jpg', 40, 10, 70, 30, 60, 30, 15, 'Shadow_Shaman'),
(26, '26.jpg', 40, 15, 70, 25, 60, 25, 20, 'Silencer'),
(27, '27.jpg', 40, 10, 40, 30, 70, 10, 70, 'Skywrath_Mage'),
(28, '28.jpg', 60, 70, 85, 55, 50, 60, 80, 'Sven'),
(29, '29.jpg', 40, 15, 45, 70, 10, 60, 25, 'Tide_Hunter'),
(30, '30.jpg', 40, 20, 30, 60, 30, 25, 65, 'Tiny'),
(31, '31.jpg', 40, 65, 30, 25, 30, 15, 65, 'Tuskar'),
(32, '32.jpg', 40, 10, 20, 80, 10, 15, 70, 'Undying'),
(33, '33.jpg', 40, 25, 15, 70, 75, 20, 40, 'Venomancer'),
(34, '34.jpg', 60, 50, 50, 80, 55, 75, 50, 'Viper'),
(35, '35.jpg', 40, 60, 30, 70, 30, 10, 10, 'Windranger'),
(36, '36.jpg', 40, 20, 15, 75, 20, 75, 30, 'Wraith_King'),
(37, '37.jpg', 40, 15, 80, 30, 25, 20, 60, 'Zeus'),
(38, '38.jpg', 60, 90, 40, 50, 80, 60, 50, 'Doom'),
(39, '39.jpg', 40, 75, 10, 20, 70, 45, 20, 'Ember_Spirit'),
(40, '40.jpg', 40, 80, 20, 20, 75, 10, 10, 'Dragon_Knight'),
(41, '41.jpg', 40, 30, 30, 30, 30, 30, 30, 'Roshan');

-- --------------------------------------------------------

--
-- Struktur dari tabel `color`
--

DROP TABLE IF EXISTS `color`;
CREATE TABLE IF NOT EXISTS `color` (
  `cl_id` int(11) NOT NULL,
  `cl_name` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`cl_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `color`
--

INSERT INTO `color` (`cl_id`, `cl_name`) VALUES
(1, 'red'),
(2, 'blue'),
(3, 'green'),
(4, 'yellow'),
(5, 'black'),
(6, 'white');

-- --------------------------------------------------------

--
-- Struktur dari tabel `inventory`
--

DROP TABLE IF EXISTS `inventory`;
CREATE TABLE IF NOT EXISTS `inventory` (
  `i_player_id` int(11) DEFAULT NULL,
  `i_card_id` int(11) DEFAULT NULL,
  KEY `FK_player_invent` (`i_player_id`),
  KEY `fk_card_id` (`i_card_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `inventory`
--

INSERT INTO `inventory` (`i_player_id`, `i_card_id`) VALUES
(17, 5),
(17, 15),
(17, 29),
(17, 37),
(17, 20),
(17, 41),
(18, 10),
(18, 17),
(18, 25),
(18, 37),
(18, 28),
(18, 41),
(19, 6),
(19, 14),
(19, 22),
(19, 39),
(19, 3),
(19, 41),
(20, 1),
(20, 11),
(20, 22),
(20, 36),
(20, 2),
(20, 41);

-- --------------------------------------------------------

--
-- Struktur dari tabel `match_record`
--

DROP TABLE IF EXISTS `match_record`;
CREATE TABLE IF NOT EXISTS `match_record` (
  `match_id` int(11) NOT NULL AUTO_INCREMENT,
  `p1_id` int(11) DEFAULT NULL,
  `p2_id` int(11) DEFAULT NULL,
  `co1` int(11) DEFAULT NULL,
  `pt1` int(11) DEFAULT NULL,
  `co2` int(11) DEFAULT NULL,
  `pt2` int(11) DEFAULT NULL,
  `co3` int(11) DEFAULT NULL,
  `pt3` int(11) DEFAULT NULL,
  `co4` int(11) DEFAULT NULL,
  `pt4` int(11) DEFAULT NULL,
  `co5` int(11) DEFAULT NULL,
  `pt5` int(11) DEFAULT NULL,
  `stat` int(11) DEFAULT NULL,
  PRIMARY KEY (`match_id`),
  KEY `fk_p1` (`p1_id`),
  KEY `fk_p2` (`p2_id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=16 ;

-- --------------------------------------------------------

--
-- Struktur dari tabel `player`
--

DROP TABLE IF EXISTS `player`;
CREATE TABLE IF NOT EXISTS `player` (
  `p_id` int(11) NOT NULL AUTO_INCREMENT,
  `p_username` varchar(20) DEFAULT NULL,
  `p_password` char(32) DEFAULT NULL,
  `p_email` varchar(20) DEFAULT NULL,
  `p_uang` int(11) DEFAULT NULL,
  `p_card1` int(11) DEFAULT NULL,
  `p_card2` int(11) DEFAULT NULL,
  `p_card3` int(11) DEFAULT NULL,
  `p_card4` int(11) DEFAULT NULL,
  `p_card5` int(11) DEFAULT NULL,
  `p_aksi` int(11) DEFAULT NULL,
  `p_time` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`p_id`),
  KEY `fk_card1_player` (`p_card1`),
  KEY `fk_card2_player` (`p_card2`),
  KEY `fk_card3_player` (`p_card3`),
  KEY `fk_card4_player` (`p_card4`),
  KEY `fk_card5_player` (`p_card5`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=21 ;

--
-- Dumping data untuk tabel `player`
--

INSERT INTO `player` (`p_id`, `p_username`, `p_password`, `p_email`, `p_uang`, `p_card1`, `p_card2`, `p_card3`, `p_card4`, `p_card5`, `p_aksi`, `p_time`) VALUES
(17, 'amik', '30ac5e7fa0aae96bceb4c641ed3ae430', 'amik@gmail.com', 5, 5, 15, 29, 37, 20, 10, '2016-05-16 14:36:05'),
(18, 'hari', 'a9bcf1e4d7b95a22e2975c812d938889', 'hari@gmail.com', 5, 10, 17, 25, 37, 28, 10, '2016-05-16 14:38:44'),
(19, 'monyet', '547169e9b90c798e0daae9e554ce04d0', 'monyet@gmail.com', 5, 6, 14, 22, 39, 3, 10, '2016-05-16 15:23:01'),
(20, 'panji', 'd6b16b990a41b83f81a58d38ad7265f1', 'panji@gmail.com', 5, 1, 11, 22, 36, 2, 10, '2016-05-17 01:02:21');

-- --------------------------------------------------------

--
-- Struktur dari tabel `setting`
--

DROP TABLE IF EXISTS `setting`;
CREATE TABLE IF NOT EXISTS `setting` (
  `ap_v` int(11) DEFAULT NULL,
  `ap_dt` int(11) DEFAULT NULL,
  `ap_max` int(11) DEFAULT NULL,
  `ap_id` int(11) NOT NULL,
  PRIMARY KEY (`ap_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Dumping data untuk tabel `setting`
--

INSERT INTO `setting` (`ap_v`, `ap_dt`, `ap_max`, `ap_id`) VALUES
(1, 10, 15, 1);

--
-- Ketidakleluasaan untuk tabel pelimpahan (Dumped Tables)
--

--
-- Ketidakleluasaan untuk tabel `inventory`
--
ALTER TABLE `inventory`
  ADD CONSTRAINT `FK_player_invent` FOREIGN KEY (`i_player_id`) REFERENCES `player` (`p_id`),
  ADD CONSTRAINT `fk_card_id` FOREIGN KEY (`i_card_id`) REFERENCES `card` (`c_id`);

--
-- Ketidakleluasaan untuk tabel `match_record`
--
ALTER TABLE `match_record`
  ADD CONSTRAINT `fk_p1` FOREIGN KEY (`p1_id`) REFERENCES `player` (`p_id`),
  ADD CONSTRAINT `fk_p2` FOREIGN KEY (`p2_id`) REFERENCES `player` (`p_id`);

--
-- Ketidakleluasaan untuk tabel `player`
--
ALTER TABLE `player`
  ADD CONSTRAINT `fk_card1_player` FOREIGN KEY (`p_card1`) REFERENCES `card` (`c_id`),
  ADD CONSTRAINT `fk_card2_player` FOREIGN KEY (`p_card2`) REFERENCES `card` (`c_id`),
  ADD CONSTRAINT `fk_card3_player` FOREIGN KEY (`p_card3`) REFERENCES `card` (`c_id`),
  ADD CONSTRAINT `fk_card4_player` FOREIGN KEY (`p_card4`) REFERENCES `card` (`c_id`),
  ADD CONSTRAINT `fk_card5_player` FOREIGN KEY (`p_card5`) REFERENCES `card` (`c_id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
