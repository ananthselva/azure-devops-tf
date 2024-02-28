terraform {
  required_providers {
    azurerm = {
        source = "hashicorp/azurerm"
         version = "=3.90.0"
    }
    
  }
}

provider "azurerm" {
    features {     
    }

     subscription_id = "94581167-9799-4165-bc6d-2005e189b1d8"
     tenant_id = "6a0cb9b2-0371-4375-be46-be1e3cbb5a4b"
     client_id = "fe0481da-ccc3-461e-9706-9ec20b6c2bf3"
     client_secret = "ilf8Q~oW65hfBwKGhUXEH3gzL6DoSoFYen8nfaaP"
     skip_provider_registration = true

}


resource "azurerm_service_plan" "toynewstore" {
  name                = "toynewstore"
  location            = "West Europe"
  resource_group_name = "Toytest"
  sku_name  ="B1"
  os_type = "Linux"
  
}

resource "azurerm_linux_web_app" "toyservice" {
  name                  = "toyservice"
  location              = azurerm_service_plan.location
  resource_group_name   = azurerm_service_plan.resource_group_name
  app_service_plan_id   = azurerm_service_plan.toynewstore.id

  site_config {
    always_on = false
  }
}

resource "azurerm_mssql_server" "toy-sqlserver01" {
  name                         = "toy-sqlserver"
  resource_group_name          = "Toytest"
  location                     = "UK south"
  version                      = "12.0"
  administrator_login          = "Admin"
  administrator_login_password = "Admin@123"
}

resource "azurerm_mssql_database" "example" {
  name           = "Toyserver"
  server_id      = azurerm_mssql_server.toy-sqlserver01
  collation      = "SQL_Latin1_General_CP1_CI_AS"
  license_type   = "LicenseIncluded"
  max_size_gb    = 2
  sku_name       = "Basic"
   depends_on = [ azurerm_mssql_server.toy-sqlserver01 ]

}


