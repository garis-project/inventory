<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Login extends CI_Controller
{
    public function index()
    {
        view('login');
    }

    public function proses()
    {
        $this->load->model('M_crud');
        $post = $this->input->post();
        $password = $post['password'];
        $username = $post['username'];
        $show = $this->M_crud->getById('admin', array('username' => $username));
        // // die(print_r($show));
        $pass = "";
        foreach ($show as $s) {
            $pass = $s->password;
        }
        if (password_verify($password, $pass)) {

            $this->session->set_userdata('id_admin', $s->id_admin);
            $this->session->set_userdata('user_admin', $s->username);
            $this->session->set_userdata('nama_admin', $s->nama_admin);
            // echo $this->session->userdata('nama_user');
            redirect('home');
        } else {
            echo '<script>alert("Gagal Login"); window.history.back()</script>';
        }
    }
    public function logout()
    {
        $this->session->unset_userdata('nama_admin');
        redirect('/');
    }
}
