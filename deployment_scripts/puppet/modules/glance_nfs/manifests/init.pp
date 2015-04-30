class glance_nfs (
$nfs_volume_for_glance,
$nfs_mount_point_glance,
){
  include glance_nfs::params

  # Install package and start services
  package { $glance_nfs::params::package_name:
    ensure => present,
  }

  package { $glance_nfs::params::required_packages:
    ensure => present,
  }

  service { $glance_nfs::params::service_name:
    ensure => running,
  }
  if ($glance_nfs::params::nfs_service_name) {
    service { $glance_nfs::params::nfs_service_name:
    ensure => running,
    }
  }

  # Configure Glance
  glance_api_config {
    'glance_store/default_store':  value => 'file';
    'glance_store/filesystem_store_datadir': value => "${nfs_mount_point_glance}/images";
	'glance_store/stores': value => 'file';
  }~> Service["$::glance_nfs::params::service_name"]
  
  glance_cache_config {
    'DEFAULT/filesystem_store_datadir': value => $nfs_mount_point_glance;
  }~> Service["$::glance_nfs::params::service_name"]

  # Create Mount Point
  exec{ "/bin/mkdir -p $nfs_mount_point_glance":
	unless => "/usr/bin/test -d $nfs_mount_point_glance",
	before => mount["$nfs_mount_point_glance"],
  }
  
  
  # Mount NFS Share 
  mount { "$nfs_mount_point_glance":
     atboot  => true,
     ensure  => mounted,
     device  => "$nfs_volume_for_glance",
     fstype  => "nfs",
     options => "vers=3",
  }

  # Apply permission on mount point
  exec{ "/bin/chown glance:glance $nfs_mount_point_glance":
  require => Mount["$nfs_mount_point_glance"],
  }
  exec{ "/bin/chmod 775 $nfs_mount_point_glance":
  require => Mount["$nfs_mount_point_glance"],
  }
  
  exec{ "/bin/mkdir -p ${$nfs_mount_point_glance}/images":
  unless => "/usr/bin/test -d ${$nfs_mount_point_glance}/images",
  require => Mount["$nfs_mount_point_glance"],
  }
  exec{ "/bin/chown glance:glance ${$nfs_mount_point_glance}/images":
  require => Exec["/bin/mkdir -p ${$nfs_mount_point_glance}/images"],
  }
  exec{ "/bin/chmod 775 ${$nfs_mount_point_glance}/images":
  require => Exec["/bin/mkdir -p ${$nfs_mount_point_glance}/images"],
  notify => Service["$::glance_nfs::params::service_name"],
  }

}
