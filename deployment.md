# Pre-Requisites Check


## Networking

### Force tunneling

Will [force tunneling](https://docs.microsoft.com/en-us/azure/firewall/forced-tunneling) be utilised to send traffic network through a security appliance for firewall or proxy inspection? (e.g. Azure Firewall, Palo Alto, F5). 

If force tunneling is **not** going to be used, AML network traffic will egress via the default network route (direct to internet).

If force tunneling **is** to be used, obtain the private IP address of the security appliance. This IP address will be utilised to create/update a user defined route to send AML traffic via the security appliance.






# Azure Machine Learning Workspace

| VNET Name | New or existing |
| --- | --- |
| aml-vnet | New |


| Subnet | New or existing | Description |
| --- | --- | --- |
| training-subnet | New | Subnet for hosting compute instances |
| scoring-subnet | New | Subnet for hosting compute clusters |
| pvtlink-subnet | New | Subnet for hosting private link endpoints |

## Training Subnet


## Scoring Subnet

## Private Link Subnet

# Azure Machine Learning Resources

## Azure Storage Account

## Azure Key Vault

## Azure Container Registry

## Azure App Insights

