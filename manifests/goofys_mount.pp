# This defined type is a wrapper to the ressource mount that enforce the proper value for Goofys
#
# @summary Handle a Goofys mountpoint
#
# @example
#   goofys::goofys_mount { '/goofys': bucket_name => 'data001.example.org' }
#
# @param ensure
#   ensure state of the ressources
#   - mounted: add to fstab and for the ressource to be mounted
#   - unmounted: add to fstab but force the ressource to be unmounted
#   - absent: force umount and remove the fstab entry
#   - defined/present: add the fstab entry only
#
# @param bucket_name
#   The bucket name to mount
#
# @param options
#   A single string containing options for the mount, as they would appear in fstab.
#
# @param mount_point
#   Path to mount the bucket
#   This param is can be set through the ressource title
#   
define goofys::goofys_mount(
  String $ensure,
  String $bucket_name,
  String $options,
  String $mount_point = $title
) {

  mount { $mount_point:
    ensure   => $ensure,
    device   => "/opt/goofys/goofys#${bucket_name}",
    options  => $options,
    # Fixed params for Goofys
    fstype   => 'fuse',
    remounts => false,
    dump     => '0',
    pass     => '0',
  }

}
