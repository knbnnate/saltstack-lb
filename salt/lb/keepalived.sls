
lb.keepalived.installed:
  pkg.installed:
    - pkgs:
      - keepalived
      - psmisc

lb.keepalived.config:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://lb/templates/keepalived.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - require:
      - pkg: lb.keepalived.installed

lb.keepalived.service:
  service.running:
    - name: keepalived
    - enable: True
    - reload: True
    - watch:
      - file: /etc/keepalived/keepalived.conf
    - require:
      - file: /etc/keepalived/keepalived.conf
