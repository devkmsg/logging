name 'base'
default_source :supermarket
run_list 'chef-client::config', 'chef-client::default'
cookbook 'chef-client', '~> 10.0.5', :supermarket