# Web Platform for Digital Deployment of Virtual Servers  
## About
Allow people to easily deploy servers and monitor their performance through a web interface

## Aims
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
Virtualisation


# Technologies:
1. docker
2. kubernets
3. flynn
4. Chef
5. Virtualbox
6. bash
7. Web API

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
| VIRTUALIZATION: CONCEPTS, APPLICATIONS, AND PERFORMANCE MODELING | Background | Will back up the claims I do about performance and usage | Menasc´e, D. A. (2005). VIRTUALIZATION: CONCEPTS, APPLICATIONS, AND PERFORMANCE MODELING. Retrieved November 19, 2016, from http://cs.gmu.edu/~menasce/papers/menasce-cmg05-virtualization.pdf |
|Creating REST APIs to Enable Our Connected World | API | To ensure great API for my project | CA Technologies (2005). Creating REST APIs to Enable Our Connected World. Retrieved November 19, 2016, from http://www.ca.com/content/dam/ca/us/files/white-paper/creating-rest-apis-to-enable-our-connected-world.pdf |
| Containers vs. Hypervisors: Choosing the Best Virtualization Technology | Alternatives | Investicate doker vs virtualisation | BROCKMEIER J. (2010). Containers vs. Hypervisors: Choosing the Best Virtualization Technology. Retrieved November 19, 2016, from https://www.linux.com/news/containers-vs-hypervisors-choosing-best-virtualization-technology |
|Chef and HPE OneView Integration| UNIX integration | Chef integration guide | Hewlett Packard Enterprise (2016). Chef and HPE OneView Integration. Retrieved November 19, 2016 from http://hpe-composable-assets.mr-file-serve.com/prod/attachment/1/4AA6-1024ENW.pdf  |
| Chef bash guide | UNIX integration | | 4.	Chef Software, Inc. (2014). bash guide. Retrieved November 27, 2016, from https://docs.chef.io/resource_bash.html  |
| Learn the Chef basics on Red Hat Enterprise Linux with Vagrant and VirtualBox | UNIX integration | Chef on RHEL with Vagrant and Virtualbox | Chef Software (2016). Learn the Chef basics on Red Hat Enterprise Linux with Vagrant and VirtualBox. Retrieved November 19, 2016 from https://learn.chef.io/tutorials/learn-the-basics/rhel/virtualbox/ |
| How to design your server virtualization infrastructure | Background | Design basic guide | Techtarget. How to design your server virtualization infrastructure. (n.d.). Retrieved November 19, 2016 from http://searchservervirtualization.techtarget.com/essentialguide/How-to-design-your-server-virtualization-infrastructure |
| Five tips for building a VMware virtual infrastructure | Guide | tips | Davis D. (2013). Five tips for building a VMware virtual infrastructure. Retrieved November 19, 2016 from http://searchservervirtualization.techtarget.com/tip/Five-tips-for-building-a-VMware-virtual-infrastructure |
| Virtual Infrastructure | Definition | word definition | https://www.techopedia.com/definition/30459/virtual-infrastructure |
| Server consolidation | Definition | word definition | http://searchdatacenter.techtarget.com/definition/server-consolidation |
| Server sprawl | Definition | word definition | http://searchdatacenter.techtarget.com/definition/server-sprawl |
| Virtualization: Build an IT Lab for Virtual Machines | Guide |  | https://technet.microsoft.com/en-us/library/hh395484.aspx |
| Hyperbox - Manage your VirtualBox infrastructure! | Management || https://forums.virtualbox.org/viewtopic.php?f=32&t=60069 |
| Free Virtualization Monitoring. Unlimited. Forever. | Monitoring | | https://turbonomic.com/free-tool-vhm-fiber-optic/?utm_source=facebook&utm_medium=social-display&utm_campaign=vhm-fiber-optic&utm_content=custom-master-desktop&utm_term=23842524981040521 |
| Oracle VM 3: Building a Demo Environment using Oracle VM VirtualBox | Guide |  |  Oracle Corporation (2016) Building a Demo Environment using Oracle VM VirtualBox. Retrieved November 27, 2016, from  http://www.oracle.com/technetwork/server-storage/vm/ovm3-demo-vbox-1680215.pdf |
|The Top 5 Things to Automate with Puppet Right Now| Alternatives | | https://puppet.com/system/files/2016-07/puppet-wp-top-5-things-to-automate-with-puppet-right-now.pdf |
|The State of Public Infrastructure-as-a-Service Cloud Security| Concerns | | http://cloudcomputing.ieee.org/images/files/publications/articles/TheStateofPublicInfrastructureasaServiceCloudSecurity.pdf |
|Understanding Cloud Computing Vulnerabilities | Concerns | | 6.	IEEE (2011). Understanding Cloud Computing Vulnerabilities. Retrieved November 27, 2016, from http://cloudcomputing.ieee.org/images/files/publications/articles/CC_Vulnerabilities.pdf |
| Heterogeneous Cloud Computing: The Way Forward | Background | | https://s3.amazonaws.com/ieeecs.cdn.cci/documents/07030253.pdf |
| Server Consolidation | Background | | http://www.vmware.com/solutions/consolidation.html |
| Virtualization Overview | Background | | https://www.vmware.com/pdf/virtualization.pdf |
| VMware Infrastructure Architecture Overview | Background | | https://www.vmware.com/pdf/vi_architecture_wp.pdf |
| Intel invested $740 million to buy 18 percent of Cloudera | Background | | http://www.reuters.com/article/us-intel-cloudera-idUSBREA2U0ME20140331 |
| Virtualization and Cloud Computing | Background | | http://www.intel.com/content/dam/www/public/us/en/documents/guides/cloud-computing-virtualization-building-private-iaas-guide.pdf |
| What are the advantages of using Linux red hat? | UNIX integration | | https://www.quora.com/What-are-the-advantages-of-using-Linux-red-hat |
| Bash Guide for Beginners | UNIX integration || http://tldp.org/LDP/Bash-Beginners-Guide/html/sect_01_02.html |
|Kubernetes on Hitachi Unified Compute Platform (UCP) | Alternatives ||https://www.hds.com/en-us/pdf/white-paper/kubernetes-on-hitachi-ucp-whitepaper.pdf |
| VBoxHeadless - Running Virtual Machines with VirtualBox 5.1 on a headless Ubuntu 16.04 LTS Server | UNIX integration | | https://www.howtoforge.com/tutorial/running-virtual-machines-with-virtualbox-5.1-on-a-headless-ubuntu-16.04-lts-server/ |
| VirtualBox extensions for Metal as a Service | UNIX integration | | https://insights.ubuntu.com/2015/01/15/virtualbox-extensions-for-maas/ |
| 2016 Gartner Magic Quadrant for Enterprise Application Platform-as-a-Service Worldwide | Background | | https://www.gartner.com/technology/media-products/reprints/cybozu/277028.html?submissionGuid=607cc1a6-8d77-4532-9b4d-43fcb322a849 |
| Create your own Heroku on EC2 with Vagrant, Docker, and Dokku | Alternatives | |http://blog.clearbit.com/ec2-heroku/ |
| Make Your Own Heroku with Dokku and DigitalOcean | Alternatives | | https://rogerstringer.com/2015/05/13/make-your-own-heroku/ |
|What is server virtualization?| Background | | http://www.nec.com/en/global/solutions/servervirtualization/merit.html |
| How To: Port Forwarding on VirtualBox | Guide ||https://github.com/CenturyLinkLabs/panamax-ui/wiki/How-To%3A-Port-Forwarding-on-VirtualBox|
| Cloud Computing, Server Utilization, & the Environment | Background | | https://aws.amazon.com/blogs/aws/cloud-computing-server-utilization-the-environment/ |
| Building a Vagrant Box from Start to Finish | | | https://blog.engineyard.com/2014/building-a-vagrant-box |
| Virtualbox network configuration ||| https://www.virtualbox.org/manual/ch06.html |
| Chef, setup virtualmachine to manage ||| https://learn.chef.io/tutorials/learn-the-basics/ubuntu/virtualbox/set-up-a-machine-to-manage/ |
| Provision a New Linux Dev Environment in Nothing Flat with Puppet | | | https://www.linux.com/news/provision-new-Linux-dev-environment-nothing-flat-puppet |
| Shell provisioner for Test Kitchen | Testing vagrant| || https://www.morethanseven.net/2014/01/12/shell-provisioner-for-test-kitchen/ |
| Book about virtualisation | | |  http://ac.els-cdn.com.libproxy.ncl.ac.uk/B9781597495929000026/3-s2.0-B9781597495929000026-main.pdf?_tid=f2676874-04ef-11e7-b28f-00000aab0f6b&acdnat=1489081606_0a7d482eb21fa80e894a65d537b3736f |
| Intel® Virtualization Technology (Intel® VT) | | | |http://www.intel.la/content/www/xl/es/virtualization/virtualization-technology/intel-virtualization-technology.html
| IBM Virtualisation about hypervisors/supervisors | | | http://www.redbooks.ibm.com/redpapers/pdfs/redp4396.pdf |
http://resources.idgenterprise.com/original/AST-0088868_scalen-elastic-infrastructure-white-paper.pdf
http://www.isi.edu/~mkkang/papers/PPAC2011.pdf
>>> http://ieeexplore.ieee.org/document/1430629/ defines virtualisation
https://docs.oracle.com/cd/E20065_01/doc.30/e18549/oraclevm.htm#CACFJCFH

https://www.ncsc.gov.uk/guidance/virtualisation-security-guidance
# citation example
`sunt in culpa qui officia deserunt mollit anim id est laborum (Menasc D. 2005).`

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

# Project Proposal
Why is the project worth doing:
1. Rise of popularity of the cloud
2. Virtualisation removes incompatable hardware architecture bugs through the hypervisor
3. Low cost
4. Lowers barrier to entry
5. Server migrations are easy
6. Scalable
7. Utilisation
8. security concern
9. definition
10. Benefits of virtualisation
11. APIS

- why is the project worth doing
- what is the problem I am trying to solve
- what are the addressed needs
- specific need it addresses
- identify specific points where the proposed project will go beyond existing work
- why use restful api
- which server is best
- redundancy, alternatives and software candidates
