
# Example. Create dns zone in gcp
```
module "dns-zone" {
    source = "dasmeta/terraform/google//modules/dns-zone"
    version = "0.1.0"

    project_id = "your project_id here"
    name = "example.com"
    key_path = "./key.json"
}
```