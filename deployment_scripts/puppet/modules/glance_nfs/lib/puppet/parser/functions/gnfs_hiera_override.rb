require 'yaml'

module Puppet::Parser::Functions
  newfunction(:gnfs_hiera_override, :type => :rvalue, :arity => 1) do |args|
    mount_point = args[0]

    override = {}
    override['configuration'] = {
      'glance_api' => {
        'glance_store/default_store' => {'value' => 'file'},
        'glance_store/filesystem_store_datadir' => {'value' => "#{mount_point}/images"},
        'glance_store/stores' => {'value' => 'file'}
      }
    }

    override.to_yaml
  end
end
