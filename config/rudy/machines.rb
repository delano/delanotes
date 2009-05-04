
machines do

  env :stage do
    ami "ami-e348af8a"  # Debian 5.0 32-bit, Alestic
    size 'm1.small'
    
    role :app do
      positions 1
      addresses '174.129.213.130', '174.129.214.40'
      
      disks do
        path "/rudy/disk1" do
          size 2
          device "/dev/sdr"
        end
      end
    end

  end  
  
end


