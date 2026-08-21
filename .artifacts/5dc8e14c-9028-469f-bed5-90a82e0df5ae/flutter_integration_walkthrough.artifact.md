# Walkthrough - Flutter & Backend Integration

I have successfully connected your Flutter application to the FastAPI backend. This enables the **ML Prediction** screen to use your real Random Forest model instead of static mock data.

## Changes Made

### 1. Backend Optimization
- **Dependency Pinning**: Updated [requirements.txt](file:///C:/Users/Admin/StudioProjects/EMF/Backend/requirements.txt) to match the exact versions used during model training (`scikit-learn==1.6.1`). This resolves the `InconsistentVersionWarning`.

### 2. Flutter API Service
- **[api_service.dart](file:///C:/Users/Admin/StudioProjects/EMF/lib/services/api_service.dart)**: Created a new service to handle communication with the backend.
    - It automatically detects the environment:
        - **Android Emulator**: Uses `10.0.2.2` to reach your computer's localhost.
        - **Web/iOS/Desktop**: Uses `127.0.0.1`.
    - Implemented a 10-second timeout for better user experience on slow networks.

### 3. UI Implementation
- **[prediction_screen.dart](file:///C:/Users/Admin/StudioProjects/EMF/lib/screens/prediction_screen.dart)**:
    - Added the missing `EMFMeasurement` model import.
    - Integrated `ApiService.predict` into the form submission logic.
    - Added an error dialog to inform users if the backend server is unreachable.

## How to Verify

### Step 1: Update & Restart Backend
To fix the model loading warnings, run these commands in your terminal:
```powershell
# Stop the server with CTRL+C first
pip install -r Backend/requirements.txt
uvicorn Backend.main:app --reload
```

### Step 2: Test in Flutter
1. Run your Flutter app.
2. Navigate to **ML Prediction**.
3. Fill in the fields (e.g., Distance: 25, Magnetic Flux: 0.5).
4. Tap **Predict Exposure**.
5. You should see a result card based on the model's actual prediction.

> [!TIP]
> You can verify it's working by checking your Python terminal—you will see `POST /predict 200 OK` every time you tap the button.
