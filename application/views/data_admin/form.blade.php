<div class="row">
    <div class="col-md-6">
        @if (validation_errors() != false)
        <div class="alert alert-danger" role="alert">
            {!! validation_errors() !!}
        </div>
        @endif
        <div class="form-group">
            <label for="username">Username</label>
            <input type="text" name="username" id="username" value="{{ $field->username ?? ''}}" class="form-control {{ (form_error('username')) ? 'is-invalid' : '' }}">
            <div class="invalid-feedback">
                {!! (form_error('username')) ? form_error('username') : '' !!}
            </div>
            <label for="password">Password</label>
            <input type="password" name="password" id="password" value="{{ $field->password ?? ''}}" class="form-control {{ (form_error('password')) ? 'is-invalid' : '' }}">
            <div class="invalid-feedback">
                {!! (form_error('password')) ? form_error('tlp') : '' !!}
            </div>
        </div>
        <div class="form-group">
            <button type="submit" class="btn btn-primary">Simpan</button>
            <a href="{{ base_url('customer') }}" class="btn btn-danger">Kembali</a>
        </div>
    </div>
</div>