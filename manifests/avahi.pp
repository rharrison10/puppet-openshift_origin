# Copyright 2013 Mojo Lingo LLC.
# Modifications by Red Hat, Inc.
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
class openshift_origin::avahi {
  include openshift_origin::params

  # TODO: Farm work out to Avahi module

  package { ['avahi-cname-manager']:
    ensure  => present,
    require => Class['openshift_origin::install_method'],
  }

  if !($::domain =~ /.local$/) {
    fail 'For avahi to be configure properly this machines domain name must end with .local'
  }

  file { 'avahi config':
    path    => '/etc/avahi/avahi-daemon.conf',
    content => template('openshift_origin/avahi/avahi-daemon.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['avahi-cname-manager'],
  }

  file { '/etc/avahi/cname-manager.conf':
    path    => '/etc/avahi/cname-manager.conf',
    content => template('openshift_origin/avahi/cname-manager.conf.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Package['avahi-cname-manager'],
  }

  service { 'avahi-cname-manager':
    ensure    => running,
    subscribe => File['/etc/avahi/cname-manager.conf'],
    enable    => true,
    require   => Package['avahi-cname-manager'],
  }

  service { 'avahi-daemon':
    ensure    => running,
    subscribe => File['avahi config'],
    enable    => true,
    require   => Package['avahi-cname-manager'],
  }
}
