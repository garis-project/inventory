-- phpMyAdmin SQL Dump
-- version 4.7.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Aug 15, 2022 at 02:53 PM
-- Server version: 10.1.29-MariaDB
-- PHP Version: 7.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `skripsi_inventori`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id_admin` int(10) NOT NULL,
  `username` varchar(100) NOT NULL DEFAULT '',
  `password` varchar(255) NOT NULL DEFAULT '',
  `nama_admin` varchar(100) NOT NULL DEFAULT '',
  `level` varchar(255) DEFAULT 'Admin'
) ENGINE=InnoDB DEFAULT CHARSET=latin1 ROW_FORMAT=COMPACT;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id_admin`, `username`, `password`, `nama_admin`, `level`) VALUES
(4, 'admin', '$2y$10$41UtNJc5QFJbgLWtqDZm..ziGXPFlKziMHowHFT68PfsCzvuuIfLW', 'admin', 'admin'),
(7, 'fauzi', 'fauzi', 'magista', 'admin');

-- --------------------------------------------------------

--
-- Table structure for table `barang`
--

CREATE TABLE `barang` (
  `id_barang` int(11) NOT NULL,
  `kode_barang` char(20) NOT NULL,
  `nama_barang` varchar(100) DEFAULT NULL,
  `no_rak` varchar(20) DEFAULT NULL,
  `satuan` varchar(20) DEFAULT NULL,
  `harga` double(11,0) DEFAULT NULL,
  `stok` int(11) DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `barang`
--

INSERT INTO `barang` (`id_barang`, `kode_barang`, `nama_barang`, `no_rak`, `satuan`, `harga`, `stok`) VALUES
(9, 'BR.001', 'Bondex', '001', 'pcs', 10000, 1232131622),
(10, 'BR.002', 'Spandek', '001', 'pcs', 60000, 174);

-- --------------------------------------------------------

--
-- Table structure for table `barang_keluar`
--

CREATE TABLE `barang_keluar` (
  `id_barang_keluar` int(11) NOT NULL,
  `kwt_barang_keluar` char(10) NOT NULL,
  `id_customer` int(11) NOT NULL,
  `tgl_barang_keluar` date DEFAULT NULL,
  `id_admin` int(11) DEFAULT NULL,
  `status` varchar(20) DEFAULT 'Belum Diverifikasi'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `barang_keluar`
--

INSERT INTO `barang_keluar` (`id_barang_keluar`, `kwt_barang_keluar`, `id_customer`, `tgl_barang_keluar`, `id_admin`, `status`) VALUES
(46, 'KWK001', 1, '2020-05-16', NULL, 'Belum Diverifikasi'),
(50, 'KWK002', 3, '2022-08-15', NULL, 'Belum Diverifikasi');

-- --------------------------------------------------------

--
-- Table structure for table `barang_keluar_rinci`
--

CREATE TABLE `barang_keluar_rinci` (
  `id_barang_keluar_rinci` int(11) NOT NULL,
  `id_barang` int(11) DEFAULT NULL,
  `harga_keluar` double(11,0) DEFAULT NULL,
  `jml_keluar` int(11) DEFAULT NULL,
  `id_barang_keluar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Triggers `barang_keluar_rinci`
--
DELIMITER $$
CREATE TRIGGER `ai_stok` AFTER INSERT ON `barang_keluar_rinci` FOR EACH ROW BEGIN
  UPDATE barang SET stok=stok-NEW.jml_keluar
  WHERE id_barang=NEW.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `au_stok` AFTER UPDATE ON `barang_keluar_rinci` FOR EACH ROW BEGIN
  UPDATE barang SET stok= stok-NEW.jml_keluar + OLD.jml_keluar
  WHERE id_barang = OLD.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `bd_stok` BEFORE DELETE ON `barang_keluar_rinci` FOR EACH ROW BEGIN
  UPDATE barang SET stok = stok + OLD.jml_keluar
  WHERE id_barang=OLD.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `barang_masuk`
--

CREATE TABLE `barang_masuk` (
  `id_barang_masuk` int(11) NOT NULL,
  `kwt_barang_masuk` char(10) NOT NULL,
  `id_supplier` int(11) DEFAULT NULL,
  `tgl_barang_masuk` date DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- --------------------------------------------------------

--
-- Table structure for table `barang_masuk_rinci`
--

CREATE TABLE `barang_masuk_rinci` (
  `id_barang_masuk_rinci` int(11) NOT NULL,
  `id_barang` int(11) DEFAULT NULL,
  `harga_masuk` double(11,0) DEFAULT NULL,
  `jml_masuk` int(11) DEFAULT NULL,
  `stok_masuk` int(11) NOT NULL DEFAULT '0',
  `id_barang_masuk` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Triggers `barang_masuk_rinci`
--
DELIMITER $$
CREATE TRIGGER `ai_stok2` AFTER INSERT ON `barang_masuk_rinci` FOR EACH ROW BEGIN
  UPDATE barang SET stok=stok+NEW.jml_masuk
  WHERE id_barang=NEW.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `au_stok_masuk` AFTER UPDATE ON `barang_masuk_rinci` FOR EACH ROW BEGIN
  UPDATE barang SET stok= stok+NEW.jml_masuk - OLD.jml_masuk
  WHERE id_barang = OLD.id_barang;
END
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `bd_stok2` BEFORE DELETE ON `barang_masuk_rinci` FOR EACH ROW BEGIN
  UPDATE barang SET stok = stok - OLD.jml_masuk
  WHERE id_barang=OLD.id_barang;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer`
--

CREATE TABLE `customer` (
  `id_customer` int(11) NOT NULL,
  `nama_customer` varchar(200) DEFAULT NULL,
  `alamat` text,
  `tlp` char(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`id_customer`, `nama_customer`, `alamat`, `tlp`) VALUES
(1, 'Toko Anda', 'Taktakan', '08212894249'),
(3, 'Magista', 'Jln.Kh.killin', '0895358694267');

-- --------------------------------------------------------

--
-- Table structure for table `kartu_stok`
--

CREATE TABLE `kartu_stok` (
  `id_kartu_stok` int(11) NOT NULL,
  `stok_awal` int(11) DEFAULT '0',
  `id_barang` int(11) NOT NULL,
  `id_barang_masuk_rinci` int(11) NOT NULL,
  `jm_stok_masuk` int(11) NOT NULL DEFAULT '0',
  `id_barang_keluar_rinci` int(11) NOT NULL,
  `id_barang_keluar` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Triggers `kartu_stok`
--
DELIMITER $$
CREATE TRIGGER `bd_kartu_stok` BEFORE DELETE ON `kartu_stok` FOR EACH ROW BEGIN
  UPDATE barang_masuk_rinci SET stok_masuk = stok_masuk + (OLD.stok_awal - OLD.jm_stok_masuk)
  WHERE id_barang_masuk_rinci=OLD.id_barang_masuk_rinci;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `rak`
--

CREATE TABLE `rak` (
  `id_rak` int(11) NOT NULL,
  `no_rak` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `rak`
--

INSERT INTO `rak` (`id_rak`, `no_rak`) VALUES
(2, '001'),
(1, '002');

-- --------------------------------------------------------

--
-- Table structure for table `satuan`
--

CREATE TABLE `satuan` (
  `id_satuan` int(11) NOT NULL,
  `satuan` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `satuan`
--

INSERT INTO `satuan` (`id_satuan`, `satuan`) VALUES
(2, 'pcs');

-- --------------------------------------------------------

--
-- Table structure for table `supplier`
--

CREATE TABLE `supplier` (
  `id_supplier` int(11) NOT NULL,
  `nama_supplier` varchar(200) DEFAULT NULL,
  `alamat` text,
  `tlp` char(13) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

--
-- Dumping data for table `supplier`
--

INSERT INTO `supplier` (`id_supplier`, `nama_supplier`, `alamat`, `tlp`) VALUES
(1, 'Kantor Utama', 'Jakarta', '021049394'),
(2, 'PT.Maju Mundur', 'Jln.Kh.killin', '0895358694267'),
(3, 'Magista', 'Jln.Kh.killin', '0895358694267');

-- --------------------------------------------------------

--
-- Table structure for table `tmp_barang`
--

CREATE TABLE `tmp_barang` (
  `id_tmp` int(11) NOT NULL,
  `id_barang` int(11) NOT NULL,
  `id_transaksi` int(11) NOT NULL,
  `jml_tmp` int(11) NOT NULL,
  `harga_tmp` double(11,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id_admin`);

--
-- Indexes for table `barang`
--
ALTER TABLE `barang`
  ADD PRIMARY KEY (`id_barang`),
  ADD KEY `fk_jenis` (`no_rak`),
  ADD KEY `fk_satuan` (`satuan`);

--
-- Indexes for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD PRIMARY KEY (`id_barang_keluar`),
  ADD KEY `fk_admin` (`id_admin`),
  ADD KEY `fk_distributor` (`id_customer`);

--
-- Indexes for table `barang_keluar_rinci`
--
ALTER TABLE `barang_keluar_rinci`
  ADD PRIMARY KEY (`id_barang_keluar_rinci`),
  ADD KEY `fk_barang2` (`id_barang`),
  ADD KEY `fk_id_pengeluaran` (`id_barang_keluar`);

--
-- Indexes for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD PRIMARY KEY (`id_barang_masuk`),
  ADD KEY `fk_supplier` (`id_supplier`);

--
-- Indexes for table `barang_masuk_rinci`
--
ALTER TABLE `barang_masuk_rinci`
  ADD PRIMARY KEY (`id_barang_masuk_rinci`),
  ADD KEY `fk_barang1` (`id_barang`),
  ADD KEY `fk_id_order_barang` (`id_barang_masuk`);

--
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`id_customer`);

--
-- Indexes for table `kartu_stok`
--
ALTER TABLE `kartu_stok`
  ADD PRIMARY KEY (`id_kartu_stok`);

--
-- Indexes for table `rak`
--
ALTER TABLE `rak`
  ADD PRIMARY KEY (`id_rak`),
  ADD UNIQUE KEY `kategori` (`no_rak`);

--
-- Indexes for table `satuan`
--
ALTER TABLE `satuan`
  ADD PRIMARY KEY (`id_satuan`),
  ADD UNIQUE KEY `satuan` (`satuan`);

--
-- Indexes for table `supplier`
--
ALTER TABLE `supplier`
  ADD PRIMARY KEY (`id_supplier`);

--
-- Indexes for table `tmp_barang`
--
ALTER TABLE `tmp_barang`
  ADD PRIMARY KEY (`id_tmp`),
  ADD UNIQUE KEY `id_barang` (`id_barang`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id_admin` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `barang`
--
ALTER TABLE `barang`
  MODIFY `id_barang` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  MODIFY `id_barang_keluar` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=54;

--
-- AUTO_INCREMENT for table `barang_keluar_rinci`
--
ALTER TABLE `barang_keluar_rinci`
  MODIFY `id_barang_keluar_rinci` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=109;

--
-- AUTO_INCREMENT for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  MODIFY `id_barang_masuk` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=102;

--
-- AUTO_INCREMENT for table `barang_masuk_rinci`
--
ALTER TABLE `barang_masuk_rinci`
  MODIFY `id_barang_masuk_rinci` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=124;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `id_customer` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `kartu_stok`
--
ALTER TABLE `kartu_stok`
  MODIFY `id_kartu_stok` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `rak`
--
ALTER TABLE `rak`
  MODIFY `id_rak` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `satuan`
--
ALTER TABLE `satuan`
  MODIFY `id_satuan` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `supplier`
--
ALTER TABLE `supplier`
  MODIFY `id_supplier` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tmp_barang`
--
ALTER TABLE `tmp_barang`
  MODIFY `id_tmp` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=36;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `barang`
--
ALTER TABLE `barang`
  ADD CONSTRAINT `fk_jenis` FOREIGN KEY (`no_rak`) REFERENCES `rak` (`no_rak`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_satuan` FOREIGN KEY (`satuan`) REFERENCES `satuan` (`satuan`) ON UPDATE CASCADE;

--
-- Constraints for table `barang_keluar`
--
ALTER TABLE `barang_keluar`
  ADD CONSTRAINT `fk_admin` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id_admin`) ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_distributor` FOREIGN KEY (`id_customer`) REFERENCES `customer` (`id_customer`) ON UPDATE CASCADE;

--
-- Constraints for table `barang_keluar_rinci`
--
ALTER TABLE `barang_keluar_rinci`
  ADD CONSTRAINT `fk_barang2` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_id_pengeluaran` FOREIGN KEY (`id_barang_keluar`) REFERENCES `barang_keluar` (`id_barang_keluar`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `barang_masuk`
--
ALTER TABLE `barang_masuk`
  ADD CONSTRAINT `fk_supplier` FOREIGN KEY (`id_supplier`) REFERENCES `supplier` (`id_supplier`) ON UPDATE CASCADE;

--
-- Constraints for table `barang_masuk_rinci`
--
ALTER TABLE `barang_masuk_rinci`
  ADD CONSTRAINT `fk_barang1` FOREIGN KEY (`id_barang`) REFERENCES `barang` (`id_barang`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `fk_barang_masuk` FOREIGN KEY (`id_barang_masuk`) REFERENCES `barang_masuk` (`id_barang_masuk`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
