# Sample FastAPI Microservice 🚀

A sample python microservice built with **FastAPI** and managed with the **uv** package manager. This project serves as a starting point for building robust and scalable APIs.


---

## 🚀 Getting Started

Follow these instructions to get the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Python 3.12+
* [uv](https://github.com/astral-sh/uv) package manager

### Installation & Running Locally

1.  **Clone the repository:**
    ```bash
    git clone [https://github.com/your-username/your-repo.git](https://github.com/your-username/your-repo.git)
    cd your-repo/samples/apps/sample-app
    ```

2.  **Install dependencies and sync the environment with uv:**
    This command will create a virtual environment and install all the necessary packages from your `pyproject.toml`.
    ```bash
    uv sync
    ```

3.  **Run the application:**
    This command will start the FastAPI development server.
    ```bash
    uv run uvicorn app.main:app --reload
    ```
    The `--reload` flag will automatically restart the server when you make changes to the code.

You can now access the API documentation at [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs).

---

## 🐳 Docker

This project is fully containerized with Docker.

1.  **Navigate to the app directory:**
    ```bash
    cd samples/apps/sample-app
    ```

2.  **Build the Docker image:**
    ```bash
    docker build -t sample-app-image .
    ```

3.  **Run the Docker container:**
    ```bash
    docker run -p 8348:8000 --name sample-app-container sample-app-image
    ```
    The application will be accessible on your host machine at `http://localhost:8348`.You can now access the API documentation on your host machine at [http://localhost:8348/docs](http://localhost:8348/docs). The host port `8348` can be adjusted to your needs.

---

## 🛠️ Development

To maintain code quality and consistency, this project uses `Ruff` for formatting and linting.

### Code Formatting

To format the entire codebase, run the following command:
```bash
uv run ruff format
```

### Linting

To check for linting errors and automatically fix them, run:
```bash
uv run ruff check --fix
```



