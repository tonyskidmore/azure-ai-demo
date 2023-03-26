locals {
  secret_expiry_date = timeadd(timestamp(), "8760h")
}