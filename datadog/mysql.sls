# Copyright 2012-2013 Hewlett-Packard Development Company, L.P.
# All Rights Reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#

include:
  - datadog

/etc/dd-agent/conf.d/mysql.yaml:
  file.managed:
    - source: salt://datadog/mysql.yaml
    - template: jinja
    - require_in:
      - service: datadog

mysql_check_link:
  file.symlink:
    - target: /usr/share/datadog/agent/checks.d/mysql.py
    - name: /etc/dd-agent/checks.d/mysql.py
    - require:
      - pkg.installed: datadog-agent
