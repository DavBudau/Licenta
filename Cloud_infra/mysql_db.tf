resource "azurerm_mysql_server" "pwp_server_mysql" {
  name                         = "pwp-server-mysql"
  location                     = data.azurerm_resource_group.pwp_rg.location
  resource_group_name          = data.azurerm_resource_group.pwp_rg.name
  administrator_login          = var.administrator_login
  administrator_login_password = var.administrator_login_password
  version                      = "5.7"
  sku_name                     = "B_Gen4_1"
  storage_mb                   = 5120

  auto_grow_enabled                 = false
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = true
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}
resource "azurerm_mysql_database" "pwp_db"  {
  name                = "database_em"
  server_name         = azurerm_mysql_server.pwp_server_mysql.name
  resource_group_name = data.azurerm_resource_group.pwp_rg.name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}
resource "azurerm_mysql_firewall_rule" "pwp_server_firewall" {
  name                = "server_firewall"
  resource_group_name = data.azurerm_resource_group.pwp_rg.name
  server_name         = azurerm_mysql_server.pwp_server_mysql.name
  start_ip_address    = "0.0.0.0"
  end_ip_address      = "255.255.255.255"
}


