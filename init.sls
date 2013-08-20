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

datadog:
{% if pillar.get('use_remote_repo', false) %}
    {% if grains['os_family'] == 'Debian' %}
  pkgrepo.managed:
    - name: deb http://apt.datadoghq.com/ unstable main
    - file: /etc/apt/sources.list.d/datadog.list
    - keyserver: keyserver.ubuntu.com
    - keyid: C7A7DA52
    {% endif %}
{% endif %}

  pkg.installed:
    - name: python-openssl

  pkg.installed:
    - name: datadog-agent
{% if pillar.get('use_remote_repo', false) %}
    - require:
      - pkgrepo: datadog
{% endif %}
  service.running:
    - enable: True
    - name: datadog-agent
    - require:
      - pkg: datadog
    - watch:
      - file: /etc/dd-agent/datadog.conf

{% if pillar.get('redis', false) %}
python-redis:
  pkg.latest:
    - require-in:
      - service: datadog

/etc/dd/agent/conf.d/redisdb.yaml:
  file.managed:
    - source: salt://datadog/redisdb.yaml
    - template: jinja
    - require_in:
      - service: datadog
{% endif %}

{% if pillar.get('elasticsearch', false) %}
/etc/dd/agent/conf.d/elastic.yaml:
  file.managed:
    - source: salt://datadog/elastic.yaml
    - template: jinja
    - require_in:
      - service: datadog
{% endif %}

{% if 'dbhead0003' in grains['host'] %}
/etc/dd/agent/conf.d/mysql.yaml:
  file.managed:
    - source: salt://datadog/mysql.yaml
    - template: jinja
    - require_in:
      - service: datadog
{% endif %}

/etc/dd-agent/datadog.conf:
  file.managed:
    - template: jinja
    - source: salt://datadog/datadog.conf
