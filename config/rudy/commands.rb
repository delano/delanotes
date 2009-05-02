
commands do
  allow :gem_install, "/usr/bin/gem", "install", :y, :V, "--no-rdoc", "--no-ri"
  allow :gem_sources, "/usr/bin/gem", "sources"
  allow :apt_get, "apt-get", :y, :q
  allow :passenger_install, "passenger-install-apache2-module", :a
  allow :apache2ctl
  allow :start_delanotes, "/rudy/disk1/app/delanotes/bin/start.sh"
end