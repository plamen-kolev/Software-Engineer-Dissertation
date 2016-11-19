# Web Platform for Digital Deployment of Virtual Servers  
## About Allow people to easily deploy servers and monitor their performance through a web interface

## Aims
`High level description of the task`  
Give developers a platform for easy deployment, management and monitoring of virtual servers

## Objectives

provide a platform that makes it more convenient to manage the following from a web interface
1. Deploy a virtual machine of the user's choice quickly by filling minimal amount of details
2. Configure firewall settings
3. Allow console access ( Set up authentication credentials (SSH keys) for your instances )
4. Monitor disk/cpu usage of your virtual instances

---

# Features
1. Allow system administrators to easily deploy variety of Linux machines through a click/select interfaces (free distriutions)
 - arch, fedora, Ubuntu, centos
2. Allow system administrators to customize the install of the systems by allowing them to choose the packages they want ( apache, nginx, openssh server)
3. Provide stats for the deployed machines
 - uptime, cpu/gpu performance, network, temperature graphs.
 - Notify on crash/high traffic via email
 - Health monitoring
 - Allow system administrators to save their OS images as templates and share them on the website
- Allow importing and exporting of SSH public keys. Possible multiple auths
- Allow web console to manage the system

# Tasks
1. Research virtualbox deployment script automation
 - virtualbox api documentation
 - see sample and similar scripts and see capabilities and constrains

2. Create

# Keywords
Platform-as-a-Service
System as a service
Cloud computing
Virtualbox

# Technologies:
1. docker
2. kubernets
3. flynn

# Similar applications in the wild
digitalocean
amazon AWS
heroku
VULTR
Azure
Linode
VULTR
Openshift

# Books

# Research resources (Articles, Blogs, Guides)
|  Title | Type | Description | Reference |
|---|---|---|---|
| VIRTUALIZATION: CONCEPTS, APPLICATIONS, AND PERFORMANCE MODELING | Virtualisation | Will back up the claims I do about performance and usage | Menasc´e, D. A. (2005). VIRTUALIZATION: CONCEPTS, APPLICATIONS, AND PERFORMANCE MODELING. Retrieved November 19, 2016, from http://cs.gmu.edu/~menasce/papers/menasce-cmg05-virtualization.pdf |
|Creating REST APIs to Enable Our Connected World | API | To ensure great API for my project | CA Technologies (2005). Creating REST APIs to Enable Our Connected World. Retrieved November 19, 2016, from http://www.ca.com/content/dam/ca/us/files/white-paper/creating-rest-apis-to-enable-our-connected-world.pdf |
| Containers vs. Hypervisors: Choosing the Best Virtualization Technology | additional | Investicate doker vs virtualisation | BROCKMEIER J. (2010). Containers vs. Hypervisors: Choosing the Best Virtualization Technology. Retrieved November 19, 2016, from https://www.linux.com/news/containers-vs-hypervisors-choosing-best-virtualization-technology |
|Chef and HPE OneView Integration| UNIX integration | Chef integration guide | Hewlett Packard Enterprise (2016). Chef and HPE OneView Integration. Retrieved November 19, 2016 from http://hpe-composable-assets.mr-file-serve.com/prod/attachment/1/4AA6-1024ENW.pdf  |
| Chef bash guide | UNIX integration | | https://docs.chef.io/resource_bash.html  |
| Learn the Chef basics on Red Hat Enterprise Linux with Vagrant and VirtualBox | UNIX integration | Chef on RHEL with Vagrant and Virtualbox | Chef Software (2016). Learn the Chef basics on Red Hat Enterprise Linux with Vagrant and VirtualBox. Retrieved November 19, 2016 from https://learn.chef.io/tutorials/learn-the-basics/rhel/virtualbox/ |
| How to design your server virtualization infrastructure | Guide | Design basic guide | Techtarget. How to design your server virtualization infrastructure. (n.d.). Retrieved November 19, 2016 from http://searchservervirtualization.techtarget.com/essentialguide/How-to-design-your-server-virtualization-infrastructure |
| Five tips for building a VMware virtual infrastructure | Guide | tips | Davis D. (2013). Five tips for building a VMware virtual infrastructure. Retrieved November 19, 2016 from http://searchservervirtualization.techtarget.com/tip/Five-tips-for-building-a-VMware-virtual-infrastructure |
---------

https://www.techopedia.com/definition/30459/virtual-infrastructure
https://technet.microsoft.com/en-us/library/hh395484.aspx
https://forums.virtualbox.org/viewtopic.php?f=32&t=60069
https://turbonomic.com/free-tool-vhm-fiber-optic/?utm_source=facebook&utm_medium=social-display&utm_campaign=vhm-fiber-optic&utm_content=custom-master-desktop&utm_term=23842524981040521
http://www.oracle.com/technetwork/server-storage/vm/ovm3-demo-vbox-1680215.pdf
https://puppet.com/system/files/2016-07/puppet-wp-top-5-things-to-automate-with-puppet-right-now.pdf
http://cloudcomputing.ieee.org/images/files/publications/articles/TheStateofPublicInfrastructureasaServiceCloudSecurity.pdf
http://cloudcomputing.ieee.org/images/files/publications/articles/CC_Vulnerabilities.pdf
https://s3.amazonaws.com/ieeecs.cdn.cci/documents/07030253.pdf
http://www.reuters.com/article/us-intel-cloudera-idUSBREA2U0ME20140331
http://www.intel.com/content/dam/www/public/us/en/documents/guides/cloud-computing-virtualization-building-private-iaas-guide.pdf
https://www.quora.com/What-are-the-advantages-of-using-Linux-red-hat
Why use bash http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_01_02.html
Not relavant (docker contrast) https://www.hds.com/en-us/pdf/white-paper/kubernetes-on-hitachi-ucp-whitepaper.pdf

[VBoxHeadless - Running Virtual Machines with VirtualBox 5.1 on a headless Ubuntu 16.04 LTS Server](https://www.howtoforge.com/tutorial/running-virtual-machines-with-virtualbox-5.1-on-a-headless-ubuntu-16.04-lts-server/)

[VirtualBox extensions for MAAS](https://insights.ubuntu.com/2015/01/15/virtualbox-extensions-for-maas/)

[Comparing the Cloud: Put the Top Ten PaaS Vendors Head-to-Head for a Full-Stack Comparison](http://solutionsreview.com/cloud-platforms/comparing-the-cloud-put-the-top-10-paas-vendors-head-to-head-for-a-full-stack-comparison/)  

[2016 Gartner Magic Quadrant for Enterprise Application Platform-as-a-Service Worldwide](http://solutionsreview.com/cloud-platforms/gartner_magic_quadrant_enterprise_application_platform_as_a_service_worldwide/)

[Create your own Heroku on EC2 with Vagrant, Docker, and Dokku](http://blog.clearbit.com/ec2-heroku/)

[Make Your Own Heroku with Dokku and DigitalOcean](https://rogerstringer.com/2015/05/13/make-your-own-heroku/)

citation example
sunt in culpa qui officia deserunt mollit anim id est laborum (Menasc D. 2005).

---
# Needs further research

# Features
1. Multiple locations
2. Redundancy
3. Reincarnation/Healthmonitor

# Keywords
Puppet and Jenkins, Octopus Deploy, Chef, Kubernetes, docker, Flynn.

# Possible Reading materials
1. Architecting the Cloud: Design Decisions for Cloud Computing Service Models (SaaS, PaaS, and IaaS) `Michael J. Kavis`
 -  An expert guide to selecting the right cloud service model for your business, allowing for the delivery of computing and storage capacity to a diverse community of end-recipients. Helping you cut through all the haze, Architecting the Cloud is vendor neutral and guides you in making one of the most critical technology decisions that you will face: selecting the right cloud service model(s) based on a combination of both business and technology requirements.

2. Cloud Computing: Concepts, Technology & Architecture (The Prentice Hall Service Technology Series from Thomas Erl) `Thomas Erl`
 - Is for beginners looking to learn more about cloud computing and gives a broad over view of the topic. Erl teams up with cloud computing experts and researchers to break down cloud computing technologies and practices. The book also establishes business-centric models and metrics that allow for the financial assessment of cloud-based IT resources and their comparison to those hosted on traditional IT enterprise premises. It also provides templates and formulas for calculating SLA-related quality-of-service values and numerous explorations of the SaaS, PaaS and IaaS.

3. Cloud Computing Explained: Implementation Handbook for EnterprisesCloud Computing ExplainedCloud Computing Explained `John Rhoton`
 - describes the benefits and challenges of Cloud Computing and leads the reader through the process of assessing the suitability of a cloud-based approach for a given situation, calculating and justifying the investment that is required to transform the process or application, and then developing a solid design that considers the implementation as well as the ongoing operations and governance required to maintain the solution in a partially outsourced delivery model.


# Presentation notes
 1. What am I going to do
 2. How I am going to do it
 3. What will happen at the end
 4. Own it !
 5. The tools I am going to use
 6. Put a timeline

## General notes
1. Emphasise the important
2. Who why when where how

3. Things to tell: My project in details (80%), summary at the end 10% and questions 10%
4. Repetition and rehersal
5. Speak slowly (but fast when 'excited')
6. be passionated
7. interact with the audience(eye contact)

- clear topic
- clear and sensible plan
- relavant background materials
- smart Objectives
- dont waffle
