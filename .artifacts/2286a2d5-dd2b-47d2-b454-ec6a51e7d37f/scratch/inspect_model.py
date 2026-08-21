import joblib
import os
import pandas as pd
import numpy as np

model_path = r"C:/Users/Admin/StudioProjects/EMF/Backend/best_model_Random_Forest_20260819_232556.pkl"

if not os.path.exists(model_path):
    print(f"Model not found at {model_path}")
    exit(1)

try:
    model = joblib.load(model_path)
    print("Model loaded successfully.")
    print(f"Model type: {type(model)}")

    # Try to get feature names
    if hasattr(model, 'feature_names_in_'):
        print(f"Feature names (feature_names_in_): {model.feature_names_in_}")
    elif hasattr(model, 'n_features_in_'):
        print(f"Number of features (n_features_in_): {model.n_features_in_}")

    # Try to see what it predicts
    # If it's a classifier
    if hasattr(model, 'classes_'):
        print(f"Classes (classes_): {model.classes_}")

    # Check if it has predict_proba
    print(f"Has predict_proba: {hasattr(model, 'predict_proba')}")

    # Inspect the estimator itself if it's a wrapper or pipeline
    print(f"Model params: {model.get_params()}")

    # Try a dummy prediction if we know n_features
    if hasattr(model, 'n_features_in_'):
        n = model.n_features_in_
        dummy_input = np.zeros((1, n))
        try:
            prediction = model.predict(dummy_input)
            print(f"Dummy prediction output shape: {prediction.shape}")
            print(f"Dummy prediction output: {prediction}")
        except Exception as e:
            print(f"Dummy prediction failed: {e}")

except Exception as e:
    print(f"Error: {e}")
