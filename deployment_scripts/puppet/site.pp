$fuel_settings = parseyaml(file('/etc/astute.yaml'))
class { 'glance_nfs':
    nfs_volume_for_glance          		=> $fuel_settings['glance_nfs']['nfs_volume_for_glance'],
    nfs_mount_point_glance          	=> $fuel_settings['glance_nfs']['nfs_mount_point_glance'],
}