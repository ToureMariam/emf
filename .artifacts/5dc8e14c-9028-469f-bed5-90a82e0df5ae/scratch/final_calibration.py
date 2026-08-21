import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def get_p(d, l_idx):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    l_x = [0.10, 0.20, 0.40][l_idx]
    l_yz = [0.05, 0.10, 0.20][l_idx]
    f = [d, 150, l_x, l_yz, l_yz]
    df = pd.DataFrame([f], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    return model.predict(scaler.transform(df))[0][0]

if __name__ == "__main__":
    print("Final Calibration Check (Height 1.5m):")
    print(f"35m + Max Load: B={get_p(35, 2):.4f} {'[DANGER]' if get_p(35, 2) > 0.4 else '[SAFE]'}")
    print(f"35m + Avg Load: B={get_p(35, 1):.4f} {'[DANGER]' if get_p(35, 1) > 0.4 else '[SAFE]'}")
    print(f"35m + Off Load: B={get_p(35, 0):.4f} {'[DANGER]' if get_p(35, 0) > 0.4 else '[SAFE]'}")
