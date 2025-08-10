from fastapi import FastAPI

app = FastAPI(title="Graph based agentic workflows")


@app.get("/status")
def health_check():
    return {"status": "healthy"}
