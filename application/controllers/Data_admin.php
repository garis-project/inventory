<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Data_admin extends CI_Controller
{
    protected $_table = 'admin';

    public function __construct()
    {
        parent::__construct();
        $this->load->model('M_crud', 'm_crud');
    }
    public function index()
    {
        $this->data['rows'] =  $this->m_crud->getAll($this->_table);
        view('data_admin.table', $this->data);
    }
    public function create()
    {
        $post = $this->input->post();

        $this->form_validation->set_rules('username', 'Username', 'required');
        $this->form_validation->set_rules('password', 'Password', 'required');
        if ($this->form_validation->run()) {
            $data = [
                'username' => $post['username'], 'password' => password_hash($post['password'], PASSWORD_BCRYPT)

            ];
            $simpan = $this->m_crud->save($this->_table, $data);
            if ($simpan) {
                $this->session->set_flashdata('success', 'simpan');
                redirect('data_admin');
            } else {
                $this->session->set_flashdata('error', 'error');
                redirect('data_admin');
            }
        }
        view('data_admin.create');
    }
    public function edit()
    {
        $id_admin = $_GET['id'];
        $post = $this->input->post();
        $this->data['field'] = $this->m_crud->first($this->_table, ['id_admin' => $id_admin]);

        $this->form_validation->set_rules('username', 'Username', 'required');
        $this->form_validation->set_rules('password', 'Password', 'required');

        if ($this->form_validation->run()) {
            $data = [
                'username' => $post['username'],
                'password' => password_hash($post['password'],PASSWORD_BCRYPT),
            ];
            $update = $this->m_crud->update($this->_table, $data, ['id_admin' => $id_admin]);
            if ($update) {
                $this->session->set_flashdata('success', 'ubah');
                redirect('data_admin');
            } else {
                $this->session->set_flashdata('error', 'error');
                redirect('data_admin');
            }
        }
        view('data_admin.edit', $this->data);
    }
    public function delete()
    {
        $id_customer = $_GET['id'];
        $delete = $this->m_crud->delete($this->_table, ['id_customer' => $id_customer]);
        if ($delete) {
            $this->session->set_flashdata('success', 'hapus');
            redirect('customer');
        } else {
            $this->session->set_flashdata('error', 'error');
            redirect('customer');
        }
    }
}
