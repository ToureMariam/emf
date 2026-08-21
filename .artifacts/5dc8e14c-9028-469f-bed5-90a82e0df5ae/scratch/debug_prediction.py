import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test_prediction(distance):
    if not os.path.exists(MODEL_PATH) or not os.path.exists(SCALER_PATH):
        print("Model or Scaler not found")
        return

    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    # ["distance", "rf_strength", "x_component", "y_component", "z_component"]
    # Testing with defaults used in main.py
    feature_data = [
        distance,
        1.0, # rf_strength
        1.0, # x_component
        1.0, # y_component
        1.0  # z_component
    ]

    features_df = pd.DataFrame([feature_data], columns=[
        "distance", "rf_strength", "x_component", "y_component", "z_component"
    ])

    scaled_features = scaler.transform(features_df)
    prediction = model.predict(scaled_features)

    b_field = prediction[0][0]
    e_field = prediction[0][1]

    print(f"Distance: {distance}m")
    print(f"Predicted B-Field: {b_field:.6f} uT")
    print(f"Predicted E-Field: {e_field:.6f} V/m")
    print(f"Compliant (B <= 0.4, E <= 5000): {(b_field <= 0.4 and e_field <= 5000)}")
    print("-" * 30)

if __name__ == "__main__":
    print("Testing Predictions at various distances:")
    test_prediction(5)
    test_prediction(20)
    test_prediction(50)
    test_prediction(100)
