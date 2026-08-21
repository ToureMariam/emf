# Implementation Plan - Multi-Model Support & Scaler Integration

Move the recently provided model metadata and scaler to the backend, integrate the scaling logic for higher prediction accuracy, and prepare the comparison framework for when the remaining models are added.

## User Review Required

> [!IMPORTANT]
> **Scaling is Critical**: I found the `scaler_20260819_232556.pkl`. Most ML models (especially SVM and KNN) require data to be scaled exactly as it was during training. Without this, the predictions will be inaccurate.
>
> **Multi-Output Mapping**: The Random Forest model predicts BOTH `magnetic_field` and `electric_field`. I will ensure the backend returns both values so the UI can show a more complete picture.

## Proposed Changes

### [Backend Enhancements]

#### [MOVE] [scaler.pkl](file:///C:/Users/Admin/StudioProjects/EMF/Backend/scaler.pkl)
- Move `scaler_20260819_232556.pkl` from Downloads to `Backend/scaler.pkl`.

#### [MOVE] [metadata.json](file:///C:/Users/Admin/StudioProjects/EMF/Backend/metadata.json)
- Move `model_metadata_20260819_232556.json` from Downloads to `Backend/metadata.json`.

#### [MODIFY] [main.py](file:///C:/Users/Admin/StudioProjects/EMF/Backend/main.py)
- Update startup logic to load the `scaler.pkl` using `joblib`.
- In the `/predict` endpoint, apply the scaler to the input features before calling `model.predict()`.
- Return the specific metrics (R2, MAE) from the metadata so the Flutter app can display the "Model Reliability."

### [Frontend Enhancements]

#### [MODIFY] [prediction_screen.dart](file:///C:/Users/Admin/StudioProjects/EMF/lib/screens/prediction_screen.dart)
- Update the UI to show the "Model R2 Score" (Accuracy) for the selected model.
- Add a placeholder for when you add the SVM, KNN, and other models so we can compare them side-by-side.

## Verification Plan

### Automated Tests
- Verify that a known input (from your training data) returns the expected output after scaling.
- Ensure the backend doesn't crash if the scaler or metadata files are missing.

### Manual Verification
- Check the "ML Prediction" screen and verify that the "Note" at the bottom now shows the R2 score from the metadata.
