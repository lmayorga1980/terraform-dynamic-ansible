# Define the HTTP provider
provider "http" {
  # Configure any necessary options for the HTTP provider
}

# Define the external data source to retrieve variables
data "http" "example" {
  #NOTE: External Data must be validated/certified in order to be used as/is
  #instead of an http resource a client program can be used to retrieve the data
  #and perform some sort of extra validation before ingestion
  url = "http://127.0.0.1:5000/dev/app123"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}

output "response" {
    value = data.http.example.response_body
}

resource "local_file" "ansible" {
  content  = yamlencode(jsondecode(data.http.example.response_body))
  filename = "${path.module}/ansible/group_vars/external.yml"
}



#TODO:
#1. Validate Response
#2. Create Ansible Variables File => application_configuration.vars.yaml
#3. CI/CD => Calls ansible and pass external variable files. Those files can be updated externally and be applied without impacting 
# terraform code variable set