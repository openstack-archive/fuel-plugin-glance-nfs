notice('MODULAR: install_nfs.pp')

$nfs_backend = hiera('glance_nfs')
$mount_point = $nfs_backend['nfs_mount_point_glance']
$nfs_volume = $nfs_backend['nfs_volume_for_glance']
$nfs_options = $nfs_backend['nfs_mount_options']

package { 'nfs-common':
  ensure => present,
  notify => Service['glance-api']
}

file { $mount_point :
          ensure => directory,
          mode   => 0775,
          owner  => 'glance',
          group  => 'glance',
} ->
mount { $mount_point :
   atboot  => true,
   ensure  => mounted,
   device  => $nfs_volume,
   fstype  => "nfs",
   options => $nfs_options,
   require => Package['nfs-common']
} ->
file { "${mount_point}/images":
          ensure => directory,
          mode   => 0775,
          owner  => 'glance',
          group  => 'glance',
          notify => Service['glance-api'],
}

service { 'glance-api':
    ensure     => running,
    name       => $::glance::params::api_service_name,
    require    => File["${mount_point}/images"],
}
