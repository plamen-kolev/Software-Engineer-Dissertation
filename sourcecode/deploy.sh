#!/bin/bash

usage="Usage: $0 -d distribution_name -n instance_name -u user" 
if [ $# -eq 0 ]; then
    echo $usage
    exit 0
fi

# if no args passed, exit and print usage
if [ $# -eq 0 ]; then
    echo $usage
    exit 1
fi

supported_distros=(ubuntu arch debian centos)

distribution=''
name=''

while getopts "d:hn:" opt; do
    case $opt in
        d)
            supported=''
            for var in "${supported_distros[@]}"
            do
                if [ $var = ${OPTARG} ] 
                then
                    supported=1
                fi
            done
            if [ -z $supported ]; then
                echo "${OPTARG} is unsupported. 
List of supported distributions: ${supported_distros[@]}
Exiting" 
                exit 1
            fi
            distribution=${OPTARG}
            ;;
        h)
            echo $usage >&2
            exit 0
            ;;
        n)
            name=${OPTARG}
            ;;
        u)
            user=${OPTARG}
            ;;
        *)
            echo "Nothing specified"
            exit 0
    esac
done
# do validity checking on arguments nessesary for deployiment,
# error out

if [ -z $name ] ; then
    echo "Mandatory name argument,"
    echo  "$usage"
    exit 0
fi

if [ -z $distribution ] ; then
    echo "Mandatory distribution argument,"
    echo  "$usage"
    exit 0
fi
##############

echo "I ran till completion"
exit 0

vagrantconfig = << CONFIG
Vagrant.configure(2) do |config|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.provider "virtualbox" do |vb|
        vb.customize ["modifyvm", :id, "--cableconnected1", "on"]
    end
end
CONFIG

