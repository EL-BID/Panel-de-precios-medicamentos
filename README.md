
*This digital tool is part of the catalog of tools of the **Inter-American Development Bank**. You can learn more about the IDB initiative at [https://knowledge.iadb.org/pt-br/codigo-para-o-desenvolvimento](https://knowledge.iadb.org/pt-br/codigo-para-o-desenvolvimento)*

<h1 align = "center"> Drug Price Panel </h1>
<p align = "center"> <img src = "https://raw.githubusercontent.com/EL-BID/Panel-de-precios-medicamentos/main/panel-de-precios.png" /> </p>

## Table of Contents:
---
- [Description and context](#description-and-context)
- [Installation guide](#installation-guide)
- [Author/s](#authors)
- [License](#license)
- [Limitation of responsibilities](#limitation-of-responsibilities)

## Description and context
---
This application presents information on the reference prices of medicines and other products, based on the data from the Electronic Fiscal Note.
Tool developed using the R language and with the support of Text and Data Mining algorithms. The objective is to improve it with the development of new algorithms and, possibly, with the use of the Python language and its libraries.

The intended readers of this document are the system analyst & designer, project developer, developer, project panel, and system owners. The system analyst & designer can use this document for his cross reference to verify his future work. Project developers can use this document for traceability of the functions implemented. Project panel can use this document to verify the quantity and quality of the end product, finally this document can help bridge-up the gaps between the project stakeholders i.e. analysts, designers, developers, system users and the system owners to help them understand what functionalities this platform will have and what not

- Advanced/Professional Users, such as engineers (Developers) or researchers, who want to use for more demanding graph analysis.
- Development Consultants – Experienced professionals within the app and web development market. This document can be used to review the components of the platform and possible changes are needed or to provide an overview of the user experience.
- App Developers – This document will primarily be used to instruct the development team on how the Platform should be built on the mediums.
- Programmers who are interested in working on the project by further developing it or for maintaining the platform.
- For Users who want to setup.

## Installation guide
---
How to set up the server

**Steps to setup development env**

- Clone project from github https://github.com/EL-BID/Panel-de-precios-medicamentos
- Install Rstudio & composer
- make sure that you have postgresql database installed
- copy .env.dev to .env and change the DB\_XXX environment variable to your local postgresql server info
- run command:

```
composer.phar install
```

- To init database, run command at folders database/migrations and database/seeds:
```
migrate:fresh –db.
```
- access the page for toolkit: https://github.com/EL-BID/Panel-de-precios-medicamentos


**Steps to deployment**

Install the  **R-base package**  using the following code
```
sudo apt-get update
```
```
sudo apt-get install r-base
```

Download and install the  **gdebi**  package using the following commands

```
sudo apt install gdebi
```

Use the following commands to install the .deb package

```
sudo gdebi /path/to/the/file/.deb
```

Updated R studio

Updated Sql version

**Steps to setup development enviroment**

- install
- clone project from [b](https://github.com/orite-dev/kepp-v2-web)https://github.com/EL-BID/Panel-de-precios-medicamentos
- copy .env.development to .env

Run the following commands in the project root folder:

```
yarn install
```
```
yarn start
```

\*NOTE: the project is based on .R execution resources required.

**Steps to deploy on system**

- copy .env.production to .env
- Run the following commands:
```
yarn install
```
```
yarn build
```
```
yarn deploy
```
**Clone and Install**

Clone the repo:

https://github.com/EL-BID/Panel-de-precios-medicamentos

Move to the appropriate directory:

Install dependencies:

```
npm install
```

## Software Interfaces

<p align = "center"> <img src = "https://raw.githubusercontent.com/EL-BID/Panel-de-precios-medicamentos/main/soft-inter.png" /> </p>
<p align = "center"> <img src = "https://raw.githubusercontent.com/EL-BID/Panel-de-precios-medicamentos/main/package-inter.png" /> </p>

## Hardware Interfaces

| No | Hardware | Description |
| --- | --- | --- |
| 1 | System | Server Based System |
| 2 | OS | (All Supported OS) |
| 3 | Memory | 2 GB (optional) |
| 4 | RAM | 4.0 GB (optional) |

### Equipment

- An Internet connection – Wi-Fi (a/g/n/ac) or wireless (3G or 4G/LTE)
- For Mobile Permissions for upload.

### Supported operating systems

- Windows, Mac and linux

### Processor requirement

- Any single core processor or better


## Author/s
---
Eduardo Yonekura

## Limitation of responsibilities
Disclaimer: This section is only for IDB-funded tools.

The IDB will not be responsible, under any circumstance, for damage or compensation, moral or patrimonial; direct or indirect; accessory or special; or by way of consequence, foreseen or unforeseen, that could arise:

i. Under any theory of liability, whether by contract, infringement of intellectual property rights, negligence or under any other theory; me

ii. As a result of the use of the Digital Tool, including, but not limited to, potential defects in the Digital Tool, or the loss or inaccuracy of data of any kind. The foregoing includes expenses or damages associated with communication failures and / or computer malfunctions, related to the use of the Digital Tool.




