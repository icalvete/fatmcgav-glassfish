require 'spec_helper'

# Start to describe glassfish::create_instance define
describe 'glassfish::create_instance' do
  
  # Set the osfamily fact
  let(:facts) { {
    :osfamily                  => 'RedHat',
    :operatingsystemmajrelease => '6',
    :path                      => "/home/vagrant/vendor/bundler/ruby/1.8/bin:/usr/local/sbin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/var/lib/gems/1.8/bin/:/usr/local/bin:/root/.gem/ruby/2.1.0/bin:/usr/lib64/ruby/gems/1.9.1/gems/bundler-1.7.12/bin:/usr/lib64/ruby/gems/2.0.0/gems/bundler-1.7.12/bin",
    :systemd                   => false,
    :hostname                  => 'testhost'
  } }
  
  # Include Glassfish class 
  let (:pre_condition) { "include glassfish" }
  
  # Set-up default params values
  let :default_params do 
    {
      :cluster           => 'test',
      :instance_portbase => '28000'
    }
  end
  
  context 'with default params' do 
    # Set the title
    let(:title) { 'test' }
      
    # Set the params
    let(:params) { default_params }
    
    it do
      should contain_cluster_instance('test').with({
        'ensure'       => 'present',
        'user'         => 'glassfish',
        'asadminuser'  => 'admin',
        'passwordfile' => '/home/glassfish/asadmin.pass',
        'dasport'      => '4848',
        'nodename'     => 'testhost',
        'cluster'      => 'test',
        'portbase'     => '28000'
      })
    end
    
    it do
      should contain_glassfish__create_service('test').with({
        'mode'          => 'instance', 
        'instance_name' => 'test',
        'node_name'     => 'testhost',
        'service_name'  => 'glassfish_test'
      }).that_requires('Cluster_instance[test]')
    end
  end
  
  context 'with create_service => false' do 
    # Set the title
    let(:title) { 'test' }

    # Set the params
    let(:params) do 
      default_params.merge({
        :create_service => false
      })
    end
    
    it do
      should contain_cluster_instance('test').with({
        'ensure'       => 'present',
        'user'         => 'glassfish',
        'asadminuser'  => 'admin',
        'passwordfile' => '/home/glassfish/asadmin.pass',
        'dasport'      => '4848',
        'nodename'     => 'testhost',
        'cluster'      => 'test',
        'portbase'     => '28000'
      })
    end
    
    it do
      should_not contain_glassfish__create_service('test')
    end
  end
  
  context 'with a das_host provided' do 
    # Set the title
    let(:title) { 'test' }

    # Set the params
    let(:params) do 
      default_params.merge({
        :das_host => 'otherhost'
      })
    end
    
    it do
      should contain_cluster_instance('test').with({
        'ensure'       => 'present',
        'user'         => 'glassfish',
        'asadminuser'  => 'admin',
        'passwordfile' => '/home/glassfish/asadmin.pass',
        'dashost'      => 'otherhost',
        'dasport'      => '4848',
        'nodename'     => 'testhost',
        'cluster'      => 'test',
        'portbase'     => '28000'
      })
    end
    
    it do
      should contain_glassfish__create_service('test').with({
        'mode'          => 'instance', 
        'instance_name' => 'test',
        'node_name'     => 'testhost'
      }).that_requires('Cluster_instance[test]')
    end
  end
  
  context 'with a service_name specificed' do 
    # Set the title
    let(:title) { 'test' }

    # Set the params
    let(:params) do 
      default_params.merge({
        :service_name => 'glassfish_instance'
      })
    end
    
    it do
      should contain_cluster_instance('test').with({
        'ensure'       => 'present',
        'user'         => 'glassfish',
        'asadminuser'  => 'admin',
        'passwordfile' => '/home/glassfish/asadmin.pass',
        'dasport'      => '4848',
        'nodename'     => 'testhost',
        'cluster'      => 'test',
        'portbase'     => '28000'
      })
    end
    
    it do
      should contain_glassfish__create_service('test').with({
        'mode'          => 'instance', 
        'instance_name' => 'test',
        'node_name'     => 'testhost',  
        'service_name'  => 'glassfish_instance'
      }).that_requires('Cluster_instance[test]')
    end
  end
  
end
