from fastapi import FastAPI
import uvicorn

app = FastAPI(title="Sample FastAPI application")


@app.get("/status")
def health_check():
    return {"status": "healthy"}

