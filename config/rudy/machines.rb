# ---------------------------------------------------------  MACHINES  --------
# The machines block describes the "physical" characteristics
# of your environments. 
machines do
  
  users do
    # If you already have private keys for logging in to your EC2 instances
    # EC2 instances you can specify them here and Rudy will use these instead.
    # root :keypair => "/#{Rudy.sysinfo.home}/.rudy/root-private-key"
  end
  
  # We've defined an environment called "stage" with one role: "app". 
  # The configuration inside the env block is available to all its 
  # roles. The configuration inside the role blocks is available only
  # to machines in that specific role. 
  env :stage do
    ami "ami-e348af8a"   # Debian 5.0 32-bit, Alestic
    size 'm1.small'
    
    # see: http://www.cubiclemuses.com/cm/articles/2009/04/09/rails-passenger-open-solaris-ec2/
    role :solaris do
      ami "ami-c7cf28ae"
      disks do
        path "/rudy/disk1" do
          size 2
          device 3
        end
      end
    end
    
    role :app do
      positions 1
      #addresses '11.22.33.44', '55.66.77.88'
    
      # You can define disks for the stage-app machines. Rudy uses 
      # this configuration when it executes a routine (see below).
      disks do
        path "/rudy/disk1" do
          size 2
          device "/dev/sdr"
        end
      end
    
    end

  end  
  
end


