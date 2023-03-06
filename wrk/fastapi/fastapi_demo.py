from fastapi import FastAPI, Response

app = FastAPI()

RESPONSE = Response(content="Hi from FastAPI!", media_type="text/plain")

@app.get("/")
async def root() -> Response:
    return RESPONSE
