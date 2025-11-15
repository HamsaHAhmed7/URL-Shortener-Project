.PHONY: lint fmt validate security check

# Run all linters
lint:
	@echo "🔍 Running all linters..."
	@cd infra && terraform fmt -recursive
	@cd infra && terraform init -backend=false -upgrade
	@cd infra && terraform validate
	@cd infra && tflint --init && tflint --recursive
	@cd infra && tfsec . --minimum-severity MEDIUM
	@cd infra && checkov -d . --quiet --compact
	@echo "✅ All checks passed!"

# Just format
fmt:
	cd infra && terraform fmt -recursive

# Just validate
validate:
	cd infra && terraform init -backend=false && terraform validate

# Just security scans
security:
	cd infra && tfsec .
	cd infra && checkov -d . --quiet

# Quick check (format + validate)
check: fmt validate
	@echo "✅ Quick checks passed!"

# Full check (everything)
full: lint
