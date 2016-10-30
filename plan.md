# Project Plan

## Research phase
  - (20) creating a project plan
  - (5 hours) creating a presentation
  - (3) prepare for presentation
  - how is it done in the field
    - (8) research
    - (5) documenting my findings
  - Background resources  that will provide some insight into the problem I am trying to solve
    - (5) find books
    - (5)articles and online resources
  - (5) define hardware requirements
  - (2) document harware requirements
  - investigate virtual machine deployment (Virtualbox) using the shell language
    - (13) get familiar with Virtualbox API
  - (8) write proof of concept shell deployment script
  - (3) research Virtual Machine caching for instant deployment of Virtual Machines
  - (3) read UFW firewall manual page
  - (3) research network/disk/CPU/temperature monitors
  - (3) Research on web frameworks for rapid development with strong API support (convention over configuration frameworks)
  - write proof of concept script that will setup login credentials automatically:
    - (3) generates SSH keys on the guest operating system
    - (3) connects to a remote machine and copies the SSH keys
    - (3) the remote machine connects to the guest machine with the SSH keys
  - (3) create a list of necessary API calls that have to be exposed on the website's end

## (13) create poster

## Development and testing phase
1. write shell scripts for installing popular linux distros on the virtual machine host
    - (13) write perl scripts that tests and verifies that the installed distributions are  operational (you can ping them and remotely connect and execute commands on them)
    - (5) write up findings in the dissertation
2. Write shell scripts that install popular software (apache, mysql, text editors)
    - (10) write the actual script
    - (8) write tests that verify the integrity of the installed software on the machine using the Perl  scripting language
    - (5) write up findings in the dissertation
4. write firewall management shell script using UFW
    - (5) actual script writing
    - (10) test firewall configuration
    - (5) write up findings in the dissertation

5. Write scripts for managing credential information
    - (3) create new key with a name and password
    - (3) obtain key by name
    - (3) delete(destroy key)
    - (13) test functionality
    - (5) document behaviour
<!-- 6. test shell deployment script with multiple Linux distributions
    - (13) actual tests
    - (5) write up any findings in the dissertation -->
7. install performance monitor software to every created virtual machine instance during post-install
    - (8) installation
    - (10) create a manual test that verifies that the numbers are correct
    - (5) document findings
8. Create design for the website
    - (10) design work
    - (5) document design decisions
9. Create base of the website (user login, main page, etc.)
    - (5) Pick database technology, web technology, API
    - (10) implementing main features
     implementation and nessesary components
    - (10) write tests that verify integrity of the base
    - (5) document findings
10. Create API for the website that will allow it to interact with the deployment/monitoring and configuring shell scripts
    - (13) write api
    - (18) test API
    - (5) document findings

11. Implement main features in the website
 - virtual machine creation/listing/deleting and management
    - (13) creation interface
    - (5) listing interface
    - (5) deleting interface
    - test expected behaviour
        - (15) creation
        - (7) listing interface
        - (7) deleting interface
    - (7) document findings
 - on the management side, the website should allow
  - (5) manage access keys (using the script defined in  point 5)
  - (5) install additional software
  - (5) monitor performance with graphs
  - (20) The above behaviour must be tested and marked down in the dissertation paper

  400 hours
