import joblib
import pandas as pd
import os

BASE_DIR = r"C:\Users\Admin\StudioProjects\emf\Backend"
MODEL_PATH = os.path.join(BASE_DIR, "best_model_Random_Forest_20260819_232556.pkl")
SCALER_PATH = os.path.join(BASE_DIR, "scaler.pkl")

def get_b(d, load):
    model = joblib.load(MODEL_PATH)
    scaler = joblib.load(SCALER_PATH)
    f = [d, 150, load, load/2, load/2]
    df = pd.DataFrame([f], columns=["distance", "rf_strength", "x_component", "y_component", "z_component"])
    return model.predict(scaler.transform(df))[0][0]

if __name__ == "__main__":
    for load in [0.3, 0.35, 0.4]:
        print(f"\nLoad={load}:")
        for d in [5, 20, 50, 100]:
            print(f"Dist={d}m => B={get_b(d, load):.4f}")
