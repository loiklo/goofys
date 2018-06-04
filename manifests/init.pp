# Install Goofys to and mount AWS s3 bucket
#
# @summary Install Goofys and manage s3 bucket mount point
#
# @param version
#   Version to install, please read the limitation part in the README
#   Accept:
#   - version number, like 0.19.0
#   - latest
#
# @param s3buckets
#   hash of buckets to mount, ie:
#     s3b001.bucket.demo.internal:
#       mount_point: /aws/bucket-s3b001
#       options: '--file-mode=0666,--profile=goofys-aws'
#       ensure: mounted
#     
class goofys (
  String  $version = 'latest',
  Hash    $s3buckets = {},
) {

  require awscredentials

  class {
    'goofys::install':
    goofys_version => $version;
  } -> class {
    'goofys::s3bucket':
    s3buckets => $s3buckets;
  }

}
