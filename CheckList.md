# Infrastructure

## Networking

### Network Virtual Appliance

Are you utilising a [network virtual appliance (NVA)](https://azure.microsoft.com/en-us/blog/azure-firewall-and-network-virtual-appliances/) to control traffic egress out of the environment? (e.g. Azure Firewall, Palo Alto, F5).

| **Network Virtual Appliance** | **Action** |
| --- | --- |
| No | No further action is required. |
| Yes | Apply below documented firewall rules|

#### Firewall Rules
  
 | **Destination** | **Protocol** | **Port** | **Use** | 
 | --- | --- | --- | --- |
 

### Traffic Routing

Will [force tunneling](https://docs.microsoft.com/en-us/azure/firewall/forced-tunneling) be utilised to send AML traffic through a  (NVA) for firewall or proxy inspection? (e.g. Azure Firewall, Palo Alto, F5).

| **Force Tunneling** | **Action** |
| --- | --- |
| No | No further action is required. AML network traffic will egress via the [default network route](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#default).|
| Yes | 1) Obtain the private IP address of the security appliance. This IP address will be utilised to create/update a [user defined route](https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview#user-defined) to send AML traffic via the security appliance. </br> 2) Review **User Defined Route** section below|


#### User Defined Route

## Domain Name Resolution

Will endpoints utilise [Azure provided DNS](https://learn.microsoft.com/en-us/azure/virtual-network/what-is-ip-address-168-63-129-16) for name resolution or utilise a deployed DNS server?

| **Custom DNS Server** | **Action** |
| --- | --- |
| No | No further action is required. |Azure provided DNS will be utilised for name resolution requests.|
| Yes | 1) Conditional forwarders will need to be created for Private Endpoint name resolution. </br> See section below. |

### Private EndPoint Conditional Forwarders


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

