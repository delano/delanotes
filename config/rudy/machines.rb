# ---------------------------------------------------------  MACHINES  --------
# The machines block describes the "physical" characteristics
# of your environments. 
machines do
  
  users do
    # If you already have private keys for logging in to your EC2 instances
    # EC2 instances you can specify them here and Rudy will use these instead.
    # root :keypair => "/#{Rudy.sysinfo.home}/.rudy/root-private-key"
  end
  
  zone :"us-east-1b" do
    ami 'ami-235fba4a'    # Amazon Getting Started AMI (US)
  end
  zone :"eu-west-1b" do
    ami 'ami-e40f2790'    # Amazon Getting Started AMI (EU)
  end
  

  # We've defined an environment called "stage" with one role: "app". 
  # The configuration inside the env block is available to all its 
  # roles. The configuration inside the role blocks is available only
  # to machines in that specific role. 
  env :stage do
    ami "ami-5394733a"    # ec2onrails/ec2onrails-v0_9_9_1-i386.manifest.xml
    size 'm1.small'
    
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
    
    # Here are some examples of other roles. You can use these or
    # remove them and create your own.
    role :db do
    end
    
    role :analysis do
    end
    
    role :balancer do
    end
    
  end  

  # The routines section below contains calls to local and remote
  # scripts. The config contained in this block is made available
  # those scripts in the form of a yaml file. The file is called
  # rudy-config.yml. 
  config do
    dbmaster 'localhost'
    newparam 573114
  end
  
  
end


