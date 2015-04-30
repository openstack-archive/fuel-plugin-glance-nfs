class glance_nfs::params {

  if $::osfamily == 'Debian' {
  
    $required_packages      = [ 'rpcbind', 'nfs-common', 'libevent-2.0',
                                'libgssglue1', 'libnfsidmap2', 'libtirpc1' ]
    $package_name           = 'glance-api'
    $service_name    		= 'glance-api'
	$nfs_service_name 		= undef

  } elsif($::osfamily == 'RedHat') {
  
    $required_packages      = [ 'rpcbind', 'nfs-utils', 'nfs-utils-lib',
                                'libevent', 'libtirpc', 'libgssglue' ]
    $package_name           = 'openstack-glance'
    $service_name    		= 'openstack-glance-api'
	$nfs_service_name 		= ['rpcbind']

  } else {
    fail("unsuported osfamily ${::osfamily}, currently Debian and Redhat are the only supported platforms")
  }
}
