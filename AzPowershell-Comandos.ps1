======= Ambiente de Laboratorio =====
1- Instalar o Azure CLI e Azure PowerShell
2- Instalar o Editor que usaremos que é o Visual Estudio
	|--> Instalar algumas extenções e temas
3-Instalar o GIT
--------



======= Azure CLI =====

[ Azure CLI ]
Ele é a experiencia de gerenciamento de linha de comando da plataforma cruzada da Microsoft 
p/ o gerenciamento de recursos do Azure, formas de uso:
.Navegador com "Azure Cloud Shell"
.Instalar no Windows e executar através de linha de comando

# Comandos Básicos
az <command> <subcommand> --help

# P/ fazer Login
az login --> Chama o navegador padrão p/ fazer login

az login --use-device-code --> efetua o login sem navegador
|-->O comando retorna uma msg na linha de comando, fornecendo um URL e um código de dispositivo.
	|--> Exemplo de saída:"To sign in, use a web browser to open the page https://microsoft.com/devicelogin and enter the code ABCD-EFGH to authenticate."

az login --service-principal -u <ID-do-Cliente> -p <Senha-Secreta> -t <ID-do-tenant>
|--> "--service-principal": Indica que o login será feito usando uma Principal de Serviço, em vez de um usuário comum
|--> "-u" <ID-do-Cliente>: Substitua <ID-do-Cliente> pelo ID do Cliente (Client ID) da Principal de Serviço
|--> "-p" <Senha-Secreta>: Substitua <Senha-Secreta> pela senha secreta (Client Secret) associada à Principal de Serviço
|--> "-t" <ID-do-tenant>: Substitua <ID-do-tenant> pelo ID do Tenant (Tenant ID), que é o identificador do diretório (tenant) 
	 do Azure Active Directory (AAD) onde a Principal de Serviço foi criada
	 
az login --identity |--> usado em automações, exemplo: Acessos para pipelines usando o Azure DevOps
|--> Exemplo:  "az login --identity --username "myUserAssignedIdentity""

#Comando para seber se esta logado e qual a conta esta logado:
az account show

az logout [--username] 
|--> usado para deslogar ou deslogar algum usuario

az account list |--> Lista de Assinaturas: Exibe uma lista de todas as assinaturas associadas à conta de usuário que fez login na CLI
|--> exibirá uma lista de assinaturas em formato JSON com todos os detalhes mencionados acima

az account list --output table
|--> Isso formata a saída em uma tabela, facilitando a leitura.

az account list --query "[?isDefault]"
|--> Isso usa uma consulta para filtrar apenas a assinatura que é marcada como padrão.

Quando Usar:
Mudança de Assinatura: Quando você trabalha com múltiplas assinaturas e precisa identificar qual está atualmente ativa ou mudar para outra.
Gerenciamento de Assinaturas: Útil para obter uma visão geral das assinaturas sob sua conta, especialmente em ambientes com várias assinaturas, como produção, desenvolvimento, e testes.
Automação: Em scripts onde você precisa garantir que está trabalhando com a assinatura correta.

# O Que Fazer Depois:
Depois de listar as assinaturas, você pode usar "az account set" para definir uma assinatura específica como a ativa (padrão) para suas operações subsequentes na Azure CLI.

Exemplo:
az account set --subscription "Nome ou ID da Assinatura"
|--> Isso garante que todos os comandos subsequentes da CLI serão executados dentro do contexto da assinatura selecionada.

# Tudo no Azure fica em um RG e para isso devemos cria-lo
az group create --location brazilsouth --resource-group RG 
														 |--> indica que estamos dando o nome RG ao grupo

# Cria uma VM Linux Ubuntu no azure dentro de um RG
az vm create -n vm-linux-ubuntu -g RGAZCLI --image Ubuntu2204 --generate-ssh-keys
-n vm-linux-ubuntu         --> da um nome a VM
-g RGAZCLI              --> Diz que ficará no grupo RG   
--image Ubuntu2204   --> Diz que será do tipo Ubuntu
--generate-ssh-keys  --> Gera um par de chaves SSH ping 

# P/ iniciar/parar uma Maquina virtual:
az vm start ou az vm stop ou az vm restart
--resource-group RG
--name vm-linux

# P/ desalocar uma maquina virtual
az vm deallocate --resource-group RG --name vm-linux

Quando uma VM é desalocada, ela é essencialmente parada, e os recursos como a CPU e a memória, são liberados, mas o disco da VM e outros recursos associados (IP estáticos) permanecem intactos.
*O deallocate é usado para economia de recursos.

# Realocar uma maquina em outro local 
az vm redeploy --resource-group RG --name vm-linux

O comando az vm redeploy na Azure CLI é utilizado para reimplantar uma máquina virtual (VM) em um novo host no Azure. Isso pode ser útil em situações onde a VM está enfrentando problemas de conectividade, desempenho ou se você suspeita que o host físico no qual a VM está executando tem algum problema.
O Que Acontece Durante a Reimplantação:
Nova Alocação de Host: A VM é desalocada do host atual e realocada em um novo host físico dentro do mesmo datacenter.
Interrupção: Haverá uma breve interrupção na disponibilidade da VM enquanto ela é desalocada e realocada. Todos os processos em execução serão interrompidos.
Preservação de Dados: O disco do sistema operacional e os discos de dados conectados à VM permanecem intactos, e as configurações de rede são preservadas.


# Deletar uma Vm
Quando você cria uma vm você cria vários resouces dentro do seu RG e pra remover todos você deve remover o RG ou entrar via web selecionar um por um e pedir pra deletar.
Além disso também é criado automaticamente um outro RG p/ rede dessa vm, chamado "NetworkWatcherRG" 

az vm delete --resource-group <nome-do-RG> --name <nome da vm>
ou
# Deletar um grupo RG
az group delete --name NetworkWatcherRG --yes --no-wait ---> p/ não pedir confirmação

# Listar VM
az vm list

# Listar os tamanhos das VM disponiveis em uma determinada região do Azure:
az vm list-sizes --location eastus 
|
|--> Neste exemplo, o comando lista todos os tamanhos de VM disponíveis na região "East US"
|--> O Que Esse Comando Lista?
Name: #Nome do tamanho da VM (por exemplo, Standard_DS1_v2).
NumberOfCores: #Número de núcleos de CPU.
MemoryInMB: #Quantidade de memória RAM em megabytes.
MaxDataDiskCount: #Número máximo de discos de dados que podem ser anexados à VM.
OSDiskSizeInMB: #Tamanho do disco do sistema operacional.
ResourceDiskSizeInMB: #Tamanho do disco temporário (ou "resource disk").
MaxIOPS: #Máximo de operações de entrada/saída por segundo (IOPS) que o disco pode suportar.

#Formatação da Saída:
A saída é, por padrão, em formato JSON, mas você pode formatar a saída para torná-la mais legível:

# lista os tamanhos de máquinas virtuais (VMs) disponíveis para uma determinada região no Azure (eastus p/ região Leste dos EUA) 
--Tabela: Para exibir em formato tabular
az vm list-sizes --location eastus --output table


-- CSV: Para exportar os dados em formato CSV
az vm list-sizes --location eastus --output csv


[ Lab teste de criação de ambientes com comando Azure CLI ]
# Criar um RG
az group create -n RGACLI -l brazilsouth

#Mostra a lista de grupo exitente em formato de tabela de banco
az group list --output table
Name     Location     Status
-------  -----------  ---------
RGAZCLI  brazilsouth  Succeeded


#Mostra detalhes do grupo criado onde é informado o grupo criado
az group show -n RGAZCLI
{
  "id": "/subscriptions/0865ab82-e3c3-4f43-9aa6-5f5a68592140/resourceGroups/RGAZCLI",
  "location": "brazilsouth",
  "managedBy": null,
  "name": "RGAZCLI",
  "properties": {
    "provisioningState": "Succeeded"
  },
  "tags": null,
  "type": "Microsoft.Resources/resourceGroups"
}





======= Windows PowerShell =====


# Verificando a versao do PowerShell
$PSVersionTable.PSVersion

# Instalar o Modulo do Azure Powershell
Install-Module -Name Az -Repository PSGallery -Force

# Conectando a nossa conta do Azure ao Powershell
Connect-AzAccount -UseDeviceAuthentication


# Conferir a conta que esta autenticada
Get-AzContext

# Criando Resource Group no Azure Powershell
New-AzResourceGroup -Name RGPOWERSHELL -Location "BrazilSouth"

# Listar dos Resource Groups 
Get-AzResourceGroup

# Removendo Resource Group no Azure Powershell
Remove-AzResourceGroup -Name RGPOWERSHELL



======= Visual studio Code =====
Após instalado devemos instalar suas extenções:	

1- Clique no icone de extensions ao seu lado esquerdo, ele é um de barra de cubos com um quadrado se soltando
2- Na sua barra de pesquisa, procure por Azure e instale: Azure tools, azure account, 


======= Docker Básico =====
Containers docker, docker hub e docker compose:

-- Principais comandos básicos:

# mostra versão do docker
docker version

# mostra as imagens 
docker images list
docker images

# procurar um parametro
docker search <parametro>

# trazer uma imagem para nossa máquina
docker image pull <imagem>
Ex:
docker pull hello-world
 
# Rodar a imagem baixada
docker run <nome-imagem>, ex
docker run hello-world
|--> ela roda e morre


# Rodar em uma porta especifica
docker run -it -p 8080:80 nginx

# verificar como como esta o container
docker ps

# verificar inclusive containers que ja morreram:
docker ps -a --> exemplo ver os containers que rodaram e morreram 

# inspencionar a nossa imagem:
docker inspect <id ou alias>

#deletar um container que esta parado/morto
Apos o "docker ps -a", pegado o CONTAINER ID e executamos o comando abaixo:
docker rm 9c52fb02d773	
			|---> ID do container que pegamos no docker ps -a 

# Deletar uma imagem
docker rmi <imagem>

# executar um comando dentro do container
docker exec <id ou nome>

# Iniciar/parar um comando que paramos
docker start/stop <id do container>


#rodar uma imagem de forma deatachada -d e interativa -it (exec comandos shell)
docker run -it -d ubuntu 

#pegar o ID do container rodando
docker ps

# Entrar no modo bash
docker exec -it <id-container> bash


# Expor uma aplicação na porta 80
Procupar no site do docker hub a imagem yeasy/simple-web

docker run --rm -it -p 8022:80 yeasy/simple-web:latest

--rm
O que faz: Esta opção diz ao Docker para remover automaticamente o contêiner assim que ele for interrompido ou encerrado.

-it
-i (interativo): Mantém o STDIN (entrada padrão) aberto, permitindo que você interaja com o contêiner.
-t (tty): Aloca um terminal TTY, o que permite uma interface de linha de comando interativa. Juntos, -it permitem que você interaja com o contêiner diretamente, como se estivesse usando um terminal.

-p 8022:80
Este parâmetro mapeia a porta do contêiner para uma porta no host.
8022 é a porta no host (seu computador).
80 é a porta no contêiner (onde o serviço web está rodando).
Isso significa que qualquer solicitação enviada para localhost:8022 no seu computador será redirecionada para a porta 80 do contêiner

yeasy/simple-web:latest
yeasy/simple-web é o nome da imagem Docker . Esta imagem contém uma aplicação web simples.
:latest especifica a tag da imagem, latest refere-se à versão mais recente da imagem disponível

Após isso pode acessar a aplicação através do link: http://localhost:8022/

############# Docker File #############
1 - criar uma imagem
2 - Criar o docker File


1 - Procurar pela imagem do nginx no docker hub
No site após achar a imagem nós veremos como usar a imagem do docker file, ex. de como estará no site:

Alternatively, a simple Dockerfile can be used to generate a new image that...

FROM nginx
COPY static-html-directory /usr/share/nginx/html


# Criar pra organizar um pasta chamada DockerContainer em:
D:\Entrevistas-e-Labs-de-entrevistas\LabsAzure-com-Kubernets-e-Docker\DockerContainer

Dentro deste diretório baixe o zip "https://github.com/higorbarbosa/SiteHTML-Treinamento" e extraia todo conteundo aqui dentro

Criar um arquivo chamado dockerfile  e dentro dele inserir:

FROM nginx
COPY . /usr/share/nginx/html

Abrir o terminal do VS Code modo com bash 

Navegue  até o dir do DockerContainer e dentro dele execute o comando:
docker build -t site-nginx .


