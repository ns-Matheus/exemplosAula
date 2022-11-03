-- monkey.homes definition

CREATE TABLE `homes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `apartamento` int DEFAULT NULL,
  `bau` int DEFAULT NULL,
  `cds` text,
  `disponivel` int DEFAULT NULL,
  `interior` varchar(255) DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `qtd_chaves` int DEFAULT NULL,
  `transferivel` int DEFAULT NULL,
  `valor` int DEFAULT NULL,
  `valor_acresc` int DEFAULT NULL,
  `foto` varchar(500) DEFAULT NULL,
  `coins` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=89 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- monkey.homes_permission definition

CREATE TABLE `homes_permission` (
  `id` int NOT NULL AUTO_INCREMENT,
  `apartamento` int DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=31 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- monkey.users_homes definition

CREATE TABLE `users_homes` (
  `id` int NOT NULL AUTO_INCREMENT,
  `apartamento` int DEFAULT NULL,
  `expire_home` int DEFAULT NULL,
  `interior` varchar(255) DEFAULT NULL,
  `iptu` int DEFAULT NULL,
  `nome` varchar(255) DEFAULT NULL,
  `user_id` int DEFAULT NULL,
  `isOwner` bit(1) NOT NULL DEFAULT b'0',
  `isLocked` bit(1) NOT NULL DEFAULT b'1',
  `bau` int DEFAULT NULL,
  `qtd_chaves` int DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- monkey.`session` definition

CREATE TABLE `session` (
  `user_id` int DEFAULT NULL,
  `world` int DEFAULT NULL,
  `interior` varchar(50) DEFAULT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `apartamento` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;


-- monkey.session_temp definition

CREATE TABLE `session_temp` (
  `user_id` int DEFAULT NULL,
  `interior` varchar(50) DEFAULT NULL,
  `nome` varchar(50) DEFAULT NULL,
  `apartamento` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;



-- monkey.monkey_homes_moveis definition

CREATE TABLE `monkey_homes_moveis` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `preco` int(11) NOT NULL DEFAULT 0,
  `coins` int(11) NOT NULL DEFAULT 0,
  `url_foto` varchar(500) NOT NULL,
  `nome_vitrine` varchar(255) NOT NULL,
  `correcao_z` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=139 DEFAULT CHARSET=utf8mb4;


-- monkey.monkey_homes_moveis_position definition

CREATE TABLE `monkey_homes_moveis_position` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `id_moveis_user` int(11) NOT NULL,
  `x` double DEFAULT NULL,
  `y` double DEFAULT NULL,
  `z` double DEFAULT NULL,
  `h` double DEFAULT NULL,
  `codigo_mundo` int(11) DEFAULT NULL,
  `id_movel_user` int(11) NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=151 DEFAULT CHARSET=utf8mb4;


-- monkey.monkey_homes_moveis_user definition

CREATE TABLE `monkey_homes_moveis_user` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `nome` varchar(255) NOT NULL,
  `nome_vitrine` varchar(255) NOT NULL,
  `url_foto` varchar(255) NOT NULL,
  `user_id` int(11) NOT NULL,
  `usado` bit(1) NOT NULL DEFAULT b'0',
  `correcao_z` float NOT NULL DEFAULT 0,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=73 DEFAULT CHARSET=utf8mb4;