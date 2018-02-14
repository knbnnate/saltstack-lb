lb:
  keepalived:
    state: MASTER
    priority: 101
    router_id: 51
    virtual_ip: {{ salt['dnsutil.A']('foo.bar.baz')[0] }}
