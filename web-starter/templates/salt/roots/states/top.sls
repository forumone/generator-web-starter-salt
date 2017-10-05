base:
  '*':
    - core
    - epel
    - jinja26
    - node
    - node.npm-install
    - ruby
#    Load mysql.client first to avoid getting mysql-libs from base repo
    - mysql.client
    - mysql
    - memcached.config
    - nginx.ng
    - varnish.repo
    - varnish
    - php.ng
    - php.ng.cli.ini
    - php.ng.fpm.pools
     - drush
<% if (platform == 'wordpress') { %>
    - wpcli
<% } %>
<% if (search != '') { %>
    - java
<% } %>
<% if (search == 'solr3') { %>
    - solr.v3
<% } %>
<% if (search == 'solr4') { %>
    - solr.v4
<% } %>
<% if (search == 'elasticsearch') { %>
    - elasticsearch
<% } %>
    - mailhog
    - core.cleanup
