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
class openshift_origin::plugins::frontend::haproxy_sni_proxy {
  package { 'rubygem-openshift-origin-frontend-haproxy-sni-proxy':
    require => Class['openshift_origin::install_method'],
  }

  service { 'openshift-sni-proxy':
    ensure     => true,
    enable     => true,
    hasrestart => true,
    hasstatus  => true,
    require    => [
      Package['openshift-origin-node-util'],
    ],
    provider   => $openshift_origin::params::os_init_provider,
  }
}
