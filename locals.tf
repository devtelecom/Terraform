locals {
  resource_location="Eastus2"
  vnet={
    name="infra-vnet"
    vnet_range=["192.168.0.0/16"]
  }
  subnet= {
    range=["192.168.1.0/24"]
    name="app-snet"
    }
  }


/*
subnets=[
          {
            name= "infra-snet"
            subnet_range=["192.168.1.0/24"]
         },
  { 
    name= "app-snet"
    subnet_range=["192.168.2.0/24"]
  }
]
}
*/