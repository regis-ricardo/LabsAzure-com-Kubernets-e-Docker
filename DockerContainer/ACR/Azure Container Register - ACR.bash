========================================== Azure Container Register - ACR ======================================
Permite criar, armazenar e gerenciar imagens e artefatos de container de forma privada (concorrete do docker hub)
Vantagens: facil reutilização pelas aplicações
Linkaar com facilidade ao app service for container: AKS, container instance, azure container apps

- Por que usar o ACR se o Docker Hub Faz isso e de grança ?
Tamanho: imagens docker tendem a ser grandes e como você ja esta no Azure se fizer pull de uma imagem será muito mais rápido
-Confiabilidade
-autenticação como entra ID
-Multiplas regiões

Opções de Planos: Basic, Padrão, Premium
Basic:
armazenamento de 10GB
Webhooks 2
Replicação geografica sem Suporte

Padrão:
armazenamento de 100GB
Webhooks 10
Replicação geografica: sem Suporte

Premium:
armazenamento de 500GB
Webhooks 500
Replicação geografica:  Com suporte por um curto por região

=============================================================================

[ Criando uma imagem local p/ e publicar no ACR ]

Acesse o site do github p/ baixar o html do SiteTreinamento:
https://github.com/higorbarbosa/SiteHTML-Treinamento
Extraia onde vamos criar nossa imagem docker 

Abra no VS Code, em open folder, a pasta onde esta o "SiteHTML-Treinamento"
Ajuste o index.html
crie o dockerfile com os codigos:

FROM nginx:alpine
COPY . /usr/share/nginx/html

Builde a imagem:
docker build -t site-html .

--- Após criar a imagem vamos criar nosso ambiente no ACR do Azure
Abra o portal do Azure
perquise por "container registry"
Subscription* Free Trial	
Resouce group --> clique em "create new" (usado quando não temos um RG p/ tal ou queremos um novo
								|
								|--> rg-containers --> nome que escolhi
Registry name* acrcontainersapps --> nome que escolhi
Location Brazil...
SKU Basic (isso é o plano)

"Review + create" ----> Estando tudo certo "Create"
-------------------------------------------------------------------------
-- Após criado minha ACR ele seguirá para outra pagina e la clique em "Go to resouce"
Apos clicar em Go to Resouce, poderemos ver todas informações de nosso Registry (ACR), como:

--Quick Start : São instruções que vão desde criar uma imagem a fazer push dela pra ACR
***--Acces keys: Onde temos nossas chaves de acesso ao ACR e também onde habilita o user admin (precisa ser marcado o check box "user admin")
***--Identity: Onde podemos vincular, Você pode conceder permissões à identidade gerenciada usando o controle de acesso baseado em função do Azure (Azure RBAC). 
A identidade gerenciada é autenticada com o Microsoft Entra ID, então você não precisa armazenar nenhuma credencial no código. 

=============================================================================

[ Efetuar push da imagem de container para o ACR ]
No Vs code:
Vá em +New File e de o nome de "container.azcli" e insira 
# Login no azure
az login 
 |--Dica-> Você pode no código selecionar e clicar com o botão direito do mouse, clique em "Run Line in Terminal" vai abrir o browser e ira aparecer informações sobre a subscription, no meu caso é a "[1] *  Free Trial 0865ab82-e..." digite "1" enter
Após estar logado volte no arquivo "container.azcli" e continue a a inserção do script pra build como abaixo:


# Build da imagem localmente
docker build -t site-html .               ---> pode fazer o mesmo feito acima, clique com o botão direito do mouse em "Run Line in Terminal"...

# Login no acr
az acr login --name acrcontainersapps     ---> P/ saber o nome, vá em "all resources", na coluna do resource em Name, esse é o nome que estamos buscando, é o nome 												 do "Container Registry" ---> Após isso, execute o comando, clique c/ botão dir. do mouse..., conforme ja feito. 
# Tag da imagem local ( estaremos renomeando/criando uma nova tag com base na existente e usando o nome do "login server" q é criado automaticamente
docker tag site-html acrcontainersapps.azurecr.io/site-html  ---> o nome "acrcontainersapps.azurecr.io" é o login server e você pega lá em overview (all resources, clicar no resource e em "Login Server" copie o nome que é "acrcontainersapps.azurecr.io"

=============================================================================
[ Azure app service for Containers ]
Ja vimos acima o que é um app service e na hora de provisionar temos a opção de publicar a partir de uma imagem de container
Quando usamos App service podemos selecionar se podemos usar como:
Code
Docker Container
Static Web App
Outra caracteristica que nos ajuda muito é visualizar o desempenho de nosso aplicativo e a integridade do serviço de ponta a ponta, ex:
Usamos o: Azure aplications insigths e o Azure monitor
Podemos ter alta disponibilidade
Podemos escolher o S.O linux ou Windows
Na segunda aba em "Create Web App" temos:
Options: Single Container
Image Source: Aqui escolhemos de onde vem nossa imagem, como ACR, Docker Hub, etc
Quick Start options
|-->Sample:
Image and tag:

Por que usar ACR ao invez de usar AKS ?
ACR é mais simples se você não precisa da complexidade do AKS e sua orquestração o ACR é a melhor pedida
*Resumido, indicado para sistemas pequenos


[ Publicando no App Service for Container com ACR ]
Pesquise por "App Service" e clique nele
					|
					|--> +Create --> +Web App
						|
						|-->Subscription*  Free Trial
						  |--> Resource Group --> rg-containers
							|
							|-->Instance Details
									|-->Name --> app-svc-containers-app (o nome você da um intuitivo)
Publish*          ---> Container
Operating System* ---> Linux (mais comuns para containers)
Region*			  ---> Brazil South	

Linux Plan (Brazil South) ---> clique em new p/ criar um novo com nome intuitico, p/ esse caso darei "plano-container"
Pricing plan              --->  Aqui escolha o plano free "Free F1 0,00 USD/Month (Estimated)  60 CPU Minutes/day included"

Clique em:  "Next: Container>"
Sidecar support (preview) ---> Disable
Image Source* 			  ---> Azure Container Registry (pois vamos escolher a imagem que demos push p/ o repositorio da azure ACR)
Options					  ---> Single Container (implemente e execute um único contêiner Docker em seu Web App. Uso: Ideal para aplicativos simples, onde você 
                                                  só  precisa de um único serviço ou aplicativo rodando em contêiner)

Azure container registry options:
Registry  		---> acrcontainersapps
Image  			---> site-html
Tag             ---> latest

Clicar em "Review + Create" depois "Create"
									|--> depois clique em "Go to Resource"
 E na proxima pagina temos nossa URL no canto superior direito
 
=============================================================================
[ Continuous Deployment com Webhooks ]
Ou seja, deploy automatico assim que a imagem é atuazada no ACR

Na mesma pagina onde pegamos o link para testar a aplicação, iremos em:
Deployment Center
	|
	|--> Procurar por: "Continuos deployment" e marcar "On" depois "save"
	
	
 
	




	





 


























