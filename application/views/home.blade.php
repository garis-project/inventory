@extends('layouts.app')
@section('content')
<br>
<div class="section-header">

	<h1>Dashboard </h1>
</div>
<style>
	.white {
		color: #fff !important;
	}
</style>
<div class="row">
	<strong>Rekap Data Tanggal {{ date('d F Y') }} (Hari Ini)</strong>
</div>
<div class="row">
	<div class="col-md-6">
		<div class="card">
			<div class="card-body">
				Total Barang Masuk <span class="text-info float-right" style="font-size: 3rem">{{ $harian['stok_masuk']->total }}</span>
			</div>
		</div>
	</div>
	<div class="col-md-6">
		<div class="card">
			<div class="card-body">
				Total Barang Keluar <span class="text-danger float-right" style="font-size: 3rem">{{ $harian['stok_keluar']->total }}</span>
			</div>
		</div>
	</div>
</div>
<div class="row">

	<div class="col-md-12">
		<div class="card">
			<div class="card-header">
				<h5 class="card-title">Histori Stok Barang</h5>
			</div>
			<div class="card-body">
				<table id="datatable" class="table table-striped dataTable dtr-column collapsed">
					<thead>

						<tr>
							<th>Tgl Masuk</th>
							<th>Nama Barang</th>
							<th>Satuan</th>
							<th>Stok Awal</th>
							<th>Histori Stok</th>
							<th>Jumlah Stok</th>
						</tr>
					</thead>
					<tbody>
						@foreach ($rows as $item)
						<tr>
							<td>{{ date('Y-m-d H:i:s',strtotime($item->tgl_barang_masuk)) }}</td>
							<td>{{ $item->nama_barang }}</td>
							<td>{{ $item->satuan }}</td>
							<td>{{ $item->jml_masuk }}</td>
							<td>{{ $item->stok_masuk }}</td>
							<td>{{ $item->stok}}</td>
						</tr>
						@endforeach
					</tbody>
				</table>


			</div>
		</div>
	</div>
</div>
</div>
@endsection