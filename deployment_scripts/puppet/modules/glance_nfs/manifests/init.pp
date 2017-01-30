class glance_nfs {
  $override_file = '/etc/hiera/plugins/glance_nfs.yaml'
  $conf = hiera('glance_nfs')

  $store = gnfs_hiera_override($conf['nfs_mount_point_glance'])

  file { $override_file:
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    content => $store,
  }
}
