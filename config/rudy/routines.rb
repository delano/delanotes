
# ----------------------------------------------------------- ROUTINES --------
# The routines block describes the repeatable processes for each machine group.
routines do
  
  env :stage do
    role :app do
      
      # This routine will be executed when you run "rudy startup"
      startup do        
        disks do
          # Rudy creates an EBS volume for each instance, attaches
          # it, gives it a filesystem, and mounts it. 
          #create "/rudy/disk1"
        end
        # You can execute a shell command on each instance after
        # it's created. This touch command will run as root.
        after :root => "touch /rudy/disk1/rudy-was-here"
      end
      
      # Copy the startup routine for release. Then we'll add additional
      # configuration for release. 
      release stage.app.startup
      release do
        #git do
          
        #end
      end
      
      # This routine will be executed when you run "rudy shutdown"
      shutdown do
        before :root => '/a/nonexistent/script'
        disks do
          # Rudy unmounts the EBS volume and deletes it. Careful! 
          #destroy "/rudy/disk1"
        end
      end
      
    end
  end
end