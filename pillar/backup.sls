lb:
  keepalived:
    state: BACKUP
    priority: 100
    router_id: 51
    virtual_ip: {{ salt['dnsutil.A']('foo.bar.baz')[0] }}
