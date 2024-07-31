#cloud-config

runcmd:
  - sudo route del default gw
  - sudo route add default gw 192.168.2.4 
  - sudo sleep 300
  - sudo apt-get update -y
