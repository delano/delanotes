

# ----------------------------------------------------------- ROUTINES --------
# The routines block describes the repeatable processes for each machine group.
routines do
  

  cmdtest do
    
  end
  
  allshells do

    before_local do
      ls :l
    end
    before :root do
      #rm :f, :r, '/mnt/delanotes'
      df :h
      touch 'home-poop'
    end
    after :delano do
      ps 'aux'
    end
    after_local do
      uname :a
    end
  end
  
  startup do      
    adduser :delano
    authorize :delano  
    disks do
      create "/rudy/disk1"
    end
    after :delano do
      #ps 'aux'
    end
  end
  
  sysupdate do
    before :root do                  
      apt_get "update"               
      apt_get "install", "build-essential", "sqlite3", "libsqlite3-dev"
      apt_get "install", "ruby1.8-dev", "rubygems"
      apt_get "install", "apache2-prefork-dev", "libapr1-dev"
      gem_sources :a, "http://gems.github.com"
      gem_install 'rudy'
    end
  end
  
  installdeps do
    before :root do
      gem_install "rack", "thin", "sinatra-sinatra", "rails"
    end
  end
  
  installpassenger do
    gem_install "passenger"
    passenger_install
  end
  
  authorize do
    adduser :delano
    authorize :delano
  end
  
  #release stage.app.startup      # Copy the startup routine
  release do
    #changes :enforce
    git :delano do
      privatekey '/Users/delano/.ssh/git-delano_rsa'
      remote :origin
      path "/rudy/disk1/app/delanotes"
    end
    after :delano do
      start_delanotes
    end
  end
  
  rerelease do
    git :delano do
      remote :origin
      path "/rudy/disk1/app/delanotes"
    end
    after :delano do
      start_delanotes
    end
  end
  
  restart do
    after :delano do
      cd "/rudy/disk1/app/delanotes"
      start_delanotes
    end
  end
  
  # This routine will be executed when you run "rudy shutdown"
  shutdown do
    disks do
      # Rudy unmounts the EBS volume and deletes it. Careful! 
      destroy "/rudy/disk1"
    end
  end
  

end