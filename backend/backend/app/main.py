from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from app.api.router import api_router

import logging
app = FastAPI(
    title="Clinical AI Backend",
    version="0.1.0"
)
app.mount("/uploads", StaticFiles(directory="app/storage/uploads"), name="uploads")


logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s | %(levelname)s | %(name)s | %(message)s",
)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # TEMP: allow all
    allow_credentials=True,
    allow_methods=["*"],  # IMPORTANT: allows OPTIONS
    allow_headers=["*"],
)

app.include_router(api_router)




@app.get("/")
def health_check():
    return {"status": "ok"}
