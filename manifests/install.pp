# This class handle the installation of Goofys.
#
# Warning: If the version is not specified or set to "latest"
# the latest version of Goofys will be intalled once
# and won't be updated over time. Use latest for ephemeral servers.
#
# @summary Install goofys
#
# @param version
#   Allow to specify a version number like '0.19.0' or 'latest'
#
#
class goofys::install (
  String $goofys_version = 'latest',
) {

  $goofys_tmp = '/tmp/goofys_part'

  ensure_package({'wget' => { 'ensure' => 'present'}})

  if $goofys_version == 'latest' {
    $goofys_url = 'https://bit.ly/goofys-latest'
  } else {
    $goofys_url = "https://github.com/kahing/goofys/releases/download/v${goofys_version}/goofys"
  }

  file {
    # Create directory
    '/opt/goofys':
      ensure => 'directory',
      owner  => 'root',
      group  => 'root',
      mode   => '0700';

  } -> exec {
    # Download the binary
    # This Exec-Move tricks ensure the final target has been properly downloaded
    "download_goofys${goofys_version}":
      command => "/usr/bin/wget -q ${goofys_url} -O ${goofys_tmp} && /usr/bin/mv ${goofys_tmp} -f /opt/goofys/goofys_${goofys_version}",
      creates => "/opt/goofys/goofys_${goofys_version}";

  } ~> file {
    # Clean temporary files, set proper rights and activate the requested version
    $goofys_tmp:
      ensure => 'absent';

    "/opt/goofys/goofys_${goofys_version}":
      owner => 'root',
      group => 'root',
      mode  => '0700';

    '/opt/goofys/goofys':
      ensure => 'link',
      target => "/opt/goofys/goofys_${goofys_version}";
  }

}
