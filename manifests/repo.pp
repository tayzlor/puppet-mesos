# == Class mesos::repo
#
# This class manages apt/yum repositories for Mesos packages
#
class mesos::repo() {

  case $::osfamily {
    'Debian': {
      if !defined(Class['apt']) {
        class { 'apt': }
      }

      $distro = downcase($::operatingsystem)

      apt::source { 'mesosphere':
        location    => "http://repos.mesosphere.io/${distro}",
        release     => $::lsbdistcodename,
        repos       => 'main',
        key         => 'E56151BF',
        key_server  => 'keyserver.ubuntu.com',
        include_src => false,
      }
    }
    'RedHat': {
      package { 'mesosphere-el-repo':
        ensure   => installed,
        provider => 'rpm',
        source   => "http://repos.mesosphere.io/el/${::operatingsystemmajrelease}/noarch/RPMS/mesosphere-el-repo-6-2.noarch.rpm"
      }
    }
    default: {
      fail("\"${module_name}\" provides no repository information for OSfamily \"${::osfamily}\"")
    }
  }
}
