deploy:
	terraform init
	terraform plan -out tfplan
	terraform apply tfplan
	scripts/run_terraform_pipeline.sh

destroy:
	terraform init
	terraform plan -destroy -out tfplan
	terraform apply tfplan
