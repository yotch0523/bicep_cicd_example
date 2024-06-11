# Structure of this directory
```
.
├── .gitignore
│   └── Specifies intentionally untracked files to ignore
├── modules/
│   ├── storageAccount/
│   │   └── storageAccount.bicep
│   │       └── Defines the Azure Storage Account infrastructure with various properties like CORS rules, encryption, and network ACLs.
│   ├── uami/
│   │   └── uami.bicep
│   │       └── Sets up a User-Assigned Managed Identity (UAMI) with a role definition to access the Storage Account.
│   └── webApp/
│       └── webApp.bicep
│           └── Configures an Azure Web App with settings for PHP, Node.js versions, HTTPS only, and publishing credentials.
├── parameters.bicepparam
│   └── Contains parameters for the Bicep templates.
├── README.md
│   └── Project documentation (currently empty).
└── template.bicep
    └── Main Bicep template that orchestrates the deployment of the web app, storage account, and UAMI modules with dependencies.
```

# Prerequisites
## 1. Has Service principal already been created and assigned the necessary roles? 
```shell
az login --tenant [your-tenant-id]

# create service principal to execute CI/CD
az ad sp create-for-rbac
  --name GitHubActionApp
  --role contributor
  --scopes /subscriptions/[your-subscription-id]/resourceGroups/[your-resource-group-name]
  --sdk-auth

# create federated credential
az ad app federated-credential create
  --id [your-application-id]
  --parameters credential.json

# the contributor role on Web App
az role assignment create
  --role contributor
  --subscription [your-subscription-id]
  --assignee-object-id [target-service-principal-id]
  --scope [your-target-webapp-path]
  --assignee-principal-type ServicePrincipal

# if create role-assignment resource, the folowing assignment code is necessary
az role assignment create
  --role "User Access Administrator"
  --subscription [your-subscription-id]
  --assignee-object-id [target-service-principal-id]
  --scope [your-target-resource-group]
  --assignee-principal-type ServicePrincipal
```

# How to deploy the infrastructure
```shell
az login --tenant [your-tenant-id]

# dry-run command
az deployment group what-if
  --resource-group [resource-group-name]
  --template-file [bicep-file-path]
  --parameters [parameter-file-path]

# deploy command
az deployment group create
  --resource-group [resource-group-name]
  --template-file [bicep-file-path]
  --parameters [parameter-file-path]


```