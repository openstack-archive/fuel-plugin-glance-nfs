notice('MODULAR: glance_nfs_backend.pp')

$nfs_backend = hiera('glance_nfs')
$mount_point = $nfs_backend['nfs_mount_point_glance']
$nfs_volume = $nfs_backend['nfs_volume_for_glance']
$nfs_options = $nfs_backend['nfs_mount_options']

service { 'glance-api':
  ensure => running,
}

package { 'nfs-common':
  ensure => present,
} ->
file { $mount_point :
          ensure => directory,
          mode   => 0775,
          owner  => 'glance',
          group  => 'glance',
} ->
# Mount NFS Share
mount { $mount_point :
   atboot  => true,
   ensure  => mounted,
   device  => $nfs_volume,
   fstype  => "nfs",
   options => $nfs_options,
} ->
file { "${mount_point}/images":
          ensure => directory,
          mode   => 0775,
          owner  => 'glance',
          group  => 'glance',
} ->
# Configure Glance
glance_api_config {
  'glance_store/default_store':  value => 'file';
  'glance_store/filesystem_store_datadir': value => "${mount_point}/images";
  'glance_store/stores': value => 'file';
}~> Service['glance-api']
