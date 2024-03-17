import pytest
from fastapi.testclient import TestClient

from .main import Todo, app, todos


@pytest.fixture(scope="function")
def client():
    todos.clear()  # Clear todos before each test
    with TestClient(app) as client:
        yield client


def setup_function():
    todos.clear()


buy_groceries_json = Todo(name="Buy groceries").model_dump()


def test_getTodos_whenNoTodosExist_shouldReturnEmptyList(client):
    response = client.get("/")
    assert response.status_code == 200
    assert response.json() == []


def test_createTodo_whenValidDataIsPosted_shouldCreateTodo(client):
    response = client.post("/", json=buy_groceries_json)
    assert response.status_code == 200
    assert response.json() == {"name": "Buy groceries", "completed": False}


def test_getTodo_whenTodoExists_shouldReturnTodo(client):
    client.post("/", json=buy_groceries_json)
    response = client.get("/1")
    assert response.status_code == 200
    assert response.json() == {"name": "Buy groceries", "completed": False}


def test_updateTodo_whenTodoExists_shouldUpdateTodo(client):
    client.post("/", json=buy_groceries_json)
    response = client.put("/1", json={"name": "Buy vegetables", "completed": True})
    assert response.status_code == 200
    assert response.json() == {"name": "Buy vegetables", "completed": True}


def test_deleteTodo_whenTodoExists_shouldDeleteTodo(client):
    client.post("/", json=buy_groceries_json)
    response = client.delete("/1")
    assert response.status_code == 200
    assert response.json() == {"name": "Buy groceries", "completed": False}


def test_getTodo_whenTodoDoesNotExist_shouldReturn404NotFound(client):
    response = client.get("/999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Todo not found"}


def test_updateTodo_whenTodoDoesNotExist_shouldReturn404NotFound(client):
    response = client.put("/999", json={"name": "Buy something", "completed": True})
    assert response.status_code == 404
    assert response.json() == {"detail": "Todo not found"}


def test_deleteTodo_whenTodoDoesNotExist_shouldReturn404NotFound(client):
    response = client.delete("/999")
    assert response.status_code == 404
    assert response.json() == {"detail": "Todo not found"}
