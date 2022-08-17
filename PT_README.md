![analytics image (flat)](https://raw.githubusercontent.com/vitr/google-analytics-beacon/master/static/badge-flat.gif)
![analytics](https://www.google-analytics.com/collect?v=1&cid=555&t=pageview&ec=repo&ea=open&dp=/panel-de-precios/readme&dt=&tid=UA-4677001-16)
[![Quality Gate Status](https://sonarcloud.io/api/project_badges/measure?project=EL-BID_Panel-de-precios-medicamentos&metric=alert_status)](https://sonarcloud.io/summary/new_code?id=EL-BID_Panel-de-precios-medicamentos)

*Esta ferramenta digital faz parte do catálogo de ferramentas do **Banco Interamericano de Desenvolvimento**. Você pode saber mais sobre a iniciativa do BID em [code.iadb.org](https://code.iadb.org)*

<h1 align = "center"> Painel de preços de medicamentos </h1>
<p align = "center"> <img src = "https://raw.githubusercontent.com/EL-BID/Panel-de-precios-medicamentos/main/panel-de-precios.png" /> </p >

## Índice:
---
- [Descrição e contexto](#description-and-context)
- [Guia de instalação](#installation-guide)
- [Autor/es](#autores)
- [Licença](#licença)
- [Limitação de responsabilidades](#limitação-de-responsabilidades)

## Descrição e contexto
---
Este aplicativo apresenta informações sobre os preços de referência de medicamentos e outros produtos, com base nos dados da Nota Fiscal Eletrônica.
Ferramenta desenvolvida em linguagem R e com o apoio de algoritmos de Text Mining e Data Mining. O objetivo é melhorá-lo com o desenvolvimento de novos algoritmos e, possivelmente, com o uso da linguagem Python e suas bibliotecas.

Os leitores pretendidos deste documento são o analista e designer do sistema, o gerente do projeto, o desenvolvedor, o painel do projeto e os proprietários do sistema. O analista de sistemas e designer podem usar este documento como referência cruzada para verificar seu trabalho futuro. Gerentes de projetos podem usar este documento para rastreabilidade das funções implementadas. O painel do projeto pode usar este documento para verificar a quantidade e a qualidade do produto final. Este documento pode ajudar a preencher as lacunas entre as partes interessadas do projeto, ou seja, analistas, designers, desenvolvedores, usuários do sistema e os proprietários do sistema para ajudá-los a entender quais funcionalidades esta plataforma terá e quais não terá:

- Usuários avançados/profissionais, como engenheiros (desenvolvedores) ou pesquisadores, que desejam usar para análises gráficas mais exigentes.
- Consultores de Desenvolvimento – Profissionais experientes no mercado de desenvolvimento de aplicativos e web. Este documento pode ser usado para revisar os componentes da plataforma e possíveis alterações necessárias ou para fornecer uma visão geral da experiência do usuário.
- Desenvolvedores de Aplicativos – Este documento será usado principalmente para instruir a equipe de desenvolvimento sobre como a Plataforma deve ser construída nas mídias.
- Programadores interessados em trabalhar no projeto, desenvolvendo-o ou mantendo a plataforma.
- Para usuários que desejam configurar.

## Guia de instalação
---
Como configurar o servidor

**Etapas para configurar o ambiente de desenvolvimento**

- Clone projeto do github https://github.com/EL-BID/Panel-de-precios-medicamentos
- Instale o Rstudio e compositor
- certifique-se de ter o banco de dados postgresql instalado
- copie .env.dev para .env e altere a variável de ambiente DB\_XXX para as informações do seu servidor postgresql local
- comando de execução:

```
composer.phar install
```

- Para iniciar o banco de dados, execute o comando nas pastas database/migrations e database/seeds:
```
migrate:fresh –db.
```
- acesse a página do kit de ferramentas: https://github.com/EL-BID/Panel-de-precios-medicamentos

**Etapas para implantação**

Instale o **R-base package** usando o código a seguir
```
sudo apt-get update
```
```
sudo apt-get install r-base
```

Baixe e instale o pacote **gdebi** usando os seguintes comandos

```
sudo apt install gdebi
```

Use os seguintes comandos para instalar o pacote .deb

```
sudo gdebi /path/to/the/file/.deb
```

Rstudio atualizado

Atualizar versão do SQL

**Etapas para configurar o ambiente de desenvolvimento**

- instalar
- projeto clone de [b](https://github.com/orite-dev/kepp-v2-web)https://github.com/EL-BID/Panel-de-precios-medicamentos
- copie .env.development para .env

Execute os seguintes comandos na pasta raiz do projeto:

```
yarn install
```
```
yarn start
```

\*NOTA: o projeto é baseado nos recursos de execução .R necessários.

**Etapas para implantar no sistema**

- copie .env.production para .env
- Execute os seguintes comandos:
```
yarn install
```
```
yarn build
```
```
yarn deploy
```
**Clone e instale**

Clone o repositório:

https://github.com/EL-BID/Panel-de-precios-medicamentos

Mova para o diretório apropriado:

Instalar dependências:

```
npm install
```

## Interfaces de software

<p align = "center"> <img src = "https://raw.githubusercontent.com/EL-BID/Panel-de-precios-medicamentos/main/soft-inter.png" /> </p>
<p align = "center"> <img src = "https://raw.githubusercontent.com/EL-BID/Panel-de-precios-medicamentos/main/package-inter.png" /> </p>

## Interfaces de hardware

| Não | Ferragens | Descrição |
| --- | --- | --- |
| 1 | Sistema | Sistema Baseado em Servidor |
| 2 | SO | (todos os sistemas operacionais suportados) |
| 3 | Memória | 2 GB (opcional) |
| 4 | RAM | 4,0 GB (opcional) |

### Equipamento

- Uma conexão com a Internet – Wi-Fi (a/g/n/ac) ou sem fio (3G ou 4G/LTE)
- Para permissões móveis para upload.

### Sistemas operacionais suportados

- Windows, Mac e Linux

### Requisito do processador

- Qualquer processador de núcleo único ou melhor


## Autor(es)
---
Eduardo Yonekura

## Limitação de responsabilidades
Isenção de responsabilidade: Esta seção é apenas para ferramentas financiadas pelo BID.

O BID não será responsável, em hipótese alguma, por danos ou indenizações, morais ou patrimoniais; direto ou indireto; acessório ou especial; ou por consequência, prevista ou imprevista, que possa surgir:

i. Sob qualquer teoria de responsabilidade, seja por contrato, violação de direitos de propriedade intelectual, negligência ou sob qualquer outra teoria; Eu

ii. Como resultado do uso da Ferramenta Digital, incluindo, mas não se limitando a, possíveis defeitos na Ferramenta Digital, ou a perda ou imprecisão de dados de qualquer tipo. O anterior inclui despesas ou danos associados a falhas de comunicação e/ou mau funcionamento do computador, relacionadas ao uso da Ferramenta Digital.




