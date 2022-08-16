<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Home extends CI_Controller
{
	public function index()
	{
		$data['rows'] = $this->db->select('a.*,b.*,c.*')
			->from('barang_masuk a')
			->join('barang_masuk_rinci b', 'a.id_barang_masuk=b.id_barang_masuk', 'right')
			->join('barang c', 'b.id_barang=c.id_barang')
			->order_by('c.id_barang,a.tgl_barang_masuk')
			->get()->result();
		$data['harian'] = [
			'stok_masuk' =>
			$this->db->select('SUM(jml_masuk) AS total')
				->from('barang_masuk_rinci a')
				->join('barang_masuk b', 'b.id_barang_masuk=a.id_barang_masuk')
				->like('tgl_barang_masuk', date('Y-m-d'))->get()->row(),
			'stok_keluar' =>
			$this->db->select('SUM(jml_keluar) AS total')
				->from('barang_keluar_rinci a')
				->join('barang_keluar b', 'b.id_barang_keluar=a.id_barang_keluar')
				->like('tgl_barang_keluar', date('Y-m-d'))->get()->row()
		];
		view('home', $data);
	}
}
