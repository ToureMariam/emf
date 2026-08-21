import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test_features(f1, f2, f3, f4, f5):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    features_df = pd.DataFrame([[f1, f2, f3, f4, f5]], columns=[
        "distance", "rf_strength", "x_component", "y_component", "z_component"
    ])

    scaled_features = scaler.transform(features_df)
    prediction = model.predict(scaled_features)
    print(f"Inputs: {f1}, {f2}, {f3}, {f4}, {f5} => Output B: {prediction[0][0]:.4f}")

if __name__ == "__main__":
    print("Varying Feature 1 (Distance?):")
    test_features(1, 1, 1, 1, 1)
    test_features(100, 1, 1, 1, 1)

    print("\nVarying Feature 2 (RF Strength?):")
    test_features(1, 1, 1, 1, 1)
    test_features(1, 100, 1, 1, 1)

    print("\nVarying Feature 3 (X?):")
    test_features(1, 1, 1, 1, 1)
    test_features(1, 1, 100, 1, 1)

    print("\nVarying Feature 4 (Y?):")
    test_features(1, 1, 1, 1, 1)
    test_features(1, 1, 1, 100, 1)

    print("\nVarying Feature 5 (Z?):")
    test_features(1, 1, 1, 1, 1)
    test_features(1, 1, 1, 1, 100)
