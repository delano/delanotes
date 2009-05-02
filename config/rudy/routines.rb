

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
      ps 'aux'
    end
  end
  
  sysupdate do                       # $ rudy sysupdate
    before :root do                  
      apt_get "update"               
      apt_get "install", "build-essential", "sqlite3", "libsqlite3-dev"
      apt_get "install", "apache2-prefork-dev", "libapr1-dev"
      gem_install 'rudy'
      start_delanotes "/rudy/disk1/app/delanotes/bin/start.sh"
    end
  end
  
  installdeps do
    before :root do
      gem_install "passenger", "rack", "thin", "sinatra", "rails"
      passenger_install
    end
  end
  
  authorize do
    adduser :delano
    authorize :delano
  end
  
  #release stage.app.startup      # Copy the startup routine
  release do
    git :delano do
      privatekey '/Users/delano/.ssh/git-delano_rsa'
      remote :origin
      path "/rudy/disk1/app/delanotes"
    end
    after :root do
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