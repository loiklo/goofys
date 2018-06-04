# Call goofys_mount type for all ressrouces declared in the hash
#
# @summary Call goofys_mount type for all ressrouces declared in the hash
#
# @param s3buckets
#   hash of buckets to mount, ie:
#     s3b001.bucket.demo.internal:
#       mount_point: /aws/bucket-s3b001
#       options: '--file-mode=0666,--profile=goofys-aws'
#       ensure: mounted
#
class goofys::s3bucket (

  Hash $s3buckets = undef,

) {

  # Retrieve the s3bucket to mount
  #$s3buckets = lookup('goofys::s3buckets', undef, undef, '')
  $s3buckets.each | String $s3bucket, Hash $s3bucket_hash | {

    # Create the mount point
    exec { "/usr/bin/mkdir -p ${s3bucket_hash['mount_point']}":
      unless => ["/usr/bin/test -d ${s3bucket_hash['mount_point']}"]
    }

    # Default behavior if not specified: fstab + mount
    if has_key($s3bucket_hash, 'ensure') {
      $_ensure = $s3bucket_hash['ensure']
    } else {
      $_ensure = 'mounted'
    }

    # Append specified options, if any
    if has_key($s3bucket_hash, 'options') {
      $_options = "_netdev,allow_other,${s3bucket_hash['options']}"
    } else {
      $_options = '_netdev,allow_other'
    }

    # Mount the s3bucket
    goofys::goofys_mount {
      $s3bucket_hash['mount_point']:
      ensure      => $_ensure,
      bucket_name => $s3bucket,
      options     => $_options,
    }

  }

}
