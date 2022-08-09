# Panel de precios medicamentos

![Shape1](RackMultipart20220809-1-es8cmr_html_6c130e2361d54574.gif)

# **Software Technical Documentation**

# **For**

# **Project**

**Version 1.0**

**Revision History**

| Name | Date | Reason for Changes | Version |
| --- | --- | --- | --- |
|
 |
 |
 |
 |
|
 |
 |
 |
 |

# Contents

[1.Installation Guide 4](#_Toc110466646)

[How to set up 4](#_Toc110466647)

[1. Server 4](#_Toc110466648)

[Developing 6](#_Toc110466649)

[Built With 6](#_Toc110466650)

[1.1Document Conventions 6](#_Toc110466651)

[1.2Intended Audience and Reading Suggestions 6](#_Toc110466652)

[1.3Hardware Interfaces 7](#_Toc110466653)

[1. Equipment 7](#_Toc110466654)

[2. Supported operating systems 7](#_Toc110466655)

[3. Processor requirement 7](#_Toc110466656)

[1.4Software Interfaces 7](#_Toc110466657)

[1. Test Cases 10](#_Toc110466658)

[2.Other Nonfunctional Requirements 15](#_Toc110466659)

[2.1Safety Requirements 15](#_Toc110466660)

[2.2Security Requirements 15](#_Toc110466661)

[2.3Business Rules 15](#_Toc110466662)

[3.Appendix A: Glossary 16](#_Toc110466663)

1.
# Installation Guide

How to set up

1. Server

1. **Steps to setup development env**

- Clone project from github https://github.com/EL-BID/Panel-de-precios-medicamentos
- Install Rstudio & composer
- make sure that you have postgresql database installed
- copy .env.dev to .env and change the DB\_XXX environment variable to your local postgresql server info
- run command:

composer.phar install

- To init database, run command at folders database/migrations and database/seeds:

migrate:fresh –db.

- access the page for toolkit: https://github.com/EL-BID/Panel-de-precios-medicamentos


1. Steps to deploy on

Install the  **R-base package**  using the following code

sudo apt-get update

sudo apt-get install r-base

Download and install the  **gdebi**  package using the following commands

sudo apt install gdebi

Use the following commands to install the .deb package

sudo gdebi /path/to/the/file/.deb

Updated R studio

Updated Sql version

1. **Steps to setup development env**

- install
- clone project from [b](https://github.com/orite-dev/kepp-v2-web)https://github.com/EL-BID/Panel-de-precios-medicamentos
- copy .env.development to .env
- Run the following commands in the project root folder:

yarn install

yarn start

\*NOTE: the project is based on .R execution resources required.

1. **Steps to deploy on system**

- copy .env.production to .env
- Run the following commands:

yarn install

yarn build

yarn deploy

1. **Clone and Install**

Clone the repo:

https://github.com/EL-BID/Panel-de-precios-medicamentos

Move to the appropriate directory:

Install dependencies:

npm install

## Developing

### Built With

R Scripts with Sql

  1.
## Document Conventions

| Terms / Abbreviations | Description |
| --- | --- |
| UC | Use cases |
| RUP | Rational Unified Process |
| Platform | Based on. R |

  1.
## Intended Audience and Reading Suggestions

The intended readers of this document are the system analyst & designer, project developer, developer, project panel, and system owners. The system analyst & designer can use this document for his cross reference to verify his future work. Project developers can use this document for traceability of the functions implemented. Project panel can use this document to verify the quantity and quality of the end product, finally this document can help bridge-up the gaps between the project stakeholders i.e. analysts, designers, developers, system users and the system owners to help them understand what functionalities this platform will have and what not

- Advanced/Professional Users, such as engineers (Developers) or researchers, who want to use for more demanding graph analysis.
- Development Consultants – Experienced professionals within the app and web development market. This document can be used to review the components of the platform and possible changes are needed or to provide an overview of the user experience.
- App Developers – This document will primarily be used to instruct the development team on how the Platform should be built on the mediums.
- Programmers who are interested in working on the project by further developing it or for maintaining the platform.
- For Users who want to setup.

  1.
## Hardware Interfaces

| No | Hardware | Description |
| --- | --- | --- |
| 1 | System | Server Based System |
| 2 | OS | (All Supported OS) |
| 3 | Memory | 2 GB (optional) |
| 4 | RAM | 4.0 GB (optional) |

1.
### Equipment

- An Internet connection – Wi-Fi (a/g/n/ac) or wireless (3G or 4G/LTE)
- For Mobile Permissions for upload.


1.
### Supported operating systems

- Windows, Mac and linux

1.
### Processor requirement

- Any single core processor or better

  1.
## Software Interfaces

![](RackMultipart20220809-1-es8cmr_html_28ea93a1b8f8b304.gif)

![](RackMultipart20220809-1-es8cmr_html_3ce6ed89d80e2215.gif)

1.
### Test Cases

**1.0 Environment**

| **Test Script No** | **1.1** |
| --- | --- |
| **Title** | **Env** |
| **Test Script** | Key-in below url in browser URL text field and login.

 |
| **Expected Result** |
 |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape5](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

| **Test Script No** | **1.2** |
| --- | --- |
| **Title** | **Env** |
| **Test Script** | Login with the email and password |
| **Expected Result** | Dashboard page will be displayed. |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape6](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

| **Test Script No** | **1.3** |
| --- | --- |
| **Title** | **Env** |
| **Test Script** | Data |
| **Expected Result** | Data tables.

 |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape7](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

| **Test Script No** | **1.4** |
| --- | --- |
| **Title** | **Env** |
| **Test Script** | Navigate to data |
| **Expected Result** | Data attributes

 |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape8](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

**Features**

| **Test Script No** | **1.5** |
| --- | --- |
| **Title** | **features** |
| **Test Script** | Navigate to User Page |
| **Expected Result** | Page to manage all the users including details.

 |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape9](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

  1. **Running state**

| **Test Script No** | **2.1** |
| --- | --- |
| **Title** | **Running state** |
| **Test Script** | Install Running state:
OS
 |
| **Expected Result** | displayed upon starting


 |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape10](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

| **Test Script No** | **2.2** |
| --- | --- |
| **Title** | **Running state** |
| **Test Script** | Access |
| **Expected Result** | Control env. |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape11](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |

| **Dependencies** | N/A |
| --- | --- |
| **Priority** | High |

**4.0 Grouping & Category**

| **Test Script No** | **4.1** |
| --- | --- |
| **Title** | **Grouping & Category** |
| **Test Script** | Grouping and category data. |
| **Expected Result** | Script execution |
| **Meets**** Specification **** Y - Pass ****N - Fail** | ![Shape12](RackMultipart20220809-1-es8cmr_html_6075d6e719770650.gif) **Y**
**N** |
| **Remarks** |
 |
| **Restrictions and Risk** | Requires an active env |
| **Dependencies** | N/A |
| **Priority** | High |

1.
# User interfaces

## Login

To login required user name, Select from main url.

System Show login tab:

![Shape13](RackMultipart20220809-1-es8cmr_html_5b5e6b312af0c09e.gif) ![Shape14](RackMultipart20220809-1-es8cmr_html_1c9b0ae2723f1410.gif) ![Shape15](RackMultipart20220809-1-es8cmr_html_8592d63fd9794145.gif)

Login-Button

 ![](RackMultipart20220809-1-es8cmr_html_170ab1fb00354669.png)

Enter into username/password by top left with options and click _login button._ By clicking, the system will automatically populate Tab with option. Select button as below.

![Shape16](RackMultipart20220809-1-es8cmr_html_6bcfe8e61c64c9eb.gif) ![](RackMultipart20220809-1-es8cmr_html_802555af7f0f9702.png)

Select INICIAR button to continue to menu screen.

![](RackMultipart20220809-1-es8cmr_html_57806dcb28b7e338.png)

![](RackMultipart20220809-1-es8cmr_html_20bf07601f7e011d.png)

![](RackMultipart20220809-1-es8cmr_html_9ece6985184fe26b.png)

![](RackMultipart20220809-1-es8cmr_html_4771840f4cbd22a2.png)

![](RackMultipart20220809-1-es8cmr_html_53e7a8777133ca12.png)

![](RackMultipart20220809-1-es8cmr_html_9a634d7355a360dc.png)

![](RackMultipart20220809-1-es8cmr_html_b8df86969517a084.png)

1.
# Other Nonfunctional Requirements

  1.
## Safety Requirements

The program is able to avoid catastrophic behavior.

  1.
## Security Requirements

This system provides protection of information through the mechanism only authorized can access the databases.

  1.
## Business Rules

All the installation rights will be mentioned in the license agreement.

1.
# Appendix A: Glossary

**Mean Time between Failures (MTBF)** The predicted average elapsed time between inherent failures of a system during operation.

**Mean Time to Failures (MTTF)** The predicted average operation time for a system replaced after a failure.

**MT Connect** an open industry standard for enabling interoperability between controls, devices, and software in manufacturing systems.

**User** : person using the Platform.

**Priority** : Giving rate of importance to the system features.

**REQ:** Functional Requirements

**HTTP** : Hypertext Transfer Protocol

**SMTP** : Server Message Transfer Protocol

_ **Copyright ©** _ _ **2022 Software Technical** _ _ **document.** _












