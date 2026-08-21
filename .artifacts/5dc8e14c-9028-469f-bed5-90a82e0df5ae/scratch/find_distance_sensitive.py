import joblib
import pandas as pd
import numpy as np
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def test():
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    means = scaler.mean_
    scales = scaler.scale_

    for i in range(5):
        # Test mean-2std vs mean+2std
        v_low = max(0, means[i] - 2*scales[i])
        v_high = means[i] + 2*scales[i]

        f_low = list(means)
        f_low[i] = v_low
        f_high = list(means)
        f_high[i] = v_high

        df_low = pd.DataFrame([f_low], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
        df_high = pd.DataFrame([f_high], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])

        p_low = model.predict(scaler.transform(df_low))[0][0]
        p_high = model.predict(scaler.transform(df_high))[0][0]

        diff = p_high - p_low
        print(f"Feature {i} ({v_low:.2f} -> {v_high:.2f}): Diff {diff:.6f}")

if __name__ == "__main__":
    test()
