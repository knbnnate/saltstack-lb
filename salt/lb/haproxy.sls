
lb.haproxy.installed:
  pkg.installed:
    - pkgs:
      - haproxy

lb.haproxy.config:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://lb/templates/haproxy.cfg
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: lb.haproxy.installed

lb.haproxy.logging:
  file.managed:
    - name: /etc/rsyslog.d/haproxy.conf
    - contents: |
        # HAproxy local socket
        $AddUnixListenSocket /var/lib/haproxy/dev/log
        :programname, contains, "haproxy" /var/log/haproxy.log
        & stop

lb.haproxy.logfile:
  file.touch:
    - name: /var/log/haproxy.log

lb.haproxy.logsocket:
  file.touch:
    - name: /var/lib/haproxy/dev/log
    - makedirs: True

lb.haproxy.service:
  service.running:
    - name: haproxy
    - enable: True
    - reload: True
    - watch:
      - file: /etc/haproxy/haproxy.cfg
    - require:
      - file: /etc/haproxy/haproxy.cfg

lb.haproxy.rsyslog:
  service.running:
    - name: rsyslog
    - enable: True
    - reload: True
    - watch:
      - file: /etc/rsyslog.d/haproxy.conf
    - require:
      - file: /var/log/haproxy.log
      - file: /var/lib/haproxy/dev/log
