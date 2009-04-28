

# ----------------------------------------------------------- ROUTINES --------
# The routines block describes the repeatable processes for each machine group.
routines do
  
  env :stage do
    role :app do
      
      cmdtest do
        after :delano do
          ps 'aux'
          
        end
      end
      
      allshells do
        before_local do
          ls :l
        end
        before :root do
          #rm :f, :r, '/mnt/delanotes'
          df :h
          touch 'home-poop'
          #upload "/Users/delano/.ssh/git-delano_rsa", "~/.ssh"
        end
        after :delano do
          ps 'aux'
        end
        after_local do
          uname :a
        end
      end
      
      
      # This routine will be executed when you run "rudy startup"
      startup do      
        adduser :delano
        authorize :delano  
        disks do
          # Rudy creates an EBS volume for each instance, attaches
          # it, gives it a filesystem, and mounts it. 
          create "/rudy/disk1"
        end
      end
      
      # Copy the startup routine for release. Then we'll add additional
      # configuration for release. 
      #release stage.app.startup
      release do
        before :root do
          #rm :f, :r, '/mnt/delanotes'
          df :h
          touch 'home-poop'
          #upload "/Users/delano/.ssh/git-delano_rsa", "~/.ssh"
        end
        git :delano do
          privatekey '/Users/delano/.ssh/id_rsa'
          remote :heroku
          path "/rudy/disk1/app/delanotes"
        end
        after :delano do

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
  end
end