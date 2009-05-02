
commands do
  allow :gem_install, "/usr/bin/gem", "install", :V, "--no-rdoc", "--no-ri"
  allow :apt_get, "apt-get", :y, :q
  allow :passenger_install, "passenger-install-apache2-module", :a
  allow :apache2ctl
  allow :start_delanotes, "/rudy/disk1/app/delanotes/bin/start.sh"
end