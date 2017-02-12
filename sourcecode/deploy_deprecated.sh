#!/bin/bash
supported_distros=(ubuntu arch debian centos)

usage=$(cat <<USAGE
Usage: $0 [options]

-h              brings up this manpage.

-d            distribution to be used, e.g. ${supported_distros[*]}
-n                    human readable name associated with the instance
-u                username of the machine
-p                password of the machine
-t               dry run without any deployment, used to test end configuration

USAGE
)

#"Usage: $0 -d distribution_name -n instance_name -u user" 
if [ $# -eq 0 ]; then
    echo $usage
    exit 0
fi

# if no args passed, exit and print usage
if [ $# -eq 0 ]; then
    echo $usage
    exit 1
fi



distribution=''
name=''

while getopts "d:hn:u:p:t" opt; do
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
        p)
            password=${OPTARG}
            ;;
        t)
            debug=1
            ;;
        *)
            echo $usage
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

if [ -z $user ] ; then
    echo "Mandatory user argument,"
    echo  "$usage"
    exit 0
fi

if [ -z $password ] ; then
    echo "Mandatory password argument,"
    echo  "$usage"
    exit 0
fi
##############

# now determin the actual vagrant instance we will use
# vagrant_distro="bento/ubuntu-16.04"
case $distribution in
    ubuntu)
        vagrant_distro="bento/ubuntu-16.04"
        ;;
esac

vagrantconfig=$(cat <<CONFIG
Vagrant.configure(2) do |config|\n
\tconfig.vm.box = "$vagrant_distro"\n
\tconfig.ssh.username = '$user'\n
\tconfig.ssh.password = '$password'\n
\tconfig.vm.provider "virtualbox" do |vb|\n
\t\tvb.customize ["modifyvm", :id, "--cableconnected1", "on"]\n
\tend\n
end
CONFIG
)

# if not debugging, execute the deployment scripts
if [ -z $debug ]; then
    user_machine_directory=`pwd`/userspace/$user/$name
    mkdir -p $user_machine_directory
    echo -e $vagrantconfig > $user_machine_directory/Vagrantfile
    cd $user_machine_directory
    vagrant up

fi
exit 0



