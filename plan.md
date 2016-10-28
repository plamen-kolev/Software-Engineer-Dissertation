# Project Plan

## Research phase
  - how is it done in the field + documenting my findings
  - find books, articles and online resources that will provide some insight into the problem I am trying to solve
  - define hardware requirements
  - investigate virtual machine deployment (using Virtualbox) using the shell language
    - get familiar with Virtualbox API
    - manual and automated deployment scripting API
  - write proof of concept shell deployment script
  - research Virtual Machine caching for instant deployment of Virtual Machines

  - (research) read UFW firewall manual page
  - research network/disk/CPU/temperature monitors
  - Research on web frameworks for rapid development with strong API support (convention over configuration frameworks)
  - write proof of concept script that will setup login credentials automatically:
    - generates SSH keys on the guest operating system
    - connects to a remote machine and copies the SSH keys
    - the remote machine connects to the guest machine with the SSH keys
  - create a list of necessary API calls that have to be exposed on the website's end


## Development and testing phase
1. write shell scripts for installing popular software on the virtual machine instances
  - write perl scripts that verify that the installed distributions are operational (you can ping them and remotely connect and execute commands on them)
2. Write shell scripts that install popular software (apache, mysql, text editors)
 - write tests that verify the integrity of the installed software on the machine using the Perl  scripting language
4. write firewall management shell script using UFW
5. test shell deployment script with multiple Linux distributions
6. install performance monitor software to every created virtual machine instance during post-install
7. Create design for the website
8. Create base of the website (user login, main page, etc)
9. Create API for the website that will allow it to interact with the deployment/monitoring and configuring shell scripts

10. Implement main features in the website
 - virtual machine creation/listing/deleting and management
 - on the management side, the user can
  - manage access keys
  - install additional software
  - monitor performance with graphs
