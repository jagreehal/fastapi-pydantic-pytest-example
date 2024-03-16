# fastapi-pydantic-pytest-example

This is a simple example project using FastAPI with Pydantic models and pytest for testing.

## Getting Started

Follow these steps to set up and run the project:

### Prerequisites

- Python 3.x
- pipenv

### Installation

To install project dependencies, use the following command:

```bash
make install
```

This command will set up the project's virtual environment and install all required dependencies specified in the Pipfile.

## Running the Application

To run the application locally, use the following command:

```bash
make run
```

This will start the FastAPI server, allowing you to interact with the API.

## Running Tests

To run tests using pytest, execute the following command:

```bash
make test
```

This command will run all test cases defined in the project.

## Code Quality Checks

You can perform various code quality checks using the provided Makefile. Here are some useful commands:

### Linting with flake8

```bash
make lint
```

### Checking for security vulnerabilities

```bash
make check
```

### Formatting code with black

```bash
make format
```

### Checking code format without making changes

```bash
make check-format
```

### Sorting import statements with isort

```bash
make sort-imports
```

### Running all code quality checks

```bash
make quality
```

### Starting a pipenv shell

```bash
make shell
```

### Removing the pipenv environment

```bash
make clean
```

### Watching tests for changes:

```bash
make watch-tests
```
