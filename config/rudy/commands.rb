
commands do
  allow :apt_get, "apt-get", :y, :q
  allow :gem_install, "/usr/bin/gem", "install", :n, '/usr/bin', :y, :V, "--no-rdoc", "--no-ri"
  allow :gem_sources, "/usr/bin/gem", "sources"
  allow :thin, "/usr/bin/thin", :d, :R, './config.ru', :l, './thin.log', :P, './thin.pid', :p, '80'
end