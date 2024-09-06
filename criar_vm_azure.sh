#!/bin/bash

# Criar o Resource Group (caso ainda não tenha sido criado)
az group create --name RG-lab-desafio-docker --location brazilsouth

# Criar a VM Ubuntu 20.04 LTS com autenticação por senha e IP público padrão
az vm create \
  --name host-docker-ubuntu \
  --resource-group RG-lab-desafio-docker \
  --location brazilsouth \
  --image Ubuntu2204 \
  --admin-username regis \
  --admin-password W9b4n7i5!@#$% \
  --authentication-type password \
  --size Standard_B1s \
  --public-ip-sku Standard \
  --output json

