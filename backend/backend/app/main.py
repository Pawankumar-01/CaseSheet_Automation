from fastapi import FastAPI
from app.api.router import api_router
from app.api.routes import facts
app = FastAPI(
    title="Clinical AI Backend",
    version="0.1.0"
)

app.include_router(api_router)

app.include_router(facts.router)


@app.get("/")
def health_check():
    return {"status": "ok"}
