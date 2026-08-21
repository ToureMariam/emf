import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test_direction():
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    means = scaler.mean_

    for i in range(5):
        # Test low vs high
        f_low = list(means)
        f_low[i] = 1.0

        f_high = list(means)
        f_high[i] = 100.0

        # Scaling
        df_low = pd.DataFrame([f_low], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
        df_high = pd.DataFrame([f_high], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])

        s_low = scaler.transform(df_low)
        s_high = scaler.transform(df_high)

        p_low = model.predict(s_low)[0][0]
        p_high = model.predict(s_high)[0][0]

        diff = p_high - p_low
        direction = "INCREASE" if diff > 0 else "DECREASE"
        print(f"Feature {i} variation (1 -> 100): Result {direction} (Diff: {diff:.6f})")

if __name__ == "__main__":
    test_direction()
