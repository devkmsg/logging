name 'base'
default_source :supermarket
run_list 'chef-client::config', 'chef-client::default', 'policy-fetcher::default'
cookbook 'chef-client', '~> 10.0.5', :supermarket
cookbook 'policy-fetcher', path: '../../cookbooks/policy-fetcher'