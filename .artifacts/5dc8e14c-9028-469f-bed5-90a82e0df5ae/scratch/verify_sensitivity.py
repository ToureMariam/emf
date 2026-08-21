import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def get_prediction(d, h, load_idx):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)

    # New Logic:
    l_x = [0.10, 0.25, 0.50][load_idx]
    l_yz = [0.05, 0.10, 0.25][load_idx]

    f = [d, h * 100.0, l_x, l_yz, l_yz]
    df = pd.DataFrame([f], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    p = model.predict(scaler.transform(df))[0][0]
    return p

if __name__ == "__main__":
    print("Verifying High-Sensitivity Mapping at 35m:")

    b_max = get_prediction(35, 1.5, 2) # Maximum-Peak
    print(f"Dist=35m, Load=Maximum-Peak => B={b_max:.4f} uT (Compliant: {b_max <= 0.4})")

    b_avg = get_prediction(35, 1.5, 1) # Average-Peak
    print(f"Dist=35m, Load=Average-Peak => B={b_avg:.4f} uT (Compliant: {b_avg <= 0.4})")

    b_off = get_prediction(35, 1.5, 0) # Off-Peak
    print(f"Dist=35m, Load=Off-Peak => B={b_off:.4f} uT (Compliant: {b_off <= 0.4})")

    print("\nVerifying boundary for Maximum-Peak:")
    for d in range(30, 61, 5):
        b = get_prediction(d, 1.5, 2)
        print(f"Dist={d}m => B={b:.4f} {'[SAFE]' if b <= 0.4 else '[DANGER]'}")
