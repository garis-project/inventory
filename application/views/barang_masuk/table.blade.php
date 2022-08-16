@extends('layouts.app')
@section('content')
<div class="section-header">
	<h1>Data Barang Masuk</h1>
	@include('barang_masuk.breadcrumb')
</div>
<div class="section-body">
	<div class="row">
		<div class="col-md-12">
			<div class="card">
				<div class="card-header">
					<h4>Tabel Barang Masuk</h4>
					<a href="{{ base_url('barang_masuk/create') }}" class="btn btn-small btn-success"><i class="fa fa-plus"></i> Tambah</a>
				</div>
				<div class="card-body">
					@if (isset($_SESSION['success']) == 'success')
					<div class="alert alert-success" role="alert">Data berhasil di{{ $_SESSION['success'] }}</div>
					@elseif (isset($_SESSION['error']) == 'error')
					<div class="alert alert-danger" role="alert">Data gagal di{{ $_SESSION['error'] }}</div>
					@endif
					<table id="datatable" class="table table-striped dataTable dtr-column collapsed">
						<thead>
							<tr>
								<th>#</th>
								<th>Kwitansi Masuk</th>
								<th>Tgl Barang Masuk</th>
								<th>Supplier</th>
								<th>Total Barang Masuk</th>
								<th>Aksi</th>
							</tr>
						</thead>
						<tbody>
							@php
							$no=1;
							@endphp
							@foreach ($rows as $r)
							<tr>
								<td>{{ $no }}</td>
								<td>{{ $r->kwt_barang_masuk }}</td>
								<td>{{ $r->tgl_barang_masuk }}</td>
								<td>{{ $r->nama_supplier }}</td>
								<td>{{ $r->qty }}</td>
								<td width="200px">
									<a href="{{ base_url('barang_masuk/edit').'?id='.$r->id_barang_masuk }}" class="btn btn-small btn-warning"><i class="fa fa-edit"></i> Edit</a>
									<button data-delete="{{ $r->id_barang_masuk }}" class="btn-delete btn btn-small btn-danger"><i class="fa fa-trash"></i> Hapus</a>
								</td>
							</tr>
							@php
							$no++;
							@endphp
							@endforeach
						</tbody>
					</table>
				</div>
			</div>
		</div>
	</div>
</div>
@endsection
@push('scripts')
<script>
	$(document).ready(function() {
		$(".btn-delete").click(function() {
			var hapus = confirm('yakin data akan dihapus?');
			var id = $(this).attr('data-delete');
			if (hapus == true) {
				window.location.href = "{{ base_url('barang_masuk/delete')}}" + '?id=' + id;
			} else {
				return false;
			}
		});
	});

    var detailRows = [];

    $('#datatable tbody').on('click', 'tr td.details-control', function() {
        let tr = $(this).closest('tr');
        let row = table.row(tr);
        let idx = $.inArray(tr.attr('id'), detailRows);
        let btnPlus = '<button class="btn btn-transparent btn-xs"><i class="fas fa-eye"></i></button>';
        let btnMinus = '<button class="btn btn-transparent btn-xs"><i class="fas fa-eye-slash"></i></button>';
        if (row.child.isShown()) {
            tr.removeClass('details');
            row.child.hide();
            $(this).html(btnPlus);
            // Remove from the 'open' array
            detailRows.splice(idx, 1);
        } else {
            $(this).html(btnMinus);
            tr.addClass('details');
            getDetail(row.data()[1]).done(function(data) {

                let html = "";
                if (data.length > 0) {
                    html =
                        `<table style="width:80%!important" class="mx-auto">
							<thead class="text-center">
								<th width='50%'>ID Barang</th>
								<th width='50%'>Qty</th>
							</thead>
                       	<tbody>`;

                    let i = 1;
                    $.each(data, function(index, value) {
                        function result_icon(value) {
                            let badge = '';
                            switch (parseInt(value)) {
                                case 1:
                                    badge = `<i class="fas fa-hourglass-half text-warning"></i>`;
                                    break;
                                case 2:
                                    badge = `<i class="fas fa-times text-danger"></i>`;
                                    break;
                                case 3:
                                    badge = `<i class="fas fa-check text-success"></i>`;
                                    break;
                                case 4:
                                    badge = `<i class="fas fa-thumbs-up text-info"></i>`;
                                    break;
                            }

                            return badge
                        }

                        html +=
                            `<tr class="text-center">
                                <td class='text-left'>${value.id_barang}</td>
                                <td>${value.nama_barang}</td>
                             </tr>`;
                        i++;

                    });
                    html += `</tbody></table>`;
                } else {
                    html = `<p class'text-center'><i>There isn't data to be displayed</i></p>`;
                }
                row.child(html).show();
            });

            if (idx === -1) {
                detailRows.push(tr.attr('id'));
            }

        }
    });

    table.on('draw', function() {
        $.each(detailRows, function(i, id) {
            $('#' + id + ' td.details-control').trigger('click');
        });
    });

    function getDetail(id) {
        let process = $.ajax({
            url: "{{ base_url('barang_masuk/details')}} ",
            method: "post",
            dataType: "json",
            data: {
                id: id
            },
            success: function(data) {

            }
        });
        return process;
    }

</script>
@endpush