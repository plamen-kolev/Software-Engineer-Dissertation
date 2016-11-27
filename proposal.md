# Web Platform for Digital Deployment of Virtual Servers

# Motivation and rationale
## Abstract
In 2016 there are currently three billion people that have access to the internet. The website google.com handles between two and three billion search queries per day [[1]](#1). Achieving such task requires full usage of the available hardware . Part of Google's ability to scale and be performant is due to the emergence of cloud infrastructure.  The topic of the paper is tightly connected with one of the building blocks of cloud computing, which is virtualisation.

Techopedia defines the term virtualisation, as the ability of one piece of hardware to run multiple operating systems [[2]](#2).
Creating a platform that uses such technology enables an organisation to quickly set up any environment that can be used in a variety of cases.  Virtualisation can help solve the following problems.

## Problem
These days, it is a common place for a company to buy a computer per person which requires physical access to perform repairs and maintenance. Physical systems are also more difficult to manage due to their distributions. Another downside is hardware utilisation, a case where one machine uses maximum resources but another one is idle. The solution of this problem is virtualisation. With this technology, which is part of modern Intel processor chips, one server can run numerous operating systems concurrently. This helps with performance, as a virtual machine can be configured on the fly to use more or less resources. Another problem that my work will help to solve is .....

## Approach
My project aims at making the process of managing and creating virtual machines easy.
A system manager should be able to open a website, fill in a web form with enough information about the desired virtual machine, click a button and create an operating system. The user should also be able to gain credentials for that machine, as well as mark common packages for installation on it. The solution should also show performance statistics.


# Aim
Give developers a platform for easy deployment, management and monitoring of virtual servers
# Objectives
1. **Deploy a virtual machine of the user's choice quickly through shell scripts **  
The main feature of the solution is the deployment of the virtual machine instances. The following will be achieved by using Oracle's virtualisation documentation for Virtualbox and the shell scripting language and also the automation tool chef.

2. **Configure firewall settings**  
Will be achieved through the virutalisation technology's API. Adds required security layer to the instance.

3. **Allow console access and set up authentication credentials (SSH keys) for your instances**  

4. **Monitor disk/CPU usage of your virtual instances**  

5. **Install software from a predefined list**  

6. **Create a website with backend API that will manage and create virtual machine instances**  

7. **Connect backend API to web forms for web-based deployment**  

# Background

**Paper:** Menasc´e, D. A. (2005). VIRTUALIZATION: CONCEPTS, APPLICATIONS, AND PERFORMANCE MODELING  
**Description:**  The document provides brief description of virtualisation, explains performance modeling and gives a diagram overview of how it works.   
**Relevance:** Gives background and context for the work that I will be doing. Gives a good overview of the technology and its relevance to the project.

**Resource:**  Chef Software, Inc. (2014). bash guide  
**Description:** Description of syntax, actions properties and examples of how to use version control for deployment. It also contains examples.  
**Relevance:** Chef is an automation platform that will help me with deployment. The website's guides are a quick way to learn how to operate with the automation of the task.

**Paper:** Oracle Corporation (2016)  
**Description:** The paper gives context and intuition about Virtualbox terminology and ideas, provides getting started checklist and it shows step by step guide that cover the basics of virtual machine deployment.  
**Relevance: ** This white paper will be the essential source of information for achieving the aim of my dissertation. It also lays the building blocks that need to be automated and configured.

**Paper:** IEEE (2011). Understanding Cloud Computing Vulnerabilities  
**Description: ** IEEE document that provides an overview of cloud computing vulnerabilities. The paper discusses Web Applications, managing access and identity and authentication.  
**Relevance: ** Because the solution will include managing ports, installing applications and giving authentication tokens, it is important to be mindful of potential security threat vectors.

# Diagrammatic work plan

#	Explanation work plan

# References
1. http://www.internetlivestats.com/google-search-statistics/
2. https://www.techopedia.com/definition/719/virtualization

<style>
    @import url('https://fonts.googleapis.com/css?family=Open+Sans|Raleway');

    h1, h2{
        font-family: 'Raleway', sans-serif;
    }

    p, a, span, table{
        font-family: 'Open Sans', sans-serif !important;
    }

    .written_date{
        color:#999;
    }

    .writer_name{
        color:#0080ff;
    }

    .writer_email{
    }

    .writer_name, .writer_email, .written_date{
        margin-right:30px;
        font-size:1.2em;
    }
    p{
        font-size:11pt;
    }

    a{
        color:#0080ff !important;
    }

    a:hover{
        color:#444 !important;
    }

    @media print {
        h1{
            font-size:1.6em !important;
        }

        h2{
            font-size:1.4em !important;
        }

        p, span, td, table{
            font-size:0.8em;
            font-family: 'Open Sans', sans-serif !important;
        }

        .hide_in_print{
            display:none;
        }

        .page_break{
          page-break-before: always;
        }

        .h1,h2{
          border:none !important;
        }
    }

</style>
