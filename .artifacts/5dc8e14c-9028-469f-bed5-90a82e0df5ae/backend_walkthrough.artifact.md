# Walkthrough - EMF SafeZone Backend Implementation

I have successfully prepared the `Backend` folder to serve your Random Forest model. The backend is built using **FastAPI**, which is the industry standard for high-performance ML model serving.

## Key Components

### 1. API Infrastructure (`main.py`)
- **FastAPI Initialization**: Set up a robust REST API with a `POST /predict` endpoint.
- **Model Integration**: Implemented automatic model loading on startup using `joblib`.
- **CORS Support**: Configured Cross-Origin Resource Sharing to allow your Flutter app to communicate with the backend seamlessly.

### 2. Data Preprocessing (`utils.py`)
- Created mapping logic to convert Flutter's human-readable load conditions (e.g., "Off-Peak") into numerical features (0, 1, 2) required by the ML model.

### 3. Environment Setup (`requirements.txt`)
- Defined all necessary Python dependencies: `fastapi`, `uvicorn`, `scikit-learn`, `pandas`, and `joblib`.

## How to Run the Backend

1.  **Install Python**: Ensure you have Python 3.8+ installed.
2.  **Install Dependencies**:
    ```bash
    cd Backend
    pip install -r requirements.txt
    ```
3.  **Start the Server**:
    ```bash
    uvicorn main:app --reload
    ```
4.  **Interactive Documentation**:
    Open [http://127.0.0.1:8000/docs](http://127.0.0.1:8000/docs) in your browser to test the API directly through the Swagger UI.

> [!TIP]
> The backend is currently configured to listen on all interfaces (`0.0.0.0`) at port `8000`. If you are testing on a physical Android device, ensure the phone is on the same WiFi network and use your computer's IP address instead of `127.0.0.1` in the Flutter code.

## Next Steps
The backend is now ready. In the next phase, we can update the Flutter frontend to switch from using mock data to calling this real API.
