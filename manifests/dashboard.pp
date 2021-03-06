#
# Copyright (C) 2018 Binero
#
# Author: Tobias Urdin <tobias.urdin@binero.se>
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License. You may obtain
# a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
# License for the specific language governing permissions and limitations
# under the License.
#
# == Define: horizon::dashboard
#
# This resource installs additional horizon dashboard which is not
# shipped with the horizon packages, but as additional packages.
#
# == Example:
#
# This will install the correct heat-dashboard package for your deployment.
# horizon::dashboard { 'heat': }
#
define horizon::dashboard {

  $dashboard = downcase($name)

  case $::osfamily {
    'Debian': {
        $dashboard_package_name = $::os_package_type ? {
          'debian' => "python3-${dashboard}-dashboard",
          default  => "python-${dashboard}-dashboard"
        }
    }
    'RedHat': {
      $dashboard_package_name = "openstack-${dashboard}-ui"
    }
    default: {
      fail("Unsupported OS family: ${::osfamily}")
    }
  }

  ensure_packages($dashboard_package_name, {
    'ensure'  => present,
    'tag'     => ['horizon-dashboard-package']
  })
}
