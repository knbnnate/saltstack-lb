lb:
  haproxy:
    frontends:
      web_load_balancer: |
        bind *:80
        acl host_foo hdr(host) -m dom foo
        use_backend foo_cluster if host_foo
    backends:
      nac_cluster: |
        stats enable
        stats hide-version
        stats scope .
        stats uri /haproxy?stats
        stats realm Haproxy\ Statistics
        option httpchk GET /api/foo/1.0/bar
        http-check expect string baz
        balance leastconn{% for node in ['foo001','foo002'] %}
        server {{ node }} {{ salt['dnsutil.A']('{0}.bar.baz'.format(node))[0] }}:8080 check port 8080{% endfor %}
