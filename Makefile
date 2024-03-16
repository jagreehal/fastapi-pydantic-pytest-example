# Install dependencies from Pipfile
install:
	pipenv install

# Install development dependencies
install-dev:
	pipenv install --dev

# Run the application
run:
	pipenv run uvicorn app.main:app --reload --port 5000

# Run tests with pytest
test:
	pipenv run pytest

# Check the project for security vulnerabilities and PEP 508 requirements
check:
	pipenv check

# Start a pipenv shell
shell:
	pipenv shell

# Run linting with flake8
lint:
	pipenv run flake8 app/

# Remove the pipenv environment
clean:
	pipenv --rm

# Format code with black
format:
	pipenv run black app/

# Check code format with black without making changes
check-format:
	pipenv run black --check app/

# Sort import statements with isort
sort-imports:
	pipenv run isort app/

# Watch tests
watch-tests:
	pipenv run ptw

# Run all code quality checks
quality: lint check check-format

.PHONY: install install-dev run test check shell lint clean format check-format sort-imports watch-tests quality
