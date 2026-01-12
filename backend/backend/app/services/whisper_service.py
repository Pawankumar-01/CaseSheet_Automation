import whisper
import tempfile
import os

class WhisperService:
    _model = None

    @classmethod
    def load_model(cls):
        if cls._model is None:
            cls._model = whisper.load_model("base")  # change later
        return cls._model

    @classmethod
    def transcribe(cls, audio_bytes: bytes) -> dict:
        model = cls.load_model()

        with tempfile.NamedTemporaryFile(delete=False, suffix=".wav") as f:
            f.write(audio_bytes)
            temp_path = f.name

        result = model.transcribe(temp_path)
        os.unlink(temp_path)

        return result
