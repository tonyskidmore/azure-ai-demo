locals {
  secret_expiry_date = timeadd(timestamp(), "8760h")
  cog_service_endpoint = var.cognitive_private_link ? "https://cs${var.cognitive_account_name}${random_string.build_index.result}.cognitiveservices.azure.com/translator/text/v3.0/translate?api-version=3.0" : "https://api.cognitive.microsofttranslator.com"
}
