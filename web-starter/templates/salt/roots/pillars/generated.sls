node:
  version: 6.11.3
  install_from_binary: True
  # Available versions can be found on nodejs.org/dist/
  # checksums are listed in the file SHASUMS256.txt in the respective version’s directory.
  # Package name to look for is nodejs-version-linux-x64.tar.gz
  checksum: 610705d45eb2846a9e10690678a078d9159e5f941487aca20c6f53b33104358c
  global_npm:
    - grunt-cli
    - bower

java: java-1.8.0-openjdk

elasticsearch:
# Tested versions: 5.3.0, 2.4.2
  version: 5.3.0
  config:
    http.cors.enabled: true
    network.bind_host: 0.0.0.0

mysql:
  mysql_version: <%= mysql_base %>
  database:
    - web
  user:
    web:
      password: <%= mysql_password %>
      host: '%'
      databases:
        - database: web
          grants: ['all privileges']

php:
  ng:
    php_version: <%= php_base %>

drush:
  version: '8.x'

<% if (webserver == 'apache') { %>
{% set doc_root = '<%= doc_root %>' %}
apache:
  lookup:
    mod_php5: <%= php_base %>
  sites:
    vagrant.byf1.io:
      enabled: True
      template_file: salt://apache/vhosts/standard.tmpl
      interface: '*'
      port: '8080'
      ServerAlias: '*'
      DocumentRoot: /vagrant/{{doc_root}}
      Rewrite: |
        RewriteRule ^index\.php$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.php [L]
      Directory:
        /vagrant/{{doc_root}}:
          AllowOverride: All
          Order: allow,deny
          Allow: from all
    vagrant.byf1.io-ssl:
      enabled: True
      template_file: salt://apache/vhosts/standard.tmpl
      interface: '*'
      port: '443'
      SSLCertificateFile: /etc/pki/tls/certs/vagrant.crt
      SSLCertificateKeyFile: /etc/pki/tls/private/vagrant.key
      ServerAlias: '*'
      DocumentRoot: /vagrant/{{doc_root}}
      Rewrite: |
        RewriteRule ^index\.php$ - [L]
        RewriteCond %{REQUEST_FILENAME} !-f
        RewriteCond %{REQUEST_FILENAME} !-d
        RewriteRule . /index.php [L]
      Directory:
        /vagrant/{{doc_root}}:
          AllowOverride: All
          Order: allow,deny
          Allow: from all
<% } %>
