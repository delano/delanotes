
commands do
  allow :gem_install, "/usr/bin/gem", "install", :n, '/usr/local/bin', :y, :V, "--no-rdoc", "--no-ri"
  allow :gem_sources, "/usr/bin/gem", "sources"
  allow :thin, "/usr/local/bin/thin", :d, :R, './config.ru', :l, './thin.log', :P, './thin.pid', :p, "4566"
  allow :apt_get, "apt-get", :y, :q
  allow :passenger_install, "passenger-install-apache2-module", :a
  allow :apache2ctl
end