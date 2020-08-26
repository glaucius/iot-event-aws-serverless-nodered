

<!-- PROJECT LOGO -->
<br />
<p align="center">

  <h1 align="center">Criando um stack completo para um ambiente IoT orientado a eventos</h1>

  <p align="center">
    Um excelente ponto de partida para você começar a construir suas funções, containers e micro serviços
    <br />
  </p>
</p>



<!-- TABLE OF CONTENTS -->
## Sumário

* [Sobre o projeto](#about-the-project)
  * [Stack de tecnologia](#built-with)
* [Como iniciar](#getting-started)
  * [Pre requisitos](#prerequisites)
  * [Instalação](#installation)
* [Uso](#usage)
* [Roadmap](#roadmap)
* [Contribua](#contributing)
* [License](#license)
* [Contato](#contact)
* [Agradecimentos](#acknowledgements)



<!-- ABOUT THE PROJECT -->
## Sobre o projeto


Este projeto teve como ponto de partida a minha participação em atividade e meetup do AWS User Group de SP, e para tanto, foi precisa criar este stack de tecnologias para demonstrar e enriquecer a palestra.

Aqui o link da palestra (https://www.meetup.com/pt-BR/awsusergroupsp/events/272646545/)

O objetivo é criar um ambiente de ponta a ponta orientado a eventos, simulando uma plataforma de monitoramento de animais e espécies de um parque de preservação ambiental, tudo com ferramentas open source e cloud pública AWS.


### Stack de tecnologias
Foram usadas algumas ferramentas e frameworks para o deploy deste stack, sendo:

* [Node Red](https://nodered.org): Criação da fazenda ou onde nascem os sensores
* [Serverless](https://serverless.com): Para as funções Lambda
* [Terraform](https://terraform.io): Setup dos serviços e produtos AWS
* [Docker](https://docker.com): Para os containers e micro serviços
* [Telegram](https://core.telegram.org/bots): Para o seu bot, a fim de receber as notificações

O stack em si tem como propósito ser todo orientado a código, IaC, logo, você não vai precisar criar nada na console da AWS, tudo no command line. 

<!-- GETTING STARTED -->
## Instalação e deploy

Vamos lá apressadinho, seguem os pre requisitos para iniciar o setup e deploy:


### Pre requisitos

O que você vai precisar já configurado e instalado, procure nos sites dos vendors para instruções de como instalar e configurar:

* [AWS-CLI](https://aws.amazon.com/pt/cli/)
* [Docker-compose](https://docs.docker.com/compose/)
* [Serverless](https://www.serverless.com/framework/docs/getting-started/)


### Passo 1 - Clone do repositório

1. Clonar o repositorio
```sh
git clone https://github.com/glaucius/iot-event-aws-serverless-nodered.git
```

### Passo 2 - Funções Lambda 

1. Criando suas funções Lambda
```sh
cd serverless/iot-telegram
```
2. Configure o TOKEN do Telegram e o ChatId onde você quer receber as notificações:
```sh
vi serverless.env.yml
```
3. Instale todas as dependencias do framework serverless, dentro da pasta iot-telegram:
```sh
npm install
```
4. Agora é a hora de fazer o deploy:
```sh
serverless deploy
```
5. Configure o webhook do seu bot, depois que finalizar o passo 4, você deve receber o link da sua função, então, configure o webhook da seguinte maneira :
```sh
curl -X POST https:/xxxxxxxxx/dev/set_webhook
```
Preste atenção a mensagem de retorno, deve aparecer a mensagem/string "ok".

6. Por fim, veja os detalhes das suas funções que foram instaladas:
```sh

aws lambda list-functions 
```
Procure pelo ARN da função de notificação, a string é parecida com a abaixo:

```sh
aws lambda get-function --function-name=iot-telegram-dev-notification | grep FunctionArn
```
    FunctionArn = "arn:aws:lambda:REGION:XXXXXXXXX:function:iot-telegram-dev-notification"

Guarde a string da função Lambda, que esta entre aspas "", você vai usar em instantes no código do Terraform para subir a Thing.

De uma olhada no painel da AWS da sua conta e veja se as funções estão já disponíveis a fim de validação.


### Passo 3 - Deploy de recursos AWS - Iot - VPC  

1. Criar os certificados para os dispositivos IoT

Os certificados para os dispositivos IoT, os Things, são necessários para a garantia da comunição segura e criptografada ponta a ponta, então, neste caso eu optei por seguir a recomendação da AWS e criar os certificados no dashboard da conta. Não é nada complicado, veja o link abaixo:

https://docs.aws.amazon.com/iot/latest/developerguide/device-certs-create.html

Faça o download dos certificados, você vai usar depois para configurar o Node Red.

2. Obter o ARN do certificado

Para obter o ARN do certificado, execute o comando abaixo:

```sh
aws iot list-certificates
```
O ARN do certificado se parece como arn:aws:iot:REGION:xxxxxxxxxxx:cert/um_grande_hash

Agora é hora de editar os arquivos para subir os recursos na AWS.

3. Editar o deploy, faço o setup dos arquivos abaixo, para configurar os detalhes do deploy
```sh
cd terraform 
nano vars.tf
```
  - vars.tf : edite as variáveis, principalmente a LAMBDA_FUNCTION_ARN, que você captou nos passos anteriores e o 


2. Inicie o terraform na pasta do terraform
```sh
terraform init
```
2. Agora é a hora de validar o plano de deploy
```sh
terraform plan -out=plano.out
```
2. Chegou o momento de fazer o deploy dos recursos na AWS
```sh
terraform apply plano.out
```
Cruze os dedos, eu indicaria buscar um café, mas será rápido.

Depois de criado, de uma visitada geral no dashboard, para ver com seus olhos o trabalho realizado pelo código.


### Passo 4 - Deploy da fazenda, ou, dos sensores dos bichos 

1. Aqui você vai precisar do docker e docker-compose instalado no seu computador
```sh
cd docker
docker-compose up -d

```
2. Agora, acesse o nodered no seu browser no endereço : http://127.0.0.1:1880

3. Instale o node random, pois ele que gera os dados e simulações dos sensores

  https://flows.nodered.org/node/node-red-node-random

4. Importe o fluxo de eventos que esta dentro da pasta docker, o arquivo flow.json

  https://nodered.org/docs/user-guide/editor/workspace/import-export

5. Configure o node red para acessar a sua Thing, que foi criada no passo 3




<!-- ROADMAP -->
## Roadmap

Vamos manter este código e incluir novas funcionalidades.



<!-- LICENSE -->
## Licença

Distribuido sobre a licença MIT. Veja o arquivo LICENSE para mais informações.


<!-- CONTACT -->
## Contato

Glaucius Djalma Pereira Junior- [@glauciusjunior](https://twitter.com/glaucius) - glaucius@gmail.com

