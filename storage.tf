/*#Configuring storage account
resource "azurerm_storage_account" "mystorage" {
  name                     = "shivam00786"
  resource_group_name      = azurerm_resource_group.myrg.name
  location                 = local.resource_location
  account_tier             = "Standard"
  account_replication_type = "LRS"
  #depends_on = [ azurerm_resource_group.myrg ]
 }

#configuring storage container
 resource "azurerm_storage_container" "mycontainer" {
  storage_account_name    = azurerm_storage_account.mystorage.name
  name                  = "infracontainer"
  #depends_on = [ azurerm_storage_account.mystorage ]
} 


resource "azurerm_storage_blob" "mystorageblob" {
  name                   = "HLD-files"
  storage_account_name   = azurerm_storage_account.mystorage.name
  storage_container_name = azurerm_storage_container.mycontainer.name
  type                   = "Block"
  source                 = "sample.txt"
  depends_on = [ azurerm_storage_container.mycontainer ]
}
*/