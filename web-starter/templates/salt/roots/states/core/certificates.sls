default_vagrant_ssl_cert:
  file.managed:
    - name: /etc/pki/tls/certs/vagrant.crt
    - makedirs: True
    - contents_pillar: nginx:ng:certificates:vagrant:public_cert

default_vagrant_ssl_key:
  file.managed:
    - name: /etc/pki/tls/private/vagrant.key
    - mode: 600
    - makedirs: True
    - contents_pillar: nginx:ng:certificates:vagrant:private_key
